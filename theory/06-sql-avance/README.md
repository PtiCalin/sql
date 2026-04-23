# Module 6 — SQL avancé : vues, procédures, fonctions, curseurs

**Prérequis :** Module 4 (langage SQL)  
**Matériaux de référence :**
- `../BDD - Les vues.pdf`
- `../BDD - Les procédures stockées.pdf`
- `../BDD - Les fonctions stockées.pdf`
- `../BDD - Les curseurs.pdf`

---

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Créer et utiliser des vues pour encapsuler des requêtes complexes
- Écrire des procédures stockées avec paramètres IN/OUT
- Implémenter des fonctions retournant une valeur ou une table
- Utiliser un curseur pour traiter des résultats ligne par ligne
- Comprendre quand utiliser chaque objet et leurs compromis

---

## Objets SQL avancés

### Vues (`VIEW`)

> **Intuition** : Une vue est une requête nommée et sauvegardée — elle se comporte comme une table mais ne stocke pas de données.

```sql
CREATE VIEW etudiants_actifs AS
SELECT matricule, nom, prenom
FROM etudiant
WHERE statut = 'ACTIF';

-- Utilisation
SELECT * FROM etudiants_actifs WHERE nom = 'Martin';
```

**Avantages** : simplification, sécurité (masquer des colonnes), réutilisabilité.  
**Limite** : Les vues ne sont généralement pas mises à jour directement (dépend du moteur).

---

### Procédures stockées

> **Intuition** : Un programme SQL réutilisable stocké côté serveur — s'exécute avec `CALL`, peut modifier des données, n'a pas de valeur de retour directe.

```sql
CREATE PROCEDURE inscrire_etudiant(
    IN p_matricule INT,
    IN p_sigle CHAR(10)
)
BEGIN
    INSERT INTO s_inscrit(matricule, sigle)
    VALUES (p_matricule, p_sigle);
END;

CALL inscrire_etudiant(12345, 'IFT2821');
```

---

### Fonctions stockées

> **Intuition** : Comme une procédure, mais retourne une valeur — utilisable directement dans une requête SELECT.

```sql
CREATE FUNCTION moyenne_etudiant(p_matricule INT)
RETURNS DECIMAL(5,2)
BEGIN
    DECLARE v_moy DECIMAL(5,2);
    SELECT AVG(note) INTO v_moy
    FROM s_inscrit
    WHERE matricule = p_matricule;
    RETURN v_moy;
END;

-- Utilisation dans une requête
SELECT nom, moyenne_etudiant(matricule) AS moyenne
FROM etudiant;
```

---

### Curseurs

> **Intuition** : Un curseur permet de traiter un ensemble de résultats **ligne par ligne** — à utiliser uniquement quand une opération ensembliste ne suffit pas.

```sql
DECLARE cur CURSOR FOR
    SELECT matricule, note FROM s_inscrit WHERE sigle = 'IFT2821';

OPEN cur;
FETCH cur INTO v_matricule, v_note;
-- traitement...
CLOSE cur;
```

> **Avertissement** : Les curseurs sont lents sur de grands volumes. Préférez toujours les opérations ensemblistes (UPDATE, INSERT…SELECT) quand c'est possible.

---

## Comparatif

| Objet | Retourne | Utilisable dans SELECT | Modifie des données |
|-------|----------|----------------------|---------------------|
| Vue | Table virtuelle | Oui | Non (en général) |
| Procédure | Rien (ou OUT params) | Non | Oui |
| Fonction | Une valeur scalaire | Oui | Oui (avec précautions) |
| Curseur | Ligne par ligne | Non | Oui (dans procédure) |

---

## Vérifiez votre compréhension

1. Quand préférer une **vue** à une **sous-requête** dans le FROM ? Quand est-ce l'inverse ?
2. Quelle est la différence fondamentale entre une **procédure** et une **fonction** en SQL ?
3. Pourquoi les curseurs sont-ils généralement **déconseillés** pour de grands volumes ? Proposez une alternative ensembliste pour un cas typique.
