import 'package:coupon_place/src/core/router/app_routes.dart';
import 'package:coupon_place/src/features/coupon/provider/folder_provider.dart';
import 'package:coupon_place/src/features/coupon/view/coupon_register_screen.dart';
import 'package:coupon_place/src/features/coupon/view/folder_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum FolderMenuAction { add, edit }

class MyCouponsScreen extends ConsumerWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final folders = ref.watch(folderProvider).folders;
    final isEditing = ref.watch(folderProvider).isEditing;
    final folderNotifier = ref.read(folderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myCouponsTitle),
        centerTitle: true,
        actions: [
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
              } else if (value == FolderMenuAction.edit) {
                folderNotifier.toggleEditing();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: FolderMenuAction.add,
                    child: Text(loc.folderAdd),
                  ),
                  PopupMenuItem(
                    value: FolderMenuAction.edit,
                    child: Text(loc.folderEdit),
                  ),
                ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: folder.color,
              child: Icon(folder.icon, color: Colors.white),
            ),
            title: Text(folder.name),
            trailing: Visibility(
              visible: isEditing,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => folderNotifier.removeFolder(folder.id),
              ),
            ),
            onTap: () {
              context.push(
                AppRoutes.folderDetail.replaceFirst(':folderId', folder.id),
                extra: folder.name,
              );
            },
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
