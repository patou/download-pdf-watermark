#!/bin/bash

# Script de validation pour le plugin WordPress Download PDF Watermark
# Usage: ./validate-plugin.sh [chemin_vers_plugin]

PLUGIN_PATH="${1:-.}"
PLUGIN_NAME="download-pdf-watermark"
MAIN_FILE="download-pdf-watermark.php"

echo "🔍 Validation du plugin WordPress: $PLUGIN_NAME"
echo "📂 Répertoire analysé: $PLUGIN_PATH"
echo "=================================================="

# Compteur d'erreurs
ERRORS=0
WARNINGS=0

# Fonction pour afficher les erreurs
error() {
    echo "❌ ERREUR: $1"
    ((ERRORS++))
}

# Fonction pour afficher les avertissements
warning() {
    echo "⚠️  AVERTISSEMENT: $1"
    ((WARNINGS++))
}

# Fonction pour afficher les succès
success() {
    echo "✅ $1"
}

echo "1. 📋 Vérification de la structure des fichiers"
echo "------------------------------------------------"

# Vérifier l'existence du fichier principal
if [ -f "$PLUGIN_PATH/$MAIN_FILE" ]; then
    success "Fichier principal trouvé: $MAIN_FILE"
else
    error "Fichier principal manquant: $MAIN_FILE"
fi

# Vérifier les dossiers essentiels
for dir in "admin" "includes" "vendor"; do
    if [ -d "$PLUGIN_PATH/$dir" ]; then
        success "Dossier trouvé: $dir/"
        # Vérifier que le dossier n'est pas vide
        if [ -z "$(ls -A $PLUGIN_PATH/$dir)" ]; then
            warning "Le dossier $dir/ est vide"
        fi
    else
        error "Dossier manquant: $dir/"
    fi
done

# Vérifier les fichiers optionnels mais recommandés
for file in "README.md" "composer.json"; do
    if [ -f "$PLUGIN_PATH/$file" ]; then
        success "Fichier trouvé: $file"
    else
        warning "Fichier recommandé manquant: $file"
    fi
done

echo ""
echo "2. 🔧 Vérification de l'en-tête du plugin principal"
echo "------------------------------------------------"

if [ -f "$PLUGIN_PATH/$MAIN_FILE" ]; then
    # Vérifier la présence des métadonnées WordPress obligatoires
    PLUGIN_HEADER=$(head -30 "$PLUGIN_PATH/$MAIN_FILE")
    
    # Vérifier le format du commentaire DocBlock
    if echo "$PLUGIN_HEADER" | grep -q "^/\*\*" && echo "$PLUGIN_HEADER" | grep -q "\*/"; then
        success "Format de commentaire DocBlock détecté (/**...*/)"
    else
        error "En-tête du plugin doit utiliser le format DocBlock (/** ... */) au lieu de /* ... */"
    fi
    
    # Vérifier que le plugin commence bien par <?php
    FIRST_LINE=$(head -1 "$PLUGIN_PATH/$MAIN_FILE")
    if [ "$FIRST_LINE" = "<?php" ]; then
        success "Balise PHP d'ouverture correcte"
    else
        error "Le fichier doit commencer par <?php"
    fi
    
    # Plugin Name
    if echo "$PLUGIN_HEADER" | grep -q "Plugin Name:"; then
        PLUGIN_NAME_VALUE=$(echo "$PLUGIN_HEADER" | grep "Plugin Name:" | cut -d':' -f2 | xargs)
        success "Plugin Name trouvé: $PLUGIN_NAME_VALUE"
    else
        error "En-tête 'Plugin Name:' manquant"
    fi
    
    # Version
    if echo "$PLUGIN_HEADER" | grep -q "Version:"; then
        VERSION_VALUE=$(echo "$PLUGIN_HEADER" | grep "Version:" | cut -d':' -f2 | xargs)
        success "Version trouvée: $VERSION_VALUE"
    else
        error "En-tête 'Version:' manquant"
    fi
    
    # Description
    if echo "$PLUGIN_HEADER" | grep -q "Description:"; then
        success "Description trouvée"
    else
        warning "En-tête 'Description:' manquant (recommandé)"
    fi
    
    # Author
    if echo "$PLUGIN_HEADER" | grep -q "Author:"; then
        success "Auteur trouvé"
    else
        warning "En-tête 'Author:' manquant (recommandé)"
    fi
    
    # Text Domain
    if echo "$PLUGIN_HEADER" | grep -q "Text Domain:"; then
        TEXT_DOMAIN_VALUE=$(echo "$PLUGIN_HEADER" | grep "Text Domain:" | cut -d':' -f2 | xargs)
        success "Text Domain trouvé: $TEXT_DOMAIN_VALUE"
    else
        warning "En-tête 'Text Domain:' manquant"
    fi
fi

echo ""
echo "3. 🔍 Vérification de la syntaxe PHP"
echo "------------------------------------------------"

