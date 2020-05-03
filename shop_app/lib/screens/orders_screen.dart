import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: orderData.orders.length == 0
          ? const Center(
              child: Text('Your didn\'t ordered anything. Try some!'),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (_, index) => OrderItem(
                orderData.orders[index],
              ),
            ),
    );
  }
}
