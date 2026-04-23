# Exercices — Modélisation E-A vers relationnel

Prérequis: theory/02-modelisation/

## Contexte

On veut modéliser la gestion d'un département universitaire.

Règles métier:
- Un étudiant appartient à un seul programme.
- Un programme contient plusieurs étudiants.
- Un cours peut être offert par plusieurs sessions.
- Un étudiant peut s'inscrire à plusieurs offres de cours.
- Une offre de cours contient plusieurs inscriptions.
- Un professeur peut enseigner plusieurs offres de cours.
- Une offre de cours est enseignée par un seul professeur.

## Exercice 1 (★)

Identifiez les entités principales et proposez leurs attributs (incluant les identifiants).

## Exercice 2 (★★)

Donnez les associations et les cardinalités min/max pour chaque relation entre entités.

## Exercice 3 (★★)

Transformez votre modèle E-A en schéma relationnel complet (tables, PK, FK).

## Exercice 4 (★★★)

Ajoutez la contrainte suivante:
- un étudiant ne peut pas s'inscrire deux fois a la meme offre de cours.

Indiquez:
- la table impactée
- la clé candidate et/ou contrainte a ajouter

## Exercice 5 (★★★)

Proposez trois contraintes d'intégrité additionnelles qui devraient exister dans le schéma relationnel final.

Exemples attendus:
- contraintes de domaine
- contraintes d'unicité
- contraintes référentielles
