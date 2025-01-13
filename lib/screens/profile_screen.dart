import 'package:flutter/material.dart';
import 'dart:convert'; // For base64Encode and base64Decode
import 'package:image_picker/image_picker.dart'; // Image picker
import '../service/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final String codePatient;

  const ProfileScreen({super.key, required this.codePatient});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? patientData;
  bool isLoading = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? profilePicture;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    try {
      final data = await apiService.getPatientData(widget.codePatient);
      if (data != null) {
        setState(() {
          patientData = data;
          firstNameController.text = data['prenom'] ?? "";
          lastNameController.text = data['nom'] ?? "";
          cinController.text = data['cin'] ?? "";
          phoneController.text = data['tel'] ?? "";
          profilePicture = data['profilePictureUrl']; // Fetch the profile picture URL
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching patient data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _saveChanges() async {
    if (patientData == null) return;

    final updatedData = {
      "prenom": firstNameController.text.trim(),
      "nom": lastNameController.text.trim(),
      "cin": cinController.text.trim(),
      "tel": phoneController.text.trim(),
      "profilePictureUrl": profilePicture, // Send the updated profile picture
    };

    try {
      bool isUpdated = await apiService.updatePatient(widget.codePatient, updatedData);
      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")),
        );
      }
    } catch (error) {
      print("Error updating profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }


  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Convert the image file to a Base64 string
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);

        setState(() {
          profilePicture = base64Image; // Update the profile picture state
        });

        print("Image picked and encoded successfully.");
      } catch (error) {
        print("Error encoding image: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      }
    }
  }


  Future<void> _logout() async {
    try {
      await apiService.logout();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print("Error during logout: $error");
    }
  }

  Widget _buildProfileField(String label, TextEditingController controller, {bool editable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          readOnly: !editable,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: editable ? Colors.white : Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color.fromARGB(255, 123, 191, 247),
          backgroundImage: profilePicture != null
              ? MemoryImage(base64Decode(profilePicture!))
              : const NetworkImage("https://via.placeholder.com/150") as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                border: Border.all(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : patientData == null
              ? const Center(child: Text("Error loading patient data"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildProfilePicture(),
                        const SizedBox(height: 10),
                        const Text("Verified", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 30),
                        _buildProfileField("First Name", firstNameController, editable: true),
                        _buildProfileField("Last Name", lastNameController, editable: true),
                        _buildProfileField("CIN", cinController, editable: true),
                        _buildProfileField("Phone Number", phoneController, editable: true),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          label: const Text("Save Changes"),
                          icon: const Icon(Icons.save),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: _logout,
                          label: const Text("Logout"),
                          icon: const Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
