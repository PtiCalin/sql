/*
  =====================================================
  Titre : Vues — Requêtes réutilisables
  Démontre : CREATE VIEW, vues simples et complexes
  Prérequis : SELECT, JOIN, GROUP BY
  =====================================================

  Une VUE est une requête stockée qui se comporte comme une table.
  Elle simplifie les requêtes complexes, cache la complexité,
  et améliore la maintenabilité et la sécurité.
*/

-- Schéma de démonstration
CREATE TABLE employes (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  salaire INT,
  departement_id INT,
  date_embauche DATE
);

CREATE TABLE departements (
  id INT PRIMARY KEY,
  nom VARCHAR(50)
);

-- Données
INSERT INTO departements VALUES (1, 'IT'), (2, 'HR');
INSERT INTO employes VALUES
  (1, 'Alice', 6000, 1, '2020-01-15'),
  (2, 'Bob', 4000, 2, '2021-03-10'),
  (3, 'Charlie', 5500, 1, '2019-07-20');

-- =====================================================
-- EXEMPLE 1 : VUE simple
-- =====================================================

-- Créer une vue qui affiche les employés avec leur département
CREATE VIEW v_employes_detail AS
SELECT
  e.id,
  e.nom,
  e.salaire,
  d.nom AS departement
FROM employes e
JOIN departements d ON e.departement_id = d.id;

-- Utiliser la vue (comme une table)
SELECT * FROM v_employes_detail;
-- Résultat :
-- id  nom      salaire  departement
-- 1   Alice    6000     IT
-- 2   Bob      4000     HR
-- 3   Charlie  5500     IT

-- Avantages :
// - Réutilisable : SELECT * FROM v_employes_detail
// - Lisible : pas besoin de réécrire la JOIN
// - Maintenable : si le schéma change, modifier seulement la vue

-- =====================================================
-- EXEMPLE 2 : VUE avec agrégations
-- =====================================================

CREATE VIEW v_salaire_par_dept AS
SELECT
  d.nom AS departement,
  COUNT(e.id) AS nombre_employes,
  AVG(e.salaire) AS salaire_moyen,
  MIN(e.salaire) AS salaire_min,
  MAX(e.salaire) AS salaire_max,
  SUM(e.salaire) AS total_salaires
FROM employes e
JOIN departements d ON e.departement_id = d.id
GROUP BY d.id, d.nom;

SELECT * FROM v_salaire_par_dept;
-- Résultat :
-- departement  nombre_employes  salaire_moyen  ...
-- IT           2                5750           ...
-- HR           1                4000           ...

-- =====================================================
-- EXEMPLE 3 : VUE avec WHERE
-- =====================================================

CREATE VIEW v_employes_bien_payes AS
SELECT
  id,
  nom,
  salaire,
  departement_id
FROM employes
WHERE salaire > 5000;

SELECT * FROM v_employes_bien_payes;
-- Résultat :
-- id  nom      salaire  departement_id
-- 1   Alice    6000     1
-- 3   Charlie  5500     1

-- =====================================================
-- EXEMPLE 4 : VUE calculée (avec expressions)
-- =====================================================

CREATE VIEW v_employes_senior AS
SELECT
  id,
  nom,
  YEAR(CURDATE()) - YEAR(date_embauche) AS annees_service,
  salaire,
  CASE
    WHEN YEAR(CURDATE()) - YEAR(date_embauche) >= 5 THEN 'Senior'
    WHEN YEAR(CURDATE()) - YEAR(date_embauche) >= 2 THEN 'Mid'
    ELSE 'Junior'
  END AS niveau
FROM employes;

SELECT * FROM v_employes_senior;
-- Résultat : affiche le niveau d'expérience

-- =====================================================
-- EXEMPLE 5 : Vues imbriquées
-- =====================================================

-- Une vue basée sur une autre vue
CREATE VIEW v_stats_dept AS
SELECT
  departement,
  nombre_employes,
  salaire_moyen,
  CASE
    WHEN nombre_employes >= 2 THEN 'Complet'
    ELSE 'Petit'
  END AS taille_dept
FROM v_salaire_par_dept;

SELECT * FROM v_stats_dept;
-- Cette vue se base sur v_salaire_par_dept

-- =====================================================
-- EXEMPLE 6 : Filtrer une vue (WHERE sur une vue)
-- =====================================================

