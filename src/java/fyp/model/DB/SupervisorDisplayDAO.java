package fyp.model.DB;

import fyp.model.SupervisorDisplayDTO;
import DBconnection.DatabaseConnection;

import java.sql.*;
import java.util.*;

public class SupervisorDisplayDAO {
    public List<SupervisorDisplayDTO> getAllSupervisors() {
        List<SupervisorDisplayDTO> list = new ArrayList<>();

        String sql = "SELECT u.name, u.email, u.phoneNum, s.supervisor_id " +
                     "FROM supervisor s " +
                     "JOIN users u ON s.supervisor_id = u.user_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                SupervisorDisplayDTO dto = new SupervisorDisplayDTO();
                dto.setName(rs.getString("name"));
                dto.setEmail(rs.getString("email"));
                dto.setPhoneNum(rs.getString("phoneNum"));
                dto.setStaffId(rs.getInt("supervisor_id"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
