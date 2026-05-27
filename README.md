# User Management System

A comprehensive user management system built with PHP MVC architecture, featuring authentication, authorization, 2FA, OAuth integration, and activity logging.

## Features

### Authentication & Authorization
- **Multiple Login Options:**
  - Username and Password
  - Single Sign-On (SSO) with Google
  - Single Sign-On (SSO) with Facebook
  - Two-Factor Authentication (2FA) with Google Authenticator

### User Management
- User registration with email binding (Gmail required)
- Optional Facebook account binding
- Optional 2FA setup during registration
- User profile management
- User levels: Admin, User, Data-Encoder
- User statuses: Active, Inactive, Suspended, Deleted

### Security Features
- Password hashing with bcrypt
- 2FA support using Google Authenticator
- Session management with multi-device logout
- Failed login attempt tracking (3 attempts = 24-hour lock)
- Automatic session validation
- IP address and device tracking

### Admin Dashboard
- View users by status (Active, Inactive, Suspended, Deleted)
- View currently online users
- Edit user accounts
- Kick users from active sessions
- User activity logs with filtering
- Print reports

### User Dashboard
- Edit profile information
- Enable/Disable 2FA
- Change password
- View personal activity logs
- Filter logs by date

### Additional Features
- Multi-device login detection and logout
- Real-time session monitoring
- Toast notifications for all actions
- Responsive design with Bootstrap 5
- Activity logging for audit trails
- Print functionality for reports

## Technology Stack

- **Backend:** PHP 7.4+ with MVC architecture
- **Database:** MySQL with stored procedures
- **Frontend:** HTML5, CSS3, JavaScript (jQuery)
- **UI Framework:** Bootstrap 5
- **Icons:** Font Awesome 6
- **QR Code:** kjua v0.1.1
- **Authentication:** Google Authenticator (TOTP)

## Installation

### Prerequisites
- PHP 7.4 or higher
- MySQL 5.7 or higher
- Apache with mod_rewrite enabled
- Laragon (or similar local server environment)

### Setup Instructions

1. **Database Setup:**
   ```bash
   # Import the database schema
   mysql -u root -p -P 3307 < database/schema.sql
   
   # Import stored procedures
   mysql -u root -p -P 3307 < database/stored_procedures.sql
   ```

2. **Configuration:**
   - Database credentials are already configured in `config/config.php`
   - OAuth credentials are pre-configured for Google and Facebook
   - Update `config/config.php` if you need to change any settings

3. **Apache Configuration:**
   - Ensure mod_rewrite is enabled
   - The `.htaccess` file is already configured for clean URLs

4. **File Permissions:**
   - Ensure the web server has read access to all files
   - No special write permissions needed

5. **Access the Application:**
   - Navigate to: `http://localhost/User-Management/`
   - Default admin credentials:
     - Username: `Admin`
     - Password: `Admin10122003`

## Project Structure

```
User-Management/
├── .htaccess                 # Apache rewrite rules
├── index.php                 # Application entry point
├── config/
│   ├── config.php           # Application configuration
│   └── database.php         # Database connection class
├── core/
│   ├── Router.php           # Routing system
│   └── Controller.php       # Base controller
├── controllers/
│   ├── AuthController.php   # Authentication logic
│   ├── AdminController.php  # Admin functionality
│   ├── UserController.php   # User functionality
│   └── TwoFactorController.php # 2FA management
├── models/
│   ├── User.php             # User model
│   ├── Session.php          # Session model
│   └── UserLog.php          # Activity log model
├── views/
│   ├── auth/
│   │   ├── login.php        # Login page
│   │   └── register.php     # Registration page
│   ├── admin/
│   │   └── dashboard.php    # Admin dashboard
│   └── user/
│       └── dashboard.php    # User dashboard
├── assets/
│   ├── css/
│   │   └── style.css        # Main stylesheet
│   └── js/
│       ├── main.js          # Core JavaScript
│       ├── admin.js         # Admin dashboard JS
│       └── user.js          # User dashboard JS
├── helpers/
│   └── GoogleAuthenticator.php # 2FA helper
├── oauth/
│   ├── google.php           # Google OAuth init
│   ├── google_callback.php  # Google OAuth callback
│   ├── facebook.php         # Facebook OAuth init
│   └── facebook_callback.php # Facebook OAuth callback
└── database/
    ├── schema.sql           # Database schema
    └── stored_procedures.sql # Stored procedures
```

## Database Schema

### Tables

