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

@WebServlet("/F3Servlet")
public class F3Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formsDB = new FormsDB(conn);
                Map<String, String> formData = formsDB.getFormDataByCode(userId, "F3");

                for (Map.Entry<String, String> entry : formData.entrySet()) {
                    request.setAttribute(entry.getKey(), entry.getValue());
                }

                request.getRequestDispatcher("f3.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // Get parameters
            String studentName = request.getParameter("studentName");
            String studentIdStr = request.getParameter("studentId");
            String projectTitle = request.getParameter("projectTitle");
            String lecturerName = request.getParameter("lecturerName");
            String remarks = request.getParameter("remarks");

            String litComment = request.getParameter("literatureComment");
            String analysisComment = request.getParameter("analysisComment");
            String clarityComment = request.getParameter("clarityComment");

            double score1 = parseDouble(request.getParameter("score1"));
            double score2 = parseDouble(request.getParameter("score2"));
            double score3 = parseDouble(request.getParameter("score3"));
            double totalScore = (score1 * 0.4) + (score2 * 0.4) + (score3 * 0.2);

            int studentId = Integer.parseInt(studentIdStr);
            int lecturerId = (int) session.getAttribute("userId");

            String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

            // Create Forms object
            Forms form = new Forms(
                    0,
                    "F3",
                    "Literature Review Evaluation",
                    litComment + " | " + analysisComment + " | " + clarityComment,
                    "lecturer",
                    today,
                    lecturerName,
                    studentIdStr,
                    today,
                    "Submitted",
                    totalScore,
                    remarks,
                    studentId,
                    lecturerId,
                    0,
                    0,
                    0
            );

            // Insert form
            Connection conn = DatabaseConnection.getConnection();
            FormsDB formsDB = new FormsDB(conn);
            formsDB.insertForm(form);

            response.sendRedirect("formSuccess.jsp?form=F3");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F3");
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
