import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/transaction.dart';
import '../helpers/database.dart';
import './transaction_list.dart';
import './chart.dart';

class PageBody extends StatefulWidget {
  final appBarHeight;

  PageBody(this.appBarHeight);

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  bool _showChart = false;

  void _deleteTransaction(int txId) {
    setState(() {
      TransactionDatabaseProvider.db.deleteTransactionWithId(txId);
    });
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

  @override
  Widget build(BuildContext context) {
    final mediaQueryCtx = MediaQuery.of(context);
    final isLandscape = mediaQueryCtx.orientation == Orientation.landscape;

    final bodyHeight = mediaQueryCtx.size.height -
        widget.appBarHeight -
        mediaQueryCtx.padding.top;

    return FutureBuilder<List<Transaction>>(
        future: TransactionDatabaseProvider.db.getAllTransactions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final userTransactions = snapshot.data;

            final txListWidget = Container(
              height: bodyHeight * 0.7,
              child: TransactionList(userTransactions, _deleteTransaction),
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
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
