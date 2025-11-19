import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/infra/local_db/backup_manager.dart';
import 'package:coupon_place/src/infra/local_db/backup_status.dart';
import 'package:coupon_place/src/infra/local_db/data_clear_manager.dart';
import 'package:coupon_place/src/infra/local_db/restore_status.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:coupon_place/src/shared/widgets/full_width_ink_button.dart';
import 'package:coupon_place/src/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  String getBackupMessage(BackupStatus backupStatus, AppLocalizations loc) {
    if (backupStatus == BackupStatus.success) {
      return loc.backupSuccess;
    }
    if (backupStatus == BackupStatus.cancelled) {
      return loc.backupCancelled;
    }
    return loc.backupError;
  }

  String getRestoreMessage(RestoreStatus restoreStatus, AppLocalizations loc) {
    if (restoreStatus == RestoreStatus.success) {
      return loc.restoreSuccess;
    }
    if (restoreStatus == RestoreStatus.cancelled) {
      return loc.restoreCancelled;
    }
    return loc.restoreError;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final currentContext = context;
    final dataBackupButton = FullWidthInkButton(
      text: loc.dataBackupLabel,
      onTap: () async {
        await showConfirmDialog(
          currentContext,
          title: loc.dataBackupDialogTitle,
          message: loc.dataBackupDialogMessage,
          onConfirm: () async {
            final backupStatus = await withLoading(
              currentContext,
              () =>
                  BackupService.createBackupAndSave(loc.saveBackupDialogTitle),
              loc.loadingBackupMessage,
            );

            final backupResultMessage = getBackupMessage(backupStatus, loc);
            if (currentContext.mounted) {
              ScaffoldMessenger.of(
                currentContext,
              ).showSnackBar(SnackBar(content: Text(backupResultMessage)));
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
          currentContext,
          title: loc.dataRestoreDialogTitle,
          message: loc.dataRestoreDialogMessage,
          onConfirm: () async {
            final restoreStatus = await withLoading(
              currentContext,
              () => BackupService.restoreFromBackup(
                loc.selectBackupDialogTitle,
                ref,
                loc,
              ),
              loc.loadingRestoreMessage,
            );
            if (currentContext.mounted) {
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(content: Text(getRestoreMessage(restoreStatus, loc))),
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
          currentContext,
          title: loc.deleteAllDataDialogTitle,
          message: loc.deleteAllDataDialogMessage,
          onConfirm: () async {
            await withLoading(
              currentContext,
              () => DataClearManager.clearAll(ref),
              loc.loadingClearAllMessage,
            );
            if (currentContext.mounted) {
              ScaffoldMessenger.of(currentContext).showSnackBar(
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
