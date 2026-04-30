import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          // Returns user to the Home tab of MainNavigation
          icon: const Icon(Icons.arrow_back, color: Color(0xFF06B6D4)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("Account"),
          _settingsTile(
            Icons.person_outline,
            "Profile Settings",
            () => Navigator.pushNamed(context, '/profile'),
          ),
          _settingsTile(
            Icons.notifications_active_outlined,
            "Notification Settings",
            // Points to the toggle switch screen we just built
            () => Navigator.pushNamed(context, '/notification_settings'),
          ),
          
          const SizedBox(height: 30),
          _buildSectionTitle("Support & Legal"),
          _settingsTile(
            Icons.lock_outline,
            "Privacy Policy",
            () => Navigator.pushNamed(context, '/privacy'),
          ),
          _settingsTile(
            Icons.help_outline,
            "Help & Support",
            () => Navigator.pushNamed(context, '/help'),
          ),
          
          const SizedBox(height: 30),
          _buildSectionTitle("App"),
          _settingsTile(
            Icons.info_outline,
            "Version 1.0.0",
            null, // Static info, no navigation
          ),
          
          const SizedBox(height: 20),
          // Logout button with a subtle background to match tiles
          Card(
            elevation: 0,
            color: Colors.red.withOpacity(0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5, top: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback? onTap) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF8FAFC),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF06B6D4)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out of Just-In-Time?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}