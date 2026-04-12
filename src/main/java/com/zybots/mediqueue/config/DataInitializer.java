package com.zybots.mediqueue.config;

import com.zybots.mediqueue.model.Appointment;
import com.zybots.mediqueue.model.AppointmentStatus;
import com.zybots.mediqueue.model.Doctor;
import com.zybots.mediqueue.model.Patient;
import com.zybots.mediqueue.repository.AppointmentRepository;
import com.zybots.mediqueue.repository.DoctorRepository;
import com.zybots.mediqueue.repository.PatientRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.zybots.mediqueue.model.Role;
import java.time.LocalDateTime;
import java.util.List;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(PatientRepository patientRepository,
                                  DoctorRepository doctorRepository,
                                  AppointmentRepository appointmentRepository) {
        return args -> {
            // 1. Seed Doctors
            Doctor drWijesekara = new Doctor();
            drWijesekara.setName("Dr. Wijesekara");
            drWijesekara.setSpecialization("Cardiologist");
            drWijesekara.setCurrentStatus("Active");
            drWijesekara.setPhone("0712345678");
            drWijesekara.setEmail("drw@example.com");
            drWijesekara.setPassword("password123");
            drWijesekara.setRole(Role.DOCTOR);

            Doctor drSilva = new Doctor();
            drSilva.setName("Dr. Silva");
            drSilva.setSpecialization("Dermatologist");
            drSilva.setCurrentStatus("On Break");
            drSilva.setPhone("0719876543");
            drSilva.setEmail("drs@example.com");
            drSilva.setPassword("password123");
            drSilva.setRole(Role.DOCTOR);

            doctorRepository.saveAll(List.of(drWijesekara, drSilva));

            // 2. Seed Patients
            Patient p1 = new Patient();
            p1.setName("John Doe");
            p1.setPhone("0771234567");
            p1.setEmail("john@example.com");
            p1.setPassword("pass123");
            p1.setRole(Role.PATIENT);

            Patient p2 = new Patient();
            p2.setName("Jane Smith");
            p2.setPhone("0777654321");
            p2.setEmail("jane@example.com");
            p2.setPassword("pass123");
            p2.setRole(Role.PATIENT);

            Patient me = new Patient();
            me.setName("Test User");
            me.setPhone("0123456789"); // Matching the login test
            me.setEmail("test@example.com");
            me.setPassword("pass123");
            me.setRole(Role.PATIENT);

            patientRepository.saveAll(List.of(p1, p2, me));

            // 3. Seed Appointments (The Queue)
            Appointment a1 = new Appointment();
            a1.setPatient(p1);
            a1.setDoctor(drWijesekara);
            a1.setTokenNumber(15);
            a1.setStatus(AppointmentStatus.COMPLETED);
            a1.setEstimatedTime(LocalDateTime.now().minusMinutes(30));

            Appointment a2 = new Appointment();
            a2.setPatient(p2);
            a2.setDoctor(drWijesekara);
            a2.setTokenNumber(20);
            a2.setStatus(AppointmentStatus.IN_PROGRESS);
            a2.setEstimatedTime(LocalDateTime.now().minusMinutes(5));

            Appointment a3 = new Appointment();
            a3.setPatient(me);
            a3.setDoctor(drWijesekara);
            a3.setTokenNumber(25);
            a3.setStatus(AppointmentStatus.PENDING);
            a3.setEstimatedTime(LocalDateTime.now().plusMinutes(15));

            appointmentRepository.saveAll(List.of(a1, a2, a3));

            System.out.println("Wait... Seed Data Initialized!");
        };
    }
}
