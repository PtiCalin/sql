-- ============================================================
-- Jointures : INNER, LEFT, RIGHT, FULL OUTER, CROSS, auto-jointure
-- Prérequis : fondamentaux/01-select-where-order.sql
--             theory/04-langage-sql/ (section jointures)
-- ============================================================

-- Schéma de référence :
--   ETUDIANT(matricule, nom, prenom, programme)
--   COURS(sigle, titre, credits, departement)
--   S_INSCRIT(matricule FK, sigle FK, note, session)
--   PROFESSEUR(id_prof, nom, departement)
--   ENSEIGNE(id_prof FK, sigle FK, session)

-- ------------------------------------------------------------
-- 1. INNER JOIN — intersection (correspondances des deux côtés)
-- ------------------------------------------------------------

-- Étudiants avec leurs cours
SELECT e.nom, e.prenom, c.titre, si.note
FROM etudiant e
    INNER JOIN s_inscrit si ON e.matricule = si.matricule
    INNER JOIN cours c      ON si.sigle = c.sigle;

-- ⚠️ Les étudiants sans inscription N'APPARAISSENT PAS dans un INNER JOIN.


-- ------------------------------------------------------------
-- 2. LEFT JOIN — tous les tuples de gauche, même sans correspondance
-- ------------------------------------------------------------

-- Tous les étudiants, avec leurs cours s'ils en ont (NULL sinon)
SELECT e.nom, e.prenom, c.titre
FROM etudiant e
    LEFT JOIN s_inscrit si ON e.matricule = si.matricule
    LEFT JOIN cours c      ON si.sigle = c.sigle;

-- Cas d'usage typique : trouver les étudiants SANS aucune inscription
SELECT e.nom, e.prenom
FROM etudiant e
    LEFT JOIN s_inscrit si ON e.matricule = si.matricule
WHERE si.matricule IS NULL;  -- ⚠️ La condition NULL est dans WHERE, pas dans ON


-- ------------------------------------------------------------
-- 3. RIGHT JOIN — tous les tuples de droite
-- ------------------------------------------------------------

-- Tous les cours, avec les étudiants inscrits (NULL si aucun inscrit)
SELECT c.sigle, c.titre, e.nom
FROM etudiant e
    RIGHT JOIN s_inscrit si ON e.matricule = si.matricule
    RIGHT JOIN cours c      ON si.sigle = c.sigle;

-- 💡 Un RIGHT JOIN peut toujours être réécrit en LEFT JOIN en inversant les tables.
--    Préférer LEFT JOIN par convention pour la lisibilité.


-- ------------------------------------------------------------
-- 4. FULL OUTER JOIN — tous les tuples des deux tables
-- ------------------------------------------------------------

-- Tous les étudiants et tous les cours, avec correspondances où elles existent
-- (Non supporté nativement par MySQL — utiliser UNION de LEFT + RIGHT)
SELECT e.nom, c.titre
FROM etudiant e
    FULL OUTER JOIN s_inscrit si ON e.matricule = si.matricule
    FULL OUTER JOIN cours c      ON si.sigle = c.sigle;


-- ------------------------------------------------------------
-- 5. CROSS JOIN — produit cartésien
-- ------------------------------------------------------------

-- Toutes les combinaisons possibles étudiant × cours (rarement utile directement)
SELECT e.nom, c.titre
FROM etudiant e
    CROSS JOIN cours c;

-- ⚠️ Sur N étudiants et M cours, le résultat a N×M lignes.


-- ------------------------------------------------------------
-- 6. Auto-jointure — jointure d'une table sur elle-même
-- ------------------------------------------------------------

-- Exemple : trouver les étudiants du même programme (paires)
-- Les alias sont OBLIGATOIRES pour distinguer les deux instances
SELECT a.nom AS etudiant_1, b.nom AS etudiant_2, a.programme
FROM etudiant a
    JOIN etudiant b ON a.programme = b.programme AND a.matricule < b.matricule;

-- ⚠️ La condition a.matricule < b.matricule évite (A,B) ET (B,A) dans le résultat.
