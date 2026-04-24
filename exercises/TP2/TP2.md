# TP2 IFT2821 - Introduction aux bases de données

**Session :** Hiver 2026

---

## Mise en contexte

Un parc d'attractions veut numériser toutes ses données et services dans une base de données. Chaque visiteur achète un billet à l'entrée et est inséré dans la base de données ainsi que le moment de sa visite. Si celui-ci existe déjà, on ne l'insère pas à nouveau, mais on enregistre tout de même le moment de sa visite. Chacun est doté d'un bracelet leur permettant l'accès à une attraction et le système enregistre la visite du client.

Le parc a identifié les différentes entités et leurs associations requises pour la numérisation de ses activités. Ils sont arrivés au modèle relationnel suivant :

```
Manege           (nom, hauteur_minimale, niveau_membre)
Visiteur         (id, courriel, prenom, nom, hauteur, niveau_membre) *
VisiteManege     (#nom_manege, #id_visiteur, date)
VisiteVisiteur   (#id_visiteur, date)
InspectionManege (#no_employe, date, #nom_manege)
Employe          (no_employe, nom, salaire)
```

> \* On assume que la hauteur est remesurée à chaque visite lors de l'achat du billet.

**Sachant que :**

- Le champ `courriel` est unique pour chaque visiteur.
- Le niveau de membre est soit `0`, `1` ou `2` :
  - `0` : Régulier
  - `1` : VIP
  - `2` : Méga VIP

---

## Travail demandé

Exécuter le script **"Création des tables.sql"** disponible dans les fichiers joints.

Prenez bien le temps d'analyser les données insérées ainsi que les relations entre les tables afin de vous aider pour la suite.

Écrivez ensuite les requêtes SQL permettant de :

