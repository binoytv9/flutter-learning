import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/auth.dart';

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

    final authData = Provider.of<Auth>(context, listen: false);

    return IconButton(
      icon: Icon(
        product.isFavorite ? Icons.favorite : Icons.favorite_border,
      ),
      onPressed: () async {
        try {
          setState(() {});
          await product.toggleFavoriteStatus(authData.token, authData.userId);
        } catch (err) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                err.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          );
          setState(() {});
        }
      },
      color: Theme.of(context).accentColor,
    );
  }
}
