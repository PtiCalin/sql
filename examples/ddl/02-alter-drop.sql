/*
  =====================================================
  Titre : DDL — Modifier et supprimer les structures
  Démontre : ALTER TABLE, DROP, renaming
  Prérequis : CREATE TABLE
  =====================================================

  ALTER TABLE modifie la structure d'une table existante.
  DROP supprime les tables et leurs données.
*/

-- Schéma de base pour les exemples
CREATE TABLE produits (
  id      INT PRIMARY KEY AUTO_INCREMENT,
  nom     VARCHAR(100) NOT NULL,
  prix    DECIMAL(10, 2),
  stock   INT
);

-- =====================================================
-- EXEMPLE 1 : ALTER TABLE — Ajouter une colonne
-- =====================================================

-- Ajouter une colonne à la fin
ALTER TABLE produits ADD COLUMN description TEXT;

-- Ajouter au milieu (si le moteur le supporte)
ALTER TABLE produits ADD COLUMN categorie VARCHAR(50) AFTER nom;

-- Ajouter une colonne avec contrainte
ALTER TABLE produits ADD COLUMN date_creation DATE DEFAULT CURDATE();

-- Après ALTER :
-- Ancienne structure : id, nom, prix, stock
-- Nouvelle structure : id, nom, categorie, prix, stock, description, date_creation

-- =====================================================
-- EXEMPLE 2 : ALTER TABLE — Modifier une colonne
-- =====================================================

-- Augmenter la taille du VARCHAR
ALTER TABLE produits MODIFY nom VARCHAR(200);

-- Changer le type (attention : peut causer des erreurs)
ALTER TABLE produits MODIFY prix DECIMAL(12, 3);

-- Ajouter NOT NULL (si les données le permettent)
ALTER TABLE produits MODIFY categorie VARCHAR(50) NOT NULL;

-- Changer la valeur par défaut
ALTER TABLE produits MODIFY date_creation DATE DEFAULT NOW();

-- ⚠️ MODIFY change le type/contrainte mais garde la colonne
// Utiliser CHANGE pour renommer ET modifier

-- =====================================================
-- EXEMPLE 3 : ALTER TABLE — Renommer une colonne
-- =====================================================

-- Renommer 'nom' en 'titre'
ALTER TABLE produits CHANGE nom titre VARCHAR(200);

-- Renommer 'stock' en 'quantite_stock'
ALTER TABLE produits CHANGE stock quantite_stock INT;

-- Syntaxe : CHANGE ancien_nom nouveau_nom type_donnees

-- =====================================================
-- EXEMPLE 4 : ALTER TABLE — Supprimer une colonne
-- =====================================================

-- Supprimer la colonne description
ALTER TABLE produits DROP COLUMN description;

-- Supprimer plusieurs colonnes (une à la fois)
ALTER TABLE produits DROP COLUMN categorie;

-- ⚠️ ATTENTION : La suppression est irréversible !
// Les données sont perdues. Faire une sauvegarde avant.

-- =====================================================
-- EXEMPLE 5 : ALTER TABLE — Ajouter des contraintes
-- =====================================================

