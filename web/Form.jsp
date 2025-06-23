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

    String[][] forms = {
        {"F1", "Mutual Acceptance Form"},
        {"F2", "Project Motivation Form"},
        {"F3", "Literature Review Evaluation Form"},
        {"F4", "Methodology Evaluation Form"},
        {"F5", "Proposal/Project In-Progress Form"},
        {"F6a", "Project Formulation Report Submission Form"},
        {"F6b", "Project Report Submission Form"},
        {"F7", "Project Formulation Presentation Form"},
        {"F8", "Project Formulation Evaluation Form"},
        {"F9", "Project Progress Presentation Form"},
        {"F10", "Final Project Presentation Form"},
        {"F11", "Final Report Evaluation Form"},
        {"F12", "Confirmation of Correction Form"},
        {"F13", "Business Model Evaluation Form"}
    };
%>

<!DOCTYPE html>
<html>
<head>
    <title>UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="sidebarStyle.css">
    <style>
        table.form-table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            font-family: Arial, sans-serif;
        }

        .form-table th, .form-table td {
            padding: 12px 20px;
            text-align: left;
        }

        .form-table th {
            background-color: #6a1b9a;
            color: white;
            font-size: 16px;
        }

        .form-table td {
            font-size: 14px;
            border-bottom: 1px solid #eee;
        }

        .form-table tr:hover {
            background-color: #f9f9f9;
        }

        .form-link {
            color: #6a1b9a;
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
            border-radius: 5px;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
        }

        .edit-btn {
            background-color: #28a745;
        }

        .edit-btn:hover {
            background-color: #218838;
        }

        .download-btn {
            background-color: #007bff;
        }

        .download-btn:hover {
            background-color: #0056b3;
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
        <h2 style="padding: 20px;">Available Forms</h2>
        <table class="form-table">
            <thead>
                <tr>
                    <th>Form ID</th>
                    <th>Form Name</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (String[] form : forms) {
                        String formId = form[0];
                        String formName = form[1];
                        String filename = formId.toLowerCase() + ".jsp";

                        boolean canEdit = false;
                        boolean canSignOnly = false;

                        if ("F1".equals(formId) || "F5".equals(formId)) {
                            if ("student".equals(userRole)) canEdit = true;
                            else if ("supervisor".equals(userRole)) canSignOnly = true;
                        } else if ("F2".equals(formId) || "F3".equals(formId) || "F4".equals(formId) || "F9".equals(formId) || "F13".equals(formId)) {
                            if ("lecturer".equals(userRole)) canSignOnly = true;
                        } else if ("F6a".equalsIgnoreCase(formId) || "F6b".equalsIgnoreCase(formId)) {
                            if ("supervisor".equals(userRole)) canSignOnly = true;
                        } else if ("F7".equals(formId) || "F8".equals(formId) || "F10".equals(formId) || "F11".equals(formId) || "F12".equals(formId)) {
                            if ("supervisor".equals(userRole) || "examiner".equals(userRole)) canSignOnly = true;
                        }
                %>
                <tr>
                    <td><%= formId %></td>
                    <td><a class="form-link" href="<%= filename %>?mode=view"><%= formName %></a></td>
                    <td>
                        <div class="action-icons">
                            <% if (canEdit || canSignOnly) { %>
                                <a class="icon-button edit-btn" href="<%= filename %>?mode=edit" title="Edit or Sign Form">
                                    <i class="fas fa-pen"></i>
                                </a>
                            <% } %>
                            <a class="icon-button download-btn" href="DownloadFormServlet?form=<%= formId %>" title="Download PDF">
                                <i class="fas fa-download"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
<jsp:include page="sidebarScript.jsp" />
</body>
</html>
