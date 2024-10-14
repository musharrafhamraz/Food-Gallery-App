import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tailorapp/screens/customer_side/customer_dashboard.dart';
import 'package:tailorapp/widgets/background_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  EmailVerificationScreenState createState() => EmailVerificationScreenState();
}

class EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerification();
    });
  }

  // execute every 5 seconds
  checkEmailVerification() {
    FirebaseAuth.instance.currentUser!.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const UserMenuListScreen();
      }));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Verification Text
            const Text(
              'Verify Your Email',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Image to enhance the ambiance
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/verify_email.png', // Use an email-related image
                height: 300,
              ),
            ),
            const SizedBox(height: 30),
            // Instruction Text
            Text(
              'A Verification has been sent to ${FirebaseAuth.instance.currentUser!.email}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Resend Code Option
            TextButton(
              onPressed: () {
                // Add your resend code logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Verification email sent successfully')),
                );
              },
              child: const Text(
                'Resend Code',
                style: TextStyle(color: Colors.orangeAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
