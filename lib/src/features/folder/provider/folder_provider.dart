import 'package:coupon_place/src/features/folder/model/folder.dart';
import 'package:coupon_place/src/infra/firebase/firestore_service.dart';
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

final firestoreService = FirestoreService();

class FolderNotifier extends StateNotifier<FolderState> {
  FolderNotifier() : super(FolderState()) {
    _loadFolders();
  }

  final _uuid = const Uuid();

  Future<void> _loadFolders() async {
    final folders = await firestoreService.getFoldersFromFirestore();
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
    firestoreService.addFolderToFirestore(newFolder);
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

  void removeFolder(String id) {
    state = state.copyWith(
      folders: state.folders.where((folder) => folder.id != id).toList(),
    );
    firestoreService.removeFolder(id);
  }
}

final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>(
  (ref) => FolderNotifier(),
);
