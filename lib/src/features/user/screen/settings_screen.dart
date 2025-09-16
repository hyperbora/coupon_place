import 'package:flutter/material.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle), centerTitle: true),
      body: Center(child: Text(loc.settingsTitle)),
    );
  }
}
