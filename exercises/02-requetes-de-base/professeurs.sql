-- ============================================================
-- Exercices de base : SELECT, WHERE, ORDER BY
-- Niveau : ★ débutant
-- Prérequis : theory/04-langage-sql/, examples/fondamentaux/
-- ============================================================

-- Schéma disponible (voir tools/schemas/ pour le script de création) :
--
--   PROFESSEUR(matricule INT PK, nom CHAR(50), prenom CHAR(50),
--              position CHAR(50), cours CHAR(50), annee_entree INT)
--
-- Données de départ dans ce fichier (section setup ci-dessous).

-- ============================================================
-- SETUP — créer et peupler la table
-- ============================================================

DROP TABLE IF EXISTS professeurs;

CREATE TABLE professeurs (
    matricule    INT         NOT NULL PRIMARY KEY,
    nom          CHAR(50)    NOT NULL,
    prenom       CHAR(50)    NOT NULL,
    position     CHAR(50),
    cours        CHAR(50),
    annee_entree INT
);

INSERT INTO professeurs (matricule, nom, prenom, position, cours, annee_entree) VALUES
(1,  'Smith',   'John',    'Professeur',              'Mathématiques', 2010),
(2,  'Doe',     'Jane',    'Professeur agrégé',        'Physique',      2012),
(3,  'Brown',   'Charlie', 'Professeur adjoint',       'Chimie',        2015),
(4,  'Martin',  'Sophie',  'Chargé de cours',          'Informatique',  2018),
(5,  'Tremblay','Luc',     'Professeur',              'Informatique',  2009),
(6,  'Roy',     'Anne',    'Professeur agrégé',        'Mathématiques', 2014),
(7,  'Gagnon',  'Pierre',  'Professeur adjoint',       'Physique',      2020),
(8,  'Côté',    'Marie',   'Chargé de cours',          NULL,            2021),
(9,  'Lefebvre','Paul',    'Professeur',              'Chimie',        2007),
(10, 'Bouchard','Isabelle','Professeur agrégé',        'Biologie',      2016);

-- ============================================================
-- EXERCICES
-- ============================================================

-- ★ EX01 : Affichez tous les professeurs (toutes les colonnes).
-- Votre requête :


-- ★ EX02 : Affichez uniquement le nom, prénom et cours de chaque professeur.
-- Votre requête :


-- ★ EX03 : Affichez les professeurs dont le titre de position est 'Professeur'.
-- Votre requête :


-- ★ EX04 : Affichez les professeurs entrés après l'année 2014, triés par année d'entrée croissante.
-- Votre requête :


-- ★★ EX05 : Affichez les professeurs dont le cours est 'Informatique' OU 'Mathématiques'.
-- Votre requête :


-- ★★ EX06 : Affichez les professeurs dont le cours n'est PAS renseigné (valeur NULL).
-- ⚠️ Attention : comment teste-t-on le NULL en SQL ?
-- Votre requête :


-- ★★ EX07 : Affichez le nombre de positions distinctes parmi tous les professeurs.
-- Votre requête :


-- ★★ EX08 : Affichez les professeurs dont le nom commence par la lettre 'M'.
-- Votre requête :


-- ★★★ EX09 : Affichez les 3 professeurs les plus anciens (par annee_entree).
-- Votre requête :


-- ★★★ EX10 : Affichez les professeurs entrés entre 2010 et 2016 inclus,
--             triés par position puis par nom.
-- Votre requête :


-- ============================================================
-- Solutions → exercises/solutions/02-professeurs-solutions.sql
-- ============================================================
