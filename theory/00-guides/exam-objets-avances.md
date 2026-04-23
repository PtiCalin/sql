# Cheat Sheet : Vues, Procédures, Fonctions, Déclencheurs

## Tableau comparatif

| Objet | Syntaxe | Retour | Utilisable dans SELECT | Modifie données | Cas d'usage |
|-------|---------|--------|-------|----------|-----------|
| **Vue** | `CREATE VIEW` | Table virtuelle | Oui | Rarement | Requêtes réutilisables, sécurité |
| **Procédure** | `CREATE PROCEDURE` | Rien (OUT param) | Non | Oui | Logique métier complexe, appels répétés |
| **Fonction** | `CREATE FUNCTION` | Valeur scalaire ou table | Oui (scalaire) | Rarement | Calculer une valeur, traiter données |
| **Déclencheur** | `CREATE TRIGGER` | — | Non | Oui | Actions automatiques (audit, validation) |

---

## VUES (`VIEW`)

**Qu'est-ce** : Requête nommée et sauvegardée = table virtuelle.

```sql
CREATE VIEW etudiants_actifs AS
SELECT matricule, nom, prenom
FROM etudiant
WHERE statut = 'ACTIF';

SELECT * FROM etudiants_actifs;  -- Utilisation simple
```

**Avantages** :
- Simplification de requêtes complexes
- Masquer certaines colonnes (sécurité)
- Réutilisabilité
- Maintenance centralisée

**Limites** :
- Ne stocke pas les données (requête exécutée à chaque appel)
- Mise à jour complexe, souvent en lecture seule

**Quand l'utiliser** :
- Requête SELECT fréquemment utilisée
- Besoin de simplifier l'accès aux données
- Sécurité (restreindre les colonnes/lignes)

---

## PROCÉDURES (`PROCEDURE`)

**Qu'est-ce** : Programme SQL sauvegardé côté serveur, appelé avec `CALL`.

```sql
CREATE PROCEDURE inscrire_etudiant(
    IN p_matricule INT,
    IN p_sigle CHAR(10),
    OUT p_statut VARCHAR(100)
)
BEGIN
    INSERT INTO s_inscrit(matricule, sigle)
    VALUES (p_matricule, p_sigle);
    
    SET p_statut = 'Inscription réussie';
END;

CALL inscrire_etudiant(12345, 'IFT2821', @resultat);
SELECT @resultat;  -- Accéder au paramètre OUT
```

**Paramètres** :
- `IN` : valeur en entrée
- `OUT` : retour de valeur
- `INOUT` : en entrée ET sortie

**Avantages** :
- Logique complexe
- Performance (côté serveur)
- Transactions

**Limites** :
- Pas callable directement dans SELECT
- Pas de valeur de retour (seulement OUT)

**Quand l'utiliser** :
- Opérations multi-étapes
- Logique métier à sécuriser
- Besoin de transactions explicites

---

## FONCTIONS (`FUNCTION`)

**Qu'est-ce** : Comme une procédure, mais retourne UNE valeur = utilisable dans SELECT.

### Fonction scalaire (valeur simple)

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

-- Utilisation
SELECT nom, moyenne_etudiant(matricule) AS moyenne
FROM etudiant;
```

### Fonction retournant une table

```sql
CREATE FUNCTION etudiants_par_dept(p_dept VARCHAR)
RETURNS TABLE(matricule INT, nom VARCHAR, programme VARCHAR)
BEGIN
    RETURN (
        SELECT matricule, nom, programme
        FROM etudiant
        WHERE programme = p_dept
    );
END;

-- Utilisation
SELECT * FROM etudiants_par_dept('INFO');
```

**Avantages** :
- Utilisable dans SELECT (comme une fonction native)
- Encapsulation de logique
- Réutilisabilité

**⚠️ Performance** : Une fonction scalaire appelée ligne par ligne = très lent. Préférer un JOIN si possible.

---

## DÉCLENCHEURS (`TRIGGER`)

**Qu'est-ce** : Code qui s'exécute automatiquement lors d'une opération (INSERT, UPDATE, DELETE).

```sql
CREATE TRIGGER audit_modification_etudiant
AFTER UPDATE ON etudiant
FOR EACH ROW
BEGIN
    INSERT INTO audit_etudiant(id_etudiant, ancienne_valeur, nouvelle_valeur, moment)
    VALUES (
        OLD.matricule,
        CONCAT(OLD.nom, ' ', OLD.prenom),
        CONCAT(NEW.nom, ' ', NEW.prenom),
        NOW()
    );
END;
```

### Syntaxe complète

```
CREATE TRIGGER nom
[BEFORE | AFTER]            -- Avant ou après l'opération
[INSERT | UPDATE | DELETE]  -- Quelle opération
ON table
FOR EACH ROW                -- Pour chaque ligne affectée
BEGIN
    -- Code (peut utiliser OLD.colonne et NEW.colonne)
END;
```

### OLD et NEW

```sql
-- OLD.colonne : ancienne valeur (INSERT/UPDATE/DELETE)
-- NEW.colonne : nouvelle valeur (INSERT/UPDATE, NULL pour DELETE)

BEFORE UPDATE ON employe
FOR EACH ROW
BEGIN
    IF NEW.salaire < OLD.salaire THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Baisse de salaire interdite';
    END IF;
END;
```

**Avantages** :
- Audit automatique
- Validation métier
- Calculs automatiques (colonnes dérivées)
- Maintenir la cohérence

**Limites** :
- Complexité (difficile à déboguer)
- Performance (exécuté pour chaque ligne)
- Non interopérable (chaque SGBD a sa syntaxe)

**Quand l'utiliser** :
- Audit (tracer les modifications)
- Validation (empêcher certaines opérations)
- Maintenance d'historique
- Cohérence des données

---

## Décisions pratiques

| Besoin | Utiliser |
|--------|----------|
| Simplifier une requête SELECT récurrente | Vue |
| Logique métier multi-étapes | Procédure |
| Calculer une valeur dans SELECT | Fonction scalaire |
| Tracer les modifications | Déclencheur |
| Valider les données avant insertion | Déclencheur BEFORE ou contrainte CHECK |
| Opération batch (INSERT/UPDATE massif) | Procédure |
| Sécurité (masquer colonnes) | Vue |

---

## Pièges courants

❌ **Piège 1** : Fonction scalaire dans SELECT sur grosse table = Très lent

```sql
-- ❌ LENT : fonction appelée pour chaque ligne
SELECT nom, moyenne_etudiant(matricule) FROM etudiant;

-- ✅ RAPIDE : jointure
SELECT e.nom, AVG(si.note)
FROM etudiant e
LEFT JOIN s_inscrit si ON e.matricule = si.matricule
GROUP BY e.matricule, e.nom;
```

❌ **Piège 2** : Déclencheur causant une cascade infinie

```sql
-- ❌ DANGER : UPDATE dans AFTER UPDATE = déclencheur re-exécuté
AFTER UPDATE ON employe
FOR EACH ROW
BEGIN
    UPDATE employe SET date_modification = NOW() WHERE matricule = NEW.matricule;
    -- Ça re-déclenche ce même trigger !
END;

-- ✅ Utiliser BEFORE UPDATE
BEFORE UPDATE ON employe
FOR EACH ROW
BEGIN
    SET NEW.date_modification = NOW();
END;
```

❌ **Piège 3** : OLD/NEW confusion

```sql
-- DELETE : OLD a les anciennes valeurs, NEW est NULL
-- INSERT : OLD est NULL, NEW a les nouvelles valeurs
-- UPDATE : OLD a ancien, NEW a nouveau
```
