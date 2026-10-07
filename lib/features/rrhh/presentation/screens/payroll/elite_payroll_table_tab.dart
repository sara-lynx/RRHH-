import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 1: Pre-Planilla Mensual con cálculo de Ley Boliviana y tabla Full-Width en Tarjeta Corporativa.
class ElitePayrollTableTab extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToPaySlip;

  const ElitePayrollTableTab({
    super.key,
    required this.onNavigateToPaySlip,
  });

  @override
  ConsumerState<ElitePayrollTableTab> createState() =>
      _ElitePayrollTableTabState();
}

class _ElitePayrollTableTabState extends ConsumerState<ElitePayrollTableTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPayroll = ref.watch(rrhhFilteredPayrollProvider);
    final workplaceFilter = ref.watch(payrollWorkplaceTypeFilterProvider);
    final costCenterFilter = ref.watch(payrollCostCenterFilterProvider);

    // Sumatorias totales de la tabla
    final totalBase = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.baseSalary,
    );
    final totalSeniority = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.seniorityBonus,
    );
    final totalGross = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.totalEarned,
    );
    final totalPenalties = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.penaltyDeductions,
    );
    final totalGestora = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.gestoraDeduction,
    );
    final totalDeductions = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.totalDeductions,
    );
    final totalNet = filteredPayroll.fold<double>(
      0.0,
      (sum, p) => sum + p.netPayable,
    );

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // =====================================================================
          // BARRA DE FILTROS SUPERIOR COMPACTA (~46px)
          // =====================================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                // Buscador de texto
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 32,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        ref
                            .read(payrollSearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar colaborador, CI, cargo o ID...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(payrollSearchQueryProvider.notifier)
                                      .setQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D9488),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Selector: Tipo (Todos, Oficina, Campo)
                SizedBox(
                  height: 32,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<EmployeeWorkplaceType?>(
                        value: workplaceFilter,
                        icon: const Icon(
                          Icons.filter_list,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155),
                        ),
                        onChanged: (val) {
                          ref
                              .read(
                                  payrollWorkplaceTypeFilterProvider.notifier)
                              .setFilter(val);
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Tipo: Todos'),
                          ),
                          DropdownMenuItem(
                            value: EmployeeWorkplaceType.oficina,
                            child: Text(
                              'Oficina',
                              style: TextStyle(
                                color: EmployeeWorkplaceType.oficina.badgeColor,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: EmployeeWorkplaceType.campo,
                            child: Text(
                              'Campo',
                              style: TextStyle(
                                color: EmployeeWorkplaceType.campo.badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Selector: Centro de Costo
                SizedBox(
                  height: 32,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: costCenterFilter,
                        icon: const Icon(
                          Icons.business_outlined,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155),
                        ),
                        onChanged: (val) {
                          ref
                              .read(payrollCostCenterFilterProvider.notifier)
                              .setFilter(val);
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Centro: Todos'),
                          ),
                          ...EliteCostCenter.all.map((cc) {
                            return DropdownMenuItem(
                              value: cc,
                              child: Text(cc),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Selector Mes de Nómina
                Container(
                  height: 32,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF99F6E4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: Color(0xFF0D9488),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Octubre 2026',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F766E),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Limpiar filtros
                if (workplaceFilter != null ||
                    costCenterFilter != null ||
                    _searchController.text.isNotEmpty)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 30),
                    ),
                    icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                    label: Text(
                      'Limpiar filtros',
                      style: GoogleFonts.inter(fontSize: 11),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref
                          .read(payrollSearchQueryProvider.notifier)
                          .setQuery('');
                      ref
                          .read(payrollWorkplaceTypeFilterProvider.notifier)
                          .setFilter(null);
                      ref
                          .read(payrollCostCenterFilterProvider.notifier)
                          .setFilter(null);
                    },
                  ),
              ],
            ),
          ),

          // =====================================================================
          // TABLA DE PRE-PLANILLA FULL-WIDTH EN TARJETA CORPORATIVA (EXPANDED)
          // =====================================================================
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
                child: filteredPayroll.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 38,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No hay registros salariales que coincidan con los filtros',
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
                          final tableWidth = constraints.maxWidth < 1280
                              ? 1280.0
                              : constraints.maxWidth;
                          const horizMargin = 16.0;
                          const colSpacing = 12.0;
                          final netColumnsWidth = tableWidth - (horizMargin * 2) - (colSpacing * 9);

                          // Reparto proporcional al 100% exacto
                          final colWorker = netColumnsWidth * 0.18;
                          final colPosition = netColumnsWidth * 0.13;
                          final colBase = netColumnsWidth * 0.08;
                          final colSeniority = netColumnsWidth * 0.08;
                          final colGross = netColumnsWidth * 0.09;
                          final colPenalties = netColumnsWidth * 0.09;
                          final colGestora = netColumnsWidth * 0.09;
                          final colTotalDesc = netColumnsWidth * 0.09;
                          final colNet = netColumnsWidth * 0.10;
                          final colActions = netColumnsWidth * 0.07;

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
                                  columnSpacing: colSpacing,
                                  border: const TableBorder(
                                    horizontalInside: BorderSide(
                                      color: Color(0xFFF1F5F9),
                                      width: 1.0,
                                    ),
                                  ),
                                  headingRowColor: const WidgetStatePropertyAll(
                                    Color(0xFFF8FAFC),
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
                                          'CARGO / LÍNEA',
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
                                        width: colBase,
                                        child: Text(
                                          'BÁSICO (BS)',
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
                                          'BONO ANTIG. (BS)',
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
                                        width: colGross,
                                        child: Text(
                                          'TOTAL GANADO (BS)',
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
                                        width: colPenalties,
                                        child: Text(
                                          'MULTAS / ASIST. (BS)',
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
                                        width: colGestora,
                                        child: Text(
                                          'GESTORA 12.71% (BS)',
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
                                        width: colTotalDesc,
                                        child: Text(
                                          'TOTAL DESC. (BS)',
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
                                        width: colNet,
                                        child: Text(
                                          'LÍQUIDO PAGABLE (BS)',
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
                                          'ACCIÓN',
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
                                  rows: filteredPayroll.map((item) {
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
                                                    _getInitials(item.employeeName),
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
                                                        item.employeeName,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12.5,
                                                          fontWeight: FontWeight.w700,
                                                          color: const Color(0xFF0F172A),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        '${item.ci} • ${item.serviceLineCode}',
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

                                        // Cargo / Línea
                                        DataCell(
                                          SizedBox(
                                            width: colPosition,
                                            child: Text(
                                              item.position,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: const Color(0xFF334155),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        // Básico (Bs)
                                        DataCell(
                                          SizedBox(
                                            width: colBase,
                                            child: Text(
                                              item.baseSalary.toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                color: const Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Bono Antigüedad (Bs)
                                        DataCell(
                                          SizedBox(
                                            width: colSeniority,
                                            child: Text(
                                              item.seniorityBonus.toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                color: const Color(0xFF0D9488),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Total Ganado (Bs)
                                        DataCell(
                                          SizedBox(
                                            width: colGross,
                                            child: Text(
                                              item.totalEarned.toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Multas / Asistencia
                                        DataCell(
                                          SizedBox(
                                            width: colPenalties,
                                            child: Text(
                                              item.penaltyDeductions.toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                fontWeight: item.penaltyDeductions > 0
                                                    ? FontWeight.w700
                                                    : FontWeight.normal,
                                                color: item.penaltyDeductions > 0
                                                    ? const Color(0xFFDC2626)
                                                    : const Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Gestora 12.71%
                                        DataCell(
                                          SizedBox(
                                            width: colGestora,
                                            child: Text(
                                              item.gestoraDeduction.toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                color: const Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Total Descuentos
                                        DataCell(
                                          SizedBox(
                                            width: colTotalDesc,
                                            child: Text(
                                              item.totalDeductions.toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFFB91C1C),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Líquido Pagable (Cápsula esmeralda)
                                        DataCell(
                                          SizedBox(
                                            width: colNet,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3.5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFECFDF5),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'Bs. ${item.netPayable.toStringAsFixed(2)}',
                                                  style: GoogleFonts.jetBrainsMono(
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(0xFF047857),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Acción (Ver Boleta en Cápsula)
                                        DataCell(
                                          SizedBox(
                                            width: colActions,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          selectedPaySlipEmployeeIdProvider
                                                              .notifier)
                                                      .selectEmployee(
                                                          item.employeeId);
                                                  widget.onNavigateToPaySlip();
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Color(0xFFE2E8F0),
                                                  ),
                                                  backgroundColor: Colors.white,
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
                                                child: Text(
                                                  'Boleta',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFF64748B),
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

          // =====================================================================
          // BARRA FIJA AL PIE CON TOTALES CONSOLIDADOS (~40px)
          // =====================================================================
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'TOTALES (${filteredPayroll.length} reg):',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Básico: Bs. ${totalBase.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      color: const Color(0xFF334155),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Antigüedad: Bs. ${totalSeniority.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      color: const Color(0xFF0D9488),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ganado: Bs. ${totalGross.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Multas: Bs. ${totalPenalties.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Gestora: Bs. ${totalGestora.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total Desc.: Bs. ${totalDeductions.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB91C1C),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'LÍQUIDO A PAGAR:',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xFF99F6E4)),
                    ),
                    child: Text(
                      'Bs. ${totalNet.toStringAsFixed(2)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F766E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
