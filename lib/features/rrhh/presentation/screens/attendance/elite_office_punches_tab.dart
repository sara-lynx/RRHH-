import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 2: Marcaciones de Oficina en tiempo real (Full-Width Responsivo en Tarjeta Corporativa).
class EliteOfficePunchesTab extends ConsumerWidget {
  const EliteOfficePunchesTab({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x040F172A),
              blurRadius: 4,
              offset: Offset(0, 1),
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
                  final tableWidth = constraints.maxWidth < 1100
                      ? 1100.0
                      : constraints.maxWidth;

                  const horizMargin = 16.0;
                  final netColumnsWidth = tableWidth - (horizMargin * 2);

                  // Distribuir el 100% exacto de las columnas útiles
                  final colWorker = netColumnsWidth * 0.22;
                  final colPosition = netColumnsWidth * 0.17;
                  final colEntry = netColumnsWidth * 0.09;
                  final colExit = netColumnsWidth * 0.09;
                  final colIp = netColumnsWidth * 0.12;
                  final colBrowser = netColumnsWidth * 0.13;
                  final colTolerance = netColumnsWidth * 0.08;
                  final colEvaluation = netColumnsWidth * 0.10;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowHeight: 46.0,
                            dataRowMinHeight: 52.0,
                            dataRowMaxHeight: 56.0,
                            horizontalMargin: horizMargin,
                            columnSpacing: 0,
                            border: const TableBorder(
                              horizontalInside: BorderSide(
                                color: Color(0xFFF1F5F9),
                                width: 1.0,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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
                                      color: const Color(0xFF64748B),
                                      letterSpacing: 0.6,
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

                              return DataRow(
                                cells: [
                                  // Colaborador con Avatar Circular
                                  DataCell(
                                    SizedBox(
                                      width: colWorker,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE0F2FE),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              _getInitials(rec.employeeName),
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF0369A1),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11,
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
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF0F172A),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 1),
                                                Text(
                                                  '${rec.employeeId} • ${rec.serviceLineCode}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.5,
                                                    color: const Color(0xFF64748B),
                                                    fontWeight: FontWeight.w500,
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

                                  // Dirección IP (Cápsula sutil)
                                  DataCell(
                                    SizedBox(
                                      width: colIp,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            cleanIp,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF475569),
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
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius: BorderRadius.circular(20),
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

                                  // Evaluación (Cápsula pastel)
                                  DataCell(
                                    SizedBox(
                                      width: colEvaluation,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Builder(
                                          builder: (context) {
                                            Color bg;
                                            Color fg;
                                            IconData icon;

                                            if (rec.evaluation == AttendanceEvaluation.puntual) {
                                              bg = const Color(0xFFECFDF5);
                                              fg = const Color(0xFF047857);
                                              icon = Icons.check_circle_outline;
                                            } else if (rec.evaluation == AttendanceEvaluation.retraso) {
                                              bg = const Color(0xFFFFFBEB);
                                              fg = const Color(0xFFB45309);
                                              icon = Icons.warning_amber_outlined;
                                            } else if (rec.evaluation == AttendanceEvaluation.faltaInjustificada) {
                                              bg = const Color(0xFFFEF2F2);
                                              fg = const Color(0xFFB91C1C);
                                              icon = Icons.cancel_outlined;
                                            } else {
                                              bg = const Color(0xFFF1F5F9);
                                              fg = const Color(0xFF475569);
                                              icon = Icons.timelapse;
                                            }

                                            return Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 9,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: bg,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(icon, size: 12, color: fg),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    rec.evaluation.label,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: fg,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
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
