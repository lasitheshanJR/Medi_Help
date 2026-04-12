package com.zybots.mediqueue.service;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OTPService {

    // Store OTP in memory. Key: Email, Value: generated OTP
    private final ConcurrentHashMap<String, String> otpStorage = new ConcurrentHashMap<>();

    @Autowired
    private org.springframework.mail.javamail.JavaMailSender mailSender;

    /**
     * Generates a 4-digit OTP, stores it for the given email,
     * and sends it via real email.
     */
    public void generateAndSendOTP(String email) {
        String otp = String.format("%04d", new Random().nextInt(10000));
        otpStorage.put(email, otp);
        
        try {
            org.springframework.mail.SimpleMailMessage message = new org.springframework.mail.SimpleMailMessage();
            message.setTo(email);
            message.setSubject("Your Mediqueue OTP");
            message.setText("Your verification code is: " + otp);
            mailSender.send(message);
            System.out.println("Email sent successfully to " + email);
        } catch (Exception e) {
            System.err.println("Failed to send email to " + email + ": " + e.getMessage());
            // Still log OTP locally if email fails due to placeholder credentials
            System.out.println("[FALLBACK] OTP for " + email + " is: " + otp);
        }
    }

    /**
     * Verifies if the provided OTP matches the stored OTP for the email.
     * Removes the OTP from storage if it matches.
     */
    public boolean verifyOTP(String email, String otp) {
        if (otpStorage.containsKey(email) && otpStorage.get(email).equals(otp)) {
            otpStorage.remove(email); // OTP is verified and should only be used once
            return true;
        }
        return false;
    }
}
