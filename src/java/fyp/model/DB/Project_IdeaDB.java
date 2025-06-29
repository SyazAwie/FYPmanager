package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Project_Idea;
import DBconnection.DatabaseConnection;

public class Project_IdeaDB {

    // Insert a new project idea
    public static boolean insertProjectIdea(Project_Idea idea, String fileName) {
        String sql = "INSERT INTO project_idea (title, description, status, student_id, supervisor_id, scope) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, idea.getTitle());
            stmt.setString(2, fileName); // or idea.getDescription()
            stmt.setString(3, idea.getStatus());
            stmt.setInt(4, idea.getStudent_id());

            // Handle NULL supervisor_id
            if (idea.getSupervisor_id() == null || idea.getSupervisor_id() == 0) {
                stmt.setNull(5, Types.INTEGER);
            } else {
                stmt.setInt(5, idea.getSupervisor_id());
            }

            stmt.setString(6, idea.getScope());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // Get all project ideas
    public List<Project_Idea> getAllProjectIdeas() {
        List<Project_Idea> ideas = new ArrayList<>();
        String sql = "SELECT * FROM project_idea";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Project_Idea idea = mapResultSetToProjectIdea(rs);
                ideas.add(idea);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ideas;
    }

    // Get project idea by ID
    public Project_Idea getProjectIdeaById(int ideaId) {
        String sql = "SELECT * FROM project_idea WHERE projectIdea_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ideaId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProjectIdea(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get project ideas by student ID
    public List<Project_Idea> getProjectIdeasByStudentId(int studentId) {
        List<Project_Idea> ideas = new ArrayList<>();
        String sql = "SELECT * FROM project_idea WHERE student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Project_Idea idea = mapResultSetToProjectIdea(rs);
                    ideas.add(idea);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ideas;
    }

    // Get project ideas by supervisor ID
    public List<Project_Idea> getProjectIdeasBySupervisorId(int supervisorId) {
        List<Project_Idea> ideas = new ArrayList<>();
        String sql = "SELECT * FROM project_idea WHERE supervisor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supervisorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Project_Idea idea = mapResultSetToProjectIdea(rs);
                    ideas.add(idea);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ideas;
    }

    // Get project ideas by status
    public List<Project_Idea> getProjectIdeasByStatus(String status) {
        List<Project_Idea> ideas = new ArrayList<>();
        String sql = "SELECT * FROM project_idea WHERE status = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Project_Idea idea = mapResultSetToProjectIdea(rs);
                    ideas.add(idea);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ideas;
    }

    // Update project idea
    public boolean updateProjectIdea(Project_Idea idea) {
        String sql = "UPDATE project_idea SET title = ?, scope=?, description = ?, status = ?, " +
                     "student_id = ?, supervisor_id = ? WHERE projectIdea_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, idea.getTitle());
            stmt.setString(2, idea.getScope());
            stmt.setString(3, idea.getDescription());
            stmt.setString(4, idea.getStatus());
            stmt.setInt(5, idea.getStudent_id());
            stmt.setInt(6, idea.getSupervisor_id());
            stmt.setInt(7, idea.getProjectIdea_id());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update project idea status only
    public boolean updateProjectIdeaStatus(int ideaId, String newStatus) {
        String sql = "UPDATE project_idea SET status = ? WHERE projectIdea_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, ideaId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete project idea
    public boolean deleteProjectIdea(int ideaId) {
        String sql = "DELETE FROM project_idea WHERE projectIdea_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ideaId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Project_Idea object
    private Project_Idea mapResultSetToProjectIdea(ResultSet rs) throws SQLException {
        Project_Idea idea = new Project_Idea();
        idea.setProjectIdea_id(rs.getInt("projectIdea_id"));
        idea.setTitle(rs.getString("title"));
        idea.setDescription(rs.getString("description"));
        idea.setStatus(rs.getString("status"));
        idea.setStudent_id(rs.getInt("student_id"));
        idea.setSupervisor_id(rs.getInt("supervisor_id"));
        return idea;
    }
    
    public static Project_Idea getProposalByStudentId(int studentId) {
        String sql = "SELECT * FROM project_idea WHERE student_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Project_Idea idea = new Project_Idea();
                idea.setProjectIdea_id(rs.getInt("projectIdea_id"));
                idea.setTitle(rs.getString("title"));
                idea.setDescription(rs.getString("description"));
                idea.setStatus(rs.getString("status"));
                idea.setStudent_id(rs.getInt("student_id"));
                idea.setSupervisor_id(rs.getInt("supervisor_id"));
                idea.setScope(rs.getString("scope"));
                return idea;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean updateProposal(Project_Idea idea) {
        String sql = "UPDATE project_idea SET title=?, description=?, scope=? WHERE projectIdea_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, idea.getTitle());
            stmt.setString(2, idea.getDescription());
            stmt.setString(3, idea.getScope());
            stmt.setInt(4, idea.getProjectIdea_id());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteProposal(int proposalId) {
        String sql = "DELETE FROM project_idea WHERE projectIdea_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, proposalId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}