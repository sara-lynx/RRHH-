import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_disciplinary_record.dart';

/// Chip para tipo de sanción disciplinaria con punto indicador semántico.
class RrhhSanctionTypeChip extends StatelessWidget {
  final String? sanctionType;

  const RrhhSanctionTypeChip({super.key, required this.sanctionType});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getConfig(sanctionType);

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

  (Color, String) _getConfig(String? type) {
    if (type == null ||
        type.isEmpty ||
        type == 'ninguna' ||
        type == 'sin_sancion') {
      return (const Color(0xFF64748B), 'Sin sanción');
    }
    switch (type.toLowerCase()) {
      case RrhhSanctionTypes.verbal:
        return (const Color(0xFF38BDF8), 'Amonestación Verbal');
      case RrhhSanctionTypes.escrita:
        return (const Color(0xFFF59E0B), 'Amonestación Escrita');
      case RrhhSanctionTypes.pecuniaria:
        return (const Color(0xFFA855F7), 'Sanción Pecuniaria');
      case RrhhSanctionTypes.suspension:
        return (const Color(0xFFF97316), 'Suspensión sin goce');
      case RrhhSanctionTypes.retiro:
        return (const Color(0xFFEF4444), 'Retiro / Destitución');
      default:
        return (const Color(0xFF94A3B8), type);
    }
  }
}
