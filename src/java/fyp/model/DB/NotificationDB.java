package fyp.model.DB;

import java.sql.*;
import java.util.*;
import fyp.model.Notification;
import DBconnection.DatabaseConnection;

public class NotificationDB {

    // Insert notification
    public void insertNotification(Notification notification) {
        String sql = "INSERT INTO NOTIFICATION (notification_id, role, title, message, sent_at, is_read, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notification.getNotification_id());
            stmt.setString(2, notification.getRole());
            stmt.setString(3, notification.getTitle());
            stmt.setString(4, notification.getMessage());
            stmt.setString(5, notification.getSent_at());
            stmt.setBoolean(6, notification.isIs_read());
            stmt.setInt(7, notification.getUser_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all notifications
    public List<Notification> getAllNotifications() {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM NOTIFICATION";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Notification notification = new Notification(
                    rs.getInt("notification_id"),
                    rs.getString("role"),
                    rs.getString("title"),
                    rs.getString("message"),
                    rs.getString("sent_at"),
                    rs.getBoolean("is_read"),
                    rs.getInt("user_id")
                );
                notifications.add(notification);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    // Update notification
    public void updateNotification(Notification notification) {
        String sql = "UPDATE NOTIFICATION SET role = ?, title = ?, message = ?, sent_at = ?, is_read = ?, user_id = ? WHERE notification_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, notification.getRole());
            stmt.setString(2, notification.getTitle());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getSent_at());
            stmt.setBoolean(5, notification.isIs_read());
            stmt.setInt(6, notification.getUser_id());
            stmt.setInt(7, notification.getNotification_id());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete notification
    public void deleteNotification(int notificationId) {
        String sql = "DELETE FROM NOTIFICATION WHERE notification_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notificationId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
