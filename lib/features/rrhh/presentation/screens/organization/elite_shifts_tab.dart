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

        // Tabla en Expanded (dentro de Tarjeta Corporativa)
        Expanded(
          child: Padding(
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
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowHeight: 46.0,
                    dataRowMinHeight: 52.0,
                    dataRowMaxHeight: 56.0,
                    horizontalMargin: 16,
                    columnSpacing: 16,
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
                                  size: 15,
                                  color: const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  shift.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tipo Alcance (Píldora cápsula suave)
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: shift.workplaceType == ShiftWorkplaceType.campo
                                    ? const Color(0xFFF0FDFA)
                                    : const Color(0xFFF0F9FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                shift.workplaceType.label,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: shift.workplaceType == ShiftWorkplaceType.campo
                                      ? const Color(0xFF0F766E)
                                      : const Color(0xFF0369A1),
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
                                    fontSize: 12,
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

                          // Tolerancia (Píldora cápsula suave)
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${shift.gracePeriodMinutes} min gracia',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
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

                          // Estado (Píldora cápsula suave)
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Vigente',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF047857),
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
        ),
      ],
    );
  }

  DataColumn _buildColumnHeader(String label, double width) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF64748B),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
