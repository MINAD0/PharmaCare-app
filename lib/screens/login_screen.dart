import 'package:flutter/material.dart';
import 'package:pharmacare/screens/login_with_password_screen.dart';
import 'package:pharmacare/screens/password_setup_screen.dart';
import '../service/api_service.dart'; // Import the API service

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController codeController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  void handleLogin() async {
    final String code = codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code cannot be empty!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool isValid = await apiService.verifyCode(code);

      if (isValid) {
        // Navigate to Password Setup Screen if the code is valid
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordSetupScreen(codePatient: codeController.text.trim(),)),
        );
      } else {
        // Show error message if the code is invalid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid code. Please try again.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'images/logo.png', // Replace with your app logo
                    height: 200,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bienvenue 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Code Input Field
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Saisir votre code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 24),
            // Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: isLoading ? null : handleLogin,
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Inscrit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            SizedBox(height: 24),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Do you have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginWithPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Connecter',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
