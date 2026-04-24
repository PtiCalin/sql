-- TP1 - Base de donnees Bibliotheque
-- Auteur(s) : PrenomNom1, PrenomNom2
-- SGBD cible : PostgreSQL

-- =========================================================
-- 0) Nettoyage prealable (optionnel)
-- =========================================================
DROP TABLE IF EXISTS Pret;
DROP TABLE IF EXISTS Acquisition;
DROP TABLE IF EXISTS Employe;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Document;
DROP TABLE IF EXISTS Editeur;

-- =========================================================
-- 1) Creation des tables avec contraintes
-- =========================================================
CREATE TABLE Editeur (
    No_editeur      INT PRIMARY KEY,
    Nom_editeur     VARCHAR(100) NOT NULL,
    CONSTRAINT chk_editeur_no_positif CHECK (No_editeur > 0),
    CONSTRAINT uq_editeur_nom UNIQUE (Nom_editeur)
);

CREATE TABLE Document (
    Titre_document  VARCHAR(120) PRIMARY KEY,
    Type_document   VARCHAR(40) NOT NULL,
    Langue_document VARCHAR(40) NOT NULL,
    CONSTRAINT chk_document_titre_non_vide CHECK (length(trim(Titre_document)) > 0),
    CONSTRAINT chk_document_type_valide CHECK (Type_document IN ('Livre', 'Revue', 'Media numerique')),
    CONSTRAINT chk_document_langue_valide CHECK (Langue_document IN ('Francais', 'Anglais'))
);

CREATE TABLE Section (
    Nom_section         VARCHAR(80) PRIMARY KEY,
    Numero_etage        INT NOT NULL,
    Numero_telephone    VARCHAR(10) NOT NULL,
    No_chef_equipe      INT NOT NULL,
    CONSTRAINT chk_section_nom_non_vide CHECK (length(trim(Nom_section)) > 0),
    CONSTRAINT chk_section_etage_positif CHECK (Numero_etage > 0),
    CONSTRAINT chk_section_tel_10_chiffres CHECK (Numero_telephone ~ '^[0-9]{10}$'),
    CONSTRAINT uq_section_telephone UNIQUE (Numero_telephone)
);

CREATE TABLE Employe (
    No_employe      INT PRIMARY KEY,
    Nom             VARCHAR(80) NOT NULL,
    Salaire         NUMERIC(10,2) NOT NULL,
    Nom_section     VARCHAR(80) NOT NULL,
    CONSTRAINT chk_employe_no_positif CHECK (No_employe > 0),
    CONSTRAINT chk_employe_nom_non_vide CHECK (length(trim(Nom)) > 0),
    CONSTRAINT chk_employe_salaire_min CHECK (Salaire >= 30000),
    CONSTRAINT fk_employe_section FOREIGN KEY (Nom_section)
        REFERENCES Section(Nom_section)
);

CREATE TABLE Acquisition (
    No_acquisition      INT PRIMARY KEY,
    Quantite_acquise    INT NOT NULL,
    Titre_document      VARCHAR(120) NOT NULL,
    Nom_section         VARCHAR(80) NOT NULL,
    No_editeur          INT NOT NULL,
    CONSTRAINT chk_acquisition_no_positif CHECK (No_acquisition > 0),
    CONSTRAINT chk_acquisition_quantite_positive CHECK (Quantite_acquise > 0),
    CONSTRAINT fk_acquisition_document FOREIGN KEY (Titre_document)
        REFERENCES Document(Titre_document),
    CONSTRAINT fk_acquisition_section FOREIGN KEY (Nom_section)
        REFERENCES Section(Nom_section),
    CONSTRAINT fk_acquisition_editeur FOREIGN KEY (No_editeur)
        REFERENCES Editeur(No_editeur)
);

