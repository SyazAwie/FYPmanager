package fyp.controller;

import DBconnection.DatabaseConnection;
import fyp.model.DB.FormsDB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/F6aServlet")
public class F6aServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            String role = (String) session.getAttribute("role");

            // Dapatkan studentId sama ada dari session (student) atau dari parameter (staff)
            int studentId = "student".equals(role) ? userId : Integer.parseInt(request.getParameter("studentId"));

            System.out.println("🔍 F6aServlet [GET] accessed");
            System.out.println("✅ Role: " + role + ", Supervisor/User ID: " + userId);
            System.out.println("🎯 Target Student ID: " + studentId);

            FormsDB formDB = new FormsDB(DatabaseConnection.getConnection());

            // Cuba ambil data F6a dahulu
            Map<String, String> data = formDB.getFormDataByCode(studentId, "F6a");

            // Jika kosong (belum submit), fallback ke F2 (jika sesuai)
            if (data == null || data.isEmpty()) {
                System.out.println("ℹ️ No F6a data found. Falling back to F2 data...");
                data = formDB.getFormF2Data(studentId);
            } else {
                System.out.println("✅ F6a data found and loaded.");
            }

            // Letak data dalam request
            for (Map.Entry<String, String> entry : data.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            request.getRequestDispatcher("f6a.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("❌ studentId parameter invalid or missing");
            response.sendRedirect("formError.jsp?form=F6a&error=invalidStudentId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F6a");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            int supervisorId = (int) session.getAttribute("userId");
            String role = (String) session.getAttribute("role");

            if (!"supervisor".equalsIgnoreCase(role)) {
                response.sendRedirect("unauthorized.jsp");
                return;
            }

            int studentId = Integer.parseInt(request.getParameter("studentId"));
            double similarityIndex = Double.parseDouble(request.getParameter("similarityIndex"));
            boolean confirm = "yes".equalsIgnoreCase(request.getParameter("plagiarismConfirm"));

            FormsDB formsDB = new FormsDB(DatabaseConnection.getConnection());
            formsDB.saveFormF6a(studentId, supervisorId, similarityIndex, confirm);

            System.out.println("✅ F6a submitted by supervisorId=" + supervisorId + " for studentId=" + studentId);

            response.sendRedirect("formSuccess.jsp?form=F6a");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F6a");
        }
    }
}
