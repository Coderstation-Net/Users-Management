# Quick Setup Guide

## Step 1: Database Setup

Run the following command in your terminal (from the project root):

```bash
mysql -u root -pAdmin1234 -P 3307 < database/setup.sql
```

Or manually:
1. Open phpMyAdmin or MySQL Workbench
2. Connect to MySQL (localhost:3307, user: root, password: Admin1234)
3. Execute the SQL file: `database/setup.sql`

## Step 2: Verify Installation

1. Navigate to: http://localhost/User-Management/
2. You should see the login page

## Step 3: Login with Default Admin

- Username: `Admin`
- Password: `Admin10122003`

## Step 4: Test the System

### Test Registration:
1. Click "Register here"
2. Fill in the form
3. Optionally enable 2FA
4. Submit

### Test Login:
1. Use your registered credentials
2. If 2FA is enabled, enter the code from Google Authenticator

### Test Admin Features:
1. Login as admin
2. View different user tabs
3. Edit a user
4. View logs

### Test User Features:
1. Login as a regular user
2. Edit your profile
3. Enable/Disable 2FA
4. View your activity logs

## Troubleshooting

### If you get "Database connection failed":
- Check if MySQL is running
- Verify port 3307 is correct
- Check credentials in config/config.php

### If you get "Route not found":
- Ensure mod_rewrite is enabled in Apache
- Check .htaccess file exists

### If OAuth doesn't work:
- OAuth credentials are pre-configured but may need updating
- Check redirect URIs match your domain

## Next Steps

1. Change the default admin password
2. Configure OAuth credentials if needed
3. Customize the color theme in assets/css/style.css
4. Add more users and test features

## Features to Test

- [x] User Registration
- [x] User Login (Username/Password)
- [x] 2FA Setup and Login
- [x] Profile Editing
- [x] Password Change
- [x] Admin Dashboard
- [x] User Management
- [x] Session Management (Multi-device logout)
- [x] Activity Logs
- [x] User Kick Feature
- [x] Toast Notifications
- [x] Account Lockout (3 failed attempts)

Enjoy your User Management System!
