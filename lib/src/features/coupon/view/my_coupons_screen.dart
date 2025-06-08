import 'package:coupon_place/src/features/coupon/view/coupon_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myCouponsTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.folder_open),
            onSelected: (value) {
              if (value == 'add') {
                // 폴더 등록 모달 띄우기
              } else if (value == 'edit') {
                // 폴더 편집 모달 띄우기
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'add',
                    child: Text(loc.folderAdd), // "폴더 등록" (다국어)
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(loc.folderEdit), // "폴더 편집" (다국어)
                  ),
                ],
          ),
        ],
      ),
      body: Center(child: Text(loc.myCouponsTitle)),
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
        child: const Icon(Icons.add_card),
      ),
    );
  }
}
