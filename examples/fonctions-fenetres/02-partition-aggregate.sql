/*
  =====================================================
  Titre : Fonctions fenêtrées — Agrégations avec PARTITION
  Démontre : Combiner agrégations et fenêtres
  Prérequis : GROUP BY, ROW_NUMBER
  =====================================================

  Utiliser des agrégations (SUM, AVG, etc.) dans une fenêtre
  pour enrichir les données sans les regrouper.
*/

-- Schéma de démonstration
CREATE TABLE transactions (
  id INT PRIMARY KEY,
  client VARCHAR(50),
  mois VARCHAR(10),
  montant DECIMAL(10, 2)
);

-- Données
INSERT INTO transactions VALUES
  (1, 'Alice', 'Jan', 100.00),
  (2, 'Alice', 'Jan', 150.00),
  (3, 'Bob',   'Jan', 200.00),
  (4, 'Alice', 'Feb', 120.00),
  (5, 'Bob',   'Feb', 180.00),
  (6, 'Bob',   'Feb', 220.00),
  (7, 'Alice', 'Mar', 110.00);

-- =====================================================
-- EXEMPLE 1 : SUM avec PARTITION BY
-- =====================================================

-- Chaque transaction avec le total du client
SELECT
  client,
  mois,
  montant,
  SUM(montant) OVER (PARTITION BY client) AS total_client
FROM transactions;

/*
Résultat :
  client  mois  montant  total_client
  Alice   Jan   100.00   480.00        (100 + 150 + 120 + 110)
  Alice   Jan   150.00   480.00
  Bob     Jan   200.00   600.00        (200 + 180 + 220)
  Alice   Feb   120.00   480.00
  Bob     Feb   180.00   600.00
  Bob     Feb   220.00   600.00
  Alice   Mar   110.00   480.00

Explication :
  - SUM(...) OVER (PARTITION BY client) calcule la somme pour chaque client
  - Chaque ligne garde son propre contexte (pas de regroupement)
  - Contrairement à GROUP BY, on voit toutes les lignes
*/

-- =====================================================
-- EXEMPLE 2 : Chaine de transactions avec total cumulé
-- =====================================================

