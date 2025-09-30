import 'package:flutter/material.dart';

class FullWidthInkButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? textColor;

  const FullWidthInkButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.splashColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: splashColor ?? Colors.white24,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
