package com.zybots.mediqueue.controller;

import com.zybots.mediqueue.model.Appointment;
import com.zybots.mediqueue.service.AppointmentService;
import com.zybots.mediqueue.dto.AppointmentRequest;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;

    public AppointmentController(AppointmentService appointmentService) {
        this.appointmentService = appointmentService;
    }

    // ✅ UPDATED
    @PostMapping("/book")
    public Appointment bookAppointment(@RequestBody AppointmentRequest request) {
        return appointmentService.bookAppointment(request);
    }

    @GetMapping("/queue/{doctorId}")
    public List<Appointment> getDoctorQueue(@PathVariable Long doctorId) {
        return appointmentService.getQueueForDoctor(doctorId);
    }

    @GetMapping("/patient/{patientId}")
    public List<Appointment> getPatientAppointments(@PathVariable Long patientId) {
        return appointmentService.getAppointmentsForPatient(patientId);
    }
}