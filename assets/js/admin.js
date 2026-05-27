// Admin Dashboard JavaScript

let currentUsers = [];
let allUsers = [];

// Load initial data
$(document).ready(function () {
    loadStats();
    loadUsers();
    loadOnlineUsers();

    // Auto-refresh online users every 30 seconds
    setInterval(() => {
        if ($('#dashboard-overview').hasClass('active')) {
            loadOnlineUsers();
        }
    }, 30000);

    // Check for success or error query parameters to display notifications
    const urlParams = new URLSearchParams(window.location.search);
    const successParam = urlParams.get('success');
    const errorParam = urlParams.get('error');

    if (successParam) {
        if (successParam === 'gmail_linked') {
            Toast.success('Google account linked successfully!');
        } else {
            Toast.success(decodeURIComponent(successParam));
        }
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    if (errorParam) {
        if (errorParam === 'gmail_taken') {
            Toast.error('This Google account is already linked to another user.');
        } else {
            Toast.error(decodeURIComponent(errorParam));
        }
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

// Tab change event
// Track current tab
let currentAdminTab = 'dashboard';

// Sidebar Toggle
$('#menu-toggle').click(function (e) {
    e.preventDefault();
    $('#wrapper').toggleClass('toggled');
});

// Sidebar Navigation
$('.list-group-item[data-tab]').on('click', function (e) {
    e.preventDefault();
    const tab = $(this).data('tab');
    if (!tab) return;

    // Update current tab
    currentAdminTab = tab;

    // UI Updates
    $('.list-group-item').removeClass('active');
    $(this).addClass('active');

    // Hide all sections
    $('.content-section').removeClass('active');

    // Show target section and load data
    switch (tab) {
        case 'dashboard':
            $('#dashboard-overview').addClass('active');
            loadStats();
            loadOnlineUsers();
            break;
        case 'manageUsers':
            $('#manageUsers').addClass('active');
            loadUsers();
            break;
        case 'userLogs':
            $('#userLogs').addClass('active');
            loadUserLogs();
            break;
        case 'myProfile':
            // Logic handled inside showAdminProfile but we need to ensure container is shown
            $('#myProfile').addClass('active');
            showAdminProfile();
            break;
    }
});

// Stat Card Navigation / Scroll
$(document).on('click', '.stat-card[data-tab]', function (e) {
    e.preventDefault();
    const tab = $(this).data('tab');
    if (!tab) return;

    if (tab === 'onlineUsers') {
        const element = document.getElementById('online-users-card');
        if (element) {
            element.scrollIntoView({ behavior: 'smooth' });
        }
    } else if (tab === 'activeUsers' || tab === 'inactiveUsers' || tab === 'suspendedUsers' || tab === 'deletedUsers' || tab === 'allUsers') {
        let filterVal = 'All';
        if (tab === 'activeUsers') filterVal = 'Active';
        if (tab === 'inactiveUsers') filterVal = 'Inactive';
        if (tab === 'suspendedUsers') filterVal = 'Suspended';
        if (tab === 'deletedUsers') filterVal = 'Deleted';
        $('#filterAccount').val(filterVal);
        $(`.list-group-item[data-tab="manageUsers"]`).trigger('click');
    } else {
        $(`.list-group-item[data-tab="${tab}"]`).trigger('click');
    }
});

// Load statistics
// Load statistics
async function loadStats() {
    try {
        const [active, inactive, suspended, deleted, online] = await Promise.all([
            Ajax.post('/User-Management/admin/users/active'),
            Ajax.post('/User-Management/admin/users/inactive'),
            Ajax.post('/User-Management/admin/users/suspended'),
            Ajax.post('/User-Management/admin/users/deleted'),
            Ajax.post('/User-Management/admin/users/online')
        ]);

        const activeCount = active.users?.length || 0;
        const inactiveCount = inactive.users?.length || 0;
        const suspendedCount = suspended.users?.length || 0;
        const deletedCount = deleted.users?.length || 0;
        const onlineCount = online.users?.length || 0;

        $('#totalActiveUsers').text(activeCount);
        $('#totalInactiveUsers').text(inactiveCount);
        $('#totalOnlineUsers').text(onlineCount);
        $('#totalSuspendedUsers').text(suspendedCount);
        $('#totalDeletedUsers').text(deletedCount);
        $('#totalUsersCount').text(activeCount + inactiveCount + suspendedCount + deletedCount);

        // Render Chart
        renderUserChart(activeCount, inactiveCount, suspendedCount, deletedCount);

    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

// Global Chart Instance
let userStatusChartInstance = null;

function renderUserChart(active, inactive, suspended, deleted) {
    const ctx = document.getElementById('userStatusChart').getContext('2d');

    if (userStatusChartInstance) {
        userStatusChartInstance.destroy();
    }

    userStatusChartInstance = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: ['Active', 'Inactive', 'Suspended', 'Deleted'],
            datasets: [{
                data: [active, inactive, suspended, deleted],
                backgroundColor: [
                    '#10b981', // Success (Active)
                    '#f59e0b', // Warning (Inactive)
                    '#ef4444', // Danger (Suspended)
                    '#64748b'  // Muted (Deleted)
                ],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                datalabels: {
                    color: '#ffffff',
                    font: {
                        weight: 'bold',
                        size: 11,
                        family: "'Inter', sans-serif"
                    },
                    formatter: (value, context) => {
                        if (!value || value === 0) return null;
                        const label = context.chart.data.labels[context.dataIndex];
                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                        if (total === 0) return null;
                        const percentage = ((value / total) * 100).toFixed(0) + '%';
                        return `${label}\n${percentage}`;
                    },
                    textAlign: 'center',
                    align: 'center',
                    anchor: 'center',
                    textShadowColor: 'rgba(0, 0, 0, 0.5)',
                    textShadowBlur: 4
                }
            }
        },
        plugins: [ChartDataLabels]
    });

    // Populate the table
    const total = active + inactive + suspended + deleted;
    const tbody = document.querySelector('#distributionTable tbody');
    if (tbody) {
        tbody.innerHTML = `
            <tr>
                <td><span class="status-dot" style="background-color: #10b981;"></span> Active</td>
                <td class="text-right"><strong>${active}</strong></td>
                <td class="text-right text-muted">${total > 0 ? ((active / total) * 100).toFixed(1) : 0}%</td>
            </tr>
            <tr>
                <td><span class="status-dot" style="background-color: #f59e0b;"></span> Inactive</td>
                <td class="text-right"><strong>${inactive}</strong></td>
                <td class="text-right text-muted">${total > 0 ? ((inactive / total) * 100).toFixed(1) : 0}%</td>
            </tr>
            <tr>
                <td><span class="status-dot" style="background-color: #ef4444;"></span> Suspended</td>
                <td class="text-right"><strong>${suspended}</strong></td>
                <td class="text-right text-muted">${total > 0 ? ((suspended / total) * 100).toFixed(1) : 0}%</td>
            </tr>
            <tr>
                <td><span class="status-dot" style="background-color: #64748b;"></span> Deleted</td>
                <td class="text-right"><strong>${deleted}</strong></td>
                <td class="text-right text-muted">${total > 0 ? ((deleted / total) * 100).toFixed(1) : 0}%</td>
            </tr>
        `;
    }
}
// Load Users
async function loadUsers() {
    const response = await Ajax.post('/User-Management/admin/users');

    if (response.success) {
        allUsers = response.users;
        filterAndRenderUsers();
    }
}

// Filter and Render Users
function filterAndRenderUsers() {
    const filter = $('#filterAccount').val() || 'All';
    let filtered = allUsers;

    if (filter !== 'All') {
        filtered = allUsers.filter(u => u.user_status === filter);
    }

    currentUsers = allUsers; // Populate currentUsers so editUser works
    renderUsersTable(filtered, '#usersTable tbody');
}

// Change event for Filter Account
$(document).on('change', '#filterAccount', function () {
    filterAndRenderUsers();
});

// Add User Modal Toggle
$(document).on('click', '#btnShowAddUser', function () {
    $('#addUserModal').addClass('show');
    $('body').addClass('modal-open');
});

$(document).on('click', '#btnHideAddUser, #btnCancelAddUser', function () {
    $('#addUserModal').removeClass('show');
    $('body').removeClass('modal-open');
    $('#addUserForm')[0].reset();
});

// Load Online Users
async function loadOnlineUsers() {
    const response = await Ajax.post('/User-Management/admin/users/online');

    if (response.success) {
        renderOnlineUsersTable(response.users);
    }
}

// Load User Logs
async function loadUserLogs(startDate = null, endDate = null) {
    let url = '/User-Management/admin/logs';
    const payload = {};

    if (startDate) payload.start_date = startDate;
    if (endDate) payload.end_date = endDate;

    const response = await Ajax.post(url, payload);

    if (response.success) {
        renderLogsTable(response.logs);
    }
}

// 2FA State variables for Admin Profile
let adminTwoFASecret = null;
let isAdminTwoFAVerified = false;

// Make function available globally (keep just in case)
window.showAdminProfile = showAdminProfile;

// Click handler for My Profile button
$(document).on('click', '#btnMyProfile', function (e) {
    e.preventDefault(); // Prevent default anchor behavior if any
    showAdminProfile();
});

// Show Admin Profile Modal
// Show Admin Profile (Population Logic)
async function showAdminProfile() {
    console.log('Loading Admin Profile...');

    // Layout Update for Sidebar
    $('.content-section').removeClass('active'); // Hide other pages
    $('.list-group-item').removeClass('active'); // Clear Active Sidebar
    $('[data-tab="myProfile"]').addClass('active'); // Highlight My Profile

    // Show Profile Container
    $('#myProfile').addClass('active').show();

    // Reset Inner Tabs
    $('.modal-tab-content').hide();
    $('.sub-nav-tab').removeClass('active');

    // Show Profile Info Inner Tab
    $('[data-modal-tab="adminInfo"]').addClass('active');
    $('#adminInfo').show();

    // Fetch Profile Data (Session-based)
    const response = await Ajax.post('/User-Management/user/profile');

    if (response.success) {
        const admin = response.user;

        // Populate Edit Form
        $('#admin_profile_id').val(admin.user_id);
        $('#admin_username').val(admin.username);
        $('#admin_account_name').val(admin.account_name);
        $('#admin_email').val(admin.email);
        $('#admin_gmail_id').val(admin.gmail_id || '');

        // Gmail Bind/Unbind Button Logic
        if (admin.gmail_id) {
            $('#btnBindGmail').hide();
            $('#btnUnbindGmail').show();
        } else {
            $('#btnBindGmail').show();
            $('#btnUnbindGmail').hide();
        }

        $('#admin_password').val('');
        $('#admin_confirm_password').val('');

        // 2FA Checkbox State
        const is2FAEnabled = admin.twofa_enabled == 1;
        $('#admin_twofa_toggle').prop('checked', is2FAEnabled);
        adminTwoFASecret = admin.twofa_secret || null;
        isAdminTwoFAVerified = is2FAEnabled;

        // Show Form directly (reset inner tab to first one)
        $('[data-modal-tab="adminInfo"]').trigger('click');

        // Load admin logs (Session-based)
        try {
            // Load logs as well
            const logsResponse = await Ajax.post('/User-Management/user/logs');
            if (logsResponse.success) {
                renderAdminLogs(logsResponse.logs);
            }
        } catch (e) {
            console.error('Error loading logs:', e);
        }
    } else {
        console.error('Failed to load profile:', response.message);
        Toast.error('Could not load profile data: ' + (response.message || 'Unknown error'));
    }
}



// Gmail Bind Button (Admin Profile)
$(document).on('click', '#btnBindGmail', function () {
    window.location.href = '/User-Management/oauth/google.php?action=link';
});

// Gmail Unlink Button (Admin Profile) - shows confirm modal
$(document).on('click', '#btnUnbindGmail', function () {
    $('#confirmUnlinkGmailModal').addClass('show');
    $('body').addClass('modal-open');
});

// Cancel Unlink Gmail
$(document).on('click', '#cancelUnlinkGmail, #closeUnlinkGmailModal', function () {
    $('#confirmUnlinkGmailModal').removeClass('show');
    $('body').removeClass('modal-open');
});

// Confirm Unlink Gmail
$(document).on('click', '#confirmUnlinkGmail', async function () {
    const response = await Ajax.post('/User-Management/user/profile/unlink-gmail', {});
    if (response.success) {
        Toast.success(response.message);
        $('#confirmUnlinkGmailModal').removeClass('show');
        $('body').removeClass('modal-open');
        showAdminProfile(); // Reload profile to reflect change
    } else {
        Toast.error(response.message || 'Failed to unlink Google account');
    }
});



// Admin 2FA Toggle Logic
$(document).on('change', '#admin_twofa_toggle', async function () {
    if ($(this).is(':checked')) {
        // If enabling and not already verified/set up
        if (!isAdminTwoFAVerified || !adminTwoFASecret) {
            await showAdminTwoFAModal();
        }
    } else {
        // Disabling 2FA
        isAdminTwoFAVerified = false;
        // Keep the secret in variable in case they re-enable, but verification reset might be safer
        // For now, let's allow basic toggle off
    }
});

async function showAdminTwoFAModal() {
    const username = $('#admin_username').val();
    const response = await Ajax.post('/User-Management/2fa/generate', {
        username: username
    });

    if (response.success) {
        adminTwoFASecret = response.secret;
        $('#secretKey').val(response.secret);
        $('#verifyCode').val('');

        const qrCode = kjua({
            text: response.qrCodeUrl,
            size: 200,
            render: 'image'
        });

        $('#qrCodeContainer').html('').append(qrCode);

        // Show 2FA Modal
        $('#twoFAModal').addClass('show');
        $('body').addClass('modal-open');
    } else {
        Toast.error('Failed to generate 2FA secret');
        $('#admin_twofa_toggle').prop('checked', false);
    }
}

// Verify 2FA Button (in 2FA Modal)
$(document).on('click', '#verify2FABtn', async function () {
    const code = $('#verifyCode').val();

    if (!code || code.length !== 6) {
        Toast.error('Please enter a valid 6-digit code');
        return;
    }

    const response = await Ajax.post('/User-Management/2fa/verify', {
        secret: adminTwoFASecret,
        code: code
    });

    if (response.success) {
        Toast.success('2FA verified successfully');
        isAdminTwoFAVerified = true;

        // Close 2FA Modal
        $('#twoFAModal').removeClass('show');
        // If admin profile modal is open, don't remove body class, else do
        if (!$('#adminProfileModal').hasClass('show')) {
            $('body').removeClass('modal-open');
        }
    } else {
        Toast.error(response.message);
    }
});

// Close 2FA Modal
$(document).on('click', '[data-dismiss="twofa-modal"]', function () {
    $('#twoFAModal').removeClass('show');
    if (!$('#adminProfileModal').hasClass('show')) {
        $('body').removeClass('modal-open');
    }

    // If not verified, uncheck the toggle
    if (!isAdminTwoFAVerified) {
        $('#admin_twofa_toggle').prop('checked', false);
    }
});

// Modal tab clicking logic (works for both modal and profile page tabs)
// Modal tab clicking logic (works for both modal and profile page tabs)
$(document).on('click', '[data-modal-tab]', function () {
    const target = $(this).data('modal-tab');
    // Remove active from all siblings (handles both .nav-tab and .profile-nav-tab)
    $(this).addClass('active').siblings().removeClass('active');

    // Hide all modal-tab-content elements globally first (safest approach given the mix)
    $('.modal-tab-content').hide();

    // Show the target
    $('#' + target).show();
});

// Handle Admin Profile Form Submission
$(document).on('submit', '#adminProfileForm', async function (e) {
    e.preventDefault();

    const password = $('#admin_password').val();
    const confirmPassword = $('#admin_confirm_password').val();

    if (password && password !== confirmPassword) {
        Toast.error('Passwords do not match');
        return;
    }

    // Check if 2FA is enabled but not verified
    if ($('#admin_twofa_toggle').is(':checked') && !isAdminTwoFAVerified) {
        Toast.warning('Please verify 2FA setup first');
        await showAdminTwoFAModal();
        return;
    }

    const data = {
        user_id: $('#admin_profile_id').val(),
        username: $('#admin_username').val(),
        account_name: $('#admin_account_name').val(),
        email: $('#admin_email').val(),
        password: password,
        twofa_enabled: $('#admin_twofa_toggle').is(':checked') ? 1 : 0,
        twofa_secret: $('#admin_twofa_toggle').is(':checked') ? adminTwoFASecret : null
    };

    const response = await Ajax.post('/User-Management/admin/user/update', data);

    if (response.success) {
        Toast.success('Profile updated successfully');
        Modal.hide('adminProfileModal');
        // Refresh page to update header name if changed
        setTimeout(() => location.reload(), 1500);
    } else {
        Toast.error(response.message);
    }
});

// Render Admin Logs within Modal
function renderAdminLogs(logs) {
    const table = $('#adminLogsTable');
    const tbody = table.find('tbody');
    tbody.empty();

    if (logs.length === 0) {
        tbody.append('<tr><td colspan="4" class="text-center">No activity found</td></tr>');
        return;
    }

    logs.forEach(log => {
        const row = `
            <tr>
                <td>${formatDateTime(log.created_at)}</td>
                <td><span class="badge badge-info">${escapeHtml(log.action)}</span></td>
                <td>${escapeHtml(log.description || '')}</td>
                <td>${escapeHtml(log.ip_address || '')}</td>
            </tr>
        `;
        tbody.append(row);
    });

    // Check if footable is already initialized and destroy it first
    if (table.hasClass('footable-loaded')) {
        table.data('footable-sort', null); // Clear previous sort data
        table.removeClass('footable-loaded');
    }

    table.footable({
        paging: { enabled: true, size: 5, position: 'center' },
        filtering: { enabled: true },
        sorting: { enabled: true }
    });
}

// Render Users Table
function renderUsersTable(users, tableSelector) {
    const table = $(tableSelector).closest('table');
    const tbody = $(tableSelector);
    tbody.empty();

    if (users.length === 0) {
        tbody.append('<tr><td colspan="7" class="text-center">No users found</td></tr>');
        return;
    }

    const loggedInUserId = $('body').data('user-id');

    users.forEach(user => {
        let actionButtons = '';
        if (user.user_status === 'Deleted') {
            actionButtons = `
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-success btn-icon" title="Restore User" onclick="restoreUser(${user.user_id}, '${escapeHtml(user.username)}')">
                        <i class="fas fa-undo"></i>
                    </button>
                    ${user.user_id != loggedInUserId ? `
                    <button class="btn btn-sm btn-danger btn-icon" title="Purge User" onclick="permanentlyDeleteUser(${user.user_id}, '${escapeHtml(user.username)}')">
                        <i class="fas fa-times-circle"></i>
                    </button>
                    ` : ''}
                </div>
            `;
        } else {
            actionButtons = `
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-primary btn-icon" title="Edit User" onclick="editUser(${user.user_id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    ${user.user_id != loggedInUserId ? `
                    <button class="btn btn-sm btn-danger btn-icon" title="Delete User" onclick="deleteUser(${user.user_id}, '${escapeHtml(user.username)}')">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                    ` : ''}
                </div>
            `;
        }

        let statusBadge = '';
        if (user.user_status === 'Active') {
            statusBadge = `<span class="badge badge-success">Active</span>`;
        } else if (user.user_status === 'Inactive') {
            statusBadge = `<span class="badge badge-warning">Inactive</span>`;
        } else if (user.user_status === 'Suspended') {
            statusBadge = `<span class="badge badge-danger">Suspended</span>`;
        } else if (user.user_status === 'Deleted') {
            statusBadge = `<span class="badge badge-secondary">Deleted</span>`;
        }

        const row = `
            <tr>
                <td>${escapeHtml(user.username)}</td>
                <td>${escapeHtml(user.account_name)}</td>
                <td>${escapeHtml(user.email)}</td>
                <td><span class="badge badge-info">${escapeHtml(user.user_level)}</span></td>
                <td>${statusBadge}</td>
                <td>${formatDateTime(user.user_status === 'Deleted' ? user.updated_at : user.created_at)}</td>
                <td class="action-cell no-print">${actionButtons}</td>
            </tr>
        `;
        tbody.append(row);
    });

    // Check if footable is already initialized and destroy it first
    if (table.hasClass('footable-loaded')) {
        table.data('footable-sort', null);
        table.removeClass('footable-loaded');
    }

    // Initialize Footable with pagination
    table.footable({
        paging: {
            enabled: true,
            size: 5,
            position: 'center'
        },
        filtering: {
            enabled: true
        },
        sorting: {
            enabled: true
        }
    });
}

// Submit Add User Form
$(document).on('submit', '#addUserForm', async function (e) {
    e.preventDefault();

    const password = $('#add_password').val();
    const confirmPassword = $('#add_confirm_password').val();

    if (password && password !== confirmPassword) {
        Toast.error('Passwords do not match');
        return;
    }

    const data = {
        username: $('#add_username').val(),
        account_name: $('#add_account_name').val(),
        email: $('#add_email').val(),
        user_level: $('#add_user_level').val(),
        user_status: $('#add_user_status').val(),
        password: password
    };

    const response = await Ajax.post('/User-Management/admin/user/add', data);

    if (response.success) {
        Toast.success(response.message);
        $('#addUserForm')[0].reset();
        $('#addUserModal').removeClass('show');
        $('body').removeClass('modal-open');
        loadUsers();
        loadStats();
    } else {
        Toast.error(response.message);
    }
});

// Delete User (Soft Delete)
async function deleteUser(userId, username) {
    if (!confirm(`Are you sure you want to delete user "${username}"? They will be marked as Deleted and logged out.`)) {
        return;
    }

    const response = await Ajax.post('/User-Management/admin/user/delete', { user_id: userId });

    if (response.success) {
        Toast.success(response.message);
        loadUsers();
        loadStats();
    } else {
        Toast.error(response.message);
    }
}

// Restore User
async function restoreUser(userId, username) {
    if (!confirm(`Are you sure you want to restore user "${username}"?`)) {
        return;
    }

    const response = await Ajax.post('/User-Management/admin/user/update', {
        user_id: userId,
        user_status: 'Active'
    });

    if (response.success) {
        Toast.success('User restored successfully');
        loadUsers();
        loadStats();
    } else {
        Toast.error(response.message);
    }
}

// Permanently Delete User (Hard Delete)
async function permanentlyDeleteUser(userId, username) {
    if (!confirm(`WARNING: Are you sure you want to PERMANENTLY delete user "${username}"? This action cannot be undone and will delete all their sessions and logs.`)) {
        return;
    }

    const response = await Ajax.post('/User-Management/admin/user/delete-permanent', { user_id: userId });

    if (response.success) {
        Toast.success(response.message);
        loadUsers();
        loadStats();
    } else {
        Toast.error(response.message);
    }
}

// Expose functions globally for inline HTML click handlers
window.deleteUser = deleteUser;
window.restoreUser = restoreUser;
window.permanentlyDeleteUser = permanentlyDeleteUser;

// Render Online Users Table
function renderOnlineUsersTable(users) {
    const table = $('#onlineUsersTable');
    const tbody = table.find('tbody');
    tbody.empty();

    if (users.length === 0) {
        tbody.append('<tr><td colspan="8" class="text-center">No users currently online</td></tr>');
        return;
    }

    users.forEach(user => {
        const row = `
            <tr>
                <td>${escapeHtml(user.username)}</td>
                <td>${escapeHtml(user.account_name)}</td>
                <td><span class="badge badge-info">${escapeHtml(user.user_level)}</span></td>
                <td>${formatDateTime(user.login_time)}</td>
                <td>${formatDateTime(user.last_activity)}</td>
                <td>${escapeHtml(user.ip_address)}</td>
                <td>${escapeHtml(user.device_info)}</td>
                <td class="no-print">
                    <button class="btn btn-sm btn-danger btn-icon" title="Kick User" onclick="kickUser(${user.user_id}, '${escapeHtml(user.username)}')">
                        <i class="fas fa-sign-out-alt"></i>
                    </button>
                </td>
            </tr>
        `;
        tbody.append(row);
    });

    // Initialize Footable with pagination
    table.footable({
        paging: {
            enabled: true,
            size: 5,
            position: 'center'
        },
        filtering: {
            enabled: true
        },
        sorting: {
            enabled: true
        }
    });
}

// Render Logs Table
function renderLogsTable(logs) {
    const table = $('#logsTable');
    const tbody = table.find('tbody');
    tbody.empty();

    if (logs.length === 0) {
        tbody.append('<tr><td colspan="5" class="text-center">No logs found</td></tr>');
        return;
    }

    logs.forEach(log => {
        const row = `
            <tr>
                <td>${formatDateTime(log.created_at)}</td>
                <td>${escapeHtml(log.username || 'N/A')}</td>
                <td><span class="badge badge-info">${escapeHtml(log.action)}</span></td>
                <td>${escapeHtml(log.description || '')}</td>
                <td>${escapeHtml(log.ip_address || '')}</td>
            </tr>
        `;
        tbody.append(row);
    });

    // Initialize Footable with pagination
    table.footable({
        paging: {
            enabled: true,
            size: 5,
            position: 'center'
        },
        filtering: {
            enabled: true
        },
        sorting: {
            enabled: true
        }
    });
}

// Edit User
function editUser(userId) {
    const user = currentUsers.find(u => u.user_id == userId);

    if (!user) {
        Toast.error('User not found');
        return;
    }

    // Populate Form
    $('#edit_user_id').val(user.user_id);
    $('#edit_username').val(user.username);
    $('#edit_account_name').val(user.account_name);
    $('#edit_email').val(user.email);
    $('#edit_gmail_id').val(user.gmail_id || '');
    $('#edit_user_level').val(user.user_level);
    $('#edit_user_status').val(user.user_status);
    $('#edit_failed_attempts').text(user.failed_login_attempts || 0);
    $('#reset_failed_attempts').prop('checked', false);

    if (user.account_locked_until) {
        $('#edit_locked_until').text(formatDateTime(user.account_locked_until));
        $('#locked_until_wrapper').show();
    } else {
        $('#edit_locked_until').text('N/A');
        $('#locked_until_wrapper').hide();
    }

    // Prevent admin from changing their own level or status
    const loggedInUserId = $('body').data('user-id');
    if (user.user_id == loggedInUserId) {
        $('#edit_user_level').prop('disabled', true);
        $('#edit_user_status').prop('disabled', true);
    } else {
        $('#edit_user_level').prop('disabled', false);
        $('#edit_user_status').prop('disabled', false);
    }

    // --- 2FA Status Badge & Action Buttons for Admin (No QR/Secret changes — preserves secret) ---
    updateAdminEditUser2FADisplay(user.twofa_enabled);

    // Reset password fields
    $('#edit_password').val('');
    $('#edit_confirm_password').val('');

    // Show Edit Modal
    $('#editUserModal').addClass('show');
    $('body').addClass('modal-open');
}

// Cancel Edit User
$(document).on('click', '#btnHideEditUser, #btnCancelEditUser', function () {
    $('#editUserModal').removeClass('show');
    $('body').removeClass('modal-open');
    $('#editUserForm')[0].reset();
});

// Save User
$('#saveUserBtn').on('click', async function (e) {
    e.preventDefault();
    const password = $('#edit_password').val();
    const confirmPassword = $('#edit_confirm_password').val();

    if (password && password !== confirmPassword) {
        Toast.error('Passwords do not match');
        return;
    }

    const data = {
        user_id: $('#edit_user_id').val(),
        username: $('#edit_username').val(),
        account_name: $('#edit_account_name').val(),
        email: $('#edit_email').val(),
        gmail_id: $('#edit_gmail_id').val(),
        user_level: $('#edit_user_level').val(),
        user_status: $('#edit_user_status').val(),
        reset_failed_attempts: $('#reset_failed_attempts').is(':checked') ? 1 : 0,
        password: password
    };

    const response = await Ajax.post('/User-Management/admin/user/update', data);

    if (response.success) {
        Toast.success(response.message);
        $('#editUserModal').removeClass('show');
        $('body').removeClass('modal-open');
        $('#editUserForm')[0].reset();
        loadUsers();
        loadStats();
    } else {
        Toast.error(response.message);
    }
});


// Kick User
async function kickUser(userId, username) {
    if (!confirm(`Are you sure you want to kick user "${username}"? They will be logged out immediately.`)) {
        return;
    }

    const response = await Ajax.post('/User-Management/admin/user/kick', { user_id: userId });

    if (response.success) {
        Toast.success(response.message);
        loadOnlineUsers();
        loadStats();
    } else {
        Toast.error(response.message);
    }
}

// Filter Logs
$('#filterLogsBtn').on('click', function () {
    const startDate = $('#startDate').val();
    const endDate = $('#endDate').val();

    loadUserLogs(startDate, endDate);
});

// Print Logs
$('#printLogsBtn').on('click', function () {
    PrintHelper.print('logsTableContainer');
});

// Print Users List
$(document).on('click', '#btnPrintUsersBtn', function () {
    PrintHelper.print('usersTableContainer');
});

// Utility Functions
function formatDateTime(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
}

function escapeHtml(text) {
    if (!text) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.toString().replace(/[&<>"']/g, m => map[m]);
}

// Admin 2FA Helper & Handlers (No QR/Secret changes — preserves secret)
function updateAdminEditUser2FADisplay(twofaEnabled) {
    const badge = $('#admin2faBadge');
    if (twofaEnabled == 1) {
        badge.text('Enabled').css({ background: 'var(--success-color, #10b981)', color: 'white' });
        $('#btnAdminEnable2FA').hide();
        $('#btnAdminDisable2FA').show();
    } else {
        badge.text('Disabled').css({ background: 'var(--danger-color, #ef4444)', color: 'white' });
        $('#btnAdminEnable2FA').show();
        $('#btnAdminDisable2FA').hide();
    }
}

// Enable 2FA for User by Admin (Preserving existing secret)
$(document).on('click', '#btnAdminEnable2FA', async function () {
    const userId = $('#edit_user_id').val();
    const username = $('#edit_username').val();
    if (!confirm(`Are you sure you want to enable 2FA for user "${username}"?`)) {
        return;
    }
    
    const response = await Ajax.post('/User-Management/admin/user/toggle-2fa', {
        user_id: userId,
        action: 'enable'
    });
    
    if (response.success) {
        Toast.success(response.message);
        updateAdminEditUser2FADisplay(1);
        loadUsers();
    } else {
        Toast.error(response.message);
    }
});

// Disable 2FA for User by Admin (Preserving existing secret)
$(document).on('click', '#btnAdminDisable2FA', async function () {
    const userId = $('#edit_user_id').val();
    const username = $('#edit_username').val();
    if (!confirm(`Are you sure you want to disable 2FA for user "${username}"?`)) {
        return;
    }
    
    const response = await Ajax.post('/User-Management/admin/user/toggle-2fa', {
        user_id: userId,
        action: 'disable'
    });
    
    if (response.success) {
        Toast.success(response.message);
        updateAdminEditUser2FADisplay(0);
        loadUsers();
    } else {
        Toast.error(response.message);
    }
});
