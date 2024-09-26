import 'package:flutter/material.dart';
import 'package:tailorapp/screens/add_menu_screen.dart';

class TailorDashboard extends StatefulWidget {
  const TailorDashboard({super.key});

  @override
  _TailorDashboardState createState() => _TailorDashboardState();
}

class _TailorDashboardState extends State<TailorDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          // Orders Tab
          _buildTabContent('Orders', Colors.orangeAccent),
          // Progress Tab
          _buildTabContent('In Progress', Colors.deepOrangeAccent),
          // Completed Tab
          _buildTabContent('Completed Orders', Colors.greenAccent),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action when the button is pressed
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MenuInputScreen();
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
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add navigation or action here
              },
            ),
          );
        },
      ),
    );
  }
}
