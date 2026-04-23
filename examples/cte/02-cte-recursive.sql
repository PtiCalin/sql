/*
  =====================================================
  Titre : Récursion avec CTE
  Démontre : Traiter les structures hiérarchiques
  Prérequis : CTE simples (voir 01-simple-cte.sql)
  =====================================================

  Une CTE RECURSIVE permet de traverser des structures hiérarchiques
  (arbres, graphes) : hiérarchies d'employés, listes de tâches,
  fichiers imbriqués, etc.
*/

-- Schéma de démonstration : Hiérarchie d'employés
CREATE TABLE employees_hierarchy (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  manager_id INT,
  salaire INT,
  FOREIGN KEY(manager_id) REFERENCES employees_hierarchy(id)
);

-- Données : Une hiérarchie d'employés
INSERT INTO employees_hierarchy VALUES
  (1, 'CEO',        NULL,  100000),
  (2, 'VP Sales',   1,     80000),
  (3, 'VP IT',      1,     85000),
  (4, 'Manager A',  2,     60000),
  (5, 'Manager B',  3,     65000),
  (6, 'Dev 1',      5,     50000),
  (7, 'Dev 2',      5,     50000),
  (8, 'Sales Rep',  4,     40000);

-- =====================================================
-- EXEMPLE 1 : CTE RECURSIVE basique
-- =====================================================

-- Afficher la hiérarchie complète des employés

WITH RECURSIVE org_hierarchy AS (
  -- Cas de base : commence avec le CEO (niveau 0)
  SELECT
    id,
    nom,
    manager_id,
    salaire,
    0 AS niveau,
    CAST(nom AS CHAR(100)) AS chemin
  FROM employees_hierarchy
  WHERE manager_id IS NULL  -- Le CEO n'a pas de manager

  UNION ALL

  -- Cas récursif : ajouter les employés directs de chaque manager
  SELECT
    e.id,
    e.nom,
    e.manager_id,
    e.salaire,
    oh.niveau + 1,
    CONCAT(oh.chemin, ' -> ', e.nom)
  FROM employees_hierarchy e
  JOIN org_hierarchy oh ON e.manager_id = oh.id
)
SELECT
  CONCAT(REPEAT('  ', niveau), nom) AS nom_indente,
  salaire,
  niveau,
  chemin
FROM org_hierarchy
ORDER BY chemin;

/*
Résultat :
  nom_indente           salaire  niveau  chemin
  CEO                   100000   0       CEO
    VP Sales            80000    1       CEO -> VP Sales
      Manager A         60000    2       CEO -> VP Sales -> Manager A
        Sales Rep       40000    3       CEO -> VP Sales -> Manager A -> Sales Rep
    VP IT               85000    1       CEO -> VP IT
      Manager B         65000    2       CEO -> VP IT -> Manager B
        Dev 1           50000    3       CEO -> VP IT -> Manager B -> Dev 1
        Dev 2           50000    3       CEO -> VP IT -> Manager B -> Dev 2

Explication :
  1. Cas de base (WHERE manager_id IS NULL) : trouve le CEO
  2. Cas récursif (UNION ALL + JOIN) : ajoute les subordonnés
  3. La récursion s'arrête quand il n'y a plus d'employés à ajouter
*/

-- =====================================================
-- EXEMPLE 2 : Trouver la chaîne de commande complète
-- =====================================================

