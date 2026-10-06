import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_payroll_period.dart';

/// Chip de impacto económico en la nómina (Pantalla 12 — Bloque 4).
///
/// Muestra claramente si representa un Descuento (-Bs.), Pago Extra (+Bs.) o Sin Impacto.
class RrhhPayrollImpactChip extends StatelessWidget {
  final String impactType;
  final double? impactAmount;

  const RrhhPayrollImpactChip({
    super.key,
    required this.impactType,
    this.impactAmount,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0.00', 'es_BO');
    final amountAbs = (impactAmount != null ? impactAmount!.abs() : 0.0);
    final formattedAmount = 'Bs. ${currencyFormatter.format(amountAbs)}';

    Color bg;
    Color border;
    Color text;
    IconData icon;
    String label;

    switch (impactType.toLowerCase()) {
      case RrhhPayrollImpactType.descuento:
        bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        border = const Color(0xFFEF4444).withValues(alpha: 0.35);
        text = const Color(0xFFF87171);
        icon = Icons.arrow_downward_rounded;
        label = '-$formattedAmount';
        break;
      case RrhhPayrollImpactType.pagoExtra:
        bg = const Color(0xFF10B981).withValues(alpha: 0.15);
        border = const Color(0xFF10B981).withValues(alpha: 0.35);
        text = const Color(0xFF34D399);
        icon = Icons.arrow_upward_rounded;
        label = '+$formattedAmount';
        break;
      case RrhhPayrollImpactType.sinImpacto:
      default:
        bg = const Color(0xFF334155).withValues(alpha: 0.4);
        border = const Color(0xFF475569).withValues(alpha: 0.5);
        text = const Color(0xFF94A3B8);
        icon = Icons.horizontal_rule_rounded;
        label = 'Sin impacto';
        break;
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
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 4),
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
