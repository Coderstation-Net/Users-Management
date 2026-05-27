<?php
session_start();
require_once 'config/config.php';
require_once 'config/database.php';
require_once 'core/Router.php';
require_once 'core/Controller.php';

// Initialize Router
$router = new Router();

// Define Routes
$router->add('GET', '/', 'AuthController@showLogin');
$router->add('GET', '/login', 'AuthController@showLogin');
$router->add('POST', '/login', 'AuthController@login');
$router->add('GET', '/register', 'AuthController@showRegister');
$router->add('POST', '/register', 'AuthController@register');
$router->add('GET', '/logout', 'AuthController@logout');

// Admin Routes
$router->add('GET', '/admin/dashboard', 'AdminController@dashboard');
$router->add('POST', '/admin/users', 'AdminController@getUsers');
$router->add('POST', '/admin/users/active', 'AdminController@getActiveUsers');
$router->add('POST', '/admin/users/inactive', 'AdminController@getInactiveUsers');
$router->add('POST', '/admin/users/suspended', 'AdminController@getSuspendedUsers');
$router->add('POST', '/admin/users/deleted', 'AdminController@getDeletedUsers');
$router->add('POST', '/admin/users/online', 'AdminController@getOnlineUsers');
$router->add('POST', '/admin/logs', 'AdminController@getLogs');
$router->add('POST', '/admin/user/update', 'AdminController@updateUser');
$router->add('POST', '/admin/user/kick', 'AdminController@kickUser');
$router->add('POST', '/admin/user/add', 'AdminController@addUser');
$router->add('POST', '/admin/user/delete', 'AdminController@deleteUser');
$router->add('POST', '/admin/user/delete-permanent', 'AdminController@deleteUserPermanent');
$router->add('POST', '/admin/user/toggle-2fa', 'AdminController@toggleUser2FA');

// User Routes
$router->add('GET', '/user/dashboard', 'UserController@dashboard');
$router->add('POST', '/user/profile', 'UserController@getProfile');
$router->add('POST', '/user/profile/update', 'UserController@updateProfile');
$router->add('POST', '/user/profile/unlink-gmail', 'UserController@unlinkGmail');
$router->add('POST', '/user/logs', 'UserController@getLogs');

// 2FA Routes
$router->add('POST', '/2fa/generate', 'TwoFactorController@generate');
$router->add('POST', '/2fa/verify', 'TwoFactorController@verify');
$router->add('POST', '/2fa/enable', 'TwoFactorController@enable');
$router->add('POST', '/2fa/disable', 'TwoFactorController@disable');

// Session Check Route
$router->add('POST', '/session/check', 'AuthController@checkSession');

// Dispatch the request
$url = isset($_GET['url']) ? $_GET['url'] : '/';
$method = $_SERVER['REQUEST_METHOD'];

$router->dispatch($method, $url);
