import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Widget> _favoriteItems = [];

  List<Widget> get favoriteItems => _favoriteItems;

  void toggleFavorites(Widget favoriteItem) {
    final isExist = _favoriteItems.contains(favoriteItem);

    if (isExist) {
      _favoriteItems.remove(favoriteItem);
    } else {
      _favoriteItems.add(favoriteItem);
    }
    notifyListeners();
  }

  bool isFavorite(Widget favoriteItem) {
    return _favoriteItems.contains(favoriteItem);
  }
}
