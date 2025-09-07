import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
  String? confirmText,
  String? cancelText,
  Color? confirmColor,
  Color? cancelColor,
}) async {
  final loc = AppLocalizations.of(context)!;

  final result = await showDialog<bool>(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                cancelText ?? loc.cancel,
                style: TextStyle(color: cancelColor ?? Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                confirmText ?? loc.confirm,
                style: TextStyle(color: confirmColor ?? Colors.red),
              ),
            ),
          ],
        ),
  );

  if (result == true) {
    onConfirm();
  }
}
