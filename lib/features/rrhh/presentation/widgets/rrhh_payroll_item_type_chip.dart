import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_payroll_period.dart';

/// Chip de tipo de fuente u origen de la novedad laboral (Pantalla 12 — Bloque 4).
class RrhhPayrollItemTypeChip extends StatelessWidget {
  final String sourceType;

  const RrhhPayrollItemTypeChip({
    super.key,
    required this.sourceType,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String label;

    switch (sourceType.toLowerCase()) {
      case RrhhPayrollSourceType.permiso:
        bg = const Color(0xFF3B82F6).withValues(alpha: 0.15);
        border = const Color(0xFF3B82F6).withValues(alpha: 0.35);
        text = const Color(0xFF60A5FA);
        icon = Icons.event_available_rounded;
        label = 'Permiso / Licencia';
        break;
      case RrhhPayrollSourceType.vacacion:
        bg = const Color(0xFF10B981).withValues(alpha: 0.15);
        border = const Color(0xFF10B981).withValues(alpha: 0.35);
        text = const Color(0xFF34D399);
        icon = Icons.beach_access_rounded;
        label = 'Vacaciones';
        break;
      case RrhhPayrollSourceType.incidencia:
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        border = const Color(0xFFF59E0B).withValues(alpha: 0.35);
        text = const Color(0xFFFBBF24);
        icon = Icons.gavel_rounded;
        label = 'Incidencia / Disciplina';
        break;
      case RrhhPayrollSourceType.desvinculacion:
        bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        border = const Color(0xFFEF4444).withValues(alpha: 0.35);
        text = const Color(0xFFF87171);
        icon = Icons.person_remove_rounded;
        label = 'Desvinculación';
        break;
      default:
        bg = const Color(0xFF64748B).withValues(alpha: 0.15);
        border = const Color(0xFF64748B).withValues(alpha: 0.35);
        text = const Color(0xFF94A3B8);
        icon = Icons.info_outline;
        label = sourceType;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: text,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
