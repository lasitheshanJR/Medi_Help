import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';
import 'globals.dart';

class ApptsScreen extends StatefulWidget {
  const ApptsScreen({super.key});

  @override
  State<ApptsScreen> createState() => _ApptsScreenState();
}

class _ApptsScreenState extends State<ApptsScreen> {
  List<dynamic> appointments = [];
  bool isLoading = true;

  // Colors from original UI
  static const primaryTeal = Color(0xFF40AFC6);
  static const highlightBlue = Color(0xFFE0F7FA);

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (Globals.currentUser == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final appts = await ApiService.getAppointmentsForPatient(Globals.currentUser!['id']);
      if (mounted) {
        setState(() {
          appointments = appts;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error loading appointments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadAppointments,
            color: primaryTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Upcoming Appointments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    
                    if (isLoading)
                      const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: primaryTeal)))
                    else if (appointments.isEmpty)
                      const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("No appointments found")))
                    else
                      ...appointments.map((appt) {
                        final dateTime = DateTime.parse(appt['estimatedTime']);
                        final dateStr = DateFormat('MMM d, yyyy').format(dateTime);
                        final timeStr = DateFormat('hh:mm a').format(dateTime);
                        
                        return AppointmentCard(
                          name: appt['doctor']['name'] ?? "Unknown Doctor",
                          type: appt['doctor']['specialization'] ?? "Consultation",
                          date: dateStr,
                          time: timeStr,
                          status: appt['status'] == 'PENDING' ? "Upcoming" : "Today",
                          isHighlighted: appt['status'] == 'IN_PROGRESS' || appt['status'] == 'PENDING',
                        );
                      }),

                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/book_appt'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryTeal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text("Book New Appointment", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: topPadding + 15, left: 20, right: 20, bottom: 25),
      decoration: const BoxDecoration(color: primaryTeal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Just-In-time", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              Text("Appointments", style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          Row(
            children: [
              _headerIcon(Icons.notifications_none),
              const SizedBox(width: 10),
              _headerIcon(Icons.menu),
            ],
          )
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String name, type, date, time, status;
  final bool isHighlighted;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.type,
    required this.date,
    required this.time,
    required this.status,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFE0F7FA) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isHighlighted ? const Color(0xFF40AFC6) : Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == "Today" ? const Color(0xFF1CB5E0) : Colors.grey[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(type, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(date, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(width: 20),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(time, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
