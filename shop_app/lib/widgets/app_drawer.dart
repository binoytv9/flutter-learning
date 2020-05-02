import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  List<Widget> buildListTile(
    BuildContext ctx,
    String title,
    IconData icon,
    Function onTap,
  ) {
    return [
      Divider(),
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
            title: Text('Hello friend'),
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
        ],
      ),
    );
  }
}
