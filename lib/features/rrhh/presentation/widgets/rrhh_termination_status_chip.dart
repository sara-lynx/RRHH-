import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_termination_record.dart';

/// Chip de estado para procesos de desvinculación con punto indicador semántico.
class RrhhTerminationStatusChip extends StatelessWidget {
  final String status;

  const RrhhTerminationStatusChip({super.key, required this.status});

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
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case RrhhTerminationStatus.registrada:
        return (const Color(0xFF94A3B8), 'Registrada');
      case RrhhTerminationStatus.enProceso:
        return (const Color(0xFFF59E0B), 'En proceso');
      case RrhhTerminationStatus.finalizada:
        return (const Color(0xFF10B981), 'Finalizada');
      case RrhhTerminationStatus.cancelada:
        return (const Color(0xFFEF4444), 'Cancelada');
      default:
        return (const Color(0xFF94A3B8), status);
    }
  }
}
