# Cheat Sheet : SQL en 2 pages

## Struktur générale d'une requête

```sql
SELECT    col1, col2, COUNT(*) AS nb      -- Projection (étape 5)
FROM      table1                          -- Source (étape 1)
JOIN      table2 ON table1.id = table2.id -- Jointure (étape 1)
WHERE     condition                       -- Filtre avant agrégat (étape 2)
GROUP BY  col1, col2                      -- Regroupement (étape 3)
HAVING    COUNT(*) > 5                    -- Filtre après agrégat (étape 4)
ORDER BY  col1 DESC, col2 ASC             -- Tri (étape 6)
LIMIT     10 OFFSET 20;                   -- Pagination (étape 7)
```

## Ordre d'exécution (IMPORTANT)

1. FROM + JOIN
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
7. LIMIT

→ **Alias du SELECT n'existe que en ORDER BY/LIMIT, pas dans WHERE/HAVING!**

---

## Les 10 opérateurs les plus utilisés

| Opérateur | Syntaxe | Exemple |
|-----------|---------|---------|
| `=` | Égal | `WHERE age = 18` |
| `<>` / `!=` | Pas égal | `WHERE dept <> 'INFO'` |
| `IN` | Appartient à liste | `WHERE programme IN ('INFO', 'MATH')` |
| `BETWEEN` | Entre deux valeurs | `WHERE annee BETWEEN 2010 AND 2020` |
| `LIKE` | Correspondance texte | `WHERE nom LIKE 'Mar%'` |
| `IS NULL` | Valeur manquante | `WHERE cours IS NULL` |
| `AND` / `OR` | Logique | `WHERE age > 18 AND statut = 'ACTIF'` |
| `>` / `<` / `>=` / `<=` | Comparaison | `WHERE salaire >= 40000` |
| `NOT` | Négation | `WHERE NOT programme = 'PHYS'` |
| `EXISTS` | Sous-requête | `WHERE EXISTS (SELECT 1 FROM ...)` |

---

## Fonctions d'agrégat (GROUP BY)

```sql
SELECT departement, COUNT(*), AVG(salaire), MAX(salaire)
FROM employe
GROUP BY departement
HAVING COUNT(*) > 5;  -- Filtre SUR l'agrégat
```

| Fonction | Résultat |
|----------|----------|
| `COUNT(*)` | Nombre de lignes |
| `COUNT(DISTINCT col)` | Nombre de valeurs uniques |
| `SUM(col)` | Somme |
| `AVG(col)` | Moyenne |
| `MIN(col)` / `MAX(col)` | Min/Max |
| `STDDEV(col)` | Écart-type |

---

## Jointures (les 4 essentielles)

```sql
-- INNER : intersection (défaut)
FROM t1 JOIN t2 ON t1.id = t2.id

-- LEFT : tous de t1 + correspondances
FROM t1 LEFT JOIN t2 ON t1.id = t2.id

-- RIGHT : tous de t2 + correspondances
FROM t1 RIGHT JOIN t2 ON t1.id = t2.id

-- FULL OUTER : tous des deux (PostgreSQL; MySQL → UNION LEFT+RIGHT)
FROM t1 FULL OUTER JOIN t2 ON t1.id = t2.id
```

---

## Sous-requêtes en 4 formes

### 1. Scalaire (une valeur)
```sql
WHERE note = (SELECT MAX(note) FROM s_inscrit)
```

### 2. Dans IN
```sql
WHERE matricule IN (SELECT matricule FROM s_inscrit WHERE note > 80)
```

### 3. Table dérivée (FROM)
```sql
SELECT dept, moy
FROM (SELECT dept, AVG(salaire) AS moy FROM emp GROUP BY dept) t
WHERE moy > 50000
```

### 4. Corrélée (référence externe)
```sql
SELECT nom FROM etudiant e
WHERE EXISTS (SELECT 1 FROM s_inscrit WHERE matricule = e.matricule)
```

---

## CTE (WITH)

