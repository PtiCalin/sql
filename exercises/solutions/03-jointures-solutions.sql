-- Solutions : 03-jointures

-- EX01
SELECT e.nom, e.programme, i.sigle
FROM etudiants e
JOIN inscriptions i ON i.matricule = e.matricule;

-- EX02
SELECT c.sigle, c.titre, e.nom
FROM cours c
JOIN inscriptions i ON i.sigle = c.sigle
JOIN etudiants e ON e.matricule = i.matricule
WHERE i.session = 'A24';

-- EX03
SELECT e.*
FROM etudiants e
LEFT JOIN inscriptions i ON i.matricule = e.matricule
WHERE i.matricule IS NULL;

-- EX04
SELECT c.sigle, c.titre, COUNT(i.matricule) AS nb_inscriptions
FROM cours c
LEFT JOIN inscriptions i ON i.sigle = c.sigle
GROUP BY c.sigle, c.titre
ORDER BY nb_inscriptions DESC, c.sigle ASC;

-- EX05
SELECT e1.matricule AS m1, e1.nom AS nom1,
       e2.matricule AS m2, e2.nom AS nom2,
       e1.programme
FROM etudiants e1
JOIN etudiants e2
  ON e1.programme = e2.programme
 AND e1.matricule < e2.matricule;
