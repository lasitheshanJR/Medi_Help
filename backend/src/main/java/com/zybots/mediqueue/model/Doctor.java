package com.zybots.mediqueue.model;

import jakarta.persistence.*;

@Entity
@Table(name = "doctors")
public class Doctor extends User {
    private String specialization;
    private String currentStatus; 
    private String idPhotoPath;

    public Doctor() {
    }

    // --- Getters and Setters ---

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getCurrentStatus() { return currentStatus; }
    public void setCurrentStatus(String currentStatus) { this.currentStatus = currentStatus; }

    public String getIdPhotoPath() { return idPhotoPath; }
    public void setIdPhotoPath(String idPhotoPath) { this.idPhotoPath = idPhotoPath; }
}