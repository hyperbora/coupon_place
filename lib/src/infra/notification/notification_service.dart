import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/coupon/model/coupon.dart';
import 'package:coupon_place/src/features/folder/model/folder.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String _getBasePayload(Folder folder, Coupon coupon) {
  return '/coupon/${folder.id}/${coupon.id}';
}

Future<void> registerCouponNotifications({
  required Folder folder,
  required Coupon coupon,
  required AppLocalizations loc,
  List<ReminderConfig>? configs,
}) async {
  final validDate = coupon.validDate;
  if (validDate == null) return;
  if (validDate.isBefore(DateTime.now())) return;

  final basePayload = _getBasePayload(folder, coupon);

  final reminders = configs ?? defaultReminderConfigs;
  for (final config in reminders) {
    final scheduledDate = tz.TZDateTime.from(
      validDate.subtract(config.offset),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      '$basePayload${config.key}'.hashCode,
      loc.couponExpireNotificationTitle,
      config.labelGetter(loc),
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
      payload: basePayload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

Future<void> cancelCouponNotifications({
  required Folder folder,
  required Coupon coupon,
  List<ReminderConfig>? configs,
}) async {
  final basePayload = _getBasePayload(folder, coupon);

  final reminders = configs ?? defaultReminderConfigs;

  for (final config in reminders) {
    await flutterLocalNotificationsPlugin.cancel(
      '$basePayload${config.key}'.hashCode,
    );
  }
}
