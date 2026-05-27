# Database Setup Instructions

## Option 1: Using the Batch File (Easiest)

1. Double-click `setup_database.bat`
2. The script will automatically find MySQL and set up the database
3. If successful, you'll see a success message

## Option 2: Using phpMyAdmin

1. Open phpMyAdmin in your browser: http://localhost/phpmyadmin
2. Login with:
   - Username: root
   - Password: Admin1234
3. Click on "Import" tab
4. Choose file: `database/setup.sql`
5. Click "Go" button
6. Wait for completion

## Option 3: Using MySQL Command Line

If you know where MySQL is installed:

```bash
mysql -u root -pAdmin1234 -P 3307 < database/setup.sql
```

## Option 4: Manual Setup

1. Open the file `database/setup.sql` in a text editor
2. Copy all the contents
3. Open phpMyAdmin or MySQL Workbench
4. Paste and execute the SQL

## After Setup

Once the database is set up, you can access the application:

**URL:** http://localhost/User-Management/

**Default Admin Login:**
- Username: `Admin`
- Password: `Admin10122003`

## Verification

To verify the database was created successfully:

1. Open phpMyAdmin
2. You should see a database named `user_management`
3. It should contain 3 tables:
   - users
   - user_sessions
   - user_logs
4. The users table should have 1 admin user

## Troubleshooting

**If you get connection errors:**
- Make sure MySQL is running (check Laragon)
- Verify the port is 3307
- Check the password is Admin1234

**If tables are not created:**
- Check for SQL errors in phpMyAdmin
- Make sure you have permission to create databases

**If stored procedures are not created:**
- Check MySQL version (should be 5.7+)
- Look for errors in the SQL execution log

## Need Help?

If you encounter any issues, please check:
1. Is Laragon running?
2. Is MySQL service started?
3. Can you access phpMyAdmin?
4. What error message do you see?
