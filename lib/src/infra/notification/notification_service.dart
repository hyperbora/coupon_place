import 'dart:convert';

import 'package:coupon_place/src/core/router/app_router.dart';
import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 알림에 포함되는 쿠폰 정보
class BasePayload {
  final String routeName;
  final Map<String, String> pathParams;

  BasePayload({required this.routeName, required this.pathParams});

  factory BasePayload.fromCoupon(Coupon coupon) {
    return BasePayload(
      routeName: AppRoutes.couponDetail.name,
      pathParams: {'folderId': coupon.folderId, 'couponId': coupon.id},
    );
  }

  String toPayload() =>
      jsonEncode({'routeName': routeName, 'pathParams': pathParams});

  static BasePayload fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return BasePayload(
      routeName: jsonMap['routeName'] as String,
      pathParams: Map<String, String>.from(
        jsonMap['pathParams'] as Map<dynamic, dynamic>,
      ),
    );
  }
}

/// 초기화
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
      _handleNotificationPayload(response.payload);
    },
  );

  // 앱이 알림을 통해 실행된 경우
  final NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details?.didNotificationLaunchApp ?? false) {
    _handleNotificationPayload(details!.notificationResponse?.payload);
  }

  tz.initializeTimeZones();
}

/// 알림 클릭 시 처리 로직
Future<void> _handleNotificationPayload(String? payload) async {
  if (payload == null) return;

  await Future.delayed(const Duration(milliseconds: 500));

  BasePayload basePayload;
  try {
    basePayload = BasePayload.fromJson(payload);
  } catch (_) {
    return;
  }

  // 홈에서 바로 진입한 경우 대비
  if (!appRouter.canPop()) {
    appRouter.goNamed(AppRoutes.mainTab.name);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  appRouter.pushNamed(
    basePayload.routeName,
    pathParameters: basePayload.pathParams,
  );
}

/// 고정 해시 기반 ID 생성
int _getNotificationId(BasePayload basePayload, ReminderType key) {
  final input = '${basePayload.pathParams['couponId']}-${key.name}';
  return input.hashCode & 0x7FFFFFFF;
}

/// 쿠폰별 알림 등록
Future<void> registerCouponNotifications({
  required Coupon coupon,
  required AppLocalizations loc,
  required List<ReminderConfig> configs,
}) async {
  await cancelCouponNotifications(coupon: coupon);

  final validDate = coupon.validDate;
  if (validDate == null) return;

  if (coupon.isUsed) return;

  if (coupon.enableAlarm == false) return;

  final basePayload = BasePayload.fromCoupon(coupon);
  final Duration offsetTime = DateTime.now().timeZoneOffset;
  for (final config in configs) {
    final targetDate = validDate.subtract(config.offset);
    final scheduledDate = tz.TZDateTime.local(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      config.hour,
      config.minute,
    ).subtract(offsetTime);

    final now = tz.TZDateTime.now(tz.local);

    if (scheduledDate.isBefore(now)) continue;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _getNotificationId(basePayload, config.key),
      loc.couponExpireNotificationTitle,
      config.labelGetter(loc),
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'coupon_channel',
          'Coupon Expiration Notifications',
          channelDescription: 'Notifications for upcoming coupon expirations',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: basePayload.toPayload(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

/// 특정 쿠폰의 알림 취소
Future<void> cancelCouponNotifications({required Coupon coupon}) async {
  final basePayload = BasePayload.fromCoupon(coupon);

  for (final key in ReminderType.values) {
    await flutterLocalNotificationsPlugin.cancel(
      _getNotificationId(basePayload, key),
    );
  }
}

/// 모든 쿠폰 알림 재등록
Future<void> rescheduleAllNotifications({
  required List<Coupon> coupons,
  required AppLocalizations loc,
  required List<ReminderConfig> configs,
}) async {
  for (final coupon in coupons) {
    if (!coupon.enableAlarm || coupon.isUsed) continue;

    await cancelCouponNotifications(coupon: coupon);
    await registerCouponNotifications(
      coupon: coupon,
      loc: loc,
      configs: configs,
    );
  }
}
