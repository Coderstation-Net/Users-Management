<?php
class User
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function register($data)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_register_user(?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $data['username'],
                $data['account_name'],
                $data['email'],
                $data['password_hash'],
                !empty($data['gmail_id']) ? $data['gmail_id'] : null,
                !empty($data['twofa_secret']) ? $data['twofa_secret'] : null,
                $data['twofa_enabled'] ?? 0
            ]);

            $result = $stmt->fetch();
            return $result;
        } catch (PDOException $e) {
            error_log("Register Error: " . $e->getMessage());
            return false;
        }
    }

    public function getUserByUsername($username)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_user_by_username(?)");
            $stmt->execute([$username]);
            return $stmt->fetch();
        } catch (PDOException $e) {
            error_log("Get User Error: " . $e->getMessage());
            return false;
        }
    }

    public function getUserByEmail($email)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_user_by_email(?)");
            $stmt->execute([$email]);
            return $stmt->fetch();
        } catch (PDOException $e) {
            return false;
        }
    }

    public function getUserByGmail($gmail_id)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_user_by_gmail(?)");
            $stmt->execute([$gmail_id]);
            return $stmt->fetch();
        } catch (PDOException $e) {
            return false;
        }
    }



    public function getUserById($user_id)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_user_by_id(?)");
            $stmt->execute([$user_id]);
            return $stmt->fetch();
        } catch (PDOException $e) {
            return false;
        }
    }

    public function updateProfile($user_id, $data)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_update_user_profile(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $user_id,
                $data['username'] ?? null,
                $data['account_name'] ?? null,
                $data['email'] ?? null,
                !empty($data['gmail_id']) ? $data['gmail_id'] : null,
                !empty($data['twofa_secret']) ? $data['twofa_secret'] : null,
                $data['twofa_enabled'] ?? 0,
                $data['password_hash'] ?? '',
                $data['user_level'] ?? null,
                $data['user_status'] ?? null
            ]);

            // For stored procedures that return result sets, we should fetch to clear it
            // but we'll return true if execute didn't throw an exception
            return true;
        } catch (PDOException $e) {
            error_log("Update Profile Error: " . $e->getMessage());
            return false;
        }
    }

    public function deleteUser($user_id)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_delete_user(?)");
            $stmt->execute([$user_id]);
            return true;
        } catch (PDOException $e) {
            error_log("Delete User Error: " . $e->getMessage());
            return false;
        }
    }

    public function addUser($data)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_add_user(?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $data['username'],
                $data['account_name'],
                $data['email'],
                $data['password_hash'],
                $data['user_level'],
                $data['user_status']
            ]);
            $result = $stmt->fetch();
            return $result;
        } catch (PDOException $e) {
            error_log("Add User Error: " . $e->getMessage());
            return false;
        }
    }

    public function recordFailedLogin($username)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_record_failed_login(?)");
            $stmt->execute([$username]);
            return true;
        } catch (PDOException $e) {
            return false;
        }
    }

    public function resetFailedLogin($user_id)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_reset_failed_login(?)");
            $stmt->execute([$user_id]);
            return true;
        } catch (PDOException $e) {
            return false;
        }
    }

    public function isAccountLocked($user_id)
    {
        try {
            $stmt = $this->db->prepare("SELECT fn_is_account_locked(?) as is_locked");
            $stmt->execute([$user_id]);
            $result = $stmt->fetch();
            return $result['is_locked'] == 1;
        } catch (PDOException $e) {
            return false;
        }
    }

    public function getUsersByStatus($status)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_users_by_status(?)");
            $stmt->execute([$status]);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }

    public function getAllUsers()
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_all_users()");
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }
}
