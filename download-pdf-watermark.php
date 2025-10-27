<?php
/**
 * Plugin Name: Download PDF Watermark
 * Description: Ajoute un filigrane personnalisé aux fichiers PDF téléchargés via le site WordPress.
 * Version: 1.0.0
 * Author: Patrice de Saint Steban
 * Text Domain: download-pdf-watermark
 * Domain Path: /languages
 * Requires at least: 5.0
 * Tested up to: 6.8
 * Requires PHP: 7.4
 * Requires Plugins: woocommerce
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * 
 * @package         Download_PDF_Watermark
 * 
 * @wordpress-plugin
 */

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly
}

// Charger l'autoloader Composer
if (file_exists(__DIR__ . '/vendor/autoload.php')) {
    require_once __DIR__ . '/vendor/autoload.php';
}

// Charger les fichiers nécessaires de manière sécurisée
if (file_exists(__DIR__ . '/admin/class-dpw-settings.php')) {
    require_once __DIR__ . '/admin/class-dpw-settings.php';
}

if (file_exists(__DIR__ . '/includes/class-dpw-utils.php')) {
    require_once __DIR__ . '/includes/class-dpw-utils.php';
}

// Initialiser les paramètres d'administration
if (is_admin() && class_exists('DPW_Settings')) {
    DPW_Settings::init();
}

// Les traductions sont automatiquement chargées par WordPress pour les plugins hébergés sur wordpress.org

// Initialiser le plugin de manière sécurisée
add_action('plugins_loaded', 'dpw_init_plugin');

/**
 * Initialise le plugin après le chargement de WordPress
 */
function dpw_init_plugin() {
    // Vérifier que les fonctions nécessaires existent
    if (!function_exists('dpw_is_watermark_enabled') || !function_exists('dpw_add_watermark_to_pdf')) {
        return;
    }
    
    // Interception du téléchargement WooCommerce pour les fichiers PDF
    add_filter('woocommerce_download_product_filepath', function($file_path, $email, $order, $product, $download) {
        // Vérifier si le filigrane est activé
        if (!dpw_is_watermark_enabled()) {
            return $file_path;
        }
        
        // Vérifie si le fichier est un PDF
        if (strtolower(pathinfo($file_path, PATHINFO_EXTENSION)) === 'pdf') {
            // Générer le texte du filigrane personnalisé
            $watermark_text = dpw_generate_watermark_text($email, $order);
            // Applique le filigrane avec le texte généré
            $watermarked = dpw_add_watermark_to_pdf($file_path, $watermark_text);
            return $watermarked;
        }
        return $file_path;
    }, 10, 5);
    
    // Nettoyer les fichiers temporaires quotidiennement
    if (!wp_next_scheduled('dpw_cleanup_temp_files')) {
        wp_schedule_event(time(), 'daily', 'dpw_cleanup_temp_files');
    }
    
    add_action('dpw_cleanup_temp_files', 'dpw_cleanup_temp_files');
}

// Nettoyer lors de la désactivation du plugin
register_deactivation_hook(__FILE__, function() {
    // Supprimer la tâche cron programmée
    if (function_exists('wp_clear_scheduled_hook')) {
        wp_clear_scheduled_hook('dpw_cleanup_temp_files');
    }
    
    // Supprimer tous les fichiers PDF temporaires
    if (function_exists('dpw_cleanup_temp_files')) {
        dpw_cleanup_temp_files(0);
    }
    
    // Supprimer toutes les options du plugin de la base de données
    dpw_remove_plugin_options();
});
