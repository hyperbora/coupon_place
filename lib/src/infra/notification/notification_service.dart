import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class BasePayload {
  final Coupon coupon;

  BasePayload({required this.coupon});

  @override
  String toString() {
    return '/coupon/${coupon.folderId}/${coupon.id}';
  }
}

int _getNotificationId(BasePayload basePayload, ReminderType key) {
  return '${basePayload.toString()}${key.name}'.hashCode;
}

Future<void> registerCouponNotifications({
  required Coupon coupon,
  required AppLocalizations loc,
  required List<ReminderConfig> configs,
}) async {
  await cancelCouponNotifications(coupon: coupon);

  final validDate = coupon.validDate;
  if (validDate == null) return;
  if (validDate.isBefore(DateTime.now())) return;

  final basePayload = BasePayload(coupon: coupon);

  for (final config in configs) {
    final scheduledDateRaw = validDate.subtract(config.offset);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledDateRaw.year,
      scheduledDateRaw.month,
      scheduledDateRaw.day,
      9,
      0,
      0,
    );

    if (!scheduledDate.isAfter(DateTime.now())) {
      continue;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _getNotificationId(basePayload, config.key),
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
      payload: basePayload.toString(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

Future<void> cancelCouponNotifications({required Coupon coupon}) async {
  final basePayload = BasePayload(coupon: coupon);

  for (final key in ReminderType.values) {
    await flutterLocalNotificationsPlugin.cancel(
      _getNotificationId(basePayload, key),
    );
  }
}

Future<void> rescheduleAllNotifications({
  required List<Coupon> coupons,
  required AppLocalizations loc,
  required List<ReminderConfig> configs,
}) async {
  await flutterLocalNotificationsPlugin.cancelAll();

  for (final coupon in coupons) {
    if (coupon.enableAlarm == false) {
      continue;
    }

    final validDate = coupon.validDate;

    if (validDate != null && validDate.isAfter(DateTime.now())) {
      await registerCouponNotifications(
        coupon: coupon,
        loc: loc,
        configs: configs,
      );
    }
  }
}
