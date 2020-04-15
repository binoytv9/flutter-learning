import 'package:flutter/foundation.dart';

const DB_ID = 'id';
const DB_TITLE = 'title';
const DB_AMOUNT = 'amount';
const DB_DATE = 'date';
const DB_TABLE = 'transactions';
const DB_FILE = 'transaction.db';

const APP_BAR_TEXT = 'Personal Expenses';
const SHOW_CHART_TEXT = 'Show Chart';

const DB_INVALID_ID = -1;

class Transaction {
  int id = DB_INVALID_ID;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    @required this.title,
    @required this.amount,
    @required this.date,
  });

  Transaction._all({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });

  factory Transaction.fromMap(Map<String, dynamic> dict) => Transaction._all(
        id: dict[DB_ID],
        title: dict[DB_TITLE],
        amount: dict[DB_AMOUNT],
        date: DateTime.fromMillisecondsSinceEpoch(dict[DB_DATE]),
      );

  Map<String, dynamic> toMap() => {
        DB_TITLE: title,
        DB_AMOUNT: amount,
        DB_DATE: date.millisecondsSinceEpoch,
      };
}
