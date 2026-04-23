/*
  =====================================================
  Titre : Common Table Expressions (CTE) — Simples
  Démontre : Simplifier les requêtes avec WITH
  Prérequis : Sous-requêtes, GROUP BY
  =====================================================

  Une CTE (Common Table Expression) est une "variable" temporaire
  dans une requête. Elle améliore la lisibilité et peut être réutilisée
  plusieurs fois dans la même requête.
*/

-- Schéma de démonstration
CREATE TABLE departements (
  id INT PRIMARY KEY,
  nom VARCHAR(50)
);

CREATE TABLE employes (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  departement_id INT,
  salaire INT
);

-- Données
INSERT INTO departements VALUES
  (1, 'IT'),
  (2, 'HR'),
  (3, 'Sales');

INSERT INTO employes VALUES
  (1, 'Alice',   1, 6000),
  (2, 'Bob',     1, 5000),
  (3, 'Charlie', 2, 4000),
  (4, 'David',   3, 5500),
  (5, 'Eve',     1, 5500),
  (6, 'Frank',   3, 4500);

-- =====================================================
-- EXEMPLE 1 : CTE basique — Remplacer une sous-requête
-- =====================================================

-- ❌ Sans CTE : Lisibilité faible
SELECT d.nom, COUNT(e.id) AS nb_employes, AVG(e.salaire) AS salaire_moyen
FROM departements d
LEFT JOIN employes e ON d.id = e.departement_id
GROUP BY d.id, d.nom;

-- ✅ Avec CTE : Plus lisible
WITH employes_par_dept AS (
  SELECT
    departement_id,
    COUNT(*) AS nb_employes,
    AVG(salaire) AS salaire_moyen
  FROM employes
  GROUP BY departement_id
)
SELECT
  d.nom,
  ep.nb_employes,
  ep.salaire_moyen
FROM departements d
LEFT JOIN employes_par_dept ep ON d.id = ep.departement_id;

-- Avantages :
// - Chaque étape est nommée et claire
// - Plus facile à lire et modifier

-- =====================================================
-- EXEMPLE 2 : Réutiliser la CTE plusieurs fois
-- =====================================================

-- La CTE peut être utilisée plusieurs fois dans la même requête
WITH stats_employes AS (
  SELECT
    departement_id,
    COUNT(*) AS nb_employes,
    AVG(salaire) AS salaire_moyen,
    MAX(salaire) AS salaire_max,
    MIN(salaire) AS salaire_min
  FROM employes
  GROUP BY departement_id
)
SELECT
  d.nom AS departement,
  s.nb_employes,
  s.salaire_moyen,
  s.salaire_max,
  s.salaire_min,
  ROUND((s.salaire_max - s.salaire_min) * 100.0 / s.salaire_min, 2) AS ecart_pourcent
FROM departements d
LEFT JOIN stats_employes s ON d.id = s.departement_id;

-- =====================================================
-- EXEMPLE 3 : Filtrer avec une CTE
-- =====================================================

-- Les départements avec plus de 2 employés
WITH dept_filtres AS (
  SELECT
    departement_id,
    COUNT(*) AS nb_employes
  FROM employes
  GROUP BY departement_id
  HAVING COUNT(*) > 2
)
SELECT
  d.nom,
  df.nb_employes,
  (SELECT GROUP_CONCAT(nom) FROM employes WHERE departement_id = d.id) AS employes
FROM departements d
JOIN dept_filtres df ON d.id = df.departement_id;

-- =====================================================
-- EXEMPLE 4 : CTE avec CONDITIONS CASE
-- =====================================================

-- Classifier les employés par salaire (CTE)
WITH employes_classes AS (
  SELECT
    nom,
    departement_id,
    salaire,
    CASE
      WHEN salaire >= 6000 THEN 'Senior'
      WHEN salaire >= 5000 THEN 'Mid-level'
      ELSE 'Junior'
    END AS classe
  FROM employes
)
SELECT
  classe,
  COUNT(*) AS nombre,
  ROUND(AVG(salaire), 2) AS salaire_moyen
