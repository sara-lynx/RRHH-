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
      color: const Color(0xFFF8FAFC),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tableWidth = constraints.maxWidth < 1100
                ? 1100.0
                : constraints.maxWidth;
            const horizMargin = 16.0;
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
                    headingRowHeight: 46.0,
                    dataRowMinHeight: 52.0,
                    dataRowMaxHeight: 56.0,
                    horizontalMargin: horizMargin,
                    columnSpacing: 0,
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
                      _buildColumnHeader('CARGO / POSICIÓN', colPosition),
                      _buildColumnHeader('CENTRO DE COSTO', colCostCenter),
                      _buildColumnHeader('TIPO PERSONAL', colType),
                      _buildColumnHeader('SALARIO MÍNIMO REF.', colMin),
                      _buildColumnHeader('SALARIO MÁXIMO REF.', colMax),
                      _buildColumnHeader('DOTACIÓN ACTIVA', colCount),
                      _buildColumnHeader('RANGO SALARIAL', colRange),
                    ],
                    rows: scales.map((scale) {
                      final currentCount = allEmployees
                          .where((e) =>
                              e.position.toLowerCase() ==
                              scale.position.toLowerCase())
                          .length;

                      final isField = scale.workplaceType == EmployeeWorkplaceType.campo;

                      return DataRow(
                        cells: [
                          // 1. Cargo
                          DataCell(
                            SizedBox(
                              width: colPosition,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isField
                                          ? const Color(0xFFCCFBF1)
                                          : const Color(0xFFE0F2FE),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.badge_outlined,
                                      size: 14,
                                      color: isField
                                          ? const Color(0xFF0F766E)
                                          : const Color(0xFF0369A1),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      scale.position,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
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
                                    color: const Color(0xFF475569),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          // 3. Tipo Personal (Píldora cápsula suave)
                          DataCell(
                            SizedBox(
                              width: colType,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isField
                                        ? const Color(0xFFF0FDFA)
                                        : const Color(0xFFF0F9FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    scale.workplaceType.label,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isField
                                          ? const Color(0xFF0F766E)
                                          : const Color(0xFF0369A1),
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
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF475569),
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
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 6. Dotación Activa (Píldora cápsula suave)
                          DataCell(
                            SizedBox(
                              width: colCount,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDFA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.people_outline,
                                        size: 13,
                                        color: Color(0xFF0D9488),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          '$currentCount colaborador${currentCount != 1 ? 'es' : ''}',
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F766E),
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

                          // 7. Rango Salarial (Barra suave)
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
                                      backgroundColor: const Color(0xFFF1F5F9),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color(0xFF0D9488),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Spread: Bs ${(scale.maxSalary - scale.minSalary).toStringAsFixed(0)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
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
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
            letterSpacing: 0.6,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