if [ -f "$PLUGIN_PATH/$MAIN_FILE" ]; then
    if php -l "$PLUGIN_PATH/$MAIN_FILE" > /dev/null 2>&1; then
        success "Syntaxe PHP valide pour $MAIN_FILE"
    else
        error "Erreur de syntaxe PHP dans $MAIN_FILE"
        php -l "$PLUGIN_PATH/$MAIN_FILE"
    fi
fi

# Vérifier tous les fichiers PHP
PHP_FILES=$(find "$PLUGIN_PATH" -name "*.php" -not -path "*/vendor/*" 2>/dev/null)
if [ -n "$PHP_FILES" ]; then
    PHP_SYNTAX_ERRORS=0
    while IFS= read -r php_file; do
        if ! php -l "$php_file" > /dev/null 2>&1; then
            error "Erreur de syntaxe dans: $php_file"
            ((PHP_SYNTAX_ERRORS++))
        fi
    done <<< "$PHP_FILES"
    
    if [ $PHP_SYNTAX_ERRORS -eq 0 ]; then
        success "Tous les fichiers PHP ont une syntaxe valide"
    fi
fi

echo ""
echo "4. 📦 Vérification des dépendances Composer"
echo "------------------------------------------------"

if [ -f "$PLUGIN_PATH/composer.json" ]; then
    success "composer.json trouvé"
    
    if [ -f "$PLUGIN_PATH/vendor/autoload.php" ]; then
        success "Autoloader Composer trouvé"
    else
        error "vendor/autoload.php manquant - exécuter 'composer install'"
    fi
    
    # Vérifier si les dépendances FPDF/FPDI sont présentes
    if [ -d "$PLUGIN_PATH/vendor/setasign" ]; then
        success "Dépendances setasign (FPDF/FPDI) trouvées"
    else
        error "Dépendances setasign manquantes"
    fi
else
    warning "composer.json manquant"
fi

echo ""
echo "5. 🌍 Vérification de l'internationalisation"
echo "------------------------------------------------"

if [ -d "$PLUGIN_PATH/languages" ]; then
    success "Dossier languages/ trouvé"
    
    # Vérifier les fichiers de traduction
    POT_FILES=$(find "$PLUGIN_PATH/languages" -name "*.pot" 2>/dev/null | wc -l)
    PO_FILES=$(find "$PLUGIN_PATH/languages" -name "*.po" 2>/dev/null | wc -l)
    MO_FILES=$(find "$PLUGIN_PATH/languages" -name "*.mo" 2>/dev/null | wc -l)
    
    if [ $POT_FILES -gt 0 ]; then
        success "$POT_FILES fichier(s) POT trouvé(s)"
    else
        warning "Aucun fichier POT trouvé"
    fi
    
    if [ $PO_FILES -gt 0 ]; then
        success "$PO_FILES fichier(s) PO trouvé(s)"
    else
        warning "Aucun fichier PO trouvé"
    fi
    
    if [ $MO_FILES -gt 0 ]; then
        success "$MO_FILES fichier(s) MO trouvé(s)"
    else
        warning "Aucun fichier MO trouvé (les traductions ne seront pas actives)"
    fi
else
    warning "Dossier languages/ manquant"
fi

echo ""
echo "6. 🧪 Vérification de la structure pour WordPress"
echo "------------------------------------------------"

# Vérifier si le plugin suit la structure WordPress standard
PLUGIN_DIR_NAME=$(basename "$PLUGIN_PATH")
if [ "$PLUGIN_DIR_NAME" = "$PLUGIN_NAME" ]; then
    success "Nom du dossier correct: $PLUGIN_DIR_NAME"
else
    warning "Le nom du dossier ($PLUGIN_DIR_NAME) ne correspond pas au nom du plugin ($PLUGIN_NAME)"
fi

# Vérifier la présence de code WordPress
if [ -f "$PLUGIN_PATH/$MAIN_FILE" ]; then
    if grep -q "add_action\|add_filter\|wp_\|WP_" "$PLUGIN_PATH/$MAIN_FILE" > /dev/null 2>&1; then
        success "Code WordPress détecté dans le fichier principal"
    else
        warning "Aucun code WordPress évident détecté"
    fi
fi

echo ""
echo "=================================================="
echo "📊 RÉSUMÉ DE LA VALIDATION"
echo "=================================================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "🎉 EXCELLENT! Le plugin semble parfaitement configuré."
elif [ $ERRORS -eq 0 ]; then
    echo "✅ BIEN! Le plugin est valide avec $WARNINGS avertissement(s) mineur(s)."
else
    echo "❌ PROBLÈME! Le plugin a $ERRORS erreur(s) et $WARNINGS avertissement(s)."
fi

echo ""
echo "Erreurs: $ERRORS"
echo "Avertissements: $WARNINGS"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo "🔧 Actions recommandées:"
    echo "1. Corriger les erreurs listées ci-dessus"
    echo "2. Relancer la validation avec: ./validate-plugin.sh"
    echo "3. Tester le plugin dans un environnement WordPress"
    exit 1
fi

exit 0