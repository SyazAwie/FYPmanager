package fyp.controller;

import fyp.model.DB.FormsDB;
import fyp.model.Forms;
import DBconnection.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

@WebServlet("/F4Servlet")
public class F4Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ========== Handle Prefill (GET) ==========
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("Login.jsp?error=sessionExpired");
        return;
        }

        try {
            String userIdStr = (String) session.getAttribute("userId");
            int userId = Integer.parseInt(userIdStr);

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formDB = new FormsDB(conn);
                Map<String, String> formData = formDB.getFormDataByCode(userId, "F4");


                for (Map.Entry<String, String> entry : formData.entrySet()) {
                    request.setAttribute(entry.getKey(), entry.getValue());
                }

                request.getRequestDispatcher("f4.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("formError.jsp?form=F4");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F4");
        }
    }

    // ========== Handle Submit (POST) ==========
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {
            int userId = Integer.parseInt((String) session.getAttribute("userId"));

            // Retrieve form fields
            String studentName = request.getParameter("studentName");
            String studentIdStr = request.getParameter("studentId");
            String projectTitle = request.getParameter("projectTitle");
            String designComment = request.getParameter("designComment");
            String toolsComment = request.getParameter("toolsComment");
            String feasibilityComment = request.getParameter("feasibilityComment");
            String dateScored = request.getParameter("dateScored");
            String supervisorName = request.getParameter("supervisorName");

            double score1 = parseDouble(request.getParameter("score1"));
            double score2 = parseDouble(request.getParameter("score2"));
            double score3 = parseDouble(request.getParameter("score3"));
            double totalScore = (score1 * 3) + (score2 * 3) + (score3 * 4);
            int studentId = Integer.parseInt(studentIdStr);

            String description = "Design: " + designComment +
                    " | Tools: " + toolsComment +
                    " | Feasibility: " + feasibilityComment;

            String formDate = (dateScored == null || dateScored.isEmpty())
                    ? new SimpleDateFormat("yyyy-MM-dd").format(new Date())
                    : dateScored;

            String role = (String) session.getAttribute("role");
            String submittedBy = role; // will be 'supervisor' or 'lecturer'

            int lecturerId = 0;
            int supervisorId = 0;

            if ("supervisor".equals(role)) {
                supervisorId = userId;
            } else if ("lecturer".equals(role)) {
                lecturerId = userId;
            }
            Forms form = new Forms(
            0, "F4", "Methodology Evaluation", description, submittedBy,
            formDate, supervisorName, studentName, formDate,
            "Submitted", totalScore, null,
             studentId, lecturerId, supervisorId, 0, 0
            );

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formDB = new FormsDB(conn);
                formDB.saveOrUpdateForm(form);
                response.sendRedirect("formSuccess.jsp?form=F4");

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("formError.jsp?form=F4");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F4");
        }
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0.0;
        }
    }
}
