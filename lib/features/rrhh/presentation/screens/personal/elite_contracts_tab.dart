import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 2: Contratos y Legajos Documentales.
/// Control de vigencias contractuales y checklist legal boliviano.
class EliteContractsTab extends ConsumerWidget {
  const EliteContractsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(rrhhFilteredEmployeesProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      color: Colors.white,
      child: employees.isEmpty
          ? Center(
              child: Text(
                'No hay colaboradores registrados para los filtros seleccionados.',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFF64748B),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = constraints.maxWidth < 980
                    ? 980.0
                    : constraints.maxWidth;
                const horizMargin = 12.0;
                final netColumnsWidth = tableWidth - (horizMargin * 2);

                final colEmp = netColumnsWidth * 0.22;
                final colTypeCc = netColumnsWidth * 0.12;
                final colModalidad = netColumnsWidth * 0.14;
                final colHire = netColumnsWidth * 0.11;
                final colExpiry = netColumnsWidth * 0.16;
                final colSalary = netColumnsWidth * 0.11;
                final colLegajo = netColumnsWidth * 0.14;

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
                          _buildColumnHeader('COLABORADOR', colEmp),
                          _buildColumnHeader('TIPO Y CC', colTypeCc),
                          _buildColumnHeader('MODALIDAD CONTRATO', colModalidad),
                          _buildColumnHeader('FECHA INGRESO', colHire),
                          _buildColumnHeader('VENCIMIENTO / ALERTA', colExpiry),
                          _buildColumnHeader('SALARIO BASE', colSalary),
                          _buildColumnHeader('ESTADO LEGAJO LEGAL', colLegajo),
                        ],
                        rows: employees.map((emp) {
                          final isNearExpiry = emp.isContractNearExpiry;
                          final isExpired = emp.isContractExpired;
                          final hasEndDate = emp.contractEndDate != null;

                          return DataRow(
                            cells: [
                              // 1. Colaborador
                              DataCell(
                                SizedBox(
                                  width: colEmp,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        emp.fullName,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${emp.ci} • ${emp.position}',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          color: const Color(0xFF64748B),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // 2. Tipo y CC
                              DataCell(
                                SizedBox(
                                  width: colTypeCc,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: emp.workplaceType.badgeBgColor,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: emp.workplaceType
                                                  .badgeBorderColor,
                                            ),
                                          ),
                                          child: Text(
                                            emp.workplaceType.label,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: emp.workplaceType.badgeColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            emp.serviceLineCode,
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF475569),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 3. Modalidad Contrato
                              DataCell(
                                SizedBox(
                                  width: colModalidad,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      emp.contractType.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF1E293B),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),

                              // 4. Fecha Ingreso
                              DataCell(
                                SizedBox(
                                  width: colHire,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      dateFormat.format(emp.hireDate),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // 5. Vencimiento / Alerta (Semáforo)
                              DataCell(
                                SizedBox(
                                  width: colExpiry,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _buildExpiryBadge(
                                      emp,
                                      dateFormat,
                                      isNearExpiry,
                                      isExpired,
                                      hasEndDate,
                                    ),
                                  ),
                                ),
                              ),

                              // 6. Salario Base
                              DataCell(
                                SizedBox(
                                  width: colSalary,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Bs ${emp.baseSalary.toStringAsFixed(2)}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // 7. Estado Legajo Legal (Checklist)
                              DataCell(
                                SizedBox(
                                  width: colLegajo,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: emp.hasPendingLegalDocs
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEF2F2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFFECACA),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.pending_actions_outlined,
                                                  size: 12,
                                                  color: Color(0xFFDC2626),
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    'Docs Pendientes',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          const Color(0xFFDC2626),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF0FDF4),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFDCFCE7),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_outline,
                                                  size: 12,
                                                  color: Color(0xFF16A34A),
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    'Legajo Completo',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          const Color(0xFF16A34A),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
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
    );
  }

  Widget _buildExpiryBadge(
    EliteEmployee emp,
    DateFormat dateFormat,
    bool isNearExpiry,
    bool isExpired,
    bool hasEndDate,
  ) {
    if (emp.contractType == ContractType.indefinido) {
      return Text(
        'Vigente Indefinido',
        style: GoogleFonts.inter(
          fontSize: 11.5,
          color: const Color(0xFF16A34A),
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 12, color: Color(0xFFDC2626)),
            const SizedBox(width: 4),
            Text(
              'Venció ${dateFormat.format(emp.contractEndDate!)}',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      );
    } else if (isNearExpiry) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 12,
              color: Color(0xFFD97706),
            ),
            const SizedBox(width: 4),
            Text(
              'Vence ${dateFormat.format(emp.contractEndDate!)} (${emp.contractEndDate!.difference(DateTime.now()).inDays}d)',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB45309),
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(
        hasEndDate ? dateFormat.format(emp.contractEndDate!) : '-',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF334155),
        ),
      );
    }
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