FROM employes_classes
GROUP BY classe;

/*
Résultat :
  classe    nombre  salaire_moyen
  Senior    1       6000
  Mid-level 3       5333.33
  Junior    2       4250
*/

-- =====================================================
-- EXEMPLE 5 : Multiple CTEs (enchaînées)
-- =====================================================

-- Chaque CTE s'appuie sur les précédentes
WITH employes_classes AS (
  SELECT
    id,
    nom,
    departement_id,
    salaire,
    CASE
      WHEN salaire >= 5500 THEN 'Bien payé'
      ELSE 'Peu payé'
    END AS classe
  FROM employes
),
employes_bien_payes AS (
  SELECT
    departement_id,
    COUNT(*) AS bien_payes
  FROM employes_classes
  WHERE classe = 'Bien payé'
  GROUP BY departement_id
)
SELECT
  d.nom,
  COALESCE(ebp.bien_payes, 0) AS bien_payes
FROM departements d
LEFT JOIN employes_bien_payes ebp ON d.id = ebp.departement_id;

/*
Résultat :
  nom    bien_payes
  IT     2           (Alice 6000, Eve 5500)
  HR     0
  Sales  1           (David 5500)
*/

-- =====================================================
-- EXEMPLE 6 : CTE pour simplifier la logique complexe
-- =====================================================

-- Trouver les employés gagnant plus que leurs collègues du même département
WITH salaires_dept AS (
  SELECT
    id,
    nom,
    departement_id,
    salaire,
    AVG(salaire) OVER (PARTITION BY departement_id) AS salaire_moyen_dept
  FROM employes
)
SELECT
  nom,
  departement_id,
  salaire,
  salaire_moyen_dept,
  ROUND(salaire - salaire_moyen_dept, 2) AS difference
FROM salaires_dept
WHERE salaire > salaire_moyen_dept;

/*
Résultat :
  nom     departement_id  salaire  salaire_moyen_dept  difference
  Alice   1               6000     5500                500
  David   3               5500     5000                500
  Eve     1               5500     5500                0           <- Excluded
*/

-- =====================================================
-- EXEMPLE 7 : CTE vs Sous-requête (Lisibilité)
-- =====================================================

-- ❌ Sous-requête imbriquée (difficile à lire)
SELECT d.nom, COUNT(e.id)
FROM departements d
LEFT JOIN (
  SELECT id, departement_id FROM employes
  WHERE salaire > (
    SELECT AVG(salaire) FROM employes
  )
) AS e ON d.id = e.departement_id
GROUP BY d.id, d.nom;

-- ✅ Avec CTE (plus lisible)
WITH employes_bien_payes AS (
  SELECT id, departement_id
  FROM employes
  WHERE salaire > (SELECT AVG(salaire) FROM employes)
)
SELECT d.nom, COUNT(e.id) AS bien_payes
FROM departements d
LEFT JOIN employes_bien_payes e ON d.id = e.departement_id
GROUP BY d.id, d.nom;

-- =====================================================
-- EXEMPLE 8 : CTE avec ORDER BY et LIMIT (Ranking)
-- =====================================================

-- Top 2 employés les mieux payés par département
WITH employes_ranges AS (
  SELECT
    nom,
    departement_id,
    salaire,
    ROW_NUMBER() OVER (PARTITION BY departement_id ORDER BY salaire DESC) AS rang
  FROM employes
)
SELECT nom, departement_id, salaire
FROM employes_ranges
WHERE rang <= 2;

/*
Résultat :
  nom     departement_id  salaire
  Alice   1               6000
  Eve     1               5500
  David   3               5500
  Frank   3               4500
  Charlie 2               4000
*/

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE employes;
-- DROP TABLE departements;
