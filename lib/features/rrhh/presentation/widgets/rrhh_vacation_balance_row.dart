import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_vacation.dart';
import 'rrhh_vacation_balance_chip.dart';

/// Fila para la tabla de Saldo de Vacaciones por Empleado (Tab 1).
class RrhhVacationBalanceRow extends StatelessWidget {
  final RrhhVacationBalance balance;
  final bool isEven;
  final VoidCallback onProgramar;
  final VoidCallback onViewHistory;
  final VoidCallback onAdjustBalance;

  const RrhhVacationBalanceRow({
    super.key,
    required this.balance,
    required this.isEven,
    required this.onProgramar,
    required this.onViewHistory,
    required this.onAdjustBalance,
  });

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final canBook =
        balance.pendingDays > 0 &&
        balance.balanceStatus != RrhhVacationBalanceStatus.sinDerecho;

    final progress = balance.assignedDays > 0
        ? (balance.usedDays / balance.assignedDays).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: isEven
            ? const Color(0xFF0F172A)
            : const Color(0xFF0B132B).withValues(alpha: 0.5),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 1. Colaborador (Avatar + Nombre + Código) - Ancho flexible 22%
          Expanded(
            flex: 22,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(
                    0xFF2563EB,
                  ).withValues(alpha: 0.2),
                  child: Text(
                    balance.employeeName.isNotEmpty
                        ? balance.employeeName[0].toUpperCase()
                        : 'E',
                    style: GoogleFonts.inter(
                      fontSize: 12,
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
                      Tooltip(
                        message: balance.employeeName,
                        child: Text(
                          balance.employeeName,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        balance.employeeCode,
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

          // 2. Antigüedad calculada con fecha de ingreso debajo - 13%
          Expanded(
            flex: 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  RrhhVacationCalculator.formatAntiquity(
                    balance.hireDate,
                    DateTime(2026, 9, 26),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE2E8F0),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Ingreso: ${_formatDate(balance.hireDate)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 3. Días asignados - 8%
          Expanded(
            flex: 8,
            child: Text(
              '${balance.assignedDays} d',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: balance.assignedDays > 0
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF64748B),
              ),
            ),
          ),

          // 4. Días gozados - 8%
          Expanded(
            flex: 8,
            child: Text(
              '${balance.usedDays} d',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),

          // 5. Días pendientes con barra de progreso - 15%
          Expanded(
            flex: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '${balance.pendingDays}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: balance.pendingDays > 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      ' / ${balance.assignedDays} d',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFF1E293B),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0
                          ? const Color(0xFF64748B)
                          : const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Estado del saldo - 11%
          Expanded(
            flex: 11,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RrhhVacationBalanceChip(status: balance.balanceStatus),
            ),
          ),

          // 7. Próximo aniversario - 12%
          Expanded(
            flex: 12,
            child: balance.nextAnniversary != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDate(balance.nextAnniversary!),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      if (balance.daysUntilAnniversary != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          balance.daysUntilAnniversary! > 0
                              ? 'en ${balance.daysUntilAnniversary} días'
                              : balance.daysUntilAnniversary == 0
                              ? 'Hoy'
                              : 'Venció hace ${balance.daysUntilAnniversary!.abs()} d',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color:
                                (balance.daysUntilAnniversary! <= 30 &&
                                    balance.daysUntilAnniversary! >= 0)
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  )
                : const Text('—', style: TextStyle(color: Color(0xFF64748B))),
          ),

          // 8. Acciones: [Programar] + [⋯] - 11%
          Expanded(
            flex: 11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: canBook ? onProgramar : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF60A5FA),
                    disabledForegroundColor: const Color(0xFF475569),
                    side: BorderSide(
                      color: canBook
                          ? const Color(0xFF2563EB).withValues(alpha: 0.5)
                          : const Color(0xFF334155),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    minimumSize: const Size(0, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Programar',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  tooltip: 'Más opciones',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: const Color(0xFF0F172A),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF1E293B)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  onSelected: (val) {
                    if (val == 'history') onViewHistory();
                    if (val == 'adjust') onAdjustBalance();
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'history',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.history,
                            size: 16,
                            color: Color(0xFF38BDF8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ver historial',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'adjust',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.tune,
                            size: 16,
                            color: Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ajustar saldo',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
