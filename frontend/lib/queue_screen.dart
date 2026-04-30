import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'globals.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  List<dynamic> queue = [];
  Map<String, dynamic>? activeAppt;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    if (Globals.currentUser == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final patientAppts = await ApiService.getAppointmentsForPatient(Globals.currentUser!['id']);
      final pendingAppts = patientAppts.where((a) => a['status'] == 'PENDING').toList();

      if (pendingAppts.isNotEmpty) {
        final currentAppt = pendingAppts.first;
        final docId = currentAppt['doctor']['id'];
        final q = await ApiService.getQueueForDoctor(docId);

        if (mounted) {
          setState(() {
            activeAppt = currentAppt;
            queue = q;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            activeAppt = null;
            queue = [];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      debugPrint("Error loading queue: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4))));
    }

    if (activeAppt == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.blur_linear, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text("No Active Queue", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 10),
              const Text("You don't have any pending appointments.", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    int myToken = activeAppt!['tokenNumber'] ?? 999;
    final inProgress = queue.firstWhere((a) => a['status'] == 'IN_PROGRESS', orElse: () => null);
    
    int aheadCount = queue.where((a) => a['status'] == 'PENDING' && a['tokenNumber'] < myToken).length;
    int estimatedWait = aheadCount * 8; 
    
    bool isUrgent = estimatedWait < 5 && estimatedWait >= 0;
    Color alertColor = isUrgent ? const Color(0xFFEF4444) : const Color(0xFF22C55E);
    Color alertBg = isUrgent ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadQueue,
        color: const Color(0xFF06B6D4),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  children: [
                    _buildProgressCard(inProgress, activeAppt),
                    const SizedBox(height: 24),
                    _buildPaceCard(),
                    const SizedBox(height: 24),
                    _buildUrgencyCard(isUrgent, alertColor, alertBg, estimatedWait),
                    const SizedBox(height: 24),
                    _buildFullQueueList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
      decoration: const BoxDecoration(color: Color(0xFF06B6D4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Just-In-time", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              Text("Live Queue", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              _buildHeaderCircleButton(Icons.notifications_none),
              const SizedBox(width: 12),
              _buildHeaderCircleButton(Icons.menu),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCircleButton(IconData icon) {
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildProgressCard(dynamic inProgress, dynamic myAppt) {
    String nowTreating = inProgress != null ? "Token #${inProgress['tokenNumber']}" : "None";
    String yourToken = "Your Token #${myAppt['tokenNumber']}";
    
    int myTokenNum = myAppt['tokenNumber'] ?? 100;
    int currentTokenNum = inProgress != null ? inProgress['tokenNumber'] ?? 0 : 0;
    
    double progress = 0.0;
    if (myTokenNum > 0) {
      progress = currentTokenNum / myTokenNum;
      if (progress > 1.0) progress = 1.0;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Queue Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("${(progress * 100).toInt()}%", style: const TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF06B6D4)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tokenLabel(nowTreating, const Color(0xFF06B6D4)),
              _tokenLabel(yourToken, const Color(0xFF22C55E)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB2EBF2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF00ACC1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.access_time, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Doctor's Pace", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Average Time per Patient", style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: const [
                Text("8", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00838F))),
                Text("minutes per patient", style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyCard(bool isUrgent, Color color, Color bg, int wait) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color, child: const Icon(Icons.near_me, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Should I leave Now?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(
                      isUrgent ? "Leave Immediately" : "You have plenty of time.",
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _infoRow(Icons.location_on_outlined, "Your Travel time", "22 mins"),
          _infoRow(Icons.access_time, "Estimated wait", "$wait mins"),
        ],
      ),
    );
  }

  Widget _buildFullQueueList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Full Queue List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ...queue.map((item) {
          bool isMe = item['tokenNumber'] == activeAppt!['tokenNumber'];
          return Card(
            elevation: 0,
            color: isMe ? const Color(0xFFF0FDF4) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), 
              side: BorderSide(color: isMe ? const Color(0xFF22C55E) : Colors.grey.shade200)
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['status'] == 'IN_PROGRESS' 
                    ? Colors.green 
                    : (isMe ? const Color(0xFF22C55E) : Colors.grey.shade200),
                child: Text("${item['tokenNumber']}", style: TextStyle(color: (item['status'] == 'IN_PROGRESS' || isMe) ? Colors.white : Colors.black)),
              ),
              title: Text(item['patient']['name'] ?? "Unknown Patient"),
              subtitle: Text("Status: ${item['status']}"),
              trailing: item['status'] == 'IN_PROGRESS' 
                  ? const Icon(Icons.play_circle_fill, color: Colors.green) 
                  : (isMe ? const Icon(Icons.person, color: Color(0xFF22C55E)) : null),
            ),
          );
        }),
      ],
    );
  }

  Widget _tokenLabel(String text, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black45),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.black87)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}