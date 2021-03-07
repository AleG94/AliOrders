import 'package:sqflite/sqflite.dart';

import '../database/database_provider.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  NotificationRepository._();

  static const String _table = DatabaseTable.notifications;
  static final DatabaseProvider _dbProvider = DatabaseProvider();

  static Future<int> create(Notification notification) async {
    final Database db = await _dbProvider.database;

    return await db.insert(_table, notification.toMap());
  }

  static Future<List<Notification>> list({int orderId}) async {
    final Database db = await _dbProvider.database;

    final List<String> where = <String>[];
    final List<dynamic> whereArgs = <dynamic>[];

    if (orderId != null) {
      where.add('order_id = ?');
      whereArgs.add(orderId);
    }

    final List<Map<String, dynamic>> result = await db.query(_table, where: where.join(', '), whereArgs: whereArgs);
    final List<Notification> notifications = result.map<Notification>(Notification.fromMap).toList();

    return notifications;
  }

  static Future<void> update(Notification notification) async {
    final Database db = await _dbProvider.database;

    await db.update(_table, notification.toMap(), where: 'id = ?', whereArgs: <dynamic>[notification.id]);
  }

  static Future<void> delete(int id) async {
    final Database db = await _dbProvider.database;

    await db.delete(_table, where: 'id = ?', whereArgs: <dynamic>[id]);
  }
}
