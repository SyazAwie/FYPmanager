package fyp.model;

public class ProgressLog {
    private int progress_id;
    private String update_date;
    private String description;
    private String next_meeting;
    private int project_id;

    public ProgressLog(int progress_id, String update_date, String description, String next_meeting, int project_id) {
        this.progress_id = progress_id;
        this.update_date = update_date;
        this.description = description;
        this.next_meeting = next_meeting;
        this.project_id = project_id;
    }

    // Getters
    public int getProgress_id() {
        return progress_id;
    }

    public String getUpdate_date() {
        return update_date;
    }

    public String getDescription() {
        return description;
    }

    public String getNext_meeting() {
        return next_meeting;
    }

    public int getProject_id() {
        return project_id;
    }

    // Setters
    public void setProgress_id(int progress_id) {
        this.progress_id = progress_id;
    }

    public void setUpdate_date(String update_date) {
        this.update_date = update_date;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setNext_meeting(String next_meeting) {
        this.next_meeting = next_meeting;
    }

    public void setProject_id(int project_id) {
        this.project_id = project_id;
    }
}
