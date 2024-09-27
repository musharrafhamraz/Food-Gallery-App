import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailorapp/screens/list_of_menu_items.dart';

class TailorDashboard extends StatefulWidget {
  const TailorDashboard({super.key});

  @override
  _TailorDashboardState createState() => _TailorDashboardState();
}

class _TailorDashboardState extends State<TailorDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this); // 3 tabs: Orders, Progress, Completed
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Gallery',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orangeAccent, // Foody theme color
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Orders Tab: Fetching data from Firestore
          _buildOrdersTab(),
          // Progress Tab: Dummy content
          _buildTabContent('In Progress', Colors.deepOrangeAccent),
          // Completed Tab: Dummy content
          _buildTabContent('Completed Orders', Colors.greenAccent),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action when the button is pressed
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MenuListScreen(); // Navigate to the menu list screen
          }));
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, color: Colors.white), // Plus sign
      ),
    );
  }

  // Helper function to generate the tab content
  Widget _buildTabContent(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: 10, // Dummy data count
        itemBuilder: (context, index) {
          return Card(
            color: color.withOpacity(0.1),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: const Icon(Icons.shopping_bag, color: Colors.white),
              ),
              title: Text('$title Item ${index + 1}'),
              subtitle: const Text('Details of the order...'),
              trailing: Column(
                children: [
                  Icon(Icons.price_check_outlined),
                  Icon(Icons.delete),
                ],
              ),
              onTap: () {
                // Add navigation or action here
              },
            ),
          );
        },
      ),
    );
  }

  // Fetch Orders from Firestore and build the UI
  Widget _buildOrdersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.orangeAccent
                  .withOpacity(0.1), // Themed background color
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.shopping_bag, color: Colors.white),
                ),
                title: Text(order['item_name']),
                subtitle: Text(
                    'Quantity: ${order['quantity']}\nPrice: ${order['price']}'),
                trailing: const Icon(Icons.check),
                onTap: () {
                  // Handle order click
                },
              ),
            );
          },
        );
      },
    );
  }
}
