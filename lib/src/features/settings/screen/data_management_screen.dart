import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/features/coupon/provider/coupon_list_provider.dart';
import 'package:coupon_place/src/features/folder/provider/folder_provider.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:coupon_place/src/shared/widgets/full_width_ink_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final dataBackupButton = FullWidthInkButton(
      text: loc.dataBackupLabel,
      onTap: () async {
        await showConfirmDialog(
          context,
          title: loc.dataBackupDialogTitle,
          message: loc.dataBackupDialogMessage,
          onConfirm: () async {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.dataBackupDoneMessage)),
              );
            }
          },
        );
      },
      backgroundColor: Colors.blue.shade600,
    );
    final dataRestoreButton = FullWidthInkButton(
      text: loc.dataRestoreLabel,
      onTap: () async {
        await showConfirmDialog(
          context,
          title: loc.dataRestoreDialogTitle,
          message: loc.dataRestoreDialogMessage,
          onConfirm: () async {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.dataRestoreDoneMessage)),
              );
            }
          },
        );
      },
      backgroundColor: Colors.purple.shade600,
    );
    final clearAllButton = FullWidthInkButton(
      text: loc.clearAllDataLabel,
      onTap: () async {
        await showConfirmDialog(
          context,
          title: loc.deleteAllDataDialogTitle,
          message: loc.deleteAllDataDialogMessage,
          onConfirm: () async {
            await ref.read(allCouponsProvider.notifier).clearAll();
            await ref.read(folderProvider.notifier).clearAll();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.allDataDeletedMessage)),
              );
            }
          },
        );
      },
      backgroundColor: Colors.red,
    );
    return Scaffold(
      appBar: AppBar(title: Text(loc.dataManagementTitle), centerTitle: true),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          dataBackupButton,
          const SizedBox(height: 16),
          dataRestoreButton,
          const SizedBox(height: 16),
          clearAllButton,
        ],
      ),
    );
  }
}
