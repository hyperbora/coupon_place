import 'package:coupon_place/l10n/app_localizations.dart';

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
