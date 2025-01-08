import 'package:flutter/material.dart';
import 'package:pharmacare/screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/login_with_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PharmaCare App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/password_setup': (context) => PasswordSetupScreen(codePatient: 'defaultCode',),
        '/login_with_password': (context) => LoginWithPasswordScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final codePatient = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(codePatient: codePatient),
          );
        } else if (settings.name == '/profile') {
          final codePatient = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(codePatient: codePatient),
          );
        }
        return null;
      },
    );
  }
}
