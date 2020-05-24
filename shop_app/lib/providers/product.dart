import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url =
        'https://flutter-shop-app-dfa73.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    var existingFav = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final res = await http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );

    if (res.statusCode >= 400) {
      isFavorite = existingFav;
      notifyListeners();
      throw HttpException('Couldn\'t update favorite');
    }
  }
}
