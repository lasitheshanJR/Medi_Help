import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'globals.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  static const primaryTeal = Color(0xFF40AFC6);
  
  List<dynamic> doctors = [];
  bool isLoading = true;
  int? selectedDoctorId;
  
  DateTime selectedDateObj = DateTime.now();
  TimeOfDay selectedTimeObj = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      final docs = await ApiService.getAllDoctors();
      if (mounted) {
        setState(() {
          doctors = docs;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error loading doctors: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateObj,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryTeal),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDateObj = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeObj,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryTeal),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedTimeObj = picked);
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a doctor")));
      return;
    }
    if (Globals.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are not logged in!")));
      return;
    }

    // Format LocalDateTime for Spring Boot: yyyy-MM-ddTHH:mm:ss
    String formattedTime = "${selectedDateObj.year}-${selectedDateObj.month.toString().padLeft(2, '0')}-${selectedDateObj.day.toString().padLeft(2, '0')}T${selectedTimeObj.hour.toString().padLeft(2, '0')}:${selectedTimeObj.minute.toString().padLeft(2, '0')}:00";

    // Route to payment page instead of creating directly
    Navigator.pushNamed(context, '/payment', arguments: {
      'estimatedTime': formattedTime,
      'doctorId': selectedDoctorId,
      'patientId': Globals.currentUser!['id']
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateDisplay = "${selectedDateObj.year} / ${selectedDateObj.month.toString().padLeft(2, '0')} / ${selectedDateObj.day.toString().padLeft(2, '0')}";
    String timeDisplay = selectedTimeObj.format(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F2),
      appBar: AppBar(
        backgroundColor: primaryTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Book New Appointment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: primaryTeal))
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Select Doctor
          _buildSectionCard(
            title: "1. Select Doctor",
            child: Column(
              children: doctors.map((doc) => _doctorItem(doc)).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Select Date & Time
          _buildSectionCard(
            title: "2. Select Date & Time",
            child: Column(
              children: [
                _inputTile(Icons.calendar_today, "Select Date", dateDisplay, () => _selectDate(context)),
                const SizedBox(height: 12),
                _inputTile(Icons.access_time, "Select Time", timeDisplay, () => _selectTime(context)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Patient Information
          _buildSectionCard(
            title: "3. Patient Information",
            child: TextField(
              controller: TextEditingController(text: Globals.currentUser?['name'] ?? ''),
              enabled: false,
              decoration: const InputDecoration(
                hintText: "Patient Name",
                border: UnderlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _bookAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _doctorItem(dynamic doc) {
    bool isSelected = selectedDoctorId == doc['id'];
    return GestureDetector(
      onTap: () => setState(() => selectedDoctorId = doc['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F7FA) : Colors.transparent,
          border: Border.all(color: isSelected ? primaryTeal : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? Colors.white : const Color(0xFFE0F7FA),
              child: const Icon(Icons.person, color: primaryTeal),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc['name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(doc['specialization'] ?? "Specialist", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: primaryTeal, size: 20)
            else const Icon(Icons.check_circle_outline, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _inputTile(IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: primaryTeal, size: 22),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}