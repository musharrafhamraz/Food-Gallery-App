// lib/tailor/tailor_dashboard.dart
import 'package:flutter/material.dart';

class TailorDashboard extends StatelessWidget {
  const TailorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tailor Dashboard')),
      body: const Center(
        child: Text(
          'Welcome, Tailor!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
