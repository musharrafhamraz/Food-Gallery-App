import 'package:flutter/material.dart';
import 'package:foodapp/auth/auth_services.dart';
import 'package:foodapp/auth/login_screen.dart';
import 'package:foodapp/widgets/background_widget.dart';
import 'package:foodapp/widgets/custom_button.dart';

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

  var _obsecureText = true;

  togglePassword() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.orangeAccent, // Food-inspired color
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: SingleChildScrollView(
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
                  icon: Icons.person, // Icon for name field
                  passwordText: false,
                ),

                const SizedBox(height: 15),
                // Age Field
                SignupTextField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.cake,
                  passwordText: false,
                  type: TextInputType.number,
                ),
                const SizedBox(height: 15),
                // Gender Field
                SignupTextField(
                  controller: _genderController,
                  label: 'Gender',
                  icon: Icons.transgender,
                  passwordText: false,
                ),

                const SizedBox(height: 15),
                // Email Field
                SignupTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  passwordText: false,
                ),
                const SizedBox(height: 15),
                // Password Field
                SignupTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  passwordText: _obsecureText,
                  suffixicon: IconButton(
                    onPressed: () {
                      togglePassword();
                    },
                    icon: _obsecureText
                        ? Icon(
                            Icons.remove_red_eye,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Icon(
                            Icons.remove_red_eye_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Signup Button
                CustomButton(
                  onPress: () async {
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
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign Up Failed')),
                      );
                    }
                  },
                  buttonTxt: const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
      ),
    );
  }
}

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool passwordText;
  final IconButton? suffixicon;
  final TextInputType? type;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.passwordText,
    this.suffixicon,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: passwordText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        border: const OutlineInputBorder(),
        suffixIcon: suffixicon,
      ),
      keyboardType: type,
    );
  }
}
