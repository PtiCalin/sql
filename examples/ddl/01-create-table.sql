/*
  =====================================================
  Titre : DDL — Créer et modifier les tables
  Démontre : CREATE TABLE, types de données, contraintes
  Prérequis : Comprendre les bases du modèle relationnel
  =====================================================

  Le DDL (Data Definition Language) crée et modifie la structure
  des bases de données. CREATE TABLE définit une table,
  les colonnes, les types de données, et les contraintes.
*/

-- =====================================================
-- EXEMPLE 1 : CREATE TABLE simple
-- =====================================================

CREATE TABLE utilisateurs (
  -- Colonne   Type de données
  id          INT,
  nom         VARCHAR(100),
  email       VARCHAR(100),
  age         INT
);

-- Types de données courants :
-- INT           : entiers (-2147483648 à 2147483647)
-- VARCHAR(n)    : chaîne de caractères, max n caractères
-- DECIMAL(p,s)  : nombres décimaux (p=précision, s=échelle)
-- DATE          : dates (YYYY-MM-DD)
-- DATETIME      : dates + heures
-- BOOLEAN       : vrai/faux

-- =====================================================
-- EXEMPLE 2 : Clés primaires et contraintes
-- =====================================================

CREATE TABLE employes (
  id          INT PRIMARY KEY,  -- Clé primaire : unique + NOT NULL
  nom         VARCHAR(100) NOT NULL,  -- NOT NULL : obligatoire
  email       VARCHAR(100) UNIQUE,    -- UNIQUE : pas de doublons
  salaire     DECIMAL(10, 2),
  date_embauche DATE,
  departement VARCHAR(50) DEFAULT 'Non assigné'  -- DEFAULT : valeur par défaut
);

-- Clé primaire : identifie uniquement chaque ligne
-- NOT NULL : la colonne ne peut pas être vide
-- UNIQUE : aucune duplication de valeur
-- DEFAULT : valeur automatique si non fournie

-- =====================================================
-- EXEMPLE 3 : Clés composées (composite primary key)
-- =====================================================

CREATE TABLE commandes (
  client_id   INT,
  numero_cmd  INT,
  date_cmd    DATE,
  montant     DECIMAL(10, 2),
  PRIMARY KEY (client_id, numero_cmd)  -- La combinaison est unique
);

