import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tailorapp/firebase/order_services.dart';
import 'package:tailorapp/widgets/custom_button.dart';

class UserMenuItemDetailScreen extends StatefulWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;

  const UserMenuItemDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<UserMenuItemDetailScreen> createState() =>
      _UserMenuItemDetailScreenState();
}

class _UserMenuItemDetailScreenState extends State<UserMenuItemDetailScreen> {
  int _quantity = 1; // Initial quantity

  // Function to increment the quantity
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Function to decrement the quantity
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.2,
                image: AssetImage('assets/images/background.jpg'))),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the image on top
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                        progressIndicatorBuilder:
                            (context, child, loadingProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Name of the food item
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Price of the food item
                    Text(
                      'RS ${widget.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Description of the food item
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quantity and Button fixed to the bottom
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Quantity Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Quantity",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _decrementQuantity,
                              icon: const Icon(Icons.remove,
                                  color: Colors.redAccent),
                            ),
                            Text(
                              '$_quantity', // Display the current quantity
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: _incrementQuantity,
                              icon: const Icon(Icons.add, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Place order
                    CustomButton(
                      onPress: () {
                        placeOrder(widget.name, _quantity, widget.price)
                            .then((_) {
                          Fluttertoast.showToast(
                              msg: 'Order Placed Successfully.');
                        }).catchError((error) {
                          Fluttertoast.showToast(msg: 'Error Placing Order.');
                        });
                        // logic for placing order here.
                      },
                      buttonTxt: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
