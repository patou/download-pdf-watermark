# Download PDF Watermark / Filigrane PDF Téléchargement

**Plugin WordPress professionnel qui ajoute automatiquement un filigrane personnalisé aux fichiers PDF téléchargés via WooCommerce.**  
**Professional WordPress plugin that automatically adds a custom watermark to PDF files downloaded via WooCommerce.**

---

## 🚀 Fonctionnalités / Features

### ✨ Filigrane personnalisé / Custom Watermark
- **Français :** Texte configurable avec variables dynamiques ({blog_name}, {customer_name}, {customer_email})  
  Positionnement précis (distance personnalisable depuis le bas de la page)  
  Style configurable (taille de police, couleur du texte)  
  Centrage automatique horizontal sur toutes les pages  

- **English:** Configurable text with dynamic variables ({blog_name}, {customer_name}, {customer_email})  
  Precise positioning (customizable distance from the bottom of the page)  
  Configurable style (font size, text color)  
  Automatic horizontal centering on all pages  

### ⚙️ Interface d'administration / Admin Interface
- **Français :**  
  Panneau de configuration intégré dans WooCommerce → Paramètres → PDF Watermark  
  Paramètres en temps réel sans modification de code  
  Activation/désactivation simple du filigrane  
  Aperçu des variables disponibles  

- **English:**  
  Built-in configuration panel in WooCommerce → Settings → PDF Watermark  
  Real-time settings without code modification  
  Easy enable/disable of watermark  
  Preview of available variables  

### 🔧 Fonctionnalités techniques / Technical Features
- **Français :** Compatible WooCommerce - Intercepte automatiquement les téléchargements PDF  
  Support URL et chemins locaux - Gestion intelligente des fichiers  
  Gestion d'erreurs robuste - Continue de fonctionner même en cas de problème  
  Nettoyage automatique - Suppression programmée des fichiers temporaires  
  Encodage UTF-8 - Support complet des caractères accentués  

- **English:** Compatible with WooCommerce – Automatically intercepts PDF downloads  
  Supports URLs and local paths – Smart file management  
  Robust error handling – Continues working even in case of issues  
  Automatic cleanup – Scheduled deletion of temporary files  
  UTF-8 encoding – Full support for accented characters  

---

## 📦 Installation / Installation

### Méthode automatique (GitHub Release) / Automatic Method (GitHub Release)
1. Télécharger la dernière release depuis GitHub Releases / Download the latest release from GitHub Releases  
2. Uploader le fichier ZIP via WordPress Admin → Extensions → Ajouter / Upload the ZIP file via WordPress Admin → Plugins → Add New  
3. Activer le plugin / Activate the plugin  

### Méthode manuelle / Manual Method
1. Cloner ou télécharger ce repository / Clone or download this repository  
2. Installer les dépendances : `composer install --no-dev` / Install dependencies: `composer install --no-dev`  
3. Copier le dossier dans `wp-content/plugins/` / Copy the folder to `wp-content/plugins/`  
4. Activer le plugin dans l'administration WordPress / Activate the plugin in WordPress admin  

---

## 📋 Prérequis / Requirements
- **WordPress 5.0 ou supérieur / WordPress 5.0 or higher**  
- **WooCommerce 3.0 ou supérieur / WooCommerce 3.0 or higher**  
- **PHP 7.4 ou supérieur / PHP 7.4 or higher**  
- **Extensions PHP : mbstring, zip / PHP extensions: mbstring, zip**  
- **Composer pour l'installation des dépendances / Composer for dependency installation**  

---

## 🛠️ Configuration / Configuration

### Accès aux paramètres / Access Settings
- Aller dans WooCommerce → Paramètres / Go to WooCommerce → Settings  
- Cliquer sur l'onglet "PDF Watermark" / Click the "PDF Watermark" tab  
- Configurer selon vos besoins / Configure according to your needs  

### Paramètres disponibles / Available Settings
| Paramètre / Parameter       | Description | Défaut / Default |
|-----------------------------|-------------|----------------|
| Texte du filigrane / Watermark Text | Template avec variables {blog_name}, {customer_name}, {customer_email} | Acheté sur {blog_name} par {customer_name} ({customer_email}) |
| Taille de police / Font Size | Taille en points (6-72) / Size in points (6-72) | 12 |
| Position verticale / Vertical Position | Distance depuis le bas en pixels (1-100) / Distance from bottom in pixels (1-100) | 6 |
| Couleur du texte / Text Color | Noir, Gris, ou Gris clair / Black, Gray, or Light Gray | Noir / Black |
| Activer / Enable | Activation/désactivation du filigrane / Enable/disable watermark | Activé / Enabled |


