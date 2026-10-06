import 'package:flutter/material.dart';

enum BadgeVariant {
  success,
  warning,
  danger,
  info,
  neutral,
}

/// Badge visual accesible y con armonía cromática para estados del sistema.
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (variant) {
      case BadgeVariant.success:
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF047857);
        border = const Color(0xFFA7F3D0);
        break;
      case BadgeVariant.warning:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFB45309);
        border = const Color(0xFFFDE68A);
        break;
      case BadgeVariant.danger:
        bg = const Color(0xFFFFF1F2);
        fg = const Color(0xFFBE123C);
        border = const Color(0xFFFECDD3);
        break;
      case BadgeVariant.info:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        border = const Color(0xFFBFDBFE);
        break;
      case BadgeVariant.neutral:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        border = const Color(0xFFE2E8F0);
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      bg = fg.withValues(alpha: 0.15);
      border = fg.withValues(alpha: 0.35);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
