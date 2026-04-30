import 'dart:ui';
import 'package:flutter/material.dart';

// --- AUTH & CORE IMPORTS ---
import 'login_page.dart';
import 'signup_page.dart';
import 'otp_page.dart';
import 'home_screen.dart';
import 'queue_screen.dart';
import 'appts_screen.dart'; 
import 'doctor_screen.dart';

// --- FEATURE & SUB-PAGES ---
import 'navigation_screen.dart';
import 'clinic_screen.dart';
import 'notification_screen.dart';
import 'notification_settings_page.dart';
import 'book_new_appt.dart'; // ADDED
import 'payment_page.dart'; // ADDED

// --- USER & LEGAL ---
import 'settings_page.dart';
import 'profile_page.dart';
import 'edit_profile_page.dart';
import 'privacy_policy_page.dart';
import 'help_support_page.dart';

void main() => runApp(const JustInTimeApp());

// CUSTOM SCROLL BEHAVIOR: Fixes "stuck" scrolling in Chrome Pixel 7 view
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class JustInTimeApp extends StatelessWidget {
  const JustInTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Just-In-time',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF06B6D4), // Signature Cyan
      ),
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/otp': (context) => const OtpPage(),
        '/main': (context) => const MainNavigation(),
        '/notifications': (context) => const NotificationScreen(),
        '/notification_settings': (context) => const NotificationSettingsPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
        '/help': (context) => const HelpSupportPage(),
        '/book_appt': (context) => const BookAppointmentPage(), // ADDED
        '/payment': (context) => const PaymentPage(), // ADDED
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Pages indexed 0-3 are on the BottomNav. 4-5 are sub-pages of Home.
    final List<Widget> pages = [
      HomeScreen(onNavigate: (index) => setState(() => _currentIndex = index)),
      const QueueScreen(),
      const ApptsScreen(),
      const DoctorScreen(),
      NavigationScreen(onBackToHome: (index) => setState(() => _currentIndex = index)),
      ClinicScreen(onBackToHome: (index) => setState(() => _currentIndex = index)),
    ];

    return PopScope(
      canPop: _currentIndex == 0, 
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Logic: Return to Home tab if back is pressed on any other tab
        if (_currentIndex != 0) setState(() => _currentIndex = 0); 
      },
      child: Scaffold(
        body: pages[_currentIndex], 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF06B6D4),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Queue"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Appts"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Doctor"),
          ],
        ),
      ),
    );
  }
}