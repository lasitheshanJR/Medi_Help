package com.zybots.mediqueue.service;

import com.zybots.mediqueue.model.Appointment;
import com.zybots.mediqueue.model.AppointmentStatus;
import com.zybots.mediqueue.model.Patient;
import com.zybots.mediqueue.model.Doctor;
import com.zybots.mediqueue.repository.AppointmentRepository;
import com.zybots.mediqueue.repository.PatientRepository;
import com.zybots.mediqueue.repository.DoctorRepository;
import com.zybots.mediqueue.dto.AppointmentRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;

    public AppointmentService(AppointmentRepository appointmentRepository,
                              PatientRepository patientRepository,
                              DoctorRepository doctorRepository) {
        this.appointmentRepository = appointmentRepository;
        this.patientRepository = patientRepository;
        this.doctorRepository = doctorRepository;
    }

    // ✅ FIXED METHOD
    public Appointment bookAppointment(AppointmentRequest request) {

        Appointment appointment = new Appointment();

        Patient patient = patientRepository.findById(request.getPatientId())
            .orElseThrow(() -> new RuntimeException("Patient not found"));

        Doctor doctor = doctorRepository.findById(request.getDoctorId())
            .orElseThrow(() -> new RuntimeException("Doctor not found"));

        appointment.setPatient(patient);
        appointment.setDoctor(doctor);

        // Generate the token number for the doctor queue
        List<Appointment> existingQueue = appointmentRepository.findByDoctorIdOrderByTokenNumberAsc(doctor.getId());
        int nextToken = existingQueue.isEmpty() ? 1 : (existingQueue.get(existingQueue.size() - 1).getTokenNumber() == null ? existingQueue.size() + 1 : existingQueue.get(existingQueue.size() - 1).getTokenNumber() + 1);
        appointment.setTokenNumber(nextToken);

        appointment.setStatus(AppointmentStatus.PENDING);

        // Use the requested estimated time, if provided, otherwise default to +15 mins
        if (request.getEstimatedTime() != null) {
            appointment.setEstimatedTime(request.getEstimatedTime());
        } else {
            appointment.setEstimatedTime(java.time.LocalDateTime.now().plusMinutes(15));
        }

        return appointmentRepository.save(appointment);
    }
    
    public List<Appointment> getQueueForDoctor(Long doctorId) {
        return appointmentRepository.findByDoctorIdOrderByTokenNumberAsc(doctorId);
    }

    public List<Appointment> getAppointmentsForPatient(Long patientId) {
        return appointmentRepository.findByPatientId(patientId);
    }
}