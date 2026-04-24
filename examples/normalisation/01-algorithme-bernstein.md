# Algorithme de Bernstein — Synthèse en 3NF

L'algorithme de Bernstein (1976) produit une **décomposition en 3NF sans perte de dépendances** à partir d'un ensemble de dépendances fonctionnelles.

---

## Vue d'ensemble de l'algorithme

```
Entrée  : Schéma R(U), ensemble de DFs F
Sortie  : Décomposition D = {R1, R2, …, Rk} en 3NF,
          sans perte de dépendances (et sans perte d'information si on applique l'étape 4)

Étape 1 – Couverture minimale de F
Étape 2 – Regroupement des DFs de même partie gauche
Étape 3 – Création des schémas
Étape 4 – Ajout d'une clé si aucun schéma n'en contient une
Étape 5 – Suppression des schémas redondants
```

---

## Exemple 1 — Inscription universitaire

### Relation initiale

```
INSCRIPTION(matricule, cours_id, nom_etudiant, email, titre_cours, dept_cours, note)
```

### Dépendances fonctionnelles

```
F = {
  matricule  → nom_etudiant, email
  cours_id   → titre_cours, dept_cours
  matricule, cours_id → note
}
```

---

### Étape 1 — Couverture minimale

**1a. Décomposer les parties droites (forme standard)**

```
matricule  → nom_etudiant
matricule  → email
cours_id   → titre_cours
cours_id   → dept_cours
matricule, cours_id → note
```

**1b. Réduire les parties gauches (test de redondance)**

Pour `matricule, cours_id → note` :
- Peut-on déduire `note` depuis `matricule` seul ?
  Fermeture `{matricule}⁺ = {matricule, nom_etudiant, email}` — ne contient pas `note` ✗
- Peut-on déduire `note` depuis `cours_id` seul ?
  Fermeture `{cours_id}⁺ = {cours_id, titre_cours, dept_cours}` — ne contient pas `note` ✗

→ La partie gauche est déjà minimale.

**1c. Supprimer les DFs redondantes**

Aucune DF n'est impliquée par les autres → couverture minimale = F lui-même.

---

### Étape 2 — Regrouper par partie gauche

```
G1 : matricule  → nom_etudiant, email
G2 : cours_id   → titre_cours, dept_cours
G3 : {matricule, cours_id} → note
```

---

### Étape 3 — Créer les schémas

| Schéma | Attributs |
|--------|-----------|
| R1 | matricule, nom_etudiant, email |
| R2 | cours_id, titre_cours, dept_cours |
| R3 | matricule, cours_id, note |

---

### Étape 4 — Vérifier qu'une clé est présente

Clé de INSCRIPTION : `{matricule, cours_id}` → présente dans R3 ✓

---

### Étape 5 — Supprimer les schémas redondants

Aucun schéma n'est sous-ensemble d'un autre → tous conservés.

---

### Résultat en SQL

```sql
CREATE TABLE Etudiant (
    matricule   CHAR(8)      PRIMARY KEY,
    nom_etudiant VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Cours (
    cours_id    CHAR(6)      PRIMARY KEY,
    titre_cours  VARCHAR(200) NOT NULL,
    dept_cours   VARCHAR(100) NOT NULL
);

CREATE TABLE Inscription (
    matricule   CHAR(8)   NOT NULL REFERENCES Etudiant(matricule),
    cours_id    CHAR(6)   NOT NULL REFERENCES Cours(cours_id),
    note        NUMERIC(4,2),
    PRIMARY KEY (matricule, cours_id)
);
```

---

## Exemple 2 — Couverture minimale non triviale

### Relation initiale

```
VENTE(vendeur, region, produit, categorie, commission_taux)
```

### Dépendances fonctionnelles initiales

```
F = {
  vendeur           → region
  region, produit   → commission_taux
  vendeur, produit  → commission_taux     ← possiblement redondante
  produit           → categorie
}
```

---

### Étape 1 — Couverture minimale

**1a. Parties droites déjà atomiques** ✓

**1b. Réduire les parties gauches**

Pour `vendeur, produit → commission_taux` :
- Fermeture `{vendeur}⁺ = {vendeur, region}` → pas `commission_taux` ✗
- Fermeture `{produit}⁺ = {produit, categorie}` → pas `commission_taux` ✗
→ Partie gauche minimale.

**1c. Supprimer les DFs redondantes**

Test de `vendeur, produit → commission_taux` :
- On sait `vendeur → region` et `region, produit → commission_taux`
- Donc : vendeur → region et (region + produit) → commission_taux
- Or `{vendeur, produit}⁺` sans cette DF = `{vendeur, produit, region, categorie, commission_taux}`
  (en utilisant les trois autres DFs)

→ `vendeur, produit → commission_taux` est **redondante** ← à supprimer.

**Couverture minimale retenue :**

```
Fm = {
  vendeur          → region
  region, produit  → commission_taux
  produit          → categorie
}
```

---

### Étapes 2–5

| Groupe | Schéma | Attributs |
|--------|--------|-----------|
| G1 | R1 | vendeur, region |
| G2 | R2 | region, produit, commission_taux |
| G3 | R3 | produit, categorie |

**Étape 4** : Clé de VENTE = `{vendeur, produit}`.  
Aucun schéma ne la contient → on ajoute :

| Schéma | Attributs |
|--------|-----------|
| R4 | vendeur, produit *(schéma clé)* |

**Étape 5** : R4 ⊄ R1, R4 ⊄ R2 → aucun schéma redondant.

---

### Résultat en SQL

```sql
CREATE TABLE Vendeur (
    vendeur VARCHAR(100) PRIMARY KEY,
    region  VARCHAR(100) NOT NULL
);

CREATE TABLE Produit (
    produit   VARCHAR(100) PRIMARY KEY,
    categorie VARCHAR(100) NOT NULL
);

CREATE TABLE TauxCommission (
    region  VARCHAR(100) NOT NULL,
    produit VARCHAR(100) NOT NULL REFERENCES Produit(produit),
    commission_taux NUMERIC(5,4) NOT NULL,
    PRIMARY KEY (region, produit)
);

-- Schéma clé (ajouté à l'étape 4) — peut être intégré à une table de faits
CREATE TABLE Vente (
    vendeur VARCHAR(100) NOT NULL REFERENCES Vendeur(vendeur),
    produit VARCHAR(100) NOT NULL REFERENCES Produit(produit),
    PRIMARY KEY (vendeur, produit)
);
```

---

## Récapitulatif des étapes

| Étape | Action | But |
|-------|--------|-----|
| 1a | Décomposer les parties droites | Un seul attribut par DF |
| 1b | Réduire les parties gauches | Supprimer les attributs inutiles |
| 1c | Supprimer les DFs redondantes | Couverture minimale |
| 2  | Regrouper par partie gauche | Un schéma par groupe |
| 3  | Créer un schéma par groupe | Chaque schéma est en 3NF |
| 4  | Ajouter une clé si absente | Garantit sans-perte d'information |
| 5  | Supprimer les schémas redondants | Éviter les doublons |

---

## Propriétés garanties

- ✅ Chaque schéma résultant est en **3NF**
- ✅ La décomposition **préserve toutes les dépendances** de Fm
- ✅ Si l'étape 4 est appliquée, la jointure naturelle est **sans perte d'information**
- ⚠️ Ne garantit **pas** BCNF (pour BCNF, utiliser l'algorithme de décomposition BCNF)

---

*Référence : P. Bernstein, « Synthesizing Third Normal Form Relations from Functional Dependencies », ACM TODS, 1976.*
