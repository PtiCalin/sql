# Guides et références — Ressources rapides

Ce dossier contient des guides thématiques et des références pour compléter la théorie.

---

## 📚 Ressources disponibles

| Guide | Description |
|-------|-------------|
| [**glossaire.md**](glossaire.md) | 📖 Dictionnaire complet des termes SQL (A-Z, par catégorie) |
| [**syntaxe-sql.md**](syntaxe-sql.md) | ⚙️ Référence syntaxe DDL, DML, DQL |
| [**types-de-donnees.md**](types-de-donnees.md) | 🔢 Types de données SQL et leurs propriétés |
| [**erreurs-courantes.md**](erreurs-courantes.md) | ⚠️ Pièges et erreurs à éviter |
| [**exam-sql-general.md**](exam-sql-general.md) | 📝 Points clés pour les examens SQL généraux |
| [**exam-jointures.md**](exam-jointures.md) | 📝 Comprendre et maîtriser les JOINs |
| [**exam-normalisation.md**](exam-normalisation.md) | 📝 Formes normales et normalisation |
| [**exam-cles-candidates.md**](exam-cles-candidates.md) | 📝 Clés, candidats, primaires |
| [**exam-objets-avances.md**](exam-objets-avances.md) | 📝 Vues, procédures, triggers |

---

## 🎯 Comment naviguer

### Je ne connais pas un terme → [Glossaire](glossaire.md)
Recherche alphabétiquement ou par catégorie (DDL, DML, fenêtres, etc.).

**Exemple** : Qu'est-ce qu'une **CTE RECURSIVE** ?
→ Consulte [glossaire.md → CTE RECURSIVE](glossaire.md#cte-recursive)

---

### Je veux voir la syntaxe exacte → [Syntaxe SQL](syntaxe-sql.md)
Tous les formats de commandes SQL avec `[ ]` optionnels.

**Exemple** : Comment écrire exactement un `ALTER TABLE` ?
→ Consulte [syntaxe-sql.md → DDL](syntaxe-sql.md)

---

### Je veux connaître les types disponibles → [Types de données](types-de-donnees.md)
INT, VARCHAR, DATE, DECIMAL, BOOLEAN, etc.

**Exemple** : Quelle est la différence entre `VARCHAR(100)` et `TEXT` ?
→ Consulte [types-de-donnees.md](types-de-donnees.md)

---

### Je fais une erreur → [Erreurs courantes](erreurs-courantes.md)
Pièges courants, solutions, et bonne pratiques.

**Exemple** : Ma requête retourne NULL au lieu du résultat attendu.
→ Consulte [erreurs-courantes.md](erreurs-courantes.md)

---

### Je prépare un examen → Consultez les fichiers `exam-*.md`

- **exam-sql-general.md** — Vue d'ensemble SQL
- **exam-jointures.md** — Maîtriser tous les types de JOIN
- **exam-normalisation.md** — Formes normales et DF
- **exam-cles-candidates.md** — Clés, candidats, super-clés
- **exam-objets-avances.md** — Objets stockés (vues, procédures)

---

## 🔄 Parcours recommandé

1. **Débuter** → Lire [glossaire.md](#) pour connaître la terminologie clé
2. **Comprendre** → Consulter [syntaxe-sql.md](syntaxe-sql.md) pour les syntaxes
3. **Approfondir** → Suivre les modules théoriques (`../`)
4. **Pratiquer** → Exécuter les exemples (`../../examples/`)
5. **Exercer** → Résoudre les exercices (`../../exercises/`)
6. **Réviser** → Consulter les guides examen et `erreurs-courantes.md`

---

## 💡 Astuces d'utilisation

### Recherche rapide
- Utilise les titres (Ctrl+F) dans le glossaire pour trouver un terme
- Les termes sont listés alphabétiquement (A-Z)
- Une table des matières par catégorie en tête du glossaire

### Renvois croisés
Beaucoup de termes incluent une section **"Voir aussi"** pour naviguer vers d'autres concepts connexes.

**Exemple** : 
```
Clé primaire
Voir aussi : PRIMARY KEY, Clé composite, UNIQUE
```

### Apprentissage progressif
- **Débutants** : Commencer par le glossaire, puis lire les modules théoriques
- **Intermédiaires** : Utiliser les guides d'examen pour réviser
- **Avancés** : Consulter au besoin pour clarifier des détails

---

## 📖 Autres ressources

Pour aller plus loin :
- Tous les **modules théoriques** dans [`../`](../)
- Des **exemples exécutables** dans [`../../examples/`](../../examples/)
- Des **exercices progressifs** dans [`../../exercises/`](../../exercises/)

