=== Download PDF Watermark ===
Contributors: patou
Donate link: https://github.com/patou/download-pdf-watermark
Tags: pdf, watermark, woocommerce, download, digital
Requires at least: 5.0
Tested up to: 6.8
Requires PHP: 7.4
Stable tag: 1.0.0
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Add custom watermarks to PDF files downloaded through your WordPress site, with full WooCommerce integration.

== Description ==

Download PDF Watermark is a powerful WordPress plugin that automatically adds custom watermarks to PDF files when they are downloaded through your website. Perfect for digital product protection, document security, and customer personalization.

**Key Features:**

* **Automatic PDF Watermarking**: Seamlessly adds watermarks to PDF downloads without user intervention
* **WooCommerce Integration**: Full support for WooCommerce digital products and downloads
* **Customizable Text**: Use dynamic placeholders for personalized watermarks
* **Flexible Positioning**: Configure watermark position, font size, and color
* **Customer Information**: Include customer name, email, and site information in watermarks
* **Secure Processing**: Files are processed server-side with automatic cleanup
* **Performance Optimized**: Lightweight processing with minimal server impact

**Dynamic Placeholders:**

* `{blog_name}` - Your website name
* `{customer_name}` - Customer's full name
* `{customer_email}` - Customer's email address

**Perfect for:**

* Digital product sellers
* Document protection
* License compliance
* Customer personalization
* Content security
* Professional branding

**Technical Features:**

* Uses industry-standard FPDF and FPDI libraries
* Automatic temporary file cleanup
* Multi-language support ready
* WordPress coding standards compliant
* Comprehensive unit testing
* PSR-4 autoloading

== Installation ==

**Automatic Installation:**

1. Log in to your WordPress admin panel
2. Go to Plugins > Add New
3. Search for "Download PDF Watermark"
4. Click "Install Now" and then "Activate"

**Manual Installation:**

1. Download the plugin zip file
2. Upload it via Plugins > Add New > Upload Plugin
3. Activate the plugin through the 'Plugins' menu

**Configuration:**

1. Go to Settings > PDF Watermark
2. Enable watermarking
3. Customize your watermark text using placeholders
4. Configure font size, position, and color
5. Save your settings

== Frequently Asked Questions ==

= Does this work with WooCommerce? =

Yes! The plugin is fully integrated with WooCommerce and automatically watermarks PDF files when customers download digital products.

= What PDF libraries are required? =

The plugin uses setasign/fpdf and setasign/fpdi libraries, which are included via Composer. No additional installation is required.

= Can I customize the watermark text? =

Absolutely! You can use dynamic placeholders like {customer_name}, {customer_email}, and {blog_name} to create personalized watermarks.

= Will this slow down my website? =

No, the plugin is optimized for performance. Watermarks are added during download with minimal server impact, and temporary files are automatically cleaned up.

= Can I change the watermark position? =

Yes, you can configure the watermark position, font size, and color through the settings page.

= Does it work with any theme? =

Yes, the plugin works independently of your theme and integrates seamlessly with any WordPress installation.

= Is it translation ready? =

Yes, the plugin is prepared for translations and includes a .pot file for translators.

= What happens to temporary files? =

The plugin automatically cleans up temporary watermarked files daily to prevent server storage issues.

== Screenshots ==

1. **Settings Page** - Configure watermark text, position, and styling options
2. **Watermark Preview** - Example of a watermarked PDF with customer information
3. **WooCommerce Integration** - Seamless integration with digital product downloads

== Changelog ==

= 1.0.0 =
* Initial release
* Automatic PDF watermarking for downloads
* WooCommerce integration
* Customizable watermark text with placeholders
* Configurable font size, position, and color
* Automatic temporary file cleanup
* Multi-language support preparation
* Comprehensive unit testing
* WordPress coding standards compliance

== Upgrade Notice ==

= 1.0.0 =
Initial release of Download PDF Watermark. Install to start protecting your PDF downloads with custom watermarks.

== Technical Details ==

**Requirements:**
* PHP 7.4 or higher
* WordPress 5.0 or higher
* WooCommerce (optional, for e-commerce integration)

**Libraries Used:**
* setasign/fpdf - PDF generation and manipulation
* setasign/fpdi - PDF import and template handling

**Security Features:**
* Server-side PDF processing
* Automatic file cleanup
* Input sanitization
* WordPress security standards compliance

**Performance:**
* Lightweight processing
* Automatic cleanup prevents storage bloat
* Optimized for high-volume downloads

== Support ==

For support, feature requests, or bug reports:

* GitHub: https://github.com/patou/download-pdf-watermark
* WordPress.org Support Forum: Use the plugin support forum

**Contributing:**
We welcome contributions! Please visit our GitHub repository to submit pull requests or report issues.

== Privacy Policy ==

This plugin does not collect or store any personal user data beyond what WordPress normally handles. Customer information used in watermarks comes from existing WordPress/WooCommerce data and is only used for watermark generation during download.

== Credits ==

* Developed by Patrice de Saint Steban
* Uses FPDF library by Olivier Plathey
* Uses FPDI library by Setasign
* Testing framework: PHPUnit
* Code quality: WordPress Coding Standards