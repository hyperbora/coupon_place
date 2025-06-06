import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.myCouponsTitle)),
      body: Center(child: Text(loc.myCouponsTitle)),
    );
  }
}
