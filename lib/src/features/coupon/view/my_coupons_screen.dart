import 'package:coupon_place/src/features/coupon/view/coupon_register_screen.dart';
import 'package:coupon_place/src/features/coupon/view/folder_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FolderMenuAction {
  static const add = 'add';
  static const edit = 'edit';
}

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
              if (value == FolderMenuAction.add) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder:
                      (context) => FractionallySizedBox(
                        heightFactor: 0.9,
                        child: Center(
                          child: FolderFormScreen(
                            onSubmit: (name, color, icon) {},
                          ),
                        ),
                      ),
                );
              } else if (value == FolderMenuAction.edit) {}
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: FolderMenuAction.add,
                    child: Text(loc.folderAdd),
                  ),
                  PopupMenuItem(
                    value: FolderMenuAction.edit,
                    child: Text(loc.folderEdit),
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
