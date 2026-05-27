<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CODERSTATION</title>
    <link rel="icon" type="image/png" href="/User-Management/assets/icons/favicon.png">
    <link rel="stylesheet" href="/User-Management/assets/css/style.css?v=1.24">
    <link rel="stylesheet" href="/User-Management/assets/css/all.min.css">
</head>

<body class="auth-body">
    <div class="app-wrapper auth-wrapper">
        <!-- Header -->
        <header class="app-header">
            <div class="container auth-header-container">
                <div class="brand-name">
                    <img src="/User-Management/assets/icons/favicon.png" alt="CODERSTATION" class="brand-logo">
                    <div class="brand-text auth-brand-text">
                        <span>CODERSTATION</span>
                        <span class="brand-subtitle">Authentication Portal</span>
                    </div>
                </div>
                <div class="header-nav">
                    <a href="#" id="btnLoginLink" class="nav-btn-link">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                    <a href="#" id="btnRegisterLink" class="nav-btn-link">
                        <i class="fas fa-user-plus"></i> Register
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Landing Content -->
        <div class="auth-container auth-landing-container">
            <div class="welcome-card">
                <div class="welcome-logo-container">
                    <img src="/User-Management/assets/icons/favicon.png" alt="CODERSTATION" class="welcome-logo">
                </div>
                
                <h1 class="welcome-title">Secure Identity Management</h1>
                <p class="welcome-desc">
                    Welcome to the CODERSTATION administrative & user dashboard. Access your workspaces, manage authentication details, and verify active sessions.
                </p>
          
                <!-- Key features grid -->
                <div class="feature-grid">
                    <div class="feature-card">
                        <i class="fas fa-shield-alt feature-icon-shield"></i>
                        <span class="feature-title">2FA Security</span>
                        <span class="feature-detail">Google Authenticator support.</span>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-desktop feature-icon-desktop"></i>
                        <span class="feature-title">Active Sessions</span>
                        <span class="feature-detail">Real-time device logout.</span>
                    </div>
                    <div class="feature-card">
                        <i class="fab fa-google feature-icon-google"></i>
                        <span class="feature-title">Google OAuth</span>
                        <span class="feature-detail">One-click secure login.</span>
                    </div>
                </div>
          
                <button class="btn btn-primary welcome-btn" id="btnGetStarted">
                    <i class="fas fa-sign-in-alt"></i> Access Portal
                </button>
            </div>
        </div>

        <!-- Footer -->
        <footer class="app-footer auth-footer">
            <p>Copyright 2026 CODERSTATION. All Rights Reserved</p>
        </footer>
    </div>

    <!-- Login/Register Modal Dialog -->
    <div class="modal" id="loginModal">
        <div class="modal-dialog auth-modal-dialog">
            <div class="auth-card-modern auth-modal-card">
                <!-- Close Button -->
                <button type="button" class="modal-close auth-modal-close" id="closeLoginModal">&times;</button>
                
                <!-- Login form container -->
                <div id="loginFormContainer">
                    <p class="auth-subtitle auth-modal-subtitle">Secure Access Control Panel</p>
        
                    <!-- Login Form -->
                    <form id="loginForm">
                        <div class="form-group-floating">
                            <input type="text" class="form-control" id="username" name="username" placeholder=" " required autocomplete="username">
                            <label for="username">Username</label>
                        </div>
        
                        <div class="form-group-floating">
                            <input type="password" class="form-control" id="password" name="password" placeholder=" " required autocomplete="current-password">
                            <label for="password">Password</label>
                        </div>
        
                        <div class="form-group-floating" id="twofa-group" style="display: none;">
                            <input type="text" class="form-control" id="twofa_code" name="twofa_code" maxlength="6" placeholder=" " autocomplete="one-time-code">
                            <label for="twofa_code">2FA Code</label>
                            <small class="text-muted auth-2fa-hint">Enter the 6-digit code from your authenticator</small>
                            <div class="auth-2fa-spacer"></div>
                        </div>
        
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </button>
                    </form>
        
                    <div class="auth-divider-modern">
                        <span>Or continue with</span>
                    </div>
        
                    <!-- OAuth Buttons -->
                    <div class="oauth-buttons">
                        <a href="/User-Management/oauth/google.php" class="btn btn-google btn-block">
                            <img src="/User-Management/assets/icons/gmail.png" alt="Gmail" class="google-icon"> Sign in with Google
                        </a>
                    </div>

                    <div class="auth-switch-text">
                        Don't have an account? <a href="#" id="switchToRegister" class="auth-switch-link">Register here</a>
                    </div>
                </div>

                <!-- Register form container -->
                <div id="registerFormContainer" style="display: none;">
                    <p class="auth-subtitle auth-modal-subtitle">Create New Account</p>
        
                    <div style="text-align: center; margin: 1.5rem 0; color: var(--text-color); font-size: 0.95rem; line-height: 1.5;">
                        <p style="margin-bottom: 1.5rem;">To create a secure account, please register using Google Single Sign-on. All registrations must be reviewed and approved by an administrator before activation.</p>
                        
                        <a href="/User-Management/oauth/google.php" class="btn btn-google btn-block">
                            <img src="/User-Management/assets/icons/gmail.png" alt="Gmail" class="google-icon"> Register with Google
                        </a>
                    </div>
        
                    <div class="auth-switch-text">
                        Already have an account? <a href="#" id="switchToLogin" class="auth-switch-link">Login here</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/User-Management/assets/js/jquery-3.6.0.min.js"></script>
    <script src="/User-Management/assets/js/main.js?v=1.4"></script>
    <script src="/User-Management/assets/js/auth.js?v=1.0"></script>
</body>
</html>