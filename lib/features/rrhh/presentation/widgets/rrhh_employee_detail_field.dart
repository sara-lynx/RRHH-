import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Componente modular para mostrar un par Label / Valor en el expediente del empleado.
/// Soporta icono opcional, estado protegido/sensible (🔒) y máscara de confidencialidad.
class RrhhEmployeeDetailField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isSensitive;
  final bool isMasked;
  final Color? valueColor;
  final Widget? trailing;

  const RrhhEmployeeDetailField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isSensitive = false,
    this.isMasked = false,
    this.valueColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: const Color(0xFF64748B)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isSensitive) ...[
                      const SizedBox(width: 4),
                      const Tooltip(
                        message: 'Dato confidencial / protegido',
                        child: Icon(
                          Icons.lock_outline,
                          size: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isMasked ? '••••••••' : (value.isEmpty ? '—' : value),
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: isMasked
                        ? const Color(0xFF94A3B8)
                        : (valueColor ?? const Color(0xFFF8FAFC)),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
