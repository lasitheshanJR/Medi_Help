package com.zybots.mediqueue.service;

import com.zybots.mediqueue.model.Doctor;
import com.zybots.mediqueue.model.Role; // ✅ IMPORTANT FIX
import com.zybots.mediqueue.repository.DoctorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DoctorService {

    @Autowired
    private DoctorRepository doctorRepository;

    // CREATE
    public Doctor registerDoctor(Doctor doctor) {
        doctor.setRole(Role.DOCTOR); // ✅ SET ROLE HERE
        return doctorRepository.save(doctor);
    }

    // READ (All)
    public List<Doctor> getAllDoctors() {
        return doctorRepository.findAll();
    }

    // READ (Single)
    public Optional<Doctor> getDoctorById(Long id) {
        return doctorRepository.findById(id);
    }

    // UPDATE
    public Doctor updateDoctor(Long id, Doctor updatedDetails) {
        return doctorRepository.findById(id).map(existingDoctor -> {
            existingDoctor.setName(updatedDetails.getName());
            existingDoctor.setSpecialization(updatedDetails.getSpecialization());
            existingDoctor.setPhone(updatedDetails.getPhone());
            existingDoctor.setCurrentStatus(updatedDetails.getCurrentStatus());
            return doctorRepository.save(existingDoctor);
        }).orElseThrow(() -> new RuntimeException("Doctor with ID " + id + " not found!"));
    }

    // DELETE
    public void deleteDoctor(Long id) {
        if (doctorRepository.existsById(id)) {
            doctorRepository.deleteById(id);
        } else {
            throw new RuntimeException("Doctor with ID " + id + " not found!");
        }
    }
}