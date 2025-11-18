import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/features/settings/provider/user_reminder_setting_provider.dart';
import 'package:coupon_place/src/infra/local_db/coupon_local_db.dart';
import 'package:coupon_place/src/infra/notification/notification_service.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _couponLocalDb = CouponLocalDb();

class CouponListState {
  final List<Coupon> coupons;

  CouponListState({this.coupons = const []});

  CouponListState copyWith({List<Coupon>? coupons}) {
    return CouponListState(coupons: coupons ?? this.coupons);
  }
}

class CouponListNotifier extends StateNotifier<CouponListState> {
  final Ref ref;
  final String folderId;
  CouponListNotifier(this.ref, this.folderId) : super(CouponListState()) {
    final initial = ref.read(allCouponsProvider);
    state = state.copyWith(
      coupons:
          initial.where((c) => c.folderId == folderId).toList()
            ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0)),
    );

    ref.listen<List<Coupon>>(allCouponsProvider, (_, allCoupons) {
      state = state.copyWith(
        coupons:
            allCoupons.where((c) => c.folderId == folderId).toList()
              ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0)),
      );
    });
  }

  void addCoupon(Coupon coupon, AppLocalizations loc) async {
    await ref.read(allCouponsProvider.notifier).addCoupon(coupon, loc);
  }

  void updateCoupon(Coupon newCoupon, AppLocalizations loc) async {
    await ref.read(allCouponsProvider.notifier).updateCoupon(newCoupon, loc);
  }

  void removeCoupon(Coupon deleted) async {
    await ref.read(allCouponsProvider.notifier).removeCoupon(deleted);
  }

  Future<void> toggleUsed(Coupon coupon, AppLocalizations loc) async {
    await ref.read(allCouponsProvider.notifier).toggleUsed(coupon, loc);
  }

  Future<void> reorderCoupons(
    int oldIndex,
    int newIndex,
    AppLocalizations loc,
  ) async {
    if (newIndex > oldIndex) newIndex -= 1;

    final updatedList = [...state.coupons];
    final movedItem = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, movedItem);

    // 즉시 UI 반영
    state = state.copyWith(coupons: updatedList);

    // 비동기로 DB 업데이트 (await 제거)
    Future(() async {
      for (int i = 0; i < updatedList.length; i++) {
        final updatedCoupon = updatedList[i].copyWith(order: i);
        await ref
            .read(allCouponsProvider.notifier)
            .updateCoupon(updatedCoupon, loc);
      }
    });
  }
}

class AllCouponsNotifier extends StateNotifier<List<Coupon>> {
  final Ref ref;
  AllCouponsNotifier(this.ref) : super([]) {
    loadAllCoupons();
  }

  Future<void> loadAllCoupons() async {
    state = await _couponLocalDb.getAll();
  }

  Future<void> addCoupon(Coupon coupon, AppLocalizations loc) async {
    state = [...state, coupon];
    await _couponLocalDb.add(coupon);
    await _registerCouponNotifications(ref: ref, coupon: coupon, loc: loc);
  }

  Future<void> updateCoupon(Coupon updated, AppLocalizations loc) async {
    Coupon oldCoupon = state.firstWhere((c) => c.id == updated.id).copyWith();
    state = [
      for (final coupon in state) coupon.id == updated.id ? updated : coupon,
    ];
    try {
      await _couponLocalDb.update(updated);
      if (oldCoupon.imagePath != null &&
          oldCoupon.imagePath != updated.imagePath) {
        FileHelper.deleteImageFile(oldCoupon.imagePath);
      }
      await _registerCouponNotifications(ref: ref, coupon: updated, loc: loc);
    } catch (e) {
      state = [
        for (final coupon in state)
          coupon.id == oldCoupon.id ? oldCoupon : coupon,
      ];
    }
  }

  Future<void> _removeCoupon(Coupon deleted) async {
    await _couponLocalDb.delete(deleted.id);
    await cancelCouponNotifications(coupon: deleted);

    FileHelper.deleteImageFile(deleted.imagePath);
  }

  Future<void> removeCoupon(Coupon deleted) async {
    await _removeCoupon(deleted);

    state = state.where((coupon) => coupon.id != deleted.id).toList();
  }

  Future<void> clearAll() async {
    state = [];
    final coupons = await _couponLocalDb.getAll();
    for (final coupon in coupons) {
      await _removeCoupon(coupon);
    }
    _couponLocalDb.clear();
  }

  Future<void> toggleUsed(Coupon coupon, AppLocalizations loc) async {
    final isUsed = !coupon.isUsed;
    if (isUsed) {
      await cancelCouponNotifications(coupon: coupon);
    } else {
      await _registerCouponNotifications(ref: ref, coupon: coupon, loc: loc);
    }
    final updated = coupon.copyWith(isUsed: isUsed);
    state = [for (final c in state) c.id == updated.id ? updated : c];
    await _couponLocalDb.update(updated);
  }
}

Future<void> _registerCouponNotifications({
  required Ref ref,
  required Coupon coupon,
  required AppLocalizations loc,
}) async {
  final userReminderSetting = ref.read(userReminderSettingProvider);
  final configs = buildReminderConfigs(userReminderSetting);
  await registerCouponNotifications(coupon: coupon, loc: loc, configs: configs);
}

final couponListProvider =
    StateNotifierProvider.family<CouponListNotifier, CouponListState, String>(
      (ref, folderId) => CouponListNotifier(ref, folderId),
    );

final allCouponsProvider =
    StateNotifierProvider<AllCouponsNotifier, List<Coupon>>(
      (ref) => AllCouponsNotifier(ref),
    );
