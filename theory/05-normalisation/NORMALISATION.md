# Module 5 — Normalisation et dépendances fonctionnelles

**Prérequis :** Module 2 (modélisation)  
**Matériau de référence :** `../BDD - Normalisation et DF.pdf`

---

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Définir une dépendance fonctionnelle et identifier celles d'un schéma
- Calculer la fermeture d'un ensemble d'attributs
- Vérifier si un schéma est en 1NF, 2NF, 3NF ou FNBC
- Décomposer un schéma en formes normales supérieures sans perte de données ni de dépendances

---

## Concepts clés

### Dépendance fonctionnelle (DF)

> **Intuition (L1)** : X → Y signifie "si vous connaissez X, vous pouvez déterminer Y de façon unique."

**Définition formelle (L2)** : Dans une relation R, on dit que X → Y (X détermine fonctionnellement Y) si, pour toute paire de tuples t₁ et t₂, t₁[X] = t₂[X] implique t₁[Y] = t₂[Y].

**Exemple** : Dans `ÉTUDIANT(matricule, nom, département)` :
- `matricule → nom` ✓ (un matricule identifie un seul étudiant)
- `nom → matricule` ✗ (deux étudiants peuvent avoir le même nom)

### Formes normales

| Forme normale | Condition à satisfaire |
|---------------|----------------------|
| **1NF** | Tous les attributs sont atomiques (pas de valeur multiple) |
| **2NF** | 1NF + pas de dépendance partielle envers la clé primaire |
| **3NF** | 2NF + pas de dépendance transitive envers la clé primaire |
| **FNBC** | Pour toute DF X → Y non triviale, X est une super-clé |

> La FNBC est plus stricte que la 3NF. Elle élimine toutes les anomalies, mais peut parfois ne pas préserver toutes les DFs.

### Anomalies évitées par la normalisation

| Anomalie | Description |
|----------|-------------|
| **Insertion** | Impossible d'insérer un fait sans en connaître un autre non lié |
| **Suppression** | Supprimer un tuple efface des informations non liées |
| **Mise à jour** | Modifier une valeur répétée dans plusieurs tuples → incohérence |

### Décomposition

Une décomposition est **sans perte** si la jointure naturelle des tables décomposées redonne la table originale.

Elle **préserve les dépendances** si toutes les DFs originales peuvent être vérifiées sans jointure.

---

## Vérifiez votre compréhension

1. Soit le schéma `COMMANDE(num_commande, num_produit, quantité, prix_produit, nom_fournisseur)`.
   - Identifiez les dépendances fonctionnelles.
   - Ce schéma est-il en 2NF ? Justifiez.

2. Quelle est la différence pratique entre **3NF** et **FNBC** ? Dans quel cas préférer l'une à l'autre ?

3. Pourquoi normaliser peut-il parfois **dégrader les performances** ? Comment compenser ?
