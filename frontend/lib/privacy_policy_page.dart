import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF06B6D4)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Privacy Matters", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
            const SizedBox(height: 15),
            _policySection("1. Data Collection", "We collect your phone number and appointment history to provide real-time queue updates."),
            _policySection("2. Location Access", "We access your location only to calculate the 'Travel Time' and 'Suggested Departure' features."),
            _policySection("3. Security", "All data is stored securely using Firebase encryption standards."),
            const SizedBox(height: 30),
            const Text("Last updated: March 2026", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _policySection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}