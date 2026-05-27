<?php
class Session
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function createSession($user_id, $session_token, $ip_address, $user_agent, $device_info)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_create_session(?, ?, ?, ?, ?)");
            $stmt->execute([$user_id, $session_token, $ip_address, $user_agent, $device_info]);
            $result = $stmt->fetch();
            return $result;
        } catch (PDOException $e) {
            error_log("Create Session Error: " . $e->getMessage());
            return false;
        }
    }

    public function deactivateOtherSessions($user_id, $current_session_token)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_deactivate_other_sessions(?, ?)");
            $stmt->execute([$user_id, $current_session_token]);
            $result = $stmt->fetch();
            return $result;
        } catch (PDOException $e) {
            error_log("Deactivate Sessions Error: " . $e->getMessage());
            return false;
        }
    }

    public function getActiveSession($session_token)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_active_session(?)");
            $stmt->execute([$session_token]);
            return $stmt->fetch();
        } catch (PDOException $e) {
            return false;
        }
    }

    public function deactivateSession($session_token)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_deactivate_session(?)");
            $stmt->execute([$session_token]);
            return true;
        } catch (PDOException $e) {
            return false;
        }
    }

    public function deactivateAllUserSessions($user_id)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_deactivate_all_user_sessions(?)");
            $stmt->execute([$user_id]);
            $result = $stmt->fetch();
            return $result;
        } catch (PDOException $e) {
            return false;
        }
    }

    public function getCurrentlyActiveUsers()
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_currently_active_users()");
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }

    public function updateSessionToken($old_token, $new_token)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_update_session_token(?, ?)");
            $stmt->execute([$old_token, $new_token]);
            return $stmt->fetch();
        } catch (PDOException $e) {
            error_log("Update Session Token Error: " . $e->getMessage());
            return false;
        }
    }

    public function generateSessionToken($user_id = null)
    {
        require_once __DIR__ . '/../helpers/JWT.php';

        $payload = [
            'iat' => time(),
            'exp' => time() + JWT_EXPIRATION,
            'jti' => bin2hex(random_bytes(16))
        ];

        if ($user_id) {
            $payload['sub'] = $user_id;
        }

        return JWT::encode($payload, JWT_SECRET);
    }
}
