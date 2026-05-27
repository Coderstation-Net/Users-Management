let require2FA = false;

$(document).ready(function () {
    // Modal Open Events - Login Mode
    $('#btnLoginLink, #btnGetStarted').on('click', function (e) {
        e.preventDefault();
        $('#registerFormContainer').hide();
        $('#loginFormContainer').show();
        $('#loginModal').addClass('show');
        $('body').addClass('modal-open');
        $('#username').focus();
    });

    // Modal Open Events - Register Mode
    $('#btnRegisterLink').on('click', function (e) {
        e.preventDefault();
        $('#loginFormContainer').hide();
        $('#registerFormContainer').show();
        $('#loginModal').addClass('show');
        $('body').addClass('modal-open');
    });

    // Switch to Register Form inside dialog
    $('#switchToRegister').on('click', function (e) {
        e.preventDefault();
        $('#loginFormContainer').hide();
        $('#registerFormContainer').fadeIn(300);
    });

    // Switch to Login Form inside dialog
    $('#switchToLogin').on('click', function (e) {
        e.preventDefault();
        $('#registerFormContainer').hide();
        $('#loginFormContainer').fadeIn(300);
        $('#username').focus();
    });

    // Modal Close Events
    $('#closeLoginModal').on('click', function () {
        $('#loginModal').removeClass('show');
        $('body').removeClass('modal-open');
    });

    // Close modal when clicking backdrop
    $('#loginModal').on('click', function (e) {
        if ($(e.target).is('#loginModal')) {
            $('#loginModal').removeClass('show');
            $('body').removeClass('modal-open');
        }
    });

    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');
    const registered = urlParams.get('registered');
    if (error) {
        if (error === 'account_not_found') {
            Toast.error('Your Google Account is not registered. Please contact the administrator.');
        } else if (error === 'oauth_failed') {
            Toast.error('Google Sign-In failed. Please try again.');
        } else if (error === 'registration_disabled') {
            Toast.error('Self-registration is disabled.');
        } else if (error === 'account_inactive') {
            Toast.info('Your account is currently inactive. Please wait for administrator approval.');
        } else if (error === 'account_suspended') {
            Toast.error('This account has been suspended. Please contact the administrator.');
        } else if (error === 'account_deleted') {
            Toast.error('This account has been deleted.');
        } else {
            Toast.error('An error occurred: ' + escapeHtml(error));
        }
        
        // Automatically open modal on error callback so user sees what failed
        $('#loginFormContainer').show();
        $('#registerFormContainer').hide();
        $('#loginModal').addClass('show');
        $('body').addClass('modal-open');

        // Clear URL parameters
        window.history.replaceState({}, document.title, window.location.pathname);
    } else if (registered === 'pending_approval') {
        Toast.success('Registration successful! Your account is currently inactive. Please wait for administrator approval.');
        
        // Automatically open modal so user sees confirmation or has context
        $('#loginFormContainer').show();
        $('#registerFormContainer').hide();
        $('#loginModal').addClass('show');
        $('body').addClass('modal-open');

        // Clear URL parameters
        window.history.replaceState({}, document.title, window.location.pathname);
    }
});

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

// Login Submit Handler
$('#loginForm').on('submit', async function (e) {
    e.preventDefault();

    const formData = {
        username: $('#username').val(),
        password: $('#password').val(),
        twofa_code: $('#twofa_code').val()
    };

    try {
        const response = await Ajax.post('/User-Management/login', formData);

        if (response.success) {
            Toast.success(response.message);

            if (response.sessions_deactivated > 0) {
                Toast.info(`You were logged out from ${response.sessions_deactivated} other device(s).`);
            }

            setTimeout(() => {
                window.location.href = '/User-Management' + response.redirect;
            }, 1500);
        } else {
            if (response.require_2fa && !require2FA) {
                require2FA = true;
                $('#twofa-group').show();
                Toast.info(response.message);
                $('#twofa_code').focus();
            } else {
                Toast.error(response.message);
            }
        }
    } catch (error) {
        Toast.error('An error occurred during login');
    }
});


