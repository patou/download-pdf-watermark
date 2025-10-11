# Download PDF Watermark

Ce plugin WordPress permet d’ajouter un filigrane personnalisé aux fichiers PDF téléchargés via le site.

## Installation

1. Copier le dossier `download-pdf-watermark` dans le répertoire `wp-content/plugins/` de votre site WordPress.
2. Activer le plugin depuis l’interface d’administration WordPress.

## Utilisation

- Le plugin intercepte le téléchargement des fichiers PDF et ajoute un filigrane (texte personnalisable).
- Pour personnaliser le texte du filigrane ou la logique, modifiez la fonction `dpw_add_watermark_to_pdf` dans le fichier `download-pdf-watermark.php`.

## Exemple d’extension

Pour ajouter un filigrane, vous pouvez utiliser une librairie PHP comme `setasign/fpdi` ou `mPDF`.

## À compléter

- Ajoutez la logique métier pour intercepter le téléchargement et modifier le PDF.
- Ajoutez une interface d’administration pour configurer le texte du filigrane si besoin.
