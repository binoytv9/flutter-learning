import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(
            context,
            listen: false,
          ).fetchAndSetOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                // do error handling
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Orders>(builder: (
                  ctx,
                  orderData,
                  child,
                ) {
                  return orderData.orders.length == 0
                      ? const Center(
                          child:
                              Text('Your didn\'t ordered anything. Try some!'),
                        )
                      : ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (_, index) => OrderItem(
                            orderData.orders[index],
                          ),
                        );
                });
              }
            }
          }),
    );
  }
}
