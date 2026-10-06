import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Chip de estado de disponibilidad para el Directorio de Personal de RRHH.
/// Cumple con la paleta de DESIGN.md y el ritmo visual de impeccable.
class RrhhPersonalStatusChip extends StatelessWidget {
  final String status;

  const RrhhPersonalStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _getStatusProps(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  (String, Color, IconData) _getStatusProps(String rawStatus) {
    final clean = rawStatus.toUpperCase().trim();
    switch (clean) {
      case 'DISPONIBLE':
        return (
          'Disponible',
          const Color(0xFF10B981),
          Icons.check_circle_outline,
        );
      case 'ASIGNADO':
        return (
          'Asignado',
          const Color(0xFF2563EB),
          Icons.business_center_outlined,
        );
      case 'CON_PERMISO':
        return (
          'Con Permiso',
          const Color(0xFFF59E0B),
          Icons.access_time_outlined,
        );
      case 'DE_VACACIONES':
        return (
          'Vacaciones',
          const Color(0xFF8B5CF6),
          Icons.beach_access_outlined,
        );
      case 'SUSPENDIDO':
        return (
          'Suspendido',
          const Color(0xFFEF4444),
          Icons.remove_circle_outline,
        );
      case 'INACTIVO':
      case 'BAJA':
        return ('Inactivo', const Color(0xFF64748B), Icons.cancel_outlined);
      default:
        return (
          clean.replaceAll('_', ' '),
          const Color(0xFF94A3B8),
          Icons.info_outline,
        );
    }
  }
}
