import 'package:flutter/material.dart';
import 'package:foodapp/widgets/background_widget.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/providers/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: favProvider.favoriteItems.isEmpty
            ? const Center(
                child: Text(
                  'No favorite items yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : GridView.builder(
                itemCount: favProvider.favoriteItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    mainAxisExtent: 260),
                itemBuilder: (context, index) {
                  final favoriteItem = favProvider.favoriteItems[index];
                  return favoriteItem;
                },
              ),
      ),
    );
  }
}
