import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_payroll_period.dart';

/// Panel de resumen con 4 KPIs para el período de nómina (Pantalla 12 — Bloque 4).
class RrhhPayrollKpis extends StatelessWidget {
  final RrhhPayrollPeriod period;
  final List<RrhhPayrollItem> items;

  const RrhhPayrollKpis({
    super.key,
    required this.period,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0.00', 'es_BO');

    // 1. Empleados únicos con novedades
    final uniqueEmployees = items.map((i) => i.employeeId).toSet().length;

    // 2. Total descuentos (suma de valores absolutos de items con impacto 'descuento')
    final totalDiscounts = items
        .where((i) => i.impactType == RrhhPayrollImpactType.descuento)
        .fold<double>(0.0, (sum, i) => sum + (i.impactAmount?.abs() ?? 0.0));

    // 3. Total pagos extra / finiquitos
    final totalExtra = items
        .where((i) => i.impactType == RrhhPayrollImpactType.pagoExtra)
        .fold<double>(0.0, (sum, i) => sum + (i.impactAmount ?? 0.0));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final cardWidth = isNarrow
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        final cards = [
          _buildKpiCard(
            title: 'Empleados con novedades',
            value: '$uniqueEmployees',
            subtitle: 'En ${period.displayName}',
            icon: Icons.people_outline_rounded,
            iconColor: const Color(0xFF3B82F6),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Total descuentos',
            value: 'Bs. ${currencyFormatter.format(totalDiscounts)}',
            subtitle: 'Faltas, sanciones y permisos',
            icon: Icons.trending_down_rounded,
            iconColor: const Color(0xFFEF4444),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Total pagos extra',
            value: 'Bs. ${currencyFormatter.format(totalExtra)}',
            subtitle: 'Finiquitos y liquidaciones',
            icon: Icons.trending_up_rounded,
            iconColor: const Color(0xFF10B981),
            width: cardWidth,
          ),
          _buildStatusKpiCard(
            period: period,
            width: cardWidth,
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards,
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusKpiCard({
    required RrhhPayrollPeriod period,
    required double width,
  }) {
    Color statusColor;
    String statusDesc;

    switch (period.status.toLowerCase()) {
      case RrhhPayrollPeriodStatus.abierto:
        statusColor = const Color(0xFF3B82F6);
        statusDesc = 'En captura y consolidación';
        break;
      case RrhhPayrollPeriodStatus.cerrado:
        statusColor = const Color(0xFFA855F7);
        statusDesc = 'Listo para Contabilidad';
        break;
      case RrhhPayrollPeriodStatus.enviado:
        statusColor = const Color(0xFF10B981);
        statusDesc = 'Remitido a Contabilidad';
        break;
      case RrhhPayrollPeriodStatus.procesado:
        statusColor = const Color(0xFF06B6D4);
        statusDesc = 'Planilla ejecutada';
        break;
      default:
        statusColor = const Color(0xFF94A3B8);
        statusDesc = 'Estado del ciclo';
    }

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.verified_outlined, color: statusColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Estado del período',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        RrhhPayrollPeriodStatus.label(period.status),
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  statusDesc,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
