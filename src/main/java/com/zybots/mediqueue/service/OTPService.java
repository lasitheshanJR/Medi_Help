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
        System.out.println("Generated OTP: " + otp + " for email: " + email);
        
        try {
            org.springframework.mail.SimpleMailMessage message = new org.springframework.mail.SimpleMailMessage();
            message.setTo(email);
            message.setSubject("Your Mediqueue OTP");
            message.setText("Your verification code is: " + otp);
            mailSender.send(message);
            System.out.println("SUCCESS: JavaMailSender sent OTP to " + email);
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: Failed to send email to " + email);
            System.err.println("Error details: " + e.getMessage());
            e.printStackTrace();
            // Still log OTP locally so user can find it in their Railway logs
            System.out.println("[FALLBACK LOG] Since email failed, use this OTP to test: " + otp);
        }
    }

    /**
     * Verifies if the provided OTP matches the stored OTP for the email.
     * Also allows '1111' as a bypass code for presentation testing.
     */
    public boolean verifyOTP(String email, String otp) {
        // BYPASS: Use 1111 if your real email is delayed!
        if (otp.equals("1111")) {
            System.out.println("Using Bypass code '1111' for email: " + email);
            return true;
        }

        if (otpStorage.containsKey(email) && otpStorage.get(email).equals(otp)) {
            otpStorage.remove(email);
            return true;
        }
        return false;
    }
}
