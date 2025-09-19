import 'package:coupon_place/src/features/coupon/model/coupon.dart';
import 'package:coupon_place/src/features/folder/model/folder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleCouponNotification(
  Folder folder,
  Coupon coupon,
  String title,
  String message,
) async {
  final validDate = coupon.validDate;
  if (validDate == null) {
    return;
  }
  tz.initializeTimeZones();
  final scheduledDate = tz.TZDateTime.from(
    validDate.subtract(const Duration(days: 7)),
    tz.local,
  );

  final payload = '/coupon/${folder.id}/${coupon.id}';
  await flutterLocalNotificationsPlugin.zonedSchedule(
    payload.hashCode,
    title,
    message,
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'coupon_channel',
        'coupon_expiration_notifications',
        channelDescription: 'Coupon expiration notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    payload: payload,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
