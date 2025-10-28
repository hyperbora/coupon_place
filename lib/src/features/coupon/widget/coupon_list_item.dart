import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/shared/widgets/card_container.dart';
import 'package:flutter/material.dart';

class CouponListItem extends StatelessWidget {
  final Coupon coupon;

  const CouponListItem({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isUsed = coupon.isUsed;
    final textColor = isUsed ? Colors.grey : null;
    final decoration =
        isUsed ? TextDecoration.lineThrough : TextDecoration.none;

    return CardContainer(
      color: isUsed ? Colors.grey[200] : null,
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
              : SizedBox(
                width: 48,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[600]),
                ),
              ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coupon.name,
            style: TextStyle(
              color: textColor,
              decoration: decoration,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            loc.couponListItemExpiryLabel(
              coupon.validDate != null
                  ? DateFormat('yyyy-MM-dd').format(coupon.validDate!)
                  : '-',
            ),
            style: TextStyle(
              color: textColor,
              decoration: decoration,
              fontSize: 13,
            ),
          ),
          Text(
            loc.couponListItemMemoLabel(
              coupon.memo != null && coupon.memo!.isNotEmpty
                  ? coupon.memo!.split('\n').first
                  : '-',
            ),
            style: TextStyle(
              color: textColor,
              decoration: decoration,
              fontSize: 13,
            ),
          ),
        ],
      ),
      trailing: isUsed ? Icon(Icons.check, color: Colors.grey) : null,
      onTap: () {
        AppRoutes.couponDetail.push(
          context,
          pathParams: {'folderId': coupon.folderId, 'couponId': coupon.id},
        );
      },
    );
  }
}
