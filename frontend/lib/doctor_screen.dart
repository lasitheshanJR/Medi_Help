import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'doctor_details_page.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<dynamic> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      final docList = await ApiService.getAllDoctors();
      if (mounted) {
        setState(() {
          doctors = docList;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error loading doctors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4))));
    }

    return Container(
      color: const Color(0xFFF8F9FB),
      child: Column(
        children: [
          _header(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadDoctors,
              color: const Color(0xFF53C8D8),
              child: doctors.isEmpty 
                ? const Center(child: Text("No Doctors Found in Directory"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(doctors[index]);
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: topPadding + 10, left: 20, right: 20, bottom: 25),
      color: const Color(0xFF53C8D8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Just-In-time', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              Text('Doctor Directory', style: TextStyle(color: Colors.white70)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications_none, color: Colors.white),
              SizedBox(width: 15),
              Icon(Icons.menu, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDoctorCard(dynamic doc) {
    String status = doc['currentStatus'] ?? "Offline";
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorDetailsPage(doctor: doc)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF00BCD4),
              child: Text(doc['name'] != null && doc['name'].length > 3 ? doc['name'][3] : 'D', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc['name'] ?? 'Dr. Unknown', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(doc['specialization'] ?? 'Specialist', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status.toUpperCase() == "ACTIVE" ? Colors.green.shade50 : Colors.orange.shade50, 
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 4, 
                              backgroundColor: status.toUpperCase() == "ACTIVE" ? Colors.green : Colors.orange
                            ),
                            const SizedBox(width: 6),
                            Text(status, style: TextStyle(color: status.toUpperCase() == "ACTIVE" ? Colors.green.shade700 : Colors.orange.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
