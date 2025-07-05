import 'package:uuid/uuid.dart';

class Coupon {
  final String id;
  final String name;
  final String? code;
  final String? memo;
  final DateTime? validDate;
  final String? imagePath;
  final String folderId;
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

  factory Coupon.create({
    required String name,
    String? code,
    String? memo,
    DateTime? validDate,
    String? imagePath,
    required String folderId,
    bool enableAlarm = false,
  }) {
    return Coupon(
      id: const Uuid().v4(),
      name: name,
      code: code,
      memo: memo,
      validDate: validDate,
      imagePath: imagePath,
      folderId: folderId,
      enableAlarm: enableAlarm,
    );
  }
}
