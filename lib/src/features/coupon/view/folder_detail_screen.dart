import 'dart:io';

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
          return ListTile(
            leading:
                coupon.imagePath != null && coupon.imagePath!.isNotEmpty
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
                      child: Icon(Icons.card_giftcard, color: Colors.grey[600]),
                    ),
            title: Text(coupon.name),
            subtitle: Text(coupon.code ?? ''),
          );
        },
      ),
    );
  }
}
