#!/bin/bash

# Script pour compiler les fichiers de traduction PO en MO
# Utilise WP-CLI pour une meilleure intégration WordPress

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌍 Compilation des fichiers de traduction avec WP-CLI${NC}"

# Vérifier si WP-CLI est installé
if ! command -v wp &> /dev/null; then
    echo -e "${RED}❌ Erreur: WP-CLI n'est pas installé.${NC}"
    echo "Installez WP-CLI depuis: https://wp-cli.org/"
    echo "Ou utilisez une alternative:"
    echo "  - Homebrew (macOS): brew install wp-cli"
    echo "  - Composer: composer global require wp-cli/wp-cli"
    exit 1
fi

echo -e "${YELLOW}📋 Version WP-CLI:${NC}"
wp --version

echo -e "\n${YELLOW}📁 Répertoire de travail:${NC} $(pwd)"

# Compiler tous les fichiers .po en .mo
echo -e "\n${BLUE}🔨 Compilation en cours...${NC}"
po_count=0
mo_count=0

for po_file in *.po; do
    if [ -f "$po_file" ]; then
        po_count=$((po_count + 1))
        echo -e "\n${YELLOW}📝 Traitement:${NC} $po_file"
        
        # Utiliser WP-CLI pour compiler
        if wp i18n make-mo "$po_file" --quiet; then
            mo_count=$((mo_count + 1))
            mo_file="${po_file%.po}.mo"
            size=$(stat -f%z "$mo_file" 2>/dev/null || stat -c%s "$mo_file" 2>/dev/null || echo "?")
            echo -e "  ${GREEN}✅ $mo_file créé avec succès ($size octets)${NC}"
        else
            echo -e "  ${RED}❌ Erreur lors de la compilation de $po_file${NC}"
        fi
    fi
done

echo -e "\n${BLUE}📊 Résumé:${NC}"
echo -e "  • Fichiers .po trouvés: ${YELLOW}$po_count${NC}"
echo -e "  • Fichiers .mo générés: ${GREEN}$mo_count${NC}"

if [ $po_count -eq 0 ]; then
    echo -e "\n${YELLOW}⚠️  Aucun fichier .po trouvé dans le répertoire courant${NC}"
    exit 1
fi

# Afficher la liste des fichiers générés
echo -e "\n${BLUE}📂 Fichiers de traduction disponibles:${NC}"
if ls *.mo >/dev/null 2>&1; then
    for mo_file in *.mo; do
        size=$(stat -f%z "$mo_file" 2>/dev/null || stat -c%s "$mo_file" 2>/dev/null || echo "?")
        echo -e "  ${GREEN}📄 $mo_file${NC} (${size} octets)"
    done
else
    echo -e "  ${RED}❌ Aucun fichier .mo trouvé${NC}"
fi

echo -e "\n${GREEN}🎉 Compilation terminée !${NC}"

# Vérifier l'intégrité des fichiers générés
echo -e "\n${BLUE}🔍 Vérification de l'intégrité...${NC}"
for mo_file in *.mo; do
    if [ -f "$mo_file" ]; then
        if [ -s "$mo_file" ]; then
            echo -e "  ${GREEN}✅ $mo_file : OK${NC}"
        else
            echo -e "  ${RED}⚠️  $mo_file : Fichier vide${NC}"
        fi
    fi
done