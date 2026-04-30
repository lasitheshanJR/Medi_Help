package com.zybots.mediqueue.controller;

import com.zybots.mediqueue.model.Schedule;
import com.zybots.mediqueue.service.ScheduleService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/schedules")
public class ScheduleController {

    private final ScheduleService scheduleService;

    public ScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @PostMapping("/add")
    public Schedule addSchedule(@RequestBody Schedule schedule) {
        return scheduleService.addSchedule(schedule);
    }

    @GetMapping("/all")
    public List<Schedule> getAllSchedules() {
        return scheduleService.getAllSchedules();
    }
}