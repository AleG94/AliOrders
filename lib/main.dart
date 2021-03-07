import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'screens/home.dart';
import 'tasks/notification_task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@drawable/ic_notification'),
    iOS: IOSInitializationSettings(),
  );

  FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask(
    NotificationTask.id,
    NotificationTask.name,
    frequency: NotificationTask.frequency,
    initialDelay: NotificationTask.initialDelay,
  );

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp])
      .then((_) => runApp(const AliOrders()));
}

void callbackDispatcher() {
  Workmanager.executeTask((String task, Map<String, dynamic> inputData) async {
    await NotificationTask.run();
    return true;
  });
}

class AliOrders extends StatelessWidget {
  const AliOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AliOrders',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(),
    );
  }
}
