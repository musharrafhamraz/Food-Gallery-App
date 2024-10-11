import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailorapp/screens/customer_side/all_menu_list.dart';
import 'package:tailorapp/screens/customer_side/menu_list_item_details.dart';
import 'package:tailorapp/widgets/menu_item.dart';

class UserMenuListScreen extends StatefulWidget {
  const UserMenuListScreen({super.key});

  @override
  State<UserMenuListScreen> createState() => _UserMenuListScreenState();
}

class _UserMenuListScreenState extends State<UserMenuListScreen> {
  String? _selectedCategory; // Track the selected category

  void _updateSelectedCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _showAllItems(String category) {
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.2,
                image: AssetImage('assets/images/background.jpg'))),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section of the screen
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FOOD GALLERY',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Open Sans'),
                      ),
                      const Text(
                        'Order Your Favourite Food',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans'),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildFoodOfferContainer(
                              'Grab Our Exclusive\nFood Discounts',
                              'Order Now',
                              Colors.orange[100]!,
                              Colors.orangeAccent,
                              'assets/images/food.png',
                            ),
                            buildFoodOfferContainer(
                              'Buy One Get One\nFree Pizza!',
                              'Order Pizza',
                              Colors.green[100]!,
                              Colors.greenAccent,
                              'assets/images/food.png',
                            ),
                            buildFoodOfferContainer(
                              'Special Sushi\nCombo Deal!',
                              'Order Sushi',
                              Colors.blue[100]!,
                              Colors.blueAccent,
                              'assets/images/food.png',
                            ),
                            buildFoodOfferContainer(
                              'Delicious Burger\nwith 20% Off!',
                              'Order Burger',
                              Colors.red[100]!,
                              Colors.redAccent,
                              'assets/images/food.png',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Category Scrollable Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CategoryButton(
                                onSelectCategory: _showAllItems,
                                imgPath: 'assets/images/food.png',
                                label: 'All'),
                            CategoryButton(
                                onSelectCategory: _updateSelectedCategory,
                                imgPath: 'assets/images/burger.png',
                                label: 'Burger'),
                            CategoryButton(
                                onSelectCategory: _updateSelectedCategory,
                                imgPath: 'assets/images/tea.png',
                                label: 'Tea'),
                            CategoryButton(
                                onSelectCategory: _updateSelectedCategory,
                                imgPath: 'assets/images/biryani.png',
                                label: 'Biryani'),
                            CategoryButton(
                                onSelectCategory: _updateSelectedCategory,
                                imgPath: 'assets/images/chinese.png',
                                label: 'Chinese'),
                            CategoryButton(
                                onSelectCategory: _updateSelectedCategory,
                                imgPath: 'assets/images/juice.png',
                                label: 'Juices'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recommended For You',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open Sans'),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const AllMenuList();
                              }));
                            },
                            child: const Text('See All'))
                      ]),
                ),
                const SizedBox(height: 8),

                // Bottom Section - Menu Items ListView
                SizedBox(
                  height: 280, // Adjust height to fit your design needs

                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_selectedCategory == null)
                        ? FirebaseFirestore.instance
                            .collection('menuItems')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('menuItems')
                            .where('category', isEqualTo: _selectedCategory)
                            .snapshots(),
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

                      final menuItems = snapshot.data?.docs ?? [];

                      if (menuItems.isEmpty) {
                        return const Center(
                          child: Text(
                            'No menu items available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem = menuItems[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserMenuItemDetailScreen(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFoodOfferContainer(
    String offerText,
    String buttonText,
    Color backgroundColor,
    Color buttonColor,
    String imagePath,
  ) {
    return Container(
      width: 300, // Adjust the width as needed
      height: 200, // Increased height
      margin: const EdgeInsets.all(8.0), // Space between containers
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200, width: 3),
        // image: const DecorationImage(
        //     fit: BoxFit.cover,
        //     opacity: 0.9,
        //     image: AssetImage('assets/images/card_background.jpg')),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  offerText,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans',
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {}, // Implement action here
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image(
            image: AssetImage(imagePath),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String imgPath;
  final String label;
  final Function(String) onSelectCategory;

  const CategoryButton(
      {super.key,
      required this.label,
      required this.imgPath,
      required this.onSelectCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectCategory(label);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange.shade200, width: 3),
                  borderRadius: BorderRadius.circular(35)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image(
                    fit: BoxFit.contain,
                    height: 50,
                    image: AssetImage(imgPath)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Open Sans'),
            ),
          ],
        ),
      ),
    );
  }
}
