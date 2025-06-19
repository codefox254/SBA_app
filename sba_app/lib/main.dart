import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart'; // ✅ Correct import
import 'screens/home_screen.dart';

void main() {
  runApp(const SbaApp());
}

class SbaApp extends StatelessWidget {
  const SbaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SBA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(), // ✅ Correct class name
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
