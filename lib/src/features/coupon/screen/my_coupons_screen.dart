import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/provider/folder_provider.dart';
import 'package:coupon_place/src/features/coupon/screen/coupon_register_screen.dart';
import 'package:coupon_place/src/features/coupon/screen/folder_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                final selected = ref.read(selectedFoldersProvider);
                for (final id in selected) {
                  folderNotifier.removeFolder(id);
                }
                ref.read(selectModeProvider.notifier).state = false;
                ref.read(selectedFoldersProvider.notifier).state = {};
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
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return Slidable(
            key: ValueKey(folder.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: loc.edit,
                ),
                SlidableAction(
                  onPressed: (context) {
                    folderNotifier.removeFolder(folder.id);
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
                    return IgnorePointer(
                      ignoring: isOpen,
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ref.watch(selectModeProvider))
                              Checkbox(
                                value: ref
                                    .watch(selectedFoldersProvider)
                                    .contains(folder.id),
                                onChanged: (checked) {
                                  final selected = ref.read(
                                    selectedFoldersProvider.notifier,
                                  );
                                  final current = {...selected.state};
                                  if (checked == true) {
                                    current.add(folder.id);
                                  } else {
                                    current.remove(folder.id);
                                  }
                                  selected.state = current;
                                },
                              ),
                            CircleAvatar(
                              backgroundColor: folder.color,
                              child: Icon(folder.icon, color: Colors.white),
                            ),
                          ],
                        ),
                        title: Text(folder.name),
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
                    );
                  },
                );
              },
            ),
          );
        },
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
                              child: const CouponRegisterScreen(),
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
