import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/shared/utils/icon_mapping.dart';
import 'package:coupon_place/src/shared/widgets/card_container.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_form_screen.dart';
import 'package:coupon_place/src/features/folder/screen/folder_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final selectModeProvider = StateProvider<bool>((ref) => false);
final selectedFoldersProvider = StateProvider<Set<String>>((ref) => {});

enum FolderMenuAction { add, select }

class MyCouponsScreen extends ConsumerWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final folders = ref.watch(folderProvider).folders;
    final folderNotifier = ref.read(folderProvider.notifier);
    final isSelectMode = ref.watch(selectModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(selectModeProvider) ? loc.folderSelect : loc.myCouponsTitle,
        ),
        centerTitle: true,
        actions: [
          if (isSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.check_sharp, color: Colors.green),
              onPressed: () {
                ref.read(selectModeProvider.notifier).state = false;
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
                    ref.read(selectModeProvider.notifier).state = false;
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
                          child: Center(
                            child: FolderFormScreen(
                              onSubmit: (name, color, icon) {
                                folderNotifier.addFolder(name, color, icon);
                              },
                            ),
                          ),
                        ),
                  );
                } else if (value == FolderMenuAction.select) {
                  final current = ref.read(selectModeProvider);
                  ref.read(selectModeProvider.notifier).state = !current;
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
                      value: FolderMenuAction.select,
                      child: Text(loc.folderSelect),
                    ),
                  ],
            ),
          ],
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return Slidable(
              key: ValueKey(folder.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
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
                              child: Center(
                                child: FolderFormScreen(
                                  initialName: folder.name,
                                  initialColor: Color(folder.colorValue),
                                  initialIcon:
                                      iconMapping[folder.iconCodePoint],
                                  onSubmit: (name, color, icon) {
                                    folderNotifier.updateFolder(
                                      folder.id,
                                      name: name,
                                      color: color,
                                      icon: icon,
                                    );
                                  },
                                ),
                              ),
                            ),
                      );
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
                        onConfirm: () => folderNotifier.removeFolder(folder.id),
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
                  final slidable = Slidable.of(context);
                  return ValueListenableBuilder<ActionPaneType>(
                    valueListenable: slidable!.actionPaneType,
                    builder: (context, actionPaneType, child) {
                      final isOpen = actionPaneType != ActionPaneType.none;
                      final selectedFolders = ref.watch(
                        selectedFoldersProvider,
                      );
                      return IgnorePointer(
                        ignoring: isOpen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          child: Row(
                            children: [
                              if (isSelectMode)
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
                                  label: folder.name,
                                  icon:
                                      iconMapping[folder.iconCodePoint] ??
                                      Icons.folder,
                                  color: Color(folder.colorValue),
                                  onTap: () {
                                    context.push(
                                      AppRoutes.folderDetail.replaceFirst(
                                        ':folderId',
                                        folder.id,
                                      ),
                                      extra: folder.name,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
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
