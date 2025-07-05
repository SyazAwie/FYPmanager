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

@WebServlet("/F10Servlet")
public class F10Servlet extends HttpServlet {
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
                
                // Optional: prefill data (kalau ada)
                // Map<String, String> formData = formsDB.getFormF10Data(userId);
                // for (Map.Entry<String, String> entry : formData.entrySet()) {
                //     request.setAttribute(entry.getKey(), entry.getValue());
                // }

                // Fetch supervisor and examiner scores for F10
                Double supervisorScore = formsDB.getF10ScoreByRole(userId, "supervisor");
                Double examinerScore = formsDB.getF10ScoreByRole(userId, "examiner");

                // Send them to JSP
                if (supervisorScore != null)
                    request.setAttribute("supervisorScore", supervisorScore);

                if (examinerScore != null)
                    request.setAttribute("examinerScore", examinerScore);

                // Calculate final combined score: 15% + 15%
                double finalScore = 0.0;
                if (supervisorScore != null) finalScore += supervisorScore;
                if (examinerScore != null) finalScore += examinerScore;

                if (supervisorScore != null || examinerScore != null)
                    request.setAttribute("finalScore", finalScore);
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("f10.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=F10FormLoadError");
        }
    }
}
