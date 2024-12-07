import 'package:flutter/material.dart';
import 'password_setup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordSetupScreen()),
                );
              },
              child: Text(
                'Inscrit',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 24),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    // Add sign-up navigation logic
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