CREATE TABLE Pret (
    No_pret             INT PRIMARY KEY,
    Quantite_pretee     INT NOT NULL,
    Titre_document      VARCHAR(120) NOT NULL,
    Nom_section         VARCHAR(80) NOT NULL,
    CONSTRAINT chk_pret_no_positif CHECK (No_pret > 0),
    CONSTRAINT chk_pret_quantite_positive CHECK (Quantite_pretee > 0),
    CONSTRAINT fk_pret_document FOREIGN KEY (Titre_document)
        REFERENCES Document(Titre_document),
    CONSTRAINT fk_pret_section FOREIGN KEY (Nom_section)
        REFERENCES Section(Nom_section)
);

-- FK circulaire ajoutee apres creation des 2 tables concernees
ALTER TABLE Section
    ADD CONSTRAINT fk_section_chef_equipe FOREIGN KEY (No_chef_equipe)
    REFERENCES Employe(No_employe);

-- =========================================================
-- 2) Insertion des donnees (annexe + ajouts necessaires)
-- =========================================================
INSERT INTO Editeur (No_editeur, Nom_editeur) VALUES
(10, 'Pearson'),
(20, 'OReilly'),
(30, 'Springer'),
(40, 'Dunod');

INSERT INTO Document (Titre_document, Type_document, Langue_document) VALUES
('Bases de donnees avancees', 'Livre', 'Francais'),
('Introduction a SQL', 'Livre', 'Francais'),
('Algorithmique', 'Livre', 'Francais'),
('Systemes distribues', 'Livre', 'Anglais');

INSERT INTO Section (Nom_section, Numero_etage, Numero_telephone, No_chef_equipe) VALUES
('Sciences', 1, '5141111111', 1),
('Lettres', 2, '5142222222', 2),
('Informatique', 3, '5143333333', 2),
('Histoire', 4, '5144444444', 2),
('Medecine', 5, '5145555555', 1),
('Arts', 6, '5146666666', 15),
('Administration', 7, '5147777777', 17);

INSERT INTO Employe (No_employe, Nom, Salaire, Nom_section) VALUES
(1, 'Tremblay', 62000, 'Sciences'),
(2, 'Gagnon', 60000, 'Lettres'),
(3, 'Roy', 65000, 'Informatique'),
(9, 'Bouchard', 58000, 'Histoire'),
(14, 'Pelletier', 70000, 'Medecine'),
(15, 'Lefebvre', 55000, 'Arts'),
(17, 'Moreau', 72000, 'Administration');

INSERT INTO Acquisition (No_acquisition, Quantite_acquise, Titre_document, Nom_section, No_editeur) VALUES
(3001, 10, 'Bases de donnees avancees', 'Informatique', 30),
(3002, 8, 'Introduction a SQL', 'Informatique', 20),
(3003, 6, 'Algorithmique', 'Sciences', 10),
-- Ajouts necessaires / presents a l'annexe
(3004, 5, 'Systemes distribues', 'Informatique', 30),
(3005, 4, 'Algorithmique', 'Sciences', 10);

INSERT INTO Pret (No_pret, Quantite_pretee, Titre_document, Nom_section) VALUES
(2005, 2, 'Bases de donnees avancees', 'Informatique'),
(2006, 1, 'Introduction a SQL', 'Informatique'),
(2007, 3, 'Algorithmique', 'Sciences'),
(2009, 1, 'Algorithmique', 'Sciences'),
(2013, 2, 'Systemes distribues', 'Informatique'),
(2014, 1, 'Introduction a SQL', 'Informatique'),
(2015, 4, 'Bases de donnees avancees', 'Informatique'),
(2019, 1, 'Algorithmique', 'Sciences'),
(2020, 1, 'Systemes distribues', 'Informatique');

-- =========================================================
-- 3) Suppressions demandees
-- =========================================================
DELETE FROM Pret
WHERE No_pret = 2005;

-- La suppression de l'employe 2 echoue : cet employe est encore reference
-- par Section.No_chef_equipe (Lettres, Informatique, Histoire).
-- Requete qui echouerait si on l'execute directement :
-- DELETE FROM Employe WHERE No_employe = 2;

