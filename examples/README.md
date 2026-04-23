# Exemples — Requêtes annotées

Chaque sous-dossier contient des fichiers `.sql` annotés et exécutables, organisés par thème. Chaque exemple explique **pourquoi** la requête est écrite ainsi, pas seulement comment.

## Progression recommandée

| Ordre | Dossier                                      | Fichiers                                                               | Prérequis théoriques     |
| ----- | -------------------------------------------- | ---------------------------------------------------------------------- | ------------------------ |
| 1     | [`fondamentaux/`](fondamentaux/)             | SELECT, WHERE                                                          | Module 4 — langage SQL   |
| 2     | [`jointures/`](jointures/)                   | Types de JOINs                                                         | Module 4                 |
| 3     | [`agregations/`](agregations/)               | `01-count-sum.sql` / `02-group-by.sql` / `03-agregations-avancees.sql` | Module 4                 |
| 4     | [`sous-requetes/`](sous-requetes/)           | `01-in-exists.sql` / `02-subqueries-select.sql` / `03-pieges.sql`      | Module 4                 |
| 5     | [`cte/`](cte/)                               | `01-simple-cte.sql` / `02-cte-recursive.sql`                           | Sous-requêtes maîtrisées |
| 6     | [`fonctions-fenetres/`](fonctions-fenetres/) | `01-row-number.sql` / `02-partition-aggregate.sql`                     | Agrégations maîtrisées   |
| 7     | [`ddl/`](ddl/)                               | `01-create-table.sql` / `02-alter-drop.sql`                            | Module 4 — DDL           |
| 8     | [`avance/`](avance/)                         | `01-views.sql` / `02-procedures.sql` / `03-functions.sql`              | Module 6 — SQL avancé    |

## Description des sections

### Agrégations (3 fichiers)

- **01-count-sum.sql** — COUNT, SUM, AVG, MIN, MAX sans regroupement
- **02-group-by.sql** — GROUP BY et HAVING, agrégations par groupe
- **03-agregations-avancees.sql** — NULL, DISTINCT, cas limites, pièges courants

### Sous-requêtes (3 fichiers)

- **01-in-exists.sql** — IN, NOT IN, EXISTS, NOT EXISTS
- **02-subqueries-select.sql** — Sous-requêtes scalaires dans SELECT
- **03-pieges.sql** — Pièges courants (NULL, performance, logique inversée)

### CTE (2 fichiers)

- **01-simple-cte.sql** — WITH basique, réutilisation, multiple CTEs
- **02-cte-recursive.sql** — Structures hiérarchiques, RECURSIVE WITH

### Fonctions fenêtrées (2 fichiers)

- **01-row-number.sql** — ROW_NUMBER, RANK, DENSE_RANK, pagination
- **02-partition-aggregate.sql** — SUM/AVG/COUNT avec PARTITION, fenêtres glissantes

### DDL (2 fichiers)

- **01-create-table.sql** — CREATE TABLE, types de données, contraintes
- **02-alter-drop.sql** — ALTER TABLE (ADD, MODIFY, DROP), DROP TABLE

### SQL Avancé (3 fichiers)

- **01-views.sql** — CREATE VIEW, vues simples et complexes, sécurité
- **02-procedures.sql** — CREATE PROCEDURE, paramètres (IN, OUT, INOUT), logique
- **03-functions.sql** — CREATE FUNCTION, retours, utilisation dans SELECT

## Conventions des exemples

- Chaque fichier commence par un commentaire décrivant **ce qu'il démontre** et **pourquoi**.
- Les étapes non triviales sont annotées avec `-- [Explication]`.
- Les pièges et erreurs courantes sont signalés avec `-- ⚠️`.
- Les variantes et alternatives sont présentées quand elles existent.
- Chaque exemple est exécutable indépendamment (données de test créées dans le fichier).

## Comment utiliser ces exemples

1. **Lire la théorie** (dans `../theory/`) pour comprendre les concepts
2. **Exécuter les exemples** dans l'ordre progressif
3. **Modifier les requêtes** pour tester ta compréhension
4. **Adapter les schémas** à tes propres cas d'usage
