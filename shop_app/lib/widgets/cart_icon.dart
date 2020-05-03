import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import './badge.dart';

class CartIcon extends StatelessWidget {
  final Product product;

  CartIcon(this.product);

  Widget buildIconButton(
    BuildContext ctx,
    IconData icon,
    Product prod,
    Cart cart,
  ) {
    return IconButton(
      icon: Icon(
        icon,
      ),
      onPressed: () {
        cart.addItem(
          prod.id,
          prod.price,
          prod.title,
        );
        Scaffold.of(ctx).hideCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: const Text(
              'Added item to cart!',
            ),
            duration: const Duration(
              seconds: 2,
            ),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => cart.removeSingleItem(
                prod.id,
              ),
            ),
          ),
        );
      },
      color: Theme.of(ctx).accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
    );

    return cart.productQuantity(product.id) == 0
        ? buildIconButton(
            context,
            Icons.add_shopping_cart,
            product,
            cart,
          )
        : Badge(
            color: Colors.cyan,
            child: buildIconButton(
              context,
              Icons.shopping_cart,
              product,
              cart,
            ),
            value: cart.productQuantity(product.id).toString(),
          );
  }
}
