import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class FavoriteIcon extends StatefulWidget {
  final BuildContext productProviderCtx;

  FavoriteIcon({
    this.productProviderCtx = null,
  });

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    Product product;
    if (widget.productProviderCtx == null) {
      product = Provider.of<Product>(context);
    } else {
      product = Provider.of<Product>(widget.productProviderCtx);
    }

    return IconButton(
      icon: Icon(
        product.isFavorite ? Icons.favorite : Icons.favorite_border,
      ),
      onPressed: () {
        setState(() {
          product.toggleFavoriteStatus();
        });
      },
      color: Theme.of(context).accentColor,
    );
  }
}
