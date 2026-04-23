# Exercices — Dependances fonctionnelles et normalisation

Prerequis: theory/05-normalisation/

Relation de depart:
INSCRIPTION_DETAIL(
  matricule,
  nom_etudiant,
  sigle_cours,
  titre_cours,
  nom_prof,
  bureau_prof,
  note
)

Hypotheses:
- matricule -> nom_etudiant
- sigle_cours -> titre_cours, nom_prof
- nom_prof -> bureau_prof
- (matricule, sigle_cours) -> note

## Exercice 1 (★)

Identifiez la ou les cles candidates de la relation.

## Exercice 2 (★★)

Dites si la relation est en 1NF, 2NF, 3NF.
Justifiez chaque niveau.

## Exercice 3 (★★)

Identifiez les dependances partielles et transitives.

## Exercice 4 (★★★)

Proposez une decomposition en 3NF sans perte.
Donnez les tables finales avec PK/FK.

## Exercice 5 (★★★)

Discutez si votre decomposition est aussi en FNBC.
Si non, expliquez le compromis.
