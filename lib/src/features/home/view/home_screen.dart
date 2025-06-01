import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<BottomNavigationBarItem> myTabs = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
  BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: '쿠폰등록'),
  BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: '내 쿠폰'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
];

final List<Widget> myTabItems = [
  const Text("메뉴1"),
  const Text("메뉴2"),
  const Text("메뉴3"),
  const Text("메뉴4"),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final titles = [
      loc.homeTitle,
      loc.couponRegisterTitle,
      loc.myCouponsTitle,
      loc.myPageTitle,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.homeTitle),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: loc.couponRegisterTitle,
          ),
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
