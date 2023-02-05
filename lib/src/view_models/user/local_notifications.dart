import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../exports_main.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() async {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_stat_notification"),
      iOS: IOSInitializationSettings(),
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage remoteMessage) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "ladytabtabId",
          "LadyTabtab",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        remoteMessage.notification!.title,
        remoteMessage.notification!.body,
        notificationDetails,
      );
    } on Exception {}
  }
}
