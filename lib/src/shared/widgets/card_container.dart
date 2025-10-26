import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final dynamic leading;
  final Widget title;
  final Color? color;
  final Widget? trailing;
  final Function()? onTap;

  const CardContainer({
    super.key,
    this.leading,
    required this.title,
    this.color,
    this.trailing,
    this.onTap,
  });

  Widget leadingWidget(BuildContext context) {
    final Color effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    if (leading is IconData) {
      return CircleAvatar(
        backgroundColor: effectiveColor.withValues(alpha: 0.15),
        child: Icon(leading, color: effectiveColor),
      );
    }
    if (leading != null) {
      return leading;
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: effectiveColor.withValues(alpha: 0.2),
          highlightColor: effectiveColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: leadingWidget(context),
              title: title,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }
}
