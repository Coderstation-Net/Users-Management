// Toast Notification System
const Toast = {
    container: null,

    init() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        }
    },

    show(message, type = 'info', duration = 5000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;

        const icons = {
            success: '<i class="fas fa-check-circle"></i>',
            error: '<i class="fas fa-exclamation-circle"></i>',
            warning: '<i class="fas fa-exclamation-triangle"></i>',
            info: '<i class="fas fa-info-circle"></i>',
            notification: '<i class="fas fa-bell"></i>'
        };

        toast.innerHTML = `
            <div class="toast-icon">${icons[type] || icons.info}</div>
            <div class="toast-message">${message}</div>
            <button class="toast-close">&times;</button>
        `;

        if (duration > 0) {
            toast.style.setProperty('--toast-duration', `${duration}ms`);
            toast.style.animation = `slideInToast 0.4s cubic-bezier(0.16, 1, 0.3, 1)`;
            
            // Add style for the pseudo-element progress bar via a dynamic class or we can just update the CSS to use a CSS variable
        }

        this.container.appendChild(toast);

        // Close button
        toast.querySelector('.toast-close').addEventListener('click', () => {
            this.remove(toast);
        });

        // Auto remove
        if (duration > 0) {
            setTimeout(() => {
                this.remove(toast);
            }, duration);
        }
    },

    remove(toast) {
        toast.style.animation = 'slideInToast 0.4s cubic-bezier(0.16, 1, 0.3, 1) reverse';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 350);
    },

    success(message, duration = 5000) {
        this.show(message, 'success', duration);
    },

    error(message, duration = 5000) {
        this.show(message, 'error', duration);
    },

    warning(message, duration = 5000) {
        this.show(message, 'warning', duration);
    },

    info(message, duration = 5000) {
        this.show(message, 'info', duration);
    },

    notification(message, duration = 5000) {
        this.show(message, 'notification', duration);
    }
};

// Modal System
const Modal = {
    show(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('show');
            document.body.classList.add('modal-open');
        }
    },

    hide(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('show');
            document.body.classList.remove('modal-open');
        }
    },

    init() {
        // Close modal when clicking outside
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                e.target.classList.remove('show');
                document.body.classList.remove('modal-open');
            }
        });

        // Close modal buttons
        document.querySelectorAll('.modal-close, [data-dismiss="modal"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const modal = e.target.closest('.modal');
                if (modal) {
                    modal.classList.remove('show');
                    document.body.classList.remove('modal-open');
                }
            });
        });
    }
};

// Session Checker
const SessionChecker = {
    interval: null,
    checkInterval: 30000, // Check every 30 seconds

    start() {
        this.check(); // Initial check
        this.interval = setInterval(() => {
            this.check();
        }, this.checkInterval);
    },

    stop() {
        if (this.interval) {
            clearInterval(this.interval);
            this.interval = null;
        }
    },

    async check() {
        try {
            const response = await fetch('/User-Management/session/check', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            const data = await response.json();

            if (!data.valid) {
                this.stop();

                if (data.kicked) {
                    Toast.error(data.message || 'Your session has been terminated.', 0);
                    setTimeout(() => {
                        window.location.href = '/User-Management/login';
                    }, 3000);
                } else {
                    window.location.href = '/User-Management/login';
                }
            }
        } catch (error) {
            console.error('Session check failed:', error);
        }
    }
};

// Tab System
const Tabs = {
    init() {
        document.querySelectorAll('.nav-tab').forEach(tab => {
            tab.addEventListener('click', (e) => {
                const targetId = e.target.dataset.tab;

                // If it's a sub-tab (doesn't have data-tab attribute), ignore it in this handler
                if (!targetId) return;

                // Remove active class from all tabs
                document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

                // Add active class to clicked tab
                e.target.classList.add('active');
                document.getElementById(targetId)?.classList.add('active');
            });
        });
    }
};

// Form Validation Helper
const FormValidator = {
    validate(formId) {
        const form = document.getElementById(formId);
        if (!form) return false;

        let isValid = true;
        const inputs = form.querySelectorAll('[required]');

        inputs.forEach(input => {
            if (!input.value.trim()) {
                isValid = false;
                input.style.borderColor = 'var(--danger)';
            } else {
                input.style.borderColor = 'var(--gray-300)';
            }
        });

        return isValid;
    },

    clearErrors(formId) {
        const form = document.getElementById(formId);
        if (!form) return;

        form.querySelectorAll('input, select, textarea').forEach(input => {
            input.style.borderColor = 'var(--gray-300)';
        });
    }
};

// AJAX Helper
const Ajax = {
    async post(url, data) {
        try {
            const formData = new FormData();
            for (const key in data) {
                formData.append(key, data[key]);
            }

            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData
            });

            return await response.json();
        } catch (error) {
            console.error('AJAX Error:', error);
            return { success: false, message: 'Network error occurred' };
        }
    },

    async get(url) {
        try {
            const response = await fetch(url, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            return await response.json();
        } catch (error) {
            console.error('AJAX Error:', error);
            return { success: false, message: 'Network error occurred' };
        }
    }
};

// Utility Functions
const Utils = {
    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
    },

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    copyToClipboard(text) {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(text).then(() => {
                Toast.success('Copied to clipboard!');
            });
        } else {
            // Fallback
            const textarea = document.createElement('textarea');
            textarea.value = text;
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            document.body.removeChild(textarea);
            Toast.success('Copied to clipboard!');
        }
    }
};

// Print Helper
const PrintHelper = {
    print(elementId) {
        const element = document.getElementById(elementId);
        if (!element) return;

        const printWindow = window.open('', '', 'height=600,width=800');
        printWindow.document.write('<html><head><title>Print</title>');
        printWindow.document.write('<link rel="stylesheet" href="/User-Management/assets/css/style.css?v=' + new Date().getTime() + '">');
        printWindow.document.write('</head><body>');
        printWindow.document.write(element.innerHTML);
        printWindow.document.write('</body></html>');
        printWindow.document.close();

        setTimeout(() => {
            printWindow.print();
            printWindow.close();
        }, 250);
    }
};

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    Modal.init();
    Tabs.init();

    // Start session checker if user is logged in
    if (document.body.dataset.loggedIn === 'true') {
        SessionChecker.start();
    }
});
