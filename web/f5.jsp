<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");

    if (userName == null || "null".equals(userName)) userName = "User";
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }

    boolean isStudent = "student".equals(userRole);
    boolean isSupervisor = "supervisor".equals(userRole);
%>
<!DOCTYPE html>
<html>
<head>
    <title>F5 - Project In-Progress Form</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <link rel="stylesheet" href="sidebarStyle.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #4b2e83;
            --secondary: #6d4ac0;
            --light: #f9f7fd;
            --dark: #1a0d3f;
        }
        body {
            font-family: 'Poppins', sans-serif;
        }

        .form-title {
            padding: 20px;
            font-size: 22px;
            font-weight: 600;
            color: var(--dark);
        }

        .form-section {
            background: white;
            padding: 25px 30px;
            margin: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            font-weight: 600;
            color: var(--dark);
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"], input[type="date"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #bbb;
            border-radius: 6px;
            font-size: 14px;
        }

        input[readonly], textarea[readonly] {
            background-color: #eee;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: var(--primary);
            color: white;
        }

        .add-row-btn {
            margin-top: 15px;
            padding: 8px 15px;
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        .add-row-btn:hover {
            background-color: var(--secondary);
        }

        .submit-btn {
            margin-top: 25px;
            padding: 10px 20px;
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            float: right;
        }
    </style>
</head>
<body>
<header id="topbar">
    <jsp:include page="topbar.jsp" />
</header>
<aside id="sidebar">
    <jsp:include page="navbar.jsp" />
</aside>
<div id="sidebarOverlay"></div>

<div class="main-content">
    <h2 class="form-title">F5 - Proposal / Project In-Progress Form</h2>

    <form action="SubmitF5Servlet" method="post">
        <div class="form-section">
            <div class="form-group">
                <label>Student Name</label>
                <input type="text" name="studentName" value="Auto Fetch" readonly>
            </div>
            <div class="form-group">
                <label>Student ID</label>
                <input type="text" name="studentId" value="Auto Fetch" readonly>
            </div>
            <div class="form-group">
                <label>Project Title</label>
                <input type="text" name="projectTitle" value="Auto Fetch" readonly>
            </div>
        </div>

        <div class="form-section">
            <h3>Progress Log</h3>
            <table id="progressTable">
                <thead>
                    <tr>
                        <th>Date of Meeting</th>
                        <th>Completed Activity</th>
                        <th>Next Activity</th>
                        <th>Supervisor Signature</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><input type="date" name="date[]" <%= (isStudent || isSupervisor) ? "" : "readonly" %>></td>
                        <td><textarea name="completed[]" <%= isStudent ? "" : "readonly" %>></textarea></td>
                        <td><textarea name="next[]" <%= isSupervisor ? "" : "readonly" %>></textarea></td>
                        <td><input type="text" name="signature[]" value="<%= isSupervisor ? userName : "" %>" <%= isSupervisor ? "" : "readonly" %>></td>
                    </tr>
                </tbody>
            </table>
            <button type="button" class="add-row-btn" onclick="addRow()">Add Row</button>
        </div>

        <% if (isStudent || isSupervisor) { %>
        <div class="form-section">
            <button type="submit" class="submit-btn">Submit Form</button>
        </div>
        <% } %>
    </form>
</div>

<jsp:include page="sidebarScript.jsp" />

<script>
    function addRow() {
        const table = document.getElementById("progressTable").getElementsByTagName('tbody')[0];
        const newRow = table.insertRow();

        newRow.innerHTML = `
            <td><input type="date" name="date[]"></td>
            <td><textarea name="completed[]" <%= isStudent ? "" : "readonly" %>></textarea></td>
            <td><textarea name="next[]" <%= isSupervisor ? "" : "readonly" %>></textarea></td>
            <td><input type="text" name="signature[]" value="<%= isSupervisor ? userName : "" %>" <%= isSupervisor ? "" : "readonly" %>></td>
        `;
    }
</script>
</body>
</html>
