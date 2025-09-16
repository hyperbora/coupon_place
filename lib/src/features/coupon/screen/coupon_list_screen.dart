import 'package:coupon_place/src/features/coupon/widget/coupon_list_item.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'coupon_form_screen.dart';
import '../provider/coupon_list_provider.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

class CouponListScreen extends ConsumerWidget {
  final String folderId;
  final String folderName;

  const CouponListScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final coupons = ref.watch(couponListProvider(folderId));

    return Scaffold(
      appBar: AppBar(title: Text(folderName), centerTitle: true),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return Slidable(
            key: ValueKey(coupon.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    context.push(
                      '/coupon/${coupon.folderId}/${coupon.id}/edit',
                    );
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: loc.edit,
                ),
                SlidableAction(
                  onPressed: (context) async {
                    showConfirmDialog(
                      context,
                      title: loc.deleteCouponTitle,
                      message: loc.deleteCouponContent,
                      onConfirm: () {
                        ref
                            .read(couponListProvider(folderId).notifier)
                            .removeCoupon(coupon);
                      },
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: loc.delete,
                ),
              ],
            ),
            child: CouponListItem(coupon: coupon),
          );
        },
      ),
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
                  child: CouponFormScreen(folderId: folderId),
                ),
          );
        },
        tooltip: loc.couponRegisterTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
