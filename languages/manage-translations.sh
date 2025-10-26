#!/bin/bash

# Script de gestion complète des traductions avec WP-CLI
# Génère le fichier POT et compile les traductions

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PLUGIN_SLUG="download-pdf-watermark"
PLUGIN_DIR="../"
DOMAIN="download-pdf-watermark"

echo -e "${PURPLE}🚀 Gestion complète des traductions - $PLUGIN_SLUG${NC}"

# Vérifier si WP-CLI est installé
if ! command -v wp &> /dev/null; then
    echo -e "${RED}❌ Erreur: WP-CLI n'est pas installé.${NC}"
    echo "Installez WP-CLI depuis: https://wp-cli.org/"
    exit 1
fi

# Fonction d'aide
show_help() {
    echo -e "${BLUE}Usage: $0 [OPTION]${NC}"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  pot       Générer le fichier template (.pot)"
    echo "  compile   Compiler les fichiers .po en .mo"
    echo "  all       Générer POT et compiler (par défaut)"
    echo "  stats     Afficher les statistiques des traductions"
    echo "  help      Afficher cette aide"
    echo ""
    echo -e "${YELLOW}Exemples:${NC}"
    echo "  $0              # Génère POT et compile tout"
    echo "  $0 pot          # Générer seulement le POT"
    echo "  $0 compile      # Compiler seulement les .po"
    echo "  $0 stats        # Statistiques des traductions"
}

# Fonction pour générer le fichier POT
generate_pot() {
    echo -e "\n${BLUE}📝 Génération du fichier template (.pot)${NC}"
    
    if wp i18n make-pot "$PLUGIN_DIR" "$PLUGIN_SLUG.pot" \
        --domain="$DOMAIN" \
        --package-name="$PLUGIN_SLUG" \
        --file-comment="" \
        --headers='{"Report-Msgid-Bugs-To":"https://github.com/patou/download-pdf-watermark/issues"}' \
        --quiet; then
        
        size=$(stat -f%z "$PLUGIN_SLUG.pot" 2>/dev/null || stat -c%s "$PLUGIN_SLUG.pot" 2>/dev/null || echo "?")
        echo -e "  ${GREEN}✅ $PLUGIN_SLUG.pot généré avec succès ($size octets)${NC}"
        
        # Compter les chaînes
        string_count=$(grep -c "^msgid" "$PLUGIN_SLUG.pot" 2>/dev/null || echo "?")
        echo -e "  ${YELLOW}📊 Nombre de chaînes à traduire: $string_count${NC}"
    else
        echo -e "  ${RED}❌ Erreur lors de la génération du POT${NC}"
        return 1
    fi
}

# Fonction pour compiler les fichiers PO
compile_translations() {
    echo -e "\n${BLUE}🔨 Compilation des traductions${NC}"
    
    po_count=0
    mo_count=0
    
    for po_file in *.po; do
        if [ -f "$po_file" ]; then
            po_count=$((po_count + 1))
            echo -e "\n${YELLOW}📝 Traitement:${NC} $po_file"
            
            if wp i18n make-mo "$po_file" --quiet; then
                mo_count=$((mo_count + 1))
                mo_file="${po_file%.po}.mo"
                size=$(stat -f%z "$mo_file" 2>/dev/null || stat -c%s "$mo_file" 2>/dev/null || echo "?")
                echo -e "  ${GREEN}✅ $mo_file créé ($size octets)${NC}"
            else
                echo -e "  ${RED}❌ Erreur lors de la compilation${NC}"
            fi
        fi
    done
    
    echo -e "\n${BLUE}📊 Résumé compilation:${NC}"
    echo -e "  • Fichiers .po traités: ${YELLOW}$po_count${NC}"
    echo -e "  • Fichiers .mo générés: ${GREEN}$mo_count${NC}"
}

# Fonction pour afficher les statistiques
show_stats() {
    echo -e "\n${PURPLE}📊 Statistiques des traductions${NC}"
    
    # Statistiques du POT
    if [ -f "$PLUGIN_SLUG.pot" ]; then
        pot_strings=$(grep -c "^msgid" "$PLUGIN_SLUG.pot" 2>/dev/null || echo "0")
        pot_size=$(stat -f%z "$PLUGIN_SLUG.pot" 2>/dev/null || stat -c%s "$PLUGIN_SLUG.pot" 2>/dev/null || echo "?")
        echo -e "\n${BLUE}📝 Template (.pot):${NC}"
        echo -e "  • Chaînes à traduire: ${YELLOW}$pot_strings${NC}"
        echo -e "  • Taille: ${YELLOW}$pot_size octets${NC}"
    fi
    
    # Statistiques des traductions
    echo -e "\n${BLUE}🌍 Traductions disponibles:${NC}"
    for po_file in *.po; do
        if [ -f "$po_file" ]; then
            lang=$(basename "$po_file" .po | sed "s/$PLUGIN_SLUG-//")
            po_strings=$(grep -c "^msgid" "$po_file" 2>/dev/null || echo "0")
            translated=$(grep -c "^msgstr \"[^\"]*[^\"]*\"" "$po_file" 2>/dev/null || echo "0")
            
            if [ "$po_strings" -gt 0 ]; then
                percentage=$((translated * 100 / po_strings))
            else
                percentage=0
            fi
            
            mo_file="${po_file%.po}.mo"
            if [ -f "$mo_file" ]; then
                mo_size=$(stat -f%z "$mo_file" 2>/dev/null || stat -c%s "$mo_file" 2>/dev/null || echo "?")
                mo_status="${GREEN}✓${NC}"
            else
                mo_size="N/A"
                mo_status="${RED}✗${NC}"
            fi
            
            echo -e "  ${YELLOW}🌐 $lang:${NC} $translated/$po_strings traduit (${percentage}%) | MO: $mo_status ($mo_size octets)"
        fi
    done
}

# Parser les arguments
case "${1:-all}" in
    "pot")
        generate_pot
        ;;
    "compile")
        compile_translations
        ;;
    "all")
        generate_pot
        compile_translations
        show_stats
        ;;
    "stats")
        show_stats
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Option inconnue: $1${NC}"
        show_help
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Terminé !${NC}"