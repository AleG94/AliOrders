import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTable {
  static const String orders = 'orders';
  static const String notifications = 'notifications';
}

class DatabaseProvider {
  factory DatabaseProvider() {
    return _instance;
  }

  DatabaseProvider._();

  static final DatabaseProvider _instance = DatabaseProvider._();
  static const String _databaseName = 'aliorders.db';

  Database _database;

  Future<Database> get database async {
    return _database ??= await _createDatabase();
  }

  Future<Database> _createDatabase() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    final Database database = await openDatabase(path, version: 1, onCreate: _initDatabase);

    return database;
  }

  Future<void> _initDatabase(Database database, int version) async {
    await database.execute(
      'CREATE TABLE ${DatabaseTable.orders} ( '
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name varchar(255), '
      'shipped_on int(11), '
      'closes_on int(11) '
      ')',
    );

    await database.execute(
      'CREATE TABLE ${DatabaseTable.notifications} ( '
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'type int(11), '
      'order_closes_on int(11), '
      'order_id int(11), '
      'FOREIGN KEY (order_id) REFERENCES orders(id) '
      ')',
    );
  }
}