```sql
WITH top_depts AS (
    SELECT dept, SUM(salaire) AS total
    FROM employe
    GROUP BY dept
    ORDER BY total DESC
    LIMIT 5
)
SELECT * FROM top_depts;
```

---

## Cas spéciaux

### NULL (ne pas oublier !)

```sql
-- ❌ FAUX : NULL = NULL retourne NULL, pas TRUE
WHERE col = NULL  ✗

-- ✅ VRAI
WHERE col IS NULL       ✓
WHERE col IS NOT NULL   ✓
```

### DISTINCT (sur toutes les colonnes du SELECT)

```sql
-- Retourne paires uniques (dept, year)
SELECT DISTINCT dept, annee FROM employe

-- Pour déduire les doublons
SELECT col1, COUNT(*) AS nb
FROM table
GROUP BY col1
HAVING COUNT(*) > 1
```

### LIMIT / OFFSET (pagination)

```sql
-- 10 premiers
LIMIT 10

-- Sauter 20, prendre 10 (page 3 si 10 par page)
LIMIT 10 OFFSET 20

-- ⚠️ LIMIT sans ORDER BY = résultats aléatoires
ORDER BY id LIMIT 10  ✓
```

### CASE (if/then/else)

```sql
SELECT nom,
       CASE
           WHEN note >= 90 THEN 'A'
           WHEN note >= 80 THEN 'B'
           WHEN note >= 70 THEN 'C'
           ELSE 'F'
       END AS grade
FROM notes
```

---

## Les 5 erreurs qui coûtent des points

| Erreur | Exemple | Correction |
|--------|---------|-----------|
| NULL comparé avec `=` | `WHERE dept = NULL` | `WHERE dept IS NULL` |
| Alias du SELECT dans WHERE | `SELECT ... AS total WHERE total > 100` | Répéter l'expression |
| Oublier ON dans JOIN | `FROM t1 JOIN t2` | `FROM t1 JOIN t2 ON ...` |
| WHERE au lieu de HAVING | `WHERE COUNT(*) > 5` (agrégat) | `HAVING COUNT(*) > 5` |
| DISTINCT sur une colonne seule | `SELECT DISTINCT id, nom` | `SELECT DISTINCT id` OU implémenter la logique |

---

## Syntaxe DDL rapide

```sql
-- Table
CREATE TABLE nom (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    dept_id INT FOREIGN KEY REFERENCES dept(id)
)

-- Alter
ALTER TABLE nom ADD COLUMN email VARCHAR(255)
ALTER TABLE nom DROP COLUMN email
ALTER TABLE nom MODIFY COLUMN nom VARCHAR(200)

-- Supprimer
DROP TABLE nom          -- Supprime la table
TRUNCATE TABLE nom      -- Vide la table (plus rapide)

-- Indice
CREATE INDEX idx_nom ON table(colonne)
DROP INDEX idx_nom
```

---

## Syntaxe DML rapide

```sql
-- Insérer
INSERT INTO nom (col1, col2) VALUES (val1, val2)
INSERT INTO nom (col1, col2) SELECT c1, c2 FROM autre

-- Modifier
UPDATE nom SET col1 = val1, col2 = val2 WHERE id = 5

-- Supprimer
DELETE FROM nom WHERE id = 5

-- ⚠️ Sans WHERE : affecte TOUTES les lignes !
```

---

## Vues (READ ONLY)

```sql
CREATE VIEW vue_active AS
SELECT id, nom
FROM etudiant
WHERE statut = 'ACTIF'

SELECT * FROM vue_active  -- Utilisation

DROP VIEW vue_active
```

---

## Conseils exam

✅ **À faire** :
- Lire la question DEUX fois
- Identifier les tables et colonnes explicitement
- Écrire d'abord une requête simple, puis refiner
- Tester mentalement sur petit exemple
- Préférer simple et correct à compliqué et faux

❌ **À éviter** :
- Deviner la syntaxe
- Utiliser `SELECT *` (toujours lister les colonnes)
- Oublier le WHERE (modifier/supprimer TOUTES les lignes)
- Mélanger logique (AND vs OR)
- Requête sans alias sur jointures → ambiguïté
