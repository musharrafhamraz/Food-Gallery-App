// lib/auth/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Sign Up Method
  Future<void> signUpUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user role in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'role': role, // tailor or customer
      });

      print('User signed up successfully!');
    } catch (e) {
      print('Sign-up failed: $e');
      throw e; // Rethrow error to handle it in the UI
    }
  }

  // Sign In Method
  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print('User logged in successfully!');
    } catch (e) {
      print('Login failed: $e');
      throw e; // Rethrow error to handle it in the UI
    }
  }
}
