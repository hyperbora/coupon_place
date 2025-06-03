import 'package:coupon_place/src/features/coupon/view/coupon_register_screen.dart'; // 추가
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.homeTitle)),
      body: const Center(child: Text('home')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder:
                (context) => FractionallySizedBox(
                  heightFactor: 0.9,
                  child: const CouponRegisterScreen(),
                ),
          );
        },
        tooltip: loc.couponRegisterTooltip,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
