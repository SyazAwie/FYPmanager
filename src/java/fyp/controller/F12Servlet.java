package fyp.controller;

import fyp.model.DB.FormsDB;
import DBconnection.DatabaseConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;


@WebServlet("/F12Servlet")
public class F12Servlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");
        String userName = (String) session.getAttribute("userName");
        int userId = (int) session.getAttribute("userId");

        String studentName = request.getParameter("studentName");
        String studentIdStr = request.getParameter("studentId");
        String projectTitle = request.getParameter("projectTitle");
        String confirmation = request.getParameter("confirmation");
        String dateConfirmedStr = request.getParameter("dateConfirmed");

        int studentId;
        Date dateConfirmed;

        try {
            studentId = Integer.parseInt(studentIdStr);
            dateConfirmed = Date.valueOf(dateConfirmedStr);
        } catch (Exception e) {
            response.sendRedirect("f12.jsp?error=invalidInput");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO forms (form_code, form_name, description, access_role, formDate, " +
                         "submitted_by, submitted_to, submitted_date, status, student_id, supervisor_id, examinerId) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "F12");
            ps.setString(2, "Confirmation of Report Correction");
            ps.setString(3, projectTitle);
            ps.setString(4, userRole);
            ps.setDate(5, null);
            ps.setString(6, studentName);
            ps.setString(7, userName);
            ps.setDate(8, dateConfirmed);
            ps.setString(9, confirmation);
            ps.setInt(10, studentId);

            if ("supervisor".equals(userRole)) {
                ps.setInt(11, userId);
                ps.setNull(12, java.sql.Types.INTEGER);
            } else if ("examiner".equals(userRole)) {
                ps.setNull(11, java.sql.Types.INTEGER);
                ps.setInt(12, userId);
            } else {
                response.sendRedirect("f12.jsp?error=unauthorized");
                return;
            }

            int result = ps.executeUpdate();
            if (result > 0) {
                response.sendRedirect("form.jsp?success=f12submitted");
            } else {
                response.sendRedirect("f12.jsp?error=insertFailed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("f12.jsp?error=sqlError");
        }
    }
}
