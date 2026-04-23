-- Solutions : 05-sous-requetes

-- EX01
SELECT *
FROM notes
WHERE note > (
    SELECT AVG(note) FROM notes WHERE note IS NOT NULL
);

-- EX02
SELECT *
FROM etudiants
WHERE matricule IN (
    SELECT matricule
    FROM notes
    WHERE sigle = 'IFT2821'
);

-- EX03
SELECT e.*
FROM etudiants e
WHERE EXISTS (
    SELECT 1
    FROM notes n
    WHERE n.matricule = e.matricule
      AND n.note > 90
);

-- EX04
SELECT e.matricule, e.nom,
       (
           SELECT MAX(n.note)
           FROM notes n
           WHERE n.matricule = e.matricule
       ) AS meilleure_note
FROM etudiants e;

-- EX05
SELECT e.matricule, e.nom, e.programme
FROM etudiants e
WHERE (
    SELECT AVG(n1.note)
    FROM notes n1
    WHERE n1.matricule = e.matricule
      AND n1.note IS NOT NULL
) > (
    SELECT AVG(n2.note)
    FROM notes n2
    JOIN etudiants e2 ON e2.matricule = n2.matricule
    WHERE e2.programme = e.programme
      AND n2.note IS NOT NULL
);