-- Cette suppression reussit (employe 3 n'est pas reference comme chef d'equipe).
DELETE FROM Employe
WHERE No_employe = 3;

-- =========================================================
-- 4) Ajouter Date_pret (defaut : date du jour)
-- =========================================================
ALTER TABLE Pret
ADD COLUMN Date_pret DATE NOT NULL DEFAULT CURRENT_DATE;

-- =========================================================
-- 5) Renommer "Systemes distribues" -> "SysDistrib"
-- =========================================================
-- a) Pourquoi la requete directe ne fonctionne pas ?
--    UPDATE Document SET Titre_document = 'SysDistrib'
--    WHERE Titre_document = 'Systemes distribues';
--    Cette mise a jour echoue car Titre_document est cle primaire dans Document
--    et est referencee par des FK dans Pret et Acquisition (pas de ON UPDATE CASCADE).

-- b) Solution : retirer temporairement les FK dependantes, mettre a jour,
--    mettre a jour les tables enfants, puis recreer les FK.
ALTER TABLE Pret DROP CONSTRAINT fk_pret_document;
ALTER TABLE Acquisition DROP CONSTRAINT fk_acquisition_document;

UPDATE Document
SET Titre_document = 'SysDistrib'
WHERE Titre_document = 'Systemes distribues';

UPDATE Pret
SET Titre_document = 'SysDistrib'
WHERE Titre_document = 'Systemes distribues';

UPDATE Acquisition
SET Titre_document = 'SysDistrib'
WHERE Titre_document = 'Systemes distribues';

ALTER TABLE Pret
    ADD CONSTRAINT fk_pret_document FOREIGN KEY (Titre_document)
    REFERENCES Document(Titre_document);

ALTER TABLE Acquisition
    ADD CONSTRAINT fk_acquisition_document FOREIGN KEY (Titre_document)
    REFERENCES Document(Titre_document);

-- =========================================================
-- 6) Requetes de consultation
-- =========================================================
-- 6.1 Nombre total de documents pretes par titre + langue
SELECT
    p.Titre_document,
    d.Langue_document,
    SUM(p.Quantite_pretee) AS total_prete
FROM Pret p
JOIN Document d ON d.Titre_document = p.Titre_document
GROUP BY p.Titre_document, d.Langue_document
ORDER BY p.Titre_document;

-- 6.2 Sections n'ayant effectue aucun pret
SELECT s.Nom_section
FROM Section s
LEFT JOIN Pret p ON p.Nom_section = s.Nom_section
WHERE p.No_pret IS NULL
ORDER BY s.Nom_section;

-- 6.3 Employes d'une section ayant prete moins de 2 documents differents
SELECT e.Nom
FROM Employe e
JOIN (
    SELECT
        s.Nom_section,
        COUNT(DISTINCT p.Titre_document) AS nb_docs_differents
    FROM Section s
    LEFT JOIN Pret p ON p.Nom_section = s.Nom_section
    GROUP BY s.Nom_section
    HAVING COUNT(DISTINCT p.Titre_document) < 2
) sec_filtre
    ON sec_filtre.Nom_section = e.Nom_section
ORDER BY e.Nom;

-- =========================================================
-- 7) Mise a jour salariale
-- =========================================================
UPDATE Employe
SET Salaire = ROUND(Salaire * 1.15, 2)
WHERE Salaire < 60000;

-- =========================================================
-- 8) Suppression de tous les tableaux sans erreurs
-- =========================================================
-- On retire d'abord la FK circulaire pour eviter l'erreur de dependance croisee.
ALTER TABLE Section DROP CONSTRAINT fk_section_chef_equipe;

DROP TABLE Pret;
DROP TABLE Acquisition;
DROP TABLE Employe;
DROP TABLE Section;
DROP TABLE Document;
DROP TABLE Editeur;
