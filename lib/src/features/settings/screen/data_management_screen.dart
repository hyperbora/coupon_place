import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:coupon_place/src/infra/local_db/backup_manager.dart';
import 'package:coupon_place/src/infra/local_db/backup_status.dart';
import 'package:coupon_place/src/infra/local_db/data_clear_manager.dart';
import 'package:coupon_place/src/infra/local_db/restore_status.dart';
import 'package:coupon_place/src/shared/widgets/confirm_dialog.dart';
import 'package:coupon_place/src/shared/widgets/full_width_ink_button.dart';
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
      return "복원이 성공하였습니다.";
    }
    if (restoreStatus == RestoreStatus.cancelled) {
      return "복원이 취소되었습니다.";
    }
    return "복원 오류";
  }

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
            final backupStatus = await BackupService.createBackupAndSave(
              loc.saveBackupDialogTitle,
            );
            if (context.mounted) {
              final backupResultMessage = getBackupMessage(backupStatus, loc);
              ScaffoldMessenger.of(
                context,
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
          context,
          title: loc.dataRestoreDialogTitle,
          message: loc.dataRestoreDialogMessage,
          onConfirm: () async {
            final restoreStatus = await BackupService.restoreFromBackup(
              "백업 파일을 선택하세요.",
              ref,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
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
          context,
          title: loc.deleteAllDataDialogTitle,
          message: loc.deleteAllDataDialogMessage,
          onConfirm: () async {
            DataClearManager.clearAll(ref);
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
