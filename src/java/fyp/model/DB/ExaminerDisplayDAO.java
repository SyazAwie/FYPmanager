package fyp.model.DB;

import fyp.model.ExaminerDisplayDTO;
import DBconnection.DatabaseConnection;

import java.sql.*;
import java.util.*;

public class ExaminerDisplayDAO {
    public List<ExaminerDisplayDTO> getAllExaminers() {
        List<ExaminerDisplayDTO> list = new ArrayList<>();

        String sql = "SELECT u.name, u.email, u.phoneNum, e.examiner_id " +
                     "FROM examiner e " +
                     "JOIN users u ON e.examiner_id = u.user_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ExaminerDisplayDTO dto = new ExaminerDisplayDTO();
                dto.setName(rs.getString("name"));
                dto.setEmail(rs.getString("email"));
                dto.setPhoneNum(rs.getString("phoneNum"));
                dto.setStaffId(rs.getInt("examiner_id"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
