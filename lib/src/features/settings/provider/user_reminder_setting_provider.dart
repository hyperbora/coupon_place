import 'package:coupon_place/src/features/coupon/provider/coupon_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/src/features/settings/model/user_reminder_setting.dart';
import 'package:coupon_place/src/infra/notification/user_reminder_repository.dart';
import 'package:coupon_place/src/infra/notification/notification_service.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

final userReminderSettingProvider =
    StateNotifierProvider<UserReminderSettingNotifier, UserReminderSetting>(
      (ref) => UserReminderSettingNotifier(ref, UserReminderRepository()),
    );

class UserReminderSettingNotifier extends StateNotifier<UserReminderSetting> {
  final Ref ref;
  final UserReminderRepository repository;

  UserReminderSettingNotifier(this.ref, this.repository)
    : super(UserReminderSetting.defaults) {
    _load();
  }

  Future<void> _load() async {
    state = await repository.load();
  }

  Future<void> updateFirst(int? days, AppLocalizations loc) async {
    state = state.copyWith(firstReminderDays: days);
    await repository.save(state);
    await _reschedule(loc);
  }

  Future<void> updateSecond(int? days, AppLocalizations loc) async {
    state = state.copyWith(secondReminderDays: days);
    await repository.save(state);
    await _reschedule(loc);
  }

  Future<void> updateTime(int hour, int minute, AppLocalizations loc) async {
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    await repository.save(state);
    await _reschedule(loc);
  }

  Future<void> _reschedule(AppLocalizations loc) async {
    final coupons = ref.read(allCouponsProvider);
    final configs = buildReminderConfigs(state);
    await rescheduleAllNotifications(
      coupons: coupons,
      loc: loc,
      configs: configs,
    );
  }
}
