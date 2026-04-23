# Cheat Sheet : Normalisation (1NF, 2NF, 3NF, BCNF)

## Quick Check

```
1NF : Attributs atomiques ?        → Oui → 2NF ?
2NF : Pas de DF partielle ?       → Oui → 3NF ?
3NF : Pas de DF transitive ?      → Oui → BCNF ?
BCNF: Pour toute DF X → Y, X super-clé ?
```

---

## 1NF (Première forme normale)

**Condition** : Tous les attributs sont **atomiques** (non divisibles).

❌ Incorrect :
```
ETUDIANT(matricule, nom, cours[])  -- cours est multivalué
```

✅ Correct :
```
ETUDIANT(matricule, nom)
S_INSCRIT(matricule FK, sigle FK)
```

---

## 2NF (Deuxième forme normale)

**Condition** : 1NF + **pas de dépendance partielle** envers la clé primaire.

**Dépendance partielle** = Un attribut non-clé dépend seulement d'une **partie** de la clé composée.

### Exemple problématique

```
COMMANDE(num_commande, num_produit, quantité, nom_produit, prix)
Clé primaire : (num_commande, num_produit)

Dépendances fonctionnelles :
  num_produit → nom_produit  ✗ (partielle : dépend de seulement num_produit)
  num_produit → prix         ✗ (partielle)
  (num_commande, num_produit) → quantité  ✓ (dépend de la clé entière)
```

### Solution

Décomposer en 2NF :

```
COMMANDE(num_commande, num_produit FK, quantité)
PRODUIT(num_produit, nom_produit, prix)
```

---

## 3NF (Troisième forme normale)

**Condition** : 2NF + **pas de dépendance transitive** envers la clé primaire.

**Dépendance transitive** = Un attribut non-clé dépend d'un autre attribut non-clé, qui dépend lui-même de la clé primaire.

### Exemple problématique

```
EMPLOYE(id, nom, id_dept, nom_dept, budget_dept)
Clé primaire : id

Dépendances :
  id → nom             ✓
  id → id_dept         ✓
  id → nom_dept        ✗ (transitive : id → id_dept → nom_dept)
  id → budget_dept     ✗ (transitive)
```

### Solution

```
EMPLOYE(id, nom, id_dept FK)
DEPARTEMENT(id_dept, nom_dept, budget_dept)
```

---

## BCNF (Boyce-Codd Normal Form)

**Condition** : Pour toute dépendance fonctionnelle X → Y (Y non vide, X ∩ Y = ∅), X doit être une **super-clé**.

> BCNF > 3NF — plus restrictive, élimine plus d'anomalies.

### Quand BCNF ≠ 3NF ?

Cas rare : une clé candidate détermine un attribut de clé primaire.

```
ETUDIANT_COURS(matricule, sigle, id_prof)
Clés candidates : (matricule, sigle) ET (matricule, id_prof)

DF :
  (matricule, id_prof) → sigle

En 3NF ? Oui (sigle est un attribut clé).
En BCNF ? Non (id_prof seul n'est pas une super-clé).

Solution : refondre le schéma
```

---

## Anomalies évitées

| Forme | Anomalies évitées |
|-------|------------------|
| 1NF | Attributs multivalués |
| 2NF | + Dépendances partielles (sur clés composées) |
| 3NF | + Dépendances transitives |
| BCNF | + Cas où clés candidates interfèrent |

---

## Procédure pratique d'examen

### 1. Identifier la clé primaire

→ Quel(s) attribut(s) identifie(nt) uniquement une ligne ?

### 2. Identifier TOUTES les dépendances fonctionnelles

→ Poser la question : "Si je connais cet attribut, peux-je déterminer cet autre ?"

### 3. Vérifier 1NF

→ Tous les attributs sont-ils atomiques ? (pas de listes, pas de sous-structures)

### 4. Vérifier 2NF

→ Y a-t-il un attribut non-clé qui dépend seulement d'une PARTIE de la clé primaire ?

### 5. Vérifier 3NF

→ Y a-t-il un attribut non-clé qui dépend d'un AUTRE attribut non-clé qui lui-même dépend de la clé ?

### 6. Décomposer si nécessaire

→ Pour chaque anomalie, créer une nouvelle table avec l'attribut problématique et ses déterminants.
