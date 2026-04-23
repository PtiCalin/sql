# Module 4 — Le langage SQL

**Prérequis :** Module 3 (algèbre relationnelle)  
**Matériau de référence :** `../IFT2821_Module 5_Le langage SQL.pdf`  
**Référence rapide :** [`../../reference/syntaxe-sql.md`](../../reference/syntaxe-sql.md)

---

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Créer, modifier et supprimer des tables avec le DDL
- Insérer, modifier et supprimer des données avec le DML
- Écrire des requêtes SELECT avec filtres, tris et jointures
- Utiliser les fonctions d'agrégat avec GROUP BY et HAVING
- Écrire des sous-requêtes (scalaires, corrélées, dans FROM)
- Comprendre les transactions et les niveaux d'isolation (TCL)

---

## Sous-langages SQL

| Sous-langage | Commandes | Rôle |
|-------------|-----------|------|
| **DDL** — Data Definition Language | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | Définir la structure |
| **DML** — Data Manipulation Language | `INSERT`, `UPDATE`, `DELETE` | Modifier les données |
| **DQL** — Data Query Language | `SELECT` | Interroger les données |
| **DCL** — Data Control Language | `GRANT`, `REVOKE` | Gérer les droits |
| **TCL** — Transaction Control Language | `COMMIT`, `ROLLBACK`, `SAVEPOINT` | Contrôler les transactions |

---

## Structure d'une requête SELECT

```sql
SELECT   [DISTINCT] colonnes | *          -- Projection
FROM     table [AS alias]                 -- Source
[JOIN    autre_table ON condition]        -- Jointure
[WHERE   condition]                       -- Sélection (avant agrégation)
[GROUP BY colonnes]                       -- Regroupement
[HAVING  condition]                       -- Sélection (après agrégation)
[ORDER BY colonnes [ASC|DESC]]            -- Tri
[LIMIT   n [OFFSET k]];                  -- Pagination
```

**Ordre d'exécution logique** (≠ ordre d'écriture) :
1. `FROM` + `JOIN`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT`
6. `ORDER BY`
7. `LIMIT`

> Comprendre cet ordre est essentiel pour savoir **pourquoi** certaines requêtes échouent ou retournent des résultats inattendus.

---

## Types de jointures

| Type | Résultat |
|------|---------|
| `INNER JOIN` | Tuples avec correspondance dans les deux tables |
| `LEFT JOIN` | Tous les tuples de gauche + correspondances (NULL si absent) |
| `RIGHT JOIN` | Tous les tuples de droite + correspondances |
| `FULL OUTER JOIN` | Tous les tuples des deux tables |
| `CROSS JOIN` | Produit cartésien |
| Auto-jointure | `JOIN` d'une table sur elle-même (avec alias) |

---

## Fonctions d'agrégat

| Fonction | Description |
|----------|-------------|
| `COUNT(*)` | Nombre de tuples |
| `COUNT(col)` | Nombre de valeurs non-NULL |
| `SUM(col)` | Somme |
| `AVG(col)` | Moyenne |
| `MIN(col)` / `MAX(col)` | Minimum / Maximum |

> `WHERE` filtre **avant** l'agrégation. `HAVING` filtre **après**.

---

## Exemples disponibles

→ [`../../examples/fondamentaux/`](../../examples/fondamentaux/)  
→ [`../../examples/jointures/`](../../examples/jointures/)  
→ [`../../examples/agregations/`](../../examples/agregations/)  
→ [`../../examples/sous-requetes/`](../../examples/sous-requetes/)

---

## Vérifiez votre compréhension

1. Pourquoi ne peut-on pas utiliser un alias défini dans le `SELECT` à l'intérieur du `WHERE` de la même requête ?
2. Quelle est la différence entre `WHERE note > 80` et `HAVING AVG(note) > 80` ?
3. Écrivez une requête qui retourne les cours ayant **plus de 10 étudiants inscrits**, triés par nombre d'inscriptions décroissant.
