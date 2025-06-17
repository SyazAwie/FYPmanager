package fyp.controller;

import fyp.model.*;
import fyp.model.DB.*;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Suhailah
 */
public class CourseServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    List<Student> studentList = StudentDB.getAllStudents(); // You’ll need to create this method
    request.setAttribute("studentList", studentList);
    request.getRequestDispatcher("CSP600.jsp").forward(request, response);
}


}
