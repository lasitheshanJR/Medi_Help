package com.zybots.mediqueue.repository;

import com.zybots.mediqueue.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
}