import 'package:flutter/material.dart';
import '../service/patient_service.dart'; // Import the API service

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? patientProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() async {
    final patientService = PatientService();
    final profile = await patientService.getPatientByCode(widget.token);
    setState(() {
      patientProfile = profile;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : patientProfile != null
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ListTile(
                      title: Text('Code Patient: ${patientProfile!['codePatient']}'),
                    ),
                    ListTile(
                      title: Text('Nom: ${patientProfile!['nom']}'),
                    ),
                    ListTile(
                      title: Text('Prénom: ${patientProfile!['prenom']}'),
                    ),
                    ListTile(
                      title: Text('Téléphone: ${patientProfile!['tel']}'),
                    ),
                    ListTile(
                      title: Text('CIN: ${patientProfile!['cin']}'),
                    ),
                  ],
                )
              : const Center(child: Text('Failed to load profile data')),
    );
  }
}
