import 'package:flutter/material.dart';
import 'package:pharmacare/screens/login_with_password_screen.dart';
import 'package:pharmacare/screens/password_setup_screen.dart';
import '../service/api_service.dart'; // Import the API service

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
        const SnackBar(content: Text("Code cannot be empty!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String message = await apiService.verifyCode(code);

      if (message == "Account already registered") {
        // Navigate to login screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account already registered")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Navigate to password setup screen
        Navigator.pushReplacementNamed(context, '/set-password');
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
                  const SizedBox(height: 16),
                  const Text(
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
            const SizedBox(height: 40),
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
            const SizedBox(height: 24),
            // Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: isLoading ? null : handleLogin,
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Inscrit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 24),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Do you have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginWithPasswordScreen()),
                    );
                  },
                  child: const Text(
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
