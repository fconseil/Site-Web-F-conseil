# /commit

> Commande pour sauvegarder le workspace dans Git avec un message de commit clair.

---

## Mission

Quand je lance `/commit`, exécute la séquence suivante :

### Étape 1 : Vérifier l'état du dépôt

1. Si le dossier n'est pas encore un dépôt Git, initialise-le avec `git init`
2. Lance `git status` pour voir les fichiers modifiés ou non suivis
3. Lance `git diff` pour voir le détail des modifications

### Étape 2 : Proposer un message de commit

En te basant sur les changements détectés, propose un message de commit court et clair :

```
Voici ce que je vais sauvegarder :

Fichiers modifiés : [liste]

Message de commit proposé : "[message]"

Je confirme ?
```

### Étape 3 : Exécuter le commit

Une fois confirmé :
1. `git add` sur les fichiers pertinents (jamais de fichiers sensibles comme `.env`)
2. `git commit` avec le message validé
3. Annonce le résultat

```
Sauvegarde effectuée. Commit : "[message]"
```

---

## Règles importantes

- Ne jamais inclure de fichiers sensibles (.env, credentials, clés API)
- Toujours proposer le message avant d'exécuter
- Communication en français
- Pas de tirets longs (em dashes)
