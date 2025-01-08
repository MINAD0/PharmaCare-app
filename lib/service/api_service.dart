import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8081/auth";
  final FlutterSecureStorage storage = FlutterSecureStorage();

  //Verify Code
  Future<bool> verifyCode(String code) async {
    final url = Uri.parse("$baseUrl/verify-code/$code");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
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
  Future<String?> patientLogin(String code, String password) async {
    final url = Uri.parse("$baseUrl/patient-login");

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
        String token = responseBody['token'];
        // Store the token securely
        await storage.write(key: 'token', value: token);
        print("Token saved: $token");
        return token;
      } else {
        final errorBody = jsonDecode(response.body);
        print("Error: ${errorBody['message']}");
        return null;
      }
    } catch (error) {
      print("Error occurred during login: $error");
      throw Exception("Error logging in: $error");
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}
