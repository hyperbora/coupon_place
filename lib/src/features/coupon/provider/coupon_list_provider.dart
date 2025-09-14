import 'package:coupon_place/src/infra/firebase/firestore_service.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/coupon.dart';

final _firestoreService = FirestoreService();

class CouponListNotifier extends StateNotifier<List<Coupon>> {
  final String folderId;
  CouponListNotifier(this.folderId) : super([]) {
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    state = await _firestoreService.getCouponsFromFirestore(folderId);
  }

  void addCoupon(Coupon coupon) async {
    state = [...state, coupon];
    _firestoreService.addCouponToFirestore(coupon);
  }

  void updateCoupon(Coupon updated) async {
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
    } catch (e) {
      state = [
        for (final coupon in state)
          coupon.id == oldCoupon.id ? oldCoupon : coupon,
      ];
    }
  }

  void removeCoupon(Coupon deleted) {
    _firestoreService.removeCoupon(deleted.id);
    state = state.where((coupon) => coupon.id != deleted.id).toList();
  }
}

class AllCouponsNotifier extends StateNotifier<List<Coupon>> {
  AllCouponsNotifier() : super([]) {
    _loadAllCoupons();
  }

  Future<void> _loadAllCoupons() async {
    state = await _firestoreService.getAllCouponsFromFirestore();
  }

  void addCoupon(Coupon coupon) async {
    state = [...state, coupon];
    _firestoreService.addCouponToFirestore(coupon);
  }

  void updateCoupon(Coupon updated) async {
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
    } catch (e) {
      state = [
        for (final coupon in state)
          coupon.id == oldCoupon.id ? oldCoupon : coupon,
      ];
    }
  }

  void removeCoupon(Coupon deleted) async {
    _firestoreService.removeCoupon(deleted.id);
    state = state.where((coupon) => coupon.id != deleted.id).toList();
  }
}

final couponListProvider =
    StateNotifierProvider.family<CouponListNotifier, List<Coupon>, String>(
      (ref, folderId) => CouponListNotifier(folderId),
    );

final allCouponsProvider =
    StateNotifierProvider<AllCouponsNotifier, List<Coupon>>(
      (ref) => AllCouponsNotifier(),
    );
