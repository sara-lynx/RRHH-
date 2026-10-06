import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_termination_record.dart';

/// Chip de tipo de desvinculación con color semántico por causal.
class RrhhTerminationTypeChip extends StatelessWidget {
  final String type;

  const RrhhTerminationTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getTypeConfig(type);

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

  (Color, String) _getTypeConfig(String type) {
    switch (type.toLowerCase()) {
      case RrhhTerminationTypes.renunciaVoluntaria:
        return (const Color(0xFF38BDF8), 'Renuncia Voluntaria');
      case RrhhTerminationTypes.despidoJustificado:
        return (const Color(0xFFF97316), 'Despido Justificado (Art. 16)');
      case RrhhTerminationTypes.despidoInjustificado:
        return (const Color(0xFFEF4444), 'Despido Injustificado');
      case RrhhTerminationTypes.finDeContrato:
        return (const Color(0xFFA855F7), 'Fin de Contrato');
      case RrhhTerminationTypes.jubilacion:
        return (const Color(0xFF10B981), 'Jubilación');
      case RrhhTerminationTypes.abandonoDeTrabajo:
        return (const Color(0xFFE11D48), 'Abandono de Trabajo');
      default:
        return (const Color(0xFF94A3B8), type);
    }
  }
}
