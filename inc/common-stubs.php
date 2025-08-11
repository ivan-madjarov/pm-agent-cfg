<?php
/**
 * Enhanced Common Application Classes and Functions Stubs
 * This file provides comprehensive type hints for custom classes and global functions
 * used across the Mitel Networks application including validation classes.
 */

// ========================================================================
// Google Translator Class Stub
// ========================================================================

class google_translator {
    public $langIn = 'en';
    public $langOut = 'en'; 
    public $active_lang = [];
    public $months = [];
    
    public function __construct() {}
    public function translate($text, $langOut = null) { return $text; }
    public function date($format, $timestamp = null) { return date($format, $timestamp); }
    public function setLanguage($language) { return $this; }
    public function getLanguage() { return $this->langOut; }
    public function getAvailableLanguages() { return $this->active_lang; }
}

// ========================================================================
// Customer Object Class Stub  
// ========================================================================

class customerObject {
    public $customer_id = 0;
    public $site_id = 0;
    public $customer_name = '';
    public $device_count = 0;
    public $active_devices = 0;
    public $inactive_devices = 0;
    
    public function __construct() {}
    public function getCustomers() { return []; }
    public function getCustomer($id) { return null; }
    public function getSites($customer_id = 0) { return []; }
    public function getSite($id) { return null; }
    public function getDevices($customer_id = 0, $site_id = 0) { return []; }
    public function getDevice($id) { return null; }
    public function setCustomer($id) { return $this; }
    public function setSite($id) { return $this; }
}

// ========================================================================
// Validation Classes
// ========================================================================

class validate_data_collector {
    public $session;
    public $device_id;
    public $error_message;
    
    public function __construct($session, $device_id = false, $error_message = '') {
        $this->session = $session;
        $this->device_id = $device_id;
        $this->error_message = $error_message;
    }
    
    public function validate() { return true; }
    public function getErrors() { return []; }
    public function getWarnings() { return []; }
    public function getData() { return []; }
    public function getStatus() { return 'ok'; }
}

// ========================================================================
// Google Cloud Storage Client (for zsd_audit_fetch.php)
// ========================================================================

class StorageClient {
    public function __construct($config = []) {}
    public function bucket($name) { return new StorageBucket(); }
    public function upload($data, $options = []) { return null; }
    public function download($object) { return null; }
}

class StorageBucket {
    public function upload($data, $options = []) { return null; }
    public function object($name) { return new StorageObject(); }
    public function objects($options = []) { return []; }
}

class StorageObject {
    public function download() { return null; }
    public function delete() { return true; }
    public function info() { return []; }
}

// ========================================================================
// Global Utility Functions
// ========================================================================

/**
 * Test if user has specific permissions
 * @param string $permission Permission to test
 * @return bool
 */
function testForUser($permission) { return true; }

/**
 * Clean and sanitize request input
 * @param mixed $input Input to clean
 * @return mixed
 */
function cleanRequestInput($input) { return $input; }

/**
 * Generate session token
 * @return string
 */
function generateSessionToken() { return uniqid('session_', true); }

/**
 * Validate session token
 * @param string $token Token to validate
 * @return bool
 */
function validateSessionToken($token) { return !empty($token); }

/**
 * Log application events
 * @param string $message Message to log
 * @param string $level Log level (info, warning, error)
 * @return void
 */
function logEvent($message, $level = 'info') {}

/**
 * Format currency values
 * @param float $amount Amount to format
 * @param string $currency Currency code
 * @return string
 */
function formatCurrency($amount, $currency = 'USD') { return '$' . number_format($amount, 2); }

/**
 * Database connection helper
 * @param array $config Database configuration
 * @return PDO|false
 */
function getDatabaseConnection($config = []) { return new PDO('sqlite::memory:'); }

/**
 * Send email notification
 * @param string $to Recipient email
 * @param string $subject Email subject
 * @param string $message Email body
 * @return bool
 */
function sendEmailNotification($to, $subject, $message) { return true; }

/**
 * Encrypt sensitive data
 * @param string $data Data to encrypt
 * @param string $key Encryption key
 * @return string
 */
function encryptData($data, $key = '') { return base64_encode($data); }

