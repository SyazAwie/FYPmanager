package fyp.controller;

import fyp.model.*;
import fyp.model.DB.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/SupervisorListServlet")
public class SupervisorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SupervisorDisplayDAO dao = new SupervisorDisplayDAO();
        List<SupervisorDisplayDTO> supervisorList = dao.getAllSupervisors();

        request.setAttribute("supervisorList", supervisorList);
        request.getRequestDispatcher("SupervisorList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println(">>> doPost() called in SupervisorListServlet");

        try {
            int supervisorId = Integer.parseInt(request.getParameter("supervisor_id"));
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
            user.setUser_id(supervisorId);
            user.setName(name);
            user.setEmail(email);
            user.setPhoneNum(phoneNum);
            user.setRole("supervisor");
            user.setPassword(UserDB.hashPassword(String.valueOf(supervisorId)));
            user.setAvatar("default.png");

            UserDB userDB = new UserDB();
            userDB.insertUser(user);
            System.out.println("Inserted supervisor into USERS table");

            // Insert into supervisor table
            Supervisor supervisor = new Supervisor();
            supervisor.setSupervisor_id(supervisorId);
            supervisor.setQuota(5); // default quota, boleh ubah ikut keperluan
            supervisor.setRoleOfInterest("N/A");
            supervisor.setPastProject("N/A");
            supervisor.setAdmin_id(adminId);

            SupervisorDB supervisorDB = new SupervisorDB();
            supervisorDB.insertSupervisor(supervisor);
            System.out.println("Inserted into SUPERVISOR table");

            response.sendRedirect("SupervisorListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
