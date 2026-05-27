<?php
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../helpers/GoogleAuthenticator.php';

class TwoFactorController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        // requireAuth removed to allow registration usage
    }

    public function generate()
    {
        try {
            $ga = new GoogleAuthenticator();
            $secret = $ga->createSecret();

            $username = $_SESSION['username'] ?? 'New User';

            // Allow overriding via POST (e.g. from registration form)
            if (isset($_POST['username'])) {
                $username = $_POST['username'];
            }

            // Generate otpauth URI for kjua JS library (instead of Google Charts URL)
            $otpauth = 'otpauth://totp/' . rawurlencode(APP_NAME) . ':' . rawurlencode($username) . '?secret=' . $secret . '&issuer=' . rawurlencode(APP_NAME);

            // For backward compatibility variable name, but now contains raw URI
            $qrCodeUrl = $otpauth;

            $this->jsonResponse([
                'success' => true,
                'secret' => $secret,
                'qrCodeUrl' => $qrCodeUrl
            ]);

        } catch (Exception $e) {
            error_log("2FA Generate Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'Failed to generate 2FA secret']);
        }
    }

    public function verify()
    {
        try {
            $secret = $_POST['secret'] ?? '';
            $code = $_POST['code'] ?? '';

            if (empty($secret) || empty($code)) {
                $this->jsonResponse(['success' => false, 'message' => 'Secret and code are required']);
            }

            $ga = new GoogleAuthenticator();
            $isValid = $ga->verifyCode($secret, $code, 2);

            if ($isValid) {
                $this->jsonResponse(['success' => true, 'message' => '2FA code verified successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Invalid 2FA code']);
            }

        } catch (Exception $e) {
            error_log("2FA Verify Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'Failed to verify 2FA code']);
        }
    }

    public function enable()
    {
        $this->requireAuth();
        try {
            $secret = $_POST['secret'] ?? '';
            $code = $_POST['code'] ?? '';

            if (empty($secret) || empty($code)) {
                $this->jsonResponse(['success' => false, 'message' => 'Secret and code are required']);
            }

            // Verify the code first
            $ga = new GoogleAuthenticator();
            $isValid = $ga->verifyCode($secret, $code, 2);

            if (!$isValid) {
                $this->jsonResponse(['success' => false, 'message' => 'Invalid 2FA code. Please try again.']);
            }

            // Update user's 2FA settings
            $userModel = $this->loadModel('User');
            $data = [
                'twofa_secret' => $secret,
                'twofa_enabled' => 1
            ];

            $result = $userModel->updateProfile($_SESSION['user_id'], $data);

            if ($result) {
                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    '2FA Enabled',
                    'User enabled two-factor authentication',
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => '2FA has been enabled successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to enable 2FA']);
            }

        } catch (Exception $e) {
            error_log("2FA Enable Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while enabling 2FA']);
        }
    }

    public function disable()
    {
        $this->requireAuth();
        try {
            $password = $_POST['password'] ?? '';

            if (empty($password)) {
                $this->jsonResponse(['success' => false, 'message' => 'Password is required to disable 2FA']);
            }

            // Verify password
            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($_SESSION['user_id']);

            if (!password_verify($password, $user['password_hash'])) {
                $this->jsonResponse(['success' => false, 'message' => 'Invalid password']);
            }

            // Disable 2FA
            $data = [
                'twofa_secret' => null,
                'twofa_enabled' => 0
            ];

            $result = $userModel->updateProfile($_SESSION['user_id'], $data);

            if ($result) {
                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    '2FA Disabled',
                    'User disabled two-factor authentication',
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => '2FA has been disabled successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to disable 2FA']);
            }

        } catch (Exception $e) {
            error_log("2FA Disable Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while disabling 2FA']);
        }
    }
}
