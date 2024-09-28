import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailorapp/screens/menu_item_details_screen.dart';
import 'package:tailorapp/widgets/menu_item.dart';

class MenuListScreen extends StatelessWidget {
  const MenuListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Items'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menuItems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading menu items'),
            );
          }

          final menuItems = snapshot.data!.docs;

          if (menuItems.isEmpty) {
            return const Center(
              child: Text(
                'No menu items available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Using GridView.builder to display menu items in a grid
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7, // Adjust the height/width ratio
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final menuItem = menuItems[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuItemDetailScreen(
                        name: menuItem['name'],
                        description: menuItem['description'],
                        price: menuItem['price'].toString(),
                        imageUrl: menuItem['imageUrl'],
                      ),
                    ),
                  );
                },
                child: MenuItem(
                  name: menuItem['name'],
                  description: menuItem['description'],
                  price: menuItem['price'].toString(),
                  imageUrl: menuItem['imageUrl'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
