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

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(rrhhFilteredEmployeesProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

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
                  final tableWidth = constraints.maxWidth < 1100
                      ? 1100.0
                      : constraints.maxWidth;
                  const horizMargin = 16.0;
                  final netColumnsWidth = tableWidth - (horizMargin * 2);

                  final colEmp = netColumnsWidth * 0.23;
                  final colTypeCc = netColumnsWidth * 0.12;
                  final colModalidad = netColumnsWidth * 0.14;
                  final colHire = netColumnsWidth * 0.10;
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
                            final isField = emp.workplaceType == EmployeeWorkplaceType.campo;

                            return DataRow(
                              cells: [
                                // 1. Colaborador con Avatar Circular
                                DataCell(
                                  SizedBox(
                                    width: colEmp,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: isField
                                                ? const Color(0xFFCCFBF1)
                                                : const Color(0xFFE0F2FE),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            _getInitials(emp.fullName),
                                            style: GoogleFonts.inter(
                                              color: isField
                                                  ? const Color(0xFF0F766E)
                                                  : const Color(0xFF0369A1),
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
                                                emp.fullName,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF0F172A),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 1),
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
                                              emp.workplaceType.label,
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: isField
                                                    ? const Color(0xFF0F766E)
                                                    : const Color(0xFF0369A1),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 7,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                emp.serviceLineCode,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF475569),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
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

                                // 5. Vencimiento / Alerta (Semáforo Píldora)
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

                                // 7. Estado Legajo Legal (Píldora cápsula pastel)
                                DataCell(
                                  SizedBox(
                                    width: colLegajo,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: emp.hasPendingLegalDocs
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 9,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFEF2F2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.pending_actions_outlined,
                                                    size: 13,
                                                    color: Color(0xFFB91C1C),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      'Docs Pendientes',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.5,
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFFB91C1C),
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
                                                horizontal: 9,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFECFDF5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle_outline,
                                                    size: 13,
                                                    color: Color(0xFF047857),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      'Legajo Completo',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.5,
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFF047857),
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
      ),
    );
  }

  Widget _buildExpiryBadge(
    EliteEmployee emp,
    DateFormat dateFormat,
    bool isNearExpiry,
    bool isExpired,
    hasEndDate,
  ) {
    if (emp.contractType == ContractType.indefinido) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Vigente Indefinido',
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: const Color(0xFF047857),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else if (isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 13, color: Color(0xFFB91C1C)),
            const SizedBox(width: 4),
            Text(
              'Venció ${dateFormat.format(emp.contractEndDate!)}',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFB91C1C),
              ),
            ),
          ],
        ),
      );
    } else if (isNearExpiry) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 13,
              color: Color(0xFFB45309),
            ),
            const SizedBox(width: 4),
            Text(
              'Vence ${dateFormat.format(emp.contractEndDate!)} (${emp.contractEndDate!.difference(DateTime.now()).inDays}d)',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
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
