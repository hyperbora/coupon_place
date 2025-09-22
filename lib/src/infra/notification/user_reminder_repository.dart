import 'package:shared_preferences/shared_preferences.dart';
import 'package:coupon_place/src/features/user/model/user_reminder_setting.dart';

class UserReminderRepository {
  static const _firstKey = 'reminder_first_days';
  static const _secondKey = 'reminder_second_days';

  Future<UserReminderSetting> load() async {
    final prefs = await SharedPreferences.getInstance();
    final first = prefs.getInt(_firstKey);
    final second = prefs.getInt(_secondKey);
    return UserReminderSetting(
      firstReminderDays: first,
      secondReminderDays: second,
    );
  }

  Future<void> save(UserReminderSetting setting) async {
    final prefs = await SharedPreferences.getInstance();
    if (setting.firstReminderDays != null) {
      await prefs.setInt(_firstKey, setting.firstReminderDays!);
    } else {
      await prefs.remove(_firstKey);
    }
    if (setting.secondReminderDays != null) {
      await prefs.setInt(_secondKey, setting.secondReminderDays!);
    } else {
      await prefs.remove(_secondKey);
    }
  }
}
