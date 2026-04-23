# Référence syntaxe SQL

Syntaxe complète des commandes SQL les plus courantes. Les éléments entre `[ ]` sont optionnels.

---

## DDL — Définition de structure

```sql
-- Créer une table
CREATE TABLE nom_table (
    colonne1  TYPE        [NOT NULL] [DEFAULT valeur] [UNIQUE],
    colonne2  TYPE        [NOT NULL],
    ...
    [PRIMARY KEY (col1 [, col2, ...])]
    [FOREIGN KEY (col) REFERENCES autre_table(col) [ON DELETE action] [ON UPDATE action]]
    [CHECK (condition)]
);

-- Modifier une table
ALTER TABLE nom_table ADD    COLUMN  nom_col TYPE;
ALTER TABLE nom_table DROP   COLUMN  nom_col;
ALTER TABLE nom_table MODIFY COLUMN  nom_col NOUVEAU_TYPE;   -- MySQL
ALTER TABLE nom_table ALTER  COLUMN  nom_col TYPE NOUVEAU;   -- PostgreSQL
ALTER TABLE nom_table RENAME COLUMN  ancien TO nouveau;
ALTER TABLE nom_table ADD    CONSTRAINT nom CHECK (condition);

-- Supprimer une table
DROP TABLE [IF EXISTS] nom_table;

-- Vider une table (sans la supprimer)
TRUNCATE TABLE nom_table;
```

---

## DML — Manipulation des données

```sql
-- Insérer
INSERT INTO nom_table (col1, col2, ...) VALUES (val1, val2, ...);
INSERT INTO nom_table (col1, col2) SELECT col_a, col_b FROM autre;

-- Modifier
UPDATE nom_table
SET col1 = val1, col2 = val2
WHERE condition;        -- ⚠️ Sans WHERE : toutes les lignes sont modifiées

-- Supprimer
DELETE FROM nom_table
WHERE condition;        -- ⚠️ Sans WHERE : toutes les lignes sont supprimées
```

---

## DQL — Interrogation

```sql
SELECT [DISTINCT] col1 [AS alias1], col2, ...
FROM   table1 [AS alias]
    [INNER | LEFT | RIGHT | FULL OUTER] JOIN table2 ON condition
    [CROSS JOIN table3]
WHERE  condition_filtre
GROUP BY col1, col2
HAVING condition_agregat
ORDER BY col1 [ASC|DESC], col2 [ASC|DESC]
[LIMIT n [OFFSET k]];
```

### Opérateurs de condition (WHERE / HAVING)

| Opérateur | Exemple |
|-----------|---------|
| `=`, `<>`, `!=` | `age = 18`, `statut <> 'INACTIF'` |
| `<`, `<=`, `>`, `>=` | `note >= 60` |
| `BETWEEN a AND b` | `annee BETWEEN 2010 AND 2020` |
| `IN (...)` | `dept IN ('INFO', 'MATH')` |
| `NOT IN (...)` | `dept NOT IN ('PHYS')` |
| `LIKE 'motif'` | `nom LIKE 'Mar%'` — `%` = n chars, `_` = 1 char |
| `IS NULL` | `cours IS NULL` |
| `IS NOT NULL` | `cours IS NOT NULL` |
| `AND`, `OR`, `NOT` | `age > 18 AND statut = 'ACTIF'` |
| `EXISTS (sous-req)` | `WHERE EXISTS (SELECT 1 FROM ...)` |

---

## Agrégation

```sql
COUNT(*) | COUNT(col) | COUNT(DISTINCT col)
SUM(col) | AVG(col) | MIN(col) | MAX(col)

-- Règle : toute colonne dans SELECT doit être dans GROUP BY OU dans une fonction d'agrégat
SELECT dept, COUNT(*), AVG(salaire)
FROM employe
GROUP BY dept
HAVING COUNT(*) > 5;
```

---

## Sous-requêtes

```sql
-- Scalaire (retourne une valeur)
SELECT nom FROM etudiant
WHERE note = (SELECT MAX(note) FROM s_inscrit);

-- Dans IN
SELECT nom FROM etudiant
WHERE matricule IN (SELECT matricule FROM s_inscrit WHERE sigle = 'IFT2821');

-- Table dérivée (dans FROM)
SELECT dept, moy
FROM (SELECT departement AS dept, AVG(salaire) AS moy FROM employe GROUP BY departement) AS stats
WHERE moy > 50000;

-- Corrélée (référence la requête externe)
SELECT nom FROM etudiant e
WHERE EXISTS (
    SELECT 1 FROM s_inscrit si
    WHERE si.matricule = e.matricule AND si.note > 80
);
```

---

## CTE (Common Table Expressions)

```sql
WITH nom_cte AS (
    SELECT ...
),
autre_cte AS (
    SELECT ... FROM nom_cte
)
SELECT * FROM autre_cte;

-- CTE récursive
WITH RECURSIVE hierarchie AS (
    SELECT id, nom, parent_id FROM categorie WHERE parent_id IS NULL   -- cas de base
    UNION ALL
    SELECT c.id, c.nom, c.parent_id
    FROM categorie c
    JOIN hierarchie h ON c.parent_id = h.id                           -- cas récursif
)
SELECT * FROM hierarchie;
```

---

## Fonctions fenêtres (Window Functions)

```sql
fonction() OVER (
    [PARTITION BY col1, col2]
    [ORDER BY col3 [ASC|DESC]]
    [ROWS|RANGE BETWEEN ... AND ...]
)

-- Exemples
ROW_NUMBER() OVER (ORDER BY note DESC)
RANK()        OVER (PARTITION BY sigle ORDER BY note DESC)
DENSE_RANK()  OVER (PARTITION BY sigle ORDER BY note DESC)
LAG(note, 1)  OVER (PARTITION BY matricule ORDER BY session)
LEAD(note, 1) OVER (PARTITION BY matricule ORDER BY session)
SUM(note)     OVER (PARTITION BY sigle)
AVG(note)     OVER (ORDER BY session ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
```

---

## Transactions (TCL)

```sql
BEGIN;          -- ou START TRANSACTION;
    UPDATE ...;
    INSERT ...;
COMMIT;         -- valider

-- ou
ROLLBACK;       -- annuler tout depuis BEGIN

SAVEPOINT nom;          -- point de sauvegarde intermédiaire
ROLLBACK TO nom;        -- retour au savepoint
RELEASE SAVEPOINT nom;  -- supprimer le savepoint
```

---

## Objets avancés

```sql
-- Vue
CREATE [OR REPLACE] VIEW nom_vue AS SELECT ...;
DROP VIEW [IF EXISTS] nom_vue;

-- Index
CREATE [UNIQUE] INDEX nom_index ON nom_table (col1 [, col2]);
DROP INDEX nom_index;

-- Séquence (PostgreSQL)
CREATE SEQUENCE nom_seq START 1 INCREMENT 1;
SELECT nextval('nom_seq');
```