-- Pour un employé, afficher tous ses supérieurs (jusqu'au CEO)
WITH RECURSIVE chain_of_command AS (
  -- Cas de base : l'employé cible
  SELECT
    id,
    nom,
    manager_id,
    1 AS niveau
  FROM employees_hierarchy
  WHERE id = 6  -- Dev 1

  UNION ALL

  -- Cas récursif : les managers du manager
  SELECT
    e.id,
    e.nom,
    e.manager_id,
    cc.niveau + 1
  FROM employees_hierarchy e
  JOIN chain_of_command cc ON cc.manager_id = e.id
)
SELECT
  CONCAT(REPEAT('  ', niveau - 1), nom) AS manager,
  niveau,
  id
FROM chain_of_command
ORDER BY niveau;

/*
Résultat : Pour Dev 1 (id=6), affiche la chaîne jusqu'au CEO
  manager              niveau
  Dev 1               1
    Manager B         2
      VP IT           3
        CEO           4
*/

-- =====================================================
-- EXEMPLE 3 : Compter les subordonnés
-- =====================================================

-- Chaque manager avec son nombre de subordonnés directs et indirects
WITH RECURSIVE subordinates AS (
  -- Cas de base : tous les employés
  SELECT
    id,
    nom,
    manager_id,
    id AS subordinate_id,
    1 AS generation
  FROM employees_hierarchy

  UNION ALL

  -- Cas récursif : trouver les subordonnés des subordonnés
  SELECT
    s.id,
    s.nom,
    s.manager_id,
    e.id AS subordinate_id,
    s.generation + 1
  FROM subordinates s
  JOIN employees_hierarchy e ON s.subordinate_id = e.manager_id
)
SELECT
  id,
  nom,
  COUNT(DISTINCT subordinate_id) - 1 AS total_subordonnes,
  COUNT(DISTINCT CASE WHEN generation = 1 THEN subordinate_id END) - 1 AS directs
FROM subordinates
GROUP BY id, nom
ORDER BY total_subordonnes DESC;

/*
Résultat :
  id  nom       total_subordonnes  directs
  1   CEO       7                  2
  3   VP IT     3                  1
  5   Manager B 2                  2
  2   VP Sales  2                  1
  4   Manager A 1                  1
  6   Dev 1     0                  0
*/

-- =====================================================
-- EXEMPLE 4 : Chemin complet vers la racine
-- =====================================================

-- Pour chaque employé, construire son chemin complet jusqu'au CEO
WITH RECURSIVE full_path AS (
  -- Cas de base : les managers (racines)
  SELECT
    id,
    nom,
    manager_id,
    CAST(nom AS CHAR(200)) AS full_path,
    0 AS level
  FROM employees_hierarchy
  WHERE manager_id IS NULL

  UNION ALL

  -- Cas récursif : ajouter les employés en descendant
  SELECT
    e.id,
    e.nom,
    e.manager_id,
    CONCAT(fp.full_path, ' -> ', e.nom),
    fp.level + 1
  FROM employees_hierarchy e
  JOIN full_path fp ON e.manager_id = fp.id
)
SELECT
  id,
  nom,
  full_path,
  level
FROM full_path
WHERE level > 0
ORDER BY level DESC, full_path;

-- =====================================================
-- EXEMPLE 5 : Limiter la profondeur de récursion
-- =====================================================

-- Afficher seulement les 3 premiers niveaux
WITH RECURSIVE limited_hierarchy AS (
  SELECT
    id,
    nom,
    manager_id,
    0 AS niveau
  FROM employees_hierarchy
  WHERE manager_id IS NULL

  UNION ALL

  SELECT
    e.id,
    e.nom,
    e.manager_id,
    lh.niveau + 1
  FROM employees_hierarchy e
  JOIN limited_hierarchy lh ON e.manager_id = lh.id
  WHERE lh.niveau < 2  -- Arrêter à la profondeur 2
)
SELECT
  CONCAT(REPEAT('  ', niveau), nom) AS nom,
  niveau
FROM limited_hierarchy
ORDER BY niveau, nom;

-- =====================================================
-- EXEMPLE 6 : Structure de fichiers
-- =====================================================

-- Schéma alternatif : Hiérarchie de fichiers
CREATE TABLE files (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  parent_id INT,
  type VARCHAR(10),
  FOREIGN KEY(parent_id) REFERENCES files(id)
);

INSERT INTO files VALUES
  (1, 'root',      NULL,   'folder'),
  (2, 'Documents', 1,      'folder'),
  (3, 'Photos',    1,      'folder'),
  (4, 'Work',      2,      'folder'),
  (5, 'Thesis.pdf', 4,     'file'),
  (6, 'Summer.jpg', 3,     'file');

-- Afficher la structure complète
WITH RECURSIVE file_tree AS (
  SELECT
    id,
    nom,
    parent_id,
    type,
    0 AS depth,
    CAST(nom AS CHAR(100)) AS chemin
  FROM files
  WHERE parent_id IS NULL

  UNION ALL

  SELECT
    f.id,
    f.nom,
    f.parent_id,
    f.type,
    ft.depth + 1,
    CONCAT(ft.chemin, '/', f.nom)
  FROM files f
  JOIN file_tree ft ON f.parent_id = ft.id
)
SELECT
  CONCAT(REPEAT('  ', depth), IF(type = 'folder', '[' || nom || ']', nom)) AS structure,
  type,
  depth
FROM file_tree
ORDER BY chemin;

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE files;
-- DROP TABLE employees_hierarchy;
