import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final dynamic leading;
  final Widget title;
  final Color color;
  final Widget? trailing;
  final Function()? onTap;

  const CardContainer({
    super.key,
    required this.leading,
    required this.title,
    required this.color,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                if (leading is IconData)
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(leading, color: color),
                  )
                else if (leading is Widget)
                  leading,
                const SizedBox(width: 16),
                Expanded(child: title),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
