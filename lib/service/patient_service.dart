import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientService {
  final String baseUrl = "http://127.0.0.1:8081/api/patients";

  /// ✅ Get Patient Details by Code
  Future<Map<String, dynamic>?> getPatientByCode(String codePatient) async {
    final url = Uri.parse("$baseUrl/$codePatient");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error fetching patient: $error");
      throw Exception("Error fetching patient: $error");
    }
  }

  /// ✅ Update Patient Details
  Future<bool> updatePatient(
      int patientId, Map<String, dynamic> patientData) async {
    final url = Uri.parse("$baseUrl/$patientId");

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(patientData),
      );

      return response.statusCode == 200;
    } catch (error) {
      print("Error updating patient: $error");
      throw Exception("Error updating patient: $error");
    }
  }

  /// ✅ Delete Patient
  Future<bool> deletePatient(int patientId) async {
    final url = Uri.parse("$baseUrl/$patientId");

    try {
      final response = await http.delete(url, headers: {
        "Content-Type": "application/json",
      });

      return response.statusCode == 204;
    } catch (error) {
      print("Error deleting patient: $error");
      throw Exception("Error deleting patient: $error");
    }
  }

  /// ✅ Get Patient Prescriptions (Ordonnances)
  Future<List<dynamic>> getPatientOrdonnances(int patientId) async {
    final url = Uri.parse("$baseUrl/$patientId/ordonnances");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (error) {
      print("Error fetching prescriptions: $error");
      throw Exception("Error fetching prescriptions: $error");
    }
  }

  /// ✅ Get Patient Medication History
  Future<List<dynamic>> getPatientMedicationHistory(int patientId) async {
    final url = Uri.parse("$baseUrl/$patientId/historique-medicaments");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (error) {
      print("Error fetching medications: $error");
      throw Exception("Error fetching medications: $error");
    }
  }
}
