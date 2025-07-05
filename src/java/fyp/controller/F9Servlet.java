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
import java.sql.Connection;

@WebServlet("/F9Servlet")
public class F9Servlet extends HttpServlet {
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

            if (!role.equals("lecturer")) {
            response.sendRedirect("dashbosaveformf9 tu saya ard.jsp?error=unauthorized");
            return;
            }


            String studentIdStr = request.getParameter("studentId");
            String evaluationDate = request.getParameter("evaluationDate");
            String totalMarkStr = request.getParameter("totalMarks");

            if (studentIdStr == null || evaluationDate == null || totalMarkStr == null) {
                response.sendRedirect("f9.jsp?error=missingFields");
                return;
            }

            int studentId = Integer.parseInt(studentIdStr);
            double totalMark = Double.parseDouble(totalMarkStr);

           
            // Tak perlu role-based weighting jika hanya lecturer menilai
                double weightedScore = totalMark;

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formsDB = new FormsDB(conn);
                formsDB.saveFormF9(studentId, role, weightedScore, evaluationDate);
            }

            response.sendRedirect("Form.jsp?success=F9submitted");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=F9SubmitError");
        }
    }
}
