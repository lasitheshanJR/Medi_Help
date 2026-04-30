package com.zybots.mediqueue.repository;

import com.zybots.mediqueue.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    // This finds all appointments for a doctor, ordered by token number
    List<Appointment> findByDoctorIdOrderByTokenNumberAsc(Long doctorId);

    // This finds all appointments for a patient
    List<Appointment> findByPatientId(Long patientId);
}