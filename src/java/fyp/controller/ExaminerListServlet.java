package fyp.controller;

import fyp.model.*;
import fyp.model.DB.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/ExaminerListServlet")
public class ExaminerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ExaminerDisplayDAO dao = new ExaminerDisplayDAO();
        List<ExaminerDisplayDTO> examinerList = dao.getAllExaminers();

        request.setAttribute("examinerList", examinerList);
        request.getRequestDispatcher("ExaminerList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println(">>> doPost() called in ExaminerListServlet");

        try {
            int examinerId = Integer.parseInt(request.getParameter("examiner_id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phoneNum = request.getParameter("phoneNum");

            HttpSession session = request.getSession();
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj == null) {
                response.sendRedirect("Login.jsp?error=sessionexpired");
                return;
            }
            int adminId = Integer.parseInt(userIdObj.toString());

            // Insert into users table
            User user = new User();
            user.setUser_id(examinerId);
            user.setName(name);
            user.setEmail(email);
            user.setPhoneNum(phoneNum);
            user.setRole("examiner");
            user.setPassword(UserDB.hashPassword(String.valueOf(examinerId)));
            user.setAvatar("default.png");

            UserDB userDB = new UserDB();
            userDB.insertUser(user);
            System.out.println("Inserted examiner into USERS table");

            // Insert into examiner table
            Examiner examiner = new Examiner();
            examiner.setExaminer_id(examinerId);
            examiner.setAssigned_project(0); // default to 0
            examiner.setAdmin_id(adminId);

            ExaminerDB examinerDB = new ExaminerDB();
            examinerDB.insertExaminer(examiner);
            System.out.println("Inserted into EXAMINER table");

            response.sendRedirect("ExaminerListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
