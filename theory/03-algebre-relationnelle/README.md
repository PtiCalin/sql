# Module 3 — Algèbre relationnelle

**Prérequis :** Module 2 (modélisation)  
**Matériau de référence :** `../IFT2821_Module 4_Algèbre relationnelle.pdf`

---

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Appliquer les opérations de base de l'algèbre relationnelle
- Traduire une expression algébrique en requête SQL et vice-versa
- Composer des opérations pour exprimer des requêtes complexes
- Identifier l'équivalence entre plusieurs expressions algébriques

---

## Concepts clés

> **Intuition (L1)** : L'algèbre relationnelle est le langage mathématique sous-jacent à SQL — comprendre l'algèbre, c'est comprendre *ce que fait* une requête, pas seulement *comment l'écrire*.

### Opérations fondamentales

| Opération | Symbole | Description | Équivalent SQL |
|-----------|---------|-------------|----------------|
| **Sélection** | σ (sigma) | Filtre les tuples selon une condition | `WHERE` |
| **Projection** | π (pi) | Conserve uniquement certains attributs | `SELECT col1, col2` |
| **Produit cartésien** | × | Combine chaque tuple de R avec chaque tuple de S | `FROM R, S` (sans condition) |
| **Union** | ∪ | Tous les tuples de R ou S (sans doublon) | `UNION` |
| **Différence** | − | Tuples dans R mais pas dans S | `EXCEPT` |
| **Intersection** | ∩ | Tuples dans R et dans S | `INTERSECT` |
| **Jointure naturelle** | ⋈ | Produit cartésien + sélection sur attributs communs | `NATURAL JOIN` |
| **Renommage** | ρ (rho) | Renomme une relation ou ses attributs | `AS` |

### Opérations dérivées

| Opération | Définition |
|-----------|-----------|
| **Jointure-thêta** | σ_condition(R × S) |
| **Équi-jointure** | Jointure-thêta avec condition d'égalité |
| **Division** | R ÷ S — tuples de R associés à *tous* les tuples de S |

### Exemple composé

**Question** : Quels étudiants (nom) sont inscrits au cours 'IFT2821' ?

```
π_nom(σ_sigle='IFT2821'(ÉTUDIANT ⋈ S_INSCRIT ⋈ COURS))
```

**Traduction SQL :**
```sql
SELECT e.nom
FROM ÉTUDIANT e
JOIN S_INSCRIT si ON e.matricule = si.matricule
JOIN COURS c ON si.sigle = c.sigle
WHERE c.sigle = 'IFT2821';
```

---

## Pourquoi étudier l'algèbre relationnelle ?

L'algèbre relationnelle est la base formelle sur laquelle les optimiseurs de requêtes SQL opèrent. Comprendre les **équivalences algébriques** permet de :
- Raisonner sur l'efficacité d'une requête
- Comprendre pourquoi l'ordre des opérations importe
- Décomposer mentalement des requêtes complexes

---

## Vérifiez votre compréhension

1. Quelle est la différence entre une **sélection** (σ) et une **projection** (π) ? Donnez un exemple de chacune.
2. Exprimez en algèbre relationnelle : "Les noms des étudiants qui ont obtenu une note supérieure à 80."
3. Pourquoi le **produit cartésien** seul est-il rarement utile en pratique ? Que faut-il toujours lui associer ?
