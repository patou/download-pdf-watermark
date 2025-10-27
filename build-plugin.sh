#!/bin/bash

# Script de build unifié pour le plugin WordPress Download PDF Watermark
# Compatible avec l'exécution locale et les workflows CI/CD
# Usage: ./build-plugin.sh [options]

set -e  # Arrêter en cas d'erreur

# Configuration par défaut
BUILD_DIR="build"
PLUGIN_NAME="download-pdf-watermark"
BUILD_TYPE="dev"
SKIP_COMPOSER=false
SKIP_TRANSLATIONS=false
SKIP_VALIDATION=false
VERBOSE=false
CREATE_ZIP=true

# Fonction d'aide
show_help() {
    cat << EOF
Usage: $0 [options]

Options:
    -h, --help              Afficher cette aide
    -t, --type TYPE         Type de build: dev, release, ci (default: dev)
    -d, --dir DIR           Répertoire de build (default: build)
    --skip-composer         Ignorer l'installation Composer
    --skip-translations     Ignorer la compilation des traductions
    --skip-validation       Ignorer la validation du plugin
    --no-zip               Ne pas créer d'archive ZIP
    -v, --verbose          Mode verbeux

Types de build:
    dev      - Build de développement (dependencies dev incluses)
    release  - Build de production (sans dev dependencies)
    ci       - Build pour CI/CD (optimisé pour les workflows)

Examples:
    $0                          # Build de dev standard
    $0 -t release              # Build de production
    $0 -t ci --skip-validation # Build CI sans validation
EOF
}

# Fonction de log
log() {
    local level=$1
    shift
    local message="$*"
    
    case $level in
        "INFO")
            echo "ℹ️  $message"
            ;;
        "SUCCESS")
            echo "✅ $message"
            ;;
        "WARNING")
            echo "⚠️  $message"
            ;;
        "ERROR")
            echo "❌ $message"
            ;;
        "STEP")
            echo ""
            echo "🔄 $message"
            echo "$(printf '%.0s-' {1..50})"
            ;;
    esac
}

# Fonction pour vérifier les prérequis
check_prerequisites() {
    log "STEP" "Vérification des prérequis"
    
    if [ ! -f "download-pdf-watermark.php" ]; then
        log "ERROR" "Fichier principal du plugin non trouvé. Êtes-vous dans le bon répertoire ?"
        exit 1
    fi
    
    if ! command -v composer &> /dev/null && [ "$SKIP_COMPOSER" = false ]; then
        log "ERROR" "Composer n'est pas installé"
        exit 1
    fi
    
    if ! command -v wp &> /dev/null && [ "$SKIP_TRANSLATIONS" = false ]; then
        log "WARNING" "WP-CLI non disponible, compilation des traductions désactivée"
        SKIP_TRANSLATIONS=true
    fi
    
    log "SUCCESS" "Prérequis vérifiés"
}

# Fonction de nettoyage
cleanup_build() {
    log "STEP" "Nettoyage préalable"
    
    if [ -d "$BUILD_DIR" ]; then
        log "INFO" "Suppression du build existant..."
        rm -rf "$BUILD_DIR"
    fi
    
    log "SUCCESS" "Nettoyage terminé"
}

# Installation des dépendances Composer
install_composer_deps() {
    if [ "$SKIP_COMPOSER" = true ]; then
        log "INFO" "Installation Composer ignorée"
        return
    fi
    
    log "STEP" "Installation des dépendances Composer"
    
    local composer_flags="--no-interaction"
    
    case $BUILD_TYPE in
        "release"|"ci")
            composer_flags="$composer_flags --no-dev --optimize-autoloader"
            ;;
        "dev")
            composer_flags="$composer_flags --prefer-dist --no-progress"
            ;;
    esac
    
    if [ "$VERBOSE" = true ]; then
        composer install $composer_flags
    else
        composer install $composer_flags --quiet
    fi
    
    log "SUCCESS" "Dépendances Composer installées"
}

