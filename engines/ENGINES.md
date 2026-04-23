# Moteurs de bases de données

Guides des différences et spécificités par moteur. Le SQL standard couvre ~80% des cas — ces dossiers documentent le 20% qui diverge.

## Moteurs couverts

| Dossier | Moteur | Usage typique |
|---------|--------|--------------|
| [`postgresql/`](postgresql/) | PostgreSQL | Applications web, analytique, open-source enterprise |
| [`mysql/`](mysql/) | MySQL / MariaDB | Web, LAMP stack, très répandu |
| [`sql-server/`](sql-server/) | Microsoft SQL Server | Environnements Windows, .NET, enterprise |
| [`sqlite/`](sqlite/) | SQLite | Embarqué, prototypage, applications mobiles |

## Ce que chaque guide couvre

1. Installation et configuration locale
2. Types de données spécifiques
3. Fonctions propres au moteur
4. Extensions SQL (JSON, arrays, full-text search…)
5. Optimisation et index spécifiques
6. Gotchas et pièges à connaître
