import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shop-app-dfa73.firebaseio.com/products.json';

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              title: prodData['title'],
              isFavorite: prodData['isFavorite'],
            ),
          );
        },
      );

      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-shop-app-dfa73.firebaseio.com/products.json';

    try {
      final res = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        id: json.decode(res.body)['name'],
      );
      _items.add(newProduct);

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-app-dfa73.firebaseio.com/products/${newProduct.id}.json';

      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('Invalid product id!');
    }
  }

  void deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-dfa73.firebaseio.com/products/$id.json';
    final existingProdIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProdIndex];

    _items.removeAt(existingProdIndex);
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(
        existingProdIndex,
        existingProduct,
      );
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
