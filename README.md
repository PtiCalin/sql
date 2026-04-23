# Base de données & SQL — Base de connaissances

Dépôt centralisé pour l'apprentissage et la maîtrise de SQL, des bases de données relationnelles et de la conception de schémas. Structure pédagogique progressive, fondée sur des principes éprouvés.

---

## Structure du dépôt

```
sql/
├── theory/          # Fondements conceptuels, organisés par progression
│   ├── 01-fondements/               # Modèle relationnel, SGBD, concepts de base
│   ├── 02-modelisation/             # Modèle E-A, schéma relationnel, normalisation
│   ├── 03-algebre-relationnelle/    # Algèbre relationnelle formelle
│   ├── 04-langage-sql/              # DDL, DML, DQL, DCL, TCL
│   ├── 05-normalisation/            # Dépendances fonctionnelles, 1NF–BCNF
│   └── 06-sql-avance/               # Vues, procédures, fonctions, curseurs, déclencheurs
│
├── examples/        # Requêtes annotées et exécutables, par thème
│   ├── fondamentaux/                # SELECT, WHERE, ORDER BY, LIMIT
│   ├── jointures/                   # INNER, LEFT, RIGHT, FULL, CROSS, SELF
│   ├── agregations/                 # GROUP BY, HAVING, fonctions d'agrégat
│   ├── sous-requetes/               # Sous-requêtes scalaires, corrélées, tables
│   ├── cte/                         # Clauses WITH, CTEs récursives
│   ├── fonctions-fenetres/          # ROW_NUMBER, RANK, LEAD/LAG, PARTITION BY
│   ├── ddl/                         # CREATE, ALTER, DROP, contraintes
│   └── avance/                      # Procédures, fonctions, vues, curseurs
│
├── exercises/       # Problèmes progressifs avec solutions
│   ├── 01-modelisation/             # Conception de schémas, normalisation
│   ├── 02-requetes-de-base/         # SELECT, filtres, tri
│   ├── 03-jointures/                # Requêtes multi-tables
│   ├── 04-agregations/              # GROUP BY, HAVING
│   ├── 05-sous-requetes/            # Requêtes imbriquées
│   ├── 06-avance/                   # CTEs, fonctions fenêtres, procédures
│   └── solutions/                   # Solutions commentées
│
├── reference/       # Aide-mémoire et références rapides
│   ├── syntaxe-sql.md               # Référence syntaxique complète
│   ├── types-de-donnees.md          # Types par moteur (PostgreSQL, MySQL, SQLite…)
│   ├── fonctions-integrees.md       # Fonctions natives par catégorie
│   └── erreurs-courantes.md         # Erreurs fréquentes et solutions
│
├── engines/         # Guides spécifiques par moteur de base de données
│   ├── postgresql/
│   ├── mysql/
│   ├── sql-server/
│   └── sqlite/
│
├── resources/       # Ressources externes annotées
│   ├── cours.md                     # Cours et formations recommandés
│   ├── livres.md                    # Livres de référence
│   └── articles.md                 # Articles et lectures ciblées
│
└── tools/           # Scripts, schémas de démonstration, utilitaires
    ├── schemas/                     # Bases de données d'exemple (cours, exercices)
    └── scripts/                     # Scripts utilitaires
```

---

## Parcours d'apprentissage recommandés

### Débutant — Maîtriser les bases SQL
1. [`theory/01-fondements/`](theory/01-fondements/) — Qu'est-ce qu'une BD ? Le modèle relationnel
2. [`theory/02-modelisation/`](theory/02-modelisation/) — Concevoir un schéma (E-A → relationnel)
3. [`theory/04-langage-sql/`](theory/04-langage-sql/) — Syntaxe SQL fondamentale
4. [`examples/fondamentaux/`](examples/fondamentaux/) — Requêtes de base annotées
5. [`exercises/02-requetes-de-base/`](exercises/02-requetes-de-base/) — Mettre en pratique

### Intermédiaire — Requêtes complexes et conception
1. [`theory/05-normalisation/`](theory/05-normalisation/) — Dépendances fonctionnelles, formes normales
2. [`examples/jointures/`](examples/jointures/) + [`examples/agregations/`](examples/agregations/)
3. [`examples/sous-requetes/`](examples/sous-requetes/) + [`examples/cte/`](examples/cte/)
4. [`exercises/03-jointures/`](exercises/03-jointures/) à [`exercises/05-sous-requetes/`](exercises/05-sous-requetes/)

### Avancé — SQL professionnel
1. [`theory/06-sql-avance/`](theory/06-sql-avance/) — Vues, procédures, fonctions, curseurs
2. [`examples/fonctions-fenetres/`](examples/fonctions-fenetres/) — Fonctions analytiques
3. [`examples/avance/`](examples/avance/) — Patterns avancés
4. [`engines/`](engines/) — Spécificités par moteur

---

## Aide-mémoire rapide

| Besoin | Aller à |
|--------|---------|
| Syntaxe d'une commande | [`reference/syntaxe-sql.md`](reference/syntaxe-sql.md) |
| Types de données | [`reference/types-de-donnees.md`](reference/types-de-donnees.md) |
| Fonctions natives | [`reference/fonctions-integrees.md`](reference/fonctions-integrees.md) |
| Déboguer une erreur | [`reference/erreurs-courantes.md`](reference/erreurs-courantes.md) |
| Cours IFT2821 (UdeM) | [`theory/`](theory/) — PDFs des modules 1–5 + suppléments |

---

## Conventions

- Chaque dossier contient un `README.md` qui définit les **objectifs d'apprentissage** et les **prérequis**.
- Les exemples sont **annotés** : chaque étape non triviale est expliquée.
- Les exercices sont **progressifs** : du rappel à l'application à la synthèse.
- Les solutions sont dans [`exercises/solutions/`](exercises/solutions/) — essayez d'abord.
