<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UiTM FYP Management System - Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #4b2e83;
            --secondary: #6d4ac0;
            --accent: #b399d4;
            --light: #f9f7fd;
            --dark: #1a0d3f;
            --error: #dc2626;
            --success: #10b981;
            --warning: #f59e0b;
            --transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            --mobile-breakpoint: 768px;
            --tablet-breakpoint: 992px;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #333;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .login-container {
            display: flex;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            min-height: 700px;
        }

        .login-left {
            flex: 1;
            background: linear-gradient(rgba(75, 46, 131, 0.8), rgba(75, 46, 131, 0.9)), url('https://images.unsplash.com/photo-1498243691581-b145c3f54a5a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80') center/cover no-repeat;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 50px;
            color: white;
        }

        .login-left h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .login-left p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            max-width: 500px;
        }

        .login-left ul {
            list-style: none;
            margin-top: 30px;
        }

        .login-left ul li {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 1.1rem;
        }

        .login-left ul li i {
            color: var(--accent);
            font-size: 1.5rem;
        }

        .login-right {
            flex: 1;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 40px;
            justify-content: center;
        }

        .logo-img {
            height: 70px;
            width: 70px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
        }

        .logo-img img {
            height: 50px;
        }

        .logo-text {
            font-weight: 700;
            font-size: 1.8rem;
            color: var(--primary);
        }

        .logo-text span {
            color: var(--secondary);
        }

        .tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
        }

        .tab {
            padding: 15px 30px;
            cursor: pointer;
            font-size: 1.2rem;
            font-weight: 500;
            color: #777;
            transition: var(--transition);
            position: relative;
        }

        .tab.active {
            color: var(--primary);
        }

        .tab.active:after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--primary);
            border-radius: 10px 10px 0 0;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        .error-message {
            background: #fef2f2;
            color: var(--error);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #fecaca;
        }

        .error-message i {
            font-size: 1.2rem;
        }

        .success-message {
            background: #ecfdf5;
            color: var(--success);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #a7f3d0;
        }

        .success-message i {
            font-size: 1.2rem;
        }

        .warning-message {
            background: #fffbeb;
            color: var(--warning);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #fde68a;
        }

        .warning-message i {
            font-size: 1.2rem;
        }

        .user-type {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }

        .user-option {
            flex: 1;
            min-width: 120px;
            text-align: center;
            padding: 15px;
            border: 2px solid #eee;
            border-radius: 10px;
            cursor: pointer;
            transition: var(--transition);
        }

        .user-option:hover {
            border-color: var(--accent);
            background: rgba(179, 153, 212, 0.1);
        }

        .user-option.active {
            border-color: var(--primary);
            background: rgba(75, 46, 131, 0.1);
        }

        .user-option i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .user-option.active i {
            color: var(--secondary);
        }

        .user-option span {
            font-weight: 500;
            display: block;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 1.1rem;
            transition: var(--transition);
            background: #f9f9f9;
        }

        .form-control:focus {
            border-color: var(--accent);
            background: white;
            box-shadow: 0 5px 15px rgba(179, 153, 212, 0.2);
            outline: none;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 42px;
            cursor: pointer;
            color: #777;
            transition: var(--transition);
        }

        .password-toggle:hover {
            color: var(--primary);
        }

        .btn {
            display: block;
            width: 100%;
            padding: 18px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 5px 15px rgba(75, 46, 131, 0.3);
        }

        .btn:hover {
            background: var(--secondary);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(75, 46, 131, 0.4);
        }

        .btn:disabled {
            background: #e4e7ec;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-accent {
            background: var(--accent);
            color: var(--dark);
            box-shadow: 0 5px 15px rgba(179, 153, 212, 0.4);
        }

        .btn-accent:hover {
            background: #9c7fc9;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(179, 153, 212, 0.6);
        }

        .forgot-password {
            text-align: right;
            margin: 15px 0 25px;
        }

        .forgot-password a {
            color: var(--secondary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .forgot-password a:hover {
            color: var(--primary);
            text-decoration: underline;
        }

        .social-login {
            text-align: center;
            margin: 30px 0;
            position: relative;
        }

        .social-login:before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 1px;
            background: #eee;
            z-index: 1;
        }

        .social-login span {
            position: relative;
            background: white;
            padding: 0 15px;
            z-index: 2;
            color: #777;
        }

        .social-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-btn {
            flex: 1;
            padding: 12px;
            border: 2px solid #eee;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .social-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .social-btn.google {
            color: #DB4437;
            border-color: #f1c0c0;
        }

        .social-btn.google:hover {
            background: rgba(219, 68, 55, 0.05);
        }

        .social-btn.microsoft {
            color: #0078D7;
            border-color: #c0d8f1;
        }

        .social-btn.microsoft:hover {
            background: rgba(0, 120, 215, 0.05);
        }

        .footer-text {
            text-align: center;
            margin-top: 30px;
            color: #777;
        }

        .footer-text a {
            color: var(--secondary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .footer-text a:hover {
            color: var(--primary);
            text-decoration: underline;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .login-left {
                display: none;
            }
            
            .login-right {
                padding: 40px;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            
            .login-container {
                min-height: auto;
                border-radius: 15px;
            }
            
            .logo {
                margin-bottom: 30px;
            }
            
            .tabs {
                flex-direction: column;
                border-bottom: none;
            }
            
            .tab {
                border-bottom: 2px solid #eee;
                padding: 12px 20px;
                text-align: center;
            }
            
            .user-option {
                min-width: 100px;
                padding: 12px 8px;
            }
            
            .user-option i {
                font-size: 1.8rem;
            }
            
            .form-control {
                padding: 14px 16px;
                font-size: 1rem;
            }
            
            .btn {
                padding: 16px;
                font-size: 1.1rem;
            }
            
            .social-buttons {
                flex-direction: column;
            }
            
            .login-right {
                padding: 30px;
            }
        }
        
        @media (max-width: 576px) {
            body {
                padding: 10px;
            }
            
            .login-container {
                border-radius: 12px;
            }
            
            .logo {
                flex-direction: column;
                gap: 10px;
                margin-bottom: 25px;
            }
            
            .logo-text {
                font-size: 1.5rem;
            }
            
            .tab {
                font-size: 1.1rem;
                padding: 10px 15px;
            }
            
            .user-option {
                min-width: 80px;
                padding: 10px 5px;
            }
            
            .user-option i {
                font-size: 1.5rem;
            }
            
            .user-option span {
                font-size: 0.9rem;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .login-right {
                padding: 20px;
            }
        }
        
        @media (max-width: 400px) {
            .user-option {
                min-width: 70px;
                padding: 8px 3px;
            }
            
            .user-option i {
                font-size: 1.3rem;
            }
            
            .user-option span {
                font-size: 0.8rem;
            }
            
            .form-control {
                padding: 12px 14px;
            }
            
            .btn {
                padding: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="login-left">
                <h1>UiTM FYP Management System</h1>
                <p>Streamline your final year project journey with our comprehensive platform</p>
                <ul>
                    <li><i class="fas fa-check-circle"></i> Seamless project management</li>
                    <li><i class="fas fa-check-circle"></i> Real-time supervisor communication</li>
                    <li><i class="fas fa-check-circle"></i> Document repository</li>
                    <li><i class="fas fa-check-circle"></i> Progress tracking</li>
                    <li><i class="fas fa-check-circle"></i> Evaluation system</li>
                </ul>
            </div>
            
            <div class="login-right">
                <div class="logo">
                    <div class="logo-img">
                        <img src="images/uitmLogo.png" alt="UiTM Logo">
                    </div>
                    <div class="logo-text">UiTM <span>FYP</span></div>
                </div>
                
                <div class="tabs">
                    <div class="tab active" data-tab="login">Login</div>
                    <div class="tab" data-tab="register">Register</div>
                </div>
                
                <!-- Login Form -->
                <div class="tab-content active" id="login-content">
                    <% if (request.getParameter("error") != null) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Invalid ID or Password. Please try again.</span>
                    </div>
                    <% } %>
                    
                    <% if (request.getParameter("logout") != null) { %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <span>You have been successfully logged out.</span>
                    </div>
                    <% } %>
                    
                    <% if (request.getParameter("registered") != null) { %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <span>Registration successful! Please log in.</span>
                    </div>
                    <% } %>

                    <form id="loginForm" action="/FYPManagement/LoginServlet" method="post" onsubmit="return validateLoginForm()">
                        <div class="user-type">
                            <label class="user-option active" data-type="student">
                                <input type="radio" name="role" value="student" checked hidden>
                                <i class="fas fa-user-graduate"></i>
                                <span>Student</span>
                            </label>
                            <label class="user-option" data-type="supervisor">
                                <input type="radio" name="role" value="supervisor" hidden>
                                <i class="fas fa-user-tie"></i>
                                <span>Supervisor</span>
                            </label>
                            <label class="user-option" data-type="lecturer">
                                <input type="radio" name="role" value="lecturer" hidden>
                                <i class="fas fa-chalkboard-teacher"></i>
                                <span>Lecturer</span>
                            </label>
                            <label class="user-option" data-type="admin">
                                <input type="radio" name="role" value="admin" hidden>
                                <i class="fas fa-user-shield"></i>
                                <span>Admin</span>
                            </label>
                            <label class="user-option" data-type="examiner">
                                <input type="radio" name="role" value="examiner" hidden>
                                <i class="fas fa-clipboard-check"></i>
                                <span>Examiner</span>
                            </label>
                        </div>

                        <div class="form-group">
                            <label for="login-id">
                                <span id="id-label">Student ID</span>
                            </label>
                            <input type="text" name="id" id="login-id" class="form-control" placeholder="Enter Student ID" required>
                        </div>

                        <div class="form-group">
                            <label for="login-password">Password</label>
                            <input type="password" name="password" id="login-password" class="form-control" placeholder="••••••••" required>
                            <i class="fas fa-eye password-toggle" id="toggleLoginPassword"></i>
                        </div>

                        <div class="forgot-password">
                            <a href="#" id="forgot-password-link">Forgot Password?</a>
                        </div>

                        <button type="submit" class="btn" id="loginButton">Log In</button>
                    </form>

                    <div class="social-login">
                        <span>Or continue with</span>
                        <div class="social-buttons">
                            <div class="social-btn google">
                                <i class="fab fa-google"></i>
                                <span>Google</span>
                            </div>
                            <div class="social-btn microsoft">
                                <i class="fab fa-microsoft"></i>
                                <span>Microsoft</span>
                            </div>
                        </div>
                    </div>

                    <div class="footer-text">
                        <p>Don't have an examiner account? <a href="#" class="switch-to-register">Register here</a></p>
                    </div>
                </div>
                
                <!-- Registration Form (Examiner Only) -->
                <div class="tab-content" id="register-content">
                    <% if (request.getParameter("registrationError") != null) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= request.getParameter("registrationError") %></span>
                    </div>
                    <% } %>
                    
                    <h2 style="text-align: center; margin-bottom: 30px; color: var(--primary);">Examiner Registration</h2>
                    
                    <form id="register-form" action="<%= request.getContextPath() %>/RegisterNewExaminerServlet" method="post" 
                            onsubmit="return validateRegisterForm()">
                        
                        <div class="form-group">
                            <label for="register-name">Full Name</label>
                            <input type="text" id="register-name" name="name" class="form-control" placeholder="Enter your full name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-email">Email Address</label>
                            <input type="email" id="register-email" name="email" class="form-control" placeholder="Enter your email address" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-id">Examiner ID</label>
                            <input type="text" id="register-id" name="examinerId" class="form-control" placeholder="Enter your examiner ID" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-password">Password</label>
                            <input type="password" id="register-password" name="password" class="form-control" placeholder="Create a password" required>
                            <i class="fas fa-eye password-toggle" id="toggleRegisterPassword"></i>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-confirm">Confirm Password</label>
                            <input type="password" id="register-confirm" name="confirmPassword" class="form-control" placeholder="Confirm your password" required>
                            <i class="fas fa-eye password-toggle" id="toggleConfirmPassword"></i>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-expertise">Area of Expertise</label>
                            <select id="register-expertise" name="expertise" class="form-control" required>
                                <option value="">Select your expertise</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Software Engineering">Software Engineering</option>
                                <option value="Data Science">Data Science</option>
                                <option value="Artificial Intelligence">Artificial Intelligence</option>
                                <option value="Networking">Networking</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-phone">Phone Number</label>
                            <input type="tel" id="register-phone" name="phone" class="form-control" placeholder="Enter your phone number" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="register-affiliation">Institution/Affiliation</label>
                            <input type="text" id="register-affiliation" name="affiliation" class="form-control" placeholder="Enter your institution" required>
                        </div>
                        
                        <div class="warning-message">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Examiner accounts require admin approval before access is granted.</span>
                        </div>
                        
                        <button type="submit" class="btn btn-accent" id="registerButton">Register Examiner Account</button>
                    </form>
                    
                    <div class="footer-text">
                        <p>Already have an account? <a href="#" class="switch-to-login">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Tab switching functionality
        function setupTabs() {
            const tabs = document.querySelectorAll('.tab');
            const tabContents = document.querySelectorAll('.tab-content');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    // Remove active class from all tabs
                    tabs.forEach(t => t.classList.remove('active'));
                    // Add active class to clicked tab
                    tab.classList.add('active');
                    
                    // Hide all tab contents
                    tabContents.forEach(content => {
                        content.classList.remove('active');
                    });
                    
                    // Show the corresponding tab content
                    const tabId = tab.getAttribute('data-tab');
                    document.getElementById(`${tabId}-content`).classList.add('active');
                });
            });
            
            // Check URL for initial tab
            const urlParams = new URLSearchParams(window.location.search);
            const initialTab = urlParams.get('tab') || 'login';
            
            // Activate the correct initial tab
            const initialTabElement = document.querySelector(`.tab[data-tab="${initialTab}"]`);
            if (initialTabElement && !initialTabElement.classList.contains('active')) {
                initialTabElement.click();
            }
        }
        
        
        // User type selection
        document.querySelectorAll('.user-option').forEach(option => {
            option.addEventListener('click', () => {
                document.querySelectorAll('.user-option').forEach(opt => {
                    opt.classList.remove('active');
                });
                option.classList.add('active');
                option.querySelector('input').checked = true;
                
                // Update placeholder text based on role
                const idInput = document.getElementById('login-id');
                const idLabel = document.getElementById('id-label');
                const role = option.dataset.type;
                
                if (role === 'admin') {
                    idInput.placeholder = "Enter admin ID";
                    idLabel.textContent = "Admin ID";
                } else if (role === 'examiner') {
                    idInput.placeholder = "Enter examiner ID";
                    idLabel.textContent = "Examiner ID";
                    
                } else if (role === 'lecturer' || role === 'supervisor') {
                    idInput.placeholder = "Enter Staff ID";
                    idLabel.textContent = "Staff ID";
                    
                }else {
                    idInput.placeholder = "Enter Student ID";
                    idLabel.textContent = "Student ID";
                }
            });
        });
        
        // Password toggle visibility
        function setupPasswordToggle(toggleId, passwordId) {
            const toggle = document.getElementById(toggleId);
            const password = document.getElementById(passwordId);
            
            if (toggle && password) {
                toggle.addEventListener('click', () => {
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);
                    toggle.classList.toggle('fa-eye');
                    toggle.classList.toggle('fa-eye-slash');
                });
            }
        }
        
        // Initialize password toggles
        setupPasswordToggle('toggleLoginPassword', 'login-password');
        setupPasswordToggle('toggleRegisterPassword', 'register-password');
        setupPasswordToggle('toggleConfirmPassword', 'register-confirm');
        
        // Switch to register from login footer
        document.querySelector('.switch-to-register').addEventListener('click', (e) => {
            e.preventDefault();
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelector('.tab[data-tab="register"]').classList.add('active');
            
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            document.getElementById('register-content').classList.add('active');
        });
        
        // Switch to login from register footer
        document.querySelector('.switch-to-login').addEventListener('click', (e) => {
            e.preventDefault();
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelector('.tab[data-tab="login"]').classList.add('active');
            
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            document.getElementById('login-content').classList.add('active');
        });
        
        // Login form validation
        function validateLoginForm() {
            const form = document.getElementById('loginForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return false;
            }
            
            // Show loading state
            const loginButton = document.getElementById('loginButton');
            loginButton.disabled = true;
            loginButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';
            
            return true;
        }
        
        // Register form validation
        function validateRegisterForm() {
            const form = document.getElementById('register-form');
            const password = document.getElementById('register-password').value;
            const confirmPassword = document.getElementById('register-confirm').value;
            
            if (!form.checkValidity()) {
                form.reportValidity();
                return false;
            }
            
            if (password !== confirmPassword) {
                Swal.fire({
                    title: 'Password Mismatch',
                    text: 'The passwords you entered do not match. Please try again.',
                    icon: 'error',
                    confirmButtonColor: 'var(--primary)'
                });
                return false;
            }
            
            if (password.length < 8) {
                Swal.fire({
                    title: 'Weak Password',
                    text: 'Password must be at least 8 characters long.',
                    icon: 'error',
                    confirmButtonColor: 'var(--primary)'
                });
                return false;
            }
            
            // Show loading state
            const registerButton = document.getElementById('registerButton');
            registerButton.disabled = true;
            registerButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Registering...';
            
            return true;
        }
        
        // Forgot password functionality
        document.getElementById('forgot-password-link').addEventListener('click', (e) => {
            e.preventDefault();
            
            const activeRole = document.querySelector('.user-option.active').dataset.type;
            const roleName = activeRole.charAt(0).toUpperCase() + activeRole.slice(1);
            const idLabel = activeRole === 'admin' ? 'Admin ID' : 
                          activeRole === 'examiner' ? 'Examiner ID' : 'User ID';
            
            Swal.fire({
                title: `Reset ${roleName} Password`,
                html: `Enter your ${idLabel} to receive password reset instructions`,
                input: 'text',
                inputPlaceholder: `Your ${idLabel}`,
                showCancelButton: true,
                confirmButtonText: 'Send Reset Link',
                confirmButtonColor: 'var(--primary)',
                showLoaderOnConfirm: true,
                preConfirm: (id) => {
                    return new Promise((resolve) => {
                        // Simulate API call
                        setTimeout(() => {
                            if (!id) {
                                Swal.showValidationMessage(`Please enter your ${idLabel}`);
                                resolve(false);
                            } else {
                                resolve();
                            }
                        }, 1500);
                    });
                },
                allowOutsideClick: false
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Reset Link Sent!',
                        text: 'Please check your registered email for password reset instructions.',
                        icon: 'success',
                        confirmButtonColor: 'var(--primary)'
                    });
                }
            });
        });
        
        // Check if there's a role parameter in URL and select accordingly
        document.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const roleParam = urlParams.get('role');
            const tabParam = urlParams.get('tab');
            
            if (roleParam) {
                const roleOption = document.querySelector(`.user-option[data-type="${roleParam}"]`);
                if (roleOption) {
                    roleOption.click();
                }
            }
            
            if (tabParam === 'register') {
                document.querySelector('.switch-to-register').click();
            }
        });
    </script>
</body>
</html>