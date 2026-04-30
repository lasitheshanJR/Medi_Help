package com.zybots.mediqueue.dto;

import java.time.LocalDateTime;

public class AppointmentRequest {

    private Long doctorId;
    private Long patientId;
    private LocalDateTime estimatedTime;
    
    private int tokenNumber;

    public int getTokenNumber() {
        return tokenNumber;
    }

    public void setTokenNumber(int tokenNumber) {
        this.tokenNumber = tokenNumber;
    }

    public void setEstimatedTime(LocalDateTime estimatedTime) {
        this.estimatedTime = estimatedTime;
    }

    public Long getDoctorId() {
        return doctorId;
    }

    public Long getPatientId() {
        return patientId;
    }

    public LocalDateTime getEstimatedTime() {
        return estimatedTime;
    }
}