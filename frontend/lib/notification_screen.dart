import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF06B6D4)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notifItem("Leave Now!", "Your turn is coming up in 10 mins. Suggested departure: Now.", Colors.red),
          _notifItem("Appointment Confirmed", "Your visit with Dr. Smith is confirmed for tomorrow.", Colors.green),
          _notifItem("Queue Update", "The doctor is moving faster than expected!", Colors.blue),
        ],
      ),
    );
  }

  Widget _notifItem(String title, String body, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.notifications, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(body),
      ),
    );
  }
}