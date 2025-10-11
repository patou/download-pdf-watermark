<?php
/*
Plugin Name: Download PDF Watermark
Description: Ajoute un filigrane personnalisé aux fichiers PDF téléchargés via le site WordPress.
Version: 1.0.0
Author: Patrice de Saint Steban
*/

if (!defined('ABSPATH')) exit;

if (file_exists(__DIR__ . '/vendor/autoload.php')) {
    require_once __DIR__ . '/vendor/autoload.php';
}

// Import des classes nécessaires
use setasign\Fpdi\Fpdi;

// Fonction pour générer le texte du filigrane personnalisé
function dpw_generate_watermark_text($email = '', $order = null, $custom_text = '') {
    // Si un texte personnalisé est fourni, l'utiliser
    if (!empty($custom_text)) {
        return $custom_text;
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
    
    // Construire le texte du filigrane
    $watermark_text = "Acheté sur {$blog_name} par {$customer_name} ({$customer_email})";
    
    // Convertir en ISO-8859-1 pour FPDF avec gestion robuste des accents
    if (function_exists('iconv')) {
        $watermark_text = iconv('UTF-8', 'ISO-8859-1//IGNORE', $watermark_text);
    } else {
        $watermark_text = utf8_decode($watermark_text);
    }
    
    return $watermark_text;
}

// Fonction utilitaire pour ajouter un filigrane à un PDF (exemple, à adapter)
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
    $pdf = new Fpdi();
    $page_count = $pdf->setSourceFile($local_file_path);
    for ($page_no = 1; $page_no <= $page_count; $page_no++) {
        $tpl = $pdf->importPage($page_no);
        $size = $pdf->getTemplateSize($tpl);
        $pdf->AddPage($size['orientation'], [$size['width'], $size['height']]);
        $pdf->useTemplate($tpl);
        // Ajouter le filigrane
        $pdf->SetFont('Arial', '', 12);
        $pdf->SetTextColor(0, 0, 0); // Noir
        // Position plus bas sur la page, centré horizontalement
        $watermark_y = $size['height'] - 6;
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
    
    return $pdf_path;
}

// Interception du téléchargement WooCommerce pour les fichiers PDF
add_filter('woocommerce_download_product_filepath', function($file_path, $email, $order, $product, $download) {
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
