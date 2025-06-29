package fyp.model;

public class Admin {
    private String userId;
    private String email;

    // Constructor
    public Admin(String userId, String email) {
        this.userId = userId;
        this.email = email;
    }

    // Empty constructor (optional)
    public Admin() {}

    // Getters
    public String getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    // Setters
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
