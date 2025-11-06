import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/shared/widgets/card_container.dart';
import 'package:coupon_place/src/shared/widgets/card_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/settings/provider/user_reminder_setting_provider.dart';

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
      return CardContainer(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        color: color,
        title: Text(label, style: Theme.of(context).textTheme.titleMedium),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        trailing: SizedBox(
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
      );
    }

    final reminderTimeRow = CardContainer(
      leading: Icons.access_time_rounded,
      color: Colors.teal,
      title: Text(
        loc.reminderTimeLabel,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (reminderSetting.reminderHour != null &&
                    reminderSetting.reminderMinute != null)
                ? MaterialLocalizations.of(context).formatTimeOfDay(
                  TimeOfDay(
                    hour: reminderSetting.reminderHour!,
                    minute: reminderSetting.reminderMinute!,
                  ),
                )
                : loc.selectTimePlaceholder,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit, size: 18, color: Colors.grey),
        ],
      ),
      onTap: () async {
        final now = TimeOfDay.now();
        final initialTime =
            reminderSetting.reminderHour != null &&
                    reminderSetting.reminderMinute != null
                ? TimeOfDay(
                  hour: reminderSetting.reminderHour!,
                  minute: reminderSetting.reminderMinute!,
                )
                : now;
        final picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (picked != null) {
          await notifier.updateTime(picked.hour, picked.minute, loc);
        }
      },
    );

    final settingsBody = ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        CardSection(
          label: loc.settingsReminderTitle,
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
            const Divider(height: 0, indent: 50, endIndent: 50),
            alarmRow(
              label: loc.secondAlarmLabel,
              value: reminderSetting.secondReminderDays,
              onChanged: (int? days) async {
                await notifier.updateSecond(days, loc);
              },
              color: Colors.orange,
              icon: Icons.notifications_none_rounded,
            ),
            const Divider(height: 0, indent: 50, endIndent: 50),
            reminderTimeRow,
          ],
        ),
        const SizedBox(height: 8),
        CardContainer(
          title: Text(loc.settingsDataManagementTitle),
          leading: Icons.storage_rounded,
          color: Colors.blue,
          onTap: () {
            AppRoutes.dataManagementSettings.push(context);
          },
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      body: settingsBody,
    );
  }
}
