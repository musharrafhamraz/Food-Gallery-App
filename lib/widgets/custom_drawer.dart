import 'package:flutter/material.dart';
import 'package:foodapp/auth/auth_services.dart';
import 'package:foodapp/auth/login_screen.dart';
import 'package:foodapp/screens/add_menu_screen.dart';
import 'package:foodapp/screens/list_of_menu_items.dart';
import 'package:foodapp/widgets/dialog_box.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          const UserAccountsDrawerHeader(
            decoration:
                BoxDecoration(color: Colors.orangeAccent // Foody theme color
                    ),
            accountName: Text(
              'Food Gallery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              'From Appetite To Peace',
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              child: Image(
                image: AssetImage('assets/images/food.png'),
              ),
            ),
          ),
          // ListTile for Home
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.orangeAccent,
            ),
            title: const Text('Home'),
            onTap: () {
              // Navigate to Home
              Navigator.pop(context); // Close the drawer
            },
          ),
          // ListTile for Orders
          ListTile(
            leading: const Icon(
              Icons.restaurant_menu,
              color: Colors.orangeAccent,
            ),
            title: const Text('Menu'),
            onTap: () {
              // Navigate to Orders
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const MenuListScreen();
              })); // Assuming a named route
            },
          ),
          // ListTile for Progress
          ListTile(
            leading: const Icon(
              Icons.restaurant_outlined,
              color: Colors.orangeAccent,
            ),
            title: const Text('Add Menu Item'),
            onTap: () {
              // Navigate to Progress
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const MenuInputScreen();
              }));
            },
          ),

          const Divider(), // Divider for separation
          // // ListTile for Logout
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.orangeAccent,
            ),
            title: const Text('Logout'),
            onTap: () {
              showConfirmationDialog(
                context,
                'Are you sure you want to logout?',
                () {
                  try {
                    auth.logoutUser();
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (conetxt) {
                      return const LoginScreen();
                    }));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                () => Navigator.of(context).pop(false),
              );
            },
          )
        ],
      ),
    );
  }
}
