<?php
// Google OAuth Login Initiation
require_once __DIR__ . '/../config/config.php';

$action = $_GET['action'] ?? 'login';
// Verify user is logged in if action is link
if ($action === 'link') {
    session_start();
    if (!isset($_SESSION['user_id'])) {
        header('Location: /User-Management/login');
        exit;
    }
}

$state = base64_encode(json_encode(['action' => $action]));

// Build Google OAuth URL
$params = [
    'client_id' => GOOGLE_CLIENT_ID,
    'redirect_uri' => GOOGLE_REDIRECT_URI,
    'response_type' => 'code',
    'scope' => 'email profile',
    'access_type' => 'online',
    'state' => $state
];

// Require login/select account during binding to allow changing/choosing the Google account
if ($action === 'link') {
    $params['prompt'] = 'select_account';
}

$authUrl = 'https://accounts.google.com/o/oauth2/v2/auth?' . http_build_query($params);

// Redirect to Google
header('Location: ' . $authUrl);
exit;
