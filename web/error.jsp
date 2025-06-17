<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff3f3;
            text-align: center;
            padding: 50px;
        }
        .error-box {
            background-color: #ffe0e0;
            padding: 30px;
            border: 2px solid #ff4c4c;
            border-radius: 10px;
            display: inline-block;
        }
        h1 {
            color: #d8000c;
        }
        p {
            color: #a94442;
            font-size: 18px;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>Oops! Something went wrong.</h1>

        <%
            String error = request.getParameter("error");
            if (error == null) {
                out.println("<p>Unknown error occurred. Please try again.</p>");
            } else if (error.equals("supervisorNotFound")) {
                out.println("<p>The supervisor profile could not be found.</p>");
            } else if (error.equals("lecturerNotFound")) {
                out.println("<p>The lecturer profile could not be found.</p>");
            } else if (error.equals("studentNotFound")) {
                out.println("<p>The student profile could not be found.</p>");
            } else if (error.equals("unauthorized")) {
                out.println("<p>You are not authorized to access this page.</p>");
            } else if (error.equals("invalidRole")) {
                out.println("<p>The user role is invalid. Please contact the system administrator.</p>");
            } else if (error.equals("internalServer")) {
                out.println("<p>Internal server error. Please try again later or contact support.</p>");
            } else {
                out.println("<p>An unexpected error occurred: " + error + "</p>");
            }
        %>

        <a href="Login.jsp">Back to Login</a>
    </div>
</body>
</html>
