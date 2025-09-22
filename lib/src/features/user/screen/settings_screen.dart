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

    final firstEnabled = reminderSetting.firstReminderDays != null;
    final secondEnabled = reminderSetting.secondReminderDays != null;

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
              Row(
                children: [
                  Switch(
                    value: firstEnabled,
                    onChanged: (value) {
                      if (value) {
                        notifier.updateFirst(7);
                      } else {
                        notifier.updateFirst(null);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80, // Expanded 대신 고정 너비로 변경
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        initialValue:
                            firstEnabled
                                ? reminderSetting.firstReminderDays!
                                : null, // initialValue → value로 변경
                        items: List.generate(
                          31,
                          (i) => DropdownMenuItem(value: i, child: Text('$i')),
                        ),
                        onChanged:
                            firstEnabled
                                ? (value) {
                                  if (value != null) {
                                    notifier.updateFirst(value);
                                  }
                                }
                                : null,
                        decoration: const InputDecoration.collapsed(
                          hintText: '',
                        ),
                        dropdownColor: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("2차 알림"),
              Row(
                children: [
                  Switch(
                    value: secondEnabled,
                    onChanged: (value) {
                      if (value) {
                        notifier.updateSecond(7);
                      } else {
                        notifier.updateSecond(null);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80, // Expanded 대신 고정 너비로 변경
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        initialValue:
                            secondEnabled
                                ? reminderSetting.secondReminderDays!
                                : null, // initialValue → value로 변경
                        items: List.generate(
                          31,
                          (i) => DropdownMenuItem(value: i, child: Text('$i')),
                        ),
                        onChanged:
                            secondEnabled
                                ? (value) {
                                  if (value != null) {
                                    notifier.updateSecond(value);
                                  }
                                }
                                : null,
                        decoration: const InputDecoration.collapsed(
                          hintText: '',
                        ),
                        dropdownColor: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
