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
@WebServlet("/StudentListServlet")
public class StudentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Panggil DAO
        StudentDisplayDAO dao = new StudentDisplayDAO();
        List<StudentDisplayDTO> studentList = dao.getStudentsByCourse("CSP600");


        // Simpan dalam request
        request.setAttribute("studentList", studentList);

        // Forward ke JSP
        RequestDispatcher rd = request.getRequestDispatcher("CSP600.jsp");
        rd.forward(request, response);
       
    }
}

