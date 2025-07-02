<%@ page import="java.sql.*, DBconnection.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userRole = (String) session.getAttribute("role");
    if (userRole == null || !userRole.equals("admin")) {
        response.sendRedirect("Login.jsp?error=unauthorized");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>UiTM FYP System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <link rel="stylesheet" href="sidebarStyle.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #4b2e83;
            --success: #4CAF50;
            --white: #ffffff;
            --gray-light: #f5f5f5;
            --dark: #1a0d3f;
        }
        .container {
            max-width: 100%;width: 75%;; margin: 30px auto; padding: 20px;
            background-color: var(--white); border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); font-family: 'Poppins', sans-serif;
            margin-top: 100px;
        }
        h2 {
            color: var(--primary); margin-bottom: 20px;
        }
        table.form-table {
            width: 100%; border-collapse: collapse; background-color: var(--white);
        }
        .form-table th, .form-table td {
            padding: 12px 20px; text-align: left;
        }
        .form-table th {
            background-color: var(--primary); color: var(--white);
        }
        .form-table td {
            border-bottom: 1px solid var(--gray-light);
        }
        .icon-button {
            padding: 6px 10px; border-radius: 6px; font-size: 14px;
            display: inline-flex; align-items: center; justify-content: center;
            color: white; background-color: var(--success); border: none;
            cursor: pointer;
        }
        .icon-button:hover {
            background-color: #388e3c;
        }
        .success-msg {
            background-color: #d0f0d0;
            border: 1px solid #b2e0b2;
            padding: 10px;
            border-radius: 6px;
            color: var(--dark);
            margin-bottom: 20px;
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
<div class="container">
    <h2>Pending Examiner Approvals</h2>
    
    <%
String rejectId = request.getParameter("rejectExaminerId");
if (rejectId != null) {
    try (Connection conn = DatabaseConnection.getConnection()) {
        String rejectSql = "UPDATE examiner_register SET status = 'rejected' WHERE id = ?";
        PreparedStatement rejectStmt = conn.prepareStatement(rejectSql);
        rejectStmt.setInt(1, Integer.parseInt(rejectId));
        rejectStmt.executeUpdate();
%>
        <div class="success-msg" style="background-color: #f8d7da; border-color: #f5c6cb;">
            ❌ Examiner rejected successfully.
        </div>
<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error rejecting: " + e.getMessage() + "</p>");
    }
}
%>


    <%
        String approveId = request.getParameter("approveExaminerId");
        if (approveId != null) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String selectSql = "SELECT * FROM examiner_register WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(selectSql);
                ps.setInt(1, Integer.parseInt(approveId));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String fullName = rs.getString("full_name");
                    String email = rs.getString("email");
                    String examinerId = rs.getString("examiner_id");
                    String password = rs.getString("password");
                    String phone = rs.getString("phone");
                    String expertise = rs.getString("field_of_expertise");
                    String affiliation = rs.getString("institution");

                    String insertUser = "INSERT INTO users (user_id, name, email, phoneNum, password, role, avatar) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertUserStmt = conn.prepareStatement(insertUser);
                    insertUserStmt.setString(1, examinerId);
                    insertUserStmt.setString(2, fullName);
                    insertUserStmt.setString(3, email);
                    insertUserStmt.setString(4, phone);
                    insertUserStmt.setString(5, password);
                    insertUserStmt.setString(6, "examiner");
                    insertUserStmt.setString(7, "default.png");
                    insertUserStmt.executeUpdate();

                    String insertExaminer = "INSERT INTO examiner (examiner_id, name, email, phone, expertise, affiliation) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement insertExaminerStmt = conn.prepareStatement(insertExaminer);
                    insertExaminerStmt.setString(1, examinerId);
                    insertExaminerStmt.setString(2, fullName);
                    insertExaminerStmt.setString(3, email);
                    insertExaminerStmt.setString(4, phone);
                    insertExaminerStmt.setString(5, expertise);
                    insertExaminerStmt.setString(6, affiliation);
                    insertExaminerStmt.executeUpdate();

                    String updateStatus = "UPDATE examiner_register SET status = 'accepted' WHERE id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateStatus);
                    updateStmt.setInt(1, Integer.parseInt(approveId));
                    updateStmt.executeUpdate();
    %>
                    <div class="success-msg">✅ Examiner <strong><%= fullName %></strong> approved successfully!</div>
    <%
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        }
    %>

    <table class="form-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "SELECT * FROM examiner_register WHERE status = 'pending'";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int examinerId = rs.getInt("id");
                    String name = rs.getString("full_name");
                    String email = rs.getString("email");
                    String phone = rs.getString("phone");
        %>
            <tr>
                <td><%= name %></td>
                <td><%= email %></td>
                <td><%= phone %></td>
                <td>
                    <form method="post" action="<%= request.getRequestURI() %>" id="approve-form-<%= examinerId %>" style="display:inline;">
                        <input type="hidden" name="approveExaminerId" value="<%= examinerId %>" />
                        <button type="button" class="icon-button" title="Approve" onclick="confirmApprove(<%= examinerId %>)">
                            <i class="fas fa-check"></i>
                        </button>
                    </form>

                    <form method="post" action="<%= request.getRequestURI() %>" id="reject-form-<%= examinerId %>" style="display:inline;">
                        <input type="hidden" name="rejectExaminerId" value="<%= examinerId %>" />
                        <button type="button" class="icon-button" title="Reject" style="background-color: #dc3545;" onclick="confirmReject(<%= examinerId %>)">
                            <i class="fas fa-times"></i>
                        </button>
                    </form>
                </td>

            </tr>
        <%
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='4' style='color:red;'>Error loading examiners: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<script>
function confirmApprove(id) {
    Swal.fire({
        title: 'Approve this examiner?',
        text: "This will move them to active user list.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#4CAF50',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, approve'
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('approve-form-' + id).submit();
        }
    });
}

function confirmReject(id) {
    Swal.fire({
        title: 'Reject this examiner?',
        text: "This action cannot be undone.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, reject'
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('reject-form-' + id).submit();
        }
    });
}
</script>

<jsp:include page="sidebarScript.jsp" />
</body>
</html>
