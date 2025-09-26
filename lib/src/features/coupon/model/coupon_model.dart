import 'package:hive/hive.dart';

part 'coupon_model.g.dart';

@HiveType(typeId: 0)
class Coupon extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? code;

  @HiveField(3)
  final String? memo;

  @HiveField(4)
  final DateTime? validDate;

  @HiveField(5)
  final String? imagePath;

  @HiveField(6)
  final String folderId;

  @HiveField(7)
  final bool enableAlarm;

  Coupon({
    required this.id,
    required this.name,
    this.code,
    this.memo,
    this.validDate,
    this.imagePath,
    required this.folderId,
    this.enableAlarm = false,
  });
}
