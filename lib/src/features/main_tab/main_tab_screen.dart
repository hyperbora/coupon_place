import 'package:coupon_place/src/features/coupon/view/my_coupons_screen.dart';
import 'package:coupon_place/src/features/home/view/home_screen.dart';
import 'package:coupon_place/src/features/user/view/my_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<Widget> myTabItems = [
  const HomeScreen(),
  const MyCouponsScreen(),
  const MyPageScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.homeTitle),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: loc.myCouponsTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: loc.myPageTitle,
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(index: _selectedIndex, children: myTabItems),
    );
  }
}
