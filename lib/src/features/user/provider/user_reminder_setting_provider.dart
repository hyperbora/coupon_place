import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/src/features/user/model/user_reminder_setting.dart';
import 'package:coupon_place/src/infra/notification/user_reminder_repository.dart';

final userReminderSettingProvider =
    StateNotifierProvider<UserReminderSettingNotifier, UserReminderSetting>(
      (ref) => UserReminderSettingNotifier(UserReminderRepository()),
    );

class UserReminderSettingNotifier extends StateNotifier<UserReminderSetting> {
  final UserReminderRepository repository;

  UserReminderSettingNotifier(this.repository)
    : super(UserReminderSetting.defaults) {
    _load();
  }

  Future<void> _load() async {
    state = await repository.load();
  }

  Future<void> updateFirst(int? days) async {
    state = state.copyWith(firstReminderDays: days);
    await repository.save(state);
  }

  Future<void> updateSecond(int? days) async {
    state = state.copyWith(secondReminderDays: days);
    await repository.save(state);
  }
}
