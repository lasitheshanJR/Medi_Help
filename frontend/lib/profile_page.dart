import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF06B6D4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Navigates to the Edit Page we just created
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView( // Wrap with scroll view for Pixel 7 height
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Color(0xFF06B6D4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30), 
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50, 
                    backgroundColor: Colors.white24, 
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "User Name", 
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "+94 77 123 4567", 
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Profile Details Section
            _profileItem(Icons.email_outlined, "Email", "user@example.com"),
            _profileItem(Icons.location_on_outlined, "Address", "Matara, Sri Lanka"),
            _profileItem(Icons.calendar_today_outlined, "Member Since", "March 2026"),
            _profileItem(Icons.bloodtype_outlined, "Blood Group", "O+"), // Added for medical context
            _profileItem(Icons.medical_information_outlined, "Medical ID", "JIT-88291"),
            
            const SizedBox(height: 30),
            
            // Optional: Logout Button inside the profile view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Logout", style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF06B6D4).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF06B6D4), size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
    );
  }
}