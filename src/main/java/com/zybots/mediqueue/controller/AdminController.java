package com.zybots.mediqueue.controller;

import com.zybots.mediqueue.model.Patient;
import com.zybots.mediqueue.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private PatientService patientService;

    // Admin dashboard endpoint to view all registered patients
    @GetMapping("/patients")
    public ResponseEntity<List<Patient>> viewAllPatients() {
        return ResponseEntity.ok(patientService.getAllPatients());
    }
    
    // You can add DoctorService here later to view all doctors too!
}
