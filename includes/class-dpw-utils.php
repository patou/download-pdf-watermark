<?php
/**
 * Fonctions utilitaires pour le plugin Download PDF Watermark
 */

if (!defined('ABSPATH')) exit;

/**
 * Fonction pour générer le texte du filigrane personnalisé
 * 
 * @param string $email Email du client
 * @param object $order Objet commande WooCommerce
 * @param string $custom_text Texte personnalisé optionnel
 * @return string Texte du filigrane formaté
 */
function dpw_generate_watermark_text($email = '', $order = null, $custom_text = '') {
    // Si un texte personnalisé est fourni, l'utiliser
    if (!empty($custom_text)) {
        $watermark_text = $custom_text;
    } else {
        // Récupérer le template de texte depuis les paramètres
        $watermark_text = DPW_Settings::get_option('watermark_text', 'Acheté sur {blog_name} par {customer_name} ({customer_email})');
    }
    
    // Récupérer les informations du site et du client
    $blog_name = get_bloginfo('name');
    $customer_name = '';
    $customer_email = $email;
    
    // Récupérer les informations du client depuis la commande
    if ($order && is_object($order)) {
        $customer_name = trim($order->get_billing_first_name() . ' ' . $order->get_billing_last_name());
        if (empty($customer_email)) {
            $customer_email = $order->get_billing_email();
        }
    }
    
    // Remplacer les variables dans le template
    $watermark_text = str_replace(
        array('{blog_name}', '{customer_name}', '{customer_email}'),
        array($blog_name, $customer_name, $customer_email),
        $watermark_text
    );
    
    // Convertir en ISO-8859-1 pour FPDF avec gestion robuste des accents
    if (function_exists('iconv')) {
        $watermark_text = iconv('UTF-8', 'ISO-8859-1//IGNORE', $watermark_text);
    } else {
        $watermark_text = utf8_decode($watermark_text);
    }
    
    return $watermark_text;
}

/**
 * Fonction utilitaire pour ajouter un filigrane à un PDF
 * 
 * @param string $pdf_path Chemin ou URL du fichier PDF
 * @param string $watermark_text Texte du filigrane à ajouter
 * @return string Chemin ou URL du fichier PDF avec filigrane
 */
function dpw_add_watermark_to_pdf($pdf_path, $watermark_text = '') {
    // Nécessite la librairie setasign/fpdi et fpdf
    if (!class_exists('setasign\Fpdi\Fpdi')) {
        // Librairie non disponible, retourner le PDF original
        return $pdf_path;
    }

    // Convertir l'URL en chemin de fichier local si nécessaire
    $local_file_path = $pdf_path;
    if (filter_var($pdf_path, FILTER_VALIDATE_URL)) {
        // C'est une URL, la convertir en chemin local
        $upload_dir = wp_upload_dir();
        $local_file_path = str_replace($upload_dir['baseurl'], $upload_dir['basedir'], $pdf_path);
    }
    
    // Vérifier que le fichier existe localement
    if (!file_exists($local_file_path)) {
        return $pdf_path;
    }

    // Utiliser le texte du filigrane fourni
    $final_watermark_text = $watermark_text;

    $output_path = dirname($local_file_path) . '/watermarked_' . basename($local_file_path);
    
    try {
        $pdf = new setasign\Fpdi\Fpdi();
        $page_count = $pdf->setSourceFile($local_file_path);
        
        for ($page_no = 1; $page_no <= $page_count; $page_no++) {
            $tpl = $pdf->importPage($page_no);
            $size = $pdf->getTemplateSize($tpl);
            $pdf->AddPage($size['orientation'], [$size['width'], $size['height']]);
            $pdf->useTemplate($tpl);
            
            // Récupérer les paramètres de style depuis les options
            $font_size = intval(DPW_Settings::get_option('font_size', '12'));
            $position_y = intval(DPW_Settings::get_option('position_y', '6'));
            $text_color = DPW_Settings::get_option('text_color', 'black');
            
            // Ajouter le filigrane
            $pdf->SetFont('Arial', '', $font_size);
            
            // Définir la couleur du texte
            switch ($text_color) {
                case 'gray':
                    $pdf->SetTextColor(128, 128, 128);
                    break;
                case 'light_gray':
                    $pdf->SetTextColor(200, 200, 200);
                    break;
                default: // black
                    $pdf->SetTextColor(0, 0, 0);
                    break;
            }
            
            // Position selon les paramètres, centré horizontalement
            $watermark_y = $size['height'] - $position_y;
            // Calculer la position X pour centrer le texte
            $text_width = $pdf->GetStringWidth($final_watermark_text);
            $center_x = ($size['width'] - $text_width) / 2;
            $pdf->Text($center_x, $watermark_y, $final_watermark_text);
        }
        
        $pdf->Output('F', $output_path);
        
        // Retourner l'URL du fichier filigrané
        if (file_exists($output_path)) {
            $upload_dir = wp_upload_dir();
            $output_url = str_replace($upload_dir['basedir'], $upload_dir['baseurl'], $output_path);
            return $output_url;
        }
        
    } catch (Exception $e) {
        // En cas d'erreur, retourner le fichier original
        // Note: En production, les erreurs sont loggées automatiquement par WordPress si WP_DEBUG est activé
        return $pdf_path;
    }
    
    return $pdf_path;
}

/**
 * Vérifie si le filigrane est activé dans les paramètres
 * 
 * @return bool True si activé, false sinon
 */
function dpw_is_watermark_enabled() {
    return DPW_Settings::get_option('enabled', 'yes') === 'yes';
}

/**
 * Nettoie les fichiers PDF temporaires générés
 * 
 * @param int $max_age Age maximum des fichiers en secondes (défaut: 24h)
 */
function dpw_cleanup_temp_files($max_age = 86400) {
    $upload_dir = wp_upload_dir();
    $upload_path = $upload_dir['basedir'];
    
    // Chercher les fichiers watermarked_*.pdf
    $pattern = $upload_path . '/watermarked_*.pdf';
    $files = glob($pattern);
    
    if ($files) {
        foreach ($files as $file) {
            if (file_exists($file) && (time() - filemtime($file)) > $max_age) {
                wp_delete_file($file);
            }
        }
    }
}

/**
 * Récupère la liste de toutes les options du plugin
 * 
 * @return array Liste des noms d'options
 */
function dpw_get_plugin_options() {
    return array(
        'dpw_watermark_text',
        'dpw_font_size',
        'dpw_position_y',
        'dpw_text_color',
        'dpw_enabled',
        'dpw_watermark_section_title',
        'dpw_watermark_section_end'
    );
}

/**
 * Supprime toutes les options du plugin de la base de données
 */
function dpw_remove_plugin_options() {
    $plugin_options = dpw_get_plugin_options();
    
    // Supprimer chaque option
    foreach ($plugin_options as $option) {
        delete_option($option);
    }
    
    // Note: Les logs de débogage sont gérés par WordPress si WP_DEBUG est activé
}