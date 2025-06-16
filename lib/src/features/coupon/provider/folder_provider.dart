import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Folder {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Folder({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

class FolderState {
  final List<Folder> folders;

  FolderState({this.folders = const []});

  FolderState copyWith({List<Folder>? folders}) {
    return FolderState(folders: folders ?? this.folders);
  }
}

class FolderNotifier extends StateNotifier<FolderState> {
  FolderNotifier() : super(FolderState());

  final _uuid = const Uuid();

  void addFolder(String name, Color color, IconData icon) {
    final newFolder = Folder(
      id: _uuid.v4(),
      name: name,
      color: color,
      icon: icon,
    );
    state = state.copyWith(folders: [...state.folders, newFolder]);
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
  }
}

final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>(
  (ref) => FolderNotifier(),
);
