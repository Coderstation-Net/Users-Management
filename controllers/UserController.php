<?php
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/UserLog.php';

class UserController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->requireAuth();
    }

    public function dashboard()
    {
        $this->loadView('user/dashboard');
    }

    public function getProfile()
    {
        $userModel = $this->loadModel('User');
        $user = $userModel->getUserById($_SESSION['user_id']);

        if ($user) {
            // Remove sensitive data
            unset($user['password_hash']);
            $this->jsonResponse(['success' => true, 'user' => $user]);
        } else {
            $this->jsonResponse(['success' => false, 'message' => 'User not found']);
        }
    }

    public function updateProfile()
    {
        try {
            $user_id = $_SESSION['user_id'];
            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            $data = [
                'username' => $_POST['username'] ?? $user['username'],
                'account_name' => $_POST['account_name'] ?? $user['account_name'],
                'email' => $user['email'],
                'gmail_id' => $_POST['gmail_id'] ?? $user['gmail_id'],
                'twofa_secret' => $user['twofa_secret'],
                'twofa_enabled' => $_POST['twofa_enabled'] ?? $user['twofa_enabled'],
                'password_hash' => '',
                'user_level' => $user['user_level'], // Users can't change their own level
                'user_status' => $user['user_status'] // Users can't change their own status
            ];

            // Update password if provided
            if (!empty($_POST['password'])) {
                if ($_POST['password'] !== $_POST['confirm_password']) {
                    $this->jsonResponse(['success' => false, 'message' => 'Passwords do not match']);
                }
                $data['password_hash'] = password_hash($_POST['password'], PASSWORD_BCRYPT);
            }

            $result = $userModel->updateProfile($user_id, $data);

            if ($result) {
                // Update session data
                $_SESSION['username'] = $data['username'];
                $_SESSION['account_name'] = $data['account_name'];

                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $user_id,
                    $_SESSION['username'],
                    'Profile Update',
                    'User updated their profile',
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => 'Profile updated successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to update profile']);
            }

        } catch (Exception $e) {
            error_log("Update Profile Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while updating profile']);
        }
    }

    public function unlinkGmail()
    {
        try {
            $user_id = $_SESSION['user_id'];
            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            if (empty($user['gmail_id'])) {
                $this->jsonResponse(['success' => false, 'message' => 'No Google account is linked']);
            }

            $data = [
                'username'      => $user['username'],
                'account_name'  => $user['account_name'],
                'email'         => $user['email'],
                'gmail_id'      => null,
                'twofa_secret'  => $user['twofa_secret'],
                'twofa_enabled' => $user['twofa_enabled'],
                'password_hash' => '',
                'user_level'    => $user['user_level'],
                'user_status'   => $user['user_status']
            ];

            $result = $userModel->updateProfile($user_id, $data);

            if ($result) {
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $user_id,
                    $_SESSION['username'],
                    'Unlink Gmail',
                    'User unlinked Google account',
                    $this->getClientIP(),
                    $this->getUserAgent()
                );
                $this->jsonResponse(['success' => true, 'message' => 'Google account unlinked successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to unlink Google account']);
            }

        } catch (Exception $e) {
            error_log("Unlink Gmail Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred']);
        }
    }

    public function getLogs()
    {
        $user_id = $_SESSION['user_id'];
        $start_date = $_POST['start_date'] ?? null;
        $end_date = $_POST['end_date'] ?? null;

        $logModel = $this->loadModel('UserLog');
        $logs = $logModel->getUserLogs($user_id, $start_date, $end_date);

        $this->jsonResponse(['success' => true, 'logs' => $logs]);
    }
}
