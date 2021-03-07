import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification_model.dart';
import '../models/order_model.dart';
import '../repositories/notification_repository.dart';
import '../repositories/order_repository.dart';
import '../theme/app_theme.dart';

class NotificationType {
  const NotificationType._(this.value);

  final int value;

  static const NotificationType orderClosed = NotificationType._(0);
  static const NotificationType firstAlert = NotificationType._(1);
  static const NotificationType secondAlert = NotificationType._(2);
  static const NotificationType thirdAlert = NotificationType._(3);
}

class NotificationTask {
  static const String id = 'notifications';
  static const String name = 'notifications';
  static const Duration frequency = Duration(hours: 6);
  static const Duration initialDelay = Duration(minutes: 15);

  static const String _androidChannelId = 'closing_orders';
  static const String _androidChannelName = 'Closing Orders';
  static const String _androidChannelDescription = 'Receive notifications when orders are about to close';

  static const Map<NotificationType, int> _notifyOnRemainingDays = <NotificationType, int>{
    NotificationType.orderClosed: 0,
    NotificationType.firstAlert: 7,
    NotificationType.secondAlert: 3,
    NotificationType.thirdAlert: 1
  };

  static Future<void> run() async {
    final List<Order> orders = await OrderRepository.list();

    for (final Order order in orders) {
      final NotificationType notificationType = _getNotificationType(order);

      if (notificationType != null) {
        final List<Notification> sentNotifications = await NotificationRepository.list(orderId: order.id);

        final bool alreadySent = sentNotifications.any(
          (Notification e) => e.type == notificationType.value && e.orderClosesOn.isAtSameMomentAs(order.closesOn),
        );

        if (!alreadySent) {
          final int notificationId = await NotificationRepository.create(Notification(
            type: notificationType.value,
            orderId: order.id,
            orderClosesOn: order.closesOn,
          ));

          final int remainingDays = _getRemainingDays(order);

          await _showNotification(notificationId, order.name, _getNotificationMessage(remainingDays));
        }
      }
    }
  }

  static int _getRemainingDays(Order order) {
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final int days = order.closesOn.difference(today).inDays;

    return days > 0 ? days : 0;
  }

  static NotificationType _getNotificationType(Order order) {
    final int remainingDays = _getRemainingDays(order);

    if (remainingDays > _notifyOnRemainingDays[NotificationType.firstAlert]) {
      return null;
    }

    if (remainingDays > _notifyOnRemainingDays[NotificationType.secondAlert]) {
      return NotificationType.firstAlert;
    }

    if (remainingDays > _notifyOnRemainingDays[NotificationType.thirdAlert]) {
      return NotificationType.secondAlert;
    }

    if (remainingDays > _notifyOnRemainingDays[NotificationType.orderClosed]) {
      return NotificationType.thirdAlert;
    }

    return NotificationType.orderClosed;
  }

  static String _getNotificationMessage(int remainingDays) {
    if (remainingDays == 0) {
      return 'Buyer protection has ended';
    }

    if (remainingDays == 1) {
      return 'Buyer protection ends in 1 day';
    }

    return 'Buyer protection ends in $remainingDays days';
  }

  static Future<void> _showNotification(int id, String title, String body) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _androidChannelId, _androidChannelName, _androidChannelDescription,
        color: AppTheme.primary, enableLights: true, ledColor: AppTheme.primary, ledOnMs: 1000, ledOffMs: 500);

    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }
}
