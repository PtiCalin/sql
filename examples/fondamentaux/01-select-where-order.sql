-- ============================================================
-- Exemples fondamentaux : SELECT, WHERE, ORDER BY, LIMIT
-- Prérequis : theory/04-langage-sql/
-- ============================================================

-- Schéma de référence utilisé dans ces exemples :
--   ETUDIANT(matricule, nom, prenom, programme, annee_entree)
--   COURS(sigle, titre, credits, departement)
--   S_INSCRIT(matricule, sigle, note, session)

-- ------------------------------------------------------------
-- 1. SELECT de base — projection
-- ------------------------------------------------------------

-- Toutes les colonnes (à éviter en production : coûteux, fragile)
SELECT * FROM etudiant;

-- Projection explicite — toujours préférer cette forme
SELECT matricule, nom, prenom FROM etudiant;

-- Alias de colonne pour lisibilité
SELECT matricule AS id, nom AS famille, prenom AS "prénom" FROM etudiant;


-- ------------------------------------------------------------
-- 2. DISTINCT — éliminer les doublons
-- ------------------------------------------------------------

-- Sans DISTINCT : retourne toutes les lignes (avec doublons possibles)
SELECT programme FROM etudiant;

-- Avec DISTINCT : une ligne par valeur unique
SELECT DISTINCT programme FROM etudiant;

-- ⚠️ DISTINCT porte sur TOUTES les colonnes du SELECT, pas seulement la première
SELECT DISTINCT programme, annee_entree FROM etudiant;


-- ------------------------------------------------------------
-- 3. WHERE — filtrer les tuples (sélection)
-- ------------------------------------------------------------

-- Comparaisons simples
SELECT nom, prenom FROM etudiant WHERE annee_entree = 2022;
SELECT nom, prenom FROM etudiant WHERE annee_entree >= 2020;
SELECT nom, prenom FROM etudiant WHERE annee_entree BETWEEN 2019 AND 2022;

-- Opérateurs logiques
SELECT * FROM etudiant WHERE programme = 'INFO' AND annee_entree > 2020;
SELECT * FROM etudiant WHERE programme = 'INFO' OR programme = 'MATH';

-- IN : équivalent à une suite de OR (plus lisible)
SELECT * FROM etudiant WHERE programme IN ('INFO', 'MATH', 'PHYS');

-- LIKE : correspondance de motif
SELECT * FROM etudiant WHERE nom LIKE 'Mar%';    -- commence par "Mar"
SELECT * FROM etudiant WHERE nom LIKE '%son';    -- se termine par "son"
SELECT * FROM etudiant WHERE nom LIKE '_artin';  -- un caractère + "artin"

-- ⚠️ NULL ne se compare pas avec = mais avec IS NULL / IS NOT NULL
SELECT * FROM etudiant WHERE programme IS NULL;
SELECT * FROM etudiant WHERE programme IS NOT NULL;


-- ------------------------------------------------------------
-- 4. ORDER BY — trier les résultats
-- ------------------------------------------------------------

-- Tri ascendant (défaut)
SELECT nom, prenom, annee_entree FROM etudiant ORDER BY annee_entree;

-- Tri descendant
SELECT nom, prenom, annee_entree FROM etudiant ORDER BY annee_entree DESC;

-- Tri multi-critères : d'abord par programme, puis par nom
SELECT * FROM etudiant ORDER BY programme ASC, nom ASC;

-- ⚠️ L'ordre des résultats n'est garanti QUE si ORDER BY est présent.
--    Une table SQL n'a pas d'ordre naturel.


-- ------------------------------------------------------------
-- 5. LIMIT / OFFSET — pagination
-- ------------------------------------------------------------

-- Les 10 premiers étudiants inscrits
SELECT * FROM etudiant ORDER BY annee_entree LIMIT 10;

-- Page 2 : étudiants 11 à 20 (OFFSET saute les n premiers)
SELECT * FROM etudiant ORDER BY annee_entree LIMIT 10 OFFSET 10;

-- ⚠️ LIMIT sans ORDER BY retourne des résultats arbitraires et non reproductibles.
