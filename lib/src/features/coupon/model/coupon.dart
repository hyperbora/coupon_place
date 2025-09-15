import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      memo: map['memo'],
      validDate:
          map['validDate'] != null
              ? (map['validDate'] as Timestamp).toDate()
              : null,
      imagePath: map['imagePath'],
      folderId: map['folderId'],
      enableAlarm: map['enableAlarm'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'memo': memo,
      'validDate': validDate != null ? Timestamp.fromDate(validDate!) : null,
      'imagePath': imagePath,
      'folderId': folderId,
      'enableAlarm': enableAlarm,
    };
  }

  Coupon copyWith({
    String? name,
    String? code,
    String? memo,
    DateTime? validDate,
    String? imagePath,
    String? folderId,
    bool? enableAlarm,
  }) {
    return Coupon(
      id: id,
      name: name ?? this.name,
      code: code ?? this.code,
      memo: memo ?? this.memo,
      validDate: validDate ?? this.validDate,
      imagePath: imagePath,
      folderId: folderId ?? this.folderId,
      enableAlarm: enableAlarm ?? this.enableAlarm,
    );
  }
}
