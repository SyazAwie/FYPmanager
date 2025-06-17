package fyp.model;

public class Teach {
    private int teach_id;
    private int course_id;
    private int lect_id;

    public Teach(int teach_id, int course_id, int lect_id) {
        this.teach_id = teach_id;
        this.course_id = course_id;
        this.lect_id = lect_id;
    }

    // Getters
    public int getTeach_id() {
        return teach_id;
    }

    public int getCourse_id() {
        return course_id;
    }

    public int getLect_id() {
        return lect_id;
    }

    // Setters
    public void setTeach_id(int teach_id) {
        this.teach_id = teach_id;
    }

    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public void setLect_id(int lect_id) {
        this.lect_id = lect_id;
    }
}
