package fyp.controller;

import fyp.model.DB.FormsDB;
import DBconnection.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/SubmitF7Servlet")
public class SubmitF7Servlet extends HttpServlet {
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
            String scoringDate = request.getParameter("scoringDate");
            String scoreStr = request.getParameter("score");

            if (studentIdStr == null || scoreStr == null || scoringDate == null) {
                response.sendRedirect("Form.jsp?error=missingFields");
                return;
            }

            int studentId = Integer.parseInt(studentIdStr);
            double score = Double.parseDouble(scoreStr);

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formsDB = new FormsDB(conn);
                formsDB.saveFormF7(studentId, role, score, scoringDate);
            }

            response.sendRedirect("Form.jsp?success=F7submitted");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=F7SubmitError");
        }
    }
}
