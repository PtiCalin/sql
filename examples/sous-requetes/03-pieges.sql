/*
  =====================================================
  Titre : Pièges et erreurs courantes avec sous-requêtes
  Démontre : Erreurs de logique, performance, et NULL
  Prérequis : IN, EXISTS, sous-requêtes scalaires
  =====================================================

  Ce fichier montre les erreurs les plus fréquentes
  et comment les corriger.
*/

-- Schéma de démonstration
CREATE TABLE produits (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  prix DECIMAL(10, 2),
  stock INT
);

CREATE TABLE ventes (
  id INT PRIMARY KEY,
  produit_id INT,
  quantite INT,
  montant DECIMAL(10, 2)
);

-- Données
INSERT INTO produits VALUES
  (1, 'Laptop',      1000.00, 5),
  (2, 'Souris',      25.00,   50),
  (3, 'Clavier',     75.00,   30),
  (4, 'Moniteur',    350.00,  10),
  (5, 'Casque',      NULL,    20);   -- NULL intentionnel

INSERT INTO ventes VALUES
  (1, 1, 2, 2000.00),
  (2, 2, 10, 250.00),
  (3, 1, 1, 1000.00),
  (4, 3, 5, 375.00),
  (5, NULL, 1, 50.00);  -- NULL intentionnel

-- =====================================================
-- PIÈGE 1 : NOT IN avec NULL
-- =====================================================

-- ❌ Mauvaise requête
SELECT nom FROM produits
WHERE id NOT IN (SELECT produit_id FROM ventes);
-- Résultat : Aucune ligne !
-- Raison : ventes contient NULL, et NULL NOT IN (...) = NULL (pas TRUE)