-- Les vues peuvent être filtrées comme des tables
SELECT * FROM v_employes_detail
WHERE salaire > 5000;

SELECT * FROM v_employes_detail
WHERE departement = 'IT';

-- La vue effectue d'abord sa requête, puis le WHERE s'applique

-- =====================================================
-- EXEMPLE 7 : UPDATE via une vue (updateable views)
-- =====================================================

-- ✅ Vue "updateable" (simple)
CREATE VIEW v_employes_IT AS
SELECT id, nom, salaire
FROM employes
WHERE departement_id = 1;

-- Mettre à jour via la vue
UPDATE v_employes_IT SET salaire = 6500 WHERE id = 1;
-- Cela met à jour la table employes directement

-- ❌ Vue "NON-updateable"
-- CREATE VIEW v_employes_count AS
-- SELECT departement_id, COUNT(*) AS nombre
// FROM employes
// GROUP BY departement_id;
//
// UPDATE v_employes_count SET nombre = 10 WHERE departement_id = 1;
// ❌ ERREUR ! Impossible de mettre à jour via une agrégation

-- =====================================================
-- EXEMPLE 8 : ALTER VIEW vs DROP VIEW
-- =====================================================

-- Modifier une vue existante
ALTER VIEW v_employes_detail AS
SELECT
  e.id,
  e.nom,
  e.salaire,
  d.nom AS departement,
  YEAR(CURDATE()) - YEAR(e.date_embauche) AS annees
FROM employes e
JOIN departements d ON e.departement_id = d.id;

-- Supprimer une vue
DROP VIEW IF EXISTS v_employes_IT;

-- Si une vue dépend d'une autre, il faut les supprimer dans l'ordre
DROP VIEW IF EXISTS v_stats_dept;      -- Dépendante
DROP VIEW IF EXISTS v_salaire_par_dept; -- Indépendante

-- =====================================================
-- EXEMPLE 9 : Cas d'usage pratique — Masquer la complexité
-- =====================================================

-- Requête complexe (employés avec bonus)
-- Au lieu de :
-- SELECT e.id, e.nom, e.salaire,
//        d.nom,
//        CASE WHEN e.salaire > 5000 THEN e.salaire * 0.1 ELSE 100 END
// FROM employes e
// JOIN departements d ON e.departement_id = d.id

-- Créer une vue
CREATE VIEW v_employes_avec_bonus AS
SELECT
  e.id,
  e.nom,
  e.salaire,
  d.nom AS departement,
  CASE
    WHEN e.salaire > 5000 THEN ROUND(e.salaire * 0.1, 2)
    ELSE 100.00
  END AS bonus
FROM employes e
JOIN departements d ON e.departement_id = d.id;

-- Puis utiliser simplement
SELECT * FROM v_employes_avec_bonus;

-- =====================================================
-- EXEMPLE 10 : Sécurité via les vues
-- =====================================================

-- Créer une vue qui expose moins d'informations
-- Utile pour les rapports non-confidentiels
CREATE VIEW v_employes_public AS
SELECT
  id,
  nom,
  departement_id
  -- Note : salaire NOT inclus
FROM employes;

-- Les utilisateurs peuvent voir les noms et départements
// sans voir les salaires

-- =====================================================
-- EXEMPLE 11 : WITH CHECK OPTION (vues sécurisées)
-- =====================================================

CREATE VIEW v_employes_IT_secure AS
SELECT
  id,
  nom,
  salaire,
  departement_id
FROM employes
WHERE departement_id = 1
WITH CHECK OPTION;  -- Empêche les UPDATE qui sortiraient de la vue

-- INSERT INTO v_employes_IT_secure VALUES (4, 'David', 4000, 2);
-- ❌ ERREUR ! departement_id = 2, mais la vue exige 1

-- =====================================================
-- Nettoyage
-- =====================================================

DROP VIEW IF EXISTS v_employes_avec_bonus;
DROP VIEW IF EXISTS v_employes_public;
DROP VIEW IF EXISTS v_employes_IT_secure;
DROP VIEW IF EXISTS v_stats_dept;
DROP VIEW IF EXISTS v_salaire_par_dept;
DROP VIEW IF EXISTS v_employes_senior;
DROP VIEW IF EXISTS v_employes_bien_payes;
DROP VIEW IF EXISTS v_employes_detail;

DROP TABLE employes;
DROP TABLE departements;
