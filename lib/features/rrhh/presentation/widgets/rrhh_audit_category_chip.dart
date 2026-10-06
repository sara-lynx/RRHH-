import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_timeline_event.dart';

/// Chip semántico para categorías de la Bitácora de Movimientos (Pantalla 14 — Bloque 4).
class RrhhAuditCategoryChip extends StatelessWidget {
  final String category;
  final bool isCompact;

  const RrhhAuditCategoryChip({
    super.key,
    required this.category,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color bgColor;
    Color textColor;
    String label;

    switch (category.toUpperCase()) {
      case RrhhTimelineCategory.contratacion:
        dotColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF064E3B).withValues(alpha: 0.35);
        textColor = const Color(0xFF34D399);
        label = 'Contratación';
        break;
      case RrhhTimelineCategory.asignacion:
        dotColor = const Color(0xFF818CF8);
        bgColor = const Color(0xFF312E81).withValues(alpha: 0.35);
        textColor = const Color(0xFFA5B4FC);
        label = 'Asignación';
        break;
      case RrhhTimelineCategory.contractual:
        dotColor = const Color(0xFF3B82F6);
        bgColor = const Color(0xFF1E3A8A).withValues(alpha: 0.35);
        textColor = const Color(0xFF60A5FA);
        label = 'Contractual';
        break;
      case RrhhTimelineCategory.horario:
        dotColor = const Color(0xFF06B6D4);
        bgColor = const Color(0xFF164E63).withValues(alpha: 0.35);
        textColor = const Color(0xFF67E8F9);
        label = 'Horarios';
        break;
      case RrhhTimelineCategory.permiso:
        dotColor = const Color(0xFFF59E0B);
        bgColor = const Color(0xFF78350F).withValues(alpha: 0.35);
        textColor = const Color(0xFFFBBF24);
        label = 'Permiso';
        break;
      case RrhhTimelineCategory.vacaciones:
        dotColor = const Color(0xFF14B8A6);
        bgColor = const Color(0xFF134E4A).withValues(alpha: 0.35);
        textColor = const Color(0xFF5EEAD4);
        label = 'Vacaciones';
        break;
      case RrhhTimelineCategory.incidencia:
        dotColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFF7F1D1D).withValues(alpha: 0.35);
        textColor = const Color(0xFFF87171);
        label = 'Incidencia';
        break;
      case RrhhTimelineCategory.desvinculacion:
        dotColor = const Color(0xFFF43F5E);
        bgColor = const Color(0xFF881337).withValues(alpha: 0.35);
        textColor = const Color(0xFFFDA4AF);
        label = 'Desvinculación';
        break;
      case RrhhTimelineCategory.salarios:
        dotColor = const Color(0xFFEAB308);
        bgColor = const Color(0xFF713F12).withValues(alpha: 0.35);
        textColor = const Color(0xFFFDE047);
        label = 'Salarios';
        break;
      case RrhhTimelineCategory.catalogos:
        dotColor = const Color(0xFFA855F7);
        bgColor = const Color(0xFF581C87).withValues(alpha: 0.35);
        textColor = const Color(0xFFD8B4FE);
        label = 'Catálogos';
        break;
      case RrhhTimelineCategory.sistema:
        dotColor = const Color(0xFF94A3B8);
        bgColor = const Color(0xFF334155).withValues(alpha: 0.35);
        textColor = const Color(0xFFCBD5E1);
        label = 'Sistema';
        break;
      default:
        dotColor = const Color(0xFF64748B);
        bgColor = const Color(0xFF1E293B).withValues(alpha: 0.35);
        textColor = const Color(0xFF94A3B8);
        label = category;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 7 : 9,
        vertical: isCompact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: isCompact ? 10.5 : 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
