<?php
class UserLog
{
    private $db;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function logActivity($user_id, $username, $action, $description, $ip_address, $user_agent)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_log_activity(?, ?, ?, ?, ?, ?)");
            $stmt->execute([$user_id, $username, $action, $description, $ip_address, $user_agent]);
            return true;
        } catch (PDOException $e) {
            error_log("Log Activity Error: " . $e->getMessage());
            return false;
        }
    }

    public function getUserLogs($user_id = null, $start_date = null, $end_date = null)
    {
        try {
            $stmt = $this->db->prepare("CALL sp_get_user_logs(?, ?, ?)");
            $stmt->execute([$user_id, $start_date, $end_date]);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            error_log("Get Logs Error: " . $e->getMessage());
            return [];
        }
    }
}
