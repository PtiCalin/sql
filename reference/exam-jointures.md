# Cheat Sheet : Jointures — quand utiliser quoi

## Types de jointures résumé

```
        ETUDIANT                    S_INSCRIT
    (4 tuples)                   (5 tuples)
    
INNER JOIN           :  tuples avec correspondance dans LES DEUX
LEFT JOIN            :  TOUS de gauche + correspondances
RIGHT JOIN           :  TOUS de droite + correspondances  
FULL OUTER JOIN      :  TOUS des deux tables
CROSS JOIN           :  Produit cartésien (toutes combinaisons)
```

---

## 1. INNER JOIN — Intersection

**Quand** : Tu veux **seulement** les lignes qui ont une correspondance dans BOTH tables.

```sql
SELECT e.nom, c.titre, si.note
FROM etudiant e
INNER JOIN s_inscrit si ON e.matricule = si.matricule
INNER JOIN cours c     ON si.sigle = c.sigle;
```

**Résultat** :
- Étudiants ayant au moins une inscription ✓
- Étudiants sans inscription ✗

**Cas d'usage** :
- Requêtes d'analyse (ventes avec clients)
- Données reliées obligatoirement

---

## 2. LEFT JOIN — Garder la gauche

**Quand** : Tu veux **TOUS** les tuples de la table de gauche, même sans correspondance à droite.

```sql
SELECT e.nom, c.titre, si.note
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
LEFT JOIN cours c     ON si.sigle = c.sigle;
```

**Résultat** :
- Tous les étudiants
- Si pas d'inscription : `si.note` = NULL

**Cas d'usage** :
- Trouver ce qui MANQUE (valeurs NULL à droite)
- Rapport complet (inclure les non-correspondances)

**Exemple : Étudiants SANS inscription**

```sql
SELECT e.nom
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
WHERE si.matricule IS NULL;  -- Les non-inscrits
```

---

## 3. RIGHT JOIN — Garder la droite

**Quand** : Tu veux **TOUS** les tuples de la table de droite.

```sql
SELECT e.nom, c.titre
FROM etudiant e
RIGHT JOIN s_inscrit si ON e.matricule = si.matricule
RIGHT JOIN cours c     ON si.sigle = c.sigle;
```

**💡 Équivalent à** :

```sql
SELECT c.titre, e.nom
FROM cours c
LEFT JOIN s_inscrit si ON si.sigle = c.sigle
LEFT JOIN etudiant e  ON e.matricule = si.matricule;
```

**👉 Préférer LEFT JOIN par convention** (plus lisible : on met la table de référence à gauche).

---

## 4. FULL OUTER JOIN — Tous les deux

**Quand** : Tu veux **TOUS** les tuples des deux tables, avec correspondances où elles existent.

```sql
SELECT e.nom, c.titre
FROM etudiant e
FULL OUTER JOIN s_inscrit si ON e.matricule = si.matricule
FULL OUTER JOIN cours c      ON si.sigle = c.sigle;
```

**⚠️ MySQL n'a pas FULL OUTER** → Utiliser UNION de LEFT + RIGHT

```sql
-- MySQL workaround
SELECT e.nom, c.titre
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
LEFT JOIN cours c     ON si.sigle = c.sigle
UNION
SELECT e.nom, c.titre
FROM etudiant e
RIGHT JOIN s_inscrit si ON e.matricule = si.matricule
RIGHT JOIN cours c     ON si.sigle = c.sigle;
```

**Cas d'usage** : Réconciliation (voir tous les tuples des deux sources).

---

## 5. CROSS JOIN — Produit cartésien

**Quand** : Tu veux **TOUTES** les combinaisons possibles.

```sql
SELECT e.nom, c.titre
FROM etudiant e
CROSS JOIN cours c;
```

**Résultat** : 4 étudiants × 3 cours = 12 lignes.

**Cas d'usage** :
- Générer toutes les combinaisons (horaires, emplois du temps)
- Rarement directement — souvent filtrer après

```sql
-- Tous les couples possibles (non-performant)
SELECT e.nom, c.titre
FROM etudiant e
CROSS JOIN cours c
WHERE <condition supplémentaire>;
```

---

## 6. AUTO-JOINTURE — Table sur elle-même

**Quand** : Tu dois comparer les lignes d'une même table entre elles.

```sql
-- Paires d'étudiants du même programme
SELECT a.nom AS etudiant_1, b.nom AS etudiant_2, a.programme
FROM etudiant a
JOIN etudiant b ON a.programme = b.programme
                AND a.matricule < b.matricule;
```

**⚠️ Obligatoire** : Utiliser **des alias différents** pour les deux instances.

---

## Tableau de décision

| Question | Réponse | Utiliser |
|----------|---------|----------|
| Veux-tu garder les non-correspondances à droite ? | Non | INNER JOIN |
| Veux-tu garder les non-correspondances à GAUCHE ? | Oui | LEFT JOIN |
| Veux-tu garder les non-correspondances à DROITE ? | Oui | RIGHT JOIN |
| Veux-tu garder les deux côtés incomplets ? | Oui | FULL OUTER JOIN |
| Veux-tu TOUTES les combinaisons ? | Oui | CROSS JOIN |
| Compares-tu la table avec elle-même ? | Oui | AUTO-JOINTURE (+ alias) |

---

## Syntaxes rapides

```sql
-- INNER (défaut)
FROM t1 JOIN t2 ON t1.id = t2.id

-- LEFT
FROM t1 LEFT JOIN t2 ON t1.id = t2.id

-- RIGHT
FROM t1 RIGHT JOIN t2 ON t1.id = t2.id

-- FULL (PostgreSQL)
FROM t1 FULL OUTER JOIN t2 ON t1.id = t2.id

-- CROSS
FROM t1 CROSS JOIN t2
-- ou
FROM t1, t2
```

---

## Pièges courants

❌ **Piège 1** : Oublier la condition ON = produit cartésien accidentel

```sql
-- ❌ Retourne tous les couples t1 × t2
SELECT * FROM t1 JOIN t2;

-- ✅ Toujours spécifier ON
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id;
```

❌ **Piège 2** : Mélanger LEFT et WHERE

```sql
-- ❌ Le WHERE annule le LEFT (filtre après la jointure)
SELECT *
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
WHERE si.note > 80;  -- Élimine les non-inscrits !

-- ✅ Mettre la condition dans ON si elle doit garder les NULL
SELECT *
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
                       AND si.note > 80;

-- Ou utiliser WHERE si tu veux filtrer APRÈS
SELECT *
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
WHERE si.note > 80 OR si.note IS NULL;  -- Les non-inscrits
```

❌ **Piège 3** : Jointures multiples augmentent les résultats

```sql
-- Si la jointure produit un doublon, le résultat final l'aura aussi
FROM t1 JOIN t2 ON t1.id = t2.id
       JOIN t3 ON t2.id = t3.id
       -- Si un t2 a plusieurs t3, résultat x n
```

✅ **Solution** : Utiliser `DISTINCT` ou regrouper avec `GROUP BY`.
