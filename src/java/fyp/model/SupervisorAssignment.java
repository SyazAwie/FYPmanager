package fyp.model;

public class SupervisorAssignment {
    private int assignment_id;
    private String assigned_date;
    private String status;
    private int student_id;
    private int supervisor_id;

    public SupervisorAssignment(int assignment_id, String assigned_date, String status, int student_id, int supervisor_id) {
        this.assignment_id = assignment_id;
        this.assigned_date = assigned_date;
        this.status = status;
        this.student_id = student_id;
        this.supervisor_id = supervisor_id;
    }

    // Getters
    public int getAssignment_id() {
        return assignment_id;
    }

    public String getAssigned_date() {
        return assigned_date;
    }

    public String getStatus() {
        return status;
    }

    public int getStudent_id() {
        return student_id;
    }

    public int getSupervisor_id() {
        return supervisor_id;
    }

    // Setters
    public void setAssignment_id(int assignment_id) {
        this.assignment_id = assignment_id;
    }

    public void setAssigned_date(String assigned_date) {
        this.assigned_date = assigned_date;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public void setSupervisor_id(int supervisor_id) {
        this.supervisor_id = supervisor_id;
    }
}
