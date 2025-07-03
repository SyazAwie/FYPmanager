/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fyp.model;

/**
 *
 * @author syazw
 */
public class User {
    private int user_id;
    private String name;
    private String email;
    private String phoneNum;
    private String password;
    private String role;
    private String avatar;

    // Constructor
    public User(int user_id, String name, String email, String phoneNum, String password, String role, String avatar) {
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phoneNum = phoneNum;
        this.password = password;
        this.role = role;
         this.avatar = avatar;
    }

    public User() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    // Getters
    public int getUser_id() {
        return user_id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }
    
    public String getAvatar() {
    return avatar;
}

    // Setters
    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setRole(String role) {
        this.role = role;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}