import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/transaction.dart';
import '../helpers/database.dart';
import './transaction_list.dart';
import './chart.dart';
import './new_transaction.dart';

class PageBody extends StatefulWidget {
  final appBarHeight;

  PageBody(this.appBarHeight);

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  bool _showChart = false;
  Future<List<Transaction>> allTransactionsFuture;

  Future<List<Transaction>> _getAllTransaction() async {
    return await TransactionDatabaseProvider.db.getAllTransactions();
  }

  void _deleteTransaction(Transaction tx) {
    setState(() {
      TransactionDatabaseProvider.db.deleteTransactionWithId(tx.id);
    });

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("${tx.title} dismissed")));
  }

  List<Transaction> _getRecentTransactions(List<Transaction> transactions) {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(
          days: 7,
        )),
      );
    }).toList();
  }

  void _updateTransaction(Transaction updatedTx) {
    setState(() {
      TransactionDatabaseProvider.db.updateTransaction(updatedTx);
    });
  }

  void _startUpdateTransaction(BuildContext ctx, Transaction tx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_updateTransaction, tx),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryCtx = MediaQuery.of(context);
    final isLandscape = mediaQueryCtx.orientation == Orientation.landscape;

    final bodyHeight = mediaQueryCtx.size.height -
        widget.appBarHeight -
        mediaQueryCtx.padding.top;

    allTransactionsFuture = _getAllTransaction();

    return FutureBuilder<List<Transaction>>(
        future: allTransactionsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final userTransactions = snapshot.data.reversed.toList();

            final txListWidget = Container(
              height: bodyHeight * 0.7,
              child: TransactionList(
                  userTransactions, _deleteTransaction, _startUpdateTransaction),
            );

            return SafeArea(
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
                        child: Chart(_getRecentTransactions(userTransactions)),
                      ),
                    if (!isLandscape) txListWidget,
                    if (isLandscape)
                      _showChart
                          ? Container(
                              height: bodyHeight * 0.63,
                              child: Chart(
                                  _getRecentTransactions(userTransactions)),
                            )
                          : txListWidget
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(),
            );
          }
        });
  }
}
