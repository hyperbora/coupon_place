import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/folder/model/folder_model.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/shared/utils/icon_mapping.dart';
import 'package:coupon_place/src/shared/widgets/card_container.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_form_screen.dart';
import 'package:coupon_place/src/features/folder/screen/folder_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final manageModeProvider = StateProvider<bool>((ref) => false);
final selectedFoldersProvider = StateProvider<Set<String>>((ref) => {});

enum FolderMenuAction { add, manage }

class FolderListScreen extends ConsumerWidget {
  const FolderListScreen({super.key});

  void _showFolderForm(
    BuildContext context,
    Folder? folder,
    Function(String name, Color color, IconData icon) onSubmit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => FractionallySizedBox(
            heightFactor: 0.9,
            child: Center(
              child: FolderFormScreen(
                initialName: folder?.name,
                initialColor: folder != null ? Color(folder.colorValue) : null,
                initialIcon:
                    folder != null ? iconMapping[folder.iconCodePoint] : null,
                onSubmit: onSubmit,
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final folders = ref.watch(folderProvider).folders;
    final folderNotifier = ref.read(folderProvider.notifier);
    final isManageMode = ref.watch(manageModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(manageModeProvider) ? loc.folderManage : loc.myCouponsTitle,
        ),
        centerTitle: true,
        actions: [
          if (isManageMode) ...[
            IconButton(
              icon: const Icon(Icons.check_sharp, color: Colors.green),
              onPressed: () {
                ref.read(manageModeProvider.notifier).state = false;
                ref.read(selectedFoldersProvider.notifier).state = {};
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showConfirmDialog(
                  context,
                  title: loc.deleteFolderTitle,
                  message: loc.deleteFolderMessage,
                  onConfirm: () {
                    final selected = ref.read(selectedFoldersProvider);
                    for (final id in selected) {
                      folderNotifier.removeFolder(id);
                    }
                    ref.read(manageModeProvider.notifier).state = false;
                    ref.read(selectedFoldersProvider.notifier).state = {};
                  },
                );
              },
            ),
          ] else ...[
            PopupMenuButton<FolderMenuAction>(
              icon: const Icon(Icons.more_vert_outlined),
              onSelected: (value) {
                if (value == FolderMenuAction.add) {
                  _showFolderForm(context, null, (name, color, icon) {
                    folderNotifier.addFolder(name, color, icon);
                  });
                } else if (value == FolderMenuAction.manage) {
                  final current = ref.read(manageModeProvider);
                  ref.read(manageModeProvider.notifier).state = !current;
                  ref.read(selectedFoldersProvider.notifier).state = {};
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: FolderMenuAction.add,
                      child: Text(loc.folderAdd),
                    ),
                    PopupMenuItem(
                      value: FolderMenuAction.manage,
                      child: Text(loc.folderManage),
                    ),
                  ],
            ),
          ],
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: SlidableAutoCloseBehavior(
          child: ReorderableListView.builder(
            itemCount: folders.length,
            onReorder: (oldIndex, newIndex) {
              ref
                  .read(folderProvider.notifier)
                  .reorderFolders(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final folder = folders[index];
              return Slidable(
                key: ValueKey(folder.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showFolderForm(context, folder, (name, color, icon) {
                          folderNotifier.updateFolder(
                            folder.id,
                            name: name,
                            color: color,
                            icon: icon,
                          );
                        });
                      },
                      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: loc.edit,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        showConfirmDialog(
                          context,
                          title: loc.deleteFolderTitle,
                          message: loc.deleteFolderMessage,
                          onConfirm:
                              () => folderNotifier.removeFolder(folder.id),
                        );
                      },
                      backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: loc.delete,
                    ),
                  ],
                ),
                child: Builder(
                  builder: (context) {
                    final selectedFolders = ref.watch(selectedFoldersProvider);
                    final isManageModeInListItem = ref.watch(
                      manageModeProvider,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      child: Row(
                        children: [
                          if (isManageModeInListItem)
                            Checkbox(
                              value: selectedFolders.contains(folder.id),
                              onChanged: (checked) {
                                final notifier = ref.read(
                                  selectedFoldersProvider.notifier,
                                );
                                final current = Set<String>.from(
                                  notifier.state,
                                );
                                if (checked == true) {
                                  current.add(folder.id);
                                } else {
                                  current.remove(folder.id);
                                }
                                notifier.state = current;
                              },
                            ),
                          Expanded(
                            child: CardContainer(
                              title: Text(folder.name),
                              leading:
                                  iconMapping[folder.iconCodePoint] ??
                                  Icons.folder,
                              color: Color(folder.colorValue),
                              onTap:
                                  isManageModeInListItem
                                      ? null
                                      : () {
                                        AppRoutes.couponList.push(
                                          context,
                                          pathParams: {'folderId': folder.id},
                                        );
                                      },
                              trailing:
                                  isManageModeInListItem
                                      ? null
                                      : Icon(
                                        Icons.chevron_right,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                      ),
                            ),
                          ),
                          if (isManageModeInListItem) ...[
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blueGrey,
                              ),
                              tooltip: loc.editFolderTooltip,
                              onPressed: () {
                                _showFolderForm(context, folder, (
                                  name,
                                  color,
                                  icon,
                                ) {
                                  folderNotifier.updateFolder(
                                    folder.id,
                                    name: name,
                                    color: color,
                                    icon: icon,
                                  );
                                });
                              },
                            ),
                            ReorderableDragStartListener(
                              index: index,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.drag_handle,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (folders.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(loc.folderCreateFirst)));
          }
        },
        child: AbsorbPointer(
          absorbing: folders.isEmpty,
          child: FloatingActionButton(
            onPressed:
                folders.isEmpty
                    ? null
                    : () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder:
                            (context) => FractionallySizedBox(
                              heightFactor: 0.9,
                              child: const CouponFormScreen(),
                            ),
                      );
                    },
            tooltip: loc.couponRegisterTooltip,
            shape: const CircleBorder(),
            backgroundColor: folders.isEmpty ? Colors.grey : null,
            child: const Icon(Icons.add_card),
          ),
        ),
      ),
    );
  }
}
