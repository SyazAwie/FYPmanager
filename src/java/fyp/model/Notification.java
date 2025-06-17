package fyp.model;

public class Notification {
    private int notification_id;
    private String role;
    private String title;
    private String message;
    private String sent_at;
    private boolean is_read;
    private int user_id;

    public Notification(int notification_id, String role, String title, String message, String sent_at, boolean is_read, int user_id) {
        this.notification_id = notification_id;
        this.role = role;
        this.title = title;
        this.message = message;
        this.sent_at = sent_at;
        this.is_read = is_read;
        this.user_id = user_id;
    }

    // Getters
    public int getNotification_id() {
        return notification_id;
    }

    public String getRole() {
        return role;
    }

    public String getTitle() {
        return title;
    }

    public String getMessage() {
        return message;
    }

    public String getSent_at() {
        return sent_at;
    }

    public boolean isIs_read() {
        return is_read;
    }

    public int getUser_id() {
        return user_id;
    }

    // Setters
    public void setNotification_id(int notification_id) {
        this.notification_id = notification_id;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setSent_at(String sent_at) {
        this.sent_at = sent_at;
    }

    public void setIs_read(boolean is_read) {
        this.is_read = is_read;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }
}
