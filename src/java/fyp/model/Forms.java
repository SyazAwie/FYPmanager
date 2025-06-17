package fyp.model;

public class Forms {
    private int form_id;
    private String form_code;
    private String form_name;
    private String description;
    private String access_role;
    private String formDate;
    private String submitted_by;
    private String submitted_to;
    private String submitted_date;
    private String status;
    private Double score;
    private String remarks;
    private int student_id;
    private int lecturer_id;
    private int supervisor_id;
    private int admin_id;
    private int examinerId;

    public Forms(int form_id, String form_code, String form_name, String description, String access_role, String formDate,
                 String submitted_by, String submitted_to, String submitted_date, String status, Double score,
                 String remarks, int student_id, int lecturer_id, int supervisor_id, int admin_id, int examinerId) {
        this.form_id = form_id;
        this.form_code = form_code;
        this.form_name = form_name;
        this.description = description;
        this.access_role = access_role;
        this.formDate = formDate;
        this.submitted_by = submitted_by;
        this.submitted_to = submitted_to;
        this.submitted_date = submitted_date;
        this.status = status;
        this.score = score;
        this.remarks = remarks;
        this.student_id = student_id;
        this.lecturer_id = lecturer_id;
        this.supervisor_id = supervisor_id;
        this.admin_id = admin_id;
        this.examinerId = examinerId;
    }

    // Getters and setters (only showing a few for brevity, but include all in your actual file)
    public int getForm_id() {
        return form_id;
    }

    public void setForm_id(int form_id) {
        this.form_id = form_id;
    }

    public String getForm_code() {
        return form_code;
    }

    public void setForm_code(String form_code) {
        this.form_code = form_code;
    }

    public String getForm_name() {
        return form_name;
    }

    public void setForm_name(String form_name) {
        this.form_name = form_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAccess_role() {
        return access_role;
    }

    public void setAccess_role(String access_role) {
        this.access_role = access_role;
    }

    public String getFormDate() {
        return formDate;
    }

    public void setFormDate(String formDate) {
        this.formDate = formDate;
    }

    public String getSubmitted_by() {
        return submitted_by;
    }

    public void setSubmitted_by(String submitted_by) {
        this.submitted_by = submitted_by;
    }

    public String getSubmitted_to() {
        return submitted_to;
    }

    public void setSubmitted_to(String submitted_to) {
        this.submitted_to = submitted_to;
    }

    public String getSubmitted_date() {
        return submitted_date;
    }

    public void setSubmitted_date(String submitted_date) {
        this.submitted_date = submitted_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public int getLecturer_id() {
        return lecturer_id;
    }

    public void setLecturer_id(int lecturer_id) {
        this.lecturer_id = lecturer_id;
    }

    public int getSupervisor_id() {
        return supervisor_id;
    }

    public void setSupervisor_id(int supervisor_id) {
        this.supervisor_id = supervisor_id;
    }

    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }

    public int getExaminerId() {
        return examinerId;
    }

    public void setExaminerId(int examinerId) {
        this.examinerId = examinerId;
    }
}
