// lib/customer/customer_dashboard.dart
import 'package:flutter/material.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Dashboard')),
      body: const Center(
        child: Text(
          'Welcome, Customer!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
