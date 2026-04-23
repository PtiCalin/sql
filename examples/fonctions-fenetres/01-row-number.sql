/*
  =====================================================
  Titre : Fonctions fenêtrées — ROW_NUMBER, RANK, DENSE_RANK
  Démontre : Numéroter et classer les lignes
  Prérequis : GROUP BY, ORDER BY
  =====================================================

  Les fonctions fenêtrées (window functions) appliquent une opération
  à un "fenêtre" d'enregistrements sans les regrouper.
  ROW_NUMBER assigne un numéro unique à chaque ligne.
  RANK et DENSE_RANK gèrent les égalités.
*/

-- Schéma de démonstration
CREATE TABLE ventes (
  id INT PRIMARY KEY,
  vendeur VARCHAR(50),
  mois VARCHAR(10),
  montant INT
);

-- Données
INSERT INTO ventes VALUES
  (1, 'Alice', 'Jan', 5000),
  (2, 'Bob',   'Jan', 4500),
  (3, 'Charlie', 'Jan', 5000),
  (4, 'Alice', 'Feb', 6000),
  (5, 'Bob',   'Feb', 4800),
  (6, 'Charlie', 'Feb', 6000),
  (7, 'David', 'Feb', 3500),
  (8, 'Alice', 'Mar', 5500);

-- =====================================================
-- EXEMPLE 1 : ROW_NUMBER — Numéro unique par ligne
-- =====================================================

-- Chaque vente avec son numéro d'ordre (globalement)
SELECT
  vendeur,
  mois,
  montant,
  ROW_NUMBER() OVER (ORDER BY montant DESC) AS rang_global
FROM ventes;

/*
Résultat :
  vendeur  mois  montant  rang_global
  Alice    Feb   6000     1
  Charlie  Feb   6000     2           <- ROW_NUMBER donne 2, pas 1
  Alice    Jan   5000     3
  Charlie  Jan   5000     4
  Alice    Mar   5500     5
  Bob      Feb   4800     6
  Bob      Jan   4500     7
  David    Feb   3500     8

Explication :
  - Chaque ligne reçoit un numéro unique, même en cas d'égalité
  - Alice et Charlie ont tous deux 6000, mais 2 reçoit le rang 2
*/

-- =====================================================
-- EXEMPLE 2 : ROW_NUMBER avec PARTITION
-- =====================================================

-- Le TOP vendeur de chaque mois
SELECT
  vendeur,
  mois,
  montant,
  ROW_NUMBER() OVER (PARTITION BY mois ORDER BY montant DESC) AS rang_dans_mois
FROM ventes;

/*
Résultat :
  vendeur  mois  montant  rang_dans_mois
  Alice    Feb   6000     1
  Charlie  Feb   6000     2
  David    Feb   3500     3           <- David dans son mois
  Bob      Feb   4800     4
  Alice    Jan   5000     1           <- Alice "réinitialise" à 1 pour Jan
  Charlie  Jan   5000     2
  Bob      Jan   4500     3
  Alice    Mar   5500     1           <- Alice "réinitialise" à 1 pour Mar

Explication :
  - PARTITION BY crée des "fenêtres" distinctes pour chaque mois
  - Chaque mois a sa propre numérotation (1, 2, 3...)
*/

-- =====================================================
-- EXEMPLE 3 : RANK vs DENSE_RANK — Gérer les égalités
-- =====================================================

SELECT
  vendeur,
  mois,
  montant,
  ROW_NUMBER() OVER (ORDER BY montant DESC) AS row_num,
  RANK() OVER (ORDER BY montant DESC) AS rank_val,
  DENSE_RANK() OVER (ORDER BY montant DESC) AS dense_rank
FROM ventes;

/*
Résultat :
  vendeur   mois  montant  row_num  rank_val  dense_rank
  Alice     Feb   6000     1        1         1
  Charlie   Feb   6000     2        1         1           <- RANK aussi = 1
  Alice     Jan   5000     3        3         2           <- RANK saute à 3
  Charlie   Jan   5000     4        3         2
  Alice     Mar   5500     5        5         3
  Bob       Feb   4800     6        6         4
  Bob       Jan   4500     7        7         5
  David     Feb   3500     8        8         6

Explication :
  - ROW_NUMBER : 1,2,3,4,5,6,7,8 (toujours unique)
  - RANK : 1,1,3,3,5,6,7,8 (saute les rangs en cas d'égalité)
  - DENSE_RANK : 1,1,2,2,3,4,5,6 (pas de saut)

  Utiliser RANK() pour des compétitions, DENSE_RANK() pour des seuils
*/

