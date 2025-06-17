package fyp.model;

public class Examiner {
    private int examiner_id;
    private int assigned_project;
    private int admin_id;

    // Parameterized constructor
    public Examiner(int examiner_id, int assigned_project, int admin_id) {
        this.examiner_id = examiner_id;
        this.assigned_project = assigned_project;
        this.admin_id = admin_id;
    }

    // Default constructor
    public Examiner() {
        this.examiner_id = 0;
        this.assigned_project = 0;
        this.admin_id = 0;
    }

    // Getters and setters
    public int getExaminer_id() {
        return examiner_id;
    }

    public void setExaminer_id(int examiner_id) {
        this.examiner_id = examiner_id;
    }

    public int getAssigned_project() {
        return assigned_project;
    }

    public void setAssigned_project(int assigned_project) {
        this.assigned_project = assigned_project;
    }

    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }
}