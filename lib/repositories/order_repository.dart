import 'package:sqflite/sqflite.dart';

import '../database/database_provider.dart';
import '../models/order_model.dart';

class OrderRepository {
  OrderRepository._();

  static const String _table = DatabaseTable.orders;
  static final DatabaseProvider _dbProvider = DatabaseProvider();

  static Future<int> create(Order order) async {
    final Database db = await _dbProvider.database;

    return await db.insert(_table, order.toMap());
  }

  static Future<List<Order>> list() async {
    final Database db = await _dbProvider.database;

    final List<Map<String, dynamic>> result = await db.query(_table, orderBy: 'closes_on ASC');
    final List<Order> orders = result.map<Order>(Order.fromMap).toList();

    return orders;
  }

  static Future<void> update(Order order) async {
    final Database db = await _dbProvider.database;

    await db.update(_table, order.toMap(), where: 'id = ?', whereArgs: <dynamic>[order.id]);
  }

  static Future<void> delete(int id) async {
    final Database db = await _dbProvider.database;

    await db.delete(_table, where: 'id = ?', whereArgs: <dynamic>[id]);
  }
}
