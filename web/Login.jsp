<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>FYP Management System - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .login-container {
            background: #ffffff;
            width: 100%;
            max-width: 440px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
            border: 1px solid #e4e7ec;
        }

        .brand-section {
            text-align: center;
            margin-bottom: 40px;
        }

        .brand-logo {
            width: 120px;
            margin-bottom: 20px;
        }

        h1 {
            color: #101828;
            font-size: 1.8rem;
            margin-bottom: 8px;
        }

        h2 {
            color: #475467;
            font-size: 1rem;
            font-weight: 400;
        }

        .role-selection {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin: 24px 0;
        }

        .role-option {
            background: #f8f9fc;
            border: 2px solid #e4e7ec;
            border-radius: 8px;
            padding: 14px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            font-weight: 500;
            color: #344054;
        }

        .role-option.selected {
            border-color: #3b82f6;
            background: #eff4ff;
        }

        .input-group {
            margin-bottom: 24px;
            position: relative;
        }

        .input-group label {
            display: block;
            color: #344054;
            margin-bottom: 8px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .input-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e4e7ec;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s ease;
            background: #ffffff;
        }

        .input-group input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .login-button {
            width: 100%;
            padding: 14px;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 16px;
        }

        .login-button:hover {
            background: #2563eb;
        }

        .login-button:disabled {
            background: #e4e7ec;
            cursor: not-allowed;
        }

        .admin-link {
            text-align: center;
            margin-top: 32px;
            color: #475467;
        }

        .admin-link a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
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

        @media (max-width: 480px) {
            .login-container {
                padding: 32px 24px;
                border: none;
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="brand-section">
        <img src="images/UiTM-Logo.png" alt="UiTM Logo" class="brand-logo">
        <h1>UNIVERSITI TEKNOLOGI MARA</h1>
        <h2>FYP Management System</h2>
    </div>

    <% if (request.getParameter("error") != null) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        <span>Invalid ID or Password. Please try again.</span>
    </div>
    <% } %>

    <form id="loginForm" action="/FYPManagement/LoginServlet" method="post" onsubmit="return validateForm()">
        <div class="role-selection">
            <label class="role-option selected">
                <input type="radio" name="role" value="student" checked hidden>
                Student
            </label>
            <label class="role-option">
                <input type="radio" name="role" value="supervisor" hidden>
                Supervisor
            </label>
            <label class="role-option">
                <input type="radio" name="role" value="lecturer" hidden>
                Lecturer
            </label>
        </div>

        <div class="input-group">
            <label for="id">User ID</label>
            <input type="text" name="id" id="id" placeholder="Enter your ID" required>
        </div>

        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="••••••••" required>
        </div>

        <button type="submit" class="login-button">Log In</button>
    </form>

    <div class="admin-link">
        Admin access? <a href="AdminLogin.jsp">Login here</a>
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
    document.querySelectorAll('.role-option').forEach(option => {
        option.addEventListener('click', () => {
            document.querySelectorAll('.role-option').forEach(el => el.classList.remove('selected'));
            option.classList.add('selected');
            option.querySelector('input').checked = true;
        });
    });
</script>
</body>
</html>