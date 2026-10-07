import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_memorandum_detail_dialog.dart';

/// Tab 1: Memorándums y Sanciones Disciplinarias con tabla Full-Width.
class EliteMemorandumsTab extends ConsumerStatefulWidget {
  const EliteMemorandumsTab({super.key});

  @override
  ConsumerState<EliteMemorandumsTab> createState() =>
      _EliteMemorandumsTabState();
}

class _EliteMemorandumsTabState extends ConsumerState<EliteMemorandumsTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(rrhhFilteredDisciplinaryProvider);
    final selectedSeverity = ref.watch(disciplinarySeverityFilterProvider);

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
                            .read(disciplinarySearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar por colaborador, código memo o infracción...',
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
                                      .read(disciplinarySearchQueryProvider
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

                // Selector: Gravedad de Falta
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
                      child: DropdownButton<DisciplinarySeverity?>(
                        value: selectedSeverity,
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
                                  disciplinarySeverityFilterProvider.notifier)
                              .setFilter(val);
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Gravedad: Todas'),
                          ),
                          ...DisciplinarySeverity.values.map((sev) {
                            return DropdownMenuItem(
                              value: sev,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: sev.badgeColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    sev.label,
                                    style: TextStyle(
                                      color: sev.badgeColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
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
                if (selectedSeverity != null ||
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
                          .read(disciplinarySearchQueryProvider.notifier)
                          .setQuery('');
                      ref
                          .read(disciplinarySeverityFilterProvider.notifier)
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
                child: records.isEmpty
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
                              'No se encontraron memorándums con los filtros seleccionados',
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
                          final tableWidth = constraints.maxWidth < 980
                              ? 980.0
                              : constraints.maxWidth;
                          const horizMargin = 12.0;
                          final netColumnsWidth = tableWidth - (horizMargin * 2);

                          // Reparto proporcional al 100%
                          final colCode = netColumnsWidth * 0.11;
                          final colDate = netColumnsWidth * 0.08;
                          final colEmployee = netColumnsWidth * 0.19;
                          final colCostCenter = netColumnsWidth * 0.11;
                          final colSeverity = netColumnsWidth * 0.10;
                          final colInfraction = netColumnsWidth * 0.18;
                          final colSanction = netColumnsWidth * 0.15;
                          final colActions = netColumnsWidth * 0.08;

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
                                        width: colCode,
                                        child: Text(
                                          'CÓDIGO MEMO',
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
                                        width: colDate,
                                        child: Text(
                                          'FECHA',
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
                                        width: colCostCenter,
                                        child: Text(
                                          'C. COSTO / TIPO',
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
                                        width: colSeverity,
                                        child: Text(
                                          'GRAVEDAD',
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
                                        width: colInfraction,
                                        child: Text(
                                          'INFRACCIÓN',
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
                                        width: colSanction,
                                        child: Text(
                                          'SANCIÓN APLICADA',
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
                                  rows: records.map((item) {
                                    final dateStr =
                                        '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}';

                                    return DataRow(
                                      cells: [
                                        // Código Memo
                                        DataCell(
                                          SizedBox(
                                            width: colCode,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFFE2E8F0)),
                                              ),
                                              child: Text(
                                                item.memorandumCode,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF334155),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Fecha
                                        DataCell(
                                          SizedBox(
                                            width: colDate,
                                            child: Text(
                                              dateStr,
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11.5,
                                                color: const Color(0xFF475569),
                                              ),
                                            ),
                                          ),
                                        ),

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
                                                  item.employeeId,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.5,
                                                    color:
                                                        const Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // C. Costo / Tipo
                                        DataCell(
                                          SizedBox(
                                            width: colCostCenter,
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFF1F5F9),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFE2E8F0)),
                                                  ),
                                                  child: Text(
                                                    item.serviceLineCode,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF334155),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  item.workplaceType.label,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Gravedad (Chip amarillo, naranja o rojo)
                                        DataCell(
                                          SizedBox(
                                            width: colSeverity,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 2.5),
                                                decoration: BoxDecoration(
                                                  color:
                                                      item.severity.badgeBgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: item
                                                        .severity.badgeBorderColor,
                                                  ),
                                                ),
                                                child: Text(
                                                  item.severity.label,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        item.severity.badgeColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Infracción
                                        DataCell(
                                          SizedBox(
                                            width: colInfraction,
                                            child: Text(
                                              item.infractionType,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1E293B),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        // Sanción
                                        DataCell(
                                          SizedBox(
                                            width: colSanction,
                                            child: Text(
                                              item.sanction,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: const Color(0xFF475569),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        // Acción (Ver Memo)
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
                                                        EliteMemorandumDetailDialog(
                                                      record: item,
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
                                                  'Ver Memo',
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
