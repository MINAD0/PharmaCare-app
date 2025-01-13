import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io'; // Required for File class

class ApiService {
  final String baseUrl = "http://127.0.0.1:8081";
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  //Verify Code
  Future<String> verifyCode(String code) async {
    final url = Uri.parse("$baseUrl/auth/verify-code/$code");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          // "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['passwordSet'] == 'true') {
          return "Account already registered";
        } else {
          return "Account exists but not yet registered";
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to verify code: ${response.body}");
      }
    } catch (error) {
      print("Error occurred during API call: $error");
      throw Exception("Error verifying code: $error");
    }
  }

  /// Set Password
  Future<bool> setPassword(String code, String newPassword) async {
    final url = Uri.parse("$baseUrl/set-password");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "codePatient": code,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print("Response: $responseBody");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error occurred during API call: $error");
      throw Exception("Error setting password: $error");
    }
  }

  /// Patient Login
  Future<bool> patientLogin(String code, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "emailOrCode": code,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('jwt') && responseBody['jwt'] != null) {
          String token = responseBody['jwt'];
          await storage.write(key: 'token', value: token);
          print("Token saved: $token");
          return true; // Login successful
        } else {
          print("Error: JWT not found in response.");
          return false; // Login failed
        }
      } else {
        final errorBody = jsonDecode(response.body);
        print("Error: ${errorBody['message']}");
        return false; // Login failed
      }
    } catch (error) {
      print("Error occurred during login: $error");
      throw Exception("Error logging in: $error");
    }
  }

  /// Logout
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  /// Get Token from Secure Storage
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  /// Fetch Patient Data
  Future<Map<String, dynamic>?> getPatientData(String codePatient) async {
    final token = await getToken();
    if (token == null) throw Exception("No token found");

    final url = Uri.parse("$baseUrl/api/patients/$codePatient");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch patient data: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error fetching patient data: $error");
    }
  }

  /// Update Patient Profile
  Future<bool> updatePatient(String codePatient, Map<String, dynamic> patientData) async {
    final token = await getToken();
    if (token == null) throw Exception("No token found");

    final url = Uri.parse("$baseUrl/api/patients/$codePatient");

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(patientData),
      );

      return response.statusCode == 200;
    } catch (error) {
      throw Exception("Error updating patient: $error");
    }
  }

  /// Encode Image File to Base64 String
  Future<String> encodeImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (error) {
      throw Exception("Error encoding image: $error");
    }
  }

  /// Get Patient Ordonnances
  Future<List<dynamic>> getPatientOrdonnances(String codePatient) async {
    final token = await getToken(); // Retrieve token
    if (token == null) throw Exception("No token found");

    final url = Uri.parse("$baseUrl/api/patients/$codePatient/ordonnances");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (error) {
      print("Error fetching ordonnances: $error");
      throw Exception("Error fetching ordonnances: $error");
    }
  }



}
