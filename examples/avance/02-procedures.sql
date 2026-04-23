/*
  =====================================================
  Titre : Procédures stockées — Code réutilisable côté serveur
  Démontre : CREATE PROCEDURE, paramètres, logique
  Prérequis : Comprendre les vues et les agrégations
  =====================================================

  Une PROCÉDURE STOCKÉE est du code SQL stocké sur le serveur.
  Elle exécute des opérations complexes, accepte des paramètres,
  et peut retourner des résultats.
*/

-- Schéma de démonstration
CREATE TABLE employes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100),
  salaire INT,
  departement VARCHAR(50)
);

INSERT INTO employes (nom, salaire, departement) VALUES
  ('Alice', 6000, 'IT'),
  ('Bob', 4000, 'HR'),
  ('Charlie', 5500, 'IT');

-- =====================================================
-- EXEMPLE 1 : Procédure simple sans paramètres
-- =====================================================

-- Créer une procédure
DELIMITER $$

CREATE PROCEDURE sp_afficher_employes()
BEGIN
  SELECT id, nom, salaire, departement
  FROM employes
  ORDER BY salaire DESC;
END$$

DELIMITER ;

-- Appeler la procédure
CALL sp_afficher_employes();

-- Notes :
// - DELIMITER $$ : change le délimiteur (;) en $$ temporairement
// - BEGIN ... END : bloc de code
// - Appel avec CALL

-- =====================================================
-- EXEMPLE 2 : Procédure avec paramètres (IN)
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_salaire_dept(IN dept_name VARCHAR(50))
BEGIN
  SELECT
    nom,
    salaire,
    departement
  FROM employes
  WHERE departement = dept_name;
END$$

DELIMITER ;

-- Appeler avec paramètre
CALL sp_salaire_dept('IT');
-- Résultat : Alice (6000), Charlie (5500)

CALL sp_salaire_dept('HR');
-- Résultat : Bob (4000)

-- =====================================================
-- EXEMPLE 3 : Procédure avec paramètre OUT (retour)
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_salaire_moyen(
  IN dept_name VARCHAR(50),
  OUT avg_salaire INT
)
BEGIN
  SELECT AVG(salaire) INTO avg_salaire
  FROM employes
  WHERE departement = dept_name;
END$$

DELIMITER ;

-- Appeler et récupérer le résultat
CALL sp_salaire_moyen('IT', @resultat);
SELECT @resultat;
-- Résultat : 5750

-- Variables user-defined (@) pour capturer OUT

-- =====================================================
-- EXEMPLE 4 : Procédure avec logique (IF)
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_augmenter_salaire(
  IN emp_id INT,
  IN pourcentage DECIMAL(5, 2)
)
BEGIN
  DECLARE ancien_salaire INT;

  SELECT salaire INTO ancien_salaire
  FROM employes
  WHERE id = emp_id;

  IF ancien_salaire IS NULL THEN
    SELECT 'Employé non trouvé' AS message;
  ELSE
    UPDATE employes
    SET salaire = salaire * (1 + pourcentage / 100)
    WHERE id = emp_id;

    SELECT CONCAT('Salaire augmenté pour ',
           (SELECT nom FROM employes WHERE id = emp_id)) AS message;
  END IF;
END$$

DELIMITER ;

-- Appeler
CALL sp_augmenter_salaire(1, 10);  -- Alice : +10%
-- Nouveau salaire : 6600

-- =====================================================
-- EXEMPLE 5 : Procédure avec boucle (LOOP)
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_doubler_salaires()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE emp_id INT;
  DECLARE emp_cursor CURSOR FOR SELECT id FROM employes;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN emp_cursor;

  boucle: LOOP
    FETCH emp_cursor INTO emp_id;
    IF done THEN LEAVE boucle; END IF;

    UPDATE employes SET salaire = salaire * 2 WHERE id = emp_id;
  END LOOP;

  CLOSE emp_cursor;

  SELECT 'Tous les salaires ont été doublés' AS message;
