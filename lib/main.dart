import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';
import 'package:smart_parking_assistant/features/auth/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(), // Changed from HomeScreen to WelcomeScreen
    );
  }
}
