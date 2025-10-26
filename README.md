# Download PDF Watermark

Plugin WordPress professionnel qui ajoute automatiquement un filigrane personnalisé aux fichiers PDF téléchargés via WooCommerce.

## 🚀 Fonctionnalités

### ✨ Filigrane personnalisé
- **Texte configurable** avec variables dynamiques (`{blog_name}`, `{customer_name}`, `{customer_email}`)
- **Positionnement précis** (distance personnalisable depuis le bas de la page)
- **Style configurable** (taille de police, couleur du texte)
- **Centrage automatique** horizontal sur toutes les pages

### ⚙️ Interface d'administration
- **Panneau de configuration** intégré dans WooCommerce → Paramètres → PDF Watermark
- **Paramètres en temps réel** sans modification de code
- **Activation/désactivation** simple du filigrane
- **Aperçu des variables** disponibles

### 🔧 Fonctionnalités techniques
- **Compatible WooCommerce** - Intercepte automatiquement les téléchargements PDF
- **Support URL et chemins locaux** - Gestion intelligente des fichiers
- **Gestion d'erreurs robuste** - Continue de fonctionner même en cas de problème
- **Nettoyage automatique** - Suppression programmée des fichiers temporaires
- **Encodage UTF-8** - Support complet des caractères accentués

## 📦 Installation

### Méthode automatique (GitHub Release)
1. Télécharger la dernière release depuis [GitHub Releases](https://github.com/patou/download-pdf-watermark/releases)
2. Uploader le fichier ZIP via WordPress Admin → Extensions → Ajouter
3. Activer le plugin

### Méthode manuelle
1. Cloner ou télécharger ce repository
2. Installer les dépendances : `composer install --no-dev`
3. Copier le dossier dans `wp-content/plugins/`
4. Activer le plugin dans l'administration WordPress

## 📋 Prérequis

- **WordPress** 5.0 ou supérieur
- **WooCommerce** 3.0 ou supérieur
- **PHP** 7.4 ou supérieur
- **Extensions PHP** : `mbstring`, `zip`
- **Composer** pour l'installation des dépendances

## 🛠️ Configuration

### Accès aux paramètres
1. Aller dans **WooCommerce → Paramètres**
2. Cliquer sur l'onglet **"PDF Watermark"**
3. Configurer selon vos besoins

### Paramètres disponibles

| Paramètre | Description | Défaut |
|-----------|-------------|---------|
| **Texte du filigrane** | Template avec variables `{blog_name}`, `{customer_name}`, `{customer_email}` | `Acheté sur {blog_name} par {customer_name} ({customer_email})` |
| **Taille de police** | Taille en points (6-72) | `12` |
| **Position verticale** | Distance depuis le bas en pixels (1-100) | `6` |
| **Couleur du texte** | Noir, Gris, ou Gris clair | `Noir` |
| **Activer** | Activation/désactivation du filigrane | `Activé` |

### Exemple de configuration
```
Texte : "Acheté sur {blog_name} par {customer_name} ({customer_email})"
Résultat : "Acheté sur Ma Boutique par Jean Dupont (jean@example.com)"
```

## 🏗️ Architecture du code

```
/download-pdf-watermark/
├── download-pdf-watermark.php     # Fichier principal du plugin
├── /admin/
│   └── class-dpw-settings.php     # Interface d'administration WooCommerce
├── /includes/
│   └── class-dpw-utils.php        # Fonctions utilitaires (filigrane, nettoyage)
├── /vendor/                       # Dépendances Composer (FPDI, FPDF)
├── composer.json                  # Configuration des dépendances
└── README.md                      # Documentation
```

## 🔄 CI/CD et Releases

Le projet utilise **GitHub Actions** pour :
- ✅ **Tests automatiques** sur PHP 7.4, 8.0, 8.1, 8.2
- ✅ **Validation** du code et de la structure
- ✅ **Build automatique** des releases
- ✅ **Packaging** professionnel en ZIP

### Créer une release
```bash
git tag v1.0.0
git push origin v1.0.0
```
→ Génère automatiquement un ZIP prêt pour la distribution

## 🧹 Nettoyage automatique

Le plugin inclut un système de nettoyage intelligent :
- **Tâche cron quotidienne** : Supprime les fichiers PDF temporaires anciens
- **Désactivation propre** : Supprime toutes les options et fichiers lors de la désactivation
- **Gestion des erreurs** : Logs des erreurs pour le débogage

## 🛡️ Sécurité

- **Validation des entrées** : Tous les paramètres sont validés
- **Protection des fichiers** : Vérification de l'existence et des permissions
- **Gestion des erreurs** : Fallback vers le fichier original en cas de problème
- **Nettoyage automatique** : Suppression des fichiers temporaires

## 🐛 Dépannage

### Le filigrane n'apparaît pas
1. Vérifier que le plugin est **activé** dans les paramètres
2. Vérifier que WooCommerce est installé et actif
3. Consulter les logs WordPress pour les erreurs

### Caractères mal affichés
- Le plugin gère automatiquement l'encodage UTF-8 → ISO-8859-1
- Vérifier la configuration du serveur PHP

### Fichiers temporaires
- Nettoyage automatique quotidien
- Nettoyage manuel possible via désactivation/réactivation

## 📝 Développement

### Installation pour le développement
```bash
git clone https://github.com/patou/download-pdf-watermark.git
cd download-pdf-watermark
composer install
```

### Tests
```bash
# Validation de la syntaxe PHP
find . -name "*.php" -not -path "./vendor/*" -exec php -l {} \;

# Validation Composer
composer validate --strict
```

## 📄 Licence

Ce plugin est distribué sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👨‍💻 Auteur

**Patrice de Saint Steban**

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs via les [Issues GitHub](https://github.com/patou/download-pdf-watermark/issues)
- Proposer des améliorations via les Pull Requests
- Améliorer la documentation
