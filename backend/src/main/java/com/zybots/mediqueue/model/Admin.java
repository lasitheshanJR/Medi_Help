package com.zybots.mediqueue.model;

import jakarta.persistence.*;

@Entity
@Table(name = "admins")
public class Admin extends User {
    
    private String hospitalIdPhotoPath;

    public Admin() {
    }

    public String getHospitalIdPhotoPath() {
        return hospitalIdPhotoPath;
    }

    public void setHospitalIdPhotoPath(String hospitalIdPhotoPath) {
        this.hospitalIdPhotoPath = hospitalIdPhotoPath;
    }
}
