-- ============================================================
-- Exercices sous-requetes : scalaires, IN, EXISTS, corr
-- Niveau : ★★ a ★★★
-- Prerequis : theory/04-langage-sql/, examples/sous-requetes/
-- ============================================================

DROP TABLE IF EXISTS etudiants;
DROP TABLE IF EXISTS notes;

CREATE TABLE etudiants (
    matricule INT PRIMARY KEY,
    nom       VARCHAR(50) NOT NULL,
    programme VARCHAR(50) NOT NULL
);

CREATE TABLE notes (
    matricule INT NOT NULL,
    sigle     VARCHAR(10) NOT NULL,
    session   VARCHAR(10) NOT NULL,
    note      DECIMAL(5,2),
    FOREIGN KEY (matricule) REFERENCES etudiants(matricule)
);

INSERT INTO etudiants VALUES
(1001, 'Nguyen', 'Informatique'),
(1002, 'Martin', 'Informatique'),
(1003, 'Roy', 'Mathematiques'),
(1004, 'Tremblay', 'Physique');

INSERT INTO notes VALUES
(1001, 'IFT2821', 'A24', 86.5),
(1001, 'IFT2255', 'A24', 79.0),
(1002, 'IFT2821', 'A24', 91.0),
(1002, 'IFT2255', 'A24', 84.0),
(1003, 'MAT1900', 'A24', 88.0),
(1003, 'MAT1900', 'H25', 92.0),
(1004, 'PHY1001', 'A24', NULL);

-- ============================================================
-- EXERCICES
-- ============================================================

-- ★★ EX01 : Affichez les notes strictement superieures a la moyenne globale.


-- ★★ EX02 : Affichez les etudiants dont le matricule apparait dans la table notes
--           pour le cours IFT2821 (sous-requete IN).


-- ★★★ EX03 : Affichez les etudiants ayant au moins une note superieure
--            a 90 (sous-requete EXISTS).


-- ★★★ EX04 : Pour chaque etudiant, affichez sa meilleure note
--            (sous-requete correlee ou agr.


-- ★★★ EX05 : Affichez les etudiants dont la moyenne personnelle est
--            superieure a la moyenne de leur programme.


-- Solutions -> exercises/solutions/05-sous-requetes-solutions.sql
