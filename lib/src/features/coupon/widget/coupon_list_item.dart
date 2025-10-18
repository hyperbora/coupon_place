import 'dart:io';

import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CouponListItem extends StatelessWidget {
  final Coupon coupon;

  const CouponListItem({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final bool isUsed = coupon.isUsed;
    final textColor = isUsed ? Colors.grey : null;
    final decoration =
        isUsed ? TextDecoration.lineThrough : TextDecoration.none;

    return Container(
      color: isUsed ? Colors.grey[200] : null,
      child: ListTile(
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
                  child: Icon(Icons.image, color: Colors.grey[600]),
                ),
        title: Text(
          coupon.name,
          style: TextStyle(color: textColor, decoration: decoration),
        ),
        subtitle: Text(
          coupon.code ?? '',
          style: TextStyle(color: textColor, decoration: decoration),
        ),
        trailing: isUsed ? Icon(Icons.check, color: Colors.grey) : null,
        onTap: () {
          context.push('/coupon/${coupon.folderId}/${coupon.id}');
        },
      ),
    );
  }
}
