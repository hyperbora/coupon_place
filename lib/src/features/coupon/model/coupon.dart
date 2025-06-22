import 'dart:io';
import 'package:uuid/uuid.dart';

class Coupon {
  final String id;
  final String name;
  final String? code;
  final String? memo;
  final DateTime? validDate;
  final File? imageFile;
  final String folderId;
  final bool enableAlarm;

  Coupon({
    required this.id,
    required this.name,
    this.code,
    this.memo,
    this.validDate,
    this.imageFile,
    required this.folderId,
    this.enableAlarm = false,
  });

  factory Coupon.create({
    required String name,
    String? code,
    String? memo,
    DateTime? validDate,
    File? imageFile,
    required String folderId,
    bool enableAlarm = false,
  }) {
    return Coupon(
      id: const Uuid().v4(),
      name: name,
      code: code,
      memo: memo,
      validDate: validDate,
      imageFile: imageFile,
      folderId: folderId,
      enableAlarm: enableAlarm,
    );
  }
}