END$$

DELIMITER ;

-- Appeler
CALL sp_doubler_salaires();

-- Notes :
// - CURSOR : itère sur les résultats
// - LOOP : boucle infinie (LEAVE pour sortir)
// - FETCH : récupère la ligne suivante

-- =====================================================
-- EXEMPLE 6 : Procédure avec WHILE
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_count_employes(OUT total INT)
BEGIN
  DECLARE counter INT DEFAULT 0;
  DECLARE max_rows INT;

  SELECT COUNT(*) INTO max_rows FROM employes;

  WHILE counter < max_rows DO
    SET counter = counter + 1;
  END WHILE;

  SET total = counter;
END$$

DELIMITER ;

-- Appeler
CALL sp_count_employes(@total);
SELECT @total;

-- =====================================================
-- EXEMPLE 7 : Procédure avec INSERT
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_ajouter_employe(
  IN emp_nom VARCHAR(100),
  IN emp_salaire INT,
  IN emp_dept VARCHAR(50),
  OUT emp_id INT
)
BEGIN
  INSERT INTO employes (nom, salaire, departement)
  VALUES (emp_nom, emp_salaire, emp_dept);

  SET emp_id = LAST_INSERT_ID();

  SELECT CONCAT('Employé ', emp_nom, ' ajouté avec ID ', emp_id) AS message;
END$$

DELIMITER ;

-- Appeler
CALL sp_ajouter_employe('David', 5200, 'Finance', @new_id);
SELECT @new_id;

-- =====================================================
-- EXEMPLE 8 : Procédure avec exception handling
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_augmenter_salaire_safe(
  IN emp_id INT,
  IN montant INT
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SELECT 'ERREUR : Une exception s''est produite' AS message;
  END;

  IF montant < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Le montant ne peut pas être négatif';
  END IF;

  UPDATE employes
  SET salaire = salaire + montant
  WHERE id = emp_id;

  IF ROW_COUNT() = 0 THEN
    SELECT 'ERREUR : Employé non trouvé' AS message;
  ELSE
    SELECT 'Salaire mis à jour' AS message;
  END IF;
END$$

DELIMITER ;

-- Appeler
CALL sp_augmenter_salaire_safe(1, 500);  -- OK
CALL sp_augmenter_salaire_safe(999, 100); -- ERREUR

-- =====================================================
-- EXEMPLE 9 : Afficher les procédures
-- =====================================================

-- Lister toutes les procédures
SHOW PROCEDURE STATUS WHERE DB = 'current_database';

-- Voir le code source
SHOW CREATE PROCEDURE sp_afficher_employes;

-- =====================================================
-- EXEMPLE 10 : Supprimer une procédure
-- =====================================================

DROP PROCEDURE IF EXISTS sp_augmenter_salaire;
DROP PROCEDURE IF EXISTS sp_augmenter_salaire_safe;

-- =====================================================
-- Bonnes pratiques
-- =====================================================

/*
1. Nommer avec préfixe : sp_* pour les procédures
2. Documenter le but et les paramètres
3. Gérer les erreurs (exception handling)
4. Utiliser INOUT pour les paramètres modifiables
5. Retourner un OUT pour les résultats d'opération
6. Éviter la logique métier trop complexe (préférer l'app)
7. Tester avant de déployer
*/

-- =====================================================
-- Nettoyage
-- =====================================================

DROP PROCEDURE IF EXISTS sp_afficher_employes;
DROP PROCEDURE IF EXISTS sp_salaire_dept;
DROP PROCEDURE IF EXISTS sp_salaire_moyen;
DROP PROCEDURE IF EXISTS sp_doubler_salaires;
DROP PROCEDURE IF EXISTS sp_count_employes;
DROP PROCEDURE IF EXISTS sp_ajouter_employe;

DROP TABLE employes;
