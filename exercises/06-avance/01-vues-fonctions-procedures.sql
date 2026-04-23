-- ============================================================
-- Exercices SQL avance : vues, procedures, fonctions
-- Niveau : ★★ a ★★★
-- Prerequis : theory/06-sql-avance/
-- Note : syntaxe orientee MySQL/MariaDB pour procedure/fonction
-- ============================================================

DROP TABLE IF EXISTS inscriptions;
DROP TABLE IF EXISTS cours;
DROP TABLE IF EXISTS etudiants;

CREATE TABLE etudiants (
    matricule INT PRIMARY KEY,
    nom       VARCHAR(50) NOT NULL
);

CREATE TABLE cours (
    sigle VARCHAR(10) PRIMARY KEY,
    titre VARCHAR(100) NOT NULL
);

CREATE TABLE inscriptions (
    matricule INT NOT NULL,
    sigle     VARCHAR(10) NOT NULL,
    note      DECIMAL(5,2),
    PRIMARY KEY (matricule, sigle),
    FOREIGN KEY (matricule) REFERENCES etudiants(matricule),
    FOREIGN KEY (sigle) REFERENCES cours(sigle)
);

INSERT INTO etudiants VALUES
(1001, 'Nguyen'),
(1002, 'Martin'),
(1003, 'Roy');

INSERT INTO cours VALUES
('IFT2821', 'Bases de donnees'),
('IFT2255', 'Systemes d exploitation');

INSERT INTO inscriptions VALUES
(1001, 'IFT2821', 86.5),
(1001, 'IFT2255', 79.0),
(1002, 'IFT2821', 91.0),
(1003, 'IFT2255', 88.0);

-- ============================================================
-- EXERCICES
-- ============================================================

-- ★★ EX01 : Creez une vue v_notes_etudiants affichant
--           matricule, nom, sigle, note.


-- ★★ EX02 : Interrogez la vue pour afficher les lignes avec note >= 85.


-- ★★★ EX03 : Ecrivez une fonction moyenne_etudiant(p_matricule)
--            qui retourne la moyenne des notes de l'etudiant.


-- ★★★ EX04 : Ecrivez une procedure inscrire_etudiant_cours
--            qui insere une inscription (matricule, sigle, note)
--            seulement si elle n'existe pas deja.


-- ★★★ EX05 : Bonus conceptuel
--            Expliquez quand preferer une vue a une fonction,
--            et une procedure a une requete ad hoc.


-- Solutions -> exercises/solutions/06-avance-solutions.sql
