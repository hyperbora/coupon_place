import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/infra/local_db/folder_local_db.dart';
import 'package:coupon_place/src/infra/local_db/coupon_local_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

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
    state = state.copyWith(folders: folders);
  }

  void addFolder(String name, Color color, IconData icon) {
    final newFolder = Folder(
      id: _uuid.v4(),
      name: name,
      color: color,
      icon: icon,
    );
    state = state.copyWith(folders: [...state.folders, newFolder]);
    _folderDb.add(newFolder);
  }

  void editFolder(String id, String name, Color color, IconData icon) {
    state = state.copyWith(
      folders:
          state.folders.map((folder) {
            if (folder.id == id) {
              return Folder(id: id, name: name, color: color, icon: icon);
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
              color: color ?? folder.color,
              icon: icon ?? folder.icon,
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
      if (coupon.imagePath != null && coupon.imagePath!.isNotEmpty) {
        final file = File(coupon.imagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }
}

final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>(
  (ref) => FolderNotifier(),
);