**Exemple / Example:**  
- Texte : "Acheté sur {blog_name} par {customer_name} ({customer_email})"  
- Résultat / Result : "Acheté sur Ma Boutique par Jean Dupont (jean@example.com)"  

---

## 🏗️ Architecture du code / Code Architecture


```
/download-pdf-watermark/
├── download-pdf-watermark.php # Fichier principal / Main plugin file
├── /admin/
│ └── class-dpw-settings.php # Interface d'administration WooCommerce / Admin interface
├── /includes/
│ └── class-dpw-utils.php # Fonctions utilitaires / Utility functions
├── /vendor/ # Dépendances Composer / Composer dependencies (FPDI, FPDF)
├── composer.json # Configuration des dépendances / Dependency config
└── README.md # Documentation
```

---

## 🔄 CI/CD et Releases / CI/CD and Releases
- **Tests automatiques / Automatic tests:** PHP 7.4, 8.0, 8.1, 8.2  
- **Validation du code / Code validation**  
- **Build automatique / Automatic build**  
- **Packaging professionnel en ZIP / Professional ZIP packaging**  

Créer une release / Creating a release:  
```bash
git tag v1.0.0
git push origin v1.0.0

```
→ Génère automatiquement un ZIP prêt pour la distribution / Automatically generates a ZIP ready for distribution

## 🧹 Nettoyage automatique / Automatic Cleanup

Le plugin inclut un système de nettoyage intelligent :
- **Tâche cron quotidienne / Daily cron task** : Supprime les fichiers PDF temporaires anciens / Deletes old temporary PDF files
- **Désactivation propre / Clean deactivation** : SSupprime toutes les options et fichiers / Deletes all options and files
- **Gestion des erreurs / Error handling** : Logs pour débogage / Logs for debugging

---

## 🛡️ Sécurité / Security

- **Validation des entrées / Input validation** : Tous les paramètres sont validés / All parameters are validated

- **Protection des fichiers / File protection** : Vérification de l'existence et des permissions / Checks existence and permissions
- **Gestion des erreurs / Error handling** : Fallback vers le fichier original en cas de problème / Fallback to original file in case of issue
- **Nettoyage automatique / Automatic cleanup** : Suppression des fichiers temporaires / Deletes temporary files

## 🐛 Dépannage / Troubleshooting

### Le filigrane n'apparaît pas / Watermark not appearing
1. Vérifier que le plugin est **activé** dans les paramètres / Check that the plugin is **enabled** in settings
2. Vérifier que WooCommerce est installé et actif / Ensure WooCommerce is installed and active
3. Consulter les logs WordPress pour les erreurs / Check WordPress logs for errors

### Caractères mal affichés / Characters not displaying correctly
- Le plugin gère automatiquement l'encodage UTF-8 → ISO-8859-1 / Plugin automatically handles UTF-8 → ISO-8859-1 encoding
- Vérifier la configuration du serveur PHP / Verify your PHP server configuration

### Fichiers temporaires / Temporary files
- Nettoyage automatique quotidien / Daily automatic cleanup
- Nettoyage manuel possible via désactivation/réactivation / Manual cleanup possible via deactivate/reactivate

---

## 📝 Développement / Development

### Installation pour le développement / Development setup
```bash
git clone https://github.com/patou/download-pdf-watermark.git
cd download-pdf-watermark
composer install
```

### Tests / Testing
```bash
# Validation de la syntaxe PHP / PHP syntax check
find . -name "*.php" -not -path "./vendor/*" -exec php -l {} \;

# Validation Composer / Composer validation
composer validate --strict

```

## 📄 Licence / License

Ce plugin est distribué sous licence MIT / This plugin is distributed under the MIT license.  
Voir le fichier `LICENSE` pour plus de détails / See the `LICENSE` file for details.

---

## 👨‍💻 Auteur / Author

**Patrice de Saint Steban**

---

## 🤝 Contribution / Contribution

Les contributions sont les bienvenues ! N'hésitez pas à / Contributions are welcome!  
- Signaler des bugs via les [Issues GitHub](https://github.com/patou/download-pdf-watermark/issues) / Report bugs via GitHub Issues  
- Proposer des améliorations via les Pull Requests / Suggest improvements via Pull Requests  
- Améliorer la documentation / Improve documentation