<?php
/**
 * Classe pour gérer les paramètres d'administration du plugin Download PDF Watermark
 */

if (!defined('ABSPATH')) exit;

class DPW_Settings {
    
    /**
     * Initialise les hooks pour les paramètres
     */
    public static function init() {
        add_filter('woocommerce_settings_tabs_array', array(__CLASS__, 'add_settings_tab'), 50);
        add_action('woocommerce_settings_tabs_dpw_watermark', array(__CLASS__, 'settings_tab'));
        add_action('woocommerce_update_options_dpw_watermark', array(__CLASS__, 'update_settings'));
    }
    
    /**
     * Ajoute l'onglet dans les paramètres WooCommerce
     */
    public static function add_settings_tab($settings_tabs) {
        $settings_tabs['dpw_watermark'] = __('PDF Watermark', 'download-pdf-watermark');
        return $settings_tabs;
    }
    
    /**
     * Affiche le contenu de l'onglet des paramètres
     */
    public static function settings_tab() {
        woocommerce_admin_fields(self::get_settings());
    }
    
    /**
     * Met à jour les paramètres
     */
    public static function update_settings() {
        woocommerce_update_options(self::get_settings());
    }
    
    /**
     * Définit les champs de paramètres
     */
    public static function get_settings() {
        $settings = array(
            'section_title' => array(
                'name'     => __('Paramètres du filigrane PDF', 'download-pdf-watermark'),
                'type'     => 'title',
                'desc'     => __('Configurez l\'apparence et le contenu du filigrane ajouté aux fichiers PDF téléchargés.', 'download-pdf-watermark'),
                'id'       => 'dpw_watermark_section_title'
            ),
            
            'watermark_text' => array(
                'name'     => __('Texte du filigrane', 'download-pdf-watermark'),
                'type'     => 'textarea',
                'desc'     => __('Texte à afficher en filigrane. Utilisez {blog_name}, {customer_name} et {customer_email} comme variables.', 'download-pdf-watermark'),
                'id'       => 'dpw_watermark_text',
                'default'  => 'Acheté sur {blog_name} par {customer_name} ({customer_email})',
                'css'      => 'min-width:300px;',
            ),
            
            'font_size' => array(
                'name'     => __('Taille de la police', 'download-pdf-watermark'),
                'type'     => 'number',
                'desc'     => __('Taille de la police du filigrane (en points).', 'download-pdf-watermark'),
                'id'       => 'dpw_font_size',
                'default'  => '12',
                'custom_attributes' => array(
                    'min'  => '6',
                    'max'  => '72',
                    'step' => '1'
                )
            ),
            
            'position_y' => array(
                'name'     => __('Position verticale', 'download-pdf-watermark'),
                'type'     => 'number',
                'desc'     => __('Distance depuis le bas de la page (en pixels).', 'download-pdf-watermark'),
                'id'       => 'dpw_position_y',
                'default'  => '6',
                'custom_attributes' => array(
                    'min'  => '1',
                    'max'  => '100',
                    'step' => '1'
                )
            ),
            
            'text_color' => array(
                'name'     => __('Couleur du texte', 'download-pdf-watermark'),
                'type'     => 'select',
                'desc'     => __('Couleur du texte du filigrane.', 'download-pdf-watermark'),
                'id'       => 'dpw_text_color',
                'default'  => 'black',
                'options'  => array(
                    'black' => __('Noir', 'download-pdf-watermark'),
                    'gray'  => __('Gris', 'download-pdf-watermark'),
                    'light_gray' => __('Gris clair', 'download-pdf-watermark'),
                )
            ),
            
            'enabled' => array(
                'name'     => __('Activer le filigrane', 'download-pdf-watermark'),
                'type'     => 'checkbox',
                'desc'     => __('Cochez pour activer l\'ajout automatique du filigrane aux PDF téléchargés.', 'download-pdf-watermark'),
                'id'       => 'dpw_enabled',
                'default'  => 'yes'
            ),
            
            'section_end' => array(
                'type' => 'sectionend',
                'id'   => 'dpw_watermark_section_end'
            )
        );
        
        return apply_filters('dpw_watermark_settings', $settings);
    }
    
    /**
     * Récupère une option de paramétrage
     */
    public static function get_option($option_name, $default = '') {
        return get_option('dpw_' . $option_name, $default);
    }
}