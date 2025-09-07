import 'package:coupon_place/src/features/coupon/widget/coupon_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'coupon_register_screen.dart';
import '../provider/coupon_list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FolderDetailScreen extends ConsumerWidget {
  final String folderId;
  final String folderName;

  const FolderDetailScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final coupons = ref.watch(couponListProvider(folderId));

    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
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
                    // TODO: 수정 화면 이동 (쿠폰 수정 폼 연결)
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: loc.edit,
                ),
                SlidableAction(
                  onPressed: (context) {
                    // TODO: 쿠폰 삭제 로직 추가
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
                  child: const CouponRegisterScreen(),
                ),
          );
        },
        tooltip: loc.couponRegisterTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
