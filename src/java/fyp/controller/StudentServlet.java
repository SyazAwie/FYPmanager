package fyp.controller;

import fyp.model.Supervisor;
import fyp.model.DB.SupervisorDB;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Ambil studentId dari session
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("userId"); // Pastikan "userId" diset masa login

        // Jika tiada studentId, redirect ke login
        if (studentId == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

       // Dapatkan maklumat supervisor berdasarkan studentId dari table project_idea
        Supervisor supervisor = SupervisorDB.getSupervisorByStudentId(studentId);

        // Debug log untuk tengok supervisor dapat atau tidak
        System.out.println("Student ID: " + studentId);
        System.out.println("Supervisor found: " + (supervisor != null ? supervisor.getName() : "NULL"));

        // Hantar maklumat supervisor ke JSP
        request.setAttribute("supervisor", supervisor);

        // Forward ke student dashboard
        RequestDispatcher dispatcher = request.getRequestDispatcher("Dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
