import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_payroll_period.dart';

/// Barra de selección de período mensual para nómina (Pantalla 12 — Bloque 4).
///
/// Diseño compacto (~44-48px de altura) con selector dropdown de mes/año y código oficial.
class RrhhPayrollPeriodSelector extends StatelessWidget {
  final List<RrhhPayrollPeriod> periods;
  final RrhhPayrollPeriod? selectedPeriod;
  final ValueChanged<RrhhPayrollPeriod> onPeriodChanged;

  const RrhhPayrollPeriodSelector({
    super.key,
    required this.periods,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de calendario compacto
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 16,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(width: 10),

          // Label
          Text(
            'Período Mensual:',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 10),

          // Dropdown de períodos
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF334155), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedPeriod?.id,
                dropdownColor: const Color(0xFF0F172A),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF94A3B8),
                  size: 16,
                ),
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                items: periods.map((p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(p.displayName),
                        const SizedBox(width: 8),
                        _buildStatusDot(p.status),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (periodId) {
                  if (periodId != null) {
                    final found = periods.firstWhere((p) => p.id == periodId);
                    onPeriodChanged(found);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Código de referencia
          if (selectedPeriod != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFF334155), width: 1),
              ),
              child: Text(
                selectedPeriod!.code,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusDot(String status) {
    Color dotColor;
    switch (status.toLowerCase()) {
      case RrhhPayrollPeriodStatus.abierto:
        dotColor = const Color(0xFF3B82F6);
        break;
      case RrhhPayrollPeriodStatus.cerrado:
        dotColor = const Color(0xFFA855F7);
        break;
      case RrhhPayrollPeriodStatus.enviado:
        dotColor = const Color(0xFF10B981);
        break;
      case RrhhPayrollPeriodStatus.procesado:
        dotColor = const Color(0xFF06B6D4);
        break;
      default:
        dotColor = const Color(0xFF94A3B8);
    }

    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
