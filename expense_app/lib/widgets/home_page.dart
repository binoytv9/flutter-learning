import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import '../models/transaction.dart';
import '../widgets/transaction_list.dart';
import '../helpers/database.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(() {
      TransactionDatabaseProvider.db.addTransactionToDatabase(newTx);
    });
  }

  void _deleteTransaction(int txId) {
    setState(() {
      TransactionDatabaseProvider.db.deleteTransactionWithId(txId);
    });
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

  List<Transaction> getRecentTransactions(List<Transaction> transactions) {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(
          days: 7,
        )),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryCtx = MediaQuery.of(context);
    final isLandscape = mediaQueryCtx.orientation == Orientation.landscape;

    return FutureBuilder<List<Transaction>>(
      future: TransactionDatabaseProvider.db.getAllTransactions(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final userTransactions = snapshot.data;
          final PreferredSizeWidget appBar = Platform.isIOS
              ? CupertinoNavigationBar(
                  middle: Text(
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
                  title: Text(
                    APP_BAR_TEXT,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _startAddNewTransaction(context),
                    ),
                  ],
                );

          final bodyHeight = mediaQueryCtx.size.height -
              appBar.preferredSize.height -
              mediaQueryCtx.padding.top;

          final txListWidget = Container(
            height: bodyHeight * 0.7,
            child: TransactionList(userTransactions, _deleteTransaction),
          );

          final pageBody = SafeArea(
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          SHOW_CHART_TEXT,
                          style: Theme.of(context).textTheme.title,
                        ),
                        Switch.adaptive(
                          activeColor: Theme.of(context).accentColor,
                          value: _showChart,
                          onChanged: (val) {
                            setState(() {
                              _showChart = val;
                            });
                          },
                        ),
                      ],
                    ),
                  if (!isLandscape)
                    Container(
                      height: bodyHeight * 0.3,
                      child: Chart(getRecentTransactions(userTransactions)),
                    ),
                  if (!isLandscape) txListWidget,
                  if (isLandscape)
                    _showChart
                        ? Container(
                            height: bodyHeight * 0.7,
                            child:
                                Chart(getRecentTransactions(userTransactions)),
                          )
                        : txListWidget
                ],
              ),
            ),
          );
          return Platform.isIOS
              ? CupertinoPageScaffold(
                  child: pageBody,
                  navigationBar: appBar,
                )
              : Scaffold(
                  appBar: appBar,
                  body: pageBody,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
