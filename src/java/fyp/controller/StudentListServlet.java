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
    
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    System.out.println(">>> doPost() called in StudentListServlet");

    try {
        int studentId = Integer.parseInt(request.getParameter("student_id"));
        int semester = Integer.parseInt(request.getParameter("semester"));
        String intake = request.getParameter("intake");
        int courseId = Integer.parseInt(request.getParameter("course_id"));

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            response.sendRedirect("Login.jsp?error=sessionexpired");
            return;
        }
        int adminId = Integer.parseInt(userIdObj.toString());


        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNum = request.getParameter("phoneNum");

        System.out.println("Student ID: " + studentId);
        System.out.println("Course ID: " + courseId);
        System.out.println("Admin ID: " + adminId);

        // users table
        User user = new User();
        user.setUser_id(studentId);
        user.setName(name);
        user.setEmail(email);
        user.setPhoneNum(phoneNum);
        user.setRole("student");
        user.setPassword(UserDB.hashPassword(String.valueOf(studentId)));
        user.setAvatar("default.png");

        UserDB userDB = new UserDB();
        userDB.insertUser(user);
        System.out.println("Inserted user to USERS table");

        // student table
        Student student = new Student();
        student.setStudent_id(studentId);
        student.setSemester(semester);
        student.setIntake(intake);
        student.setCourse_id(courseId);
        student.setAdmin_id(adminId); 

        StudentDB studentDB = new StudentDB();
        studentDB.insertStudent(student);
        System.out.println("Inserted student to STUDENT table");

        response.sendRedirect("StudentListServlet?course=" + courseId);

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}


}
