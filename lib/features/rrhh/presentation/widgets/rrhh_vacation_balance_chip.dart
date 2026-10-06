import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_vacation.dart';

/// Chip semántico para el estado del saldo vacacional del empleado.
class RrhhVacationBalanceChip extends StatelessWidget {
  final String status;

  const RrhhVacationBalanceChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getConfig(status);

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getConfig(String status) {
    switch (status.toLowerCase()) {
      case RrhhVacationBalanceStatus.disponible:
        return (const Color(0xFF10B981), 'Disponible');
      case RrhhVacationBalanceStatus.parcial:
        return (const Color(0xFFF59E0B), 'Por vencer');
      case RrhhVacationBalanceStatus.agotado:
        return (const Color(0xFF64748B), 'Agotado');
      case RrhhVacationBalanceStatus.vencido:
        return (const Color(0xFFEF4444), 'Vencido');
      case RrhhVacationBalanceStatus.sinDerecho:
        return (const Color(0xFF94A3B8), 'Sin derecho');
      default:
        return (const Color(0xFF94A3B8), status);
    }
  }
}
