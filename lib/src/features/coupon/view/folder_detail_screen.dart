import 'package:coupon_place/src/features/coupon/view/coupon_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/coupon_list_provider.dart';

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
    final coupons =
        ref
            .watch(couponListProvider)
            .where((c) => c.folderId == folderId)
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return CouponListItem(coupon: coupon);
        },
      ),
    );
  }
}
