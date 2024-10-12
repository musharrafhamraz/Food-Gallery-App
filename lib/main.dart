import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tailorapp/auth/login_screen.dart';
import 'package:tailorapp/screens/customer_side/customer_dashboard.dart';
import 'package:tailorapp/screens/tailor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String restaurantEmail = 'musharrafhamraz328@gmail.com';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? (FirebaseAuth.instance.currentUser!.email == restaurantEmail &&
                  FirebaseAuth.instance.currentUser!.emailVerified
              ? const TailorDashboard()
              : const UserMenuListScreen())
          : const LoginScreen(),

      // home: FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified
      //     ? const UserMenuListScreen()
      //     : const LoginScreen(),
    );
  }
}
