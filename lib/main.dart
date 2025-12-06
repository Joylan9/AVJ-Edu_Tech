import 'package:flutter/material.dart';
import 'frontend/create_account.dart';

void main() {
  runApp(const SovirApp());
}

class SovirApp extends StatelessWidget {
  const SovirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sovir App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F4F5),
      ),
      home: const CreateAccountPage(),
    );
  }
}
