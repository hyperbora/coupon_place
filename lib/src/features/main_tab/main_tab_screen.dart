import 'package:coupon_place/src/features/coupon/screen/folder_list_screen.dart';
import 'package:coupon_place/src/features/settings/screen/settings_screen.dart';
import 'package:coupon_place/src/infra/ads/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

final List<Widget> myTabItems = [
  const FolderListScreen(),
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
      body: IndexedStack(index: _selectedIndex, children: myTabItems),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          const Divider(height: 1),
          _BottomNavBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            loc: loc,
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.loc,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.card_giftcard),
          label: loc.myCouponsTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_sharp),
          label: loc.settingsTitle,
        ),
      ],
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
