

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApiModel{
static  final FlutterLocalNotificationsPlugin _notification = FlutterLocalNotificationsPlugin();
static final onNotifications = BehaviorSubject<String>();
  static Future _notificationDetails() async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max  
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android= AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
  await _notification.initialize(
  settings,
  onSelectNotification: (payload) async {
    onNotifications.add(payload.toString());
  },
  );
  }
  static Future showNotification({
  int id =0,
  String? title,
  String? body,
  String? payload,

  }) async=> _notification.show(
    id,
    title,
    body,
    await _notificationDetails(),
    payload: payload,
    );
  

}