1. **users** - User account information
2. **user_sessions** - Active user sessions
3. **user_logs** - Activity audit logs

### Stored Procedures

- `sp_register_user` - Register new user
- `sp_get_user_by_username` - Get user by username
- `sp_get_user_by_email` - Get user by email
- `sp_get_user_by_gmail` - Get user by Gmail ID
- `sp_get_user_by_facebook` - Get user by Facebook ID
- `sp_update_user_profile` - Update user profile
- `sp_record_failed_login` - Record failed login attempt
- `sp_reset_failed_login` - Reset failed login counter
- `sp_create_session` - Create user session
- `sp_deactivate_other_sessions` - Deactivate other sessions
- `sp_get_active_session` - Get active session
- `sp_deactivate_session` - Deactivate session
- `sp_deactivate_all_user_sessions` - Deactivate all user sessions
- `sp_log_activity` - Log user activity
- `sp_get_users_by_status` - Get users by status
- `sp_get_all_users` - Get all users
- `sp_get_currently_active_users` - Get currently online users
- `sp_get_user_logs` - Get user logs with filters
- `sp_get_user_by_id` - Get user by ID

### Functions

- `fn_is_account_locked` - Check if account is locked

## Usage Guide

### For Users

1. **Registration:**
   - Navigate to the registration page
   - Fill in required fields (Username, Account Name, Email)
   - Optionally bind Facebook account
   - Optionally enable 2FA during registration
   - Submit the form

2. **Login:**
   - Use username and password
   - OR use Google/Facebook SSO
   - Enter 2FA code if enabled

3. **Profile Management:**
   - Access user dashboard
   - Edit profile information
   - Enable/Disable 2FA
   - Change password
   - View activity logs

### For Administrators

1. **User Management:**
   - View users by status
   - Edit user accounts
   - Change user levels and statuses
   - Reset passwords

2. **Session Management:**
   - View currently online users
   - Kick users from active sessions

3. **Monitoring:**
   - View user activity logs
   - Filter logs by date and user
   - Print reports

## Security Features

### Password Security
- Minimum 8 characters required
- Passwords hashed using bcrypt
- Password confirmation required

### Account Lockout
- 3 failed login attempts trigger 24-hour lockout
- Automatic unlock after lockout period

### Session Security
- Unique session tokens
- Multi-device detection
- Automatic logout from other devices on new login
- Session validation every 30 seconds
- Admin can kick users from sessions

### 2FA Security
- TOTP-based authentication
- QR code generation for easy setup
- Manual secret key entry option
- Verification required before enabling

## API Endpoints

### Authentication
- `POST /login` - User login
- `POST /register` - User registration
- `GET /logout` - User logout
- `GET /session/check` - Check session validity

### Admin
- `GET /admin/dashboard` - Admin dashboard
- `GET /admin/users` - Get all users
- `GET /admin/users/active` - Get active users
- `GET /admin/users/inactive` - Get inactive users
- `GET /admin/users/suspended` - Get suspended users
- `GET /admin/users/deleted` - Get deleted users
- `GET /admin/users/online` - Get online users
- `GET /admin/logs` - Get user logs
- `POST /admin/user/update` - Update user
- `POST /admin/user/kick` - Kick user

### User
- `GET /user/dashboard` - User dashboard
- `GET /user/profile` - Get user profile
- `POST /user/profile/update` - Update profile
- `GET /user/logs` - Get user logs

### 2FA
- `POST /2fa/generate` - Generate 2FA secret
- `POST /2fa/verify` - Verify 2FA code
- `POST /2fa/enable` - Enable 2FA
- `POST /2fa/disable` - Disable 2FA

## Color Theme

```css
--primary-color: #26549E;
--secondary-color: #FF5C0A;
--bg-color: #f4f6f8;
--text-color: #111827;
```

## Browser Compatibility

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Troubleshooting

### Database Connection Issues
- Verify MySQL is running on port 3307
- Check database credentials in `config/config.php`
- Ensure database and tables are created

### OAuth Issues
- Verify OAuth credentials are correct
- Check redirect URIs match configuration
- Ensure curl extension is enabled in PHP

### Session Issues
- Check PHP session configuration
- Verify session directory is writable
- Clear browser cookies if needed

### 2FA Issues
- Ensure time is synchronized on server
- Verify QR code is scanned correctly
- Check secret key is saved properly

## License

Copyright 2026 CODERSTATION. All Rights Reserved.

## Support

For issues or questions, please contact the development team.
