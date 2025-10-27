# Guide de Build du Plugin Download PDF Watermark

Ce guide explique comment utiliser le script de build unifié `build-plugin.sh` pour construire le plugin WordPress.

## 🚀 Script de Build Unifié

Le script `build-plugin.sh` est conçu pour être utilisé à la fois en local et dans les workflows CI/CD, garantissant une cohérence parfaite entre tous les environnements.

### Utilisation de base

```bash
./build-plugin.sh [options]
```

### Options disponibles

| Option | Description |
|--------|-------------|
| `-h, --help` | Afficher l'aide |
| `-t, --type TYPE` | Type de build: `dev`, `release`, `ci` |
| `-d, --dir DIR` | Répertoire de build (défaut: `build`) |
| `--skip-composer` | Ignorer l'installation Composer |
| `--skip-translations` | Ignorer la compilation des traductions |
| `--skip-validation` | Ignorer la validation du plugin |
| `--no-zip` | Ne pas créer d'archive ZIP |
| `-v, --verbose` | Mode verbeux |

## 📦 Types de Build

### 🔧 Build de Développement (`dev`)

```bash
./build-plugin.sh -t dev
```

**Caractéristiques :**
- Inclut les dépendances de développement
- Archive nommée : `download-pdf-watermark-dev.zip`
- Idéal pour les tests locaux

### 🚀 Build de Production (`release`)

```bash
./build-plugin.sh -t release
```

**Caractéristiques :**
- Optimisé pour la production
- Pas de dépendances de développement
- Supprime les fichiers de test et de développement
- Archive nommée avec la version : `download-pdf-watermark-1.0.0.zip`
- Compression optimisée

### ⚙️ Build CI/CD (`ci`)

```bash
./build-plugin.sh -t ci --no-zip
```

**Caractéristiques :**
- Optimisé pour les workflows automatisés
- Configuration adaptée aux environnements CI
- Peut ignorer la création du ZIP (géré par le workflow)

## 🛠️ Exemples d'utilisation

### Build local simple
```bash
./build-plugin.sh
```

### Build de release avec mode verbeux
```bash
./build-plugin.sh -t release -v
```

### Build pour test sans validation
```bash
./build-plugin.sh -t dev --skip-validation
```

### Build sans traductions (si WP-CLI indisponible)
```bash
./build-plugin.sh --skip-translations
```

## 🔍 Processus de Build

Le script exécute les étapes suivantes dans l'ordre :

1. **Vérification des prérequis**
   - Présence des fichiers essentiels
   - Disponibilité de Composer et WP-CLI

2. **Nettoyage préalable**
   - Suppression du dossier de build existant

3. **Installation des dépendances Composer**
   - Mode production ou développement selon le type

4. **Compilation des traductions**
   - Génération des fichiers `.mo` à partir des `.po`

5. **Création de la structure**
   - Création du dossier de build

6. **Copie des fichiers**
   - Fichiers essentiels et dossiers optionnels

7. **Nettoyage du build**
   - Suppression des fichiers indésirables

8. **Validation du plugin**
   - Vérification de la conformité WordPress

9. **Création de l'archive ZIP**
   - Archive finale prête à l'installation

## 📋 Validation du Plugin

Le script utilise `validate-plugin.sh` pour vérifier :

- ✅ Structure des fichiers
- ✅ En-tête WordPress
- ✅ Syntaxe PHP
- ✅ Dépendances Composer
- ✅ Internationalisation
- ✅ Conformité WordPress

## 🔄 Intégration CI/CD

### GitHub Actions

Les workflows utilisent le script unifié :

```yaml
- name: Build plugin
  run: |
    chmod +x build-plugin.sh
    ./build-plugin.sh -t ci --no-zip
```

### Avantages

- **Cohérence** : Même logique partout
- **Maintenance** : Un seul script à maintenir  
- **Fiabilité** : Tests identiques en local et CI
- **Flexibilité** : Options pour tous les cas d'usage

## 🚨 Prérequis

- **PHP** 7.4+ avec syntaxe check
- **Composer** pour les dépendances
- **WP-CLI** pour les traductions (optionnel)
- **Bash** pour l'exécution du script

## 📝 Dépannage

### Erreur "Composer non trouvé"
```bash
# Installer Composer globalement
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

### Erreur "WP-CLI non trouvé"
```bash
# Ignorer les traductions si WP-CLI indisponible
./build-plugin.sh --skip-translations
```

### Build qui échoue à la validation
```bash
# Vérifier le plugin source d'abord
./validate-plugin.sh .
```

## 📊 Sortie du Script

Le script affiche :
- ✅ Succès des étapes
- ⚠️ Avertissements
- ❌ Erreurs avec code de sortie approprié
- 📊 Statistiques finales (taille, nombre de fichiers)

---

Pour plus d'informations, utilisez `./build-plugin.sh --help`