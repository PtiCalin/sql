/*
  =====================================================
  Titre : Sous-requêtes avec IN et EXISTS
  Démontre : Filtrer les lignes basées sur d'autres données
  Prérequis : SELECT, WHERE, GROUP BY
  =====================================================

  Les sous-requêtes permettent d'utiliser le résultat d'une requête
  dans une autre. IN vérifie l'appartenance à un ensemble,
  EXISTS vérifie l'existence d'au moins une ligne.
*/

-- Schéma de démonstration
CREATE TABLE employes (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  departement VARCHAR(30),
  salaire INT
);

CREATE TABLE projets (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  employe_id INT
);

-- Données
INSERT INTO employes VALUES
  (1, 'Alice',   'IT',        5000),
  (2, 'Bob',     'RH',        4000),
  (3, 'Charlie', 'IT',        5500),
  (4, 'David',   'Finance',   4500),
  (5, 'Eve',     'IT',        6000),
  (6, 'Frank',   'Marketing', 4200);

INSERT INTO projets VALUES
  (1, 'ProjectA', 1),
  (2, 'ProjectB', 3),
  (3, 'ProjectC', 1),
  (4, 'ProjectD', 4),
  (5, 'ProjectE', 3);

-- =====================================================
-- EXEMPLE 1 : IN avec une sous-requête
-- =====================================================

-- Tous les employés qui travaillent sur au moins un projet
SELECT nom, departement, salaire
FROM employes
WHERE id IN (
  SELECT DISTINCT employe_id FROM projets
);
/*
Résultat :
  nom     departement  salaire
  Alice   IT           5000
  Charlie IT           5500
  David   Finance      4500

Explication :
  - La sous-requête retourne les IDs : 1, 3, 4
  - WHERE id IN (...) garde seulement les employés avec ces IDs
  - DISTINCT évite les doublons dans la sous-requête
*/

-- =====================================================
-- EXEMPLE 2 : NOT IN — L'inverse
-- =====================================================

-- Tous les employés qui ne travaillent sur AUCUN projet
SELECT nom, departement, salaire
FROM employes
WHERE id NOT IN (
  SELECT DISTINCT employe_id FROM projets
);
/*
Résultat :
  nom   departement  salaire
  Bob   RH           4000
  Eve   IT           6000
  Frank Marketing    4200

Explication : Employés dont l'ID n'est pas dans la sous-requête
*/

-- ⚠️ Piège : NULL avec NOT IN
-- Si la sous-requête contient NULL, NOT IN retourne toujours FALSE

-- Correct : Exclure les NULL
SELECT nom, departement, salaire
FROM employes
WHERE id NOT IN (
  SELECT employe_id FROM projets WHERE employe_id IS NOT NULL
);

-- =====================================================
-- EXEMPLE 3 : EXISTS — Vérifier l'existence
-- =====================================================

-- Employés qui ont au moins un projet assigné
SELECT nom, departement
FROM employes e
WHERE EXISTS (
  SELECT 1 FROM projets p WHERE p.employe_id = e.id
);
/*
Résultat :
  nom     departement
  Alice   IT
  Charlie IT
  David   Finance

Explication :
  - EXISTS retourne TRUE si la sous-requête retourne au moins une ligne
  - Le SELECT 1 est une convention (on ignore les colonnes)
  - La corrélation (p.employe_id = e.id) lie chaque employé à ses projets
*/

-- ⚠️ Piège : EXISTS ne regarde que l'existence, pas la valeur
-- EXISTS (SELECT NULL ...) retourne TRUE s'il y a une ligne

-- =====================================================
-- EXEMPLE 4 : NOT EXISTS — L'inverse
-- =====================================================

-- Employés qui n'ont AUCUN projet
SELECT nom, departement
FROM employes e
WHERE NOT EXISTS (
  SELECT 1 FROM projets p WHERE p.employe_id = e.id
);
/*
Résultat :
  nom   departement
  Bob   RH
  Eve   IT
  Frank Marketing
*/

-- =====================================================
-- EXEMPLE 5 : Comparaison IN vs EXISTS
-- =====================================================

-- Approche 1 : IN (plus lisible, simple)
SELECT nom FROM employes
WHERE id IN (SELECT employe_id FROM projets);

-- Approche 2 : EXISTS (plus flexible, souvent plus performant)
SELECT nom FROM employes e
WHERE EXISTS (SELECT 1 FROM projets p WHERE p.employe_id = e.id);

-- Les deux retournent le même résultat, mais EXISTS :
-- - S'arrête dès qu'il trouve une ligne correspondante
-- - Gère mieux les NULL
-- - Permet des jointures plus complexes

-- =====================================================
-- EXEMPLE 6 : Sous-requête dans IN avec GROUP BY
-- =====================================================

-- Tous les employés des départements qui ont au moins 2 employés
SELECT nom, departement
FROM employes
WHERE departement IN (
  SELECT departement FROM employes
  GROUP BY departement
  HAVING COUNT(*) >= 2
);
/*
Résultat :
  nom     departement
  Alice   IT
  Charlie IT
  Eve     IT

Explication :
  - La sous-requête identifie les départements : IT (3), Finance, RH, Marketing
  - Seul IT a >= 2 employés
  - WHERE departement IN retourne les employés de IT
*/

-- =====================================================
-- EXEMPLE 7 : EXISTS avec jointure complexe
-- =====================================================

-- Employés dont le salaire dépasse la moyenne de leur département
SELECT nom, departement, salaire
FROM employes e1
WHERE EXISTS (
  SELECT 1
  FROM employes e2
  WHERE e2.departement = e1.departement
  GROUP BY departement
  HAVING AVG(e2.salaire) < e1.salaire
);
/*
Résultat :
  nom     departement  salaire
  Charlie IT           5500
  Eve     IT           6000
  David   Finance      4500

Explication :
  - Pour chaque employé, on vérifie s'il existe des collègues
    dont la moyenne salariale est < son salaire
*/

-- =====================================================
-- EXEMPLE 8 : IN avec plusieurs conditions
-- =====================================================

-- Employés du département IT avec un salaire > 5000
SELECT nom, departement, salaire
FROM employes
WHERE departement = 'IT'
  AND salaire > 5000;

-- Approche alternative : IN + sous-requête
SELECT nom, departement, salaire
FROM employes
WHERE (departement, salaire) IN (
  SELECT departement, salaire FROM employes
  WHERE departement = 'IT' AND salaire > 5000
);

-- =====================================================
-- EXEMPLE 9 : Sous-requête dans WHERE avec agrégation
-- =====================================================

-- Employés avec un salaire supérieur à la moyenne globale
SELECT nom, departement, salaire
FROM employes
WHERE salaire > (
  SELECT AVG(salaire) FROM employes
);
/*
Résultat :
  nom     departement  salaire
  Alice   IT           5000
  Charlie IT           5500
  Eve     IT           6000
  David   Finance      4500

Explication :
  - Moyenne globale = (5000 + 4000 + 5500 + 4500 + 6000 + 4200) / 6 ≈ 4866.67
  - Employés avec salaire > 4866.67
*/

-- =====================================================
-- Variante : Subqueries avec LIMIT
-- =====================================================

-- Top 3 employés les mieux payés dans chaque département
-- (Cette requête utilise ROW_NUMBER, voir fonctions-fenetres/)

-- Nettoyage (optionnel)
-- DROP TABLE projets;
-- DROP TABLE employes;
