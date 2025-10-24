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
    String? id,
    String? name,
    int? colorValue,
    int? iconCodePoint,
    int? order,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      order: order ?? this.order,
    );
  }
}
