# Traductions du plugin Download PDF Watermark

Ce dossier contient tous les fichiers de traduction pour le plugin Download PDF Watermark.

## 📁 Structure des fichiers

- **`.pot`** - Template de traduction (Portable Object Template)
- **`.po`** - Fichiers de traduction source (Portable Object)  
- **`.mo`** - Fichiers de traduction compilés (Machine Object)

## 🌍 Langues disponibles

### Français (fr_FR)
- `download-pdf-watermark-fr_FR.po` - Traduction source française
- `download-pdf-watermark-fr_FR.mo` - Traduction compilée française

### Anglais (en_US)  
- `download-pdf-watermark-en_US.po` - Traduction source anglaise
- `download-pdf-watermark-en_US.mo` - Traduction compilée anglaise

## 🔧 Compilation des traductions

### Méthode recommandée (WP-CLI)
Utilisez le script de gestion complète pour toutes les opérations :
```bash
# Génération POT + compilation + statistiques
./manage-translations.sh

# Ou séparément
./manage-translations.sh pot      # Générer le template POT
./manage-translations.sh compile  # Compiler les traductions
./manage-translations.sh stats    # Afficher les statistiques
```

### Méthode rapide
Compilation simple avec le script dédié :
```bash
./compile-translations.sh
```

### Méthode manuelle (WP-CLI)
Compilez un fichier spécifique :
```bash
wp i18n make-mo download-pdf-watermark-fr_FR.po
```

### Méthode manuelle (gettext)
Alternative avec `msgfmt` :
```bash
msgfmt download-pdf-watermark-fr_FR.po -o download-pdf-watermark-fr_FR.mo
```

## ➕ Ajouter une nouvelle langue

1. **Dupliquer le template** :
   ```bash
   cp download-pdf-watermark.pot download-pdf-watermark-LOCALE.po
   ```
   Remplacez `LOCALE` par le code de langue (ex: `es_ES`, `de_DE`, `it_IT`)

2. **Modifier l'en-tête** du fichier `.po` :
   ```po
   "Language: LOCALE\n"
   "Language-Team: LANGUAGE <LOCALE@li.org>\n"
   ```

3. **Traduire les chaînes** :
   - `msgid` = Texte original (ne pas modifier)
   - `msgstr` = Traduction dans votre langue

4. **Compiler le fichier** :
   ```bash
   msgfmt download-pdf-watermark-LOCALE.po -o download-pdf-watermark-LOCALE.mo
   ```

## 🛠️ Outils recommandés

### Prérequis (recommandé)
- **WP-CLI** - Interface en ligne de commande WordPress
  - Installation: https://wp-cli.org/
  - macOS: `brew install wp-cli`
  - Composer: `composer global require wp-cli/wp-cli`

### Éditeurs de traduction
- **Poedit** - https://poedit.net/ (Gratuit, multiplateforme)
- **Lokalize** - Pour KDE/Linux
- **GTranslator** - Pour GNOME/Linux

### Alternative en ligne de commande
- **gettext** - Suite d'outils pour les traductions
  - Ubuntu/Debian: `sudo apt-get install gettext`
  - macOS: `brew install gettext`
  - Windows: https://mlocati.github.io/articles/gettext-iconv-windows.html

## 📝 Chaînes à traduire

Le plugin contient les types de chaînes suivants :

### Interface d'administration
- Titres des sections
- Labels des champs de configuration
- Descriptions des paramètres
- Options de sélection (Noir, Gris, etc.)

### Messages système
- Nom et description du plugin
- Messages d'activation/désactivation

## 🔄 Mise à jour des traductions

Quand de nouvelles chaînes sont ajoutées au plugin :

1. **Régénérer le template** `.pot` avec un outil comme `xgettext`
2. **Fusionner** avec les fichiers `.po` existants avec `msgmerge`
3. **Traduire** les nouvelles chaînes marquées `fuzzy`
4. **Recompiler** les fichiers `.mo`

## 🤝 Contribuer

Pour contribuer une nouvelle traduction :

1. Créez les fichiers `.po` et `.mo` pour votre langue
2. Testez la traduction dans WordPress
3. Soumettez une Pull Request avec vos fichiers

## 📧 Support

Pour toute question sur les traductions :
- Issues GitHub : https://github.com/patou/download-pdf-watermark/issues
- Marquez vos issues avec le label `translation`