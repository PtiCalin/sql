-- ============================================================
-- Exercices jointures : etudiants, cours, inscriptions
-- Niveau : ★ a ★★★
-- Prerequis : theory/04-langage-sql/, examples/jointures/
-- ============================================================

DROP TABLE IF EXISTS inscriptions;
DROP TABLE IF EXISTS cours;
DROP TABLE IF EXISTS etudiants;

CREATE TABLE etudiants (
    matricule INT PRIMARY KEY,
    nom       VARCHAR(50) NOT NULL,
    programme VARCHAR(50) NOT NULL
);

CREATE TABLE cours (
    sigle   VARCHAR(10) PRIMARY KEY,
    titre   VARCHAR(100) NOT NULL,
    credits INT NOT NULL
);

CREATE TABLE inscriptions (
    matricule INT NOT NULL,
    sigle     VARCHAR(10) NOT NULL,
    session   VARCHAR(10) NOT NULL,
    note      DECIMAL(5,2),
    PRIMARY KEY (matricule, sigle, session),
    FOREIGN KEY (matricule) REFERENCES etudiants(matricule),
    FOREIGN KEY (sigle) REFERENCES cours(sigle)
);

INSERT INTO etudiants VALUES
(1001, 'Nguyen', 'Informatique'),
(1002, 'Martin', 'Informatique'),
(1003, 'Roy',    'Mathematiques'),
(1004, 'Tremblay', 'Physique');

INSERT INTO cours VALUES
('IFT2821', 'Bases de donnees', 3),
('IFT2255', 'Systemes d exploitation', 3),
('MAT1900', 'Calcul differentiel', 3),
('PHY1001', 'Mecanique', 3);

INSERT INTO inscriptions VALUES
(1001, 'IFT2821', 'A24', 86.5),
(1001, 'IFT2255', 'A24', 79.0),
(1002, 'IFT2821', 'A24', 91.0),
(1003, 'MAT1900', 'A24', 88.0),
(1004, 'PHY1001', 'A24', NULL);

-- ============================================================
-- EXERCICES
-- ============================================================

-- ★ EX01 : Affichez nom et programme de tous les etudiants inscrits,
--          avec le sigle de cours associe.


-- ★ EX02 : Affichez les cours (sigle, titre) avec les noms des etudiants
--          inscrits a la session A24.


-- ★★ EX03 : Affichez les etudiants qui ne sont inscrits a aucun cours.
--           (Pensez LEFT JOIN + IS NULL)


-- ★★ EX04 : Affichez tous les cours et le nombre d'inscriptions par cours,
--           en incluant les cours sans inscription.


-- ★★★ EX05 : Affichez les paires d'etudiants du meme programme
--            (auto-jointure sur etudiants), sans doublons inverses.


-- Solutions -> exercises/solutions/03-jointures-solutions.sql
