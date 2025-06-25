<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");

    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png";
    }

    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");

    // [0]=ID, [1]=Name, [2]=DueDate
    String[][] forms = {
        {"F1", "Mutual Acceptance Form", "2025-07-10"},
        {"F2", "Project Motivation Form", null},
        {"F3", "Literature Review Evaluation Form", "2025-07-18"},
        {"F4", "Methodology Evaluation Form", null},
        {"F5", "Proposal/Project In-Progress Form", "2025-07-25"},
        {"F6a", "Project Formulation Report Submission Form", null},
        {"F6b", "Project Report Submission Form", null},
        {"F7", "Project Formulation Presentation Form", null},
        {"F8", "Project Formulation Evaluation Form", null},
        {"F9", "Project Progress Presentation Form", null},
        {"F10", "Final Project Presentation Form", null},
        {"F11", "Final Report Evaluation Form", null},
        {"F12", "Confirmation of Correction Form", null},
        {"F13", "Business Model Evaluation Form", null}
    };
%>

<!DOCTYPE html>
<html>
<head>
    <title>UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--Font & Icons-->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!--CSS Files-->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
    <style>
        :root {
            --primary: #4b2e83;
            --secondary: #6d4ac0;
            --accent: #b399d4;
            --light: #f9f7fd;
            --dark: #1a0d3f;
            --white: #ffffff;
            --gray-light: #f5f5f5;
            --gray-medium: #e0e0e0;
            --gray-dark: #757575;
            --success: #4CAF50;
            --info: #2196F3;
        }

        table.form-table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            font-family: 'Segoe UI', sans-serif;
        }

        .form-table th, .form-table td {
            padding: 12px 20px;
            text-align: left;
        }

        .form-table th {
            background-color: var(--primary);
            color: var(--white);
            font-size: 16px;
        }

        .form-table td {
            font-size: 14px;
            border-bottom: 1px solid var(--gray-light);
        }

        .form-table tr:hover {
            background-color: var(--light);
        }

        .form-link {
            color: var(--dark);
            font-weight: bold;
            text-decoration: none;
        }

        .form-link:hover {
            text-decoration: underline;
        }

        .action-icons {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .icon-button {
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
            transition: background-color 0.3s ease;
            width: 36px;
            height: 36px;
        }

        .edit-btn {
            background-color: var(--success);
        }

        .edit-btn:hover {
            background-color: #388e3c;
        }

        .download-btn {
            background-color: var(--info);
        }

        .download-btn:hover {
            background-color: #1976d2;
        }

        .automation-placeholder {
            margin: 30px auto;
            width: 90%;
            background-color: var(--gray-light);
            padding: 15px 20px;
            border-radius: 8px;
            color: var(--dark);
            font-weight: 500;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
    <!-- Topbar -->
    <header id="topbar">
        <jsp:include page="topbar.jsp" />
    </header>

    <!-- Sidebar -->
    <aside id="sidebar">
        <jsp:include page="navbar.jsp" />
    </aside>

    <!-- Overlay -->
    <div id="sidebarOverlay"></div>

    <div class="main-content">
        <h2 style="padding: 20px; color: var(--dark); font-weight: bold;">Forms and Due Date</h2>
        <table class="form-table">
            <thead>
                <tr>
                    <th>Form ID</th>
                    <th>Form Name</th>
                    <th>Due Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (String[] form : forms) {
                        String formId = form[0];
                        String formName = form[1];
                        String dueDate = form[2];
                        String filename = formId.toLowerCase() + ".jsp";
                %>
                <tr>
                    <td><%= formId %></td>
                    <td><a class="form-link" href="<%= filename %>?mode=view"><%= formName %></a></td>
                    <td><%= (dueDate != null) ? dueDate : "<span style='color:#999;'>Pending</span>" %></td>
                    <td>
                        <div class="action-icons">
                            <a class="icon-button edit-btn" href="<%= filename %>?mode=edit" title="Edit or Sign Form">
                                <i class="fas fa-pen"></i>
                            </a>
                            <a class="icon-button download-btn" href="DownloadFormServlet?form=<%= formId %>" title="Download PDF">
                                <i class="fas fa-download"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="automation-placeholder">
            <p>⚙️ Automation logic space: control due dates, access restrictions, or dependencies between forms.</p>
        </div>
    </div>

    <jsp:include page="sidebarScript.jsp" />
</body>
</html>
