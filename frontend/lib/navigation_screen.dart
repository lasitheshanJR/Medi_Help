import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the plugin

class NavigationScreen extends StatelessWidget {
  final Function(int)? onBackToHome;

  const NavigationScreen({super.key, this.onBackToHome});

  // FUNCTION: Logic to open Google Maps
  Future<void> _openGoogleMaps() async {
    // Dynamic query for nearest hospital
    final Uri googleMapsUrl = Uri.parse("geo:0,0?q=hospital");
    final Uri appleMapsUrl = Uri.parse("https://maps.apple.com/?q=hospital");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        throw 'Could not launch maps';
      }
    } catch (e) {
      debugPrint("Error opening maps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Clinic Location", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF06B6D4)),
          onPressed: () => onBackToHome?.call(0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Center(child: Icon(Icons.map_outlined, size: 80, color: Colors.grey)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Locate Nearest Hospital", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Find emergency and healthcare facilities near your current position.", style: TextStyle(color: Colors.grey)),
                  const Divider(height: 40),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _openGoogleMaps, // Triggers the map app
                      icon: const Icon(Icons.directions, color: Colors.white),
                      label: const Text("Start Navigation", style: TextStyle(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}