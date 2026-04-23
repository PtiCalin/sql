# Exercices — Algebre relationnelle vers SQL

Prerequis: theory/03-algebre-relationnelle/

Schema:
- ETUDIANT(matricule, nom, programme)
- COURS(sigle, titre)
- INSCRIPTION(matricule, sigle, note)

## Exercice 1 (★)

Exprimez en algebre relationnelle:
- les noms des etudiants du programme Informatique.

Puis traduisez en SQL.

## Exercice 2 (★★)

Exprimez en algebre relationnelle:
- les sigles des cours suivis par l'etudiant de matricule 1001.

Puis traduisez en SQL.

## Exercice 3 (★★)

Exprimez en algebre relationnelle:
- les etudiants ayant une note superieure a 85 dans au moins un cours.

Puis traduisez en SQL.

## Exercice 4 (★★★)

Donnez deux expressions algebriques equivalentes pour:
- les noms des etudiants inscrits au cours IFT2821.

Indiquez ensuite la version SQL et expliquez brievement
pourquoi les deux expressions sont equivalentes.

## Exercice 5 (★★★)

Definissez une requete de type division (R ÷ S) en mots,
puis proposez un exemple concret dans le contexte ETUDIANT/COURS.
