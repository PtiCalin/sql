# Cheat Sheet : Identification des clés candidates

## Définitions

| Terme | Définition |
|-------|-----------|
| **Clé candidate** | Ensemble **minimal** d'attributs qui identifie **uniquement** chaque tuple |
| **Clé primaire** | Une clé candidate choisie comme identifiant principal (une seule par table) |
| **Super-clé** | Ensemble d'attributs identifiant les tuples (peut être non-minimal) |
| **Clé étrangère** | Attribut référençant la clé primaire d'une autre table |

---

## Procédure d'identification

### Étape 1 : Énumère TOUTES les super-clés

Quels ensembles d'attributs identifient **uniquement** les tuples ?

```
Exemple : EMPLOYE(id, matricule, nom, prenom, email, id_dept)

Super-clés possibles :
  - {id}
  - {matricule}
  - {email}
  - {id, matricule}
  - {id, nom, prenom}
  - {id, matricule, email}
  - ... etc
```

### Étape 2 : Filtre les minimales

Une super-clé est une **clé candidate** si aucun sous-ensemble n'en est une super-clé.

```
{id} :
  - Est-ce minimal ? Oui (pas de sous-ensemble non vide)
  → Clé candidate ✓

{matricule} :
  - Est-ce minimal ? Oui
  → Clé candidate ✓

{id, matricule} :
  - Est-ce minimal ? Non ({id} seul suffit)
  → Pas une clé candidate ✗

{email} :
  - Est-ce minimal ? Oui
  → Clé candidate ✓
```

### Étape 3 : Valide avec les dépendances fonctionnelles

Pour chaque clé candidate K, **toutes les autres attributs** doivent dépendre fonctionnellement de K.

```
Si K = {id} :
  id → matricule ?  Oui
  id → nom ?        Oui
  id → prenom ?     Oui
  id → email ?      Oui
  id → id_dept ?    Oui
  → {id} est une clé candidate ✓

Si K = {nom, prenom} :
  nom ∧ prenom → id ?  Peut-être pas (deux personnes avec même nom/prénom)
  → {nom, prenom} est-elle une clé candidate ? Non ✗
```

---

## Cas courants

### 1. Clé simple (un attribut)

```
COURS(sigle, titre, credits)
Clé candidate : {sigle}  (chaque cours a un sigle unique)
```

### 2. Clé composée (obligatoire)

```
S_INSCRIT(matricule, sigle, note)
Une même personne peut s'inscrire à plusieurs cours.
Un même cours peut avoir plusieurs étudiants.
Clé candidate : {matricule, sigle}  (la paire identifie une inscription)
```

### 3. Plusieurs clés candidates

```
PROFESSEUR(id_prof, matricule_national, email)
Si tous trois identifient UNIQUEMENT un prof :
Clés candidates : {id_prof}, {matricule_national}, {email}
Clé primaire choisie (une seule) : {id_prof}
```

### 4. Clé candidate composée complexe

```
RESERVATION(id_hotel, id_chambre, date_arrivee, date_depart)
Une chambre ne peut pas être réservée deux fois pour les mêmes dates.
Clé candidate : {id_hotel, id_chambre, date_arrivee}
(ou {id_hotel, id_chambre, date_depart} selon les règles)
```

---

## Pièges à connaître

❌ **Piège 1** : Confondre "unique" avec "clé candidate"

```
ETUDIANT(matricule, nom, numero_telephone)

numero_telephone est UNIQUE mais pas une clé candidate si :
  - Deux étudiants peuvent partager un numéro (colocataires)
  - Ou si NULL est possible
```

✅ **Solution** : Une clé candidate doit identifier **chaque ligne** sans ambiguïté.

---

❌ **Piège 2** : Oublier les clés candidates composées

```
TABLE(A, B, C, D)
Si seul {A, B} identifie les tuples, ce n'est pas {A} ou {B} seul.
```

---

❌ **Piège 3** : Confondre clé candidate et clé étrangère

```
EMPLOYE(id, nom, id_dept)

{id} est une clé candidate (identifie un employé)
{id_dept} est une clé étrangère (référence une autre table)
```

---

## Questions d'examen typiques

### Format A : Donner les clés candidates

> *Schéma : RESERVATION(id_client, id_hotel, date_arrivee, date_depart, montant)*
> 
> *Énoncé : Chaque client ne peut réserver qu'une chambre par hôtel pour une période donnée.*
>
> **Réponse** : Clés candidates = {id_client, id_hotel, date_arrivee} ou {id_client, id_hotel, date_depart}

### Format B : Justifier pourquoi X est/n'est pas une clé candidate

> *X = {id_client, id_hotel}*
> 
> **Réponse** : Non, car deux réservations du même client au même hôtel pour des périodes différentes auraient la même clé. Il faut ajouter la date.

### Format C : Choisir la meilleure clé primaire

> *Clés candidates : {id}, {email}, {nom, prenom}*
>
> **Réponse** : {id} — la plus courte, la plus stable (noms/emails changent).
