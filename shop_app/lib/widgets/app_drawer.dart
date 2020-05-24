import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  List<Widget> buildListTile(
    BuildContext ctx,
    String title,
    IconData icon,
    Function onTap,
  ) {
    return [
      const Divider(),
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello friend'),
            automaticallyImplyLeading: false,
          ),
          ...buildListTile(
            context,
            'Shop',
            Icons.shop,
            () {
              Navigator.of(context).pushReplacementNamed(
                '/',
              );
            },
          ),
          ...buildListTile(
            context,
            'Orders',
            Icons.payment,
            () {
              Navigator.of(context).pushReplacementNamed(
                OrdersScreen.routeName,
              );
            },
          ),
          ...buildListTile(
            context,
            'Manage Products',
            Icons.edit,
            () {
              Navigator.of(context).pushReplacementNamed(
                UserProductsScreen.routeName,
              );
            },
          ),
          ...buildListTile(
            context,
            'Logout',
            Icons.exit_to_app,
            () async {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              await Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
            },
          ),
        ],
      ),
    );
  }
}
