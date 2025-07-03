package fyp.controller;

import DBconnection.DatabaseConnection;
import fyp.model.DB.UserDB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;

@WebServlet("/RegisterNewExaminerServlet")
public class RegisterNewExaminerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: Entering doPost of RegisterNewExaminerServlet");

        // Ambil parameter dari borang
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String examinerId = request.getParameter("examinerId");
        String password = request.getParameter("password");
        String hashedPassword = UserDB.hashPassword(password);
        System.out.println("DEBUG: Hashed Password=" + hashedPassword);
        String phone = request.getParameter("phone");
        String expertise = request.getParameter("expertise");
        String affiliation = request.getParameter("affiliation");

        System.out.println("DEBUG: Retrieved form data:");
        System.out.println("  name=" + name);
        System.out.println("  email=" + email);
        System.out.println("  examinerId=" + examinerId);
        System.out.println("  password=" + password);
        System.out.println("  phone=" + phone);
        System.out.println("  expertise=" + expertise);
        System.out.println("  affiliation=" + affiliation);

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) {
                System.err.println("DEBUG: Database connection failed");
                response.sendRedirect("error.jsp");
                return;
            }

            System.out.println("DEBUG: Successfully connected to DB");

            String sql = "INSERT INTO examiner_register (full_name, email, examiner_id, password, phone, field_of_expertise, institution, status) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, examinerId);
                ps.setString(4, hashedPassword);
                ps.setString(5, phone);
                ps.setString(6, expertise);
                ps.setString(7, affiliation);
                ps.setString(8, "Pending"); // status default

                int rowsInserted = ps.executeUpdate();
                System.out.println("DEBUG: Rows inserted: " + rowsInserted);

                if (rowsInserted > 0) {
                    response.sendRedirect("Login.jsp?registrationSuccess=1");
                } else {
                    response.sendRedirect("Login.jsp?registrationError=insert_failed");
                }
            }

        } catch (SQLException e) {
            System.err.println("DEBUG: SQLException - " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Login.jsp?registrationError=db_error");
        } catch (Exception e) {
            System.err.println("DEBUG: General Exception - " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Login.jsp?registrationError=exception");
        }

        System.out.println("DEBUG: Exiting doPost of RegisterNewExaminerServlet");
    }
}