# Compilation des traductions
compile_translations() {
    if [ "$SKIP_TRANSLATIONS" = true ]; then
        log "INFO" "Compilation des traductions ignorée"
        return
    fi
    
    log "STEP" "Compilation des traductions"
    
    if [ ! -d "languages" ]; then
        log "WARNING" "Dossier languages/ non trouvé"
        return
    fi
    
    cd languages
    local compiled=0
    
    for po_file in *.po; do
        if [ -f "$po_file" ]; then
            if [ "$VERBOSE" = true ]; then
                echo "Compilation: $po_file"
            fi
            
            local mo_file="${po_file%.po}.mo"
            
            # Essayer d'abord avec WP-CLI
            if command -v wp &> /dev/null && wp i18n make-mo "$po_file" --quiet 2>/dev/null; then
                ((compiled++))
                if [ "$VERBOSE" = true ]; then
                    log "INFO" "Compilé avec WP-CLI: $mo_file"
                fi
            # Fallback avec msgfmt si disponible
            elif command -v msgfmt &> /dev/null; then
                if msgfmt -o "$mo_file" "$po_file" 2>/dev/null; then
                    ((compiled++))
                    if [ "$VERBOSE" = true ]; then
                        log "INFO" "Compilé avec msgfmt: $mo_file"
                    fi
                else
                    log "WARNING" "Échec de compilation de $po_file avec msgfmt"
                fi
            else
                log "WARNING" "Impossible de compiler $po_file : ni WP-CLI ni msgfmt disponible"
            fi
        fi
    done
    
    cd ..
    
    if [ $compiled -gt 0 ]; then
        log "SUCCESS" "$compiled fichier(s) de traduction compilé(s)"
    else
        log "INFO" "Aucun fichier de traduction à compiler"
    fi
}

# Création de la structure de build
create_build_structure() {
    log "STEP" "Création de la structure de build"
    
    mkdir -p "$BUILD_DIR/$PLUGIN_NAME"
    
    log "SUCCESS" "Structure de build créée"
}

# Copie des fichiers
copy_plugin_files() {
    log "STEP" "Copie des fichiers du plugin"
    
    local dest="$BUILD_DIR/$PLUGIN_NAME"
    
    # Fichiers principaux
    local main_files=("download-pdf-watermark.php" "README.md" "readme.txt" "composer.json")
    for file in "${main_files[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$dest/"
            if [ "$VERBOSE" = true ]; then
                log "INFO" "Copié: $file"
            fi
        fi
    done
    
    # Copier LICENSE s'il existe
    if [ -f "LICENSE" ]; then
        cp "LICENSE" "$dest/"
        if [ "$VERBOSE" = true ]; then
            log "INFO" "Copié: LICENSE"
        fi
    fi
    
    # Dossiers essentiels
    local essential_dirs=("admin" "includes" "vendor")
    for dir in "${essential_dirs[@]}"; do
        if [ -d "$dir" ]; then
            cp -r "$dir" "$dest/"
            if [ "$VERBOSE" = true ]; then
                log "INFO" "Copié: $dir/"
            fi
        else
            log "ERROR" "Dossier essentiel manquant: $dir/"
            exit 1
        fi
    done
    
    # Dossiers optionnels
    local optional_dirs=("public" "languages")
    for dir in "${optional_dirs[@]}"; do
        if [ -d "$dir" ] && [ "$(ls -A $dir)" ]; then
            cp -r "$dir" "$dest/"
            log "SUCCESS" "Dossier $dir/ copié"
        else
            log "INFO" "Dossier $dir/ vide ou inexistant, ignoré"
        fi
    done
}

# Nettoyage du build
clean_build() {
    log "STEP" "Nettoyage du build"
    
    local dest="$BUILD_DIR/$PLUGIN_NAME"
    
    find "$dest" -name ".DS_Store" -delete 2>/dev/null || true
    find "$dest" -name "*.log" -delete 2>/dev/null || true
    find "$dest" -name ".git*" -delete 2>/dev/null || true
    find "$dest" -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
    
    if [ "$BUILD_TYPE" = "release" ]; then
        find "$dest" -name "*.test.php" -delete 2>/dev/null || true
        find "$dest" -name "phpunit.xml*" -delete 2>/dev/null || true
        rm -rf "$dest/.github" 2>/dev/null || true
    fi
    
    log "SUCCESS" "Build nettoyé"
}