-- Explication :
-- Un client peut avoir plusieurs commandes (client_id n'est pas unique)
// Une commande n°001 peut exister pour plusieurs clients
// Mais chaque (client_id, numero_cmd) est unique

-- =====================================================
-- EXEMPLE 4 : Clés étrangères (Foreign Keys)
-- =====================================================

CREATE TABLE departements (
  id    INT PRIMARY KEY,
  nom   VARCHAR(50)
);

CREATE TABLE employes_v2 (
  id              INT PRIMARY KEY,
  nom             VARCHAR(100),
  departement_id  INT,
  FOREIGN KEY (departement_id) REFERENCES departements(id)
);

-- Foreign Key :
// - Crée une relation entre deux tables
// - departement_id doit exister dans departements.id
// - Empêche les "orphelins" (employé sans département valide)
// - Ajoute une intégrité référentielle

-- =====================================================
-- EXEMPLE 5 : Contraintes de domaine (CHECK)
-- =====================================================

CREATE TABLE produits (
  id        INT PRIMARY KEY,
  nom       VARCHAR(100),
  prix      DECIMAL(10, 2),
  stock     INT,
  rating    INT,
  CHECK (prix > 0),           -- Le prix doit être positif
  CHECK (stock >= 0),         -- Le stock ne peut pas être négatif
  CHECK (rating BETWEEN 1 AND 5)  -- Rating entre 1 et 5
);

-- CHECK : valide les valeurs avant insertion/modification

-- =====================================================
-- EXEMPLE 6 : Auto-increment
-- =====================================================

CREATE TABLE articles (
  id        INT PRIMARY KEY AUTO_INCREMENT,  -- ID auto-généré
  titre     VARCHAR(200) NOT NULL,
  contenu   TEXT,
  date_creation DATETIME DEFAULT NOW()
);

-- AUTO_INCREMENT :
// - Génère automatiquement le prochain ID
// - Commence à 1, s'incrémente de 1
// - Utile pour les clés primaires

-- INSERT INTO articles (titre) VALUES ('Titre');
// Le id sera auto-assigné (1, 2, 3...)

-- =====================================================
-- EXEMPLE 7 : Types de données avancés
-- =====================================================

CREATE TABLE documents (
  id          INT PRIMARY KEY,
  titre       VARCHAR(200),

  -- Texte
  description TEXT,          -- Grands textes (jusqu'à 65535 caractères)

  -- Nombres
  pages       INT,
  poids_ko    DECIMAL(8, 2),

  -- Dates/Temps
  date_creation DATE,
  heure_modification DATETIME,

  -- Booléen
  est_publie  BOOLEAN DEFAULT FALSE,

  -- JSON (certains SGBDs)
  -- metadata    JSON,

  -- Énumération
  statut      ENUM('brouillon', 'publié', 'archivé')
);

-- ENUM : énumère les valeurs possibles
-- Si vous essayez INSERT statut = 'invalide', vous recevrez une erreur

-- =====================================================
-- EXEMPLE 8 : Comment créer une table correcte
-- =====================================================

CREATE TABLE utilisateurs_complet (
  -- Identifiant
  id          INT PRIMARY KEY AUTO_INCREMENT,

  -- Informations
  nom         VARCHAR(100) NOT NULL,
  email       VARCHAR(100) NOT NULL UNIQUE,
  phone       VARCHAR(20),

  -- Audit
  date_creation DATETIME DEFAULT NOW(),
  date_modification DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,

  -- Métadonnées
  actif       BOOLEAN DEFAULT TRUE,

  -- Intégrité
  CHECK (email LIKE '%@%.%'),  -- Email doit contenir @
  CHECK (nom != '')            -- Nom ne peut pas être vide
);

-- Bonnes pratiques :
// 1. ID primaire toujours auto-incrément
// 2. NOT NULL pour les données essentielles
// 3. UNIQUE pour les identifiants (email, username)
// 4. DEFAULT pour les valeurs logiques
// 5. CHECK pour la validation métier
// 6. Audit : date_creation et date_modification

-- =====================================================
-- EXEMPLE 9 : Index pour la performance
-- =====================================================

CREATE TABLE articles_indexed (
  id    INT PRIMARY KEY,
  titre VARCHAR(200),
  contenu TEXT,
  auteur VARCHAR(100)
);

-- Ajouter des index
CREATE INDEX idx_auteur ON articles_indexed(auteur);
CREATE INDEX idx_titre_auteur ON articles_indexed(titre, auteur);

-- INDEX :
// - Accélère les recherches WHERE
// - Ralentit les INSERT/UPDATE
// - À utiliser sur les colonnes fréquemment cherchées

-- =====================================================
-- EXEMPLE 10 : Nommage et convention
-- =====================================================

-- ❌ Mauvais nommage
CREATE TABLE T1 (
  c INT,
  n VARCHAR(50),
  d DATE
);

-- ✅ Bon nommage
CREATE TABLE utilisateurs (
  id              INT PRIMARY KEY AUTO_INCREMENT,
  nom             VARCHAR(100) NOT NULL,
  email           VARCHAR(100),
  date_creation   DATE
);

-- Conventions :
// - Tables : nom singulier ou pluriel (cohérent)
// - Colonnes : descriptif, camelCase ou snake_case
// - ID : toujours PRIMARY KEY AUTO_INCREMENT
// - Dates : date_creation, date_modification
// - Flags : est_*, a_*, has_*

-- =====================================================
-- Nettoyage
-- =====================================================

-- Pour supprimer une table :
-- DROP TABLE utilisateurs_complet;
-- DROP TABLE articles_indexed;
-- DROP TABLE employes_v2;
-- DROP TABLE departements;
-- DROP TABLE produits;
-- DROP TABLE documents;
-- DROP TABLE commandes;
-- DROP TABLE employes;
-- DROP TABLE utilisateurs;
-- DROP TABLE articles;
