import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to save the menu item data
  Future<void> saveMenuItem({
    required String name,
    required String description,
    required String price,
    required File imageFile,
  }) async {
    try {
      // Upload the image to Firebase Storage
      String imageUrl = await _uploadImageToStorage(imageFile);

      // Save the menu item data to Firestore
      await _firestore.collection('menuItems').add({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl, // Save the image URL
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save menu item: $e');
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToStorage(File imageFile) async {
    try {
      // Create a unique file name for the image
      String fileName =
          'menu_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image
      UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
