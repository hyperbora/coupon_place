import 'package:coupon_place/src/features/coupon/screen/my_coupons_screen.dart';
import 'package:coupon_place/src/features/settings/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

final List<Widget> myTabItems = [
  const MyCouponsScreen(),
  const SettingsScreen(),
];

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: loc.myCouponsTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp),
            label: loc.settingsTitle,
          ),
        ],
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(index: _selectedIndex, children: myTabItems),
    );
  }
}
