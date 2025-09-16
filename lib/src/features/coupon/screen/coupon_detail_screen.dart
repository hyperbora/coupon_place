import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../provider/coupon_list_provider.dart';
import 'coupon_form_screen.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

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
        appBar: AppBar(title: Text(loc.couponDetailTitle), centerTitle: true),
        body: Center(child: Text(loc.couponNotFound)),
      );
    }

    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold);

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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child:
                      (coupon.imagePath != null &&
                              File(coupon.imagePath!).existsSync())
                          ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: InteractiveViewer(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.file(
                                            File(coupon.imagePath!),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                              );
                            },
                            child: Image.file(
                              File(coupon.imagePath!),
                              fit: BoxFit.contain,
                            ),
                          )
                          : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              size: MediaQuery.of(context).size.width * 0.2,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),
              Text(coupon.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(140),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          loc.couponDetailCodeLabel,
                          style: labelStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            coupon.code != null && coupon.code!.isNotEmpty
                                ? coupon.code!
                                : "-",
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          loc.couponDetailMemoLabel,
                          style: labelStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            coupon.memo != null && coupon.memo!.isNotEmpty
                                ? coupon.memo!
                                : "-",
                            softWrap: true,
                            maxLines: null,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          loc.couponDetailValidDateLabel,
                          style: labelStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            coupon.validDate != null
                                ? DateFormat(
                                  'yyyy-MM-dd',
                                ).format(coupon.validDate!)
                                : "-",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
