<?php
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/Session.php';
require_once __DIR__ . '/../models/UserLog.php';

class AuthController extends Controller
{

    public function showLogin()
    {
        if (isset($_SESSION['user_id'])) {
            $redirect = $_SESSION['user_level'] === 'Admin' ? '/admin/dashboard' : '/user/dashboard';
            header("Location: /User-Management$redirect");
            exit;
        }
        $this->loadView('auth/login');
    }

    public function showRegister()
    {
        header("Location: /User-Management/login");
        exit;
    }

    public function register()
    {
        header('Content-Type: application/json');
        $this->jsonResponse([
            'success' => false,
            'message' => 'Self-registration is disabled. Please register using Google Single Sign-on instead.'
        ]);
    }

    public function login()
    {
        header('Content-Type: application/json');

        try {
            $username = $_POST['username'] ?? '';
            $password = $_POST['password'] ?? '';
            $twofa_code = $_POST['twofa_code'] ?? '';

            if (empty($username) || empty($password)) {
                $this->jsonResponse(['success' => false, 'message' => 'Username and password are required']);
            }

            $userModel = $this->loadModel('User');
            $user = $userModel->getUserByUsername($username);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'Access denied. Invalid username or password.']);
            }

            // Check if account is locked
            if ($userModel->isAccountLocked($user['user_id'])) {
                $this->jsonResponse(['success' => false, 'message' => 'Account is blocked due to multiple failed login attempts. Please try again after 24 hours.']);
            }

            // Check if account is active
            if ($user['user_status'] === 'Deleted') {
                $this->jsonResponse(['success' => false, 'message' => 'This account has been deleted']);
            }

            if ($user['user_status'] === 'Suspended') {
                $this->jsonResponse(['success' => false, 'message' => 'Account is Suspended. Please contact the administrator.']);
            }

            if ($user['user_status'] === 'Inactive') {
                $this->jsonResponse(['success' => false, 'message' => 'Account is Inactive. Please wait for administrator approval.']);
            }

            // Verify password
            if (!password_verify($password, $user['password_hash'])) {
                $userModel->recordFailedLogin($username);

                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $user['user_id'],
                    $username,
                    'Failed Login',
                    'Invalid password attempt',
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => false, 'message' => 'Access denied. Invalid username or password.']);
            }

            // Check 2FA if enabled
            if ($user['twofa_enabled'] == 1) {
                if (empty($twofa_code)) {
                    $this->jsonResponse(['success' => false, 'message' => '2FA code is required', 'require_2fa' => true]);
                }

                require_once __DIR__ . '/../helpers/GoogleAuthenticator.php';
                $ga = new GoogleAuthenticator();

                if (!$ga->verifyCode($user['twofa_secret'], $twofa_code, 2)) {
                    $userModel->recordFailedLogin($username);

                    $logModel = $this->loadModel('UserLog');
                    $logModel->logActivity(
                        $user['user_id'],
                        $username,
                        'Failed Login',
                        'Invalid 2FA code',
                        $this->getClientIP(),
                        $this->getUserAgent()
                    );

                    $this->jsonResponse(['success' => false, 'message' => 'Invalid 2FA code']);
                }
            }

            // Reset failed login attempts
            $userModel->resetFailedLogin($user['user_id']);

            // Create session
            $sessionModel = $this->loadModel('Session');
            // Generate JWT instead of random string
            $session_token = $sessionModel->generateSessionToken($user['user_id']);

            $device_info = $this->getDeviceInfo();
            $sessionModel->createSession(
                $user['user_id'],
                $session_token,
                $this->getClientIP(),
                $this->getUserAgent(),
                $device_info
            );

            // Deactivate other sessions (logout from other devices)
            $deactivated = $sessionModel->deactivateOtherSessions($user['user_id'], $session_token);

            // Set session variables
            $_SESSION['user_id'] = $user['user_id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['account_name'] = $user['account_name'];
            $_SESSION['user_level'] = $user['user_level'];
            $_SESSION['user_status'] = $user['user_status'];
            $_SESSION['session_token'] = $session_token;

            // Log activity
            $logModel = $this->loadModel('UserLog');
            $logModel->logActivity(
                $user['user_id'],
                $username,
                'Login',
                'User logged in successfully',
                $this->getClientIP(),
                $this->getUserAgent()
            );

            $redirect = $user['user_level'] === 'Admin' ? '/admin/dashboard' : '/user/dashboard';

            $response = [
                'success' => true,
                'message' => 'Login successfully!',
                'redirect' => $redirect,
                'sessions_deactivated' => $deactivated['deactivated_count'] ?? 0
            ];

            $this->jsonResponse($response);

        } catch (Exception $e) {
            error_log("Login Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred during login']);
        }
    }

    public function logout()
    {
        if (isset($_SESSION['session_token'])) {
            $sessionModel = $this->loadModel('Session');
            $sessionModel->deactivateSession($_SESSION['session_token']);

            // Log activity
            if (isset($_SESSION['user_id'])) {
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'] ?? '',
                    'Logout',
                    'User logged out',
                    $this->getClientIP(),
                    $this->getUserAgent()
                );
            }
        }

        session_destroy();
        header('Location: /User-Management/login');
        exit;
    }

    public function checkSession()
    {
        header('Content-Type: application/json');

        if (!isset($_SESSION['user_id']) || !isset($_SESSION['session_token'])) {
            $this->jsonResponse(['valid' => false, 'message' => 'No active session']);
        }

        // Validate JWT
        require_once __DIR__ . '/../helpers/JWT.php';
        $payload = JWT::decode($_SESSION['session_token'], JWT_SECRET);

        if (!$payload) {
            // Invalid JWT
            session_destroy();
            $this->jsonResponse([
                'valid' => false,
                'kicked' => true,
                'message' => 'Session expired or invalid.'
            ]);
        }

        // Check expiration
        if (isset($payload['exp']) && $payload['exp'] < time()) {
            session_destroy();
            $this->jsonResponse([
                'valid' => false,
                'kicked' => true,
                'message' => 'Session expired.'
            ]);
        }

        // Check if token needs renewal (e.g., if it expires in less than 10 minutes)
        // JWT_EXPIRATION is 15 minutes (900s). Let's renew if less than 10 minutes left.
        $needs_renewal = false;
        if (isset($payload['exp']) && ($payload['exp'] - time()) < 600) {
            $needs_renewal = true;
        }

        $sessionModel = $this->loadModel('Session');
        $session = $sessionModel->getActiveSession($_SESSION['session_token']);

        if (!$session) {
            // Session was deactivated (kicked by admin or logged in from another device)
            session_destroy();
            $this->jsonResponse([
                'valid' => false,
                'kicked' => true,
                'message' => 'Your session has been terminated. You have been logged out.'
            ]);
        }

        $new_token = null;
        if ($needs_renewal) {
            $new_token = $sessionModel->generateSessionToken($_SESSION['user_id']);
            $sessionModel->updateSessionToken($_SESSION['session_token'], $new_token);
            $_SESSION['session_token'] = $new_token;
        }

        $this->jsonResponse([
            'valid' => true,
            'renewed' => $needs_renewal,
            'token' => $new_token
        ]);
    }

    private function getDeviceInfo()
    {
        $user_agent = $this->getUserAgent();

        // Simple device detection
        if (preg_match('/mobile/i', $user_agent)) {
            return 'Mobile Device';
        } elseif (preg_match('/tablet/i', $user_agent)) {
            return 'Tablet';
        } else {
            return 'Desktop';
        }
    }
}
