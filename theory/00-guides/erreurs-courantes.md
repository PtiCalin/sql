# Erreurs SQL courantes et corrections

Diagnostic rapide des messages d'erreur et des comportements inattendus les plus fréquents.

---

## Erreurs de syntaxe

| Symptôme | Cause probable | Correction |
|----------|---------------|-----------|
| `You have an error in your SQL syntax` | Mot-clé manquant, virgule en trop, guillemets incorrects | Relire la requête ligne par ligne ; vérifier les virgules en fin de liste |
| `Unexpected token near ')'` | Parenthèse mal placée ou fermée trop tôt | Vérifier l'équilibre des parenthèses |
| `Column 'x' cannot be null` | Insertion sans valeur pour une colonne `NOT NULL` | Fournir une valeur ou définir un `DEFAULT` |

---

## Erreurs de logique fréquentes

### NULL ne se compare pas avec `=`

```sql
-- ❌ Incorrect : retourne toujours 0 lignes
SELECT * FROM professeurs WHERE cours = NULL;

-- ✅ Correct
SELECT * FROM professeurs WHERE cours IS NULL;
SELECT * FROM professeurs WHERE cours IS NOT NULL;
```

**Pourquoi** : `NULL = NULL` retourne `NULL`, pas `TRUE`. Toute comparaison avec `NULL` produit `NULL`.

---

### WHERE vs HAVING

```sql
-- ❌ Incorrect : ne peut pas utiliser une fonction d'agrégat dans WHERE
SELECT dept, COUNT(*) FROM employe WHERE COUNT(*) > 5 GROUP BY dept;

-- ✅ Correct : HAVING filtre APRÈS l'agrégation
SELECT dept, COUNT(*) FROM employe GROUP BY dept HAVING COUNT(*) > 5;
```

---

### Alias du SELECT non disponible dans WHERE

```sql
-- ❌ Incorrect : l'alias n'existe pas encore au moment où WHERE est évalué
SELECT salaire * 1.1 AS salaire_augmente
FROM employe
WHERE salaire_augmente > 50000;

-- ✅ Correct : répéter l'expression, ou utiliser une sous-requête
SELECT salaire * 1.1 AS salaire_augmente
FROM employe
WHERE salaire * 1.1 > 50000;
```

---

### DISTINCT porte sur toutes les colonnes du SELECT

```sql
-- Retourne les paires (programme, annee_entree) distinctes — pas les programmes seuls
SELECT DISTINCT programme, annee_entree FROM etudiant;

-- Pour les programmes seuls :
SELECT DISTINCT programme FROM etudiant;
```

---

### UPDATE / DELETE sans WHERE

```sql
-- ⚠️ DANGER : modifie TOUTES les lignes
UPDATE professeurs SET position = 'Retraité';

-- ✅ Toujours qualifier avec WHERE
UPDATE professeurs SET position = 'Retraité' WHERE matricule = 5;
```

---

### JOIN sans condition ON (= produit cartésien accidentel)

```sql
-- ❌ Produit cartésien : retourne N × M lignes
SELECT * FROM etudiant, cours;

-- ✅ Toujours spécifier la condition de jointure
SELECT * FROM etudiant e JOIN s_inscrit si ON e.matricule = si.matricule;
```

---

### Ordre d'exécution vs ordre d'écriture

L'ordre d'**écriture** SQL : SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY  
L'ordre d'**exécution** logique : FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

**Conséquences pratiques** :
- Un alias défini dans `SELECT` n'est pas disponible dans `WHERE` ou `GROUP BY`
- `HAVING` peut utiliser les fonctions d'agrégat, `WHERE` ne le peut pas
- `ORDER BY` peut utiliser les alias du `SELECT` (évalué après)

---

## Erreurs de performance

| Symptôme | Cause | Solution |
|----------|-------|---------|
| Requête très lente sur grande table | Pas d'index sur les colonnes du `WHERE` ou `JOIN` | Créer un index : `CREATE INDEX idx_nom ON table(col)` |
| `SELECT *` en production | Charge toutes les colonnes, même inutiles | Lister explicitement les colonnes nécessaires |
| Sous-requête corrélee dans SELECT | Exécutée une fois par ligne | Réécrire avec un `JOIN` ou une CTE |
| N+1 requêtes dans une boucle applicative | Architecture, pas SQL | Utiliser un `JOIN` et ramener tout en une requête |
