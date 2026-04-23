/*
  =====================================================
  Titre : Sous-requêtes dans SELECT
  Démontre : Utiliser des sous-requêtes comme colonnes
  Prérequis : Sous-requêtes basiques (IN, EXISTS)
  =====================================================

  Les sous-requêtes dans SELECT permettent d'ajouter des colonnes
  calculées basées sur d'autres tables.
*/

-- Schéma de démonstration
CREATE TABLE clients (
  id INT PRIMARY KEY,
  nom VARCHAR(50),
  ville VARCHAR(30)
);

CREATE TABLE commandes (
  id INT PRIMARY KEY,
  client_id INT,
  montant DECIMAL(10, 2),
  date_commande DATE
);

-- Données
INSERT INTO clients VALUES
  (1, 'Alice', 'Paris'),
  (2, 'Bob',   'Lyon'),
  (3, 'Charlie', 'Paris');

INSERT INTO commandes VALUES
  (1, 1, 100.00, '2024-01-10'),
  (2, 1, 150.00, '2024-01-15'),
  (3, 2, 200.00, '2024-01-12'),
  (4, 1, 75.00,  '2024-01-20'),
  (5, 3, 300.00, '2024-01-18');

-- =====================================================
-- EXEMPLE 1 : Sous-requête scalaire (une ligne)
-- =====================================================

-- Chaque client avec son montant total
SELECT
  nom,
  ville,
  (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) AS montant_total
FROM clients;
/*
Résultat :
  nom     ville   montant_total
  Alice   Paris   325.00
  Bob     Lyon    200.00
  Charlie Paris   300.00

Explication :
  - La sous-requête s'exécute pour chaque client
  - Elle cherche les commandes du client courant (client_id = clients.id)
  - Le résultat devient une nouvelle colonne
*/

-- =====================================================
-- EXEMPLE 2 : Sous-requête avec COUNT
-- =====================================================

-- Nombre de commandes par client
SELECT
  nom,
  (SELECT COUNT(*) FROM commandes WHERE client_id = clients.id) AS nombre_commandes,
  (SELECT AVG(montant) FROM commandes WHERE client_id = clients.id) AS montant_moyen
FROM clients
ORDER BY nombre_commandes DESC;
/*
Résultat :
  nom     nombre_commandes  montant_moyen
  Alice   3                 108.33
  Charlie 1                 300.00
  Bob     1                 200.00
*/

-- =====================================================
-- EXEMPLE 3 : Sous-requête avec condition
-- =====================================================

-- Clients avec leur "dernière commande"
SELECT
  nom,
  (SELECT MAX(montant) FROM commandes WHERE client_id = clients.id) AS derniere_commande_montant,
  (SELECT MAX(date_commande) FROM commandes WHERE client_id = clients.id) AS derniere_date
FROM clients;
/*
Résultat :
  nom     derniere_commande_montant  derniere_date
  Alice   150.00                     2024-01-20
  Bob     200.00                     2024-01-12
  Charlie 300.00                     2024-01-18
*/

-- =====================================================
-- EXEMPLE 4 : Sous-requête avec CASE
-- =====================================================

-- Classifier les clients par montant total
SELECT
  nom,
  (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) AS montant_total,
  CASE
    WHEN (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) > 300 THEN 'Premium'
    WHEN (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) > 150 THEN 'Standard'
    ELSE 'Bronze'
  END AS categorie
FROM clients;
/*
Résultat :
  nom     montant_total  categorie
  Alice   325.00         Premium
  Bob     200.00         Standard
  Charlie 300.00         Standard

Explication :
  - La même sous-requête est exécutée 3 fois pour chaque client
  - C'est inefficace ! Voir l'alternative plus bas.
*/

-- ⚠️ Piège : Répéter la même sous-requête dans CASE
-- C'est répété 3 fois ! Utiliser une CTE est plus efficace (voir cte/)

-- =====================================================
-- EXEMPLE 5 : Sous-requête retournant NULL
-- =====================================================

-- Client sans aucune commande (ajoutons-le)
INSERT INTO clients VALUES (4, 'David', 'Marseille');

SELECT
  nom,
  (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) AS montant_total
FROM clients;
/*
Résultat :
  nom     montant_total
  Alice   325.00
  Bob     200.00
  Charlie 300.00
  David   [NULL]

Explication :
  - SUM() retourne NULL si aucune ligne ne correspond
  - C'est différent de 0 !
*/

-- Traiter NULL comme 0
SELECT
  nom,
  COALESCE((SELECT SUM(montant) FROM commandes WHERE client_id = clients.id), 0) AS montant_total
FROM clients;

-- =====================================================
-- EXEMPLE 6 : Sous-requête avec plusieurs tables
-- =====================================================

-- Nombre de villes différentes d'où proviennent les commandes d'un client
SELECT
  nom,
  (SELECT COUNT(DISTINCT c2.ville)
   FROM commandes cmd
   JOIN clients c2 ON cmd.client_id = c2.id
   WHERE cmd.client_id = clients.id) AS nombre_villes
FROM clients;

-- =====================================================
-- EXEMPLE 7 : Combiner sous-requête SELECT + WHERE
-- =====================================================

-- Clients dont le montant total dépasse la moyenne
SELECT
  nom,
  (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) AS montant_total
FROM clients
WHERE (SELECT SUM(montant) FROM commandes WHERE client_id = clients.id) >
      (SELECT AVG(total) FROM (
        SELECT client_id, SUM(montant) AS total
        FROM commandes
        GROUP BY client_id
      ) AS client_totals);

-- ⚠️ Piège : Cette requête est complexe et répète les calculs
-- Utiliser une CTE (Common Table Expression) est plus lisible

-- =====================================================
-- EXEMPLE 8 : Sous-requête avec LEFT JOIN equivalent
-- =====================================================

-- Cette approche :
SELECT
  c.nom,
  (SELECT COUNT(*) FROM commandes WHERE client_id = c.id) AS nb_commandes
FROM clients c;

-- Est équivalente à (mais plus efficace) :
SELECT
  c.nom,
  COUNT(cmd.id) AS nb_commandes
FROM clients c
LEFT JOIN commandes cmd ON c.id = cmd.client_id
GROUP BY c.id, c.nom;

-- LEFT JOIN est généralement plus performant que des sous-requêtes multiples

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE commandes;
-- DROP TABLE clients;
