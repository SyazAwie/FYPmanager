package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Project;
import DBconnection.DatabaseConnection;

public class ProjectDB {

    public void insertProject(Project project) {
        String sql = "INSERT INTO PROJECT (project_id, projectTitle, project_type, submission_date, projectIdea_id, supervisor_id, student_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, project.getProject_id());
            stmt.setString(2, project.getProjectTitle());
            stmt.setString(3, project.getProject_type());
            stmt.setString(4, project.getSubmission_date());
            stmt.setInt(5, project.getProjectIdea_id());
            stmt.setInt(6, project.getSupervisor_id());
            stmt.setInt(7, project.getStudent_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Project> getAllProjects() {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT * FROM PROJECT";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Project project = new Project(
                    rs.getInt("project_id"),
                    rs.getString("projectTitle"),
                    rs.getString("project_type"),
                    rs.getString("submission_date"),
                    rs.getInt("projectIdea_id"),
                    rs.getInt("supervisor_id"),
                    rs.getInt("student_id")
                );
                projects.add(project);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return projects;
    }

    public void updateProject(Project project) {
        String sql = "UPDATE PROJECT SET projectTitle = ?, project_type = ?, submission_date = ?, projectIdea_id = ?, supervisor_id = ?, student_id = ? WHERE project_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, project.getProjectTitle());
            stmt.setString(2, project.getProject_type());
            stmt.setString(3, project.getSubmission_date());
            stmt.setInt(4, project.getProjectIdea_id());
            stmt.setInt(5, project.getSupervisor_id());
            stmt.setInt(6, project.getStudent_id());
            stmt.setInt(7, project.getProject_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteProject(int projectId) {
        String sql = "DELETE FROM PROJECT WHERE project_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, projectId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
