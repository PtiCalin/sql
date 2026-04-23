-- Solutions : 04-agregations

-- EX01
SELECT COUNT(*) AS nb_lignes FROM notes;

-- EX02
SELECT sigle, COUNT(note) AS nb_notes_non_null
FROM notes
GROUP BY sigle;

-- EX03
SELECT sigle, AVG(note) AS moyenne
FROM notes
WHERE note IS NOT NULL
GROUP BY sigle
ORDER BY moyenne DESC;

-- EX04
SELECT matricule, AVG(note) AS moyenne
FROM notes
WHERE note IS NOT NULL
GROUP BY matricule
HAVING COUNT(note) >= 2;

-- EX05
SELECT sigle, AVG(note) AS moyenne_cours
FROM notes
WHERE note IS NOT NULL
GROUP BY sigle
HAVING AVG(note) > (
    SELECT AVG(note)
    FROM notes
    WHERE note IS NOT NULL
);
