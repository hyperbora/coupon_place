import 'package:coupon_place/src/features/coupon/widget/coupon_list_item.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'coupon_form_screen.dart';
import '../provider/coupon_list_provider.dart';
import 'package:coupon_place/l10n/app_localizations.dart';

class CouponListScreen extends ConsumerStatefulWidget {
  final String folderId;
  final String folderName;

  const CouponListScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  ConsumerState<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends ConsumerState<CouponListScreen> {
  Set<String> selectedCoupons = {};
  bool selectionMode = false;

  bool get isSelectionMode => selectionMode || selectedCoupons.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final coupons = ref.watch(couponListProvider(widget.folderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        centerTitle: true,
        leading:
            isSelectionMode
                ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectionMode = false;
                      selectedCoupons.clear();
                    });
                  },
                )
                : null,
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: loc.selectModeTooltip,
              onPressed: () {
                setState(() {
                  selectionMode = true;
                  selectedCoupons.clear();
                });
              },
            ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  selectedCoupons.isEmpty
                      ? null
                      : () {
                        showConfirmDialog(
                          context,
                          title: loc.deleteCouponTitle,
                          message: loc.deleteCouponContent,
                          onConfirm: () {
                            final notifier = ref.read(
                              couponListProvider(widget.folderId).notifier,
                            );
                            for (var id in selectedCoupons) {
                              final coupon = coupons.firstWhere(
                                (c) => c.id == id,
                              );
                              notifier.removeCoupon(coupon);
                            }
                            setState(() {
                              selectedCoupons.clear();
                            });
                          },
                        );
                      },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          final isSelected = selectedCoupons.contains(coupon.id);

          return GestureDetector(
            onLongPress: () {
              setState(() {
                if (isSelected) {
                  selectedCoupons.remove(coupon.id);
                } else {
                  selectedCoupons.add(coupon.id);
                }
              });
            },
            child: Row(
              children: [
                if (isSelectionMode)
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedCoupons.add(coupon.id);
                        } else {
                          selectedCoupons.remove(coupon.id);
                        }
                      });
                    },
                  ),
                Expanded(
                  child: Slidable(
                    key: ValueKey(coupon.id),
                    endActionPane:
                        isSelectionMode
                            ? null // 선택 모드에서는 슬라이드 액션 비활성화
                            : ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    context.push(
                                      '/coupon/${coupon.folderId}/${coupon.id}/edit',
                                    );
                                  },
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: loc.edit,
                                ),
                                SlidableAction(
                                  onPressed: (context) async {
                                    showConfirmDialog(
                                      context,
                                      title: loc.deleteCouponTitle,
                                      message: loc.deleteCouponContent,
                                      onConfirm: () {
                                        ref
                                            .read(
                                              couponListProvider(
                                                widget.folderId,
                                              ).notifier,
                                            )
                                            .removeCoupon(coupon);
                                      },
                                    );
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: loc.delete,
                                ),
                              ],
                            ),
                    child: CouponListItem(coupon: coupon),
                  ),
                ),
              ],
            ),
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
                  child: CouponFormScreen(folderId: widget.folderId),
                ),
          );
        },
        tooltip: loc.couponRegisterTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
