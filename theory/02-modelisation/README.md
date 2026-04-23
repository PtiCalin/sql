# Module 2 — Modélisation : E-A → Relationnel + Normalisation initiale

**Prérequis :** Module 1 (fondements)  
**Matériaux de référence :**
- `../IFT2821_Module 2_Entité-Association.pdf`
- `../IFT2821_Module 3_Modèle relationnel.pdf`
- Exercices : `../IFT2821_Module 2_Exercice_*.pdf`

---

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Identifier entités, associations et attributs à partir d'un énoncé
- Modéliser un problème sous forme de diagramme Entité-Association (E-A)
- Appliquer les règles de passage du modèle E-A au modèle relationnel
- Définir correctement les clés primaires et étrangères dans un schéma relationnel
- Reconnaître et appliquer les contraintes de cardinalité (1:1, 1:N, N:M)

---

## Concepts clés

### Diagramme Entité-Association (E-A)

> **Intuition (L1)** : Le diagramme E-A est une carte du monde réel — il identifie *qui* (entités) existe et *comment* ils sont reliés (associations).

**Composants :**

| Composant | Représentation | Description |
|-----------|---------------|-------------|
| **Entité** | Rectangle | Objet du monde réel (ex: `ÉTUDIANT`, `COURS`) |
| **Association** | Losange | Lien entre entités (ex: `S'INSCRIT`) |
| **Attribut** | Ovale | Propriété d'une entité ou association |
| **Attribut identifiant** | Ovale souligné | Joue le rôle de clé primaire |

### Cardinalités

Définissent le nombre minimum et maximum de participations d'une entité à une association.

| Notation | Signification |
|----------|--------------|
| `(0,1)` | Zero ou un |
| `(1,1)` | Exactement un (obligatoire) |
| `(0,N)` | Zero ou plusieurs |
| `(1,N)` | Un ou plusieurs |

### Passage E-A → Relationnel

| Cas | Règle de transformation |
|-----|------------------------|
| **Entité simple** | → Une table avec ses attributs ; identifiant = clé primaire |
| **Association 1:N** | → Clé étrangère côté « N » qui référence le côté « 1 » |
| **Association N:M** | → Table intermédiaire avec les deux clés primaires comme clé composée |
| **Association 1:1** | → Clé étrangère dans l'entité la moins contrainte, ou fusion des tables |
| **Attribut multivalué** | → Table séparée avec référence à l'entité parente |

### Exemple de transformation

**Énoncé** : Un étudiant peut s'inscrire à plusieurs cours ; un cours peut avoir plusieurs étudiants.

```
E-A :
  ÉTUDIANT (matricule, nom) ——<S'INSCRIT (note)>—— COURS (sigle, titre)
  Cardinalités : ÉTUDIANT (0,N) — (0,N) COURS

Relationnel :
  ÉTUDIANT(matricule PK, nom)
  COURS(sigle PK, titre)
  S_INSCRIT(matricule FK→ÉTUDIANT, sigle FK→COURS, note)
  Clé primaire de S_INSCRIT : (matricule, sigle)
```

---

## Exercices du cours disponibles

| Fichier | Contexte |
|---------|---------|
| `IFT2821_Module 1_Exercice_ Club sportif.pdf` | Modélisation E-A |
| `IFT2821_Module 1_Exercice_Gestion de cours.pdf` | Modélisation E-A |
| `IFT2821_Module 1_Exercice_Musées d'art.pdf` | Modélisation E-A |
| `IFT2821_Module 2_Exercice_Cadeaux Noel.pdf` | E-A + passage relationnel |
| `IFT2821_Module 2_Exercice_Gestion de cours.pdf` | E-A + passage relationnel |
| `IFT2821_Module 2_Exercice_Magasin de CD.pdf` | E-A + passage relationnel |
| `IFT2821_Module 2_Exercice_Reception.pdf` | E-A + passage relationnel |

---

## Vérifiez votre compréhension

1. Quelle est la différence entre un **attribut identifiant** dans un diagramme E-A et une **clé primaire** dans le modèle relationnel ?
2. Pourquoi une association N:M nécessite-t-elle une **table intermédiaire** dans le modèle relationnel ?
3. Vous modélisez : "Un professeur enseigne plusieurs cours, mais chaque cours est enseigné par un seul professeur." Dessinez le fragment E-A et donnez le schéma relationnel correspondant.
