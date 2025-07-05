package fyp.controller;

import DBconnection.DatabaseConnection;
import fyp.model.DB.FormsDB;
import fyp.model.Forms;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/F5Servlet")
public class F5Servlet extends HttpServlet {

    // ========== DO GET: Prefill ==========
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
        String role = (String) session.getAttribute("role");

        try (Connection conn = DatabaseConnection.getConnection()) {
            FormsDB formsDB = new FormsDB(conn);

            // Get studentId from session (if student) or from project_idea (if supervisor)
            int studentId = ("student".equals(role)) ? userId : formsDB.getStudentIdBySupervisor(userId);

            // Prefill form fields (studentName, studentId, projectTitle)
            Map<String, String> formData = formsDB.getFormF2Data(studentId);
            for (Map.Entry<String, String> entry : formData.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }

            // Fetch form_id for F5
            int formId = formsDB.getFormIdByStudentAndCode(studentId, "F5");

            // Get F5 logs from f5_logs table
            List<Map<String, String>> f5logs = formsDB.getF5Logs(formId);
            request.setAttribute("f5logs", f5logs);

            request.getRequestDispatcher("f5.jsp").forward(request, response);
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("formError.jsp?form=F5");
    }
}


    // ========== DO POST: Submit F5 ==========
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        try {
            int userId = Integer.parseInt(String.valueOf(session.getAttribute("userId")));
            String role = (String) session.getAttribute("role");

            String studentName = request.getParameter("studentName");
            String studentIdStr = request.getParameter("studentId");
            String projectTitle = request.getParameter("projectTitle");
            int studentId = Integer.parseInt(studentIdStr);

            // Read table arrays
            String[] dates = request.getParameterValues("date[]");
            String[] completed = request.getParameterValues("completed[]");
            String[] next = request.getParameterValues("next[]");
            String[] signatures = request.getParameterValues("signature[]");

            StringBuilder description = new StringBuilder();
            if (dates != null) {
                for (int i = 0; i < dates.length; i++) {
                    description.append("Meeting ").append(i + 1).append(": ");
                    description.append("Date: ").append(dates[i]).append(" | ");
                    description.append("Completed: ").append(completed[i] != null ? completed[i] : "").append(" | ");
                    description.append("Next: ").append(next[i] != null ? next[i] : "").append(" | ");
                    description.append("Signature: ").append(signatures[i] != null ? signatures[i] : "").append(" || ");

                }
            }

            String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
            String submittedBy = role;
            String submittedTo = ""; // Optional - future use

            int lecturerId = "lecturer".equals(role) ? userId : 0;
            int supervisorId = "supervisor".equals(role) ? userId : 0;

            Forms form = new Forms(
                    0,
                    "F5",
                    "Project In-Progress Form",
                    description.toString(),
                    submittedBy,
                    today,
                    submittedBy,
                    submittedTo,
                    today,
                    "Submitted",
                    0.0,
                    null,
                    studentId,
                    lecturerId,
                    supervisorId,
                    0,
                    0
            );

            try (Connection conn = DatabaseConnection.getConnection()) {
                FormsDB formDB = new FormsDB(conn);
                formDB.saveOrUpdateForm(form);

                int formId = formDB.getFormIdByStudentAndCode(studentId, "F5");
                formDB.insertF5Logs(formId, dates, completed, next, signatures);

                response.sendRedirect("formSuccess.jsp?form=F5");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("formError.jsp?form=F5");
        }
    }
}
