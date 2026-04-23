/*
  =====================================================
  Titre : Agrégations simples — COUNT, SUM, AVG, MAX
  Démontre : Fonctions d'agrégation sans GROUP BY
  Prérequis : SELECT, WHERE
  =====================================================

  Les fonctions d'agrégation synthétisent un ensemble de lignes
  en UNE SEULE valeur. COUNT compte les lignes, SUM les additionne,
  AVG calcule la moyenne, MAX/MIN trouvent les extrêmes.
*/

-- Schéma de démonstration
CREATE TABLE ventes (
  id INT PRIMARY KEY,
  produit VARCHAR(50),
  quantite INT,
  prix_unitaire DECIMAL(10, 2),
  date_vente DATE
);

-- Données de test
INSERT INTO ventes VALUES
  (1, 'Laptop',      1,  1200.00, '2024-01-15'),
  (2, 'Souris',      5,    25.00, '2024-01-16'),
  (3, 'Clavier',     3,    75.00, '2024-01-17'),
  (4, 'Laptop',      2,  1200.00, '2024-01-18'),
  (5, 'Moniteur',    1,   350.00, '2024-01-19'),
  (6, 'Souris',      8,    25.00, '2024-01-20');

-- =====================================================
-- EXEMPLE 1 : COUNT — Compter les lignes
-- =====================================================

-- Combien de ventes avons-nous en total ?
SELECT COUNT(*) AS nombre_ventes
FROM ventes;
-- Résultat : 6
-- Explication : COUNT(*) compte TOUTES les lignes, même avec NULL

-- Combien de produits distincts ont été vendus ?
SELECT COUNT(DISTINCT produit) AS nombre_produits_distincts
FROM ventes;
-- Résultat : 4 (Laptop, Souris, Clavier, Moniteur)
-- Explication : DISTINCT élimine les doublons AVANT de compter

-- ⚠️ Piège : COUNT(colonne) vs COUNT(*)
SELECT COUNT(produit) AS count_produit,
       COUNT(*) AS count_total
FROM ventes;
-- Résultat : count_produit = 6, count_total = 6
-- Si produit contenait des NULL, count_produit serait moins que count_total

-- =====================================================
-- EXEMPLE 2 : SUM — Additionner les valeurs
-- =====================================================

-- Quel est le revenu total des ventes (quantité × prix) ?
SELECT SUM(quantite * prix_unitaire) AS revenu_total
FROM ventes;
-- Résultat : 5725.00
-- Explication : La multiplication se fait ligne par ligne,
-- puis SUM totalise tous les résultats

-- ⚠️ Piège : SUM avec NULL
-- Si une colonne contient NULL, elle est ignorée (pas additionée à 0)
SELECT SUM(quantite) AS total_quantite
FROM ventes;
-- Résultat : 20 (1 + 5 + 3 + 2 + 1 + 8)
-- Si une valeur était NULL, elle n'ajouterait pas 0, elle serait simplement ignorée

-- =====================================================
-- EXEMPLE 3 : AVG — Calculer la moyenne
-- =====================================================

-- Quel est le prix unitaire moyen ?
SELECT AVG(prix_unitaire) AS prix_moyen
FROM ventes;
-- Résultat : 478.75
-- Explication : (1200 + 25 + 75 + 1200 + 350 + 25) / 6

-- Quantité moyenne par vente
SELECT AVG(quantite) AS quantite_moyenne
FROM ventes;
-- Résultat : 3.33

-- =====================================================
-- EXEMPLE 4 : MAX et MIN — Extrêmes
-- =====================================================

-- Quel est le prix unitaire le plus élevé ?
SELECT MAX(prix_unitaire) AS prix_max,
       MIN(prix_unitaire) AS prix_min
FROM ventes;
-- Résultat : prix_max = 1200.00, prix_min = 25.00

-- =====================================================
-- EXEMPLE 5 : Combinaison d'agrégations
-- =====================================================

-- Vue d'ensemble statistique des ventes
SELECT
  COUNT(*) AS nombre_ventes,
  COUNT(DISTINCT produit) AS nombre_produits,
  SUM(quantite) AS quantite_totale,
  AVG(quantite) AS quantite_moyenne,
  MIN(prix_unitaire) AS prix_min,
  MAX(prix_unitaire) AS prix_max,
  ROUND(AVG(prix_unitaire), 2) AS prix_moyen_arrondi
FROM ventes;

-- =====================================================
-- VARIANTE : Agrégations avec filtrage
-- =====================================================

-- Revenu total uniquement pour les ventes de Laptops
SELECT
  SUM(quantite * prix_unitaire) AS revenu_laptops
FROM ventes
WHERE produit = 'Laptop';
-- Résultat : 2400.00 (1×1200 + 2×1200)

-- Nombre de ventes au-delà de 2 unités
SELECT COUNT(*) AS ventes_volumeuses
FROM ventes
WHERE quantite > 2;
-- Résultat : 3

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE ventes;
