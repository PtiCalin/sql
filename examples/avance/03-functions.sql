/*
  =====================================================
  Titre : Fonctions stockées — Retourner des valeurs
  Démontre : CREATE FUNCTION, paramètres, retour
  Prérequis : Procédures stockées
  =====================================================

  Une FONCTION STOCKÉE retourne toujours UNE VALEUR.
  Contrairement aux procédures, les fonctions peuvent être utilisées
  directement dans les SELECT.
*/

-- Schéma de démonstration
CREATE TABLE employes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(100),
  salaire INT,
  date_embauche DATE
);

INSERT INTO employes (nom, salaire, date_embauche) VALUES
  ('Alice', 6000, '2020-01-15'),
  ('Bob', 4000, '2021-03-10'),
  ('Charlie', 5500, '2019-07-20');

-- =====================================================
-- EXEMPLE 1 : Fonction simple — Retourner une valeur
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_salaire_annuel(salaire_mensuel INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE salaire_annuel INT;
  SET salaire_annuel = salaire_mensuel * 12;
  RETURN salaire_annuel;
END$$

DELIMITER ;

-- Utiliser la fonction dans un SELECT
SELECT
  nom,
  salaire,
  fn_salaire_annuel(salaire) AS salaire_annuel
FROM employes;

-- Résultat :
-- nom      salaire  salaire_annuel
-- Alice    6000     72000
-- Bob      4000     48000
-- Charlie  5500     66000

-- Notes :
// - RETURNS : le type retourné
// - DETERMINISTIC : même input = même output (optionnel mais recommandé)
// - La fonction peut être utilisée DANS les SELECT

-- =====================================================
-- EXEMPLE 2 : Fonction avec VARCHAR
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_formater_nom(nom VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  RETURN CONCAT(UPPER(LEFT(nom, 1)), LOWER(SUBSTRING(nom, 2)));
END$$

DELIMITER ;

-- Utiliser la fonction
SELECT
  nom,
  fn_formater_nom(nom) AS nom_formate
FROM employes;

-- Résultat :
-- Alice -> Alice, Bob -> Bob, Charlie -> Charlie

-- =====================================================
-- EXEMPLE 3 : Fonction retournant un booléen
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_est_bien_paye(salaire INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  IF salaire >= 5500 THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END$$

DELIMITER ;

-- Utiliser la fonction
SELECT
  nom,
  salaire,
  fn_est_bien_paye(salaire) AS bien_paye
FROM employes;

-- Résultat :
-- nom      salaire  bien_paye
-- Alice    6000     1 (TRUE)
-- Bob      4000     0 (FALSE)
-- Charlie  5500     1 (TRUE)

-- =====================================================
-- EXEMPLE 4 : Fonction avec logique complexe
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_bonus(salaire INT, anciennete_ans INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
  DECLARE bonus_pct DECIMAL(5, 2);

  IF anciennete_ans >= 5 THEN
    SET bonus_pct = 0.15;
  ELSEIF anciennete_ans >= 3 THEN
    SET bonus_pct = 0.10;
  ELSEIF anciennete_ans >= 1 THEN
    SET bonus_pct = 0.05;
  ELSE
    SET bonus_pct = 0;
  END IF;

  RETURN ROUND(salaire * bonus_pct, 2);
END$$

DELIMITER ;

-- Utiliser la fonction
SELECT
  nom,
  salaire,
  YEAR(CURDATE()) - YEAR(date_embauche) AS anciennete,
  fn_bonus(salaire, YEAR(CURDATE()) - YEAR(date_embauche)) AS bonus
FROM employes;

-- =====================================================
-- EXEMPLE 5 : Fonction qui interroge la base
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_salaire_moyen_dept(dept_sample VARCHAR(50))
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
  DECLARE moy DECIMAL(10, 2);

  SELECT AVG(salaire) INTO moy
  FROM employes e
  WHERE e.nome_dept = dept_sample;  -- Note : colonne inexistante ici

  RETURN IFNULL(moy, 0);
END$$

DELIMITER ;

-- ⚠️ Note : Cette fonction pourrait échouer si la colonne n'existe pas

-- =====================================================
-- EXEMPLE 6 : Fonction pour valider
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_email_valide(email VARCHAR(100))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  -- Email doit contenir @ et un point après
  IF email LIKE '%@%.%' THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END$$

DELIMITER ;

-- Utiliser dans un INSERT
-- INSERT INTO users (email) VALUES ('test@example.com');
-- Si fn_email_valide(email) = FALSE, créer un trigger pour rejeter

-- =====================================================
-- EXEMPLE 7 : Fonction avec CASE
-- =====================================================

DELIMITER $$

CREATE FUNCTION fn_niveau_salaire(salaire INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  RETURN CASE
    WHEN salaire > 6000 THEN 'Executive'
    WHEN salaire > 5000 THEN 'Manager'
    WHEN salaire > 4000 THEN 'Senior'
    ELSE 'Junior'
  END;
END$$

DELIMITER ;

-- Utiliser
SELECT
  nom,
  salaire,
  fn_niveau_salaire(salaire) AS niveau
FROM employes;

-- Résultat :
-- Alice    6000     Manager
-- Bob      4000     Junior
// Charlie  5500     Manager

-- =====================================================
-- EXEMPLE 8 : Fonction qui retourne plusieurs lignes (impossible)
-- =====================================================

-- ❌ Une fonction NE PEUT PAS retourner plusieurs lignes
// Pour cela, utiliser une PROCEDURE ou une VIEW

-- ✅ Mais une fonction peut retourner une agrégation
DELIMITER $$

CREATE FUNCTION fn_count_employes()
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE cnt INT;
  SELECT COUNT(*) INTO cnt FROM employes;
  RETURN cnt;
END$$

DELIMITER ;

-- Utiliser
SELECT fn_count_employes() AS nombre_employes;

-- =====================================================
-- EXEMPLE 9 : Comparer FUNCTION vs PROCEDURE
-- =====================================================

-- FUNCTION : Retourne UNE valeur, utilisable dans SELECT
-- SELECT fn_salaire_annuel(salaire) FROM employes;

-- PROCEDURE : Peut retourner plusieurs colonnes via OUT
// CALL sp_quelconque(@result1, @result2);

-- =====================================================
-- EXEMPLE 10 : Afficher et supprimer les fonctions
-- =====================================================

-- Lister toutes les fonctions
SHOW FUNCTION STATUS WHERE DB = 'current_database';

-- Voir le code source
SHOW CREATE FUNCTION fn_salaire_annuel;

-- Supprimer une fonction
DROP FUNCTION IF EXISTS fn_salaire_annuel;
DROP FUNCTION IF EXISTS fn_formater_nom;
DROP FUNCTION IF EXISTS fn_est_bien_paye;
DROP FUNCTION IF EXISTS fn_bonus;
DROP FUNCTION IF EXISTS fn_email_valide;
DROP FUNCTION IF EXISTS fn_niveau_salaire;
DROP FUNCTION IF EXISTS fn_count_employes;

-- =====================================================
-- Bonnes pratiques
-- =====================================================

/*
1. Nommer avec préfixe : fn_* pour les fonctions
2. DETERMINISTIC : si elle retourne toujours le même résultat
3. Ne pas modifier les données (sauf si nécessaire)
4. Utiliser READS SQL DATA si on interroge
5. Tester les edge cases (NULL, valeurs invalides)
6. Documenter les paramètres et le retour
7. Préférer les fonctions simples pour la performance
*/

-- =====================================================
-- Nettoyage
-- =====================================================

DROP TABLE employes;
