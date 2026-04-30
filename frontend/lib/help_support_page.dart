import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF06B6D4)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("How can we help you?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _supportTile(Icons.question_answer_outlined, "FAQs", "Common questions about the queue."),
          _supportTile(Icons.chat_bubble_outline, "Live Chat", "Talk to our support team."),
          _supportTile(Icons.mail_outline, "Email Us", "support@justintime.com"),
          const SizedBox(height: 30),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Frequently Asked Questions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const ExpansionTile(
            title: Text("How do I join a queue?"),
            children: [Padding(padding: EdgeInsets.all(16), child: Text("Simply book an appointment or visit the clinic to get a token number."))],
          ),
          const ExpansionTile(
            title: Text("Is the ETA accurate?"),
            children: [Padding(padding: EdgeInsets.all(16), child: Text("ETAs are based on the doctor's average pace and are updated in real-time."))],
          ),
        ],
      ),
    );
  }

  Widget _supportTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF06B6D4)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {},
      ),
    );
  }
}