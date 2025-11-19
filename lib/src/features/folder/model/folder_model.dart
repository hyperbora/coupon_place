import 'package:hive/hive.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 1)
class Folder extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int colorValue;
  @HiveField(3)
  final int iconCodePoint;
  @HiveField(4)
  final int? order;

  Folder({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    this.order,
  });

  Folder copyWith({
    String? name,
    int? colorValue,
    int? iconCodePoint,
    int? order,
  }) {
    return Folder(
      id: id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      order: order ?? this.order,
    );
  }

  /// Converts Folder object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'order': order,
    };
  }

  /// Creates Folder object from JSON map
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      name: json['name'],
      colorValue: json['colorValue'],
      iconCodePoint: json['iconCodePoint'],
      order: json['order'],
    );
  }
}