# Validation du plugin
validate_plugin() {
    if [ "$SKIP_VALIDATION" = true ]; then
        log "INFO" "Validation du plugin ignorée"
        return
    fi
    
    log "STEP" "Validation du plugin construit"
    
    if [ ! -f "validate-plugin.sh" ]; then
        log "WARNING" "Script de validation non trouvé, validation ignorée"
        return
    fi
    
    chmod +x validate-plugin.sh
    
    if [ "$VERBOSE" = true ]; then
        ./validate-plugin.sh "$BUILD_DIR/$PLUGIN_NAME"
    else
        ./validate-plugin.sh "$BUILD_DIR/$PLUGIN_NAME" > /dev/null
    fi
    
    if [ $? -eq 0 ]; then
        log "SUCCESS" "Plugin validé avec succès"
    else
        log "ERROR" "La validation du plugin a échoué"
        exit 1
    fi
}

# Création de l'archive ZIP
create_zip_archive() {
    if [ "$CREATE_ZIP" = false ]; then
        log "INFO" "Création du ZIP ignorée"
        return
    fi
    
    log "STEP" "Création de l'archive ZIP"
    
    cd "$BUILD_DIR"
    
    local zip_name
    case $BUILD_TYPE in
        "release")
            local version=$(grep "Version:" "$PLUGIN_NAME/download-pdf-watermark.php" | sed 's/.*Version: *\([0-9.]*\).*/\1/')
            zip_name="$PLUGIN_NAME-$version.zip"
            ;;
        "ci")
            zip_name="$PLUGIN_NAME-ci.zip"
            ;;
        *)
            zip_name="$PLUGIN_NAME-dev.zip"
            ;;
    esac
    
    if [ "$VERBOSE" = true ]; then
        zip -r "$zip_name" "$PLUGIN_NAME/"
    else
        zip -r "$zip_name" "$PLUGIN_NAME/" -q
    fi
    
    cd ..
    
    log "SUCCESS" "Archive créée: $BUILD_DIR/$zip_name"
    
    local zip_size=$(ls -lh "$BUILD_DIR/$zip_name" | awk '{print $5}')
    local file_count=$(find "$BUILD_DIR/$PLUGIN_NAME" -type f | wc -l)
    
    log "INFO" "Taille: $zip_size, Fichiers: $file_count"
}

# Fonction principale
main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--type)
                BUILD_TYPE="$2"
                shift 2
                ;;
            -d|--dir)
                BUILD_DIR="$2"
                shift 2
                ;;
            --skip-composer)
                SKIP_COMPOSER=true
                shift
                ;;
            --skip-translations)
                SKIP_TRANSLATIONS=true
                shift
                ;;
            --skip-validation)
                SKIP_VALIDATION=true
                shift
                ;;
            --no-zip)
                CREATE_ZIP=false
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            *)
                log "ERROR" "Option inconnue: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    if [[ ! "$BUILD_TYPE" =~ ^(dev|release|ci)$ ]]; then
        log "ERROR" "Type de build invalide: $BUILD_TYPE"
        exit 1
    fi
    
    log "STEP" "🚀 Build du plugin Download PDF Watermark (type: $BUILD_TYPE)"
    
    check_prerequisites
    cleanup_build
    install_composer_deps
    compile_translations
    create_build_structure
    copy_plugin_files
    clean_build
    validate_plugin
    create_zip_archive
    
    echo ""
    log "SUCCESS" "🎉 BUILD TERMINÉ AVEC SUCCÈS!"
    echo "=============================="
    log "INFO" "📁 Dossier de build: $BUILD_DIR/$PLUGIN_NAME/"
    if [ "$CREATE_ZIP" = true ]; then
        local zip_file=$(find "$BUILD_DIR" -name "*.zip" | head -1)
        log "INFO" "📦 Archive ZIP: $zip_file"
    fi
    log "INFO" "✅ Le plugin est prêt à être utilisé!"
}

main "$@"