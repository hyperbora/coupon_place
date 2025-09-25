import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/user/provider/user_reminder_setting_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final reminderSetting = ref.watch(userReminderSettingProvider);
    final notifier = ref.read(userReminderSettingProvider.notifier);

    Widget alarmRow({
      required String label,
      required int? value,
      required ValueChanged<int?> onChanged,
      required Color color,
      required IconData icon,
    }) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                width: 140,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int?>(
                    isExpanded: true,
                    initialValue: value,
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(loc.noAlarmDropdownItem),
                      ),
                      ...List.generate(
                        31,
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(
                            i == 0
                                ? loc.onTheDayDropdownItem
                                : loc.daysBeforeDropdownItem(i),
                          ),
                        ),
                      ),
                    ],
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    menuMaxHeight: 5 * kMinInteractiveDimension,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          // 섹션 제목을 카드 바깥에 배치
          Text(
            loc.settingsReminderTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                alarmRow(
                  label: loc.firstAlarmLabel,
                  value: reminderSetting.firstReminderDays,
                  onChanged: (int? days) async {
                    await notifier.updateFirst(days, loc);
                  },
                  color: Colors.deepPurple,
                  icon: Icons.notifications_active_rounded,
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                alarmRow(
                  label: loc.secondAlarmLabel,
                  value: reminderSetting.secondReminderDays,
                  onChanged: (int? days) async {
                    await notifier.updateSecond(days, loc);
                  },
                  color: Colors.orange,
                  icon: Icons.notifications_none_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
