<?php
// Database Configuration
define('DB_HOST', 'localhost');
define('DB_PORT', '3307');
define('DB_NAME', 'user_management');
define('DB_USER', 'root');
define('DB_PASS', 'Admin1234');

// Google OAuth Configuration
define('GOOGLE_CLIENT_ID', '');
define('GOOGLE_CLIENT_SECRET', '');
define('GOOGLE_REDIRECT_URI', '../google_callback.php');

// Application Configuration
define('APP_NAME', 'CODERSTATION');
define('APP_URL', 'http://localhost/User-Management');
define('SESSION_TIMEOUT', 3600); // 1 hour

// JWT Configuration
define('JWT_SECRET', 'your_super_secret_key_change_this_in_production');
define('JWT_EXPIRATION', 900); // 15 minutes

// Security Configuration
define('PASSWORD_MIN_LENGTH', 10);
define('MAX_LOGIN_ATTEMPTS', 3);
define('LOGIN_BLOCK_DURATION', 86400); // 24 hours

// Timezone
date_default_timezone_set('Asia/Manila');
