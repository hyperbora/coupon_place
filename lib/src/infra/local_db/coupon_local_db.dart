import 'package:hive/hive.dart';
import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';

class CouponLocalDb {
  static const _boxName = 'coupons';

  Future<Box<Coupon>> _openBox() async {
    return await Hive.openBox<Coupon>(_boxName);
  }

  Future<List<Coupon>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> add(Coupon coupon) async {
    final box = await _openBox();
    await box.put(coupon.id, coupon);
  }

  Future<void> update(Coupon coupon) async {
    final box = await _openBox();
    await box.put(coupon.id, coupon);
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }
}
