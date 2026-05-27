USE user_management;

DELIMITER $$

-- Procedure: Register New User
DROP PROCEDURE IF EXISTS sp_register_user$$
CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_account_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_gmail_id VARCHAR(100),
    IN p_twofa_secret VARCHAR(32),
    IN p_twofa_enabled TINYINT(1)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO users (username, account_name, email, password_hash, gmail_id, twofa_secret, twofa_enabled, user_status)
    VALUES (p_username, p_account_name, p_email, p_password_hash, p_gmail_id, p_twofa_secret, p_twofa_enabled, 'Inactive');
    
    SELECT LAST_INSERT_ID() as user_id;
    
    COMMIT;
END$$

-- Procedure: Get User by Username
DROP PROCEDURE IF EXISTS sp_get_user_by_username$$
CREATE PROCEDURE sp_get_user_by_username(IN p_username VARCHAR(50))
BEGIN
    SELECT * FROM users WHERE username = p_username LIMIT 1;
END$$

-- Procedure: Get User by Email
DROP PROCEDURE IF EXISTS sp_get_user_by_email$$
CREATE PROCEDURE sp_get_user_by_email(IN p_email VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE email = p_email LIMIT 1;
END$$

-- Procedure: Get User by Gmail ID
DROP PROCEDURE IF EXISTS sp_get_user_by_gmail$$
CREATE PROCEDURE sp_get_user_by_gmail(IN p_gmail_id VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE gmail_id = p_gmail_id LIMIT 1;
END$$



-- Procedure: Update User Profile
DROP PROCEDURE IF EXISTS sp_update_user_profile$$
CREATE PROCEDURE sp_update_user_profile(
    IN p_user_id INT,
    IN p_username VARCHAR(50),
    IN p_account_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_gmail_id VARCHAR(100),
    IN p_twofa_secret VARCHAR(32),
    IN p_twofa_enabled TINYINT(1),
    IN p_password_hash VARCHAR(255),
    IN p_user_level VARCHAR(20),
    IN p_user_status VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE users 
    SET username = COALESCE(p_username, username),
        account_name = COALESCE(p_account_name, account_name),
        email = COALESCE(p_email, email),
        gmail_id = p_gmail_id,
        twofa_secret = p_twofa_secret,
        twofa_enabled = p_twofa_enabled,
        password_hash = COALESCE(NULLIF(p_password_hash, ''), password_hash),
        user_level = COALESCE(p_user_level, user_level),
        user_status = COALESCE(p_user_status, user_status)
    WHERE user_id = p_user_id;
    
    COMMIT;
    
    SELECT ROW_COUNT() as affected_rows;
END$$

-- Procedure: Record Failed Login Attempt
DROP PROCEDURE IF EXISTS sp_record_failed_login$$
CREATE PROCEDURE sp_record_failed_login(IN p_username VARCHAR(50))
BEGIN
    DECLARE v_attempts INT;
    DECLARE v_user_id INT;
    
    SELECT user_id, failed_login_attempts INTO v_user_id, v_attempts 
    FROM users WHERE username = p_username LIMIT 1;
    
    IF v_user_id IS NOT NULL THEN
        SET v_attempts = v_attempts + 1;
        
        IF v_attempts >= 3 THEN
            UPDATE users 
            SET failed_login_attempts = v_attempts,
                last_failed_login = NOW(),
                account_locked_until = DATE_ADD(NOW(), INTERVAL 24 HOUR)
            WHERE user_id = v_user_id;
        ELSE
            UPDATE users 
            SET failed_login_attempts = v_attempts,
                last_failed_login = NOW()
            WHERE user_id = v_user_id;
        END IF;
    END IF;
END$$

-- Procedure: Reset Failed Login Attempts
DROP PROCEDURE IF EXISTS sp_reset_failed_login$$
CREATE PROCEDURE sp_reset_failed_login(IN p_user_id INT)
BEGIN
    UPDATE users 
    SET failed_login_attempts = 0,
        last_failed_login = NULL,
        account_locked_until = NULL
    WHERE user_id = p_user_id;
END$$

-- Procedure: Create User Session
DROP PROCEDURE IF EXISTS sp_create_session$$
CREATE PROCEDURE sp_create_session(
    IN p_user_id INT,
    IN p_session_token VARCHAR(255),
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT,
    IN p_device_info VARCHAR(255)
)
BEGIN
    INSERT INTO user_sessions (user_id, session_token, ip_address, user_agent, device_info)
    VALUES (p_user_id, p_session_token, p_ip_address, p_user_agent, p_device_info);
    
    SELECT LAST_INSERT_ID() as session_id;
END$$

-- Procedure: Deactivate Other Sessions
DROP PROCEDURE IF EXISTS sp_deactivate_other_sessions$$
CREATE PROCEDURE sp_deactivate_other_sessions(
    IN p_user_id INT,
    IN p_current_session_token VARCHAR(255)
)
BEGIN
    UPDATE user_sessions 
    SET is_active = 0 
    WHERE user_id = p_user_id 
    AND session_token != p_current_session_token 
    AND is_active = 1;
    
    SELECT ROW_COUNT() as deactivated_count;
END$$

-- Procedure: Get Active Session
DROP PROCEDURE IF EXISTS sp_get_active_session$$
CREATE PROCEDURE sp_get_active_session(IN p_session_token VARCHAR(255))
BEGIN
    SELECT s.*, u.username, u.account_name, u.user_level, u.user_status, u.twofa_enabled
    FROM user_sessions s
    INNER JOIN users u ON s.user_id = u.user_id
    WHERE s.session_token = p_session_token 
    AND s.is_active = 1
    LIMIT 1;
END$$

-- Procedure: Deactivate Session
DROP PROCEDURE IF EXISTS sp_deactivate_session$$
CREATE PROCEDURE sp_deactivate_session(IN p_session_token VARCHAR(255))
BEGIN
    UPDATE user_sessions 
    SET is_active = 0 
    WHERE session_token = p_session_token;
END$$

-- Procedure: Update Session Token (Session renewal)
DROP PROCEDURE IF EXISTS sp_update_session_token$$
CREATE PROCEDURE sp_update_session_token(
    IN p_old_token VARCHAR(255),
    IN p_new_token VARCHAR(255)
)
BEGIN
    UPDATE user_sessions 
    SET session_token = p_new_token,
        last_activity = NOW()
    WHERE session_token = p_old_token 
    AND is_active = 1;
    
    SELECT ROW_COUNT() as affected_rows;
END$$

-- Procedure: Deactivate All User Sessions
DROP PROCEDURE IF EXISTS sp_deactivate_all_user_sessions$$
CREATE PROCEDURE sp_deactivate_all_user_sessions(IN p_user_id INT)
BEGIN
    UPDATE user_sessions 
    SET is_active = 0 
    WHERE user_id = p_user_id 
    AND is_active = 1;
    
    SELECT ROW_COUNT() as deactivated_count;
END$$

-- Procedure: Log User Activity
DROP PROCEDURE IF EXISTS sp_log_activity$$
CREATE PROCEDURE sp_log_activity(
    IN p_user_id INT,
    IN p_username VARCHAR(50),
    IN p_action VARCHAR(100),
    IN p_description TEXT,
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT
)
BEGIN
    INSERT INTO user_logs (user_id, username, action, description, ip_address, user_agent)
    VALUES (p_user_id, p_username, p_action, p_description, p_ip_address, p_user_agent);
END$$

-- Procedure: Get Users by Status
DROP PROCEDURE IF EXISTS sp_get_users_by_status$$
CREATE PROCEDURE sp_get_users_by_status(IN p_status VARCHAR(20))
BEGIN
    SELECT user_id, username, account_name, email, gmail_id, 
           twofa_enabled, user_level, user_status, created_at, updated_at
    FROM users 
    WHERE user_status = p_status
    ORDER BY created_at DESC;
END$$

-- Procedure: Get All Users
DROP PROCEDURE IF EXISTS sp_get_all_users$$
CREATE PROCEDURE sp_get_all_users()
BEGIN
    SELECT user_id, username, account_name, email, gmail_id, 
           twofa_enabled, user_level, user_status, created_at, updated_at
    FROM users 
    ORDER BY created_at DESC;
END$$

-- Procedure: Get Currently Active Users
DROP PROCEDURE IF EXISTS sp_get_currently_active_users$$
CREATE PROCEDURE sp_get_currently_active_users()
BEGIN
    SELECT DISTINCT u.user_id, u.username, u.account_name, u.email, u.user_level,
           s.login_time, s.last_activity, s.ip_address, s.device_info
    FROM users u
    INNER JOIN user_sessions s ON u.user_id = s.user_id
    WHERE s.is_active = 1
    ORDER BY s.last_activity DESC;
END$$

-- Procedure: Get User Logs with Filters
DROP PROCEDURE IF EXISTS sp_get_user_logs$$
CREATE PROCEDURE sp_get_user_logs(
    IN p_user_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT * FROM user_logs
    WHERE (p_user_id IS NULL OR user_id = p_user_id)
    AND (p_start_date IS NULL OR DATE(created_at) >= p_start_date)
    AND (p_end_date IS NULL OR DATE(created_at) <= p_end_date)
    ORDER BY created_at DESC;
END$$

-- Procedure: Get User by ID
DROP PROCEDURE IF EXISTS sp_get_user_by_id$$
CREATE PROCEDURE sp_get_user_by_id(IN p_user_id INT)
BEGIN
    SELECT * FROM users WHERE user_id = p_user_id LIMIT 1;
END$$

-- Function: Check if Account is Locked
DROP FUNCTION IF EXISTS fn_is_account_locked$$
CREATE FUNCTION fn_is_account_locked(p_user_id INT)
RETURNS TINYINT(1)
DETERMINISTIC
BEGIN
    DECLARE v_locked_until DATETIME;
    
    SELECT account_locked_until INTO v_locked_until
    FROM users WHERE user_id = p_user_id;
    
    IF v_locked_until IS NOT NULL AND v_locked_until > NOW() THEN
        RETURN 1;
    ELSE
        -- Auto-unlock if time has passed
        IF v_locked_until IS NOT NULL THEN
            UPDATE users 
            SET failed_login_attempts = 0,
                account_locked_until = NULL
            WHERE user_id = p_user_id;
        END IF;
        RETURN 0;
    END IF;
END$$

-- Procedure: Add User (Admin only)
DROP PROCEDURE IF EXISTS sp_add_user$$
CREATE PROCEDURE sp_add_user(
    IN p_username VARCHAR(50),
    IN p_account_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_user_level VARCHAR(20),
    IN p_user_status VARCHAR(20)
)
BEGIN
    INSERT INTO users (username, account_name, email, password_hash, user_level, user_status)
    VALUES (p_username, p_account_name, p_email, p_password_hash, p_user_level, p_user_status);
    
    SELECT LAST_INSERT_ID() as user_id;
END$$

-- Procedure: Delete User (Admin only)
DROP PROCEDURE IF EXISTS sp_delete_user$$
CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    DELETE FROM users WHERE user_id = p_user_id;
END$$

DELIMITER ;
