import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../provider/coupon_list_provider.dart';
import 'coupon_form_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CouponDetailScreen extends ConsumerWidget {
  final String folderId;
  final String couponId;

  const CouponDetailScreen({
    super.key,
    required this.folderId,
    required this.couponId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = ref.watch(couponListProvider(folderId));
    final loc = AppLocalizations.of(context)!;
    final coupon =
        coupons.where((c) => c.id == couponId).isNotEmpty
            ? coupons.firstWhere((c) => c.id == couponId)
            : null;

    if (coupon == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.couponDetailTitle)),
        body: const Center(child: Text('쿠폰을 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.couponDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => CouponFormScreen(
                        folderId: folderId,
                        couponId: couponId,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child:
                      (coupon.imagePath != null &&
                              File(coupon.imagePath!).existsSync())
                          ? Image.file(
                            File(coupon.imagePath!),
                            fit: BoxFit.cover,
                          )
                          : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),
              Text(coupon.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (coupon.code != null && coupon.code!.isNotEmpty)
                Text(loc.couponDetailCode(coupon.code!)),
              if (coupon.memo != null && coupon.memo!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(loc.couponDetailMemo(coupon.memo!)),
                ),
              if (coupon.validDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '유효기간: ${DateFormat('yyyy-MM-dd').format(coupon.validDate!)}',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
