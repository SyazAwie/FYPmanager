<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>FYP Management System - Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Shared styles with Login page */
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

        .admin-title {
            color: #101828;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 8px;
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

        .back-link {
            text-align: center;
            margin-top: 32px;
            color: #475467;
        }

        .back-link a {
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
        <div class="admin-title">Admin Portal</div>
    </div>

    <% if (request.getParameter("error") != null) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        <span>Invalid credentials. Please try again.</span>
    </div>
    <% } %>

    <form id="adminForm" action="/FYPManagement/LoginServlet" method="post" onsubmit="return validateForm()">
        <!-- Hidden fixed role -->
        <input type="hidden" name="role" value="admin">

        <!-- Visible input for Admin ID -->
        <div class="input-group">
            <label for="id">Admin ID</label>
            <input type="text" name="id" id="id" placeholder="Enter admin ID" required>
        </div>

        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="••••••••" required>
        </div>

        <button type="submit" class="login-button">Secure Login</button>
    </form>


    <div class="back-link">
        Return to <a href="Login.jsp">User Login</a>
    </div>
</div>

<script>
    // Form validation
    function validateForm() {
        const form = document.getElementById('adminForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return false;
        }
        return true;
    }
</script>
</body>
</html>