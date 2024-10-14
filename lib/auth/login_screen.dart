import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailorapp/auth/auth_services.dart';
import 'package:tailorapp/auth/email_verification.dart';
import 'package:tailorapp/auth/forgot_password_screen.dart';
import 'package:tailorapp/auth/sign_up_screen.dart';
import 'package:tailorapp/screens/customer_side/customer_dashboard.dart';
import 'package:tailorapp/screens/tailor_dashboard.dart';
import 'package:tailorapp/widgets/background_widget.dart';
import 'package:tailorapp/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool loggingIn = false;

  var _obsecureText = true;

  togglePassword() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Gallery'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent, // Foody theme color
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Welcome Text
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Image to create foody ambiance
              Image.asset(
                'assets/images/food.png', // Add an image of food or restaurant
                height: 150,
              ),
              const SizedBox(height: 30),
              // Email Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  // labelText: 'Email',
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.orangeAccent),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  hintText: '********',
                  prefixIcon:
                      const Icon(Icons.lock, color: Colors.orangeAccent),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
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
              ),
              const SizedBox(height: 20),

              // Login Button
              CustomButton(
                onPress: () async {
                  loggingIn = true;
                  setState(() {});
                  try {
                    // Login and retrieve user credentials
                    UserCredential? userC = await _authService.loginUser(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    // Check if the email is the specific owner email
                    if (_emailController.text ==
                        'musharrafhamraz328@gmail.com') {
                      if (userC!.user != null) {
                        if (userC.user!.emailVerified) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const TailorDashboard()),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return const EmailVerificationScreen();
                          }));
                        }
                      }
                    } else {
                      if (userC!.user != null) {
                        if (userC.user!.emailVerified) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserMenuListScreen()),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return const EmailVerificationScreen();
                          }));
                        }
                      }

                      // Navigate to customer dashboard for all other users
                    }
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Login Failed ${e.toString()}')));
                  } finally {
                    loggingIn = false;
                    setState(() {});
                  }
                },
                buttonTxt: loggingIn
                    ? const SpinKitRipple(
                        color: Colors.white,
                      )
                    : const Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 10),
              // Forgot Password Text Button
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ForgotPasswordScreen();
                  }));
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
              const SizedBox(height: 20),
              // Option to navigate to the Signup screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignupScreen();
                      }));
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
