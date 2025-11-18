import 'package:coupon_place/src/core/router/app_router.dart';
import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../provider/coupon_list_provider.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

class CouponDetailScreen extends ConsumerWidget {
  final String folderId;
  final String couponId;

  const CouponDetailScreen({
    super.key,
    required this.folderId,
    required this.couponId,
  });

  Icon toggleUsedIcon(Coupon coupon) {
    if (coupon.isUsed) {
      return const Icon(Icons.undo_rounded, color: Colors.red);
    } else {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
  }

  Text toggleUsedText(Coupon coupon, AppLocalizations loc) {
    if (coupon.isUsed) {
      return Text(loc.restoreUseLabel);
    } else {
      return Text(loc.markAsUsedLabel);
    }
  }

  Text snackBarContent(bool nextUsedState, AppLocalizations loc) {
    if (nextUsedState) {
      return Text(loc.couponUseMarkedMessage);
    } else {
      return Text(loc.couponUseRestoredMessage);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = ref.watch(couponListProvider(folderId)).coupons;
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
              AppRoutes.couponFormEdit.push(
                context,
                pathParams: {'folderId': folderId, 'couponId': couponId},
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
                      FileHelper.existsImageInApp(coupon.imagePath)
                          ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: InteractiveViewer(
                                        clipBehavior: Clip.none,
                                        minScale: 0.5,
                                        maxScale: 3.0,
                                        child: Image.file(
                                          File(
                                            FileHelper.getImageAbsolutePath(
                                              coupon.imagePath!,
                                            ),
                                          ),
                                          key: ValueKey("${coupon.id}_dialog"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                              );
                            },
                            child: Image.file(
                              File(
                                FileHelper.getImageAbsolutePath(
                                  coupon.imagePath!,
                                ),
                              ),
                              key: ValueKey("${coupon.id}_main"),
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
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(loc.enableAlarmLabel, style: labelStyle),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Switch.adaptive(
                            value: coupon.enableAlarm,
                            onChanged: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  icon: toggleUsedIcon(coupon),
                  label: toggleUsedText(coupon, loc),
                  onPressed: () async {
                    final nextUsedState = !coupon.isUsed;
                    await ref
                        .read(couponListProvider(folderId).notifier)
                        .toggleUsed(coupon, loc);

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: snackBarContent(nextUsedState, loc),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      appRouter.goNamed(AppRoutes.mainTab.name);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
