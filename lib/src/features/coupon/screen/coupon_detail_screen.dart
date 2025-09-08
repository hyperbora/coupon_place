import 'package:flutter/material.dart';

class CouponDetailScreen extends StatelessWidget {
  final String folderId;
  final String couponId;

  const CouponDetailScreen({
    super.key,
    required this.folderId,
    required this.couponId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('쿠폰 상세')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Folder ID: $folderId'),
            Text('Coupon ID: $couponId'),
          ],
        ),
      ),
    );
  }
}
