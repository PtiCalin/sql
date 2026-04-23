/*
  =====================================================
  Titre : Agrégations avancées et pièges
  Démontre : Cas limites, agrégations imbriquées, et erreurs courantes
  Prérequis : COUNT, SUM, GROUP BY, HAVING
  =====================================================

  Ce fichier explore des scénarios délicats :
  - NULL dans les agrégations
  - Agrégations imbriquées
  - DISTINCT dans les agrégations
  - Erreurs de logique courantes
*/

-- Schéma de démonstration
CREATE TABLE articles (
  id INT PRIMARY KEY,
  categorie VARCHAR(50),
  titre VARCHAR(100),
  likes INT,
  commentaires INT,
  auteur_id INT
);

-- Données (avec quelques NULL intentionnels)
INSERT INTO articles VALUES
  (1, 'Tech',      'SQL Basics',        150,  10,   101),
  (2, 'Tech',      'Databases',         200,  NULL, 101),
  (3, 'Business',  'Marketing 101',     80,   5,    102),
  (4, 'Tech',      'Performance',       NULL, 8,    103),
  (5, 'Business',  'Sales Tips',        120,  12,   102),
  (6, 'Tech',      'Advanced SQL',      180,  15,   101),
  (7, 'Science',   'Physics 101',       90,   NULL, 104),
  (8, 'Science',   'Quantum Computing', NULL, NULL, 105);

-- =====================================================
-- EXEMPLE 1 : NULL dans SUM, AVG, COUNT
-- =====================================================

-- Comment NULL affecte les agrégations
SELECT
  categorie,
  COUNT(*) AS nombre_articles,        -- Compte TOUTES les lignes
  COUNT(likes) AS articles_avec_likes, -- Compte les NON-NULL
  SUM(likes) AS total_likes,           -- NULL ignoré, pas additionné
  AVG(likes) AS moyenne_likes,         -- Calcul sur les NON-NULL uniquement
  AVG(COALESCE(likes, 0)) AS moyenne_avec_0  -- Traiter NULL comme 0
FROM articles
GROUP BY categorie;
/*
Résultat :
  categorie  nombre  articles_with  total  moyenne  moyenne_0
  Tech       3       2              530    265      176.67
  Business   2       2              200    100      100.00
  Science    2       1              90     90       45.00

Explication :
  - COUNT(*) = 3 pour Tech (y compris le NULL)
  - COUNT(likes) = 2 pour Tech (exclut le NULL)
  - SUM(likes) = 530 (150 + 200 + 180), le NULL est ignoré
  - AVG(likes) = 265 (530 / 2), pas divisé par 3
  - AVG(COALESCE(likes, 0)) = 176.67 (530 / 3), traite NULL comme 0
*/

-- ⚠️ Piège : Oublier NULL peut donner des moyennes incorrectes
-- Si tu veux traiter NULL comme 0, utilise COALESCE ou IFNULL

-- =====================================================
-- EXEMPLE 2 : DISTINCT dans les agrégations
-- =====================================================

-- Combien d'auteurs par catégorie ?
SELECT
  categorie,
  COUNT(DISTINCT auteur_id) AS nombre_auteurs_distincts,
  COUNT(auteur_id) AS nombre_articles  -- Compte les lignes, pas les auteurs
FROM articles
GROUP BY categorie;
/*
Résultat :
  categorie  nombre_auteurs_distincts  nombre_articles
  Tech       2                         3
  Business   1                         2
  Science    2                         2

Explication :
  - Tech a 3 articles (count = 3) mais seulement 2 auteurs distincts (101, 103)
  - DISTINCT élimine les doublons AVANT l'agrégation
*/

-- =====================================================
-- EXEMPLE 3 : Agrégations imbriquées (subqueries)
-- =====================================================

-- La moyenne des "moyennes de likes par auteur"
-- Approche 1 : Subquery
SELECT
  AVG(moyen_par_auteur) AS moyenne_globale
