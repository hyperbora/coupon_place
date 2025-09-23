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

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loc.firstAlarmLabel),
              SizedBox(
                width: 120, // Expanded 대신 고정 너비로 변경
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int?>(
                    initialValue: reminderSetting.firstReminderDays,
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
                    onChanged: (value) {
                      notifier.updateFirst(value);
                    },
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    dropdownColor: Theme.of(context).canvasColor,
                    menuMaxHeight: 5 * 48,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loc.secondAlarmLabel),
              SizedBox(
                width: 120, // Expanded 대신 고정 너비로 변경
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int?>(
                    initialValue: reminderSetting.secondReminderDays,
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
                    onChanged: (value) {
                      notifier.updateSecond(value);
                    },
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    dropdownColor: Theme.of(context).canvasColor,
                    menuMaxHeight: 5 * 48,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
