import 'dart:io';

import 'package:Daily_Quote/models/quote_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String quoteTable = 'quote_table';
  String colId = 'id';
  String colQuoteText = 'quote_text';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'quote_list.db';
    // var databasesPath = await getDatabasesPath();
    // String path = databasesPath + 'demo.db';
    final quoteDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return quoteDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $quoteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colQuoteText TEXT)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(quoteTable);
    return result;
  }

  Future<List<Quote>> getQuoteList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Quote> quoteList = [];
    taskMapList.forEach((quoteMap) {
      quoteList.add(Quote.fromMap(quoteMap));
    });
    return quoteList;
  }

  Future<int> insertQuote(Quote quote) async {
    Database db = await this.db;
    final int result = await db.insert(quoteTable, quote.toMap());
    print("The result for adding is " + result.toString());
    return result;
  }
}