-- ✅ Correct : Exclure les NULL
SELECT nom FROM produits
WHERE id NOT IN (
  SELECT produit_id FROM ventes
  WHERE produit_id IS NOT NULL
);
-- Résultat : Casque (car id=5 n'a jamais été vendu)

-- ✅ Alternative : Utiliser NOT EXISTS (ne souffre pas de ce piège)
SELECT nom FROM produits p
WHERE NOT EXISTS (
  SELECT 1 FROM ventes v WHERE v.produit_id = p.id
);

-- =====================================================
-- PIÈGE 2 : Sous-requête retournant plusieurs lignes
-- =====================================================

-- ❌ Erreur : Sous-requête retourne plusieurs lignes
-- SELECT nom FROM produits
-- WHERE prix = (SELECT prix FROM produits WHERE stock > 20);
-- ❌ Erreur : Ambiguïté, la sous-requête retourne 2 résultats

-- ✅ Correct : Utiliser IN
SELECT nom FROM produits
WHERE prix IN (SELECT prix FROM produits WHERE stock > 20);

-- ✅ Ou ajouter LIMIT
SELECT nom FROM produits
WHERE prix = (SELECT MAX(prix) FROM produits WHERE stock > 20);

-- =====================================================
-- PIÈGE 3 : Oublier la corrélation
-- =====================================================

-- Chaque produit avec son nombre de ventes
-- ✅ Correct (avec corrélation)
SELECT
  nom,
  (SELECT COUNT(*) FROM ventes WHERE produit_id = produits.id) AS nb_ventes
FROM produits;

-- ❌ Mauvais (sans corrélation)
-- SELECT nom, (SELECT COUNT(*) FROM ventes) AS nb_ventes
-- FROM produits;
-- Retourne le TOTAL des ventes pour chaque produit (incorrect)

-- =====================================================
-- PIÈGE 4 : NULL dans les agrégations de sous-requête
-- =====================================================

-- Nombre moyen de ventes par produit
SELECT
  nom,
  (SELECT AVG(quantite) FROM ventes WHERE produit_id = produits.id) AS quantite_moyenne
FROM produits;
/*
Résultat :
  nom      quantite_moyenne
  Laptop   1.5           (2 ventes : 2, 1)
  Souris   10            (1 vente : 10)
  Clavier  5             (1 vente : 5)
  Moniteur [NULL]        (0 ventes)
  Casque   [NULL]        (NULL car montant=NULL)

Explication :
  - Moniteur : AVG() retourne NULL si aucune ligne
  - Casque : Pas de vente directe
*/

-- Traiter NULL comme 0
SELECT
  nom,
  COALESCE((SELECT AVG(quantite) FROM ventes WHERE produit_id = produits.id), 0) AS quantite_moyenne
FROM produits;

-- =====================================================
-- PIÈGE 5 : Correlated subquery très coûteuse
-- =====================================================

-- ❌ Inefficace : Une sous-requête par ligne
SELECT
  nom,
  (SELECT COUNT(*) FROM ventes WHERE produit_id = produits.id) AS nb_ventes,
  (SELECT SUM(quantite) FROM ventes WHERE produit_id = produits.id) AS total_quantite
FROM produits;
-- Cette requête exécute 10 sous-requêtes (5 produits × 2 colonnes)

-- ✅ Plus efficace : Utiliser JOIN + GROUP BY
SELECT
  p.nom,
  COUNT(v.id) AS nb_ventes,
  COALESCE(SUM(v.quantite), 0) AS total_quantite
FROM produits p
LEFT JOIN ventes v ON p.id = v.produit_id
GROUP BY p.id, p.nom;
-- Une seule passe sur les données

-- =====================================================
-- PIÈGE 6 : IN vs EXISTS — Comprendre la différence
-- =====================================================

-- Produits vendus
-- Approche 1 : IN (plus simple, mais attention aux NULL)
SELECT nom FROM produits
WHERE id IN (SELECT produit_id FROM ventes WHERE produit_id IS NOT NULL);

-- Approche 2 : EXISTS (plus flexible)
SELECT nom FROM produits p
WHERE EXISTS (SELECT 1 FROM ventes v WHERE v.produit_id = p.id);

-- Les deux retournent : Laptop, Souris, Clavier
-- Mais EXISTS est généralement plus performant pour grandes données

-- =====================================================
-- PIÈGE 7 : Logique inversée
-- =====================================================

-- ❌ Pas ce qu'on pense : Produits WITHOUT ANY vente
-- SELECT nom FROM produits
-- WHERE id NOT IN (SELECT produit_id FROM ventes);

-- ✅ Correct
SELECT nom FROM produits p
WHERE NOT EXISTS (
  SELECT 1 FROM ventes v WHERE v.produit_id = p.id
);
-- Résultat : Moniteur, Casque

-- =====================================================
-- PIÈGE 8 : Sous-requête en SELECT ne peut retourner plusieurs lignes
-- =====================================================

-- ❌ Erreur : Retourne plusieurs lignes
-- SELECT nom, (SELECT id FROM ventes WHERE produit_id = produits.id) AS vente_id
-- FROM produits;

-- ✅ Correct : Ajouter LIMIT 1 ou une agrégation
SELECT nom,
  (SELECT MAX(id) FROM ventes WHERE produit_id = produits.id) AS derniere_vente_id
FROM produits;

-- =====================================================
-- PIÈGE 9 : Performance — Quand utiliser chaque approche
-- =====================================================

-- Pour filtrer (WHERE) : EXISTS souvent plus rapide que IN
-- Pour compter : Sous-requête scalaire vs LEFT JOIN
-- Pour joindre : LEFT JOIN vs IN

-- À titre d'exemple :
-- 1. Compter efficace
SELECT p.nom, COUNT(v.id) nb_ventes
FROM produits p
LEFT JOIN ventes v ON p.id = v.produit_id
GROUP BY p.id, p.nom;

-- 2. Filtrer efficace
SELECT nom FROM produits p
WHERE EXISTS (SELECT 1 FROM ventes v WHERE v.produit_id = p.id);

-- 3. Joindre efficace
SELECT p.nom, v.montant
FROM produits p
LEFT JOIN ventes v ON p.id = v.produit_id;

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE ventes;
-- DROP TABLE produits;