1. Donner le nom de tous les manèges accessibles **uniquement** aux visiteurs Méga VIP.
2. Donner tous les manèges auxquels **Salim** a accès selon son niveau de membre et sa taille.
3. Donner la liste des visiteurs (noms et prénoms) pouvant accéder aux **"Montagnes Russes"** selon leur taille et leur niveau de membre.
4. Donner le nombre total de visites de visiteurs ayant eu lieu entre le **1er février 2024** et le **28 février 2024**.
5. Donner un tableau contenant, pour chaque visiteur (leurs noms), le **nombre de manèges différents** qu'il a visités.
6. Donner tous les manèges **n'ayant pas été inspectés aujourd'hui** (la date au moment de l'exécution).
7. Donner le nom de l'employé ayant effectué le **plus grand nombre d'inspections**.
8. Donner le nom, prénom et le nom du **manège le plus fréquenté** de chaque visiteur. Le visiteur doit avoir embarqué **au moins 3 fois** dans son attraction préférée pour qu'on affiche son manège préféré.
9. Donner la **taille moyenne** des visiteurs du parc le **25 février 2024**.
10. Créer une **procédure stockée** qui affiche la liste des visiteurs ayant utilisé un certain manège (en utilisant son nom). Appeler cette procédure 3 fois avec différents paramètres.
11. Créer une **fonction** prenant en argument le nom d'un manège et qui retourne le nombre total de visites de ce manège. Appeler cette fonction 3 fois avec différents paramètres.
12. Créer une **procédure utilisant un curseur** qui parcourt tous les manèges et affiche, pour chacun, le nombre total de visites enregistrées. Le curseur devra parcourir les manèges un par un et afficher leur nom ainsi que leur nombre de visites.
13. Créer un **déclencheur (trigger)** qui empêche la suppression d'un manège s'il a déjà été visité au moins une fois. Tester ce déclencheur à l'aide d'une requête `DELETE`.

> **Attention !** Assurez-vous que votre script puisse s'exécuter autant de fois que souhaité. Apportez les changements nécessaires (ex. : `CREATE OR ALTER PROCEDURE`, `CREATE OR ALTER FUNCTION`, etc.)

---

## Fichiers disponibles

```sql
-- Création des tables pour le parc d'attraction
-- Éxécuter ce fichier et répondez aux questions du TP

-- Réinitialisation de la DB (à exécuter au début si nécessaire)
/**
use master;
go
DROP DATABASE IF EXISTS ParcAttraction;
go
CREATE DATABASE ParcAttraction;
GO
**/

-- Utilisation de la base de données créée
USE ParcAttraction;
GO

DROP TABLE IF EXISTS VisiteManege;
DROP TABLE IF EXISTS InspectionManege;
DROP TABLE IF EXISTS VisiteVisiteur;
DROP TABLE IF EXISTS Visiteur;
DROP TABLE IF EXISTS Employe;
DROP TABLE IF EXISTS Manege;

-- Création de la table Manege
CREATE TABLE Manege (
    nom              VARCHAR(50) PRIMARY KEY,
    hauteur_minimale INT,
    niveau_membre    INT CHECK (niveau_membre IN (0, 1, 2))
);
GO

-- Création de la table Visiteur
CREATE TABLE Visiteur (
    id            INT PRIMARY KEY,
    courriel      VARCHAR(100) UNIQUE,
    prenom        VARCHAR(50),
    nom           VARCHAR(50),
    hauteur       INT,
    niveau_membre INT CHECK (niveau_membre IN (0, 1, 2))
);
GO

-- Création de la table Employe
CREATE TABLE Employe (
    no_employe INT PRIMARY KEY,
    nom        VARCHAR(50),
    salaire    DECIMAL(10, 2)
);
GO

-- Création de la table VisiteManege
CREATE TABLE VisiteManege (
    nom_manege  VARCHAR(50),
    id_visiteur INT,
    date        DATE,
    FOREIGN KEY (nom_manege)  REFERENCES Manege(nom),
    FOREIGN KEY (id_visiteur) REFERENCES Visiteur(id),
    PRIMARY KEY (nom_manege, id_visiteur, date)
);
GO

-- Création de la table VisiteVisiteur
CREATE TABLE VisiteVisiteur (
    id_visiteur INT,
    date        DATE,
    FOREIGN KEY (id_visiteur) REFERENCES Visiteur(id),
    PRIMARY KEY (id_visiteur, date)
);
GO

-- Création de la table InspectionManege
CREATE TABLE InspectionManege (
    no_employe INT,
    date       DATE,
    nom_manege VARCHAR(50),
    FOREIGN KEY (no_employe) REFERENCES Employe(no_employe),
    FOREIGN KEY (nom_manege) REFERENCES Manege(nom),
    PRIMARY KEY (no_employe, date, nom_manege)
);
GO

-- Insertion des données
INSERT INTO Manege (nom, hauteur_minimale, niveau_membre)
VALUES
    ('Montagnes Russes',   140, 1),
    ('Glissade Atlantique', 105, 2),
    ('Manège Volcanique',  150, 2),
    ('Manège de l''Espace', 110, 1),
    ('Baie des Pirates',   100, 0);

INSERT INTO Employe (no_employe, nom, salaire)
VALUES
    (101, 'Lamine Labile',     2500),
    (102, 'Marcelle Lefebvre', 2800),
    (103, 'Andreas Alcaraz',   3000),
    (104, 'Sophie Côté',       2600),
    (105, 'Fatima Benjelloun', 2700);

INSERT INTO Visiteur (id, courriel, prenom, nom, hauteur, niveau_membre)
VALUES
    (201, 'visiteur1@example.com', 'Salim',    'Bouchard', 110, 1),
    (202, 'visiteur2@example.com', 'Émilie',   'Gagnon',   120, 0),
    (203, 'visiteur3@example.com', 'Maxime',   'Fortin',   150, 2),
    (204, 'visiteur4@example.com', 'Mélissa',  'Lavoie',   130, 1),
    (205, 'visiteur5@example.com', 'Philippe', 'Bergeron', 140, 0);

INSERT INTO VisiteManege (nom_manege, id_visiteur, date)
VALUES
    ('Montagnes Russes',    201, '2024-01-20'),
    ('Glissade Atlantique', 201, '2024-02-10'),
    ('Montagnes Russes',    201, '2024-02-10'),
    ('Montagnes Russes',    201, '2024-02-15'),
    ('Glissade Atlantique', 202, '2024-01-05'),
    ('Manège Volcanique',   202, '2024-01-05'),
    ('Glissade Atlantique', 202, '2024-02-19'),
    ('Glissade Atlantique', 202, '2024-02-25'),
    ('Manège Volcanique',   203, '2024-03-01'),
    ('Manège de l''Espace', 204, '2024-03-06'),
    ('Baie des Pirates',    205, '2024-02-25'),
    ('Montagnes Russes',    205, '2024-02-25'),
    ('Glissade Atlantique', 205, '2024-03-25');

INSERT INTO VisiteVisiteur (id_visiteur, date)
VALUES
    (201, '2024-01-20'),
    (201, '2024-02-10'),
    (201, '2024-02-25'),
    (202, '2024-01-05'),
    (202, '2024-02-19'),
    (202, '2024-02-25'),
    (203, '2023-12-30'),
    (204, '2024-03-06'),
    (204, '2023-12-25'),
    (205, '2024-02-25');

INSERT INTO InspectionManege (no_employe, date, nom_manege)
VALUES
    (101, CONVERT(DATE, GETDATE()), 'Montagnes Russes'),
    (101, '2024-02-10',            'Montagnes Russes'),
    (104, '2024-01-10',            'Montagnes Russes'),
    (103, '2024-02-10',            'Montagnes Russes'),
    (102, '2023-12-20',            'Glissade Atlantique'),
    (103, '2023-12-15',            'Manège Volcanique'),
    (104, '2023-12-10',            'Manège de l''Espace'),
    (105, CONVERT(DATE, GETDATE()), 'Baie des Pirates'),
    (105, '2023-12-12',            'Manège de l''Espace');
```

---

## Grille de correction

| Critère | Points |
|---|---|
| Manèges Méga VIP | / 5 |
| Manèges de Salim | / 5 |
| Visiteurs des Montagnes Russes | / 5 |
| Visites en février 2024 | / 5 |
| Manèges différents pour les visiteurs | / 8 |
| Manèges pas inspectés aujourd'hui | / 8 |
| Le meilleur inspecteur de manège | / 8 |
| Le manège préféré de chaque visiteur | / 8 |
| Taille moyenne des visiteurs en février 2024 | / 8 |
| Procédure stockée | / 10 |
| Fonction | / 10 |
| Curseur | / 10 |
| Déclencheur | / 10 |
| **Total** | **/ 100** |

**Barème :**

| Situation | Points accordés |
|---|---|
| Aucune réponse | ~0 % |
| Réponse incomplète | ~25 % |
| Réponse avec plusieurs erreurs | ~50 % |
| Réponse avec une erreur | ~75 % |
| Réponse avec une erreur mineure | ~90–100 % |
| Bonne réponse | 100 % |

**Pénalités :**

- Petits problèmes lors de l'exécution : **-1 %**
- Problèmes majeurs nécessitant beaucoup de changements : **-3 %**