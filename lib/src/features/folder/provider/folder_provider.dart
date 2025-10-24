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

  FolderState copyWith({List<Folder>? folders, bool? isEditing}) {
    return FolderState(folders: folders ?? this.folders);
  }
}

class FolderNotifier extends StateNotifier<FolderState> {
  FolderNotifier() : super(FolderState()) {
    _loadFolders();
  }

  final FolderLocalDb _folderDb = FolderLocalDb();
  final CouponLocalDb _couponDb = CouponLocalDb();
  final _uuid = const Uuid();

  Future<void> _loadFolders() async {
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

  void editFolder(String id, String name, Color color, IconData icon) {
    state = state.copyWith(
      folders:
          state.folders.map((folder) {
            if (folder.id == id) {
              return Folder(
                id: id,
                name: name,
                colorValue: color.toARGB32(),
                iconCodePoint: icon.codePoint,
              );
            }
            return folder;
          }).toList(),
    );
  }

  void updateFolder(String id, {String? name, Color? color, IconData? icon}) {
    final updatedFolders =
        state.folders.map((folder) {
          if (folder.id == id) {
            final updatedFolder = Folder(
              id: folder.id,
              name: name ?? folder.name,
              colorValue: color?.toARGB32() ?? folder.colorValue,
              iconCodePoint: icon?.codePoint ?? folder.iconCodePoint,
            );
            _folderDb.update(updatedFolder);
            return updatedFolder;
          }
          return folder;
        }).toList();
    state = state.copyWith(folders: updatedFolders);
  }

  Future<void> removeFolder(String id) async {
    // 상태 갱신 (UI 먼저 반영)
    state = state.copyWith(
      folders: state.folders.where((folder) => folder.id != id).toList(),
    );

    // 해당 폴더의 쿠폰 가져오기
    final coupons =
        (await _couponDb.getAll())
            .where((coupon) => coupon.folderId == id)
            .toList();

    // 로컬 DB에서 폴더 삭제
    await _folderDb.delete(id);

    // 쿠폰 이미지 파일 삭제
    for (final coupon in coupons) {
      if (coupon.imagePath != null) {
        FileHelper.deleteFile(coupon.imagePath!);
      }
    }
  }

  Future<void> clearAll() async {
    // Hive 또는 Local DB 전체 삭제
    for (final folder in state.folders) {
      await _folderDb.delete(folder.id);
    }
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
