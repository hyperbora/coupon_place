import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/coupon.dart';

class CouponListNotifier extends StateNotifier<List<Coupon>> {
  CouponListNotifier() : super([]);

  void addCoupon(Coupon coupon) {
    state = [...state, coupon];
  }

  void updateCoupon(Coupon updated) {
    state = [
      for (final coupon in state) coupon.id == updated.id ? updated : coupon,
    ];
  }

  void removeCoupon(String id) {
    state = state.where((coupon) => coupon.id != id).toList();
  }
}

final couponListProvider =
    StateNotifierProvider<CouponListNotifier, List<Coupon>>(
      (ref) => CouponListNotifier(),
    );
