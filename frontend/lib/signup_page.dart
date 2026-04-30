import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String selectedRole = 'Patient';
  File? _idPhoto;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idPhoto = File(pickedFile.path);
      });
    }
  }

  void _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (selectedRole != 'Patient' && _idPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload your ID Photo')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Map<String, String> data = {
        'name': name,
        'email': email,
        'phone': phone,
        'role': selectedRole.toUpperCase(),
      };

      // 1. Unified Registration
      final regResponse = await ApiService.registerUser(data, _idPhoto);

      if (regResponse.statusCode == 200 || regResponse.statusCode == 201) {
        // 2. Send OTP
        final otpResponse = await ApiService.sendOtp(email);
        if (otpResponse.statusCode == 200) {
           if (mounted) Navigator.pushNamed(context, '/otp', arguments: email);
        } else {
           if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send OTP')));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration failed')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            // Role Dropdown
            DropdownButtonFormField<String>(
              initialValue: selectedRole,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF06B6D4)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              items: <String>['Patient', 'Doctor', 'Admin'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedRole = newValue!;
                  if (selectedRole == 'Patient') _idPhoto = null;
                });
              },
            ),
            const SizedBox(height: 20),

            _buildInput("Full Name", Icons.person_outline, _nameController, TextInputType.name),
            const SizedBox(height: 20),
            _buildInput("Email Address", Icons.email_outlined, _emailController, TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildInput("Phone Number", Icons.phone_outlined, _phoneController, TextInputType.phone),
            const SizedBox(height: 20),

            if (selectedRole != 'Patient') ...[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: const Color(0xFF06B6D4), width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: _idPhoto != null 
                      ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(_idPhoto!, fit: BoxFit.cover))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined, color: Color(0xFF06B6D4), size: 40),
                            const SizedBox(height: 10),
                            Text("Upload ${selectedRole == 'Doctor' ? 'Doctor ID' : 'Hospital ID'}", style: const TextStyle(color: Colors.grey))
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, TextEditingController controller, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF06B6D4)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}