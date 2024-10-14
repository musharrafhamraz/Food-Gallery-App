import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method (no role needed)
  Future<void> signUpUser(String email, String password, String name,
      String age, String gender) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional fields in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'age': age,
        'gender': gender,
        'email': email,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error... Signing Up!');
      rethrow;
    }
  }

  // Login Method (no role needed)
  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential; // Return the user credential for navigation check
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error... Login Failed.');
      rethrow;
    }
  }

  // Logout method
  Future<void> logoutUser() async {
    _auth.signOut();
  }
}
