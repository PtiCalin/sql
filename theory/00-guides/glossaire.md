# Glossaire — Termes et concepts SQL

> Référence alphabétique des termes techniques utilisés dans cette base de connaissances, organisée par catégorie pour faciliter la navigation.

---

## Index par catégorie

| Catégorie                 | Termes                                                                        |
| ------------------------- | ----------------------------------------------------------------------------- |
| **Concepts fondamentaux** | Attribut, Clé, Domaine, Entité, Relation, Schéma, Tuple                       |
| **Clés et contraintes**   | Clé candidate, Clé composite, Clé étrangère, Clé primaire, Contrainte, UNIQUE |
| **DDL**                   | ALTER TABLE, CREATE, DDL, DROP, TRUNCATE                                      |
| **DML**                   | DELETE, DML, INSERT, UPDATE                                                   |
| **DQL**                   | SELECT, WHERE, GROUP BY, HAVING, JOIN, ORDER BY, LIMIT                        |
| **Fonctions SQL**         | Agrégation, AVG, COUNT, MAX, MIN, SUM, DISTINCT                               |
| **Jointures**             | INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN, Self-join           |
| **Sous-requêtes**         | Correlated subquery, Scalar subquery, Subquery, IN, EXISTS                    |
| **Fenêtres et CTE**       | CTE, Window function, PARTITION BY, ROW_NUMBER, RANK, DENSE_RANK              |
| **Avancé**                | CTE recursive, Function, Index, Procedure, Trigger, View                      |
| **Modélisation**          | Algèbre relationnelle, Diagramme entité-association (E-A), Normalisation      |
| **Performance**           | Execution plan, Optimizer, Query plan                                         |

---

## A

### Agrégation (fonction d')

**Définition** : Fonction qui synthétise un ensemble de lignes en une seule valeur.

**Exemples** : COUNT, SUM, AVG, MIN, MAX.

**Usage** :

```sql
SELECT COUNT(*), AVG(salaire), MAX(salaire)
FROM employes;
```

**Synonymes** : Fonction de synthèse.

---

### Algèbre relationnelle

**Définition** : Langage mathématique formel pour exprimer les opérations sur les relations (tables).

**Opérations clés** :

- Sélection (σ) : filtrer les lignes
- Projection (π) : sélectionner les colonnes
- Jointure (⨝) : combiner deux relations
- Union (∪), Intersection (∩), Différence (−) : opérations ensemblistes

**Lien avec SQL** : Chaque requête SELECT correspond à une série d'opérations d'algèbre relationnelle.

---

### ALTER TABLE

**Définition** : Commande DDL pour modifier la structure d'une table existante.

**Usages courants** :

```sql
ALTER TABLE employes ADD COLUMN date_embauche DATE;
ALTER TABLE employes MODIFY COLUMN nom VARCHAR(200);
ALTER TABLE employes DROP COLUMN ancien_nom;
```

**Voir aussi** : DDL, CREATE TABLE, DROP TABLE.

---

### Attribut

**Définition** : Propriété ou caractéristique d'une entité dans le modèle E-A. Correspond à une **colonne** dans une table SQL.

**Exemple** : Dans l'entité "Employé", les attributs sont : id, nom, salaire, date_embauche.

**Synonymes** : Propriété, Champ, Colonne.

**Voir aussi** : Entité, Domaine.

---

## C

### Candidat (clé)

Voir **Clé candidate**.

---

### Cardinalité

**Définition** : Nombre d'occurrences d'une entité qui peuvent être associées à une autre entité dans une relation.

**Notations** :

- 1:1 (un-à-un)
- 1:N (un-à-plusieurs)
- N:M (plusieurs-à-plusieurs)

**Exemple** : Un client peut avoir plusieurs commandes (1:N).

---

### Clé candidate

**Définition** : Ensemble minimal d'attributs qui identifie uniquement chaque tuple dans une relation.

