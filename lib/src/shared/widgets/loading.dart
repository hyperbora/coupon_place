import 'package:flutter/material.dart';
import 'dart:ui';

void _showLoadingOverlay(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierColor: Colors.black38,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black12),
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 280),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(strokeWidth: 4),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<T> withLoading<T>(
  BuildContext context,
  Future<T> Function() action,
  String message,
) async {
  _showLoadingOverlay(context, message);
  try {
    return await action();
  } finally {
    Navigator.of(context).pop();
  }
}
