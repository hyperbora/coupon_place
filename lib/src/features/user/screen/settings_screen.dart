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
          ListTile(
            title: Text(
              loc.settingsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("1차 알림"),
              SizedBox(
                width: 80, // Expanded 대신 고정 너비로 변경
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int?>(
                    initialValue: reminderSetting.firstReminderDays,
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('없음'),
                      ),
                      ...List.generate(
                        31,
                        (i) => DropdownMenuItem(value: i, child: Text('$i')),
                      ),
                    ],
                    onChanged: (value) {
                      notifier.updateFirst(value);
                    },
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    dropdownColor: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("2차 알림"),
              SizedBox(
                width: 80, // Expanded 대신 고정 너비로 변경
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int?>(
                    initialValue: reminderSetting.secondReminderDays,
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('없음'),
                      ),
                      ...List.generate(
                        31,
                        (i) => DropdownMenuItem(value: i, child: Text('$i')),
                      ),
                    ],
                    onChanged: (value) {
                      notifier.updateSecond(value);
                    },
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    dropdownColor: Theme.of(context).canvasColor,
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
