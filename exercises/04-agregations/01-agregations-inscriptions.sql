-- ============================================================
-- Exercices agregations : GROUP BY, HAVING, COUNT, AVG
-- Niveau : ★ a ★★★
-- Prerequis : theory/04-langage-sql/, examples/agregations/
-- ============================================================

DROP TABLE IF EXISTS notes;

CREATE TABLE notes (
    matricule INT NOT NULL,
    sigle     VARCHAR(10) NOT NULL,
    session   VARCHAR(10) NOT NULL,
    note      DECIMAL(5,2)
);

INSERT INTO notes VALUES
(1001, 'IFT2821', 'A24', 86.5),
(1001, 'IFT2255', 'A24', 79.0),
(1001, 'IFT2821', 'H25', 90.0),
(1002, 'IFT2821', 'A24', 91.0),
(1002, 'IFT2255', 'A24', 84.0),
(1003, 'MAT1900', 'A24', 88.0),
(1003, 'MAT1900', 'H25', 92.0),
(1004, 'PHY1001', 'A24', NULL);

-- ============================================================
-- EXERCICES
-- ============================================================

-- ★ EX01 : Nombre total d'enregistrements dans notes.


-- ★ EX02 : Nombre de notes non NULL par cours (sigle).


-- ★★ EX03 : Moyenne des notes par cours, triee par moyenne decroissante.


-- ★★ EX04 : Moyenne des notes par etudiant (matricule) pour les notes non NULL,
--           mais seulement pour les etudiants ayant au moins 2 notes.


-- ★★★ EX05 : Affichez les cours dont la moyenne est strictement superieure
--            a la moyenne globale de toutes les notes non NULL.


-- Solutions -> exercises/solutions/04-agregations-solutions.sql
