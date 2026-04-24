# Guide complet : Clés candidates et Normalisation (1NF → 3NF)

> Référence progressive : identifier les clés, lire les dépendances fonctionnelles, normaliser étape par étape.

---

## Table des matières

1. [Hiérarchie des clés](#hiérarchie-des-clés)
2. [Dépendances fonctionnelles](#dépendances-fonctionnelles)
3. [Identifier les clés candidates — méthode pas-à-pas](#identifier-les-clés-candidates)
4. [Exemples de clés candidates](#exemples-de-clés-candidates)
5. [Pièges sur les clés](#pièges-sur-les-clés)
6. [1NF — Première forme normale](#1nf--première-forme-normale)
7. [2NF — Deuxième forme normale](#2nf--deuxième-forme-normale)
8. [3NF — Troisième forme normale](#3nf--troisième-forme-normale)
9. [Processus de normalisation complet (exemple guidé)](#processus-de-normalisation-complet)
10. [Questions d'examen typiques](#questions-dexamen-typiques)

---

## Hiérarchie des clés

```
Super-clé
  └─ Clé candidate  (super-clé minimale)
       └─ Clé primaire  (une clé candidate choisie)
       └─ Clé alternate  (clé candidate non choisie comme primaire)
```

| Terme             | Définition                                                      | Propriétés                               |
| ----------------- | --------------------------------------------------------------- | ---------------------------------------- |
| **Super-clé**     | Ensemble d'attributs identifiant uniquement chaque tuple        | Unicité                                  |
| **Clé candidate** | Super-clé **minimale** (supprimer un attribut = perd l'unicité) | Unicité + Minimalité                     |
| **Clé primaire**  | Clé candidate choisie comme identifiant officiel                | Unicité + NOT NULL + une seule par table |
| **Clé alternate** | Clé candidate **non choisie** comme primaire                    | Unicité (souvent UNIQUE en SQL)          |
| **Clé composite** | Clé formée de **plusieurs attributs**                           | —                                        |
| **Clé étrangère** | Attribut référençant la clé primaire d'une autre table          | Intégrité référentielle                  |

---

## Dépendances fonctionnelles

### Définition

Une **dépendance fonctionnelle** (DF) `X → Y` signifie :

> "Connaître X permet de déterminer Y de façon unique."

**Intuition** : Si deux tuples ont la même valeur pour X, ils ont nécessairement la même valeur pour Y.

```
Exemples :
  matricule → nom              (connaître le matricule → connaître le nom)
  (num_cmd, num_produit) → qte (connaître la paire → connaître la quantité)
  code_postal → ville          (un code postal correspond à une ville)
```

### Types de dépendances fonctionnelles

| Type           | Définition                              | Exemple                                           |
| -------------- | --------------------------------------- | ------------------------------------------------- |
| **Complète**   | Y dépend de **tous** les attributs de X | `(matricule, sigle) → note`                       |
| **Partielle**  | Y dépend d'un **sous-ensemble** de X    | `sigle → titre` dans `(matricule, sigle) → titre` |
| **Transitive** | Y dépend de Z, et Z dépend de X         | `id → id_dept → nom_dept`                         |

### Comment identifier une DF

Poser la question :

> "Si deux tuples ont la même valeur pour **X**, auront-ils toujours la même valeur pour **Y** ?"

- **Oui → X → Y est une DF**
- **Non → X → Y n'est pas une DF**

```
TABLE : EMPLOYE(id, nom, id_dept, nom_dept)

id → nom ?         Oui (un id = un seul employé = un seul nom)     ✓
id_dept → nom_dept ? Oui (un dept_id = un seul département)         ✓
nom → id ?         Non (deux personnes peuvent avoir le même nom)  ✗
id → id_dept ?     Oui                                              ✓
id → nom_dept ?    Oui, mais via id_dept (transitive !)             ⚠️
```

---

## Identifier les clés candidates

### Méthode formelle (3 étapes)

#### Étape 1 — Lire les données et l'énoncé

Avant toute analyse formelle, **compter les lignes du jeu de données** et repérer les doublons éventuels sur chaque attribut.

```
Exemple : VENTE(vendeur, produit, region, montant)

Jeu de données :
  Dupont  | Stylo | Nord  | 50
  Dupont  | Stylo | Sud   | 30     ← même (vendeur, produit), région différente
  Martin  | Stylo | Nord  | 40
  Dupont  | Crayon| Nord  | 20

Observation :
  - vendeur seul : Dupont apparaît 3 fois → pas une clé
  - produit seul : Stylo apparaît 3 fois  → pas une clé
  - region seul : Nord apparaît 3 fois    → pas une clé
  - (vendeur, produit) : (Dupont, Stylo) apparaît 2 fois → pas une clé
  - (vendeur, region) : chaque paire est unique → clé candidate possible
  - (produit, region) : (Stylo, Nord) apparaît 2 fois → pas une clé
  - (vendeur, produit, region) : chaque triplet unique → super-clé, mais minimale ?
```

#### Étape 2 — Lister les dépendances fonctionnelles

À partir de l'énoncé et du jeu de données, écrire **toutes les DF** connues.

```
Exemple : EMPLOYE(id, matricule, nom, prenom, email, id_dept)

DF issues de l'énoncé :
  id → {matricule, nom, prenom, email, id_dept}  (l'id identifie tout)
  matricule → {id, nom, prenom, email, id_dept}  (le matricule identifie tout)
  email → {id, matricule, nom, prenom, id_dept}  (email unique)
```

#### Étape 3 — Trouver les super-clés minimales

Un ensemble `K` est une clé candidate si :

1. `K → tous les autres attributs` (super-clé)
2. Aucun sous-ensemble propre de `K` n'est une super-clé (minimalité)

```
{id} → {matricule, nom, prenom, email, id_dept} ? Oui → super-clé
  Peut-on enlever un attribut ? {id} n'a qu'un élément → minimal ✓
  → {id} est une clé candidate ✓

{id, matricule} → tous ? Oui → super-clé
  Peut-on enlever matricule ? {id} seul suffit → {id, matricule} non minimal ✗
  → {id, matricule} n'est PAS une clé candidate

{email} → tous ? Oui → super-clé
  Minimal (un seul attribut) ✓
  → {email} est une clé candidate ✓
```

---

## Exemples de clés candidates

### Cas 1 — Clé simple unique

```
COURS(sigle, titre, credits)

Jeu de données :
  IFT2821 | Bases de données | 3
  IFT1015 | Programmation I  | 3
  MAT1400 | Calcul I         | 3

DF : sigle → {titre, credits}

Clés candidates : {sigle}
Clé primaire : {sigle}
```

### Cas 2 — Plusieurs clés candidates simples

```
PROFESSEUR(id_prof, matricule, email, nom)

DF :
  id_prof   → {matricule, email, nom}
  matricule → {id_prof, email, nom}
  email     → {id_prof, matricule, nom}

Clés candidates : {id_prof}, {matricule}, {email}
Clé primaire choisie : {id_prof}
Clés alternates : {matricule}, {email}  (→ déclarées UNIQUE en SQL)
```

### Cas 3 — Clé composite obligatoire

```
INSCRIPTION(matricule, sigle, note, semestre)

Contexte : un étudiant peut s'inscrire plusieurs fois à un cours (différents semestres).
           un étudiant ne peut s'inscrire qu'une fois par cours par semestre.

DF :
  (matricule, sigle, semestre) → note

Sous-ensembles testés :
  {matricule} → tous ? Non (plusieurs cours)        ✗
  {sigle} → tous ? Non (plusieurs étudiants)        ✗
  {matricule, sigle} → tous ? Non (plusieurs semestres) ✗
  {matricule, sigle, semestre} → note ? Oui          ✓ → clé candidate

Clé candidate : {matricule, sigle, semestre}
```

### Cas 4 — Clé composite avec plusieurs candidates

```
HORAIRE(id_salle, jour, heure_debut, id_cours, id_prof)

Règles métier :
  - Une salle ne peut pas accueillir deux cours en même temps.
  - Un prof ne peut pas donner deux cours en même temps.

DF :
  (id_salle, jour, heure_debut) → {id_cours, id_prof}
  (id_prof, jour, heure_debut)  → {id_cours, id_salle}

Clés candidates :
  {id_salle, jour, heure_debut}
  {id_prof, jour, heure_debut}

Clé primaire choisie : {id_salle, jour, heure_debut}
```

### Cas 5 — Clé déduite du contexte, pas des données seules

```
TEMPERATURE(ville, date, heure, temperature_c)

Données :
  Montréal | 2024-01-01 | 08:00 | -12
  Montréal | 2024-01-01 | 12:00 | -5
  Montréal | 2024-01-02 | 08:00 | -8
  Québec   | 2024-01-01 | 08:00 | -15

Analyse :
  ville seul → pas unique
  (ville, date) → pas unique (plusieurs heures)
  (ville, date, heure) → unique ✓ et minimal ✓

Clé candidate : {ville, date, heure}
```

---

## Pièges sur les clés

❌ **Piège 1 — Inférer une clé à partir d'un jeu de données incomplet**

```
Données :
  A  | B  | C
  1  | 10 | X
  2  | 20 | Y
  3  | 10 | Z

Attention : {B} semble non-unique (B=10 apparaît deux fois).
Mais {A} semble unique dans ces 3 lignes.

→ Ne jamais conclure "A est une clé" à partir de 3 lignes.
   Il peut y avoir A=1 deux fois dans une vraie base.
   Toujours valider avec l'énoncé ou les DF.
```

✅ **La règle** : Les clés se définissent par les **contraintes métier** et les **dépendances fonctionnelles**, pas seulement les données visibles.

---

❌ **Piège 2 — Oublier qu'une clé candidate peut être composée**

```
TRAJET(depart, arrivee, heure, duree_min)

Si l'on peut partir de la même ville, vers la même destination, à des heures différentes :
  {depart, arrivee} ne suffit pas
  {depart, arrivee, heure} est la clé candidate

→ Tester toujours les ensembles de 2, 3, ... attributs.
```

---

❌ **Piège 3 — Confondre clé étrangère et clé candidate**

```
COMMANDE(id_cmd, id_client, date_cmd, montant)

{id_cmd}    : clé candidate (identifie une commande)       ✓
{id_client} : clé étrangère (référence la table CLIENT)    ≠ clé candidate
              (un client peut passer plusieurs commandes)
```

---

❌ **Piège 4 — Croire que "unique dans les données" = clé candidate**

```
EMPLOYE(id, nom, telephone)

Si par hasard tous les téléphones sont différents dans le jeu de test,
ce n'est pas une clé candidate si deux employés POURRAIENT partager un téléphone.

→ Les DF et les règles métier priment sur les données.
```

---

## 1NF — Première forme normale

### Définition

> Une relation est en **1NF** si tous ses attributs sont **atomiques** :
> chaque cellule contient une valeur unique, non divisible.

### Violations de 1NF

**Violation A — Attribut multi-valué** (plusieurs valeurs dans une cellule)

```
❌ ETUDIANT(matricule, nom, cours)
   1001 | Dupont | IFT1015, IFT2821, MAT1400   ← trois cours dans une cellule

✅ Solution : une ligne par cours
   INSCRIPTION(matricule, sigle)
   1001 | IFT1015
   1001 | IFT2821
   1001 | MAT1400
```

**Violation B — Groupe répété** (colonnes numérotées pour le même concept)

```
❌ ETUDIANT(matricule, nom, cours1, cours2, cours3)
   1001 | Dupont | IFT1015 | IFT2821 | NULL   ← colonnes répétées

✅ Solution : table séparée
   INSCRIPTION(matricule FK, sigle FK)
```

**Violation C — Attribut non-atomique** (adresse comme un seul champ)

```
❌ CLIENT(id, adresse)
   1 | "123 rue Principale, Montréal, QC, H2X 1Y3"

✅ Solution : décomposer l'attribut
   CLIENT(id, numero_rue, rue, ville, province, code_postal)
```

### Étapes pour mettre en 1NF

```
1. Identifier tout attribut contenant plusieurs valeurs ou répété.
2. Créer une table séparée pour la valeur répétée.
3. Lier par une clé étrangère.
4. Vérifier que chaque cellule contient une valeur atomique.
```

### Exemple complet : 1NF

```
❌ Avant (pas en 1NF) :
   PROJET(id_proj, titre, membres)
   P001 | Refonte web | Alice, Bob, Charlie
   P002 | App mobile  | Bob, Diana

Problèmes :
  - membres est multi-valué
  - Impossible d'interroger "tous les projets de Bob" efficacement

✅ Après (en 1NF) :
   PROJET(id_proj, titre)
   P001 | Refonte web
   P002 | App mobile

   MEMBRE_PROJET(id_proj FK, employe FK)
   P001 | Alice
   P001 | Bob
   P001 | Charlie
   P002 | Bob
   P002 | Diana
```

---

## 2NF — Deuxième forme normale

### Définition

> Une relation est en **2NF** si elle est en 1NF **et** qu'il n'existe aucune **dépendance partielle** :
> tout attribut non-clé dépend de la **totalité** de la clé primaire.

**Ne s'applique qu'aux relations avec une clé primaire composée.**
Si la clé primaire est simple (un seul attribut), la relation est automatiquement en 2NF si elle est en 1NF.

### Dépendance partielle

```
Clé primaire composée : (A, B)
Attribut C dépend seulement de A (pas de B) → dépendance PARTIELLE → viole 2NF
```

### Exemple pas-à-pas

```
❌ Avant (en 1NF, mais pas en 2NF) :
   COMMANDE_DETAIL(num_cmd, num_produit, quantite, nom_produit, prix_unitaire)

   Clé primaire : (num_cmd, num_produit)

   Toutes les DF :
     (num_cmd, num_produit) → quantite      ✓ dépend de toute la clé
     num_produit → nom_produit              ⚠️ PARTIELLE : dépend de num_produit seulement
     num_produit → prix_unitaire            ⚠️ PARTIELLE

   Anomalies :
     - Insertion : Impossible d'ajouter un produit sans commande
     - Mise à jour : Changer le prix d'un produit oblige à MAJ toutes les lignes
     - Suppression : Supprimer la dernière commande d'un produit perd le produit
```

#### Étape 1 — Identifier les dépendances partielles

```
(num_cmd, num_produit) → quantite      → COMPLÈTE ✓
num_produit → nom_produit              → PARTIELLE ✗
num_produit → prix_unitaire            → PARTIELLE ✗
```

#### Étape 2 — Extraire chaque dépendance partielle dans sa propre table

```
Règle : Pour chaque dépendance partielle X → Y,
        créer une table (X, Y) et retirer Y de la table d'origine.
```

#### Étape 3 — Résultat final

```
✅ Après (en 2NF) :

   COMMANDE_DETAIL(num_cmd, num_produit FK, quantite)
     Clé : (num_cmd, num_produit)
     DF : (num_cmd, num_produit) → quantite   ✓ complète

   PRODUIT(num_produit, nom_produit, prix_unitaire)
     Clé : num_produit
     DF : num_produit → {nom_produit, prix_unitaire}
```

### Exemple 2 — Table d'inscription avec infos redondantes

```
❌ Avant :
   INSCRIPTION(matricule, sigle, note, titre_cours, credits, nom_etudiant)
   Clé primaire : (matricule, sigle)

   DF :
     (matricule, sigle) → note          ✓ complète
     sigle → {titre_cours, credits}     ✗ partielle (sur sigle seul)
     matricule → nom_etudiant           ✗ partielle (sur matricule seul)

✅ Après :
   INSCRIPTION(matricule FK, sigle FK, note)
   COURS(sigle, titre_cours, credits)
   ETUDIANT(matricule, nom_etudiant)
```

---

## 3NF — Troisième forme normale

### Définition

> Une relation est en **3NF** si elle est en 2NF **et** qu'il n'existe aucune **dépendance transitive** :
> aucun attribut non-clé ne dépend d'un autre attribut non-clé.

### Dépendance transitive

```
Clé primaire : A
Attributs non-clés : B, C

Si A → B et B → C
Alors A → C est TRANSITIVE (via B)
→ viole 3NF
```

### Exemple pas-à-pas

```
❌ Avant (en 2NF, mais pas en 3NF) :
   EMPLOYE(id, nom, id_dept, nom_dept, budget_dept)
   Clé primaire : id

   DF :
     id → nom              ✓ directe
     id → id_dept          ✓ directe
     id → nom_dept         ⚠️ TRANSITIVE : id → id_dept → nom_dept
     id → budget_dept      ⚠️ TRANSITIVE : id → id_dept → budget_dept
     id_dept → nom_dept    ← la dépendance intermédiaire (non-clé → non-clé)
     id_dept → budget_dept ← idem
```

#### Étape 1 — Identifier les chaînes de dépendances

```
Chercher le schéma : (clé) → X → Y  où X est un attribut non-clé

id → id_dept → nom_dept     ⚠️ transitive
id → id_dept → budget_dept  ⚠️ transitive
```

#### Étape 2 — Extraire chaque dépendance transitive

```
Règle : Pour chaque dépendance transitive X → Y (X non-clé),
        créer une table (X, Y) et retirer Y de la table d'origine.
        X reste dans la table d'origine comme clé étrangère.
```

#### Étape 3 — Résultat

```
✅ Après (en 3NF) :

   EMPLOYE(id, nom, id_dept FK)
     DF : id → {nom, id_dept}   — toutes directes ✓

   DEPARTEMENT(id_dept, nom_dept, budget_dept)
     DF : id_dept → {nom_dept, budget_dept} ✓
```

### Exemple 2 — Code postal et ville

```
❌ Avant :
   LIVRAISON(id_livraison, adresse, code_postal, ville, province)
   Clé primaire : id_livraison

   DF :
     id_livraison → {adresse, code_postal}  ✓
     code_postal → {ville, province}        ⚠️ transitive
     id_livraison → ville                   ⚠️ via code_postal

✅ Après :
   LIVRAISON(id_livraison, adresse, code_postal FK)
   CODE_POSTAL(code_postal, ville, province)
```

### Exemple 3 — Employé, projet et compétences

```
❌ Avant :
   AFFECTATION(id_employe, id_projet, role, salaire_employe, budget_projet)
   Clé primaire : (id_employe, id_projet)

   DF :
     (id_employe, id_projet) → role         ✓ complète
     id_employe → salaire_employe           ✗ partielle (2NF)
     id_projet → budget_projet              ✗ partielle (2NF)

✅ Après 2NF :
   AFFECTATION(id_employe FK, id_projet FK, role)
   EMPLOYE(id_employe, salaire_employe, ...)
   PROJET(id_projet, budget_projet, ...)

   → Déjà en 3NF si pas de transitives dans les nouvelles tables.
```

---

## Processus de normalisation complet

> Exemple guidé de bout-en-bout : d'une table à plat jusqu'en 3NF.

### Table de départ (non normalisée)

```
FACTURE(
  num_facture,
  date_facture,
  id_client,
  nom_client,
  adresse_client,
  code_postal,
  ville,
  num_produit,
  nom_produit,
  categorie_produit,
  quantite,
  prix_unitaire
)
```

### Étape 0 — Analyser les DF

```
num_facture → {date_facture, id_client}
id_client   → {nom_client, adresse_client, code_postal}
code_postal → {ville}
num_produit → {nom_produit, categorie_produit, prix_unitaire}
(num_facture, num_produit) → quantite
```

### Étape 1 — Mettre en 1NF

La table est déjà en 1NF (les attributs sont atomiques).
Mais elle contient des données groupées (une facture peut avoir plusieurs produits).

```
Après 1NF : chaque ligne = une ligne-produit de la facture
FACTURE_LIGNE(
  num_facture, date_facture, id_client, nom_client, adresse_client,
  code_postal, ville, num_produit, nom_produit, categorie_produit,
  quantite, prix_unitaire
)
Clé primaire : (num_facture, num_produit)
```

### Étape 2 — Mettre en 2NF

Identifier les dépendances partielles (attributs dépendant d'un sous-ensemble de la clé) :

```
Clé : (num_facture, num_produit)

Partielles :
  num_facture → {date_facture, id_client, nom_client, adresse_client, code_postal, ville}
  num_produit → {nom_produit, categorie_produit, prix_unitaire}

Complète :
  (num_facture, num_produit) → quantite  ✓
```

Décomposer :

```
FACTURE(num_facture, date_facture, id_client, nom_client, adresse_client, code_postal, ville)
PRODUIT(num_produit, nom_produit, categorie_produit, prix_unitaire)
LIGNE_FACTURE(num_facture FK, num_produit FK, quantite)
```

### Étape 3 — Mettre en 3NF

Inspecter chaque table pour des dépendances transitives :

```
Dans FACTURE :
  num_facture → id_client  ✓
  id_client   → {nom_client, adresse_client, code_postal}  ⚠️ transitive
  code_postal → ville  ⚠️ transitive dans FACTURE

  → Extraire CLIENT et CODE_POSTAL
```

Résultat final :

```
✅ Schéma en 3NF :

FACTURE(num_facture, date_facture, id_client FK)
CLIENT(id_client, nom_client, adresse_client, code_postal FK)
CODE_POSTAL(code_postal, ville)
PRODUIT(num_produit, nom_produit, categorie_produit, prix_unitaire)
LIGNE_FACTURE(num_facture FK, num_produit FK, quantite)
```

### Tableau récapitulatif des anomalies évitées

| Forme   | Anomalie ciblée                        | Règle                                              |
| ------- | -------------------------------------- | -------------------------------------------------- |
| **1NF** | Données non-atomiques, groupes répétés | Attributs simples, une valeur par cellule          |
| **2NF** | Dépendance partielle sur clé composée  | Tout attribut non-clé dépend de TOUTE la clé       |
| **3NF** | Dépendance transitive via un non-clé   | Tout attribut non-clé dépend DIRECTEMENT de la clé |

---

## Questions d'examen typiques

### Format A — Identifier les clés candidates

> _Schéma : VOL(num_vol, compagnie, depart, arrivee, heure_dep, heure_arr)_
>
> _Règle : Un numéro de vol est unique par compagnie. Une compagnie ne peut pas avoir deux vols avec le même numéro._

```
DF :
  (num_vol, compagnie) → {depart, arrivee, heure_dep, heure_arr}
  num_vol seul → pas d'identification (deux compagnies peuvent avoir le même num_vol)

Clé candidate : {num_vol, compagnie}
```

---

### Format B — Justifier qu'un ensemble est/n'est pas une clé candidate

> _Schéma : SEANCE(id_salle, jour, heure, id_film, id_animateur)_
>
> _X = {id_salle, jour}. Est-ce une clé candidate ?_

```
Réponse :
  Non. Deux séances dans la même salle le même jour mais à des heures différentes
  auraient la même valeur pour (id_salle, jour).
  Il faut ajouter heure : {id_salle, jour, heure} est une clé candidate.
```

---

### Format C — Identifier les formes normales

> _Schéma : INSCRIPTION(matricule, sigle, note, nom_cours, nom_etudiant)_
> _Clé : (matricule, sigle)_

```
1NF ? Oui (attributs atomiques)

2NF ?
  sigle → nom_cours          ← partielle ✗
  matricule → nom_etudiant   ← partielle ✗
  → Non en 2NF

3NF ? Non (pas en 2NF → pas en 3NF non plus)

Solution pour 2NF :
  INSCRIPTION(matricule FK, sigle FK, note)
  COURS(sigle, nom_cours)
  ETUDIANT(matricule, nom_etudiant)

Chaque table résultante est aussi en 3NF (pas de transitives).
```

---

### Format D — Normaliser une table de A à Z

> _Schéma : RESERVATION(id_res, id_client, nom_client, id_hotel, nom_hotel, ville_hotel, date_arrivee, date_depart, montant)_

```
Étape 0 — DF :
  id_res → {id_client, id_hotel, date_arrivee, date_depart, montant}
  id_client → nom_client
  id_hotel → {nom_hotel, ville_hotel}

Étape 1 — 1NF : ✓ (attributs atomiques)

Étape 2 — 2NF :
  Clé simple (id_res) → pas de dépendance partielle possible.
  Mais il y a des transitives !

Étape 3 — 3NF :
  id_res → id_client → nom_client    ⚠️ transitive
  id_res → id_hotel → {nom_hotel, ville_hotel}  ⚠️ transitive

Résultat final :
  RESERVATION(id_res, id_client FK, id_hotel FK, date_arrivee, date_depart, montant)
  CLIENT(id_client, nom_client)
  HOTEL(id_hotel, nom_hotel, ville_hotel)
```
