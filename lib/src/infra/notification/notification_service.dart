import 'package:coupon_place/src/core/router/app_router.dart';
import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class BasePayload {
  final Coupon coupon;

  BasePayload({required this.coupon});

  @override
  String toString() {
    return '/coupon/${coupon.folderId}/${coupon.id}';
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload == null) {
        return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        appRouter.go(AppRoutes.mainTab);
        Future.delayed(const Duration(milliseconds: 100), () {
          appRouter.push(payload);
        });
      });
    },
  );

  final NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details?.didNotificationLaunchApp ?? false) {
    final payload = details!.notificationResponse?.payload;
    if (payload != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        appRouter.go(AppRoutes.mainTab);
        Future.delayed(const Duration(milliseconds: 100), () {
          appRouter.push(payload);
        });
      });
    }
  }

  tz.initializeTimeZones();
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
    final now = tz.TZDateTime.now(tz.local);
    final targetDate = validDate.subtract(config.offset);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      targetDate.year,
      targetDate.month,
      targetDate.day,
      9,
    );

    if (!scheduledDate.isAfter(now)) {
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
    if (coupon.isUsed) {
      continue;
    }

    final validDate = coupon.validDate;

    if (validDate == null) {
      continue;
    }

    if (validDate.isAfter(DateTime.now())) {
      await registerCouponNotifications(
        coupon: coupon,
        loc: loc,
        configs: configs,
      );
    }
  }
}
