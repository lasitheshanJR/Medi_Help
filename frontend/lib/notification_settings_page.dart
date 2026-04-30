import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // State variables for the toggles
  bool _queueAlerts = true;
  bool _appointmentReminders = true;
  bool _clinicNews = false;
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notification Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF06B6D4)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildHeader("Alert Preferences"),
          _buildSwitchTile(
            title: "Queue Status Alerts",
            subtitle: "Notify me when I am 3rd in the queue",
            value: _queueAlerts,
            onChanged: (val) => setState(() => _queueAlerts = val),
            icon: Icons. whatshot_outlined,
          ),
          _buildSwitchTile(
            title: "Appointment Reminders",
            subtitle: "Receive reminders 24 hours before your visit",
            value: _appointmentReminders,
            onChanged: (val) => setState(() => _appointmentReminders = val),
            icon: Icons.calendar_month_outlined,
          ),
          
          const SizedBox(height: 20),
          _buildHeader("System & Sound"),
          _buildSwitchTile(
            title: "Notification Sound",
            subtitle: "Play sound for incoming alerts",
            value: _soundEnabled,
            onChanged: (val) => setState(() => _soundEnabled = val),
            icon: Icons.volume_up_outlined,
          ),
          _buildSwitchTile(
            title: "Clinic Updates",
            subtitle: "News about new doctors or holiday hours",
            value: _clinicNews,
            onChanged: (val) => setState(() => _clinicNews = val),
            icon: Icons.campaign_outlined,
          ),
          
          const SizedBox(height: 30),
          const Center(
            child: Text(
              "Managed by Just-In-Time System",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10, left: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF06B6D4),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: SwitchListTile(
        activeThumbColor: const Color(0xFF06B6D4),
        secondary: Icon(icon, color: const Color(0xFF06B6D4)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}