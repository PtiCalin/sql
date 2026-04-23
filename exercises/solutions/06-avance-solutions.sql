-- Solutions : 06-avance

-- EX01
CREATE OR REPLACE VIEW v_notes_etudiants AS
SELECT e.matricule, e.nom, i.sigle, i.note
FROM etudiants e
JOIN inscriptions i ON i.matricule = e.matricule;

-- EX02
SELECT *
FROM v_notes_etudiants
WHERE note >= 85;

-- EX03 (MySQL/MariaDB)
DELIMITER $$
CREATE FUNCTION moyenne_etudiant(p_matricule INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE v_moy DECIMAL(5,2);

    SELECT AVG(note)
      INTO v_moy
    FROM inscriptions
    WHERE matricule = p_matricule;

    RETURN v_moy;
END$$
DELIMITER ;

-- EX04 (MySQL/MariaDB)
DELIMITER $$
CREATE PROCEDURE inscrire_etudiant_cours(
    IN p_matricule INT,
    IN p_sigle VARCHAR(10),
    IN p_note DECIMAL(5,2)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM inscriptions
        WHERE matricule = p_matricule
          AND sigle = p_sigle
    ) THEN
        INSERT INTO inscriptions (matricule, sigle, note)
        VALUES (p_matricule, p_sigle, p_note);
    END IF;
END$$
DELIMITER ;

-- EX05
-- Vue : lecture simplifiee d'un jeu de donnees derive.
-- Fonction : calcul reutilisable dans SELECT.
-- Procedure : encapsule une logique de modification/transaction.
