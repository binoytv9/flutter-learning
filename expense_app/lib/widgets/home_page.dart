import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './page_body.dart';
import './new_transaction.dart';
import '../models/transaction.dart';
import '../helpers/database.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addNewTransaction(Transaction newTx) {
    setState(() {
      TransactionDatabaseProvider.db.addTransactionToDatabase(newTx);
    });

    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
      "${newTx.title} added",
      textAlign: TextAlign.center,
    )));
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              APP_BAR_TEXT,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text(
              APP_BAR_TEXT,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            key: _scaffoldKey,
            child: PageBody(appBar.preferredSize.height),
            navigationBar: appBar,
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: appBar,
            body: PageBody(appBar.preferredSize.height),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
