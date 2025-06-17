package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Course;
import DBconnection.DatabaseConnection;

public class CourseDB {

    // Insert a course
    public void insertCourse(Course course) {
        String sql = "INSERT INTO COURSE (course_id, course_code, courseName) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, course.getCourse_id());
            stmt.setString(2, course.getCourse_code());
            stmt.setString(3, course.getCourseName());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all courses
    public List<Course> getAllCourses() {
        List<Course> courseList = new ArrayList<>();
        String sql = "SELECT * FROM COURSE";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Course course = new Course(
                    rs.getInt("course_id"),
                    rs.getString("course_code"),
                    rs.getString("courseName")
                );
                courseList.add(course);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courseList;
    }

    // Update a course
    public void updateCourse(Course course) {
        String sql = "UPDATE COURSE SET course_code = ?, courseName = ? WHERE course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getCourse_code());
            stmt.setString(2, course.getCourseName());
            stmt.setInt(3, course.getCourse_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete a course
    public void deleteCourse(int courseId) {
        String sql = "DELETE FROM COURSE WHERE course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