**Propriétés** :

- Unicité : deux tuples ne peuvent pas avoir la même valeur
- Minimalité : aucun sous-ensemble ne peut l'être

**Exemple** : Dans une table Employés, à la fois `id` et `numéro_identification` peuvent être des clés candidates.

**Voir aussi** : Clé primaire, UNIQUE.

---

### Clé composite

**Définition** : Clé composée de plusieurs attributs (colonnes).

**Exemple** :

```sql
CREATE TABLE commandes (
    client_id INT,
    numero_cmd INT,
    PRIMARY KEY (client_id, numero_cmd)
);
```

**Voir aussi** : Clé primaire, PRIMARY KEY.

---

### Clé étrangère

**Définition** : Attribut (ou groupe d'attributs) dont les valeurs doivent exister dans la clé primaire d'une autre table.

**Syntaxe SQL** :

```sql
ALTER TABLE employes
ADD FOREIGN KEY (departement_id) REFERENCES departements(id);
```

**Rôle** : Maintient l'intégrité référentielle entre tables.

**Synonymes** : Référence, Clé de jointure.

**Voir aussi** : Clé primaire, Intégrité référentielle.

---

### Clé primaire

**Définition** : Attribut (ou groupe d'attributs) qui identifie uniquement chaque ligne dans une table.

**Propriétés** :

- Unicité : chaque valeur est unique
- NOT NULL : aucune valeur vide
- Une seule par table

**Syntaxe SQL** :

```sql
CREATE TABLE employes (
    id INT PRIMARY KEY,
    ...
);
```

**Voir aussi** : PRIMARY KEY, Clé candidate, Clé composite.

---

### Composite (clé)

Voir **Clé composite**.

---

### Correlated subquery

Voir **Sous-requête corrélée**.

---

### COUNT

**Définition** : Fonction d'agrégation qui compte le nombre de lignes.

**Variantes** :

- `COUNT(*)` : compte toutes les lignes (y compris les NULL)
- `COUNT(colonne)` : compte les lignes NON-NULL
- `COUNT(DISTINCT colonne)` : compte les valeurs uniques

**Exemple** :

```sql
SELECT COUNT(DISTINCT departement) FROM employes;
```

**Voir aussi** : Agrégation, SUM, AVG.

---

### CREATE

**Définition** : Commande DDL pour créer de nouveaux objets (tables, vues, index, etc.).

**Syntaxe** :

```sql
CREATE TABLE nom (...);
CREATE VIEW nom AS SELECT ...;
CREATE INDEX nom ON table(colonne);
```

**Voir aussi** : DDL, ALTER TABLE, DROP.

---

### CTE

**Définition** : Common Table Expression. Requête nommée temporaire utilisable dans une requête SELECT/INSERT/UPDATE/DELETE.

**Syntaxe** :

```sql
WITH cte_nom AS (
    SELECT ...
)
SELECT * FROM cte_nom;
```

**Avantages** :

- Améliore la lisibilité
- Permet la réutilisation
- Support de la récursion (CTE RECURSIVE)

**Synonymes** : Requête nommée, Temporary named result set.

**Voir aussi** : CTE RECURSIVE, Subquery.

---

### CTE RECURSIVE

**Définition** : CTE qui peut se référencer elle-même, permettant de parcourir des structures hiérarchiques.

**Syntaxe** :

```sql
WITH RECURSIVE cte_nom AS (
    -- Cas de base
    SELECT ... WHERE condition_initiale
    UNION ALL
    -- Cas récursif
    SELECT ... FROM cte_nom WHERE condition_recursion
)
SELECT * FROM cte_nom;
```

**Usages** : Hiérarchies d'employés, arbres de dossiers, chemins de graphes.

**Voir aussi** : CTE, Hiérarchie.

---

## D

### DDL

**Définition** : Data Definition Language. Langage SQL pour définir la structure des bases de données.

**Commandes** : CREATE, ALTER, DROP, TRUNCATE.

**Exemple** :

```sql
CREATE TABLE employes (...);
ALTER TABLE employes ADD COLUMN salaire INT;
DROP TABLE employes;
```

**Contraste** : DML (manipulation des données), DQL (requêtes).

**Voir aussi** : DML, DQL.

---

### DENSE_RANK

**Définition** : Fonction fenêtrée qui assigne un rang sans écarts, même en cas d'égalité.

**Différence avec RANK** :

- RANK : 1, 1, 3, 4 (saute les rangs)
- DENSE_RANK : 1, 1, 2, 3 (pas de saut)

**Exemple** :

```sql
SELECT nom, salaire,
       DENSE_RANK() OVER (ORDER BY salaire DESC) AS rang
FROM employes;
```

**Voir aussi** : RANK, ROW_NUMBER, Window function.

---

### Diagramme E-A

Voir **Entité-Association (diagramme)**.

---

### DISTINCT

**Définition** : Mot-clé SQL pour éliminer les doublons dans les résultats.

**Syntaxe** :

```sql
SELECT DISTINCT departement FROM employes;
```

**Usages** :

- Lister les valeurs uniques
- Combiner avec COUNT pour compter les valeurs uniques

**Exemple** :

```sql
SELECT COUNT(DISTINCT departement) FROM employes;
```

**Voir aussi** : GROUP BY, COUNT.

---

### Domaine

**Définition** : Ensemble des valeurs possibles pour un attribut (type de données et contraintes).

**Exemple** : L'attribut "salaire" a un domaine : DECIMAL(10,2), >= 0.

**Voir aussi** : Attribut, Type de données.

---

### DROP

**Définition** : Commande DDL pour supprimer définitivement un objet (table, vue, index, etc.).

**Syntaxe** :

```sql
DROP TABLE [IF EXISTS] nom_table;
DROP VIEW nom_vue;
DROP INDEX nom_index;
```

**⚠️ Attention** : Suppression irréversible (les données sont perdues).

**Voir aussi** : DDL, DELETE, TRUNCATE.

---

## E

### Entité

**Définition** : Objet distinct du monde réel représenté dans le modèle E-A. Correspond à une **table** en SQL.

**Exemple** : L'entité "Employé" se transforme en table `employes`.

**Synonymes** : Classe d'objets, Type d'objet.

**Voir aussi** : Attribut, Relation, Entité-Association.

---

### Entité-Association (modèle)

**Définition** : Modèle de données conceptuel pour décrire la structure d'une base de données avant l'implémentation SQL.

**Composants** :

- **Entités** : objets du monde réel (rectangles)
- **Attributs** : propriétés des entités (ovales)
- **Relations** : associations entre entités (losanges)

**Transformation** : E-A → Modèle relationnel → Tables SQL.

**Synonymes** : Modèle E-R, ER model.

**Voir aussi** : Normalisation, Modèle relationnel.

---

### Execution plan

**Définition** : Plan détaillé d'exécution généré par l'optimiseur SQL, montrant comment le moteur accèdera aux données.

**Usage** : Diagnostic de performance.

**Commandes** :

- MySQL : `EXPLAIN SELECT ...`
- PostgreSQL : `EXPLAIN ANALYZE SELECT ...`

**Informations** : Scan type (seq scan, index), join order, cost.

**Voir aussi** : Query plan, Optimizer.

---

## F

### Fenêtre (fonction)

Voir **Window function**.

---

### FOREIGN KEY

**Définition** : Contrainte SQL déclarant une clé étrangère.

**Syntaxe** :

```sql
ALTER TABLE employes
ADD CONSTRAINT fk_dept
FOREIGN KEY (departement_id) REFERENCES departements(id)
ON DELETE CASCADE
ON UPDATE RESTRICT;
```

**Actions de cascade** :

- CASCADE : supprimer/modifier aussi dans la table enfant
- RESTRICT : refuser la suppression/modification si enfants existent
- SET NULL : mettre à NULL
- NO ACTION : pas d'action (erreur)

**Voir aussi** : Clé étrangère, Intégrité référentielle.

---

### FULL JOIN

**Définition** : Jointure qui retourne toutes les lignes des deux tables, avec NULL là où il n'y a pas de correspondance.

**Syntaxe** :

```sql
SELECT * FROM table1
FULL JOIN table2 ON table1.id = table2.id;
```

**Résultat** : INNER JOIN ∪ LEFT JOIN (doublons supprimés).

**Voir aussi** : INNER JOIN, LEFT JOIN, RIGHT JOIN.

---

## G

### GROUP BY

**Définition** : Clause SQL qui regroupe les lignes selon une ou plusieurs colonnes avant d'appliquer des agrégations.

**Syntaxe** :

```sql
SELECT departement, COUNT(*) AS nombre
FROM employes
GROUP BY departement;
```

**Combinaison** :

- Avec WHERE : filtre avant le groupement
- Avec HAVING : filtre après le groupement

**Voir aussi** : HAVING, Agrégation.

---

## H

### HAVING

**Définition** : Clause SQL qui filtre les groupes après une agrégation (contrairement à WHERE qui filtre avant).

**Syntaxe** :

```sql
SELECT departement, COUNT(*) AS nombre
FROM employes
GROUP BY departement
HAVING COUNT(*) > 2;
```

**Différence clé** : WHERE s'applique aux lignes, HAVING aux groupes.

**Voir aussi** : GROUP BY, WHERE.

---

### Hiérarchie

**Définition** : Structure où les éléments sont organisés en niveaux (parent-enfant).

**Exemples** :

- Arborescence d'employés (CEO → VP → Manager → Employee)
- Fichiers et dossiers
- Taxonomie des produits

**Implémentation** : CTE RECURSIVE.

**Voir aussi** : CTE RECURSIVE, Self-join.

---

## I

### Index

**Définition** : Structure de données optimisant la recherche des lignes dans une table (similaire à l'index d'un livre).

**Types** :

- **Index simple** : sur une colonne
- **Index composite** : sur plusieurs colonnes
- **Index unique** : enforce uniqueness
- **Primary key** : index implicite sur la clé primaire

**Syntaxe** :

```sql
CREATE INDEX idx_nom ON employes(nom);
CREATE UNIQUE INDEX idx_email ON users(email);
```

**Trade-off** : Accélère les SELECT/WHERE/JOIN, ralentit INSERT/UPDATE/DELETE.

**Voir aussi** : Performance, Optimizer.

---

### INNER JOIN

**Définition** : Jointure qui retourne uniquement les lignes ayant une correspondance dans les deux tables.

**Syntaxe** :

```sql
SELECT * FROM employes
INNER JOIN departements ON employes.dept_id = departements.id;
```

**Résultat** : Intersection logique.

**Synonymes** : Simple join, Equijoin (si condition d'égalité).

**Voir aussi** : LEFT JOIN, RIGHT JOIN, FULL JOIN.

---

### Intégrité référentielle

**Définition** : Propriété garantissant que les clés étrangères pointent toujours vers des clés primaires valides (pas d'orphelins).

**Implémentation** : Contraintes FOREIGN KEY.

**Exemple** :

```sql
ALTER TABLE employes
ADD FOREIGN KEY (dept_id) REFERENCES departements(id);
```

Empêche l'insertion d'un employé avec un dept_id inexistant.

**Voir aussi** : Clé étrangère, Contrainte.

---

## J

### JOIN

**Définition** : Clause SQL combinant les lignes de deux tables selon une condition.

**Types principaux** :

- INNER JOIN : correspondances uniquement
- LEFT JOIN : toutes lignes de gauche
- RIGHT JOIN : toutes lignes de droite
- FULL JOIN : toutes lignes des deux tables
- CROSS JOIN : produit cartésien

**Syntaxe générale** :

```sql
SELECT * FROM table1
[INNER|LEFT|RIGHT|FULL] JOIN table2 ON condition;
```

**Voir aussi** : INNER JOIN, LEFT JOIN, Self-join.

---

## L

### LEFT JOIN

**Définition** : Jointure retournant toutes les lignes de la table de gauche et les correspondances de la droite (NULL sinon).

**Syntaxe** :

```sql
SELECT * FROM employes e
LEFT JOIN departements d ON e.dept_id = d.id;
```

**Résultat** : Tous les employés, même sans département.

**Synonymes** : LEFT OUTER JOIN.

**Voir aussi** : INNER JOIN, RIGHT JOIN, OUTER JOIN.

---

### LIMIT

**Définition** : Clause SQL qui limite le nombre de lignes retournées.

**Syntaxe** :

```sql
SELECT * FROM employes LIMIT 10;
SELECT * FROM employes LIMIT 5, 10;  -- offset 5, limit 10
SELECT * FROM employes LIMIT 10 OFFSET 5;  -- équivalent
```

**Usages** :

- Pagination
- Top N
- Performance (tester rapidement)

**Voir aussi** : ORDER BY, OFFSET.

---

## M

### MAX / MIN

**Définition** : Fonctions d'agrégation retournant la valeur maximale / minimale.

**Syntaxe** :

```sql
SELECT MAX(salaire), MIN(salaire) FROM employes;
```

**Combiner** :

```sql
SELECT MAX(salaire) - MIN(salaire) AS amplitude FROM employes;
```

**Voir aussi** : AVG, SUM, COUNT.

---

## N

### Normalisation

**Définition** : Processus de restructuration d'une base de données pour minimiser la redondance et les anomalies.

**Formes normales** :

- 1NF (First Normal Form) : Aucun attribut multi-valué
- 2NF : 1NF + Aucune dépendance partielle
- 3NF : 2NF + Aucune dépendance transitive
- BCNF (Boyce-Codd Normal Form) : Plus strict que 3NF

**Objectif** : Intégrité des données et efficacité du stockage.

**Voir aussi** : Dépendance fonctionnelle, Entité-Association.

---

### NOT NULL

**Définition** : Contrainte stipulant qu'une colonne ne peut pas avoir de valeur vide (NULL).

**Syntaxe** :

```sql
CREATE TABLE employes (
    id INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100)  -- Peut être NULL
);
```

**Voir aussi** : Contrainte, NULL.

---

### NULL

**Définition** : Valeur représentant l'absence de donnée ou l'inconnu.

**Propriétés** :

- `NULL = NULL` retourne unknown (pas TRUE)
- `NULL != NULL` retourne unknown
- Agrégations ignorent NULL (COUNT compte les non-NULL)
- Comparaisons avec NULL utilisent IS NULL / IS NOT NULL

**Syntaxe** :

```sql
SELECT * FROM employes WHERE email IS NULL;
SELECT COUNT(DISTINCT email) FROM employes;  -- Ignore les NULL
```

**Voir aussi** : NOT NULL, COALESCE.

---

## O

### OFFSET

**Définition** : Nombre de lignes à ignorer avant de retourner les résultats (utilisé avec LIMIT pour la pagination).

**Syntaxe** :

```sql
SELECT * FROM employes LIMIT 10 OFFSET 20;  -- Lignes 21-30
```

**Voir aussi** : LIMIT, Pagination.

---

### Optimizer

**Définition** : Composant du moteur SQL qui détermine le plan d'exécution optimal pour une requête.

**Rôle** :

- Analyse plusieurs approches
- Estime le coût (I/O, CPU, mémoire)
- Choisit la plus efficace

**Interaction** : Utilise les statistiques sur les tables (nombre de lignes, distribution) et les index.

**Voir aussi** : Execution plan, Query plan.

---

## P

### Pagination

**Définition** : Technique pour retourner les résultats par "pages" (utile pour les interfaces).

**Syntaxe** :

```sql
-- Page 1 (lignes 1-10)
SELECT * FROM employes ORDER BY id LIMIT 10 OFFSET 0;
-- Page 2 (lignes 11-20)
SELECT * FROM employes ORDER BY id LIMIT 10 OFFSET 10;
```

**Voir aussi** : LIMIT, OFFSET.

---

### PARTITION BY

**Définition** : Clause des fonctions fenêtrées qui divise les lignes en "partitions" avant d'appliquer la fonction.

**Syntaxe** :

```sql
SELECT nom, salaire,
       SUM(salaire) OVER (PARTITION BY departement) AS total_dept
FROM employes;
```

**Différence avec GROUP BY** : GROUP BY regroupe (réduit les lignes), PARTITION BY garde toutes les lignes.

**Voir aussi** : Window function, GROUP BY.

---

### PRIMARY KEY

**Définition** : Contrainte SQL déclarant la clé primaire d'une table.

**Propriétés** :

- Unicité (unique)
- NOT NULL (obligatoire)
- Une seule par table

**Syntaxe** :

```sql
CREATE TABLE employes (
    id INT PRIMARY KEY,
    ...
);

-- Alternative
CREATE TABLE employes (
    id INT,
    ...,
    PRIMARY KEY (id)
);
```

**Voir aussi** : Clé primaire, Clé composite, UNIQUE.

---

### Procedure

**Définition** : Bloc de code SQL stocké sur le serveur, réutilisable, qui peut accepter des paramètres et retourner des résultats.

**Syntaxe** :

```sql
CREATE PROCEDURE sp_nom(IN param INT, OUT resultat INT)
BEGIN
    SELECT COUNT(*) INTO resultat FROM table WHERE id = param;
END;

CALL sp_nom(5, @res);
```

**Différence avec Function** : Procédure = flexible (peut faire plusieurs choses), Function = retourne une valeur.

**Voir aussi** : Function, Trigger.

---

## Q

### Query plan

Voir **Execution plan**.

---

## R

### RANK

**Définition** : Fonction fenêtrée qui assigne un rang, avec écarts en cas d'égalité.

**Comparaison** :

- RANK : 1, 1, 3, 4 (saute les rangs)
- DENSE_RANK : 1, 1, 2, 3 (pas de saut)
- ROW_NUMBER : 1, 2, 3, 4 (toujours unique)

**Exemple** :

```sql
SELECT nom, salaire,
       RANK() OVER (ORDER BY salaire DESC) AS rang
FROM employes;
```

**Voir aussi** : DENSE_RANK, ROW_NUMBER, Window function.

---

### Relation

**Définition** : Lien ou association entre deux ou plusieurs entités dans le modèle E-A. Correspond aux **jointures** en SQL.

**Exemple** : La relation "travaille_pour" associe Employé ↔ Département.

**Synonymes** : Association, Lien.

**Voir aussi** : Entité, Cardinalité.

---

### Relationnel (modèle)

**Définition** : Modèle de données structurant les données en **relations** (tables) composées de **tuples** (lignes) et d'**attributs** (colonnes).

**Propriétés clés** :

- Données en tableaux (relations)
- Pas d'ordre implicite des lignes
- Pas d'ordre implicite des colonnes
- Chaque ligne unique

**Transformation** : E-A → Modèle relationnel → SQL.

**Voir aussi** : Normalisation, Entité-Association.

---

### RIGHT JOIN

**Définition** : Jointure retournant toutes les lignes de la table de droite et les correspondances de la gauche (NULL sinon).

**Syntaxe** :

```sql
SELECT * FROM employes e
RIGHT JOIN departements d ON e.dept_id = d.id;
```

**Résultat** : Tous les départements, même sans employés.

**Synonymes** : RIGHT OUTER JOIN.

**Équivalence** : RIGHT JOIN A ON ... = LEFT JOIN ... (en inversant les tables).

**Voir aussi** : LEFT JOIN, INNER JOIN.

---

### ROW_NUMBER

**Définition** : Fonction fenêtrée assignant un numéro unique à chaque ligne dans une partition/ordre.

**Syntaxe** :

```sql
SELECT nom, salaire,
       ROW_NUMBER() OVER (PARTITION BY departement ORDER BY salaire DESC) AS rang
FROM employes;
```

**Usages** :

- Pagination
- Top N par groupe
- Numérotation

**Voir aussi** : RANK, DENSE_RANK, Window function.

---

## S

### Scalar subquery

Voir **Sous-requête scalaire**.

---

### Schema

**Définition** : Structure logique d'une base de données, définissant les tables, colonnes, types, contraintes.

**Synonymes** : Schéma de base de données, Structure.

**Voir aussi** : DDL, Modèle relationnel.

---

### SELECT

**Définition** : Commande DQL retournant les lignes satisfaisant les critères.

**Syntaxe** :

```sql
SELECT [DISTINCT] colonnes
FROM table
[WHERE condition]
[GROUP BY colonnes] [HAVING condition]
[ORDER BY colonnes] [ASC|DESC]
[LIMIT n] [OFFSET m];
```

**Clauses** : FROM, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT.

**Voir aussi** : DQL, WHERE, JOIN.

---

### Self-join

**Définition** : Jointure d'une table avec elle-même (avec alias).

**Usages** :

- Hiérarchies (manager d'un employé)
- Comparaisons entre lignes

**Exemple** :

```sql
SELECT e1.nom, e2.nom AS manager
FROM employes e1
JOIN employes e2 ON e1.manager_id = e2.id;
```

**Voir aussi** : JOIN, Hiérarchie.

---

### SUM

**Définition** : Fonction d'agrégation additionnant les valeurs.

**Syntaxe** :

```sql
SELECT SUM(salaire) FROM employes;
SELECT dept_id, SUM(salaire) FROM employes GROUP BY dept_id;
```

**Propriété** : Ignore les NULL (ne les additionne pas à 0).

**Voir aussi** : AVG, COUNT, MIN, MAX.

---

### Subquery

**Définition** : Requête imbriquée utilisée dans une autre requête (SELECT, WHERE, FROM, etc.).

**Types** :

- **Scalar** : retourne une valeur (utilisable dans SELECT, WHERE)
- **IN/EXISTS** : retourne plusieurs lignes (utilisable dans WHERE)
- **Correlated** : se référence à la requête extérieure

**Exemple** :

```sql
SELECT * FROM employes
WHERE salaire > (SELECT AVG(salaire) FROM employes);
```

**Voir aussi** : CTE, Correlated subquery.

---

### Sous-requête

Voir **Subquery**.

---

### Sous-requête corrélée

**Définition** : Sous-requête se référençant à des colonnes de la requête extérieure.

**Syntaxe** :

```sql
SELECT nom FROM employes e1
WHERE salaire > (
    SELECT AVG(salaire)
    FROM employes e2
    WHERE e2.departement = e1.departement
);
```

Chaque ligne d'employes exécute la sous-requête (peut être lent).

**Voir aussi** : Subquery, EXISTS.

---

### Sous-requête scalaire

**Définition** : Sous-requête retournant exactement une ligne et une colonne (une valeur).

**Utilisable** : Dans SELECT, WHERE, HAVING, etc.

**Exemple** :

```sql
SELECT nom,
       (SELECT COUNT(*) FROM commandes WHERE client_id = c.id) AS nb_commandes
FROM clients c;
```

**Voir aussi** : Subquery, Scalar subquery.

---

## T

### Table

**Définition** : Structure stockant les données en lignes et colonnes. Correspond à une **relation** dans le modèle relationnel.

**Création** :

```sql
CREATE TABLE employes (
    id INT,
    nom VARCHAR(100),
    PRIMARY KEY (id)
);
```

**Voir aussi** : Relation, Attribut, Tuple.

---

### Trigger

**Définition** : Bloc de code exécuté automatiquement en réaction à un événement (INSERT, UPDATE, DELETE).

**Syntaxe** (exemple) :

```sql
CREATE TRIGGER trg_audit_after_insert
AFTER INSERT ON employes
FOR EACH ROW
BEGIN
    INSERT INTO audit (action, employe_id, timestamp)
    VALUES ('INSERT', NEW.id, NOW());
END;
```

**Usages** :

- Audit
- Validation métier
- Cascade de mises à jour

**Voir aussi** : Procedure, Event.

---

### Tuple

**Définition** : Ligne d'une relation (table). Collection d'attributs (valeurs de colonnes).

**Propriété** : Chaque tuple est unique dans la relation (grâce à la clé primaire).

**Synonymes** : Ligne, Enregistrement, Record.

**Voir aussi** : Relation, Attribut.

---

## U

### UNION

**Définition** : Opération ensembliste combinant les résultats de deux requêtes (en supprimant les doublons).

**Syntaxe** :

```sql
SELECT col FROM table1
UNION
SELECT col FROM table2;
```

**Variante** : UNION ALL (garde les doublons).

**Voir aussi** : INTERSECT, EXCEPT.

---

### UNIQUE

**Définition** : Contrainte stipulant que les valeurs dans une colonne doivent être uniques (pas de doublons).

**Syntaxe** :

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);
```

**Différence avec PRIMARY KEY** : UNIQUE permet les NULL multiples, PRIMARY KEY ne permet que NULL.

**Voir aussi** : PRIMARY KEY, Clé candidate.

---

## V

### View

**Définition** : Requête SQL nommée stockée comme objet virtuel (pas de données physiques).

**Syntaxe** :

```sql
CREATE VIEW v_employes_senior AS
SELECT nom, salaire
FROM employes
WHERE YEAR(CURDATE()) - YEAR(date_embauche) >= 5;

SELECT * FROM v_employes_senior;
```

**Avantages** :

- Simplifier les requêtes complexes
- Masquer les détails d'implémentation
- Contrôler l'accès aux données

**Voir aussi** : CTE, Procedure.

---

## W

### WHERE

**Définition** : Clause SQL filtrant les lignes selon une condition (appliquée avant le groupement).

**Syntaxe** :

```sql
SELECT * FROM employes
WHERE salaire > 5000 AND departement = 'IT';
```

**Différence avec HAVING** : WHERE filtre les lignes, HAVING filtre les groupes.

**Voir aussi** : HAVING, GROUP BY.

---

### Window function

**Définition** : Fonction appliquée à une fenêtre de lignes (voisinage) sans les regrouper.

**Types** :

- **Ranking** : ROW_NUMBER, RANK, DENSE_RANK
- **Aggregate** : SUM, AVG, COUNT (avec OVER)
- **Lead/Lag** : LEAD, LAG

**Syntaxe** :

```sql
SELECT nom, salaire,
       AVG(salaire) OVER (PARTITION BY departement) AS moyenne_dept,
       ROW_NUMBER() OVER (ORDER BY salaire DESC) AS rang
FROM employes;
```

**Différence avec GROUP BY** : GROUP BY regroupe, WINDOW FUNCTION garde toutes les lignes.

**Voir aussi** : PARTITION BY, OVER, RANK, ROW_NUMBER.

---

## Voir aussi

- [Syntaxe SQL](syntaxe-sql.md) — Référence des commandes
- [Types de données](types-de-donnees.md) — Types disponibles
- [Erreurs courantes](erreurs-courantes.md) — Pièges à éviter
