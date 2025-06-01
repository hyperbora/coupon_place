import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.homeTitle)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/about'),
          child: Text(loc.goToAbout),
        ),
      ),
    );
  }
}
