import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/user/model/user_reminder_setting.dart';

class ReminderConfig {
  final String key;
  final Duration offset;
  final String Function(AppLocalizations loc) labelGetter;

  const ReminderConfig({
    required this.key,
    required this.offset,
    required this.labelGetter,
  });
}

final List<ReminderConfig> defaultReminderConfigs = List.unmodifiable([
  ReminderConfig(
    key: "7d",
    offset: Duration(days: 7),
    labelGetter: (loc) => loc.reminder(7),
  ),
  ReminderConfig(
    key: "1d",
    offset: Duration(days: 1),
    labelGetter: (loc) => loc.reminder(1),
  ),
]);

List<ReminderConfig> buildReminderConfigs(UserReminderSetting setting) {
  final configs = <ReminderConfig>[];
  if (setting.firstReminderDays != null) {
    configs.add(
      ReminderConfig(
        key: "first",
        offset: Duration(days: setting.firstReminderDays!),
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
        key: "second",
        offset: Duration(days: setting.secondReminderDays!),
        labelGetter:
            (loc) =>
                setting.firstReminderDays == 0
                    ? loc.reminder_0d
                    : loc.reminder(setting.firstReminderDays!),
      ),
    );
  }
  return configs;
}
