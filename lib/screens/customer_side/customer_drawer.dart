import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tailorapp/screens/customer_side/customer_order_list.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  Future<String?> fetchUserName() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail != null) {
        // Query Firestore to get the user's name
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .limit(1) // Limit to 1 result
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first['age'];
        }
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return null;
  }

  Future<String?> fetchUserEmail() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail != null) {
        // Query Firestore to get the user's name
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .limit(1) // Limit to 1 result
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first['email'];
        }
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<String?>(
            future: fetchUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.orangeAccent),
                  accountName: Text(
                    'Hi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    'Fetching name...',
                    style: TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.orangeAccent),
                  accountName: Text(
                    'Error',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    'Unable to fetch name',
                    style: TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.error),
                  ),
                );
              } else {
                // Display the fetched user name and email
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.orangeAccent),
                  accountName: Text(
                    'Hi ${snapshot.data}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Image(
                      image: AssetImage('assets/images/food.png'),
                    ),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle Home navigation
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Order History'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserOrdersScreen();
              }));
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle Logout
              },
            ),
          ),
        ],
      ),
    );
  }
}