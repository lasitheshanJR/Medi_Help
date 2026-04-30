package com.zybots.mediqueue.model;

import jakarta.persistence.*;

@Entity
@Table(name = "patients")
public class Patient extends User {
    
    @Column(name = "medical_history")
    private String medicalHistory;

    // Default constructor is required by JPA/Hibernate
    public Patient() {
    }

    // --- Getters and Setters ---

    public String getMedicalHistory() {
        return medicalHistory;
    }

    public void setMedicalHistory(String medicalHistory) {
        this.medicalHistory = medicalHistory;
    }
}