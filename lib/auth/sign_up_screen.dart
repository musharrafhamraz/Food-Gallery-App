// lib/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:tailorapp/auth/auth_services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedRole = 'customer'; // Default role

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
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
            // Role selection
            Row(
              children: [
                const Text('Role:'),
                Radio<String>(
                  value: 'customer',
                  groupValue: selectedRole,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                const Text('Customer'),
                Radio<String>(
                  value: 'tailor',
                  groupValue: selectedRole,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                const Text('Tailor'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _authService.signUpUser(
                    _emailController.text,
                    _passwordController.text,
                    selectedRole,
                  );
                  // Show success message or navigate to another screen
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed Up Successfully')));
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign Up Failed')));
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
