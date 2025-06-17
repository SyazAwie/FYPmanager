package fyp.controller;

import fyp.model.DB.UserDB;
import fyp.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import javax.servlet.RequestDispatcher;

public class LoginServlet extends HttpServlet {
    /**
     *
     * @param request
     * @param response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */   
    @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            response.getWriter().println("LoginServlet OK je");}
            
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDB userDB = new UserDB();
        
        int id = Integer.parseInt(request.getParameter("id").trim());
        String hashedPassword = request.getParameter("password").trim();
        String password = UserDB.hashPassword(hashedPassword); //
        String role = request.getParameter("role").trim();
        
        User user = userDB.getUserByIdAndPassword(id, password, role);
        
        System.out.println("SQL TEST: id=" + id + ", password=" + password + ", role=" + role);

        request.setAttribute("debugLog", "SQL TEST: id=" + id + ", password=" + password + ", role=" + role);
        
        System.out.println("USER DEBUG:");
        System.out.println("ID: " + id);
        System.out.println("Password: " + password);
        System.out.println("Role: " + role);

        if (user != null) {
            System.out.println("Login success: " + user.getUser_id());
        } else {
            System.out.println("Login failed: no matching user found.");
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", String.valueOf(user.getUser_id())); // ✅ stores as String
            session.setAttribute("role", user.getRole());
            session.setAttribute("userName", user.getName());
            session.setAttribute("avatar", user.getAvatar());


            // Semua role akan pergi ke satu Dashboard.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Dashboard.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("Login.jsp?error=invalid");
        }
    }

}
