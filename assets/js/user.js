// User Dashboard JavaScript

let currentUser = null;
let twoFASecret = null;

// Load initial data
$(document).ready(function () {
    loadUserProfile();

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
        
        $('.list-group-item').removeClass('active');
        $(this).addClass('active');

        $('.content-section').removeClass('active');

        switch (tab) {
            case 'dashboard':
                $('#dashboard-overview').addClass('active');
                break;
            case 'myProfile':
                $('#myProfile').addClass('active');
                // Reset to Profile Info
                $('.modal-tab-content').hide();
                $('.sub-nav-tab').removeClass('active');
                $('[data-modal-tab="profileInfo"]').addClass('active');
                $('#profileInfo').show();
                break;
        }
    });

    // Sub-tab clicking logic
    $(document).on('click', '[data-modal-tab]', function () {
        const target = $(this).data('modal-tab');
        
        // Remove active from all siblings
        $(this).addClass('active').siblings().removeClass('active');

        // Hide all modal-tab-content elements globally first
        $('.modal-tab-content').hide();

        // Show the target
        $('#' + target).show();
        
        if (target === 'activityLogs') {
            loadUserLogs();
        }
    });

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

// Load User Profile
async function loadUserProfile() {
    const response = await Ajax.post('/User-Management/user/profile');

    if (response.success) {
        currentUser = response.user;
        populateProfileForm(response.user);
    } else {
        Toast.error('Failed to load profile');
    }
}

// Populate Profile Form
function populateProfileForm(user) {
    $('#username').val(user.username);
    $('#account_name').val(user.account_name);
    $('#email').val(user.email);
    $('#gmail_id').val(user.gmail_id || '');
    $('#user_level').val(user.user_level);
    $('#user_status').val(user.user_status);

    // Gmail Bind/Unlink Logic
    const gmailContainer = $('#gmail_bind_actions');
    gmailContainer.empty();
    if (user.gmail_id) {
        gmailContainer.append(`
            <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                <span class="badge" style="background:var(--success-color,#10b981);color:white;padding:5px 12px;border-radius:20px;font-size:0.8rem;"><i class="fab fa-google"></i> Linked</span>
                <button type="button" id="userUnlinkGmailBtn" class="btn btn-sm btn-danger"><i class="fas fa-unlink"></i> Unlink Google Account</button>
            </div>
        `);
    } else {
        gmailContainer.append(`<a href="/User-Management/oauth/google.php?action=link" class="btn btn-sm btn-outline-primary"><i class="fab fa-google"></i> Link Google Account</a>`);
    }



    // Update 2FA status
    $('#enable2fa_profile').prop('checked', user.twofa_enabled == 1);
}

// Save Profile
$('#profileForm').on('submit', async function (e) {
    e.preventDefault();

    const password = $('#password').val();
    const confirmPassword = $('#confirm_password').val();

    if (password && password !== confirmPassword) {
        Toast.error('Passwords do not match');
        return;
    }

    const data = {
        username: $('#username').val(),
        account_name: $('#account_name').val(),
        gmail_id: $('#gmail_id').val(),
        password: password,
        confirm_password: confirmPassword
    };

    const response = await Ajax.post('/User-Management/user/profile/update', data);

    if (response.success) {
        Toast.success(response.message);
        $('#password').val('');
        $('#confirm_password').val('');
        loadUserProfile();
    } else {
        Toast.error(response.message);
    }
});

// Toggle 2FA via Checkbox
$('#enable2fa_profile').on('change', function () {
    const isChecked = $(this).is(':checked');
    const wasEnabled = currentUser.twofa_enabled == 1;

    // Prevent immediate change until verified
    if (isChecked && !wasEnabled) {
        // Start Enable Process
        setup2FA();
    } else if (!isChecked && wasEnabled) {
        // Start Disable Process
        Modal.show('disable2FAModal');
    }
});

