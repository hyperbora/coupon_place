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

  Folder({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
  });
}
