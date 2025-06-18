/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fyp.controller;
import fyp.model.*;
import fyp.model.DB.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;
import java.io.*;
import javax.servlet.annotation.WebServlet;
/**
 *
 * @author syazw
 */
@WebServlet("/StudentList")
public class StudentListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String course = request.getParameter("course"); // example: "1" for CSP600, "2" for CSP650
        if (course == null || course.isEmpty()) {
            course = "1"; // Default to CSP600
        }

        StudentDisplayDAO dao = new StudentDisplayDAO();
        List<StudentDisplayDTO> studentList = dao.getStudentsByCourse(course); // passing course_id directly

        request.setAttribute("studentList", studentList);

        // Direct to the correct JSP based on course_id
        if ("2".equals(course)) {
            request.getRequestDispatcher("CSP650.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("CSP600.jsp").forward(request, response);
        }
    }
}
