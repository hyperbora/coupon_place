import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/infra/local_db/folder_local_db.dart';
import 'package:coupon_place/src/infra/local_db/coupon_local_db.dart';
import 'package:coupon_place/src/shared/utils/file_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FolderState {
  final List<Folder> folders;

  FolderState({this.folders = const []});

  FolderState copyWith({List<Folder>? folders}) {
    return FolderState(folders: folders ?? []);
  }
}

class FolderNotifier extends StateNotifier<FolderState> {
  FolderNotifier() : super(FolderState()) {
    loadFolders();
  }

  final FolderLocalDb _folderDb = FolderLocalDb();
  final CouponLocalDb _couponDb = CouponLocalDb();
  final _uuid = const Uuid();

  Future<void> loadFolders() async {
    final folders = await _folderDb.getAll();
    folders.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    state = state.copyWith(folders: folders);
  }

  void addFolder(String name, Color color, IconData icon) {
    final newFolder = Folder(
      id: _uuid.v4(),
      name: name,
      colorValue: color.toARGB32(),
      iconCodePoint: icon.codePoint,
      order: state.folders.length, // assign order
    );
    state = state.copyWith(folders: [...state.folders, newFolder]);
    _folderDb.add(newFolder);
  }

  void updateFolder(String id, {String? name, Color? color, IconData? icon}) {
    final oldFolder = state.folders.firstWhere((f) => f.id == id);
    final newFolder = oldFolder.copyWith(
      name: name,
      colorValue: color?.toARGB32(),
      iconCodePoint: icon?.codePoint,
    );

    final updatedFolders = [
      for (final folder in state.folders) folder.id == id ? newFolder : folder,
    ];

    state = state.copyWith(folders: updatedFolders);
    _folderDb.update(newFolder);
  }

  Future<void> removeFolder(String id) async {
    state = state.copyWith(
      folders: state.folders.where((folder) => folder.id != id).toList(),
    );

    await _removeFolder(id);
  }

  Future<void> _removeFolder(String id) async {
    final coupons =
        (await _couponDb.getAll())
            .where((coupon) => coupon.folderId == id)
            .toList();

    await _folderDb.delete(id);

    for (final coupon in coupons) {
      FileHelper.deleteImageFile(coupon.imagePath);
    }
  }

  Future<void> clearAll() async {
    for (final folder in state.folders) {
      await _removeFolder(folder.id);
    }
    await _folderDb.clear();
    state = FolderState();
  }

  Future<void> reorderFolders(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final updatedFolders = [...state.folders];
    final folder = updatedFolders.removeAt(oldIndex);
    updatedFolders.insert(newIndex, folder);

    // update order in memory
    for (int i = 0; i < updatedFolders.length; i++) {
      updatedFolders[i] = updatedFolders[i].copyWith(order: i);
    }

    // persist changes
    for (final folder in updatedFolders) {
      _folderDb.update(folder);
    }

    state = state.copyWith(folders: updatedFolders);
  }
}

final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>(
  (ref) => FolderNotifier(),
);
