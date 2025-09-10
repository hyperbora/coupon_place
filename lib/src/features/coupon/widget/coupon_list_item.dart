import 'dart:io';

import 'package:coupon_place/src/features/coupon/model/coupon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CouponListItem extends StatelessWidget {
  final Coupon coupon;

  const CouponListItem({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          (coupon.imagePath != null && File(coupon.imagePath!).existsSync())
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(coupon.imagePath!),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
              : CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              ),
      title: Text(coupon.name),
      subtitle: Text(coupon.code ?? ''),
      onTap: () {
        context.push('/coupon/${coupon.folderId}/${coupon.id}');
      },
    );
  }
}
