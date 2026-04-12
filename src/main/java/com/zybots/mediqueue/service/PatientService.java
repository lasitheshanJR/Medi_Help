package com.zybots.mediqueue.service;

import com.zybots.mediqueue.model.Patient;
import com.zybots.mediqueue.model.Role; // ✅ IMPORTANT
import com.zybots.mediqueue.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    // 1. CREATE
    public Patient registerPatient(Patient patient) {
        // ✅ FIX: Set role before saving (prevents 500 error)
        patient.setRole(Role.PATIENT);
        return patientRepository.save(patient);
    }

    // 2. READ (All Patients)
    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    // 3. READ (Single Patient by ID)
    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    // 4. UPDATE
    public Patient updatePatient(Long id, Patient updatedDetails) {
        return patientRepository.findById(id).map(existingPatient -> {

            existingPatient.setName(updatedDetails.getName());
            existingPatient.setPhone(updatedDetails.getPhone());
            existingPatient.setMedicalHistory(updatedDetails.getMedicalHistory());

            // ⚠️ DO NOT overwrite role/email/password here
            return patientRepository.save(existingPatient);

        }).orElseThrow(() -> new RuntimeException("Patient with ID " + id + " not found!"));
    }

    // 5. DELETE
    public void deletePatient(Long id) {
        if (patientRepository.existsById(id)) {
            patientRepository.deleteById(id);
        } else {
            throw new RuntimeException("Patient with ID " + id + " not found!");
        }
    }
}