// Setup 2FA
async function setup2FA() {
    const response = await Ajax.post('/User-Management/2fa/generate', {});

    if (response.success) {
        twoFASecret = response.secret;
        $('#secretKey').val(response.secret);

        // Generate QR code using kjua
        const qrCode = kjua({
            text: response.qrCodeUrl,
            size: 200,
            render: 'image'
        });

        $('#qrCodeContainer').html('').append(qrCode);
        Modal.show('setup2FAModal');
    } else {
        Toast.error('Failed to generate 2FA secret');
        $('#enable2fa_profile').prop('checked', false); // Revert
    }
}

// Handle Modal Closing (Revert checkbox if not successful)
$('#setup2FAModal .modal-close, #setup2FAModal [data-dismiss="modal"]').on('click', function () {
    // If enabling failed/cancelled, revert checkbox
    if (currentUser.twofa_enabled == 0) {
        $('#enable2fa_profile').prop('checked', false);
    }
});

$('#disable2FAModal .modal-close, #disable2FAModal [data-dismiss="modal"]').on('click', function () {
    // If disabling failed/cancelled, revert checkbox
    if (currentUser.twofa_enabled == 1) {
        $('#enable2fa_profile').prop('checked', true);
    }
});

// Confirm Enable 2FA
$('#enable2FABtn').on('click', async function () {
    const code = $('#verifyCode').val();

    if (!code || code.length !== 6) {
        Toast.error('Please enter a valid 6-digit code');
        return;
    }

    const response = await Ajax.post('/User-Management/2fa/enable', {
        secret: twoFASecret,
        code: code
    });

    if (response.success) {
        Toast.success(response.message);
        Modal.hide('setup2FAModal');
        $('#verifyCode').val('');
        loadUserProfile(); // This will refresh currentUser state
    } else {
        Toast.error(response.message);
    }
});

// Disable 2FA
$('#confirm-disable2FABtn').on('click', async function () {
    const password = $('#disable2FAPassword').val();

    if (!password) {
        Toast.error('Please enter your password');
        return;
    }

    const response = await Ajax.post('/User-Management/2fa/disable', {
        password: password
    });

    if (response.success) {
        Toast.success(response.message);
        Modal.hide('disable2FAModal');
        $('#disable2FAPassword').val('');
        loadUserProfile();
    } else {
        Toast.error(response.message);
    }
});

// Load User Logs
async function loadUserLogs(startDate = null, endDate = null) {
    let url = '/User-Management/user/logs';
    const payload = {};

    if (startDate) payload.start_date = startDate;
    if (endDate) payload.end_date = endDate;

    const response = await Ajax.post(url, payload);

    if (response.success) {
        renderUserLogsTable(response.logs);
    }
}

// Render User Logs Table
// Render User Logs Table
function renderUserLogsTable(logs) {
    const table = $('#userLogsTable');
    const tbody = table.find('tbody');
    tbody.empty();

    if (logs.length === 0) {
        tbody.append('<tr><td colspan="4" class="text-center">No logs found</td></tr>');
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

    // Initialize Footable with pagination
    table.footable({
        paging: {
            enabled: true,
            size: 5,
            position: 'center'
        },
        filtering: {
            enabled: true
        }
    });
}

// Filter User Logs
$('#filterUserLogsBtn').on('click', function () {
    const startDate = $('#log_start_date').val();
    const endDate = $('#log_end_date').val();

    loadUserLogs(startDate, endDate);
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

// ---- Gmail Unlink (User Dashboard) ----
$(document).on('click', '#userUnlinkGmailBtn', function () {
    $('#userUnlinkGmailModal').addClass('show');
    $('body').addClass('modal-open');
});

$(document).on('click', '#cancelUserUnlinkGmail, #closeUserUnlinkGmail', function () {
    $('#userUnlinkGmailModal').removeClass('show');
    $('body').removeClass('modal-open');
});

$(document).on('click', '#confirmUserUnlinkGmail', async function () {
    const response = await Ajax.post('/User-Management/user/profile/unlink-gmail', {});
    if (response.success) {
        Toast.success(response.message);
        $('#userUnlinkGmailModal').removeClass('show');
        $('body').removeClass('modal-open');
        loadUserProfile(); // Refresh profile to reflect unlinked state
    } else {
        Toast.error(response.message || 'Failed to unlink Google account');
    }
});
