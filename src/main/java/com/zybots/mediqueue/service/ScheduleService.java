package com.zybots.mediqueue.service;

import com.zybots.mediqueue.model.Schedule;
import com.zybots.mediqueue.repository.ScheduleRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    public ScheduleService(ScheduleRepository scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }

    // Add a new shift for a doctor
    public Schedule addSchedule(Schedule schedule) {
        return scheduleRepository.save(schedule);
    }

    // Get all schedules in the system
    public List<Schedule> getAllSchedules() {
        return scheduleRepository.findAll();
    }
}