<?php
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/Session.php';
require_once __DIR__ . '/../models/UserLog.php';

class AdminController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->requireAdmin();
    }

    public function dashboard()
    {
        $this->loadView('admin/dashboard');
    }

    public function getUsers()
    {
        $userModel = $this->loadModel('User');
        $users = $userModel->getAllUsers();
        $this->jsonResponse(['success' => true, 'users' => $users]);
    }

    public function getActiveUsers()
    {
        $userModel = $this->loadModel('User');
        $users = $userModel->getUsersByStatus('Active');
        $this->jsonResponse(['success' => true, 'users' => $users]);
    }

    public function getInactiveUsers()
    {
        $userModel = $this->loadModel('User');
        $users = $userModel->getUsersByStatus('Inactive');
        $this->jsonResponse(['success' => true, 'users' => $users]);
    }

    public function getSuspendedUsers()
    {
        $userModel = $this->loadModel('User');
        $users = $userModel->getUsersByStatus('Suspended');
        $this->jsonResponse(['success' => true, 'users' => $users]);
    }

    public function getDeletedUsers()
    {
        $userModel = $this->loadModel('User');
        $users = $userModel->getUsersByStatus('Deleted');
        $this->jsonResponse(['success' => true, 'users' => $users]);
    }

    public function getOnlineUsers()
    {
        $sessionModel = $this->loadModel('Session');
        $users = $sessionModel->getCurrentlyActiveUsers();
        $this->jsonResponse(['success' => true, 'users' => $users]);
    }

    public function getLogs()
    {
        $user_id = $_POST['user_id'] ?? null;
        $start_date = $_POST['start_date'] ?? null;
        $end_date = $_POST['end_date'] ?? null;

        $logModel = $this->loadModel('UserLog');
        $logs = $logModel->getUserLogs($user_id, $start_date, $end_date);

        $this->jsonResponse(['success' => true, 'logs' => $logs]);
    }

    public function updateUser()
    {
        try {
            $user_id = $_POST['user_id'] ?? 0;

            if (!$user_id) {
                $this->jsonResponse(['success' => false, 'message' => 'User ID is required']);
            }

            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            $data = [
                'username' => $_POST['username'] ?? $user['username'],
                'account_name' => $_POST['account_name'] ?? $user['account_name'],
                'email' => $_POST['email'] ?? $user['email'],
                'gmail_id' => $_POST['gmail_id'] ?? $user['gmail_id'],
                'twofa_secret' => $_POST['twofa_secret'] ?? $user['twofa_secret'],
                'twofa_enabled' => $_POST['twofa_enabled'] ?? $user['twofa_enabled'],
                'password_hash' => '',
                'user_level' => $_POST['user_level'] ?? $user['user_level'],
                'user_status' => $_POST['user_status'] ?? $user['user_status']
            ];

            // Update password if provided
            if (!empty($_POST['password'])) {
                $data['password_hash'] = password_hash($_POST['password'], PASSWORD_BCRYPT);
            }

            // Handle Reset Failed Login Attempts
            if (!empty($_POST['reset_failed_attempts']) && $_POST['reset_failed_attempts'] == 1) {
                $userModel->resetFailedLogin($user_id);
            }

            $result = $userModel->updateProfile($user_id, $data);

            // We consider it a success if the update was successful, 
            // even if 0 rows were affected (meaning no changes were made)
            if ($result !== false) {
                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    'User Update',
                    "Admin updated user: {$user['username']}",
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => 'User updated successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to update user']);
            }

        } catch (Exception $e) {
            error_log("Update User Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while updating user: ' . $e->getMessage()]);
        }
    }

    public function kickUser()
    {
        try {
            $user_id = $_POST['user_id'] ?? 0;

            if (!$user_id) {
                $this->jsonResponse(['success' => false, 'message' => 'User ID is required']);
            }

            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            // Deactivate all sessions for this user
            $sessionModel = $this->loadModel('Session');
            $result = $sessionModel->deactivateAllUserSessions($user_id);

            // Log activity
            $logModel = $this->loadModel('UserLog');
            $logModel->logActivity(
                $_SESSION['user_id'],
                $_SESSION['username'],
                'User Kicked',
                "Admin kicked user: {$user['username']}",
                $this->getClientIP(),
                $this->getUserAgent()
            );

            $logModel->logActivity(
                $user_id,
                $user['username'],
                'Kicked by Admin',
                "User was kicked by admin: {$_SESSION['username']}",
                $this->getClientIP(),
                $this->getUserAgent()
            );

            $this->jsonResponse([
                'success' => true,
                'message' => 'User has been kicked successfully',
                'sessions_deactivated' => $result['deactivated_count'] ?? 0
            ]);

        } catch (Exception $e) {
            error_log("Kick User Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while kicking user']);
        }
    }

    public function addUser()
    {
        header('Content-Type: application/json');

        try {
            $username = $_POST['username'] ?? '';
            $account_name = $_POST['account_name'] ?? '';
            $email = $_POST['email'] ?? '';
            $password = $_POST['password'] ?? '';
            $user_level = $_POST['user_level'] ?? 'User';
            $user_status = $_POST['user_status'] ?? 'Active';

            // Validation
            if (empty($username) || empty($account_name) || empty($email) || empty($password)) {
                $this->jsonResponse(['success' => false, 'message' => 'All required fields must be filled']);
            }

            if (strlen($password) < PASSWORD_MIN_LENGTH) {
                $this->jsonResponse(['success' => false, 'message' => 'Password must be at least ' . PASSWORD_MIN_LENGTH . ' characters']);
            }

            $userModel = $this->loadModel('User');

            if ($userModel->getUserByUsername($username)) {
                $this->jsonResponse(['success' => false, 'message' => 'Username already exists']);
            }

            if ($userModel->getUserByEmail($email)) {
                $this->jsonResponse(['success' => false, 'message' => 'Email already registered']);
            }

            $data = [
                'username' => $username,
                'account_name' => $account_name,
                'email' => $email,
                'password_hash' => password_hash($password, PASSWORD_BCRYPT),
                'user_level' => $user_level,
                'user_status' => $user_status
            ];

            $result = $userModel->addUser($data);

            if ($result) {
                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    'User Creation',
                    "Admin created user account: {$username} ({$user_level})",
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => 'User account created successfully!']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to create user. Please try again.']);
            }

        } catch (Exception $e) {
            error_log("Add User Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred during user creation: ' . $e->getMessage()]);
        }
    }

    public function deleteUser()
    {
        header('Content-Type: application/json');

        try {
            $user_id = $_POST['user_id'] ?? 0;

            if (!$user_id) {
                $this->jsonResponse(['success' => false, 'message' => 'User ID is required']);
            }

            if ($user_id == $_SESSION['user_id']) {
                $this->jsonResponse(['success' => false, 'message' => 'You cannot delete your own account']);
            }

            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            // Soft delete by updating status to 'Deleted'
            $data = [
                'username' => $user['username'],
                'account_name' => $user['account_name'],
                'email' => $user['email'],
                'gmail_id' => $user['gmail_id'],
                'twofa_secret' => $user['twofa_secret'],
                'twofa_enabled' => $user['twofa_enabled'],
                'user_level' => $user['user_level'],
                'user_status' => 'Deleted'
            ];

            $result = $userModel->updateProfile($user_id, $data);

            if ($result) {
                // Kick active sessions for this user
                $sessionModel = $this->loadModel('Session');
                $sessionModel->deactivateAllUserSessions($user_id);

                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    'User Delete (Soft)',
                    "Admin deleted user: {$user['username']}",
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => 'User has been deleted (soft-deleted) successfully']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to delete user']);
            }

        } catch (Exception $e) {
            error_log("Delete User Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while deleting user: ' . $e->getMessage()]);
        }
    }

    public function deleteUserPermanent()
    {
        header('Content-Type: application/json');

        try {
            $user_id = $_POST['user_id'] ?? 0;

            if (!$user_id) {
                $this->jsonResponse(['success' => false, 'message' => 'User ID is required']);
            }

            if ($user_id == $_SESSION['user_id']) {
                $this->jsonResponse(['success' => false, 'message' => 'You cannot permanently delete your own account']);
            }

            $userModel = $this->loadModel('User');
            $user = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            // Perform hard delete
            $result = $userModel->deleteUser($user_id);

            if ($result) {
                // Log activity
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    'User Delete (Permanent)',
                    "Admin permanently deleted user account: {$user['username']}",
                    $this->getClientIP(),
                    $this->getUserAgent()
                );

                $this->jsonResponse(['success' => true, 'message' => 'User account permanently removed from database']);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to permanently delete user']);
            }

        } catch (Exception $e) {
            error_log("Permanent Delete User Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred while permanently deleting user: ' . $e->getMessage()]);
        }
    }

    public function toggleUser2FA()
    {
        try {
            $user_id   = $_POST['user_id']   ?? 0;
            $action    = $_POST['action']     ?? ''; // 'enable' or 'disable'

            if (!$user_id || !in_array($action, ['enable', 'disable'])) {
                $this->jsonResponse(['success' => false, 'message' => 'Invalid request']);
            }

            $userModel = $this->loadModel('User');
            $user      = $userModel->getUserById($user_id);

            if (!$user) {
                $this->jsonResponse(['success' => false, 'message' => 'User not found']);
            }

            if ($action === 'disable') {
                $data = [
                    'username'      => $user['username'],
                    'account_name'  => $user['account_name'],
                    'email'         => $user['email'],
                    'gmail_id'      => $user['gmail_id'],
                    'twofa_secret'  => $user['twofa_secret'], // Preserve secret — only toggle the flag
                    'twofa_enabled' => 0,
                    'password_hash' => '',
                    'user_level'    => $user['user_level'],
                    'user_status'   => $user['user_status']
                ];
                $message     = 'Admin disabled 2FA for user: ' . $user['username'];
                $actionLabel = '2FA Disabled by Admin';
            } else {
                // Enable: just set the flag; preserve the existing secret
                $data = [
                    'username'      => $user['username'],
                    'account_name'  => $user['account_name'],
                    'email'         => $user['email'],
                    'gmail_id'      => $user['gmail_id'],
                    'twofa_secret'  => $user['twofa_secret'], // Preserve secret — only toggle the flag
                    'twofa_enabled' => 1,
                    'password_hash' => '',
                    'user_level'    => $user['user_level'],
                    'user_status'   => $user['user_status']
                ];
                $message     = 'Admin enabled 2FA for user: ' . $user['username'];
                $actionLabel = '2FA Enabled by Admin';
            }

            $result = $userModel->updateProfile($user_id, $data);

            if ($result !== false) {
                $logModel = $this->loadModel('UserLog');
                $logModel->logActivity(
                    $_SESSION['user_id'],
                    $_SESSION['username'],
                    $actionLabel,
                    $message,
                    $this->getClientIP(),
                    $this->getUserAgent()
                );
                $this->jsonResponse(['success' => true, 'message' => ucfirst($action) . ' 2FA successful for ' . $user['username']]);
            } else {
                $this->jsonResponse(['success' => false, 'message' => 'Failed to update 2FA status']);
            }

        } catch (Exception $e) {
            error_log("Toggle 2FA Error: " . $e->getMessage());
            $this->jsonResponse(['success' => false, 'message' => 'An error occurred: ' . $e->getMessage()]);
        }
    }
}
