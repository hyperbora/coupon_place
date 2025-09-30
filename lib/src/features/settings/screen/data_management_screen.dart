import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/shared/widgets/full_width_ink_button.dart';
import 'package:flutter/material.dart';

class DataManagementScreen extends StatelessWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.dataManagementTitle), centerTitle: true),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          FullWidthInkButton(
            text: loc.clearAllDataLabel,
            onTap: () {},
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
