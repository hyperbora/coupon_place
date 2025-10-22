import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/settings/model/user_reminder_setting.dart';

enum ReminderType { first, second }

class ReminderConfig {
  final ReminderType key;
  final Duration offset;
  final int hour;
  final int minute;
  final String Function(AppLocalizations loc) labelGetter;

  const ReminderConfig({
    required this.key,
    required this.offset,
    required this.hour,
    required this.minute,
    required this.labelGetter,
  });
}

List<ReminderConfig> buildReminderConfigs(UserReminderSetting setting) {
  final configs = <ReminderConfig>[];
  if (setting.firstReminderDays != null) {
    configs.add(
      ReminderConfig(
        key: ReminderType.first,
        offset: Duration(days: setting.firstReminderDays!),
        hour: setting.reminderHour ?? 9,
        minute: setting.reminderMinute ?? 0,
        labelGetter:
            (loc) =>
                setting.firstReminderDays == 0
                    ? loc.reminder_0d
                    : loc.reminder(setting.firstReminderDays!),
      ),
    );
  }
  if (setting.secondReminderDays != null) {
    configs.add(
      ReminderConfig(
        key: ReminderType.second,
        offset: Duration(days: setting.secondReminderDays!),
        hour: setting.reminderHour ?? 9,
        minute: setting.reminderMinute ?? 0,
        labelGetter:
            (loc) =>
                setting.secondReminderDays == 0
                    ? loc.reminder_0d
                    : loc.reminder(setting.secondReminderDays!),
      ),
    );
  }
  return configs;
}
