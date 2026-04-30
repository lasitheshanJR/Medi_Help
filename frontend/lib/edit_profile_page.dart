import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers to handle the text input
  final TextEditingController _nameController = TextEditingController(text: "User Name");
  final TextEditingController _emailController = TextEditingController(text: "user@email.com");
  final TextEditingController _phoneController = TextEditingController(text: "+94 77 123 4567");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey), // "X" to cancel
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Save text button in the top right
          TextButton(
            onPressed: () {
              // Logic to save data would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Changes Saved")),
              );
            },
            child: const Text("Save", style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Profile Picture Edit Section
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF1F5F9),
                    child: Icon(Icons.person, size: 50, color: Color(0xFF06B6D4)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF06B6D4),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () {}, // Image picker logic
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Input Fields
            _buildEditInput("Full Name", _nameController, Icons.person_outline),
            _buildEditInput("Email", _emailController, Icons.email_outlined),
            _buildEditInput("Phone Number", _phoneController, Icons.phone_iphone),
            
            const SizedBox(height: 20),
            const Text(
              "Note: Your email update might require verification.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditInput(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF06B6D4)),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF06B6D4), width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}