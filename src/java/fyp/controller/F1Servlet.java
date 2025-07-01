package fyp.controller;

import fyp.model.DB.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.util.Map;
import java.sql.*;
import DBconnection.DatabaseConnection;

@WebServlet("/F1Servlet")
public class F1Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: Entering doGet method of F1Servlet");

        HttpSession session = request.getSession(false);
        System.out.println("DEBUG: Retrieved session - " + (session != null ? "session exists" : "session is null"));

        try {
            String userIdStr = (String) session.getAttribute("userId");
            int userId = 0;
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                userId = Integer.parseInt(userIdStr);
            }
            System.out.println("DEBUG: Retrieved student_id from session: " + userId);

            try (Connection conn = DatabaseConnection.getConnection()) {
                System.out.println("DEBUG: Successfully obtained database connection");

                FormsDB formDB = new FormsDB(conn);
                System.out.println("DEBUG: Created FormsDB instance");

                Map<String, String> formData = formDB.getFormF1Data(userId);
                System.out.println("DEBUG: Retrieved form data - size: " + formData.size());

                for (Map.Entry<String, String> entry : formData.entrySet()) {
                    System.out.println("DEBUG: Setting request attribute - Key: " + entry.getKey() + ", Value: " + entry.getValue());
                    request.setAttribute(entry.getKey(), entry.getValue());
                }

                RequestDispatcher dispatcher = request.getRequestDispatcher("f1.jsp");
                System.out.println("DEBUG: Forwarding to f1.jsp");
                dispatcher.forward(request, response);

            } catch (SQLException e) {
                System.err.println("DEBUG: Database error in doGet: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } catch (Exception e) {
            System.err.println("DEBUG: General error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
        System.out.println("DEBUG: Exiting doGet method");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: Entering doPost method of F1Servlet");

        HttpSession session = request.getSession(false);
        System.out.println("DEBUG: Retrieved session - " + (session != null ? "session exists" : "session is null"));

        try {
            String userIdStr = (String) session.getAttribute("userId");
            int userId = 0;
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                userId = Integer.parseInt(userIdStr);
            }
            System.out.println("DEBUG: Retrieved student_id from session: " + userId);

            String studentSignature = request.getParameter("studentSignature");
            System.out.println("DEBUG: Retrieved studentSignature parameter: " + 
                (studentSignature != null ? "[exists]" : "null"));

            try (Connection conn = DatabaseConnection.getConnection()) {
                System.out.println("DEBUG: Successfully obtained database connection");

                FormsDB formDB = new FormsDB(conn);
                System.out.println("DEBUG: Created FormsDB instance");

                formDB.saveFormF1(userId, studentSignature);
                System.out.println("DEBUG: Successfully saved form F1 data");

                System.out.println("DEBUG: Redirecting to Form.jsp");
                response.sendRedirect("Form.jsp");

            } catch (SQLException e) {
                System.err.println("DEBUG: Database error in doPost: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } catch (Exception e) {
            System.err.println("DEBUG: General error in doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
        System.out.println("DEBUG: Exiting doPost method");
    }
}