-- Ajouter une clé primaire (si elle n'existe pas)
-- ALTER TABLE produits ADD PRIMARY KEY (id);
-- (Impossible : id est déjà PRIMARY KEY)

-- Ajouter une contrainte UNIQUE
ALTER TABLE produits ADD CONSTRAINT uk_titre UNIQUE (titre);

-- Ajouter une contrainte CHECK
ALTER TABLE produits ADD CONSTRAINT ck_prix CHECK (prix > 0);

-- ⚠️ Risque : Si les données existantes violent la contrainte
// ALTER TABLE échouera. Nettoyer les données d'abord.

-- =====================================================
-- EXEMPLE 6 : ALTER TABLE — Supprimer des contraintes
-- =====================================================

-- Supprimer une clé unique
ALTER TABLE produits DROP INDEX uk_titre;

-- Supprimer une contrainte (syntaxe dépend du SGBD)
-- MySQL
ALTER TABLE produits DROP CONSTRAINT ck_prix;

-- PostgreSQL
-- ALTER TABLE produits DROP CONSTRAINT ck_prix;

-- =====================================================
-- EXEMPLE 7 : ALTER TABLE — Ajouter une clé étrangère
-- =====================================================

CREATE TABLE categories (
  id   INT PRIMARY KEY AUTO_INCREMENT,
  nom  VARCHAR(50)
);

-- Ajouter une colonne
ALTER TABLE produits ADD COLUMN categorie_id INT;

-- Ajouter la contrainte FK
ALTER TABLE produits
ADD CONSTRAINT fk_categorie
FOREIGN KEY (categorie_id) REFERENCES categories(id);

-- Maintenant, categorie_id doit exister dans categories.id
// Cela force l'intégrité référentielle

-- =====================================================
-- EXEMPLE 8 : Renommer une table
-- =====================================================

-- Renommer 'produits' en 'produits_v2'
ALTER TABLE produits RENAME TO produits_v2;

-- Alternative (MySQL)
RENAME TABLE produits_v2 TO produits;

-- =====================================================
-- EXEMPLE 9 : Vider une table (DELETE vs TRUNCATE)
-- =====================================================

-- DELETE : supprime les lignes, peut avoir WHERE
DELETE FROM produits WHERE quantite_stock = 0;

-- DELETE ALL (plus lent)
DELETE FROM produits;

-- TRUNCATE : vide la table rapidement (pas de WHERE)
TRUNCATE TABLE produits;

-- Différences :
// - DELETE : plus lent, peut avoir WHERE, réinitialise AUTO_INCREMENT
// - TRUNCATE : plus rapide, pas de WHERE, réinitialise AUTO_INCREMENT souvent

-- =====================================================
-- EXEMPLE 10 : DROP TABLE — Supprimer la structure
-- =====================================================

-- Supprimer la table entièrement (structure + données)
DROP TABLE produits;

-- Vérifier que la table n'existe pas (sinon erreur)
DROP TABLE IF EXISTS produits;

-- Supprimer avec dépendances
-- Si d'autres tables ont des FK vers produits,
// il faut d'abord supprimer les enfants

-- Ordre correct :
DROP TABLE IF EXISTS commandes;  -- Dépendante de produits
DROP TABLE IF EXISTS produits;   -- Produit
DROP TABLE IF EXISTS categories; -- Indépendant

-- =====================================================
-- EXEMPLE 11 : Scénario réaliste — Évolution d'une table
-- =====================================================

-- Version 1 : Créer la table initiale
CREATE TABLE clients_v1 (
  id    INT PRIMARY KEY AUTO_INCREMENT,
  nom   VARCHAR(100),
  email VARCHAR(100)
);

-- Version 2 : Ajouter de la complexité
ALTER TABLE clients_v1 ADD COLUMN phone VARCHAR(20);
ALTER TABLE clients_v1 ADD COLUMN date_inscription DATE DEFAULT CURDATE();

-- Version 3 : Ajouter des contraintes
ALTER TABLE clients_v1 ADD CONSTRAINT uk_email UNIQUE (email);

-- Version 4 : Renommer en version finale
ALTER TABLE clients_v1 RENAME TO clients;

-- =====================================================
-- EXEMPLE 12 : Transactions dans ALTER TABLE
-- =====================================================

-- Certains SGBD supportent les transactions dans ALTER
-- Exemple (PostgreSQL) :
/*
BEGIN;
ALTER TABLE clients ADD COLUMN statut VARCHAR(20) DEFAULT 'actif';
ALTER TABLE clients ADD CONSTRAINT ck_statut CHECK (statut IN ('actif', 'inactif'));
COMMIT;

Si une ligne échoue, tout est annulé (ROLLBACK)
*/

-- =====================================================
-- Nettoyage
-- =====================================================

-- Pour tout nettoyer :
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS categories;
-- (produits a déjà été supprimé)
