import 'package:coupon_place/src/shared/widgets/card_container.dart';
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
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          Text(
            loc.settingsReminderTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              color: Colors.white,
            ),
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
                Divider(height: 5, indent: 50, endIndent: 50),
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
          const SizedBox(height: 8),
          CardContainer(
            label: loc.settingsDataManagementTitle,
            icon: Icons.storage_rounded,
            color: Colors.blue,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
