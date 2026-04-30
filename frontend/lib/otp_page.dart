import 'dart:convert';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'globals.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  bool _isLoading = false;
  
  void _verifyOtp(String email) async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 4-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.verifyOtp(email, otp);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['user'] == null) {
          // They logged in but aren't registered yet!
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('No account found. Please sign up first.'), duration: Duration(seconds: 4)),
             );
             Navigator.pushReplacementNamed(context, '/signup');
          }
          return;
        }

        Globals.currentUser = responseData['user'];
        if (mounted) Navigator.pushReplacementNamed(context, '/main');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid OTP')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? 'your email';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 80, color: Color(0xFF06B6D4)),
            const SizedBox(height: 30),
            const Text("Verify Email", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Enter the code sent to $email", textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _otpField(context, index)),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _verifyOtp(email),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify & Login", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpField(BuildContext context, int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: InputDecoration(counterText: "", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}