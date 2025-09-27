import 'package:hive/hive.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';

class FolderLocalDb {
  static const _boxName = 'folders';

  Future<Box<Folder>> _openBox() async {
    return await Hive.openBox<Folder>(_boxName);
  }

  Future<List<Folder>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> add(Folder folder) async {
    final box = await _openBox();
    await box.put(folder.id, folder);
  }

  Future<void> update(Folder folder) async {
    final box = await _openBox();
    await box.put(folder.id, folder);
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }
}
