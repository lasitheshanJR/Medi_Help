import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'globals.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Map<String, dynamic>? doctorInfo;
  List<dynamic> queue = [];
  Map<String, dynamic>? activeAppt;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (Globals.currentUser == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final patientAppts = await ApiService.getAppointmentsForPatient(Globals.currentUser!['id']);
      // Find the first pending appointment
      final pendingAppts = patientAppts.where((a) => a['status'] == 'PENDING').toList();

      if (pendingAppts.isNotEmpty) {
        final currentAppt = pendingAppts.first;
        final docId = currentAppt['doctor']['id'];

        final doc = await ApiService.getDoctorById(docId);
        final q = await ApiService.getQueueForDoctor(docId);

        if (mounted) {
          setState(() {
            activeAppt = currentAppt;
            doctorInfo = doc;
            queue = q;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            activeAppt = null;
            doctorInfo = null;
            queue = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error loading home data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4))));
    }

    int aheadCount = 0;
    int waitTime = 0;
    String nowTreating = "None";
    String yourToken = "None";

    if (activeAppt != null && queue.isNotEmpty) {
      int myToken = activeAppt!['tokenNumber'] ?? 999;
      aheadCount = queue.where((a) => a['status'] == 'PENDING' && a['tokenNumber'] < myToken).length;
      waitTime = aheadCount * 8; // Assuming 8 mins per patient
      
      final currentAppt = queue.firstWhere((a) => a['status'] == 'IN_PROGRESS', orElse: () => null);
      nowTreating = currentAppt != null ? "#${currentAppt['tokenNumber']}" : "None";
      yourToken = "#$myToken";
    }

    bool isLate = activeAppt != null && waitTime <= 5;

    return Scaffold(
      key: _scaffoldKey, 
      backgroundColor: Colors.white,
      endDrawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF06B6D4),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildInteractiveHeader(context),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: activeAppt == null
                    ? _buildEmptyState()
                    : _buildDoctorCard(nowTreating, yourToken),
              ),
              if (activeAppt != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildETASection(isLate, waitTime, aheadCount),
                ),
              const SizedBox(height: 20),
              if (activeAppt != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(Icons.people_outline, aheadCount.toString(), "ahead"),
                      _statCard(Icons.access_time, "8", "min/patient"),
                      _statCard(Icons.timeline, aheadCount == 0 ? "100%" : "75%", "Progress"),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              _buildNavigationGrid(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, 
        borderRadius: BorderRadius.circular(25), 
      ),
      child: Column(
        children: [
          const Icon(Icons.calendar_today, size: 60, color: Colors.grey),
          const SizedBox(height: 15),
          const Text("No Active Appointments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 10),
          const Text("You are not in any queue right now. Book an appointment to get started.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/book_appt'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4)),
            child: const Text("Book Now", style: TextStyle(color: Colors.white)),
          )
        ],
      )
    );
  }

  // --- FIXED DRAWER LOGIC ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF06B6D4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 Text(Globals.currentUser?['name'] ?? "Guest User", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                 Text(Globals.currentUser?['email'] ?? "Please log in", style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            )
          ),
          ListTile(
            leading: const Icon(Icons.person_outline), 
            title: const Text("Profile"), 
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/profile'); 
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined), 
            title: const Text("Settings"), 
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/settings'); 
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Globals.clear();
              Navigator.pushReplacementNamed(context, '/login');
            }
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---
  Widget _buildInteractiveHeader(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
      decoration: const BoxDecoration(color: Color(0xFF06B6D4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi ${Globals.currentUser?['name'] ?? ''}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                const Text("Live Dashboard", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          Row(
            children: [
              _glassIcon(Icons.notifications_none, () => Navigator.pushNamed(context, '/notifications')),
              const SizedBox(width: 15),
              _glassIcon(Icons.menu, () => _scaffoldKey.currentState?.openEndDrawer()),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNavigationGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              _gridButton(Icons.list_alt, "Live Queue", () => widget.onNavigate(1)),
              const SizedBox(width: 15),
              _gridButton(Icons.map_outlined, "Navigation", () => widget.onNavigate(4)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _gridButton(Icons.calendar_month, "Appointments", () => widget.onNavigate(2)),
              const SizedBox(width: 15),
              _gridButton(Icons.domain, "Clinic Info", () => widget.onNavigate(5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _glassIcon(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
      child: Icon(icon, color: Colors.white, size: 28),
    ),
  );

  Widget _buildDoctorCard(String nowTreating, String yourToken) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF13B9CE), 
        borderRadius: BorderRadius.circular(25), 
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _badge("My Next Appointment"),
          _activeBadge(doctorInfo?['currentStatus'] ?? "Active"),
        ]),
        const SizedBox(height: 15),
        Text(doctorInfo?['name'] ?? "No Doctor", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(doctorInfo?['specialization'] ?? "Specialist", style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _tokenSubBox("Now Treating", nowTreating)),
          const SizedBox(width: 10),
          Expanded(child: _tokenSubBox("Your Token", yourToken)),
        ]),
      ]),
    );
  }

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
  );

  Widget _activeBadge(String status) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: status == "Active" ? Colors.green : Colors.orange, borderRadius: BorderRadius.circular(20)),
    child: Text("~ $status", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
  );

  Widget _buildETASection(bool isLate, int waitTime, int aheadCount) {
    Color statusColor = isLate ? const Color(0xFFEF4444) : const Color(0xFF22C55E);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor.withOpacity(0.3)),
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        Row(children: [
          CircleAvatar(backgroundColor: statusColor, radius: 15, child: const Icon(Icons.near_me, color: Colors.white, size: 15)),
          const SizedBox(width: 10),
          const Text("Estimated Wait Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ]),
        if (isLate) 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 5),
                Text("You may miss your turn!", style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _timeBox("Wait Time", waitTime.toString()),
          _timeBox("Queue Ahead", aheadCount.toString()),
        ]),
      ]),
    );
  }

  Widget _tokenSubBox(String t, String v) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
    child: Column(children: [
      Text(t, style: const TextStyle(color: Colors.white70, fontSize: 10)), 
      Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
    ]),
  );

  Widget _timeBox(String label, String val) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const Text("mins", style: TextStyle(fontSize: 10, color: Colors.grey)),
  ]);

  Widget _statCard(IconData icon, String val, String sub) => Container(
    width: 100, padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
      Icon(icon, color: const Color(0xFF06B6D4)), 
      const SizedBox(height: 5),
      Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
      Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    ]),
  );

  Widget _gridButton(IconData icon, String label, VoidCallback onTap) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: const Color(0xFF06B6D4)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ]),
      ),
    ),
  );
}