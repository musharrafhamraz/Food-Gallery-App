import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore (storing the order)

Future<void> placeOrder(String itemName, int quantity, String price) async {
  // Get the currently signed-in user's email
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    // Handle the case where the user is not logged in
    throw Exception("User is not logged in.");
  }

  String userEmail = currentUser.email!;

  // Prepare the order data
  Map<String, dynamic> orderData = {
    'email': userEmail,
    'item_name': itemName,
    'quantity': quantity,
    'price': price,
    'timestamp': FieldValue.serverTimestamp(), // Current time of the order
  };

  try {
    // Store the order in Firestore (or send it to your backend)
    await FirebaseFirestore.instance.collection('orders').add(orderData);

    print("Order placed successfully.");
  } catch (e) {
    // Handle errors here (e.g., failed to place order)
    print("Failed to place order: $e");
  }
}
