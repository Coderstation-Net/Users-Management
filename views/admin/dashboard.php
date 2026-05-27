<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CODERSTATION</title>
    <link rel="icon" type="image/png" href="/User-Management/assets/icons/favicon.png">
    <link rel="stylesheet" href="/User-Management/assets/css/style.css?v=1.23">
    <link rel="stylesheet" href="/User-Management/assets/css/all.min.css">
</head>

<body data-logged-in="true" data-user-id="<?php echo $_SESSION['user_id']; ?>">
    <div class="app-wrapper">
        <!-- Header -->
        <header class="app-header">
            <div class="container" style="max-width: 100%; padding: 0 1.5rem;">
                <div class="brand-name">
                    <button class="menu-toggle" id="menu-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <img src="/User-Management/assets/icons/favicon.png" alt="CODERSTATION" style="width: 30px; height: 30px; object-fit: contain;">
                    <div class="brand-text" style="display: flex; flex-direction: column; line-height: 1.15;">
                        <span>CODERSTATION</span>
                        <span class="brand-subtitle">Admin Dashboard</span>
                    </div>
                </div>
                <div class="header-nav">
                    <a href="/User-Management/logout" class="d-none d-sm-inline">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </header>

        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <div id="sidebar-wrapper">
                <div class="list-group list-group-flush" style="padding-top: 1rem;">
                <a href="#" class="list-group-item list-group-item-action active" data-tab="dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="#" class="list-group-item list-group-item-action" data-tab="manageUsers">
                    <i class="fas fa-users-cog"></i> User Management
                </a>
                <a href="#" class="list-group-item list-group-item-action" data-tab="userLogs">
                    <i class="fas fa-history"></i> User Logs
                </a>
                <a href="#" class="list-group-item list-group-item-action" data-tab="myProfile">
                    <i class="fas fa-user-circle"></i> My Profile
                </a>
                <a href="/User-Management/logout" class="list-group-item list-group-item-action text-danger">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
            
            <!-- User Info at bottom of sidebar -->
            <div class="sidebar-user-info" style="margin-top: auto; padding: 1.25rem 1rem; border-top: 1px solid rgba(255,255,255,0.08); background: rgba(0,0,0,0.15);">
                <div style="display: flex; align-items: center; gap: 0.75rem;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--secondary); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.2);">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div style="display: flex; flex-direction: column;">
                        <span style="font-weight: 700; font-size: 0.95rem; line-height: 1.2;"><?php echo htmlspecialchars($_SESSION['account_name']); ?></span>
                        <span style="font-size: 0.75rem; color: rgba(255,255,255,0.6); text-transform: uppercase; letter-spacing: 0.5px; margin-top: 2px;">Admin</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Page Content -->
        <div id="page-content-wrapper">
            <div class="main-container">
                <!-- Dashboard Overview -->
                <div class="content-section active" id="dashboard-overview">
                    <h2 class="mb-4">Dashboard Overview</h2>
                    <div class="stats-grid">
                        <div class="stat-card" data-tab="onlineUsers" style="cursor: pointer;">
                            <div class="stat-value text-info" id="totalOnlineUsers">0</div>
                            <div class="stat-label">Online Now</div>
                        </div>
                        <div class="stat-card" data-tab="activeUsers" style="cursor: pointer;">
                            <div class="stat-value text-success" id="totalActiveUsers">0</div>
                            <div class="stat-label">Active Users</div>
                        </div>
                        <div class="stat-card" data-tab="inactiveUsers" style="cursor: pointer;">
                            <div class="stat-value text-warning" id="totalInactiveUsers">0</div>
                            <div class="stat-label">Inactive Users</div>
                        </div>
                        <div class="stat-card" data-tab="suspendedUsers" style="cursor: pointer;">
                            <div class="stat-value text-danger" id="totalSuspendedUsers">0</div>
                            <div class="stat-label">Suspended</div>
                        </div>
                        <div class="stat-card" data-tab="deletedUsers" style="cursor: pointer;">
                            <div class="stat-value text-muted" id="totalDeletedUsers">0</div>
                            <div class="stat-label">Deleted</div>
                        </div>
                        <div class="stat-card" data-tab="allUsers" style="cursor: pointer;">
                            <div class="stat-value text-primary" id="totalUsersCount">0</div>
                            <div class="stat-label">Total Users</div>
                        </div>
                    </div>

                    <!-- Charts Section -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card mt-4 mb-4" id="user-distribution-card">
                                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 1rem; border-bottom: 1px solid var(--border-color);">
                                    <h3 class="card-title" style="margin: 0;"><i class="fas fa-chart-pie text-primary"></i> User Distribution</h3>
                                </div>
                                <div class="card-body">
                                    <div class="dashboard-chart-container">
                                        <div class="chart-wrapper">
                                            <canvas id="userStatusChart" height="250"></canvas>
                                        </div>
                                        <div class="distribution-table-container">
                                            <table class="table" id="distributionTable" style="margin: 0; background: transparent; border: none;">
                                                <thead>
                                                    <tr>
                                                        <th style="border-top: none;">Status</th>
                                                        <th class="text-right" style="border-top: none;">Count</th>
                                                        <th class="text-right" style="border-top: none;">%</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <!-- Dynamically populated by JS -->
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Online Users Section -->
                    <div class="card mt-4" id="online-users-card">
                        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border-color);">
                            <h3 class="card-title" style="margin: 0;"><i class="fas fa-wifi text-info"></i> Online Users</h3>
                            <button class="btn btn-secondary btn-sm" onclick="window.print()">
                                <i class="fas fa-print"></i> Print Report
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table footable" id="onlineUsersTable" data-paging="true" data-filtering="true"
                                    data-sorting="true">
                                    <thead>
                                        <tr>
                                            <th data-name="username">Username</th>
                                            <th data-name="account_name">Account Name</th>
                                            <th data-name="user_level" data-breakpoints="xs">User Level</th>
                                            <th data-name="login_time" data-breakpoints="xs">Login Time</th>
                                            <th data-name="last_activity" data-breakpoints="xs">Last Activity</th>
                                            <th data-name="ip_address" data-breakpoints="xs sm">IP Address</th>
                                            <th data-name="user_agent" data-breakpoints="xs sm">Device</th>
                                            <th data-name="actions" class="no-print" data-filterable="false" data-sortable="false">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Management Tab -->
                <div class="content-section" id="manageUsers">
                    <div class="d-flex justify-content-between align-items-center mb-4" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                        <h2 style="margin: 0;">User Management</h2>
                        <button class="btn btn-primary" id="btnShowAddUser">
                            <i class="fas fa-user-plus"></i> Add New User
                        </button>
                    </div>

                    <!-- Add User Modal (Dialog Floating Form) -->
                    <div class="modal" id="addUserModal">
                        <div class="modal-dialog" style="max-width: 650px;">
                            <div class="modal-header">
                                <h3 class="modal-title" style="margin: 0;"><i class="fas fa-user-plus text-primary"></i> Add New User</h3>
                                <button type="button" class="modal-close" data-dismiss="modal" id="btnHideAddUser">&times;</button>
                            </div>
                            <div class="modal-body">
                                <form id="addUserForm">
                                    <div class="form-row">
                                        <div class="form-group-floating">
                                            <input type="text" class="form-control" id="add_username" name="username" placeholder=" " required>
                                            <label for="add_username">Username</label>
                                        </div>
                                        <div class="form-group-floating">
                                            <input type="text" class="form-control" id="add_account_name" name="account_name" placeholder=" " required>
                                            <label for="add_account_name">Account Name</label>
                                        </div>
                                    </div>

                                    <div class="form-group-floating">
                                        <input type="email" class="form-control" id="add_email" name="email" placeholder=" " required>
                                        <label for="add_email">Email Address</label>
                                    </div>
                                    <div style="margin-bottom: 25px;"></div>

                                    <div class="form-row" style="grid-template-columns: repeat(2, 1fr); gap: 1.5rem; margin-bottom: 1.5rem;">
                                        <div class="form-group">
                                            <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-size: 0.875rem; color: var(--text-muted); font-weight: 600;">User Level</label>
                                            <select class="form-select" id="add_user_level" name="user_level">
                                                <option value="User" selected>User</option>
                                                <option value="Admin">Admin</option>
                                                <option value="Data-Encoder">Data-Encoder</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-size: 0.875rem; color: var(--text-muted); font-weight: 600;">User Status</label>
                                            <select class="form-select" id="add_user_status" name="user_status">
                                                <option value="Active" selected>Active</option>
                                                <option value="Inactive">Inactive</option>
                                                <option value="Suspended">Suspended</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group-floating">
                                            <input type="password" class="form-control" id="add_password" name="password" placeholder=" " required>
                                            <label for="add_password">Password</label>
                                        </div>
                                        <div class="form-group-floating">
                                            <input type="password" class="form-control" id="add_confirm_password" name="confirm_password" placeholder=" " required>
                                            <label for="add_confirm_password">Confirm Password</label>
                                        </div>
                                    </div>
                                    <div style="margin-bottom: 30px;"></div>

                                    <div class="modal-footer" style="padding: 0; border: none; justify-content: flex-end; gap: 10px;">
                                        <button type="button" class="btn btn-back" id="btnCancelAddUser" data-dismiss="modal">
                                            <i class="fas fa-arrow-left"></i> Back
                                        </button>
                                        <button type="submit" class="btn btn-primary" id="btnSubmitAddUser">Submit</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- User Table Card -->
                    <div class="card">
                        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border-color);">
                            <div style="display: flex; align-items: center; gap: 1rem; flex-wrap: wrap;">
                                <h3 class="card-title" style="margin: 0;"><i class="fas fa-users text-primary"></i> Accounts List</h3>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <label for="filterAccount" style="font-size: 0.875rem; font-weight: 600; color: var(--text-muted); white-space: nowrap; margin-bottom: 0;">Filter Account:</label>
                                    <select class="form-select" id="filterAccount" style="padding: 0.25rem 2rem 0.25rem 0.75rem; height: auto; font-size: 0.875rem; width: auto; border-radius: var(--radius-md);">
                                        <option value="All" selected>All Users</option>
                                        <option value="Active">Active Users</option>
                                        <option value="Inactive">Inactive Users</option>
                                        <option value="Suspended">Suspended Users</option>
                                        <option value="Deleted">Deleted Users</option>
                                    </select>
                                </div>
                            </div>
                            <button class="btn btn-secondary btn-sm" id="btnPrintUsersBtn">
                                <i class="fas fa-print"></i> Print Report
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive" id="usersTableContainer">
                                <table class="table footable" id="usersTable" data-paging="true" data-filtering="true" data-sorting="true">
                                    <thead>
                                        <tr>
                                            <th data-name="username">Username</th>
                                            <th data-name="account_name">Account Name</th>
                                            <th data-name="email" data-breakpoints="xs">Email</th>
                                            <th data-name="user_level" data-breakpoints="xs">User Level</th>
                                            <th data-name="user_status">Status</th>
                                            <th data-name="created_at" data-breakpoints="xs sm">Created</th>
                                            <th data-name="actions" class="no-print" data-filterable="false" data-sortable="false">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>



                <!-- User Logs Tab -->
                <div class="content-section" id="userLogs">
                    <h2 class="mb-3">User Logs</h2>
                    <div class="mb-3">
                        <div class="form-row">
                            <div class="form-group-floating">
                                <input type="date" class="form-control" id="startDate" placeholder=" ">
                                <label for="startDate">Start Date</label>
                            </div>
                            <div class="form-group-floating">
                                <input type="date" class="form-control" id="endDate" placeholder=" ">
                                <label for="endDate">End Date</label>
                            </div>
                        </div>
                        <button class="btn btn-primary" id="filterLogsBtn">
                            <i class="fas fa-filter"></i> Filter
                        </button>
                        <button class="btn btn-secondary" id="printLogsBtn">
                            <i class="fas fa-print"></i> Print Report
                        </button>
                    </div>
                    <div class="table-responsive" id="logsTableContainer">
                        <table class="table footable" id="logsTable" data-paging="true" data-filtering="true"
                            data-sorting="true">
                            <thead>
                                <tr>
                                    <th data-name="created_at">Date/Time</th>
                                    <th data-name="username">Username</th>
                                    <th data-name="action">Action</th>
                                    <th data-name="description" data-breakpoints="xs">Description</th>
                                    <th data-name="ip_address" data-breakpoints="xs sm">IP Address</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>



                <!-- My Profile (Keep existing structure but wrap in content-section) -->
                <!-- Note: The previous logic for myProfile is compatible if we just ensure IDs match -->


                <!-- Edit User Modal -->
                <div class="modal" id="editUserModal">
                    <div class="modal-dialog" style="max-width: 650px;">
                        <div class="modal-header">
                            <h3 class="modal-title" style="margin: 0;"><i class="fas fa-edit text-primary"></i> Edit User</h3>
                            <button class="modal-close" data-dismiss="modal" id="btnHideEditUser">&times;</button>
                        </div>
                        <div class="modal-body">
                            <form id="editUserForm">
                                <input type="hidden" id="edit_user_id">

                                <div class="form-row">
                                    <div class="form-group-floating">
                                        <input type="text" class="form-control" id="edit_username" name="username" placeholder=" " required>
                                        <label for="edit_username">Username</label>
                                    </div>
                                    <div class="form-group-floating">
                                        <input type="text" class="form-control" id="edit_account_name" name="account_name" placeholder=" " required>
                                        <label for="edit_account_name">Account Name</label>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group-floating">
                                        <input type="email" class="form-control" id="edit_email" name="email" placeholder=" " required>
                                        <label for="edit_email">Email Address</label>
                                    </div>
                                    <div class="form-group-floating">
                                        <input type="text" class="form-control" id="edit_gmail_id" name="gmail_id" placeholder=" " readonly style="background-color: #f3f4f6; cursor: not-allowed;">
                                        <label for="edit_gmail_id">Gmail ID (Locked)</label>
                                    </div>
                                </div>

                                <div class="form-row" style="grid-template-columns: repeat(2, 1fr); gap: 1.5rem; margin-bottom: 1.5rem;">
                                    <div class="form-group">
                                        <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-size: 0.875rem; color: var(--text-muted); font-weight: 600;">User Level</label>
                                        <select class="form-select" id="edit_user_level" name="user_level">
                                            <option value="Admin">Admin</option>
                                            <option value="User">User</option>
                                            <option value="Data-Encoder">Data-Encoder</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" style="display: block; margin-bottom: 0.5rem; font-size: 0.875rem; color: var(--text-muted); font-weight: 600;">User Status</label>
                                        <select class="form-select" id="edit_user_status" name="user_status">
                                            <option value="Active">Active</option>
                                            <option value="Inactive">Inactive</option>
                                            <option value="Suspended">Suspended</option>
                                            <option value="Deleted">Deleted</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Security and Locks Panel -->
                                <div style="background-color: #f8fafc; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1.5rem; margin-bottom: 1.5rem;">
                                    <h4 style="margin: 0 0 1rem 0; font-size: 0.95rem; font-weight: 600; color: var(--text-color);"><i class="fas fa-shield-alt text-primary"></i> Account Security & Lock Status</h4>
                                    
                                    <div class="form-row" style="grid-template-columns: 1fr 1fr; align-items: center; gap: 1.5rem;">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label text-muted small" style="display: block; margin-bottom: 5px;">Login Attempts</label>
                                            <div style="display: flex; align-items: center; gap: 15px;">
                                                <span id="edit_failed_attempts" class="badge badge-info" style="font-size: 1rem; padding: 0.35em 0.8em; border-radius: 4px;">0</span>
                                                <div class="form-check" style="display: flex; align-items: center; gap: 8px;">
                                                    <input type="checkbox" class="form-check-input" id="reset_failed_attempts" name="reset_failed_attempts" style="width: 18px; height: 18px; cursor: pointer;">
                                                    <label for="reset_failed_attempts" style="margin: 0; font-size: 0.875rem; cursor: pointer; font-weight: 500;">Reset & Unlock</label>
                                                </div>
                                            </div>
                                            <small id="locked_until_wrapper" class="text-danger" style="display: block; margin-top: 5px; font-weight: bold;">
                                                Locked Until: <span id="edit_locked_until">N/A</span>
                                            </small>
                                        </div>

                                        <!-- Admin 2FA Toggle Panel -->
                                        <div class="form-group" style="margin-bottom: 0;" id="admin2faPanelWrapper">
                                            <label class="form-label text-muted small" style="display: block; margin-bottom: 8px;">Google Authenticator (2FA)</label>
                                            <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                                                <span id="admin2faBadge" class="badge" style="font-size: 0.8rem; padding: 0.35em 0.9em; border-radius: 20px;">Loading...</span>
                                                <button type="button" class="btn btn-sm btn-success" id="btnAdminEnable2FA" style="display: none;"><i class="fas fa-shield-alt"></i> Enable 2FA</button>
                                                <button type="button" class="btn btn-sm btn-danger" id="btnAdminDisable2FA" style="display: none;"><i class="fas fa-shield-virus"></i> Disable 2FA</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group-floating">
                                        <input type="password" class="form-control" id="edit_password" name="password" placeholder=" ">
                                        <label for="edit_password">New Password</label>
                                        <small class="text-muted" style="position: absolute; bottom: -20px; left: 0;">Leave blank to keep current</small>
                                    </div>
                                    <div class="form-group-floating">
                                        <input type="password" class="form-control" id="edit_confirm_password" name="confirm_password" placeholder=" ">
                                        <label for="edit_confirm_password">Confirm Password</label>
                                    </div>
                                </div>
                                <div style="margin-bottom: 30px;"></div>

                                <div class="modal-footer" style="padding: 0; border: none; justify-content: flex-end; gap: 10px;">
                                    <button type="button" class="btn btn-back" id="btnCancelEditUser" data-dismiss="modal">
                                        <i class="fas fa-arrow-left"></i> Back
                                    </button>
                                    <button type="submit" class="btn btn-primary" id="saveUserBtn">
                                        <i class="fas fa-save"></i> Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!-- My Profile Tab -->
                <div class="content-section" id="myProfile">
                    <div class="nav-tabs mb-4" style="border-bottom: 2px solid #E5E7EB; display: flex;">
                        <button class="sub-nav-tab active" data-modal-tab="adminInfo">Profile Info</button>
                        <button class="sub-nav-tab" data-modal-tab="adminLogs">Activity Logs</button>
                    </div>

                    <div id="adminInfo" class="modal-tab-content active">
                        <form id="adminProfileForm">
                            <input type="hidden" id="admin_profile_id" name="user_id">

                            <div class="form-row">
                                <div class="form-group-floating">
                                    <input type="text" class="form-control" id="admin_username" name="username"
                                        placeholder=" ">
                                    <label for="admin_username">Username</label>
                                </div>
                                <div class="form-group-floating">
                                    <input type="text" class="form-control" id="admin_account_name" name="account_name"
                                        placeholder=" ">
                                    <label for="admin_account_name">Account Name</label>
                                </div>
                            </div>

                            <div class="form-group-floating">
                                <input type="email" class="form-control" id="admin_email" name="email" placeholder=" ">
                                <label for="admin_email">Email Address</label>
                            </div>
                            <div style="margin-bottom: 25px;"></div>

                            <div class="form-group mb-3">
                                <label class="form-label text-muted small"
                                    style="display: block; margin-bottom: 5px;">Gmail Account</label>
                                <div style="display: flex; gap: 10px; align-items: center;">
                                    <div style="position: relative; flex: 1;">
                                        <input type="text" class="form-control" id="admin_gmail_id" readonly
                                            placeholder="Not Connected"
                                            style="padding-left: 35px; background-color: #f3f4f6;">
                                        <i class="fab fa-google"
                                            style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #DB4437;"></i>
                                    </div>
                                    <button type="button" class="btn btn-outline-primary btn-sm" id="btnBindGmail" style="display:none;">
                                        <i class="fab fa-google"></i> Connect
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm" id="btnUnbindGmail" style="display:none;">
                                        <i class="fas fa-unlink"></i> Unlink
                                    </button>
                                </div>
                            </div>

                            <hr>

                            <h4 class="mb-3">
                                <i class="fas fa-key"></i> Change Password
                            </h4>

                            <div class="form-row">
                                <div class="form-group-floating">
                                    <input type="password" class="form-control" id="admin_password" name="password"
                                        placeholder=" ">
                                    <label for="admin_password">New Password</label>
                                    <small class="text-muted" style="position: absolute; bottom: -20px; left: 0;">Leave
                                        blank to keep current</small>
                                </div>
                                <div class="form-group-floating">
                                    <input type="password" class="form-control" id="admin_confirm_password"
                                        name="confirm_password" placeholder=" ">
                                    <label for="admin_confirm_password">Confirm Password</label>
                                </div>
                            </div>
                            <div style="margin-bottom: 25px;"></div>

                            <hr>
                            <h4 class="mb-3">
                                <i class="fas fa-shield-alt"></i> Security Settings
                            </h4>

                            <div class="form-group mb-3">
                                <div class="form-check" style="display: flex; align-items: center; gap: 10px;">
                                    <input type="checkbox" class="form-check-input" id="admin_twofa_toggle"
                                        name="twofa_enabled" style="width: 20px; height: 20px;">
                                    <label class="form-label" for="admin_twofa_toggle"
                                        style="margin: 0; cursor: pointer;">Enable
                                        Google Authenticator (2FA)</label>
                                </div>
                            </div>

                            <div style="margin-top: 20px;">
                                <button type="submit" class="btn btn-success" id="saveAdminProfileBtn">
                                    <i class="fas fa-save"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                    <div id="adminLogs" class="modal-tab-content" style="display: none;">
                        <div class="table-responsive">
                            <table class="table footable" id="adminLogsTable" data-paging="true" data-filtering="true"
                                data-sorting="true">
                                <thead>
                                    <tr>
                                        <th data-name="created_at">Date/Time</th>
                                        <th data-name="action">Action</th>
                                        <th data-name="description">Description</th>
                                        <th data-name="ip_address" data-breakpoints="xs">IP Address</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>



                <!-- 2FA Setup Modal (Reused for Admin) -->
                <div class="modal" id="twoFAModal">
                    <div class="modal-dialog">
                        <div class="modal-header">
                            <h3 class="modal-title" style="margin: 0;">Setup Google Authenticator</h3>
                            <button class="modal-close" data-dismiss="twofa-modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <p class="text-center mb-3">Scan this QR code with your Google Authenticator app:</p>
                            <div class="qr-code-container text-center mb-3" id="qrCodeContainer"></div>
                            <div class="form-group-floating">
                                <input type="text" class="form-control" id="secretKey" readonly placeholder=" ">
                                <label for="secretKey">Secret Key</label>
                            </div>
                            <div class="form-group-floating">
                                <input type="text" class="form-control" id="verifyCode" maxlength="6" placeholder=" ">
                                <label for="verifyCode">Enter 6-digit code</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-dismiss="twofa-modal">Cancel</button>
                            <button class="btn btn-primary" id="verify2FABtn">Verify & Enable</button>
                        </div>
                    </div>
                </div>

                <!-- Admin: Enable 2FA for User Modal -->
                <div class="modal" id="admin2FASetupModal">
                    <div class="modal-dialog" style="max-width: 480px;">
                        <div class="modal-header">
                            <h3 class="modal-title" style="margin: 0;"><i class="fas fa-shield-alt text-success"></i> Enable 2FA for User</h3>
                            <button class="modal-close" id="closeAdmin2FASetup">&times;</button>
                        </div>
                        <div class="modal-body">
                            <p class="text-center mb-2" style="font-size:0.9rem; color:var(--text-muted);">Have the user scan this QR code with Google Authenticator, then enter the 6-digit code to confirm.</p>
                            <div class="text-center mb-3" id="admin2FAQRContainer" style="display:flex;justify-content:center;"></div>
                            <div class="form-group-floating" style="margin-bottom: 1.5rem;">
                                <input type="text" class="form-control" id="admin2FASecretDisplay" readonly placeholder=" ">
                                <label for="admin2FASecretDisplay">Secret Key (share with user)</label>
                            </div>
                            <div class="form-group-floating">
                                <input type="text" class="form-control" id="admin2FAVerifyCode" maxlength="6" placeholder=" " autocomplete="off">
                                <label for="admin2FAVerifyCode">Enter 6-digit verification code</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" id="cancelAdmin2FASetup">Cancel</button>
                            <button class="btn btn-success" id="confirmAdmin2FAEnable"><i class="fas fa-check"></i> Verify &amp; Enable</button>
                        </div>
                    </div>
                </div>

                <!-- Admin: Confirm Disable 2FA for User Modal -->
                <div class="modal" id="adminDisable2FAConfirmModal">
                    <div class="modal-dialog" style="max-width: 420px;">
                        <div class="modal-header">
                            <h3 class="modal-title" style="margin: 0;"><i class="fas fa-shield-virus text-danger"></i> Disable 2FA</h3>
                            <button class="modal-close" id="closeAdminDisable2FA">&times;</button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to <strong>disable 2FA</strong> for user <strong id="disable2FAUsername"></strong>? This will remove their authenticator secret.</p>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" id="cancelAdminDisable2FA">Cancel</button>
                            <button class="btn btn-danger" id="confirmAdminDisable2FA"><i class="fas fa-shield-virus"></i> Yes, Disable 2FA</button>
                        </div>
                    </div>
                </div>

                <!-- Confirm Unlink Gmail Modal (Admin My Profile) -->
                <div class="modal" id="confirmUnlinkGmailModal">
                    <div class="modal-dialog" style="max-width: 400px;">
                        <div class="modal-header">
                            <h3 class="modal-title" style="margin: 0;"><i class="fab fa-google text-danger"></i> Unlink Google Account</h3>
                            <button class="modal-close" id="closeUnlinkGmailModal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to <strong>unlink your Google account</strong>? You will no longer be able to sign in using Google OAuth.</p>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" id="cancelUnlinkGmail">Cancel</button>
                            <button class="btn btn-danger" id="confirmUnlinkGmail"><i class="fas fa-unlink"></i> Yes, Unlink</button>
                        </div>
                    </div>
                </div>
                </div> <!-- End Confirm Unlink Gmail Modal -->

        </div> <!-- End Page Content Wrapper -->
    </div> <!-- End Wrapper -->

    <!-- Footer -->
    <footer class="app-footer" style="margin-top: auto;">
        <p>Copyright 2026 CODERSTATION. All Rights Reserved</p>
    </footer>
</div> <!-- End App Wrapper -->

    <script src="/User-Management/assets/js/jquery-3.6.0.min.js"></script>
    <script src="/User-Management/assets/js/chart.js"></script>
    <script src="/User-Management/assets/js/chartjs-plugin-datalabels.js"></script>
    <script src="/User-Management/assets/js/kjua.min.js"></script>
    <script src="/User-Management/assets/js/footable.min.js"></script>
    <!-- Custom Scripts -->
    <script src="/User-Management/assets/js/main.js?v=1.20"></script>
    <script src="/User-Management/assets/js/admin.js?v=1.21"></script>
</body>

</html>