-- =====================================================
-- EXEMPLE 4 : Filtrer avec ROW_NUMBER
-- =====================================================

-- Le top 2 vendeur de chaque mois (utiliser une subquery)
WITH ranked_ventes AS (
  SELECT
    vendeur,
    mois,
    montant,
    ROW_NUMBER() OVER (PARTITION BY mois ORDER BY montant DESC) AS rang
  FROM ventes
)
SELECT vendeur, mois, montant
FROM ranked_ventes
WHERE rang <= 2;

/*
Résultat :
  vendeur  mois  montant
  Alice    Feb   6000
  Charlie  Feb   6000
  Alice    Jan   5000
  Charlie  Jan   5000
  Alice    Mar   5500
*/

-- =====================================================
-- EXEMPLE 5 : Pagination avec ROW_NUMBER
-- =====================================================

-- Page 2 de 3 résultats (5-6)
WITH numbered_rows AS (
  SELECT
    vendeur,
    mois,
    montant,
    ROW_NUMBER() OVER (ORDER BY vendeur, mois) AS row_num
  FROM ventes
)
SELECT vendeur, mois, montant
FROM numbered_rows
WHERE row_num BETWEEN 5 AND 7;

/*
Résultat :
  vendeur  mois  montant
  Bob      Jan   4500
  Bob      Feb   4800
  Charlie  Jan   5000
*/

-- =====================================================
-- EXEMPLE 6 : Comparer avec le précédent
-- =====================================================

-- Le LAG / LEAD pour obtenir la valeur précédente/suivante
SELECT
  vendeur,
  mois,
  montant,
  LAG(montant) OVER (PARTITION BY vendeur ORDER BY mois) AS prev_mois,
  LEAD(montant) OVER (PARTITION BY vendeur ORDER BY mois) AS next_mois,
  montant - LAG(montant) OVER (PARTITION BY vendeur ORDER BY mois) AS difference
FROM ventes;

/*
Résultat :
  vendeur  mois  montant  prev_mois  next_mois  difference
  Alice    Jan   5000     [NULL]     6000       [NULL]
  Alice    Feb   6000     5000       5500       1000
  Alice    Mar   5500     6000       [NULL]     -500
  Bob      Jan   4500     [NULL]     4800       [NULL]
  Bob      Feb   4800     4500       [NULL]     300
  Charlie  Jan   5000     [NULL]     6000       [NULL]
  Charlie  Feb   6000     5000       [NULL]     1000
  David    Feb   3500     [NULL]     [NULL]     [NULL]

Explication :
  - LAG(n, 1) retourne la valeur n lignes précédentes
  - LEAD(n, 1) retourne la valeur n lignes suivantes
  - NULL si pas de ligne précédente/suivante
*/

-- =====================================================
-- EXEMPLE 7 : Premier et dernier par groupe
-- =====================================================

-- Premier et dernier record de chaque vendeur
WITH ranked AS (
  SELECT
    vendeur,
    mois,
    montant,
    ROW_NUMBER() OVER (PARTITION BY vendeur ORDER BY mois) AS first_rank,
    ROW_NUMBER() OVER (PARTITION BY vendeur ORDER BY mois DESC) AS last_rank
  FROM ventes
)
SELECT
  vendeur,
  MAX(CASE WHEN first_rank = 1 THEN montant END) AS premiere_vente,
  MAX(CASE WHEN last_rank = 1 THEN montant END) AS derniere_vente
FROM ranked
GROUP BY vendeur;

/*
Résultat :
  vendeur  premiere_vente  derniere_vente
  Alice    5000            5500
  Bob      4500            4800
  Charlie  5000            6000
  David    3500            3500
*/

-- =====================================================
-- EXEMPLE 8 : Identifier les runs (séquences)
-- =====================================================

-- Détecter quand un vendeur change (create "runs")
SELECT
  vendeur,
  mois,
  montant,
  ROW_NUMBER() OVER (ORDER BY mois) AS row_num,
  ROW_NUMBER() OVER (ORDER BY vendeur) AS vendor_row,
  ROW_NUMBER() OVER (ORDER BY vendeur) - ROW_NUMBER() OVER (ORDER BY mois) AS run_id
FROM ventes;

-- Cela permet de grouper des séquences d'enregistrements

-- =====================================================
-- Nettoyage (optionnel)
-- =====================================================
-- DROP TABLE ventes;
