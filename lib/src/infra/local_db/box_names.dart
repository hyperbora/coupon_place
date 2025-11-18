import 'package:coupon_place/src/features/coupon/model/coupon_model.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';

enum BoxNames {
  coupons('coupons', Coupon),
  folders('folders', Folder);

  final String value;
  final Type type;
  const BoxNames(this.value, this.type);
}
