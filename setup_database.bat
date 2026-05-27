@echo off
echo Setting up User Management Database...
echo.

REM Try to find MySQL in common Laragon locations
set MYSQL_PATH=

if exist "F:\Laragon\bin\mysql\mysql-8.2.0-winx64\bin\mysql.exe" set MYSQL_PATH=F:\Laragon\bin\mysql\mysql-8.2.0-winx64\bin\mysql.exe
if exist "F:\Laragon\bin\mysql\MySQL Server 9.4\bin\mysql.exe" set MYSQL_PATH=F:\Laragon\bin\mysql\MySQL Server 9.4\bin\mysql.exe
if exist "C:\laragon\bin\mysql\mysql-8.0.30\bin\mysql.exe" set MYSQL_PATH=C:\laragon\bin\mysql\mysql-8.0.30\bin\mysql.exe
if exist "C:\laragon\bin\mysql\mysql-5.7.24\bin\mysql.exe" set MYSQL_PATH=C:\laragon\bin\mysql\mysql-5.7.24\bin\mysql.exe
if exist "F:\Laragon\bin\mysql\mysql-8.0.30\bin\mysql.exe" set MYSQL_PATH=F:\Laragon\bin\mysql\mysql-8.0.30\bin\mysql.exe
if exist "F:\Laragon\bin\mysql\MySQL 5\bin\mysql.exe" set MYSQL_PATH=F:\Laragon\bin\mysql\MySQL 5\bin\mysql.exe

if "%MYSQL_PATH%"=="" (
    echo ERROR: MySQL not found in common Laragon locations.
    echo Please run the SQL manually using phpMyAdmin or MySQL Workbench.
    echo SQL file location: database\setup.sql
    pause
    exit /b 1
)

echo Found MySQL at: %MYSQL_PATH%
echo.
echo Running database setup...
echo.

"%MYSQL_PATH%" -u root -pAdmin1234 -P 3307 < database\setup.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Database setup completed successfully!
    echo ========================================
    echo.
    echo Default admin credentials:
    echo Username: Admin
    echo Password: Admin10122003
    echo.
    echo You can now access the application at:
    echo http://localhost/User-Management/
    echo.
) else (
    echo.
    echo ERROR: Database setup failed!
    echo Please check:
    echo 1. MySQL is running
    echo 2. Port 3307 is correct
    echo 3. Password is Admin1234
    echo.
    echo Or run the SQL manually using phpMyAdmin.
    echo.
)

pause
