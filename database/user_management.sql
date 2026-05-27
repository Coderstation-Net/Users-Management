/*
 Navicat Premium Data Transfer

 Source Server         : Local MySQL-8-2 (3307)
 Source Server Type    : MySQL
 Source Server Version : 80200
 Source Host           : localhost:3307
 Source Schema         : user_management

 Target Server Type    : MySQL
 Target Server Version : 80200
 File Encoding         : 65001

 Date: 27/05/2026 22:15:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_logs`;
CREATE TABLE `user_logs`  (
  `log_id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NULL DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  INDEX `idx_action`(`action`) USING BTREE,
  CONSTRAINT `user_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_logs
-- ----------------------------
INSERT INTO `user_logs` VALUES (1, 1, 'admin', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:37:34');
INSERT INTO `user_logs` VALUES (2, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:43:41');
INSERT INTO `user_logs` VALUES (3, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:44:05');
INSERT INTO `user_logs` VALUES (4, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:48:25');
INSERT INTO `user_logs` VALUES (5, 1, 'Admin', 'Link Gmail', 'Linked Gmail Account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:51:22');
INSERT INTO `user_logs` VALUES (6, 1, 'Admin', 'Link Gmail', 'Linked Gmail Account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:51:45');
INSERT INTO `user_logs` VALUES (7, 1, 'Admin', 'Link Gmail', 'Linked Gmail Account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 09:56:18');
INSERT INTO `user_logs` VALUES (8, 1, 'Admin', 'User Update', 'Admin updated user: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:11:39');
INSERT INTO `user_logs` VALUES (9, 1, 'Admin', 'User Creation', 'Admin created user account: Zerones (User)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:28:57');
INSERT INTO `user_logs` VALUES (10, 1, 'Admin', 'User Update', 'Admin updated user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:31:22');
INSERT INTO `user_logs` VALUES (11, 1, 'Admin', 'User Update', 'Admin updated user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:31:30');
INSERT INTO `user_logs` VALUES (12, 1, 'Admin', 'User Update', 'Admin updated user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:31:43');
INSERT INTO `user_logs` VALUES (13, 1, 'Admin', 'User Update', 'Admin updated user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:31:51');
INSERT INTO `user_logs` VALUES (14, 1, 'Admin', 'User Update', 'Admin updated user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:31:59');
INSERT INTO `user_logs` VALUES (15, 1, 'Admin', '2FA Disabled by Admin', 'Admin disabled 2FA for user: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:40:29');
INSERT INTO `user_logs` VALUES (16, 1, 'Admin', 'User Update', 'Admin updated user: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:40:33');
INSERT INTO `user_logs` VALUES (17, 1, 'Admin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:47:51');
INSERT INTO `user_logs` VALUES (18, 1, 'Admin', 'User Update', 'Admin updated user: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:49:17');
INSERT INTO `user_logs` VALUES (19, 1, 'Admin', 'Unlink Gmail', 'User unlinked Google account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:50:12');
INSERT INTO `user_logs` VALUES (20, 1, 'Admin', 'Link Gmail', 'Linked Gmail Account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:50:22');
INSERT INTO `user_logs` VALUES (21, 1, 'Admin', 'Unlink Gmail', 'User unlinked Google account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:50:56');
INSERT INTO `user_logs` VALUES (22, 1, 'Admin', 'Link Gmail', 'Linked Gmail Account', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 10:51:03');
INSERT INTO `user_logs` VALUES (23, 2, 'Zerones', 'Failed Login', 'Invalid password attempt', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 10:58:03');
INSERT INTO `user_logs` VALUES (24, 2, 'Zerones', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 10:58:10');
INSERT INTO `user_logs` VALUES (25, 2, 'Zerones', 'Link Gmail', 'Linked Gmail Account', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 10:59:23');
INSERT INTO `user_logs` VALUES (26, 2, 'Zerones', 'Profile Update', 'User updated their profile', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 10:59:31');
INSERT INTO `user_logs` VALUES (27, 2, 'Zerones', '2FA Enabled', 'User enabled two-factor authentication', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 11:02:58');
INSERT INTO `user_logs` VALUES (28, 2, 'Zerones', 'Profile Update', 'User updated their profile', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 11:03:02');
INSERT INTO `user_logs` VALUES (29, 1, 'Admin', 'User Kicked', 'Admin kicked user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 11:03:15');
INSERT INTO `user_logs` VALUES (30, 2, 'Zerones', 'Kicked by Admin', 'User was kicked by admin: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 11:03:15');
INSERT INTO `user_logs` VALUES (31, 2, 'Zerones', 'Failed Login', 'Invalid 2FA code', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 11:04:08');
INSERT INTO `user_logs` VALUES (32, 2, 'Zerones', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 11:04:12');
INSERT INTO `user_logs` VALUES (33, 2, 'Zerones', 'Link Gmail', 'Linked Gmail Account', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 11:04:28');
INSERT INTO `user_logs` VALUES (34, 2, 'Zerones', 'Profile Update', 'User updated their profile', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 11:04:41');
INSERT INTO `user_logs` VALUES (35, 1, 'Admin', 'User Creation', 'Admin created user account: Daemon (Data-Encoder)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:09:57');
INSERT INTO `user_logs` VALUES (36, 3, 'Daemon', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-27 12:11:19');
INSERT INTO `user_logs` VALUES (37, 1, 'Admin', '2FA Disabled by Admin', 'Admin disabled 2FA for user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:26:23');
INSERT INTO `user_logs` VALUES (38, 1, 'Admin', 'User Update', 'Admin updated user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:26:47');
INSERT INTO `user_logs` VALUES (39, 1, 'Admin', 'User Kicked', 'Admin kicked user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:26:57');
INSERT INTO `user_logs` VALUES (40, 2, 'Zerones', 'Kicked by Admin', 'User was kicked by admin: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:26:57');
INSERT INTO `user_logs` VALUES (41, 2, 'Zerones', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:27:36');
INSERT INTO `user_logs` VALUES (42, 2, 'Zerones', '2FA Enabled', 'User enabled two-factor authentication', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:30:36');
INSERT INTO `user_logs` VALUES (43, 2, 'Zerones', 'Profile Update', 'User updated their profile', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:30:40');
INSERT INTO `user_logs` VALUES (44, 2, 'Zerones', 'Link Gmail', 'Linked Gmail Account', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:30:53');
INSERT INTO `user_logs` VALUES (45, 2, 'Zerones', 'Profile Update', 'User updated their profile', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:30:57');
INSERT INTO `user_logs` VALUES (46, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:32:22');
INSERT INTO `user_logs` VALUES (47, 3, 'Daemon', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:41:10');
INSERT INTO `user_logs` VALUES (48, 3, 'Daemon', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-27 12:46:47');
INSERT INTO `user_logs` VALUES (49, 1, 'Admin', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:47:22');
INSERT INTO `user_logs` VALUES (50, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:47:50');
INSERT INTO `user_logs` VALUES (51, 1, 'Admin', 'User Update', 'Admin updated user: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:48:33');
INSERT INTO `user_logs` VALUES (52, 2, 'Zerones', 'Logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:53:03');
INSERT INTO `user_logs` VALUES (53, 3, 'Daemon', 'Logout', 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-27 12:53:11');
INSERT INTO `user_logs` VALUES (54, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:53:19');
INSERT INTO `user_logs` VALUES (55, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 12:53:45');
INSERT INTO `user_logs` VALUES (56, 3, 'Daemon', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 12:54:34');
INSERT INTO `user_logs` VALUES (57, 2, 'Zerones', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-27 12:55:38');
INSERT INTO `user_logs` VALUES (58, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:16:25');
INSERT INTO `user_logs` VALUES (59, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:24:17');
INSERT INTO `user_logs` VALUES (60, 1, 'admin', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:24:19');
INSERT INTO `user_logs` VALUES (61, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:24:38');
INSERT INTO `user_logs` VALUES (62, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:24:52');
INSERT INTO `user_logs` VALUES (63, 1, 'Admin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:26:32');
INSERT INTO `user_logs` VALUES (64, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:30:03');
INSERT INTO `user_logs` VALUES (65, 3, 'Daemon', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-27 13:53:35');
INSERT INTO `user_logs` VALUES (66, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 13:55:14');
INSERT INTO `user_logs` VALUES (67, 2, 'Zerones', 'Login', 'User logged in successfully', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-27 13:56:53');
INSERT INTO `user_logs` VALUES (68, 1, 'Admin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 14:26:41');
INSERT INTO `user_logs` VALUES (69, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 15:06:00');
INSERT INTO `user_logs` VALUES (70, 1, 'Admin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 15:06:06');
INSERT INTO `user_logs` VALUES (71, 1, 'Admin', 'User Creation', 'Admin created user account: Viruszero (User)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 15:31:20');
INSERT INTO `user_logs` VALUES (72, 1, 'Admin', 'User Creation', 'Admin created user account: Shadow13 (User)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:07:48');
INSERT INTO `user_logs` VALUES (73, 1, 'Admin', 'User Delete (Soft)', 'Admin deleted user: Shadow13', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:07:57');
INSERT INTO `user_logs` VALUES (74, 1, 'Admin', 'User Update', 'Admin updated user: Shadow13', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:08:53');
INSERT INTO `user_logs` VALUES (75, 1, 'Admin', 'User Update', 'Admin updated user: Shadow13', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:09:00');
INSERT INTO `user_logs` VALUES (76, 1, 'Admin', 'User Creation', 'Admin created user account: Jatracs (User)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:11:40');
INSERT INTO `user_logs` VALUES (77, 1, 'Admin', 'User Delete (Soft)', 'Admin deleted user: Jatracs', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:11:45');
INSERT INTO `user_logs` VALUES (78, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:24:28');
INSERT INTO `user_logs` VALUES (79, 1, 'Admin', 'User Kicked', 'Admin kicked user: Zerones', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:24:39');
INSERT INTO `user_logs` VALUES (80, 2, 'Zerones', 'Kicked by Admin', 'User was kicked by admin: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:24:39');
INSERT INTO `user_logs` VALUES (81, 1, 'Admin', 'User Kicked', 'Admin kicked user: Daemon', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:24:40');
INSERT INTO `user_logs` VALUES (82, 3, 'Daemon', 'Kicked by Admin', 'User was kicked by admin: Admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 17:24:40');
INSERT INTO `user_logs` VALUES (83, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 20:37:55');
INSERT INTO `user_logs` VALUES (84, 1, 'Admin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 20:55:37');
INSERT INTO `user_logs` VALUES (85, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 20:56:50');
INSERT INTO `user_logs` VALUES (86, 7, 'bill.saguin', 'Registration', 'User registered account via Google Single Sign-on (Pending Admin Approval)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:44:45');
INSERT INTO `user_logs` VALUES (87, 7, 'bill.saguin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:44:55');
INSERT INTO `user_logs` VALUES (88, 7, 'bill.saguin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:45:07');
INSERT INTO `user_logs` VALUES (89, 7, 'Billy', 'Profile Update', 'User updated their profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:46:28');
INSERT INTO `user_logs` VALUES (90, 7, 'Billy', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:46:38');
INSERT INTO `user_logs` VALUES (91, 7, 'Billy', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:46:56');
INSERT INTO `user_logs` VALUES (92, 7, 'Billy', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:47:03');
INSERT INTO `user_logs` VALUES (93, 7, 'Billy', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:47:10');
INSERT INTO `user_logs` VALUES (94, 1, 'admin', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:51:07');
INSERT INTO `user_logs` VALUES (95, 1, 'admin', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:51:08');
INSERT INTO `user_logs` VALUES (96, 1, 'admin', 'Failed Login', 'Invalid password attempt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:51:09');
INSERT INTO `user_logs` VALUES (97, 1, 'Admin', 'Login', 'User logged in via Google OAuth', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:52:51');
INSERT INTO `user_logs` VALUES (98, 1, 'Admin', 'User Update', 'Admin updated user: Billy', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:53:25');
INSERT INTO `user_logs` VALUES (99, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 21:59:29');
INSERT INTO `user_logs` VALUES (100, 1, 'Admin', 'Login', 'User logged in successfully', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:10:54');
INSERT INTO `user_logs` VALUES (101, 1, 'Admin', 'User Update', 'Admin updated user: Billy', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:11:24');
INSERT INTO `user_logs` VALUES (102, 1, 'Admin', 'User Delete (Soft)', 'Admin deleted user: Viruszero', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:11:45');
INSERT INTO `user_logs` VALUES (103, 1, 'Admin', 'User Update', 'Admin updated user: Viruszero', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:12:07');
INSERT INTO `user_logs` VALUES (104, 1, 'Admin', 'User Update', 'Admin updated user: Viruszero', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:12:41');
INSERT INTO `user_logs` VALUES (105, 1, 'Admin', 'User Update', 'Admin updated user: Billy', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:13:05');
INSERT INTO `user_logs` VALUES (106, 1, 'Admin', 'Logout', 'User logged out', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '2026-05-27 22:13:33');

-- ----------------------------
-- Table structure for user_sessions
-- ----------------------------
DROP TABLE IF EXISTS `user_sessions`;
CREATE TABLE `user_sessions`  (
  `session_id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `session_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `device_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `login_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `last_activity` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `is_active` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`session_id`) USING BTREE,
  UNIQUE INDEX `session_token`(`session_token`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_session_token`(`session_token`) USING BTREE,
  INDEX `idx_is_active`(`is_active`) USING BTREE,
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_sessions
-- ----------------------------
INSERT INTO `user_sessions` VALUES (1, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NDk5NTIsImV4cCI6MTc3OTg1MDg1MiwianRpIjoiZmYwNWYxNWRmNWNmMDkyNWUwNzVhMTU3M2U2N2Q0YWYiLCJzdWIiOjF9.Mnqvz6gCqo6Lo9eFmbAwavImv8xkzQEtXUtC2oU0NgM', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 09:48:25', '2026-05-27 10:47:51', 0);
INSERT INTO `user_sessions` VALUES (2, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTYxNjMsImV4cCI6MTc3OTg1NzA2MywianRpIjoiNTQ2NTViYjJlMmQyMzdjMTkwNzJkZTlkMzViZjk4NzUiLCJzdWIiOjF9.wskZP7O-0znCx-f2FdkwyMDl_JeTIKYQGmMrg1uqXZ8', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 10:47:51', '2026-05-27 12:32:22', 0);
INSERT INTO `user_sessions` VALUES (3, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTA2OTAsImV4cCI6MTc3OTg1MTU5MCwianRpIjoiMzRkYjJhNmQyOGY2YmY1ZjExMTcxZGQ1NmY0OWQ2OTUiLCJzdWIiOjJ9.4Dt2bKjMzu-oZJjtnnBabyqId7RHCB8Le8jhCU-NY20', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 10:58:10', '2026-05-27 11:03:15', 0);
INSERT INTO `user_sessions` VALUES (4, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTU5NjEsImV4cCI6MTc3OTg1Njg2MSwianRpIjoiYTRlNjU0ZjVkMjc0NmFiOTljYTM4NTczZjBlMjgwYTUiLCJzdWIiOjJ9.UZTEs4YmVJBLnNOQoKZG71nnMR8fmhXOkOFz7X_s2nU', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 11:04:12', '2026-05-27 12:26:57', 0);
INSERT INTO `user_sessions` VALUES (5, 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTY2ODMsImV4cCI6MTc3OTg1NzU4MywianRpIjoiN2NlZTY2Mzk5ZmMxMDc5ZmRhMDZhMTZlYWY2ZWVkNDQiLCJzdWIiOjN9.LsaRwckCmG2icFu4DNp4knlkvCwn8EO1wXs_eAGEsGI', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 12:11:19', '2026-05-27 12:41:10', 0);
INSERT INTO `user_sessions` VALUES (6, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTc1NzIsImV4cCI6MTc3OTg1ODQ3MiwianRpIjoiZGZhZmEyYTUwNjAwZmUwM2U3NTJiNzFiZWY5OGY0N2MiLCJzdWIiOjJ9.uPWkoNAGbhFSoF9kQvhX23l_lEFh1PKDOoDr6xlCPgU', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 12:27:36', '2026-05-27 12:53:03', 0);
INSERT INTO `user_sessions` VALUES (7, 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTcxOTEsImV4cCI6MTc3OTg1ODA5MSwianRpIjoiNjkwYzgyYWU0YTE0ODk1ZGUwZDZmOWU3ZWM0YTIzYjIiLCJzdWIiOjN9.bjP-mLFYdMC8T8BI7jt2wQn27JRIUr-V7pj4fcS5LW4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 12:41:10', '2026-05-27 12:46:47', 0);
INSERT INTO `user_sessions` VALUES (8, 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTc1NzIsImV4cCI6MTc3OTg1ODQ3MiwianRpIjoiNjUzZjkyMWRjYTJiZDY1ZTRkODM0YmNlZDJjNDI1NDEiLCJzdWIiOjN9.n33k0MYGdGAbXFLliWhVgHxfdkFx9vLfUp0nc_y9FAk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 12:46:47', '2026-05-27 12:53:11', 0);
INSERT INTO `user_sessions` VALUES (9, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTcyNzAsImV4cCI6MTc3OTg1ODE3MCwianRpIjoiNzEzYmM5YzY0MDQwYTQ0MzY2Njc0M2Y2MmI5OGEwNmEiLCJzdWIiOjF9.JBoEMmItm0O97cm1gefvpeQ0EDsj2Dz7BIpnYDy9mK4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 12:47:50', '2026-05-27 12:53:19', 0);
INSERT INTO `user_sessions` VALUES (10, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTg4NzEsImV4cCI6MTc3OTg1OTc3MSwianRpIjoiNmFiZDlkY2ViMmFmOGRmY2NjOTA5YmQwODU1ZjBiZTciLCJzdWIiOjF9.1huw-W5xDPjLQtnbmtd81Ug9BewgeDsHB593dbwGGr4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 12:53:45', '2026-05-27 13:16:25', 0);
INSERT INTO `user_sessions` VALUES (11, 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NjExMDEsImV4cCI6MTc3OTg2MjAwMSwianRpIjoiNWZjZGQzMWY1ZWU5NWQwZmMyM2Q1ZDQ0YjVhZWJjN2EiLCJzdWIiOjN9.8ZtiuD3zJONZIArVWUXEDM5RIGBCPzF4b0mId9ezd2Q', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 12:54:34', '2026-05-27 13:53:35', 0);
INSERT INTO `user_sessions` VALUES (12, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NjA5MzEsImV4cCI6MTc3OTg2MTgzMSwianRpIjoiOTQyOTk3YzI0NzI5NGQ1NzllMmJiMjNkZjM5MTcxZWMiLCJzdWIiOjJ9.Y4i1xE5YgjdTvhnxT0dxubuUufLdZEKIV6KS3H7c-oY', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 12:55:38', '2026-05-27 13:56:53', 0);
INSERT INTO `user_sessions` VALUES (13, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTkzMTAsImV4cCI6MTc3OTg2MDIxMCwianRpIjoiMjNkZGFlMjM3OWQyYmI0OTY5NWY1ZjdmYWMwZGNhMDAiLCJzdWIiOjF9.5DdNssJSfrmDEhd7kCnlIaNeOCorPxvrVq-H0adQwCs', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 13:16:25', '2026-05-27 13:24:17', 0);
INSERT INTO `user_sessions` VALUES (14, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTk0NzgsImV4cCI6MTc3OTg2MDM3OCwianRpIjoiMDEwYjhmYzU1NDAwZmY1YmYwYjNhOWJlMGUwNzZmYTkiLCJzdWIiOjF9.VHre4RGuPeCnscZgM18joMCJO66aqxhAr_1L-L4PpWQ', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 13:24:38', '2026-05-27 13:24:52', 0);
INSERT INTO `user_sessions` VALUES (15, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NTk1OTIsImV4cCI6MTc3OTg2MDQ5MiwianRpIjoiOTBmMjYzYmRiNzVlOTY0ZjgwMjlhZDE1ODY0NmQ4YzAifQ.VaU3vOXyjq6g_sKWMo1z4eZJPJ7hht24vxernJyX9FM', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 13:26:32', '2026-05-27 13:30:03', 0);
INSERT INTO `user_sessions` VALUES (16, 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NzM2NzIsImV4cCI6MTc3OTg3NDU3MiwianRpIjoiNTVlMTk2MTcwNjlmNzJmODAwZDkyZjZlZjdmYzg2YjIiLCJzdWIiOjN9.oKoFGZ8qXDonpBIndtm9Vcni25Qn6JCDKE8UsFUK-7k', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 13:53:35', '2026-05-27 17:24:40', 0);
INSERT INTO `user_sessions` VALUES (17, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NjIyNTEsImV4cCI6MTc3OTg2MzE1MSwianRpIjoiMDZiYTYyMWZkOWViNzYxNWZjNWYxZjRhMGM4OWFmMDQiLCJzdWIiOjF9.jQXzKxss4bvamM0KsH-GVfqbHzjfW6wQI-_De9OMpbs', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 13:55:14', '2026-05-27 14:26:41', 0);
INSERT INTO `user_sessions` VALUES (18, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NzM3OTQsImV4cCI6MTc3OTg3NDY5NCwianRpIjoiNTNmNjUxZjZkMzRiYzQxOGE1YzJiMzcxZjIzYWRmY2QiLCJzdWIiOjJ9.deRP8aK8gtLJnvkc3IgPS8EkGJJLImc-2-78C3VVH9g', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Desktop', '2026-05-27 13:56:53', '2026-05-27 17:24:39', 0);
INSERT INTO `user_sessions` VALUES (19, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NjU0MTMsImV4cCI6MTc3OTg2NjMxMywianRpIjoiZjFkOTY2YmRmYjk5NTcwMjZiNGU4NjI0MWZiYzAyODIiLCJzdWIiOjF9.YPSbcC90OYO700IhmvCiPhpTdTUXxlM4LQjrOUQMuFU', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 14:26:41', '2026-05-27 15:06:00', 0);
INSERT INTO `user_sessions` VALUES (20, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NzM3NzksImV4cCI6MTc3OTg3NDY3OSwianRpIjoiNTg2MmJlYzdmZTIwZTUxOTU1NmVkZGViZjcyZjJkMzYiLCJzdWIiOjF9.jaaqU_-8fWMXDxbl5ogwZ3eIc9wudi_JfNdadh-HHh0', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 15:06:06', '2026-05-27 17:24:28', 0);
INSERT INTO `user_sessions` VALUES (21, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4NzM4NjgsImV4cCI6MTc3OTg3NDc2OCwianRpIjoiYjNmYzc3NDRiZjcyZTA4ZjUyMDc4M2QyNjM0ODM1ZGIiLCJzdWIiOjF9.03j9HgoQN8K-bkIbRsbiZHwv4waqrAqo8a4_LkEWvHk', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 17:24:28', '2026-05-27 20:37:55', 0);
INSERT INTO `user_sessions` VALUES (22, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4ODY0MTgsImV4cCI6MTc3OTg4NzMxOCwianRpIjoiNjMxYWY1YTM0MzIyNmEzOTUyN2ZmZTI1YmQ0NmZmNjMiLCJzdWIiOjF9.fo6FdVcSIu1MLLeAQgBKVD4bwGIEskxOWJuTqrHFduo', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 20:37:55', '2026-05-27 20:55:37', 0);
INSERT INTO `user_sessions` VALUES (23, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4ODY1MzcsImV4cCI6MTc3OTg4NzQzNywianRpIjoiMTY3M2UyYjIxZTUxMTE0YzhmMWNlYzg2ZmRiNTljZmIifQ.umtGJEgC6tfg5Xe6HwXGF-ZOez_LTgZp5dg0nn1nHSM', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 20:55:37', '2026-05-27 20:56:50', 0);
INSERT INTO `user_sessions` VALUES (24, 7, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4ODk0OTUsImV4cCI6MTc3OTg5MDM5NSwianRpIjoiNzZiYjcxNGUyNWQzMTI1MmFiOTBjNWZhNGNlYzgwMmUifQ.nyxvw23756IhhruCUt11YwbCXqE96jpr9yuQ9j4U-EY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 21:44:55', '2026-05-27 21:45:07', 0);
INSERT INTO `user_sessions` VALUES (25, 7, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4ODk1MDcsImV4cCI6MTc3OTg5MDQwNywianRpIjoiY2U1MThhNTJmMDdjOTY3NDRkZWRlODA0OTQzMjM0MjYifQ.s3UHlXAvsk56JZNw5LHGcwo419Z8vip1Qw_f6SB8D2c', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 21:45:07', '2026-05-27 21:46:38', 0);
INSERT INTO `user_sessions` VALUES (26, 7, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4ODk2MjMsImV4cCI6MTc3OTg5MDUyMywianRpIjoiNWUyNThjMzVlZDEzYmM0NTNkNDIwY2IxNzhkMTRiYmMiLCJzdWIiOjd9.qhfO7yPflGOaYzIyAqLXU0ZQuKmmvrJOGs6Mc24ONnc', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 21:47:03', '2026-05-27 21:47:10', 0);
INSERT INTO `user_sessions` VALUES (27, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4OTAyODcsImV4cCI6MTc3OTg5MTE4NywianRpIjoiNzY2YzJmYjA3ZGJjYmE1OTU1MTRmMWExNDY3ZDg1NDciLCJzdWIiOjF9.bUWerq6Ofl0_cxJU5wz2ZlpqSBHJzUP6rkmjaocqRA8', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 21:52:51', '2026-05-27 21:59:29', 0);
INSERT INTO `user_sessions` VALUES (28, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3Nzk4OTEwNTQsImV4cCI6MTc3OTg5MTk1NCwianRpIjoiYTdmY2FlMTFhM2EwMTdiMGVhMTVlMmMyMTFhNDM1OTQiLCJzdWIiOjF9.E-PMX7SHUbXEKFeTXa3JdLshsdhG1i3Tp5jB6hrBkNo', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'Desktop', '2026-05-27 22:10:54', '2026-05-27 22:13:33', 0);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` int(0) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `gmail_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `twofa_secret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `twofa_enabled` tinyint(1) NULL DEFAULT 0,
  `user_level` enum('Admin','User','Data-Encoder') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'User',
  `user_status` enum('Active','Inactive','Suspended','Deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Active',
  `failed_login_attempts` int(0) NULL DEFAULT 0,
  `last_failed_login` datetime(0) NULL DEFAULT NULL,
  `account_locked_until` datetime(0) NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `updated_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  UNIQUE INDEX `gmail_id`(`gmail_id`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE,
  INDEX `idx_status`(`user_status`) USING BTREE,
  INDEX `idx_level`(`user_level`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'Admin', 'System Administrator', 'saguin.armando.jr@gmail.com', '$2y$10$JvIIny/3f.HaQx4YSjbXBO.t5m3UAX5JcKGVYbN7OcrLn10Vpvb1K', '104291004032942577181', 'FA32SVFDAUAUELEM', 1, 'Admin', 'Active', 0, NULL, NULL, '2026-05-27 09:22:21', '2026-05-27 22:10:54');
INSERT INTO `users` VALUES (2, 'Zerones', 'Jason Marvelous', 'asaguin.jr@gmail.com', '$2y$10$fYh4HecV1OTJtKWMTfiMR.qa.VFC0ZbhH9X1OpCkmcU6qtKazEvFW', '117080367699684023506', 'WXGT3LK7Q2JZR5VH', 1, 'User', 'Active', 0, NULL, NULL, '2026-05-27 10:28:57', '2026-05-27 12:30:53');
INSERT INTO `users` VALUES (3, 'Daemon', 'Kaye Jasbille', 'kjrc.saguin@gmail.com', '$2y$10$cqK5skzb9u2eoMtuUlEc9OZ04fh0rwK3hKMQAxKr5vdsy18tcnn9C', NULL, NULL, 0, 'Data-Encoder', 'Active', 0, NULL, NULL, '2026-05-27 12:09:57', '2026-05-27 12:09:57');
INSERT INTO `users` VALUES (4, 'Viruszero', 'Billrich Arwen', 'billykidsaguin@gmail.com', '$2y$10$YOWmMMHvsgN5y3M3vZn/a.AWbQFvejY2fJ9hFSaQ2xwCjTU9qDC9q', NULL, NULL, 0, 'User', 'Suspended', 0, NULL, NULL, '2026-05-27 15:31:20', '2026-05-27 22:12:41');
INSERT INTO `users` VALUES (5, 'Shadow13', 'Armando Saguin', 'saguin.armando@gmail.com', '$2y$10$wq/g6glBaLrQMCTPblbaQuv7XFEXwsHkW8hHmo0A04727KnlAt3/a', NULL, NULL, 0, 'User', 'Suspended', 0, NULL, NULL, '2026-05-27 17:07:48', '2026-05-27 17:09:00');
INSERT INTO `users` VALUES (6, 'Jatracs', 'Rowena Campos', 'kaye.jasbille@gmail.com', '$2y$10$D38ZxOl8wV1XeK.yYs08bu3FrLqhff28UV/zeD/cNQ0ULK2rQONZK', NULL, NULL, 0, 'User', 'Deleted', 0, NULL, NULL, '2026-05-27 17:11:40', '2026-05-27 17:11:45');
INSERT INTO `users` VALUES (7, 'Billy', 'Billrich Arwen Saguin', 'bill.saguin@gmail.com', '$2y$10$YEbgLHwS.1Blj9Po2VqUre3Ktn9rE3jIKeWiEWxBFhXTrNttRVJwW', '113664580861472309990', NULL, 0, 'User', 'Inactive', 0, NULL, NULL, '2026-05-27 21:44:45', '2026-05-27 22:13:05');

-- ----------------------------
-- Function structure for fn_is_account_locked
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_is_account_locked`;
delimiter ;;
CREATE FUNCTION `fn_is_account_locked`(p_user_id INT)
 RETURNS tinyint(1)
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_add_user
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_add_user`;
delimiter ;;
CREATE PROCEDURE `sp_add_user`(IN p_username VARCHAR(50),
    IN p_account_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_user_level VARCHAR(20),
    IN p_user_status VARCHAR(20))
BEGIN
    INSERT INTO users (username, account_name, email, password_hash, user_level, user_status)
    VALUES (p_username, p_account_name, p_email, p_password_hash, p_user_level, p_user_status);
    
    SELECT LAST_INSERT_ID() as user_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_create_session
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_create_session`;
delimiter ;;
CREATE PROCEDURE `sp_create_session`(IN p_user_id INT,
        IN p_session_token VARCHAR(255),
        IN p_ip_address VARCHAR(45),
        IN p_user_agent TEXT,
        IN p_device_info VARCHAR(255))
BEGIN
        INSERT INTO user_sessions (user_id, session_token, ip_address, user_agent, device_info)
        VALUES (p_user_id, p_session_token, p_ip_address, p_user_agent, p_device_info);
        
        SELECT LAST_INSERT_ID() as session_id;
    END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_deactivate_all_user_sessions
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_deactivate_all_user_sessions`;
delimiter ;;
CREATE PROCEDURE `sp_deactivate_all_user_sessions`(IN p_user_id INT)
BEGIN
    UPDATE user_sessions 
    SET is_active = 0 
    WHERE user_id = p_user_id 
    AND is_active = 1;
    
    SELECT ROW_COUNT() as deactivated_count;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_deactivate_other_sessions
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_deactivate_other_sessions`;
delimiter ;;
CREATE PROCEDURE `sp_deactivate_other_sessions`(IN p_user_id INT,
        IN p_current_session_token VARCHAR(255))
BEGIN
        UPDATE user_sessions 
        SET is_active = 0 
        WHERE user_id = p_user_id 
        AND session_token != p_current_session_token 
        AND is_active = 1;
        
        SELECT ROW_COUNT() as deactivated_count;
    END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_deactivate_session
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_deactivate_session`;
delimiter ;;
CREATE PROCEDURE `sp_deactivate_session`(IN p_session_token VARCHAR(255))
BEGIN
        UPDATE user_sessions 
        SET is_active = 0 
        WHERE session_token = p_session_token;
    END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_delete_user
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_delete_user`;
delimiter ;;
CREATE PROCEDURE `sp_delete_user`(IN p_user_id INT)
BEGIN
    DELETE FROM users WHERE user_id = p_user_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_active_session
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_active_session`;
delimiter ;;
CREATE PROCEDURE `sp_get_active_session`(IN p_session_token VARCHAR(255))
BEGIN
        SELECT s.*, u.username, u.account_name, u.user_level, u.user_status, u.twofa_enabled
        FROM user_sessions s
        INNER JOIN users u ON s.user_id = u.user_id
        WHERE s.session_token = p_session_token 
        AND s.is_active = 1
        LIMIT 1;
    END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_all_users
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_all_users`;
delimiter ;;
CREATE PROCEDURE `sp_get_all_users`()
BEGIN
    SELECT user_id, username, account_name, email, gmail_id, 
           twofa_enabled, user_level, user_status, failed_login_attempts, created_at, updated_at
    FROM users 
    ORDER BY created_at DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_currently_active_users
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_currently_active_users`;
delimiter ;;
CREATE PROCEDURE `sp_get_currently_active_users`()
BEGIN
    SELECT DISTINCT u.user_id, u.username, u.account_name, u.email, u.user_level,
           s.login_time, s.last_activity, s.ip_address, s.device_info
    FROM users u
    INNER JOIN user_sessions s ON u.user_id = s.user_id
    WHERE s.is_active = 1
    ORDER BY s.last_activity DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_users_by_status
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_users_by_status`;
delimiter ;;
CREATE PROCEDURE `sp_get_users_by_status`(IN p_status VARCHAR(20))
BEGIN
    SELECT user_id, username, account_name, email, gmail_id, 
           twofa_enabled, user_level, user_status, failed_login_attempts, created_at, updated_at
    FROM users 
    WHERE user_status = p_status
    ORDER BY created_at DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_by_email
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_user_by_email`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_by_email`(IN p_email VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE email = p_email LIMIT 1;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_by_facebook
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_user_by_facebook`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_by_facebook`(IN p_facebook_id VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE facebook_id = p_facebook_id LIMIT 1;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_by_gmail
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_user_by_gmail`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_by_gmail`(IN p_gmail_id VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE gmail_id = p_gmail_id LIMIT 1;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_by_id
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_user_by_id`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_by_id`(IN p_user_id INT)
BEGIN
    SELECT * FROM users WHERE user_id = p_user_id LIMIT 1;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_by_username
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_user_by_username`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_by_username`(IN p_username VARCHAR(50))
BEGIN
    SELECT * FROM users WHERE username = p_username LIMIT 1;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_user_logs
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_user_logs`;
delimiter ;;
CREATE PROCEDURE `sp_get_user_logs`(IN p_user_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE)
BEGIN
    SELECT * FROM user_logs
    WHERE (p_user_id IS NULL OR user_id = p_user_id)
    AND (p_start_date IS NULL OR DATE(created_at) >= p_start_date)
    AND (p_end_date IS NULL OR DATE(created_at) <= p_end_date)
    ORDER BY created_at DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_log_activity
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_log_activity`;
delimiter ;;
CREATE PROCEDURE `sp_log_activity`(IN p_user_id INT,
    IN p_username VARCHAR(50),
    IN p_action VARCHAR(100),
    IN p_description TEXT,
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT)
BEGIN
    INSERT INTO user_logs (user_id, username, action, description, ip_address, user_agent)
    VALUES (p_user_id, p_username, p_action, p_description, p_ip_address, p_user_agent);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_record_failed_login
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_record_failed_login`;
delimiter ;;
CREATE PROCEDURE `sp_record_failed_login`(IN p_username VARCHAR(50))
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
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_register_user
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_register_user`;
delimiter ;;
CREATE PROCEDURE `sp_register_user`(IN p_username VARCHAR(50),
    IN p_account_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_gmail_id VARCHAR(100),
    IN p_twofa_secret VARCHAR(32),
    IN p_twofa_enabled TINYINT(1))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO users (username, account_name, email, password_hash, gmail_id, twofa_secret, twofa_enabled)
    VALUES (p_username, p_account_name, p_email, p_password_hash, p_gmail_id, p_twofa_secret, p_twofa_enabled);
    
    SELECT LAST_INSERT_ID() as user_id;
    
    COMMIT;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_reset_failed_login
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_reset_failed_login`;
delimiter ;;
CREATE PROCEDURE `sp_reset_failed_login`(IN p_user_id INT)
BEGIN
    UPDATE users 
    SET failed_login_attempts = 0,
        last_failed_login = NULL,
        account_locked_until = NULL
    WHERE user_id = p_user_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_update_session_token
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_session_token`;
delimiter ;;
CREATE PROCEDURE `sp_update_session_token`(IN p_old_token VARCHAR(255),
        IN p_new_token VARCHAR(255))
BEGIN
        UPDATE user_sessions 
        SET session_token = p_new_token,
            last_activity = NOW()
        WHERE session_token = p_old_token 
        AND is_active = 1;
        
        SELECT ROW_COUNT() as affected_rows;
    END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_update_user_profile
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_user_profile`;
delimiter ;;
CREATE PROCEDURE `sp_update_user_profile`(IN p_user_id INT,
        IN p_username VARCHAR(50),
        IN p_account_name VARCHAR(100),
        IN p_email VARCHAR(100),
        IN p_gmail_id VARCHAR(100),
        IN p_twofa_secret VARCHAR(32),
        IN p_twofa_enabled TINYINT(1),
        IN p_password_hash VARCHAR(255),
        IN p_user_level VARCHAR(20),
        IN p_user_status VARCHAR(20))
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
    END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
