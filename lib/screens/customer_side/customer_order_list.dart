import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:tailorapp/widgets/background_widget.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  UserOrdersScreenState createState() => UserOrdersScreenState();
}

class UserOrdersScreenState extends State<UserOrdersScreen> {
  // Function to fetch orders based on the user's email from multiple collections
  Stream<List<Map<String, dynamic>>> _getUserOrders() async* {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    // List to hold the combined results
    List<Map<String, dynamic>> ordersList = [];

    // Define the collections to search
    List<String> collections = ['orders', 'progress', 'completed'];

    // Iterate over each collection and fetch orders
    for (String collection in collections) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('email', isEqualTo: userEmail)
          .get();

      // Add the fetched orders to the ordersList
      for (var order in snapshot.docs) {
        Map<String, dynamic> orderData = order.data() as Map<String, dynamic>;
        orderData['collection'] =
            collection; // Add the collection name to the order data
        ordersList.add(orderData);
      }
    }

    yield ordersList; // Yield the combined orders list
  }

  Widget _getOrderCollection(String collection) {
    switch (collection) {
      case 'in-progress':
        return Lottie.asset(
          'assets/animations/cooking.json',
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        );
      case 'completed':
        return Lottie.asset(
          'assets/animations/moving.json',
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        );
      default:
        return Lottie.asset(
          'assets/animations/pending.json',
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent, // Foody theme color
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _getUserOrders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var ordersList = snapshot.data!;

            if (ordersList.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }

            return ListView.builder(
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                var orderData = ordersList[index];

                return Card(
                  color: Colors.orangeAccent.withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(orderData['item_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${orderData['quantity']}'),
                        Text('Order Date: ${orderData['timestamp'].toDate()}'),
                        const SizedBox(height: 4.0),
                      ],
                    ),
                    trailing: _getOrderCollection(orderData['collection']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
