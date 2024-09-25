import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<void> signUpUser(String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
      throw e;
    }
  }

  // Login Method and Role Retrieval
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String? role = userDoc['role'];
      return role; // Return the user's role (tailor or customer)
    } catch (e) {
      print('Login failed: $e');
      throw e;
    }
  }
}
