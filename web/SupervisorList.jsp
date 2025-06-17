
<%-- 
    Document   : supervisorList
    Created on : May 28, 2025, 12:37:47 AM
    Author     : ASUS
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Retrieve user information from session
    String userId = String.valueOf(session.getAttribute("userId"));
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String userAvatar = (String) session.getAttribute("avatar");
    
    // Set default values if null
    if(userName == null || "null".equals(userName)) {
        userName = "User";
    }
    // Check login/session
    if (userId == null || userRole == null || "null".equals(userId) || "null".equals(userRole)) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
    }
    // Set default avatar
    if (userAvatar == null || userAvatar.equals("null") || userAvatar.trim().isEmpty()) {
        userAvatar = "default.png"; // fallback kalau tak ada gambar
    }
    
    Map<String, String> roleNames = new HashMap<String, String>();
    roleNames.put("supervisor", "Supervisor");
    roleNames.put("student", "Student");
    roleNames.put("lecturer", "Lecturer");
    roleNames.put("admin", "Administrator");

    String displayRole = roleNames.getOrDefault(userRole, "User");
    
    // Fake data for supervisors (Replace with actual DB query in real app)
    class Supervisor {
        String name, staffId, contact, email;
        Supervisor(String name, String staffId, String contact, String email) {
            this.name = name; this.staffId = staffId; this.contact = contact; this.email = email;
        }
    }

    List<Supervisor> supervisors = new ArrayList<>();
    supervisors.add(new Supervisor("Prof. Muhammad Ali", "5751289", "+60 123456789", "muhdali79@gmail.com"));
    supervisors.add(new Supervisor("Dr. Nurul Huda binti Kamaruddin", "5759034", "+60 179876543", "nurulhuda@gmail.com"));
    supervisors.add(new Supervisor("Madam Tan Mei Ling", "5755672", "+60 112233445", "tanmeiling@gmail.com"));
    supervisors.add(new Supervisor("Encik Ahmad Zaki bin Osman", "5753108", "+60 1011223344", "ahmadzaki@gmail.com"));
    supervisors.add(new Supervisor("Puan Sharifah binti Syed Hussein", "5750921", "+60 1578901234", "sharifahhuss@gmail.com"));
    supervisors.add(new Supervisor("Ms. Malarvili a/p Suppiah", "5754827", "+60 1423456789", "malarvilisup@gmail.com"));
    supervisors.add(new Supervisor("Puan Siti Aminah binti Abdullah", "5752716", "+60 1890123455", "sitiaminahabd@gmail.com"));
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>UiTM FYP System</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <!--SIDEBAR-->
        <jsp:include page="sidebar.jsp" />
        
        <!-- Admin Part -->
        <% if ("admin".equals(userRole) || "lecturer".equals(userRole)) { %>
    <div class="main-content">
        <h2 class="page-title">List of Supervisors</h2>
        <div class="table-container">
            <table class="supervisor-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Staff ID</th>
                        <th>Contact</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Supervisor sup : supervisors) { %>
                    <tr>
                        <td><%= sup.name %></td>
                        <td><%= sup.staffId %></td>
                        <td><%= sup.contact %></td>
                        <td><%= sup.email %></td>
                        <td>
                            <form action="EditSupervisor.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="staffId" value="<%= sup.staffId %>"/>
                                <button type="submit" class="btn-edit">Edit</button>
                            </form>
                            <form action="DeleteSupervisorServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this supervisor?');">
                                <input type="hidden" name="staffId" value="<%= sup.staffId %>"/>
                                <button type="submit" class="btn-delete">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
        <div class="main-content">
            <h2>Access Denied</h2>
            <p>You do not have permission to view this page.</p>
        </div>
    <% } %>
    </body>
</html>