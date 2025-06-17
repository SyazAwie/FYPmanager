package fyp.model;

public class Lecturer {
    private int lecturer_id;
    private int admin_id;

    // Constructor with parameters
    public Lecturer(int lecturer_id, int admin_id) {
        this.lecturer_id = lecturer_id;
        this.admin_id = admin_id;
    }

    // Default constructor
    public Lecturer() {
        this.lecturer_id = 0;
        this.admin_id = 0;
    }

    // Getters and setters
    public int getLecturer_id() {
        return lecturer_id;
    }

    public void setLecturer_id(int lecturer_id) {
        this.lecturer_id = lecturer_id;
    }

    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }
}