import 'package:flutter/material.dart';
import 'services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  void _handleLogin() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    try {
      final email = _emailController.text.trim();
      // 1. Send OTP to the entered email
      final response = await ApiService.sendOtp(email);

      if (response.statusCode == 200) {
        // Success
        Navigator.pushNamed(context, '/otp', arguments: email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backend error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $e')),
      );
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Just-In-time",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4)),
            ),
            const SizedBox(height: 10),
            const Text("Login to manage your queue", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 50),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email Address",
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF06B6D4)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Get OTP", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF06B6D4))),
            )
          ],
        ),
      ),
    );
  }
}