/**
 * Decrypt sensitive data
 * @param string $encrypted Encrypted data
 * @param string $key Decryption key
 * @return string
 */
function decryptData($encrypted, $key = '') { return base64_decode($encrypted); }

/**
 * Generate unique identifier
 * @param string $prefix Optional prefix
 * @return string
 */
function generateUniqueId($prefix = '') { return $prefix . uniqid('', true); }

/**
 * Validate email address
 * @param string $email Email to validate
 * @return bool
 */
function validateEmail($email) { return filter_var($email, FILTER_VALIDATE_EMAIL) !== false; }

/**
 * Sanitize HTML content
 * @param string $html HTML content to sanitize
 * @return string
 */
function sanitizeHtml($html) { return htmlspecialchars($html, ENT_QUOTES, 'UTF-8'); }

/**
 * Format date for display
 * @param string|int $date Date to format
 * @param string $format Date format
 * @return string
 */
function formatDate($date, $format = 'Y-m-d H:i:s') { 
    if (is_numeric($date)) {
        return date($format, $date);
    }
    return date($format, strtotime($date));
}

/**
 * Check if user is authenticated
 * @return bool
 */
function isAuthenticated() { return isset($_SESSION['user_id']); }

/**
 * Get current user information
 * @return array|null
 */
function getCurrentUser() { 
    return isAuthenticated() ? ['id' => $_SESSION['user_id'] ?? 0, 'name' => $_SESSION['user_name'] ?? ''] : null; 
}

/**
 * Calculate time difference in human readable format
 * @param string|int $start Start time
 * @param string|int $end End time
 * @return string
 */
function getTimeDifference($start, $end = null) {
    if ($end === null) $end = time();
    if (is_string($start)) $start = strtotime($start);
    if (is_string($end)) $end = strtotime($end);
    
    $diff = abs($end - $start);
    return $diff . ' seconds';
}

/**
 * Parse CSV data
 * @param string $csv CSV content
 * @param string $delimiter Field delimiter
 * @return array
 */
function parseCSV($csv, $delimiter = ',') {
    return array_map('str_getcsv', explode("\n", $csv));
}

/**
 * Generate CSV from array
 * @param array $data Data to convert
 * @return string
 */
function generateCSV($data) {
    $output = '';
    foreach ($data as $row) {
        $output .= implode(',', array_map(function($field) {
            return '"' . str_replace('"', '""', $field) . '"';
        }, $row)) . "\n";
    }
    return $output;
}

/**
 * Check if string contains specific patterns
 * @param string $haystack String to search in
 * @param string|array $needles Pattern(s) to search for
 * @return bool
 */
function containsPattern($haystack, $needles) {
    if (is_string($needles)) $needles = [$needles];
    foreach ($needles as $needle) {
        if (strpos($haystack, $needle) !== false) return true;
    }
    return false;
}

/**
 * Get file extension
 * @param string $filename Filename to analyze
 * @return string
 */
function getFileExtension($filename) {
    return strtolower(pathinfo($filename, PATHINFO_EXTENSION));
}

/**
 * Check if file type is allowed
 * @param string $filename Filename to check
 * @param array $allowedTypes Allowed file extensions
 * @return bool
 */
function isAllowedFileType($filename, $allowedTypes = ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx']) {
    return in_array(getFileExtension($filename), $allowedTypes);
}

// ========================================================================
// Constants
// ========================================================================

define('APP_VERSION', '2.0.0');
define('DEFAULT_TIMEOUT', 30);
define('MAX_FILE_SIZE', 10485760); // 10MB
define('UPLOAD_PATH', '/uploads/');
define('LOG_PATH', '/logs/');
define('CACHE_TIMEOUT', 3600);
define('SESSION_TIMEOUT', 1800);
define('DEFAULT_LANGUAGE', 'en');
define('SUPPORTED_LANGUAGES', 'en,fr,es,de');
define('DEBUG_MODE', false);
define('API_VERSION', 'v1');
define('MAX_RETRY_ATTEMPTS', 3);
define('DEFAULT_PAGE_SIZE', 50);
define('MAX_PAGE_SIZE', 1000);
