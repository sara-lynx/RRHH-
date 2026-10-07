import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 3: Cargos y Salarios Base de Referencia.
/// Mapeo de la estructura salarial corporativa y dotación activa.
class EliteSalaryScalesTab extends ConsumerWidget {
  const EliteSalaryScalesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scales = ref.watch(rrhhSalaryScalesProvider);
    final allEmployees = ref.watch(rrhhEmployeesProvider);

    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = constraints.maxWidth < 980
              ? 980.0
              : constraints.maxWidth;
          const horizMargin = 12.0;
          final netColumnsWidth = tableWidth - (horizMargin * 2);

          final colPosition = netColumnsWidth * 0.22;
          final colCostCenter = netColumnsWidth * 0.15;
          final colType = netColumnsWidth * 0.12;
          final colMin = netColumnsWidth * 0.13;
          final colMax = netColumnsWidth * 0.13;
          final colCount = netColumnsWidth * 0.11;
          final colRange = netColumnsWidth * 0.14;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowHeight: 44.0,
                  dataRowMinHeight: 48.0,
                  dataRowMaxHeight: 54.0,
                  horizontalMargin: horizMargin,
                  columnSpacing: 0,
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
                    _buildColumnHeader('CARGO / POSICIÓN', colPosition),
                    _buildColumnHeader('CENTRO DE COSTO', colCostCenter),
                    _buildColumnHeader('TIPO PERSONAL', colType),
                    _buildColumnHeader('SALARIO MÍNIMO REF.', colMin),
                    _buildColumnHeader('SALARIO MÁXIMO REF.', colMax),
                    _buildColumnHeader('DOTACIÓN ACTIVA', colCount),
                    _buildColumnHeader('RANGO SALARIAL', colRange),
                  ],
                  rows: scales.map((scale) {
                    // Conteo dinámico de empleados reales en ese cargo
                    final currentCount = allEmployees
                        .where((e) =>
                            e.position.toLowerCase() ==
                            scale.position.toLowerCase())
                        .length;

                    return DataRow(
                      cells: [
                        // 1. Cargo
                        DataCell(
                          SizedBox(
                            width: colPosition,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.badge_outlined,
                                  size: 15,
                                  color: Color(0xFF0D9488),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    scale.position,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 2. Centro de Costo
                        DataCell(
                          SizedBox(
                            width: colCostCenter,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                EliteCostCenter.getLabel(scale.serviceLineCode),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF334155),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),

                        // 3. Tipo Personal
                        DataCell(
                          SizedBox(
                            width: colType,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: scale.workplaceType.badgeBgColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: scale.workplaceType.badgeBorderColor,
                                  ),
                                ),
                                child: Text(
                                  scale.workplaceType.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: scale.workplaceType.badgeColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 4. Mínimo
                        DataCell(
                          SizedBox(
                            width: colMin,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Bs ${scale.minSalary.toStringAsFixed(2)}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 5. Máximo
                        DataCell(
                          SizedBox(
                            width: colMax,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Bs ${scale.maxSalary.toStringAsFixed(2)}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 6. Dotación Activa (Badge)
                        DataCell(
                          SizedBox(
                            width: colCount,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDFA),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: const Color(0xFFCCFBF1)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.people_outline,
                                      size: 12,
                                      color: Color(0xFF0D9488),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '$currentCount colaborador${currentCount != 1 ? 'es' : ''}',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0D9488),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 7. Rango Salarial (Barra de progreso visual)
                        DataCell(
                          SizedBox(
                            width: colRange,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: scale.minSalary / scale.maxSalary,
                                    minHeight: 5,
                                    backgroundColor: const Color(0xFFE2E8F0),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF0D9488),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Spread: Bs ${(scale.maxSalary - scale.minSalary).toStringAsFixed(0)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
    );
  }

  DataColumn _buildColumnHeader(String label, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF475569),
            letterSpacing: 0.3,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
