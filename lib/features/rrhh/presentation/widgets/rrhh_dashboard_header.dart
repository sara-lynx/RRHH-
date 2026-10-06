import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cabecera ejecutiva para el Dashboard de Recursos Humanos (RRHH).
/// Contiene título del módulo, badge de contexto y botones de acción rápida.
class RrhhDashboardHeader extends StatelessWidget {
  final bool isMobile;
  final bool isLoading;
  final VoidCallback onRefresh;

  const RrhhDashboardHeader({
    super.key,
    required this.isMobile,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.hub_outlined,
                    size: 12,
                    color: Color(0xFF93C5FD),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'RRHH • CONTROL OPERATIVO & TALENTO',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF93C5FD),
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Dashboard de Recursos Humanos',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 20 : 23,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFF8FAFC),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Telemetría consolidada de dotación, disponibilidad operativa y alertas contractuales',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    );

    final actionsRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: isLoading ? null : onRefresh,
          icon: isLoading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF94A3B8),
                    ),
                  ),
                )
              : const Icon(Icons.refresh, size: 16),
          label: Text(
            'Refrescar',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFF8FAFC),
            backgroundColor: const Color(0xFF1E293B),
            side: const BorderSide(color: Color(0xFF334155)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Disponible en Bloque 4',
          waitDuration: const Duration(milliseconds: 200),
          child: OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.download_outlined, size: 16),
            label: Text(
              'Descargar',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              disabledForegroundColor: const Color(0xFF64748B),
              side: const BorderSide(color: Color(0xFF1E293B)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleColumn,
          const SizedBox(height: 14),
          actionsRow,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: titleColumn),
        actionsRow,
      ],
    );
  }
}
