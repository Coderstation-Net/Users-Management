<?php
// Generate password hash for Admin10122003
$password = 'Admin10122003';
$hash = password_hash($password, PASSWORD_BCRYPT);
echo "Password: $password\n";
echo "Hash: $hash\n";
