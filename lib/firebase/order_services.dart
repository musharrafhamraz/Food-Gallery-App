import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For Firebase Firestore (storing the order)

Future<void> placeOrder(String itemName, int quantity, String price) async {
  // Get the currently signed-in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    // Handle the case where the user is not logged in
    throw Exception("User is not logged in.");
  }

  String userEmail = currentUser.email!;
  String userId = currentUser.uid;

  try {
    // Fetch the user's name from Firestore
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception("User data not found.");
    }

    // Get the name from the user document
    String userName = userDoc['age'];

    // Prepare the order data
    Map<String, dynamic> orderData = {
      'email': userEmail,
      'name': userName, // Add the user's name to the order data
      'item_name': itemName,
      'quantity': quantity,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(), // Current time of the order
    };

    // Store the order in Firestore
    await FirebaseFirestore.instance.collection('orders').add(orderData);
  } catch (e) {
    // Handle errors here (e.g., failed to place order)
    Fluttertoast.showToast(msg: 'Error... Placing Order!');
  }
}

// New code may contain bugs and code might not work.

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> moveOrder(
    String orderId, String fromCollection, String toCollection) async {
  try {
    DocumentSnapshot order =
        await _firestore.collection(fromCollection).doc(orderId).get();
    Map<String, dynamic>? orderData = order.data() as Map<String, dynamic>?;

    if (orderData != null) {
      await _firestore.collection(toCollection).doc(orderId).set(orderData);
      await _firestore.collection(fromCollection).doc(orderId).delete();
    } else {
      throw Exception("No order data found for orderId: $orderId");
    }
  } catch (e) {
    throw Exception("Failed to move order: $e");
  }
}

// Delete order
Future<void> deleteOrder(String orderId, String collection) async {
  try {
    await _firestore.collection(collection).doc(orderId).delete();
  } catch (e) {
    throw Exception("Failed to delete order: $e");
  }
}
