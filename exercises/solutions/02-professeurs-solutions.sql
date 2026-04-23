-- ============================================================
-- Solutions : exercices professeurs (02-requetes-de-base)
-- ============================================================

-- EX01 : Tous les professeurs
SELECT * FROM professeurs;

-- EX02 : Nom, prénom, cours
SELECT nom, prenom, cours FROM professeurs;

-- EX03 : Position = 'Professeur' exactement
SELECT * FROM professeurs WHERE position = 'Professeur';

-- EX04 : Entrés après 2014, triés par année
SELECT * FROM professeurs WHERE annee_entree > 2014 ORDER BY annee_entree ASC;

-- EX05 : Cours = Informatique OU Mathématiques
SELECT * FROM professeurs WHERE cours IN ('Informatique', 'Mathématiques');
-- Équivalent : WHERE cours = 'Informatique' OR cours = 'Mathématiques'

-- EX06 : Cours non renseigné
-- ⚠️ = NULL ne fonctionne pas — il faut IS NULL
SELECT * FROM professeurs WHERE cours IS NULL;

-- EX07 : Nombre de positions distinctes
SELECT COUNT(DISTINCT position) AS nb_positions FROM professeurs;

-- EX08 : Nom commençant par 'M'
SELECT * FROM professeurs WHERE nom LIKE 'M%';

-- EX09 : 3 professeurs les plus anciens
SELECT * FROM professeurs ORDER BY annee_entree ASC LIMIT 3;

-- EX10 : Entrés entre 2010 et 2016, triés par position puis nom
SELECT * FROM professeurs
WHERE annee_entree BETWEEN 2010 AND 2016
ORDER BY position ASC, nom ASC;