FROM (
  SELECT auteur_id, AVG(likes) AS moyen_par_auteur
  FROM articles
  WHERE likes IS NOT NULL
  GROUP BY auteur_id
) AS auteurs_stats;
/*
Résultat : moyenne_globale ≈ 182.5

Explication :
  - La subquery calcule la moyenne de likes pour chaque auteur
  - Puis on fait la moyenne de ces moyennes
  - C'est différent de AVG(likes) global !
*/

-- =====================================================
-- EXEMPLE 4 : Erreur classique — Colonne non agrégée
-- =====================================================

-- ❌ Erreur : Cette requête est invalide dans SQL strict
-- SELECT categorie, titre, COUNT(*)
-- FROM articles
-- GROUP BY categorie;
-- ❌ Pourquoi ? titre n'est pas dans GROUP BY et n'est pas agrégé

-- ✅ Correct : Ajouter titre à GROUP BY
SELECT categorie, titre, COUNT(*)
FROM articles
GROUP BY categorie, titre;

-- ✅ Ou utiliser une agrégation
SELECT categorie, MIN(titre) AS premier_titre, COUNT(*)
FROM articles
GROUP BY categorie;

-- =====================================================
-- EXEMPLE 5 : CASE dans les agrégations
-- =====================================================

-- Compter les articles "populaires" vs "peu populaires" par catégorie
SELECT
  categorie,
  COUNT(CASE WHEN likes >= 100 THEN 1 END) AS populaires,
  COUNT(CASE WHEN likes < 100 THEN 1 END) AS peu_populaires,
  COUNT(CASE WHEN likes IS NULL THEN 1 END) AS sans_likes
FROM articles
GROUP BY categorie;
/*
Résultat :
  categorie  populaires  peu_populaires  sans_likes
  Tech       3           0               1
  Business   2           0               0
  Science    0           1               1

Explication :
  - CASE permet de compter sélectivement
  - Chaque CASE crée une colonne d'agrégation distincte
*/

-- =====================================================
-- EXEMPLE 6 : HAVING avec logique complexe
-- =====================================================

-- Catégories où la moyenne de commentaires est > 5,
-- ET il y a au moins 2 articles
SELECT
  categorie,
  COUNT(*) AS nombre_articles,
  ROUND(AVG(commentaires), 2) AS moyenne_commentaires
FROM articles
WHERE commentaires IS NOT NULL  -- Exclure les NULL du calcul
GROUP BY categorie
HAVING COUNT(*) >= 2 AND AVG(commentaires) > 5
ORDER BY moyenne_commentaires DESC;
/*
Résultat :
  categorie  nombre_articles  moyenne_commentaires
  Tech       2                11.5

Explication :
  - Business : 2 articles, moyenne = (5 + 12) / 2 = 8.5 ✓
  - Tech : 2 articles, moyenne = (10 + 15) / 2 = 12.5 ✓
  - Science : 1 article avec NULL, ne passe pas le COUNT >= 2
*/

-- =====================================================
-- EXEMPLE 7 : Agrégations avec ORDER BY et LIMIT
-- =====================================================

-- Top 3 catégories par total de likes
SELECT
  categorie,
  SUM(likes) AS total_likes,
  COUNT(*) AS nombre_articles,
  ROUND(AVG(likes), 2) AS moyenne
FROM articles
WHERE likes IS NOT NULL
GROUP BY categorie
ORDER BY total_likes DESC
LIMIT 3;

-- =====================================================
-- EXEMPLE 8 : Agrégations "avant et après"
-- =====================================================

-- Comparer le nombre d'articles avant et après un certain seuil
SELECT
  COUNT(*) AS nombre_total,
  SUM(CASE WHEN likes >= 150 THEN 1 ELSE 0 END) AS au_dessus_150,
  SUM(CASE WHEN likes < 150 THEN 1 ELSE 0 END) AS en_dessous_150,
  SUM(CASE WHEN likes IS NULL THEN 1 ELSE 0 END) AS sans_data
FROM articles;
/*
Résultat :
  nombre_total  au_dessus_150  en_dessous_150  sans_data
  8             4              2               2

Explication :
  - On compte les articles dans différentes catégories simultanément
  - Chaque CASE crée une sous-agrégation
*/

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE articles;
