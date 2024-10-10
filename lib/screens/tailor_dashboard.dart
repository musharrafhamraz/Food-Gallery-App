import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailorapp/firebase/order_services.dart';
import 'package:tailorapp/screens/add_menu_screen.dart';
import 'package:tailorapp/screens/order_details_screen.dart';
import 'package:tailorapp/widgets/custom_drawer.dart';
import 'package:tailorapp/widgets/dialog_box.dart';

class TailorDashboard extends StatefulWidget {
  const TailorDashboard({super.key});

  @override
  TailorDashboardState createState() => TailorDashboardState();
}

class TailorDashboardState extends State<TailorDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Order Dashboard',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'In-Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersTab('orders'),
          _buildOrdersTab('progress'),
          _buildOrdersTab('completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MenuInputScreen(); // Navigate to the menu list screen
          }));
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, color: Colors.white), // Plus sign
      ),
    );
  }

  Widget _buildOrdersTab(String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No orders available.'));
        }

        var orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return Card(
              color: Colors.orangeAccent.withOpacity(0.1),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Icon(Icons.shopping_bag, color: Colors.white),
                ),
                title: Text(order['name']),
                subtitle: Text(
                    'has ordered ${order['quantity']} ${order['item_name']}'),
                trailing: _buildTrailingIcons(collection, order),
                onTap: collection ==
                        'orders' // Enable navigation only in 'orders' tab
                    ? () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderDetailsScreen(
                            orderId: order.id,
                            itemName: order['item_name'],
                            quantity: order['quantity'].toString(),
                            price: order['price'].toString(),
                          );
                        }));
                      }
                    : null, // Disable navigation for 'progress' and 'completed' tabs
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrailingIcons(String collection, QueryDocumentSnapshot order) {
    if (collection == 'orders') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              await moveOrder(order.id, 'orders', 'progress');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              bool? confirmed = await showConfirmationDialog(
                context,
                'Are you sure you want to delete this order?',
                () => Navigator.of(context).pop(true),
                () => Navigator.of(context).pop(false),
              );
              if (confirmed == true) {
                await deleteOrder(order.id, collection);
              }
            },
          ),
        ],
      );
    } else if (collection == 'progress') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              await moveOrder(order.id, 'progress', 'completed');
            },
          ),
        ],
      );
    } else {
      return const SizedBox.shrink(); // No icons in 'completed' tab
    }
  }
}
