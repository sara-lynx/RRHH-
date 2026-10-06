import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_disciplinary_record.dart';

/// Chip para tipo de falta disciplinaria con punto indicador semántico.
class RrhhFaultTypeChip extends StatelessWidget {
  final String faultType;

  const RrhhFaultTypeChip({super.key, required this.faultType});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getConfig(faultType);

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

  (Color, String) _getConfig(String type) {
    switch (type.toLowerCase()) {
      case RrhhFaultTypes.leve:
        return (const Color(0xFFF59E0B), 'Falta Leve');
      case RrhhFaultTypes.grave:
        return (const Color(0xFFF97316), 'Falta Grave');
      case RrhhFaultTypes.gravisima:
        return (const Color(0xFFEF4444), 'Falta Gravísima');
      default:
        return (const Color(0xFF94A3B8), type.toUpperCase());
    }
  }
}
