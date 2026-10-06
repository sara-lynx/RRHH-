import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_payroll_period.dart';
import 'rrhh_payroll_impact_chip.dart';
import 'rrhh_payroll_item_type_chip.dart';

/// Fila representativa para una novedad consolidada de nómina (Pantalla 12 — Bloque 4).
///
/// Utiliza anchos proporcionales (flex weights) para ocupar el 100% del ancho disponible:
/// - Empleado: flex 24 (~24%)
/// - Tipo de novedad: flex 14 (~14%)
/// - Código origen: flex 11 (~11%)
/// - Fecha efectiva: flex 11 (~11%)
/// - Descripción: flex 26 (~26%)
/// - Impacto nómina: flex 14 (~14%) pegado al borde derecho.
class RrhhPayrollItemRow extends StatefulWidget {
  final RrhhPayrollItem item;
  final bool isEven;
  final VoidCallback? onTap;

  const RrhhPayrollItemRow({
    super.key,
    required this.item,
    this.isEven = false,
    this.onTap,
  });

  @override
  State<RrhhPayrollItemRow> createState() => _RrhhPayrollItemRowState();
}

class _RrhhPayrollItemRowState extends State<RrhhPayrollItemRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(item.effectiveDate);

    final baseBg = widget.isEven
        ? const Color(0xFF0F1523)
        : const Color(0xFF0B101B);
    final hoverBg = const Color(0xFF1E293B).withValues(alpha: 0.6);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? hoverBg : baseBg,
            border: const Border(
              bottom: BorderSide(color: Color(0xFF1E293B), width: 0.8),
            ),
          ),
          child: Row(
            children: [
              // 1. Empleado (Avatar + Nombre + Código) ~24%
              Expanded(
                flex: 24,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: 0.2),
                      child: Text(
                        _getInitials(item.employeeName),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.employeeName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.employeeCode,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // 2. Tipo de novedad ~14%
              Expanded(
                flex: 14,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhPayrollItemTypeChip(sourceType: item.sourceType),
                ),
              ),
              const SizedBox(width: 8),

              // 3. Código fuente ~11%
              Expanded(
                flex: 11,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Text(
                      item.sourceCode,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCBD5E1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 4. Fecha efectiva ~11%
              Expanded(
                flex: 11,
                child: Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              // 5. Descripción ~26%
              Expanded(
                flex: 26,
                child: Tooltip(
                  message: item.description,
                  child: Text(
                    item.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFE2E8F0),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 6. Impacto en nómina ~14% pegado a la derecha
              Expanded(
                flex: 14,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RrhhPayrollImpactChip(
                    impactType: item.impactType,
                    impactAmount: item.impactAmount,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'EM';
  }
}
