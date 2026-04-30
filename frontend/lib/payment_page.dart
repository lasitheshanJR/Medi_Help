import 'package:flutter/material.dart';
import 'services/api_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  Future<void> _processPaymentAndBook(Map<String, dynamic> bookingData) async {
    if (_cardController.text.isEmpty || _expController.text.isEmpty || _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all payment details")));
      return;
    }

    setState(() => _isProcessing = true);

    // Mock processing delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final response = await ApiService.bookAppointment(bookingData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
           Navigator.popUntil(context, ModalRoute.withName('/main'));
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Successful! Appointment Booked.")));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking failed: ${response.body}")));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get booking payload from route arguments
    final Map<String, dynamic> bookingData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Secure Payment", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Consultation Fee", style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 5),
            const Text("LKR 1,500.00", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
            const SizedBox(height: 40),
            
            const Text("Card details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildInput("Card Number", Icons.credit_card, _cardController, TextInputType.number),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildInput("MM/YY", Icons.date_range, _expController, TextInputType.datetime)),
                const SizedBox(width: 20),
                Expanded(child: _buildInput("CVV", Icons.lock_outline, _cvvController, TextInputType.number)),
              ],
            ),
            const SizedBox(height: 50),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _processPaymentAndBook(bookingData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isProcessing 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Pay & Confirm Booking", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, TextEditingController controller, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
