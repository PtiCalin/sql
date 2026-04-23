# Module 1 — Fondements des bases de données

**Prérequis :** Aucun  
**Matériau de référence :** `../IFT2821_Module 1_Introduction.pdf`

---

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Définir ce qu'est une base de données et un SGBD
- Distinguer le modèle relationnel des autres modèles (hiérarchique, réseau, objet)
- Identifier les composants d'une relation : attributs, tuples, domaines
- Expliquer les propriétés d'une relation (pas de doublon, pas d'ordre)
- Définir les notions de clé primaire, clé étrangère et intégrité référentielle

---

## Concepts clés

### Qu'est-ce qu'une base de données ?

> **Intuition (L1)** : Une BD est un ensemble de données organisées pour être stockées, interrogées et modifiées de façon fiable et cohérente.

**Définition formelle (L2)** : Un ensemble structuré de données persistantes, géré par un **Système de Gestion de Base de Données (SGBD)**, qui garantit l'accès concurrent, la cohérence et la durabilité des données.

### Le modèle relationnel

Proposé par E.F. Codd (1970). Toutes les données sont représentées sous forme de **relations** (tables).

| Concept | Définition |
|---------|-----------|
| **Relation** | Table à deux dimensions : lignes (tuples) × colonnes (attributs) |
| **Tuple** | Une ligne = un enregistrement |
| **Attribut** | Une colonne = une propriété de l'entité |
| **Domaine** | L'ensemble des valeurs valides pour un attribut |
| **Clé primaire** | Attribut(s) qui identifie(nt) uniquement chaque tuple |
| **Clé étrangère** | Attribut référençant la clé primaire d'une autre relation |

### Propriétés d'une relation

1. Chaque valeur est **atomique** (pas de valeur multiple ou composite)
2. Chaque tuple est **unique** (pas de doublon)
3. L'**ordre** des tuples n'a pas de sens
4. L'**ordre** des attributs n'a pas de sens
5. Chaque attribut a un **nom unique** dans la relation

### Intégrité des données

| Contrainte | Règle |
|-----------|-------|
| **Intégrité de domaine** | Chaque valeur respecte le domaine de l'attribut |
| **Intégrité d'entité** | La clé primaire ne peut pas être NULL |
| **Intégrité référentielle** | Toute clé étrangère référence une clé primaire existante |

---

## Vérifiez votre compréhension

1. Quelle est la différence entre une **clé primaire** et une **clé candidate** ?
2. Pourquoi dit-on que l'ordre des tuples dans une relation "n'a pas de sens" — quelle implication cela a-t-il pour les requêtes SQL ?
3. Qu'est-ce qu'une **valeur NULL** ? Est-ce la même chose que 0 ou une chaîne vide ?
