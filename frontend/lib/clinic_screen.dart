import 'package:flutter/material.dart';

class ClinicScreen extends StatelessWidget {
  final Function(int)? onBackToHome;

  const ClinicScreen({super.key, this.onBackToHome});

  // Theme Colors
  static const primaryTeal = Color(0xFF06B6D4);
  static const serviceBlue = Color(0xFFE0F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _clinicIntroCard(),
                  const SizedBox(height: 16),
                  _contactInfoCard(),
                  const SizedBox(height: 16),
                  _operatingHoursCard(),
                  const SizedBox(height: 16),
                  _servicesOfferedCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HEADER ---
  Widget _header(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding + 10, left: 25, right: 25, bottom: 25),
      decoration: const BoxDecoration(
        color: primaryTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Just-In-time', 
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              Text('Clinic Information', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white, size: 30),
            onPressed: () => onBackToHome?.call(0),
          ),
        ],
      ),
    );
  }

  // --- INTRO CARD WITH FIXED SPREAD OPERATOR ---
  Widget _clinicIntroCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: serviceBlue, borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.local_hospital_outlined, color: primaryTeal, size: 35),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Heart Care Clinic', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Specialized Cardiology', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // FIXED: Spread operator ensures stars are children of the Row
              ...List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 20)),
              const SizedBox(width: 8),
              const Text('4.9 (1.2k reviews)', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Providing premium cardiovascular diagnostics and patient-first care solutions since 2010.',
            style: TextStyle(color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  // --- CONTACT CARD ---
  Widget _contactInfoCard() {
    return _cardWrapper(
      title: 'Get in Touch',
      child: Column(
        children: [
          _infoRow(Icons.call_outlined, '011-2223550', 'Reception Desk'),
          _infoRow(Icons.mail_outline, 'support@heartcare.lk', 'Official Email'),
          _infoRow(Icons.map_outlined, '110, 1st Lane, Moratuwa', 'Clinic Location'),
        ],
      ),
    );
  }

  // --- HOURS CARD ---
  Widget _operatingHoursCard() {
    return _cardWrapper(
      title: 'Operating Hours',
      child: Column(
        children: [
          _timeRow('Mon - Fri', '08:00 AM - 06:00 PM'),
          _timeRow('Saturday', '09:00 AM - 02:00 PM'),
          _timeRow('Sunday', 'Closed for Emergencies Only', isClosed: true),
        ],
      ),
    );
  }

  // --- SERVICES CHIPS ---
  Widget _servicesOfferedCard() {
    return _cardWrapper(
      title: 'Services',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _serviceChip('ECG / EKG'),
          _serviceChip('Stress Test'),
          _serviceChip('Echocardiogram'),
          _serviceChip('Blood Labs'),
        ],
      ),
    );
  }

  // --- PRIVATE REUSABLE HELPERS ---
  Widget _cardWrapper({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryTeal)),
            const SizedBox(height: 15),
          ],
          child,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String main, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: serviceBlue, radius: 18, child: Icon(icon, color: primaryTeal, size: 18)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(main, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeRow(String day, String hours, {bool isClosed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(hours, style: TextStyle(color: isClosed ? Colors.red : Colors.black87, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _serviceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: serviceBlue, borderRadius: BorderRadius.circular(30)),
      child: Text(label, style: const TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
/////