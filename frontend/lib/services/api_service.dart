import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  // Use correct backend URL depending on platform
  // For Windows/Web use: http://localhost:8082/api
  // For Android Emulator use: http://10.0.2.2:8082/api
  // For Physical Phone on same Wi-Fi use: http://192.168.1.6:8082/api
  static const String baseUrl = 'http://192.168.1.6:8082/api';

  // ----------------- AUTHENTICATION & REGISTRATION -----------------
  // Register unified user with multipart support
  static Future<http.Response> registerUser(Map<String, String> data, File? file) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/auth/register'));
    
    // Add text fields
    request.fields.addAll(data);
    
    // Add file if exists
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register: ${response.body}');
    }
    return response;
  }

  // Register patient (simple JSON)
  static Future<http.Response> registerPatient(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
  // Send OTP to email
  static Future<http.Response> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP: ${response.body}');
    }
    return response;
  }

  // Verify OTP
  static Future<http.Response> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
    return response;
  }


  // Get all patients
  static Future<List<dynamic>> getAllPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/all'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patients: ${response.body}');
    }
  }

  // ----------------- DOCTORS -----------------
  // Get all doctors
  static Future<List<dynamic>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl/doctors/all'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load doctors: ${response.body}');
    }
  }

  // Get doctor by ID
  static Future<Map<String, dynamic>> getDoctorById(int doctorId) async {
    final response = await http.get(Uri.parse('$baseUrl/doctors/$doctorId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load doctor: ${response.body}');
    }
  }

  // ----------------- APPOINTMENTS -----------------
  // Book an appointment
  static Future<http.Response> bookAppointment(Map<String, dynamic> appointmentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments/book'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to book appointment: ${response.body}');
    }
    return response;
  }

  // Get queue for a doctor
  static Future<List<dynamic>> getQueueForDoctor(int doctorId) async {
    final response = await http.get(Uri.parse('$baseUrl/appointments/queue/$doctorId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load queue: ${response.body}');
    }
  }

  // Get appointments for a patient
  static Future<List<dynamic>> getAppointmentsForPatient(int patientId) async {
    final response = await http.get(Uri.parse('$baseUrl/appointments/patient/$patientId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patient appointments: ${response.body}');
    }
  }
}