<?php
// Google OAuth Callback Handler
session_start();
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/Session.php';
require_once __DIR__ . '/../models/UserLog.php';

if (!isset($_GET['code'])) {
    header('Location: /User-Management/login');
    exit;
}

$code = $_GET['code'];

// Exchange code for access token
$tokenUrl = 'https://oauth2.googleapis.com/token';
$tokenData = [
    'code' => $code,
    'client_id' => GOOGLE_CLIENT_ID,
    'client_secret' => GOOGLE_CLIENT_SECRET,
    'redirect_uri' => GOOGLE_REDIRECT_URI,
    'grant_type' => 'authorization_code'
];

$ch = curl_init($tokenUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($tokenData));
$response = curl_exec($ch);
curl_close($ch);

$tokenResponse = json_decode($response, true);

if (!isset($tokenResponse['access_token'])) {
    header('Location: /User-Management/login?error=oauth_failed');
    exit;
}

// Get user info from Google
$userInfoUrl = 'https://www.googleapis.com/oauth2/v2/userinfo';
$ch = curl_init($userInfoUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $tokenResponse['access_token']]);
$userInfoResponse = curl_exec($ch);
curl_close($ch);

$userInfo = json_decode($userInfoResponse, true);

if (!isset($userInfo['id'])) {
    header('Location: /User-Management/login?error=oauth_failed');
    exit;
}

// Connect to database
$database = new Database();
$db = $database->connect();
$userModel = new User($db);

// Handle Actions (Link vs Login)
$state = isset($_GET['state']) ? json_decode(base64_decode($_GET['state']), true) : [];
$action = $state['action'] ?? 'login';

if ($action === 'link') {
    if (!isset($_SESSION['user_id'])) {
        header('Location: /User-Management/login');
        exit;
    }

    $existing = $userModel->getUserByGmail($userInfo['id']);
    if ($existing && $existing['user_id'] != $_SESSION['user_id']) {
        // Account already bound to another user
        header('Location: /User-Management/user/dashboard?error=gmail_taken');
        exit;
    }

    $currentUser = $userModel->getUserById($_SESSION['user_id']);
    $currentUser['gmail_id'] = $userInfo['id'];
    $currentUser['email'] = $userInfo['email']; // Update local email address based on the bound Google account

    // Update profile
    $userModel->updateProfile($_SESSION['user_id'], $currentUser);

    // Log
    $logModel = new UserLog($db);
    $logModel->logActivity($_SESSION['user_id'], $_SESSION['username'], 'Link Gmail', 'Linked Gmail Account', $_SERVER['REMOTE_ADDR'], $_SERVER['HTTP_USER_AGENT']);

    // Determine redirect based on user level
    $redirect = $_SESSION['user_level'] === 'Admin' ? '/admin/dashboard' : '/user/dashboard';
    header('Location: /User-Management' . $redirect . '?success=gmail_linked');
    exit;
}

// Check if user exists (Login Flow)
$user = $userModel->getUserByGmail($userInfo['id']);

if (!$user) {
    // If not found by Gmail ID, check by email
    $user = $userModel->getUserByEmail($userInfo['email']);
    
    if ($user) {
        // Link Gmail ID to the existing account
        $user['gmail_id'] = $userInfo['id'];
        $userModel->updateProfile($user['user_id'], $user);
    } else {
        // Auto-register user via Google SSO
        $emailParts = explode('@', $userInfo['email']);
        $baseUsername = $emailParts[0];
        
        // Clean username (only alphanumeric, dots, underscores, hyphens)
        $username = preg_replace('/[^a-zA-Z0-9._-]/', '', $baseUsername);
        if (empty($username)) {
            $username = 'user_' . rand(1000, 9999);
        }
        
        // Ensure username uniqueness
        $originalUsername = $username;
        $counter = 1;
        while ($userModel->getUserByUsername($username)) {
            $username = $originalUsername . $counter;
            $counter++;
        }

        $randomPassword = bin2hex(random_bytes(16));
        $password_hash = password_hash($randomPassword, PASSWORD_DEFAULT);
        
        $registerResult = $userModel->register([
            'username' => $username,
            'account_name' => $userInfo['name'] ?? $username,
            'email' => $userInfo['email'],
            'password_hash' => $password_hash,
            'gmail_id' => $userInfo['id'],
            'twofa_secret' => null,
            'twofa_enabled' => 0
        ]);

        if ($registerResult && isset($registerResult['user_id'])) {
            // Log registration activity
            $logModel = new UserLog($db);
            $logModel->logActivity(
                $registerResult['user_id'],
                $username,
                'Registration',
                'User registered account via Google Single Sign-on (Pending Admin Approval)',
                $_SERVER['REMOTE_ADDR'],
                $_SERVER['HTTP_USER_AGENT']
            );
            
            header('Location: /User-Management/login?registered=pending_approval');
            exit;
        } else {
            header('Location: /User-Management/login?error=oauth_failed');
            exit;
        }
    }
}

// Strict user status checks
if ($user['user_status'] === 'Deleted') {
    header('Location: /User-Management/login?error=account_deleted');
    exit;
}
if ($user['user_status'] === 'Suspended') {
    header('Location: /User-Management/login?error=account_suspended');
    exit;
}
if ($user['user_status'] === 'Inactive') {
    header('Location: /User-Management/login?error=account_inactive');
    exit;
}

// Create session
$sessionModel = new Session($db);
$session_token = $sessionModel->generateSessionToken();

$sessionModel->createSession(
    $user['user_id'],
    $session_token,
    $_SERVER['REMOTE_ADDR'],
    $_SERVER['HTTP_USER_AGENT'],
    'Desktop'
);

// Deactivate other sessions
$sessionModel->deactivateOtherSessions($user['user_id'], $session_token);

// Set session variables
$_SESSION['user_id'] = $user['user_id'];
$_SESSION['username'] = $user['username'];
$_SESSION['account_name'] = $user['account_name'];
$_SESSION['user_level'] = $user['user_level'];
$_SESSION['user_status'] = $user['user_status'];
$_SESSION['session_token'] = $session_token;

// Log activity
$logModel = new UserLog($db);
$logModel->logActivity(
    $user['user_id'],
    $user['username'],
    'Login',
    'User logged in via Google OAuth',
    $_SERVER['REMOTE_ADDR'],
    $_SERVER['HTTP_USER_AGENT']
);

// Redirect to dashboard
$redirect = $user['user_level'] === 'Admin' ? '/admin/dashboard' : '/user/dashboard';
header('Location: /User-Management' . $redirect);
exit;
