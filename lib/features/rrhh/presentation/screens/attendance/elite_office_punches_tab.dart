import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 2: Marcaciones de Oficina en tiempo real (Full-Width Responsivo en Tarjeta Corporativa).
class EliteOfficePunchesTab extends ConsumerWidget {
  const EliteOfficePunchesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecords = ref.watch(rrhhAttendanceProvider);
    final officeRecords = allRecords
        .where((r) => r.workplaceType == EmployeeWorkplaceType.oficina)
        .toList();

    return Container(
      color: const Color(0xFFF8FAFC),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x040F172A),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: officeRecords.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.desktop_access_disabled_outlined,
                      size: 38,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No hay registros de marcación en oficina para hoy',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final tableWidth = constraints.maxWidth < 1000
                      ? 1000.0
                      : constraints.maxWidth;

                  const horizMargin = 12.0;
                  final netColumnsWidth = tableWidth - (horizMargin * 2);

                  // Distribuir el 100% exacto de las columnas útiles
                  final colWorker = netColumnsWidth * 0.22;
                  final colPosition = netColumnsWidth * 0.18;
                  final colEntry = netColumnsWidth * 0.08;
                  final colExit = netColumnsWidth * 0.08;
                  final colIp = netColumnsWidth * 0.12;
                  final colBrowser = netColumnsWidth * 0.14;
                  final colTolerance = netColumnsWidth * 0.08;
                  final colEvaluation = netColumnsWidth * 0.10;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowHeight: 44.0,
                            dataRowMinHeight: 48.0,
                            dataRowMaxHeight: 52.0,
                            horizontalMargin: 12,
                            columnSpacing: 0,
                            border: const TableBorder(
                              horizontalInside: BorderSide(
                                color: Color(0xFFF1F5F9),
                                width: 1,
                              ),
                            ),
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF8FAFC),
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
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colPosition,
                                  child: Text(
                                    'CARGO / PUESTO',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colEntry,
                                  child: Text(
                                    'ENTRADA',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colExit,
                                  child: Text(
                                    'SALIDA',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colIp,
                                  child: Text(
                                    'DIRECCIÓN IP',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colBrowser,
                                  child: Text(
                                    'NAVEGADOR / DISP.',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colTolerance,
                                  child: Text(
                                    'TOLERANCIA',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: colEvaluation,
                                  child: Text(
                                    'EVALUACIÓN',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: officeRecords.map((rec) {
                              final inStr = rec.evaluation ==
                                      AttendanceEvaluation.faltaInjustificada
                                  ? 'Sin Marcar'
                                  : DateFormat('HH:mm').format(rec.timestamp);

                              final outStr = rec.checkOutTimestamp != null
                                  ? DateFormat('HH:mm').format(rec.checkOutTimestamp!)
                                  : (rec.evaluation == AttendanceEvaluation.enJornada
                                      ? 'En Curso'
                                      : '--:--');

                              final cleanIp = rec.ipAddress?.split(' ').first ?? '192.168.1.45';
                              final workstation = rec.deviceBrowser?.contains('Estación') == true
                                  ? 'Estación Central RRHH'
                                  : 'Oficina Central';

                              return DataRow(
                                cells: [
                                  // Colaborador
                                  DataCell(
                                    SizedBox(
                                      width: colWorker,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rec.employeeName,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${rec.employeeId} • ${rec.serviceLineCode}',
                                            style: GoogleFonts.inter(
                                              fontSize: 10.5,
                                              color: const Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Cargo / Puesto
                                  DataCell(
                                    SizedBox(
                                      width: colPosition,
                                      child: Text(
                                        rec.employeeJobTitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: const Color(0xFF334155),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),

                                  // Entrada
                                  DataCell(
                                    SizedBox(
                                      width: colEntry,
                                      child: Text(
                                        inStr,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: rec.evaluation ==
                                                  AttendanceEvaluation.faltaInjustificada
                                              ? const Color(0xFFB91C1C)
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Salida
                                  DataCell(
                                    SizedBox(
                                      width: colExit,
                                      child: Text(
                                        outStr,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: rec.checkOutTimestamp != null
                                              ? const Color(0xFF0F766E)
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Dirección IP
                                  DataCell(
                                    SizedBox(
                                      width: colIp,
                                      child: Tooltip(
                                        message: '$cleanIp • $workstation',
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 2.5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFCBD5E1),
                                              ),
                                            ),
                                            child: Text(
                                              cleanIp,
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Navegador / Disp.
                                  DataCell(
                                    SizedBox(
                                      width: colBrowser,
                                      child: Text(
                                        'Edge 128 • Win64',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF64748B),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),

                                  // Tolerancia
                                  DataCell(
                                    SizedBox(
                                      width: colTolerance,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: const Color(0xFFE2E8F0),
                                            ),
                                          ),
                                          child: Text(
                                            '10 min',
                                            style: GoogleFonts.inter(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Evaluación
                                  DataCell(
                                    SizedBox(
                                      width: colEvaluation,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: rec.evaluation.badgeBgColor,
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color: rec.evaluation.badgeBorderColor,
                                            ),
                                          ),
                                          child: Text(
                                            rec.evaluation.label,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: rec.evaluation.badgeColor,
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
    );
  }
}
