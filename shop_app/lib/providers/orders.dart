import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  Orders();

  void update(
    String authToken,
    String userId,
    List<OrderItem> _orders,
  ) {
    this.authToken = authToken;
    this.userId = userId;
    this._orders = _orders;

    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    final url =
        'https://flutter-shop-app-dfa73.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final res = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'title': cp.title,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-dfa73.firebaseio.com/orders/$userId.json?auth=$authToken';

    final res = await http.get(url);
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      _orders = [];
      return;
    }

    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  quantity: item['quantity'],
                  price: item['price'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
