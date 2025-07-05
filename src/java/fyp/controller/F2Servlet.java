package fyp.controller;

import fyp.model.DB.FormsDB;
import fyp.model.Forms;
import DBconnection.DatabaseConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;


@WebServlet("/F2Servlet")
public class F2Servlet extends HttpServlet {
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
            Map<String, String> formData = formsDB.getFormF2Data(userId);

            for (Map.Entry<String, String> entry : formData.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            request.getRequestDispatcher("f2.jsp").forward(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String lecturerName = request.getParameter("lecturerName");
        String remarks = request.getParameter("remarks");
        double originality = parseDouble(request.getParameter("score1"));
        double relevance = parseDouble(request.getParameter("score2"));
        double feasibility = parseDouble(request.getParameter("score3"));

        double total = (originality * 0.4) + (relevance * 0.3) + (feasibility * 0.3);
        String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        try {
            Connection conn = DatabaseConnection.getConnection();
            FormsDB formsDB = new FormsDB(conn);

            Forms form = new Forms(
                    0,
                    "F2",
                    "Project Motivation Form",
                    null,
                    "lecturer",
                    today,
                    lecturerName,
                    String.valueOf(studentId),
                    today,
                    "Submitted",
                    total,
                    remarks,
                    studentId,
                    (int) session.getAttribute("userId"),
                    0,
                    0,
                    0
            );

            formsDB.insertForm(form);
            response.sendRedirect("formSuccess.jsp?form=F2");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F2");
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
