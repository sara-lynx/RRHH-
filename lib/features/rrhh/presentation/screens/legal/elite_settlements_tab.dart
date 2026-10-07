import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_settlement_detail_dialog.dart';

/// Tab 2: Finiquitos y Liquidaciones Laborales según la Ley General del Trabajo.
class EliteSettlementsTab extends ConsumerStatefulWidget {
  const EliteSettlementsTab({super.key});

  @override
  ConsumerState<EliteSettlementsTab> createState() =>
      _EliteSettlementsTabState();
}

class _EliteSettlementsTabState extends ConsumerState<EliteSettlementsTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settlements = ref.watch(rrhhFilteredSettlementsProvider);
    final selectedReason = ref.watch(settlementsReasonFilterProvider);

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // ===================================================================
          // BARRA DE FILTROS SUPERIOR COMPACTA (~46px)
          // ===================================================================
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
                            .read(settlementsSearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar colaborador, CI o cargo...',
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
                                      .read(settlementsSearchQueryProvider
                                          .notifier)
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

                // Selector: Motivo de Retiro
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
                      child: DropdownButton<TerminationReason?>(
                        value: selectedReason,
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
                                  settlementsReasonFilterProvider.notifier)
                              .setFilter(val);
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Motivo: Todos'),
                          ),
                          ...TerminationReason.values.map((reason) {
                            return DropdownMenuItem(
                              value: reason,
                              child: Text(
                                reason.label,
                                style: TextStyle(
                                  color: reason.badgeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Limpiar filtros
                if (selectedReason != null || _searchController.text.isNotEmpty)
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
                          .read(settlementsSearchQueryProvider.notifier)
                          .setQuery('');
                      ref
                          .read(settlementsReasonFilterProvider.notifier)
                          .setFilter(null);
                    },
                  ),
              ],
            ),
          ),

          // ===================================================================
          // TABLA FULL-WIDTH EN TARJETA CORPORATIVA (EXPANDED)
          // ===================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                child: settlements.isEmpty
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
                              'No se encontraron finiquitos con los filtros seleccionados',
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

                          // Reparto proporcional al 100%
                          final colEmployee = netColumnsWidth * 0.17;
                          final colReason = netColumnsWidth * 0.13;
                          final colSeniority = netColumnsWidth * 0.09;
                          final colIndemnity = netColumnsWidth * 0.10;
                          final colSeverance = netColumnsWidth * 0.09;
                          final colBonus = netColumnsWidth * 0.09;
                          final colVacations = netColumnsWidth * 0.09;
                          final colTotal = netColumnsWidth * 0.13;
                          final colActions = netColumnsWidth * 0.11;

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
                                  horizontalMargin: horizMargin,
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
                                        width: colEmployee,
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
                                        width: colReason,
                                        child: Text(
                                          'MOTIVO RETIRO',
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
                                        width: colSeniority,
                                        child: Text(
                                          'ANTIGÜEDAD',
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
                                        width: colIndemnity,
                                        child: Text(
                                          'INDEMNIZACIÓN (BS)',
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
                                        width: colSeverance,
                                        child: Text(
                                          'DESAHUCIO (BS)',
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
                                        width: colBonus,
                                        child: Text(
                                          'AGUINALDO (BS)',
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
                                        width: colVacations,
                                        child: Text(
                                          'VACACIONES (BS)',
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
                                        width: colTotal,
                                        child: Text(
                                          'TOTAL FINIQUITO (BS)',
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
                                        width: colActions,
                                        child: Text(
                                          'ACCIÓN',
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
                                  rows: settlements.map((item) {
                                    return DataRow(
                                      cells: [
                                        // Colaborador
                                        DataCell(
                                          SizedBox(
                                            width: colEmployee,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.employeeName,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        const Color(0xFF0F172A),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '${item.ci} • ${item.position}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.5,
                                                    color:
                                                        const Color(0xFF64748B),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Motivo Retiro (Chip de color)
                                        DataCell(
                                          SizedBox(
                                            width: colReason,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 2.5),
                                                decoration: BoxDecoration(
                                                  color:
                                                      item.reason.badgeBgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: item
                                                        .reason.badgeBorderColor,
                                                  ),
                                                ),
                                                child: Text(
                                                  item.reason.label,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        item.reason.badgeColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Antigüedad
                                        DataCell(
                                          SizedBox(
                                            width: colSeniority,
                                            child: Text(
                                              '${item.yearsWorked}a ${item.monthsWorked}m ${item.daysWorked}d',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                color: const Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Indemnización
                                        DataCell(
                                          SizedBox(
                                            width: colIndemnity,
                                            child: Text(
                                              item.indemnityPay
                                                  .toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                color: const Color(0xFF334155),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Desahucio (0 si retiro voluntario)
                                        DataCell(
                                          SizedBox(
                                            width: colSeverance,
                                            child: Text(
                                              item.severancePay
                                                  .toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                color: item.severancePay > 0
                                                    ? const Color(0xFFDC2626)
                                                    : const Color(0xFF94A3B8),
                                                fontWeight: item.severancePay > 0
                                                    ? FontWeight.w700
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Aguinaldo Trunco
                                        DataCell(
                                          SizedBox(
                                            width: colBonus,
                                            child: Text(
                                              item.proportionalBonus
                                                  .toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                color: const Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Vacaciones Truncas
                                        DataCell(
                                          SizedBox(
                                            width: colVacations,
                                            child: Text(
                                              item.vacationPay
                                                  .toStringAsFixed(2),
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                color: const Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Total Finiquito en Bs (Negrita Esmeralda)
                                        DataCell(
                                          SizedBox(
                                            width: colTotal,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 7,
                                                  vertical: 2.5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF0FDFA),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: const Color(
                                                        0xFF99F6E4),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Bs. ${item.totalSettlement.toStringAsFixed(2)}',
                                                  style:
                                                      GoogleFonts.jetBrainsMono(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(
                                                        0xFF0F766E),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Acción (Ver Finiquito)
                                        DataCell(
                                          SizedBox(
                                            width: colActions,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        EliteSettlementDetailDialog(
                                                      settlement: item,
                                                    ),
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Color(0xFFCBD5E1),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 0,
                                                  ),
                                                  minimumSize:
                                                      const Size(0, 26),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Ver Finiquito',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xFF0F766E),
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
      ),
    );
  }
}