-- Somme cumulée pour chaque client (dans l'ordre chronologique)
SELECT
  client,
  mois,
  montant,
  SUM(montant) OVER (
    PARTITION BY client
    ORDER BY mois
  ) AS cumul_mois
FROM transactions;

/*
Résultat :
  client  mois  montant  cumul_mois
  Alice   Jan   100.00   250.00      (100 + 150)
  Alice   Jan   150.00   250.00      (100 + 150)
  Alice   Feb   120.00   370.00      (250 + 120)
  Alice   Mar   110.00   480.00      (370 + 110)
  Bob     Jan   200.00   200.00      (juste 200)
  Bob     Feb   180.00   600.00      (200 + 180 + 220, car 2 en Feb)
  Bob     Feb   220.00   600.00

Explication :
  - ORDER BY mois crée un "cumul" qui s'accumule
  - Chaque ligne voit la somme jusqu'à ce point
*/

-- =====================================================
-- EXEMPLE 3 : Moyenne avec PARTITION
-- =====================================================

-- Chaque transaction, avec la moyenne du client
SELECT
  client,
  mois,
  montant,
  ROUND(AVG(montant) OVER (PARTITION BY client), 2) AS moyenne_client,
  ROUND(AVG(montant) OVER (PARTITION BY mois), 2) AS moyenne_mois
FROM transactions;

/*
Résultat :
  client  mois  montant  moyenne_client  moyenne_mois
  Alice   Jan   100.00   120.00          150.00       <- (100+150+200)/3
  Alice   Jan   150.00   120.00          150.00
  Bob     Jan   200.00   200.00          150.00
  Alice   Feb   120.00   120.00          173.33       <- (120+180+220)/3
  Bob     Feb   180.00   200.00          173.33
  Bob     Feb   220.00   200.00          173.33
  Alice   Mar   110.00   120.00          110.00

Explication :
  - Deux agrégations parallèles (par client ET par mois)
  - Chaque ligne voit les deux contextes
*/

-- =====================================================
-- EXEMPLE 4 : Min/Max avec PARTITION
-- =====================================================

-- Chaque transaction avec les extrêmes du client
SELECT
  client,
  mois,
  montant,
  MIN(montant) OVER (PARTITION BY client) AS min_client,
  MAX(montant) OVER (PARTITION BY client) AS max_client,
  MAX(montant) OVER (PARTITION BY client) - MIN(montant) OVER (PARTITION BY client) AS range_client
FROM transactions;

/*
Résultat :
  client  mois  montant  min_client  max_client  range_client
  Alice   Jan   100.00   100.00      150.00      50.00
  Alice   Jan   150.00   100.00      150.00      50.00
  Bob     Jan   200.00   180.00      220.00      40.00
  Alice   Feb   120.00   100.00      150.00      50.00
  Bob     Feb   180.00   180.00      220.00      40.00
  Bob     Feb   220.00   180.00      220.00      40.00
  Alice   Mar   110.00   100.00      150.00      50.00
*/

-- =====================================================
-- EXEMPLE 5 : Comparer chaque ligne à la moyenne
-- =====================================================

-- Identifier les transactions "above average"
SELECT
  client,
  mois,
  montant,
  ROUND(AVG(montant) OVER (PARTITION BY client), 2) AS moyenne,
  CASE
    WHEN montant > AVG(montant) OVER (PARTITION BY client) THEN 'Above'
    WHEN montant < AVG(montant) OVER (PARTITION BY client) THEN 'Below'
    ELSE 'At average'
  END AS vs_moyenne
FROM transactions;

/*
Résultat :
  client  mois  montant  moyenne  vs_moyenne
  Alice   Jan   100.00   120.00   Below
  Alice   Jan   150.00   120.00   Above
  Bob     Jan   200.00   200.00   At average
  Alice   Feb   120.00   120.00   At average
  Bob     Feb   180.00   200.00   Below
  Bob     Feb   220.00   200.00   Above
  Alice   Mar   110.00   120.00   Below
*/

-- =====================================================
-- EXEMPLE 6 : Compter dans une fenêtre
-- =====================================================

-- Nombre et pourcentage
SELECT
  client,
  mois,
  montant,
  COUNT(*) OVER (PARTITION BY client) AS nb_transactions,
  COUNT(*) OVER (PARTITION BY mois) AS nb_mois,
  ROUND(100.0 * COUNT(*) OVER (PARTITION BY client) /
        COUNT(*) OVER (), 1) AS pct_total
FROM transactions;

/*
Résultat :
  client  mois  montant  nb_transactions  nb_mois  pct_total
  Alice   Jan   100.00   4                3        57.1       (4 out of 7)
  Alice   Jan   150.00   4                3        57.1
  Bob     Jan   200.00   3                3        42.9       (3 out of 7)
  Alice   Feb   120.00   4                3        57.1
  Bob     Feb   180.00   3                3        42.9
  Bob     Feb   220.00   3                3        42.9
  Alice   Mar   110.00   4                3        57.1

Explication :
  - COUNT() OVER () retourne le COUNT total (7)
  - Permet de calculer les pourcentages
*/

-- =====================================================
-- EXEMPLE 7 : Fenêtre avec frame (ROWS/RANGE)
-- =====================================================

-- Moyenne mobile (dernière 2 transactions)
SELECT
  client,
  mois,
  montant,
  ROUND(AVG(montant) OVER (
    PARTITION BY client
    ORDER BY mois
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
  ), 2) AS moyenne_mobile_2
FROM transactions;

/*
Résultat :
  client  mois  montant  moyenne_mobile_2
  Alice   Jan   100.00   100.00           (juste cette ligne)
  Alice   Jan   150.00   125.00           ((100 + 150) / 2)
  Alice   Feb   120.00   135.00           ((150 + 120) / 2)
  Alice   Mar   110.00   115.00           ((120 + 110) / 2)
  Bob     Jan   200.00   200.00           (juste cette ligne)
  Bob     Feb   180.00   190.00           ((200 + 180) / 2)
  Bob     Feb   220.00   200.00           ((180 + 220) / 2)

Explication :
  - ROWS BETWEEN 1 PRECEDING AND CURRENT ROW = fenêtre de 2 lignes
  - La moyenne "glisse" sur les 2 dernières transactions
  - Utile pour les tendances et le lissage
*/

-- =====================================================
-- EXEMPLE 8 : Percentage contribution
-- =====================================================

-- Chaque client avec son part du total
SELECT
  client,
  SUM(montant) AS client_total,
  (SELECT SUM(montant) FROM transactions) AS grand_total,
  ROUND(100.0 * SUM(montant) /
        (SELECT SUM(montant) FROM transactions), 1) AS pct_du_total
FROM transactions
GROUP BY client;

-- Avec fenêtre (une autre approche)
SELECT DISTINCT
  client,
  SUM(montant) OVER (PARTITION BY client) AS client_total,
  SUM(montant) OVER () AS grand_total,
  ROUND(100.0 * SUM(montant) OVER (PARTITION BY client) /
        SUM(montant) OVER (), 1) AS pct_du_total
FROM transactions;

/*
Résultat :
  client  client_total  grand_total  pct_du_total
  Alice   480.00        1080.00      44.4
  Bob     600.00        1080.00      55.6
*/

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE transactions;
