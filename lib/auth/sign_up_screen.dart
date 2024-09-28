import 'package:flutter/material.dart';
import 'package:tailorapp/auth/auth_services.dart';
import 'package:tailorapp/auth/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.orangeAccent, // Food-inspired color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to Food Gallery!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange, // Food-inspired color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/food.png', // Image of food or restaurant theme
                height: 150,
              ),
              const SizedBox(height: 20),
              // Name Field
              SignupTextField(
                controller: _nameController,
                label: 'Name',
              ),

              const SizedBox(height: 15),
              // Age Field
              SignupTextField(
                controller: _ageController,
                label: 'Age',
              ),
              const SizedBox(height: 15),
              // Gender Field
              SignupTextField(
                controller: _genderController,
                label: 'Gender',
              ),

              const SizedBox(height: 15),
              // Email Field
              SignupTextField(
                controller: _emailController,
                label: 'Email',
              ),
              const SizedBox(height: 15),
              // Password Field
              SignupTextField(
                controller: _passwordController,
                label: 'Password',
              ),
              const SizedBox(height: 20),
              // Signup Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orangeAccent, // Foody theme button color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  try {
                    await _authService.signUpUser(
                      _emailController.text,
                      _passwordController.text,
                      _ageController.text,
                      _nameController.text,
                      _genderController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed Up Successfully')),
                    );
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign Up Failed')),
                    );
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              // Terms and Conditions
              const Text(
                'By signing up, you agree to our Terms & Conditions.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const SignupTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.person, color: Colors.orangeAccent),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
