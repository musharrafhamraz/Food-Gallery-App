import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailorapp/widgets/background_widget.dart';
import 'package:tailorapp/widgets/custom_button.dart';
import 'package:tailorapp/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                'Please Provide your EMail Address',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: emailController,
                maxLines: 1,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPress: () async {
                  String email = emailController.text.trim();

                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  Fluttertoast.showToast(
                      msg: 'Reset Email sent!',
                      backgroundColor: Colors.green,
                      textColor: Colors.white);

                  Navigator.of(context).pop();
                },
                buttonTxt: const Text(
                  'Send Email Reset Email',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
