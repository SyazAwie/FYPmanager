package fyp.controller;

import fyp.model.DB.FormsDB;
import DBconnection.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/SubmitF8Servlet")
public class SubmitF8Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            int userId = Integer.parseInt(session.getAttribute("userId").toString());
            String role = session.getAttribute("role").toString();

            if (!role.equals("supervisor") && !role.equals("examiner")) {
                response.sendRedirect("dashboard.jsp?error=unauthorized");
                return;
            }

            String studentIdStr = request.getParameter("studentId");
            String evaluationDate = request.getParameter("evaluationDate");
            String scoreStr = request.getParameter("score");

            if (studentIdStr == null || scoreStr == null || evaluationDate == null) {
                response.sendRedirect("f8.jsp?error=missingFields");
                return;
            }

            int studentId = Integer.parseInt(studentIdStr);
            double totalMarks = Double.parseDouble(scoreStr);

            // Calculate final weighted score based on role
            double weightedScore = 0.0;
            if (role.equals("supervisor")) {
                weightedScore = totalMarks * 0.30; // 30%
            } else if (role.equals("examiner")) {
                weightedScore = totalMarks * 0.15; // 15%
            }

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formsDB = new FormsDB(conn);
                formsDB.saveFormF8(studentId, role, weightedScore, evaluationDate);
            }

            response.sendRedirect("Form.jsp?success=F8submitted");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=F8SubmitError");
        }
    }
}
