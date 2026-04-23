/*
  =====================================================
  Titre : GROUP BY et HAVING — Agrégations par groupe
  Démontre : Grouper les données avant d'appliquer des agrégations
  Prérequis : COUNT, SUM, AVG (exemple précédent)
  =====================================================

  GROUP BY divise les lignes en groupes et applique une agrégation
  à chaque groupe. HAVING filtre les groupes APRÈS l'agrégation
  (alors que WHERE filtre AVANT).
*/

-- Schéma de démonstration (réutilisable)
CREATE TABLE commandes (
  id INT PRIMARY KEY,
  client VARCHAR(50),
  montant DECIMAL(10, 2),
  statut VARCHAR(20),
  date_commande DATE
);

-- Données de test
INSERT INTO commandes VALUES
  (1, 'Alice',   500.00, 'livrée',    '2024-01-10'),
  (2, 'Bob',     300.00, 'livrée',    '2024-01-12'),
  (3, 'Alice',   750.00, 'en cours',  '2024-01-15'),
  (4, 'Charlie', 200.00, 'livrée',    '2024-01-18'),
  (5, 'Bob',     600.00, 'en cours',  '2024-01-19'),
  (6, 'Alice',   450.00, 'livrée',    '2024-01-20'),
  (7, 'Charlie', 350.00, 'livrée',    '2024-01-22');

-- =====================================================
-- EXEMPLE 1 : GROUP BY basique
-- =====================================================

-- Montant total par client
SELECT
  client,
  SUM(montant) AS montant_total
FROM commandes
GROUP BY client
ORDER BY montant_total DESC;
/*
Résultat :
  client   montant_total
  Alice    1700.00
  Bob      900.00
  Charlie  550.00

Explication :
  - GROUP BY client crée 3 groupes (Alice, Bob, Charlie)
  - SUM(montant) additionne le montant pour chaque groupe
*/

-- =====================================================
-- EXEMPLE 2 : Grouper par plusieurs colonnes
-- =====================================================

-- Montant total par client ET par statut
SELECT
  client,
  statut,
  SUM(montant) AS montant_total,
  COUNT(*) AS nombre_commandes
FROM commandes
GROUP BY client, statut
ORDER BY client, statut;
/*
Résultat :
  client   statut      montant_total  nombre_commandes
  Alice    en cours    750.00         1
  Alice    livrée      950.00         2
  Bob      en cours    600.00         1
  Bob      livrée      300.00         1
  Charlie  livrée      550.00         2

Explication :
  - Les groupes sont créés par la combinaison (client, statut)
  - Chaque groupe est traité indépendamment
*/

-- =====================================================
-- EXEMPLE 3 : HAVING — Filtrer les groupes
-- =====================================================

-- Clients avec un montant total > 800
SELECT
  client,
  SUM(montant) AS montant_total
FROM commandes
GROUP BY client
HAVING SUM(montant) > 800
ORDER BY montant_total DESC;
/*
Résultat :
  client   montant_total
  Alice    1700.00
  Bob      900.00

Explication :
  - WHERE s'applique aux lignes INDIVIDUELLES (avant GROUP BY)
  - HAVING s'applique aux GROUPES (après agrégation)
  - Charlie est exclu car 550 < 800
*/

-- ⚠️ Piège : WHERE vs HAVING
-- Incorrect : utiliser WHERE pour filtrer sur une agrégation
-- SELECT client, SUM(montant) FROM commandes
-- WHERE SUM(montant) > 800  -- ❌ Erreur ! WHERE s'applique avant GROUP BY

-- Correct : utiliser HAVING
SELECT client, SUM(montant) AS total
FROM commandes
GROUP BY client
HAVING SUM(montant) > 800;  -- ✅ Correct

-- =====================================================
-- EXEMPLE 4 : Combinaison WHERE + HAVING
-- =====================================================

-- Montant total par client POUR LES COMMANDES LIVRÉES,
-- mais seulement les clients avec > 600 en total
SELECT
  client,
  COUNT(*) AS nombre_livrees,
  SUM(montant) AS montant_livrees
FROM commandes
WHERE statut = 'livrée'    -- [Filtrer avant agrégation]
GROUP BY client
HAVING SUM(montant) > 600  -- [Filtrer après agrégation]
ORDER BY montant_livrees DESC;
/*
Résultat :
  client   nombre_livrees  montant_livrees
  Alice    2               950.00
  Charlie  2               550.00  -- Exclu car 550 < 600

Flux d'exécution :
  1. WHERE statut = 'livrée' → garde 5 lignes
  2. GROUP BY client → crée 3 groupes
  3. HAVING SUM(montant) > 600 → garde Alice seulement
*/

-- =====================================================
-- EXEMPLE 5 : Agrégations multiples dans HAVING
-- =====================================================

-- Clients ayant passé 2+ commandes OU un montant total > 1000
SELECT
  client,
  COUNT(*) AS nombre_commandes,
  SUM(montant) AS montant_total,
  AVG(montant) AS montant_moyen
FROM commandes
GROUP BY client
HAVING COUNT(*) >= 2 OR SUM(montant) > 1000
ORDER BY nombre_commandes DESC;
/*
Résultat :
  client   nombre_commandes  montant_total  montant_moyen
  Alice    3                 1700.00        566.67
  Bob      2                 900.00         450.00
  Charlie  2                 550.00         275.00
*/

-- =====================================================
-- EXEMPLE 6 : NULL dans les groupes
-- =====================================================

-- Ajouter un record avec statut NULL
INSERT INTO commandes VALUES (8, 'David', 100.00, NULL, '2024-01-23');

-- Montant total par statut
SELECT
  statut,
  COUNT(*) AS nombre_commandes,
  SUM(montant) AS montant_total
FROM commandes
GROUP BY statut;
/*
Résultat incluera une ligne avec statut = NULL :
  statut      nombre_commandes  montant_total
  livrée      5                 2700.00
  en cours    2                 1350.00
  [NULL]      1                 100.00

Explication :
  - NULL est traité comme une valeur distincte dans GROUP BY
  - Les lignes avec statut = NULL forment un groupe à part
*/

-- =====================================================
-- EXEMPLE 7 : Ordonner les groupes intelligemment
-- =====================================================

-- Top 2 clients par montant total
SELECT
  client,
  SUM(montant) AS montant_total,
  COUNT(*) AS nombre_commandes
FROM commandes
GROUP BY client
ORDER BY montant_total DESC
LIMIT 2;
/*
Résultat :
  client   montant_total  nombre_commandes
  Alice    1700.00        3
  Bob      900.00         2

Explication : ORDER BY s'applique au résultat GROUP BY,
pas aux lignes individuelles
*/

-- =====================================================
-- VARIANTE : Statistiques par statut
-- =====================================================

SELECT
  statut,
  COUNT(*) AS nombre,
  SUM(montant) AS montant_total,
  ROUND(AVG(montant), 2) AS montant_moyen,
  MIN(montant) AS min_montant,
  MAX(montant) AS max_montant
FROM commandes
WHERE statut IS NOT NULL  -- Exclure les NULL
GROUP BY statut
ORDER BY montant_total DESC;

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE commandes;
