import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_vacation.dart';

/// Chip con punto indicador semántico para el estado de un registro de goce de vacaciones.
class RrhhVacationStatusChip extends StatelessWidget {
  final String status;

  const RrhhVacationStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.28), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case RrhhVacationRecordStatus.programado:
        return (const Color(0xFF38BDF8), 'Programado');
      case RrhhVacationRecordStatus.enCurso:
        return (const Color(0xFF10B981), 'En curso');
      case RrhhVacationRecordStatus.gozado:
        return (const Color(0xFF94A3B8), 'Gozado');
      case RrhhVacationRecordStatus.cancelado:
        return (const Color(0xFFEF4444), 'Cancelado');
      default:
        return (const Color(0xFF94A3B8), status);
    }
  }
}
