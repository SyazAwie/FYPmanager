package fyp.model.DB;

import fyp.model.*;

import java.util.List;
import java.util.ArrayList;
import DBconnection.DatabaseConnection;
import java.sql.*;
import java.util.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
/**
 *
 * @author syazw
 */
public class StudentDisplayDAO {
    public List<StudentDisplayDTO> getStudentsByCourse(String courseName) {
        List<StudentDisplayDTO> list = new ArrayList<>();
        String sql = "SELECT u.name AS student_name, s.student_id, c.courseName AS programme, " +
                     "su.name AS supervisor_name " +
                     "FROM student s " +
                     "JOIN users u ON s.student_id = u.user_id " +
                     "JOIN course c ON s.course_id = c.course_id " +
                     "LEFT JOIN project_idea pi ON s.student_id = pi.student_id " +
                     "LEFT JOIN supervisor sp ON pi.supervisor_id = sp.supervisor_id " +
                     "LEFT JOIN users su ON sp.supervisor_id = su.user_id " +
                     "WHERE c.course_code = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, courseName); // contoh "CSP600"
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                StudentDisplayDTO dto = new StudentDisplayDTO();
                dto.setName(rs.getString("student_name"));
                dto.setStudentId(rs.getString("student_id"));
                dto.setProgramme(rs.getString("programme"));
                dto.setSupervisorName(rs.getString("supervisor_name"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

}

