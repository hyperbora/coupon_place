import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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

  @HiveField(8)
  final bool isUsed;

  @HiveField(9)
  final int? order;

  Coupon({
    required this.id,
    required this.name,
    this.code,
    this.memo,
    this.validDate,
    this.imagePath,
    required this.folderId,
    this.enableAlarm = false,
    this.isUsed = false,
    this.order,
  });

  factory Coupon.create({
    required String name,
    String? code,
    String? memo,
    DateTime? validDate,
    String? imagePath,
    required String folderId,
    bool enableAlarm = true,
    bool isUsed = false,
    required int order,
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
      isUsed: isUsed,
      order: order,
    );
  }

  Coupon copyWith({
    String? id,
    String? name,
    String? code,
    String? memo,
    DateTime? validDate,
    String? imagePath,
    String? folderId,
    bool? enableAlarm,
    bool? isUsed,
    int? order,
  }) {
    return Coupon(
      id: this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      memo: memo ?? this.memo,
      validDate: validDate ?? this.validDate,
      imagePath: imagePath ?? this.imagePath,
      folderId: folderId ?? this.folderId,
      enableAlarm: enableAlarm ?? this.enableAlarm,
      isUsed: isUsed ?? this.isUsed,
      order: order ?? this.order,
    );
  }

  Coupon withImagePath(String? imagePath) {
    return Coupon(
      id: id,
      name: name,
      code: code,
      memo: memo,
      validDate: validDate,
      imagePath: imagePath,
      folderId: folderId,
      enableAlarm: enableAlarm,
      isUsed: isUsed,
      order: order,
    );
  }

  /// Converts Coupon object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'memo': memo,
      'validDate': validDate?.toIso8601String(),
      'imagePath': imagePath,
      'folderId': folderId,
      'enableAlarm': enableAlarm,
      'isUsed': isUsed,
      'order': order,
    };
  }

  /// Creates Coupon object from JSON map
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      memo: json['memo'],
      validDate:
          json['validDate'] != null ? DateTime.parse(json['validDate']) : null,
      imagePath: json['imagePath'],
      folderId: json['folderId'],
      enableAlarm: json['enableAlarm'] ?? false,
      isUsed: json['isUsed'] ?? false,
      order: json['order'],
    );
  }
}
