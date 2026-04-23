# Types de données SQL par moteur

Les types varient selon le moteur. Ce tableau couvre les cas les plus courants.

---

## Numériques

| Catégorie | Standard SQL | MySQL | PostgreSQL | SQL Server | SQLite |
|-----------|-------------|-------|-----------|-----------|--------|
| Entier petit | `SMALLINT` | `SMALLINT` | `SMALLINT` | `SMALLINT` | `INTEGER` |
| Entier | `INTEGER` | `INT` | `INTEGER` | `INT` | `INTEGER` |
| Entier grand | `BIGINT` | `BIGINT` | `BIGINT` | `BIGINT` | `INTEGER` |
| Auto-incrément | — | `INT AUTO_INCREMENT` | `SERIAL` / `BIGSERIAL` | `INT IDENTITY(1,1)` | `INTEGER PRIMARY KEY` |
| Décimal exact | `DECIMAL(p,s)` | `DECIMAL(p,s)` | `NUMERIC(p,s)` | `DECIMAL(p,s)` | `REAL` |
| Flottant | `FLOAT` | `FLOAT` | `REAL` / `DOUBLE PRECISION` | `FLOAT` | `REAL` |

> `p` = précision totale (nb de chiffres), `s` = échelle (chiffres après la virgule).  
> ⚠️ `FLOAT` et `DOUBLE` sont approximatifs — ne pas utiliser pour des montants financiers. Utiliser `DECIMAL`.

---

## Chaînes de caractères

| Type | Description | MySQL | PostgreSQL | SQL Server |
|------|-------------|-------|-----------|-----------|
| `CHAR(n)` | Longueur fixe, complété par des espaces | ✓ | ✓ | ✓ |
| `VARCHAR(n)` | Longueur variable, max n caractères | ✓ | ✓ | ✓ |
| `TEXT` | Texte long (taille variable, non limité) | ✓ | ✓ | `VARCHAR(MAX)` |
| `NVARCHAR(n)` | Unicode (UTF-16) | `VARCHAR` + charset | `VARCHAR` (UTF-8 natif) | ✓ |

> ⚠️ En MySQL, `CHAR(n)` et `VARCHAR(n)` comptent les **caractères**, pas les octets, si le charset est UTF-8.

---

## Dates et heures

| Type | Contenu | MySQL | PostgreSQL | SQL Server | SQLite |
|------|---------|-------|-----------|-----------|--------|
| `DATE` | Année-Mois-Jour | ✓ | ✓ | ✓ | `TEXT` |
| `TIME` | Heure-Min-Sec | ✓ | ✓ | ✓ | `TEXT` |
| `DATETIME` | Date + heure (sans fuseau) | ✓ | `TIMESTAMP` | `DATETIME` | `TEXT` |
| `TIMESTAMP` | Date + heure (avec fuseau) | ✓ (UTC) | `TIMESTAMPTZ` | `DATETIMEOFFSET` | `INTEGER` |
| `INTERVAL` | Durée | ✗ | ✓ | ✗ | ✗ |

---

## Booléens

| Moteur | Type | Valeurs |
|--------|------|---------|
| PostgreSQL | `BOOLEAN` | `TRUE`, `FALSE`, `NULL` |
| MySQL | `TINYINT(1)` | `1` (vrai), `0` (faux) — pas de type booléen natif |
| SQL Server | `BIT` | `1`, `0`, `NULL` |
| SQLite | `INTEGER` | `1`, `0` |

---

## Binaires et JSON

| Type | Usage | Disponibilité |
|------|-------|--------------|
| `BLOB` / `BYTEA` | Données binaires brutes | MySQL (`BLOB`), PostgreSQL (`BYTEA`) |
| `JSON` | Données JSON non indexables | MySQL 5.7+, PostgreSQL 9.2+ |
| `JSONB` | JSON binaire indexable | PostgreSQL uniquement |
| `XML` | Données XML | SQL Server, PostgreSQL |

---

## Conseils de choix

| Besoin | Type recommandé |
|--------|----------------|
| Identifiant auto | `SERIAL` (PostgreSQL) / `INT AUTO_INCREMENT` (MySQL) |
| Montant financier | `DECIMAL(15, 2)` — jamais `FLOAT` |
| Texte court fixe (code pays, etc.) | `CHAR(2)` |
| Texte court variable | `VARCHAR(255)` |
| Texte long | `TEXT` |
| Date seule | `DATE` |
| Horodatage avec fuseau | `TIMESTAMPTZ` (PostgreSQL) |
| Indicateur vrai/faux | `BOOLEAN` si disponible, sinon `TINYINT(1)` |
