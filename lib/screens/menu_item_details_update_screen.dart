import 'package:flutter/material.dart';
import 'package:foodapp/widgets/background_widget.dart';
import 'package:foodapp/widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuItemDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;

  const MenuItemDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: Column(
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
                        imageUrl: imageUrl,
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
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Price of the food item
                    Text(
                      'RS $price',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Description of the food item
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button fixed to the bottom
            SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    onPress: () {
                      // logic for updating the food item here.
                    },
                    buttonTxt: const Text(
                      'Update Food Item',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
