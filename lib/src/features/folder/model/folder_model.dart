import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 1)
class Folder extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final Color color;
  @HiveField(3)
  final IconData icon;

  Folder({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}
