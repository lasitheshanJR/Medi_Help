import 'package:flutter/material.dart';
import 'services/api_service.dart';

class DoctorDetailsPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  List<dynamic> queue = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    try {
      final q = await ApiService.getQueueForDoctor(widget.doctor['id']);
      if (mounted) {
        setState(() {
          queue = q;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error loading doctor queue: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xFF53C8D8), elevation: 0),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4)))
      );
    }

    int completed = queue.where((a) => a['status'] == 'COMPLETED').length;
    int remaining = queue.where((a) => a['status'] == 'PENDING' || a['status'] == 'IN_PROGRESS').length;
    int total = queue.length;
    String status = widget.doctor['currentStatus'] ?? "Offline";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Doctor Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF53C8D8),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadQueue,
        color: const Color(0xFF53C8D8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _profileCard(status),
              const SizedBox(height: 16),
              _availabilityCard(status),
              const SizedBox(height: 16),
              _queueHistoryCard(total, completed, remaining),
              const SizedBox(height: 16),
              _performanceCard(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _cardWrapper({String? title, IconData? icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(children: [
              if (icon != null) Icon(icon, size: 16, color: Colors.cyan),
              if (icon != null) const SizedBox(width: 5),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
            const SizedBox(height: 15),
          ],
          child,
        ],
      ),
    );
  }

  Widget _profileCard(String status) {
    return _cardWrapper(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF00BCD4),
                child: Text(widget.doctor['name'] != null && widget.doctor['name'].length > 3 ? widget.doctor['name'][3] : 'D', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.doctor['name'] ?? 'Dr. Unknown', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(widget.doctor['specialization'] ?? 'Specialist', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(color: status.toUpperCase() == "ACTIVE" ? Colors.greenAccent : Colors.orangeAccent, borderRadius: BorderRadius.circular(6)),
                    child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _statBox('Experience', '12 Years'),
              const SizedBox(width: 10),
              _statBox('Rating', '4.8'),
            ],
          )
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFFE1F5FE), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _availabilityCard(String currentStatus) {
    return _cardWrapper(
      title: 'Current Availability',
      child: Column(
        children: [
          _statusTile('Active', Colors.green, currentStatus.toUpperCase() == 'ACTIVE'),
          _statusTile('On Break', Colors.orange, currentStatus.toUpperCase() == 'ON BREAK'),
          _statusTile('Emergency/Away', Colors.amber, currentStatus.toUpperCase() == 'EMERGENCY' || currentStatus.toUpperCase() == 'AWAY'),
        ],
      ),
    );
  }

  Widget _statusTile(String label, Color color, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.green.withOpacity(0.05) : Colors.transparent,
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          if (isSelected) const Icon(Icons.check_circle, color: Colors.green, size: 18),
        ],
      ),
    );
  }

  Widget _queueHistoryCard(int total, int completed, int remaining) {
    return _cardWrapper(
      title: 'Session Queue History',
      icon: Icons.history,
      child: Column(
        children: [
          _dataRow('Total Tokens Today', total.toString(), const Color(0xFFE1F5FE), Colors.black),
          _dataRow('Completed', completed.toString(), const Color(0xFFE8F5E9), Colors.green),
          _dataRow('Remaining', remaining.toString(), const Color(0xFFFFF8E1), Colors.orange),
        ],
      ),
    );
  }

  Widget _dataRow(String label, String value, Color bg, Color textCol) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textCol)),
        ],
      ),
    );
  }

  Widget _performanceCard() {
    return _cardWrapper(
      title: "Today's Performance",
      child: Column(
        children: [
          _progressRow('Avg. Time per Patient', '9 min', 0.6),
          _progressRow('Queue Efficiency', '90%', 0.9),
          _progressRow('On-Time Rate', '85%', 0.85),
        ],
      ),
    );
  }

  Widget _progressRow(String label, String value, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            minHeight: 5,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }
}
