package com.zybots.mediqueue.repository;

import com.zybots.mediqueue.model.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepository extends JpaRepository<Admin, Long> {
}
