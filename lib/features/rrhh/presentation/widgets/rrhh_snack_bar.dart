import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum RrhhSnackBarType {
  success,
  info,
  warning,
  error,
}

/// Helper para estandarizar todos los SnackBars del módulo RRHH
/// con alto contraste, borde lateral semántico, icono y tipografía Inter.
class RrhhSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    RrhhSnackBarType type = RrhhSnackBarType.info,
    Duration? duration,
    SnackBarAction? action,
  }) {
    final (Color typeColor, IconData iconData) = switch (type) {
      RrhhSnackBarType.success => (
        const Color(0xFF10B981),
        Icons.check_circle_rounded,
      ),
      RrhhSnackBarType.info => (
        const Color(0xFF3B82F6),
        Icons.info_outline_rounded,
      ),
      RrhhSnackBarType.warning => (
        const Color(0xFFF59E0B),
        Icons.warning_amber_rounded,
      ),
      RrhhSnackBarType.error => (
        const Color(0xFFEF4444),
        Icons.cancel_outlined,
      ),
    };

    final effectiveDuration =
        duration ??
        ((type == RrhhSnackBarType.warning || type == RrhhSnackBarType.error)
            ? const Duration(seconds: 4)
            : const Duration(seconds: 3));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        duration: effectiveDuration,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Slate oscuro sólido
              border: Border.all(color: const Color(0xFF334155), width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 4, color: typeColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(iconData, color: typeColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              message,
                              style: GoogleFonts.inter(
                                color: const Color(
                                  0xFFF8FAFC,
                                ), // Blanco claro alto contraste
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (action != null) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                                action.onPressed();
                              },
                              child: Text(
                                action.label,
                                style: GoogleFonts.inter(
                                  color: typeColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) => show(
    context,
    message: message,
    type: RrhhSnackBarType.success,
    duration: duration,
    action: action,
  );

  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) => show(
    context,
    message: message,
    type: RrhhSnackBarType.info,
    duration: duration,
    action: action,
  );

  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) => show(
    context,
    message: message,
    type: RrhhSnackBarType.warning,
    duration: duration,
    action: action,
  );

  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) => show(
    context,
    message: message,
    type: RrhhSnackBarType.error,
    duration: duration,
    action: action,
  );
}
