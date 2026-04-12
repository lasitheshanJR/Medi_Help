package com.zybots.mediqueue.repository;

import com.zybots.mediqueue.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientRepository extends JpaRepository<Patient, Long> {
}