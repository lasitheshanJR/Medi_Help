package com.zybots.mediqueue.controller;

import com.zybots.mediqueue.model.User;
import com.zybots.mediqueue.repository.UserRepository;
import com.zybots.mediqueue.service.OTPService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private OTPService otpService;
    
    @Autowired
    private UserRepository userRepository;

    @PostMapping("/send-otp")
    public ResponseEntity<?> sendOtp(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Email is required"));
        }
        otpService.generateAndSendOTP(email);
        return ResponseEntity.ok(Map.of("message", "OTP sent successfully"));
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String otp = request.get("otp");
        
        if (email == null || otp == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Email and OTP are required"));
        }

        boolean isValid = otpService.verifyOTP(email, otp);
        if (isValid) {
            Optional<User> existingUser = userRepository.findByEmail(email);
            return ResponseEntity.ok(Map.of(
                "message", "OTP verified successfully",
                "isNewUser", existingUser.isEmpty(),
                "user", existingUser.orElse(null)
            ));
        } else {
            return ResponseEntity.status(401).body(Map.of("message", "Invalid OTP"));
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("role") String role,
            @RequestParam(value = "file", required = false) org.springframework.web.multipart.MultipartFile file) {
            
        try {
            // Check if user already exists
            if (userRepository.findByEmail(email).isPresent()) {
                return ResponseEntity.badRequest().body(Map.of("message", "Email already registered. Please login instead."));
            }

            com.zybots.mediqueue.model.Role userRole = com.zybots.mediqueue.model.Role.valueOf(role.toUpperCase());
            User user;

            // Handle file save if uploaded
            String idPhotoPath = null;
            if (file != null && !file.isEmpty()) {
                String uploadDir = System.getProperty("user.dir") + "/uploads/";
                java.io.File dir = new java.io.File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                
                String originalFilename = file.getOriginalFilename();
                String fileExtension = originalFilename != null && originalFilename.contains(".") ? originalFilename.substring(originalFilename.lastIndexOf(".")) : "";
                String newFilename = java.util.UUID.randomUUID().toString() + fileExtension;
                java.io.File targetFile = new java.io.File(uploadDir + newFilename);
                file.transferTo(targetFile);
                idPhotoPath = targetFile.getAbsolutePath();
            }

            if (userRole == com.zybots.mediqueue.model.Role.DOCTOR) {
                com.zybots.mediqueue.model.Doctor doctor = new com.zybots.mediqueue.model.Doctor();
                doctor.setSpecialization("General"); // Default
                doctor.setCurrentStatus("Active");
                doctor.setIdPhotoPath(idPhotoPath);
                user = doctor;
            } else if (userRole == com.zybots.mediqueue.model.Role.ADMIN) {
                com.zybots.mediqueue.model.Admin admin = new com.zybots.mediqueue.model.Admin();
                admin.setHospitalIdPhotoPath(idPhotoPath);
                user = admin;
            } else {
                com.zybots.mediqueue.model.Patient patient = new com.zybots.mediqueue.model.Patient();
                user = patient;
            }

            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(userRole);
            return ResponseEntity.ok(userRepository.save(user));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage() != null ? e.getMessage() : "Unknown error"));
        }
    }
}
