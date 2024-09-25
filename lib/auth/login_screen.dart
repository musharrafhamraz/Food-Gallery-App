// lib/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:tailorapp/auth/auth_services.dart';
import 'package:tailorapp/auth/sign_up_screen.dart';
import 'package:tailorapp/screens/customer_dashboard.dart';
import 'package:tailorapp/screens/tailor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Login and retrieve role
                  String? role = await _authService.loginUser(
                    _emailController.text,
                    _passwordController.text,
                  );

                  // Navigate to the appropriate dashboard based on role
                  if (role == 'tailor') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TailorDashboard()),
                    );
                  } else if (role == 'customer') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerDashboard()),
                    );
                  } else {
                    // Handle case if role is not found
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invalid user role'),
                    ));
                  }
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Failed')));
                }
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const SignupScreen();
                }));
              },
              child: const Text('SignUP'),
            ),
          ],
        ),
      ),
    );
  }
}
