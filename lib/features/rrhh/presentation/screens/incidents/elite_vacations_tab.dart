import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_schedule_vacation_dialog.dart';

/// Tab 3: Vacaciones y Descansos según la escala de la Ley General del Trabajo.
class EliteVacationsTab extends ConsumerWidget {
  const EliteVacationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vacationRecords = ref.watch(rrhhVacationsProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        // =====================================================================
        // BANNER INFORMATIVO DE LA ESCALA LEGAL BOLIVIANA (~44px)
        // =====================================================================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFFCCFBF1)),
                ),
                child: const Icon(
                  Icons.policy_outlined,
                  size: 14,
                  color: Color(0xFF0D9488),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escala Legal de Vacaciones (Ley General del Trabajo - Art. 33)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '1 a 5 años: 15 días hábiles • 5 a 10 años: 20 días hábiles • Más de 10 años: 30 días hábiles',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  '12 Colaboradores Computados',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ),

        // =====================================================================
        // TABLA DE VACACIONES EN EXPANDED (80% DEL ESPACIO)
        // =====================================================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x040F172A),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tableWidth = constraints.maxWidth < 1180
                      ? 1180.0
                      : constraints.maxWidth;

                  const colSpacing = 12.0;
                  const horizMargin = 16.0;
                  const spacingAndMargins = (colSpacing * (9 - 1)) + (horizMargin * 2);
                  final netColumnsWidth = tableWidth - spacingAndMargins;

                  // Distribución proporcional 100% exacta
                  final colWorker = netColumnsWidth * 0.22;
                  final colCostCenter = netColumnsWidth * 0.08;
                  final colHireDate = netColumnsWidth * 0.09;
                  final colSeniority = netColumnsWidth * 0.08;
                  final colLegalDays = netColumnsWidth * 0.08;
                  final colUsedDays = netColumnsWidth * 0.08;
                  final colBalance = netColumnsWidth * 0.13;
                  final colSchedule = netColumnsWidth * 0.13;
                  final colActions = netColumnsWidth * 0.11;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowHeight: 46,
                          dataRowMinHeight: 52,
                          dataRowMaxHeight: 56,
                          horizontalMargin: horizMargin,
                          columnSpacing: colSpacing,
                          headingRowColor: const WidgetStatePropertyAll(
                            Color(0xFFF8FAFC),
                          ),
                          border: const TableBorder(
                            horizontalInside: BorderSide(
                              color: Color(0xFFF1F5F9),
                              width: 1.0,
                            ),
                          ),
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: colWorker,
                                child: Text(
                                  'COLABORADOR',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colCostCenter,
                                child: Text(
                                  'CENTRO COSTO',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colHireDate,
                                child: Text(
                                  'FECHA INGRESO',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colSeniority,
                                child: Text(
                                  'ANTIGÜEDAD',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colLegalDays,
                                child: Text(
                                  'DÍAS LEY',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colUsedDays,
                                child: Text(
                                  'CONSUMIDOS',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colBalance,
                                child: Text(
                                  'SALDO DISPONIBLE',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colSchedule,
                                child: Text(
                                  'PROGRAMACIÓN',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colActions,
                                child: Text(
                                  'ACCIONES',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: vacationRecords.map((rec) {
                            final hasSchedule = rec.currentRequest != null;

                            return DataRow(
                              cells: [
                                // Colaborador
                                DataCell(
                                  SizedBox(
                                    width: colWorker,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: const Color(0xFFCCFBF1),
                                          child: Text(
                                            _getInitials(rec.employeeName),
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F766E),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                rec.employeeName,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF0F172A),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${rec.employeeJobTitle} • ${rec.employeeId}',
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
                                  ),
                                ),

                                // Centro Costo
                                DataCell(
                                  SizedBox(
                                    width: colCostCenter,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          rec.serviceLineCode,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF334155),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Fecha Ingreso
                                DataCell(
                                  SizedBox(
                                    width: colHireDate,
                                    child: Text(
                                      dateFormat.format(rec.hireDate),
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                ),

                                // Antigüedad
                                DataCell(
                                  SizedBox(
                                    width: colSeniority,
                                    child: Text(
                                      '${rec.yearsOfService} años',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                ),

                                // Días de Ley
                                DataCell(
                                  SizedBox(
                                    width: colLegalDays,
                                    child: Text(
                                      '${rec.legalDaysTotal} días',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                ),

                                // Días Consumidos
                                DataCell(
                                  SizedBox(
                                    width: colUsedDays,
                                    child: Text(
                                      '${rec.daysUsed} días',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),

                                // Saldo Disponible (Chip Esmeralda Cápsula)
                                DataCell(
                                  SizedBox(
                                    width: colBalance,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${rec.daysRemaining} días libres',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF047857),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Programación Vigente
                                DataCell(
                                  SizedBox(
                                    width: colSchedule,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: hasSchedule
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEFF6FF),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                rec.currentRequest!,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF1E40AF),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Text(
                                              'Sin Programar',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: const Color(0xFF94A3B8),
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                // Acciones
                                DataCell(
                                  SizedBox(
                                    width: colActions,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            EliteScheduleVacationDialog.show(context, rec),
                                        icon: const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Programar',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0D9488),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 0,
                                          ),
                                          minimumSize: const Size(0, 28),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
