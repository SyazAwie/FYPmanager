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

        .error-message {
            background: #fef2f2;
            color: #dc2626;
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

        .admin-link {
            text-align: center;
            margin-top: 30px;
            color: #777;
        }

        .admin-link a {
            color: var(--secondary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .admin-link a:hover {
            color: var(--primary);
            text-decoration: underline;
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
            
            .footer-text {
                font-size: 0.9rem;
                margin-top: 20px;
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
                
                <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>Invalid ID or Password. Please try again.</span>
                </div>
                <% } %>

                <form id="loginForm" action="/FYPManagement/LoginServlet" method="post" onsubmit="return validateForm()">
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
                    </div>

                    <div class="form-group">
                        <label for="id">User ID</label>
                        <input type="text" name="id" id="id" class="form-control" placeholder="Enter your ID" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" name="password" id="password" class="form-control" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn">Log In</button>
                </form>

                <div class="admin-link">
                    Admin access? <a href="AdminLogin.jsp">Login here</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Form validation
        function validateForm() {
            const form = document.getElementById('loginForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return false;
            }
            return true;
        }

        // Role selection interaction
        document.querySelectorAll('.user-option').forEach(option => {
            option.addEventListener('click', () => {
                document.querySelectorAll('.user-option').forEach(el => el.classList.remove('active'));
                option.classList.add('active');
                option.querySelector('input').checked = true;
            });
        });
    </script>
</body>
</html>