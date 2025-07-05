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

@WebServlet("/F11Servlet")
public class F11Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            int userId = Integer.parseInt(session.getAttribute("userId").toString());

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formsDB = new FormsDB(conn);

                // 1. Load existing F11 data if available
                Map<String, String> formData = formsDB.getFormF11Data(userId);
                for (Map.Entry<String, String> entry : formData.entrySet()) {
                    request.setAttribute(entry.getKey(), entry.getValue());
                }

                // 2. Get supervisor & examiner score
                Double supervisorScore = formsDB.getF11ScoreByRole(userId, "supervisor");
                Double examinerScore = formsDB.getF11ScoreByRole(userId, "examiner");

                if (supervisorScore != null)
                    request.setAttribute("supervisorScore", supervisorScore);

                if (examinerScore != null)
                    request.setAttribute("examinerScore", examinerScore);

                // 3. Final Score = (supervisor × 25%) + (examiner × 20%)
                double finalScore = 0.0;
                if (supervisorScore != null) finalScore += supervisorScore;
                if (examinerScore != null) finalScore += examinerScore;

                if (supervisorScore != null || examinerScore != null)
                    request.setAttribute("finalScore", finalScore);
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("f11.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=F11FormLoadError");
        }
    }
}
