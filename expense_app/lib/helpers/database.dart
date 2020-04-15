import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

import '../models/transaction.dart';

class TransactionDatabaseProvider {
  TransactionDatabaseProvider._();

  static final TransactionDatabaseProvider db = TransactionDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_FILE);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $DB_TABLE (
          $DB_ID INTEGER PRIMARY KEY, 
          $DB_TITLE TEXT NOT NULL, 
          $DB_AMOUNT REAL NOT NULL, 
          $DB_DATE INT NOT NULL)
          ''');
    });
  }

  addTransactionToDatabase(Transaction tx) async {
    final db = await database;
    var raw = await db.insert(
      DB_TABLE,
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updateTransaction(Transaction tx) async {
    final db = await database;
    var response = await db
        .update(DB_TABLE, tx.toMap(), where: "$DB_ID = ?", whereArgs: [tx.id]);
    return response;
  }

  Future<Transaction> getTransactionWithId(int id) async {
    final db = await database;
    var response =
        await db.query(DB_TABLE, where: "$DB_ID = ?", whereArgs: [id]);
    return response.isNotEmpty ? Transaction.fromMap(response.first) : null;
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    var response = await db.query(DB_TABLE);
    List<Transaction> list =
        response.map((c) => Transaction.fromMap(c)).toList();
    return list;
  }

  deleteTransactionWithId(int id) async {
    final db = await database;
    return db.delete(DB_TABLE, where: "$DB_ID = ?", whereArgs: [id]);
  }

  deleteAllTransactions() async {
    final db = await database;
    db.delete(DB_TABLE);
  }
}
