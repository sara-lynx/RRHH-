import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_shift_form_dialog.dart';

/// Tab 1: Catálogo de Turnos y Horarios.
/// Tabla de alta densidad visual (80% del espacio útil mediante Expanded).
class EliteShiftsTab extends ConsumerWidget {
  const EliteShiftsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(rrhhShiftsProvider);

    return Column(
      children: [
        // Barra superior compacta con botón Nuevo Turno
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.alarm_outlined,
                size: 16,
                color: Color(0xFF0D9488),
              ),
              const SizedBox(width: 8),
              Text(
                'Catálogo Oficial de Turnos y Tolerancias de Ingreso',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => EliteShiftFormDialog.show(context),
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: Text(
                  'Nuevo Turno',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(0, 30),
                ),
              ),
            ],
          ),
        ),

        // Tabla en Expanded (80% del espacio)
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 38,
                  dataRowMaxHeight: 46,
                  horizontalMargin: 16,
                  columnSpacing: 16,
                  headingRowColor: const WidgetStatePropertyAll(
                    Color(0xFFF8FAFC),
                  ),
                  dividerThickness: 1,
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: Color(0xFFF1F5F9),
                      width: 1,
                    ),
                  ),
                  columns: [
                    _buildColumnHeader('CÓDIGO', 120),
                    _buildColumnHeader('NOMBRE DEL TURNO', 220),
                    _buildColumnHeader('TIPO ALCANCE', 120),
                    _buildColumnHeader('HORARIO PROGRAMADO', 160),
                    _buildColumnHeader('TOLERANCIA', 120),
                    _buildColumnHeader('COBERTURA SEMANAL', 180),
                    _buildColumnHeader('ESTADO', 100),
                  ],
                  rows: shifts.map((shift) {
                    return DataRow(
                      cells: [
                        // Código
                        DataCell(
                          Text(
                            shift.code,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),

                        // Nombre
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                shift.workplaceType == ShiftWorkplaceType.oficina
                                    ? Icons.apartment_outlined
                                    : Icons.access_time_outlined,
                                size: 14,
                                color: const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                shift.name,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tipo Alcance
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: shift.workplaceType.badgeBgColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: shift.workplaceType.badgeBorderColor,
                              ),
                            ),
                            child: Text(
                              shift.workplaceType.label,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: shift.workplaceType.badgeColor,
                              ),
                            ),
                          ),
                        ),

                        // Horario Programado
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                shift.formattedSchedule,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              if (shift.crossesMidnight) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.nights_stay_outlined,
                                  size: 13,
                                  color: Color(0xFF6366F1),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Tolerancia
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 11,
                                  color: Color(0xFF475569),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${shift.gracePeriodMinutes} min gracia',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Cobertura Semanal
                        DataCell(
                          Text(
                            shift.activeDays,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ),

                        // Estado
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFDCFCE7)),
                            ),
                            child: Text(
                              'Vigente',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF16A34A),
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
          ),
        ),
      ],
    );
  }

  DataColumn _buildColumnHeader(String label, double width) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF475569),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
