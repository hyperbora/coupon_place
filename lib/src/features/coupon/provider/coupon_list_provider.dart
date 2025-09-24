import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/user/provider/user_reminder_setting_provider.dart';
import 'package:coupon_place/src/infra/firebase/firestore_service.dart';
import 'package:coupon_place/src/infra/notification/notification_service.dart';
import 'package:coupon_place/src/infra/notification/reminder_config.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coupon_place/src/features/coupon/model/coupon.dart';

final _firestoreService = FirestoreService();

class CouponListNotifier extends StateNotifier<List<Coupon>> {
  final Ref ref;
  final String folderId;
  CouponListNotifier(this.ref, this.folderId) : super([]) {
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    state = await _firestoreService.getCouponsFromFirestore(folderId);
  }

  void addCoupon(Coupon coupon, AppLocalizations loc) async {
    state = [...state, coupon];
    await _firestoreService.addCouponToFirestore(coupon);
    final userReminderSetting = ref.read(userReminderSettingProvider);
    final configs = buildReminderConfigs(userReminderSetting);
    await registerCouponNotifications(
      coupon: coupon,
      loc: loc,
      configs: configs,
    );
  }

  void updateCoupon(Coupon updated, AppLocalizations loc) async {
    final Coupon oldCoupon = state.firstWhere(
      (coupon) => coupon.id == updated.id,
    );
    state = [
      for (final coupon in state) coupon.id == updated.id ? updated : coupon,
    ];
    try {
      await _firestoreService.updateCouponInFirestore(updated);
      if (oldCoupon.imagePath != null &&
          oldCoupon.imagePath != updated.imagePath) {
        FileHelper.deleteFile(oldCoupon.imagePath!);
      }
      final userReminderSetting = ref.read(userReminderSettingProvider);
      final configs = buildReminderConfigs(userReminderSetting);
      await registerCouponNotifications(
        coupon: updated,
        loc: loc,
        configs: configs,
      );
    } catch (e) {
      state = [
        for (final coupon in state)
          coupon.id == oldCoupon.id ? oldCoupon : coupon,
      ];
    }
  }

  void removeCoupon(Coupon deleted) async {
    await _firestoreService.removeCoupon(deleted.id);
    await cancelCouponNotifications(coupon: deleted);
    state = state.where((coupon) => coupon.id != deleted.id).toList();
  }
}

class AllCouponsNotifier extends StateNotifier<List<Coupon>> {
  final Ref ref;
  AllCouponsNotifier(this.ref) : super([]) {
    _loadAllCoupons();
  }

  Future<void> _loadAllCoupons() async {
    state = await _firestoreService.getAllCouponsFromFirestore();
  }

  void addCoupon(Coupon coupon, AppLocalizations loc) async {
    state = [...state, coupon];
    await _firestoreService.addCouponToFirestore(coupon);
    final userReminderSetting = ref.read(userReminderSettingProvider);
    final configs = buildReminderConfigs(userReminderSetting);
    await registerCouponNotifications(
      coupon: coupon,
      loc: loc,
      configs: configs,
    );
  }

  void updateCoupon(Coupon updated, AppLocalizations loc) async {
    final Coupon oldCoupon = state.firstWhere(
      (coupon) => coupon.id == updated.id,
    );
    state = [
      for (final coupon in state) coupon.id == updated.id ? updated : coupon,
    ];
    try {
      await _firestoreService.updateCouponInFirestore(updated);
      if (oldCoupon.imagePath != null &&
          oldCoupon.imagePath != updated.imagePath) {
        FileHelper.deleteFile(oldCoupon.imagePath!);
      }
      final userReminderSetting = ref.read(userReminderSettingProvider);
      final configs = buildReminderConfigs(userReminderSetting);
      await registerCouponNotifications(
        coupon: updated,
        loc: loc,
        configs: configs,
      );
    } catch (e) {
      state = [
        for (final coupon in state)
          coupon.id == oldCoupon.id ? oldCoupon : coupon,
      ];
    }
  }

  void removeCoupon(Coupon deleted) async {
    await _firestoreService.removeCoupon(deleted.id);
    await cancelCouponNotifications(coupon: deleted);
    state = state.where((coupon) => coupon.id != deleted.id).toList();
  }
}

final couponListProvider =
    StateNotifierProvider.family<CouponListNotifier, List<Coupon>, String>(
      (ref, folderId) => CouponListNotifier(ref, folderId),
    );

final allCouponsProvider =
    StateNotifierProvider<AllCouponsNotifier, List<Coupon>>(
      (ref) => AllCouponsNotifier(ref),
    );
