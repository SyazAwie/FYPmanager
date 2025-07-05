package fyp.controller;

import fyp.model.DB.FormsDB;
import fyp.model.Forms;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/F13Servlet")
public class F13Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("f13.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp?error=sessionExpired");
            return;
        }

        int submittedBy = Integer.parseInt(session.getAttribute("userId").toString());
        String role = (String) session.getAttribute("role");

        // Get form data
        String studentName = request.getParameter("studentName");
        String studentIdStr = request.getParameter("studentId");
        String projectTitle = request.getParameter("projectTitle");
        String reviewerName = request.getParameter("reviewerName");
        String evaluationDateStr = request.getParameter("evaluationDate");
        String scoreStr = request.getParameter("totalMarks");

        // Validate
        if (studentName == null || studentIdStr == null || reviewerName == null || evaluationDateStr == null || scoreStr == null) {
            response.sendRedirect("f13.jsp?error=missingFields");
            return;
        }

        int studentId = Integer.parseInt(studentIdStr);
        double score = Double.parseDouble(scoreStr);
        Date evaluationDate = Date.valueOf(evaluationDateStr);

        // Prepare Forms object
        Forms form = new Forms(
            0, // form_id (auto)
            "F13", // form_code
            "Business Model Canvas Evaluation", // form_name
            projectTitle, // description
            role, // access_role
            evaluationDate.toString(), // formDate
            String.valueOf(submittedBy), // submitted_by
            String.valueOf(studentId), // submitted_to
            Date.valueOf(LocalDate.now()).toString(), // submitted_date
            "Submitted", // status
            score, // score
            null, // remarks
            studentId, // student_id
            0, // lecturer_id
            role.equals("supervisor") ? submittedBy : 0, // supervisor_id
            0, // admin_id
            role.equals("examiner") ? submittedBy : 0 // examiner_id
        );

        boolean success = FormsDB.saveF13Form(form);

        if (success) {
            response.sendRedirect("f13.jsp?success=1");
        } else {
            response.sendRedirect("f13.jsp?error=dbError");
        }
    }
}
