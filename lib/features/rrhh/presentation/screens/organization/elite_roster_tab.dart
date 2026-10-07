import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_roster_assignment_dialog.dart';

/// Tab 3: Malla de Cuadrantes y Asignación de Puestos.
/// Programación operativa y control de rotación de colaboradores.
class EliteRosterTab extends ConsumerWidget {
  const EliteRosterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roster = ref.watch(rrhhFilteredRosterProvider);
    final sites = ref.watch(rrhhClientSitesProvider);
    final selectedSiteId = ref.watch(rosterSiteFilterProvider);
    final selectedCostCenter = ref.watch(rosterCostCenterFilterProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        // ---------------------------------------------------------------------
        // BARRA DE FILTROS COMPACTA (~40px)
        // ---------------------------------------------------------------------
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
              // Buscador compacto
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    onChanged: (val) =>
                        ref.read(rosterSearchQueryProvider.notifier).setQuery(val),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar por colaborador, sede o turno...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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

              // Selector de Sede de Cliente
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedSiteId,
                    hint: Text(
                      'Todas las Sedes',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    isDense: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF0F172A),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todas las Sedes'),
                      ),
                      ...sites.map((st) {
                        return DropdownMenuItem<String?>(
                          value: st.id,
                          child: Text(st.name),
                        );
                      }),
                    ],
                    onChanged: (val) => ref
                        .read(rosterSiteFilterProvider.notifier)
                        .setFilter(val),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Selector de Centro de Costo
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedCostCenter,
                    hint: Text(
                      'Centro de Costo',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    isDense: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF0F172A),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todos los CC'),
                      ),
                      ...EliteCostCenter.all.map((cc) {
                        return DropdownMenuItem<String?>(
                          value: cc,
                          child: Text(EliteCostCenter.getLabel(cc)),
                        );
                      }),
                    ],
                    onChanged: (val) => ref
                        .read(rosterCostCenterFilterProvider.notifier)
                        .setFilter(val),
                  ),
                ),
              ),
              const Spacer(),

              // Botón Limpiar filtros
              if (selectedSiteId != null || selectedCostCenter != null)
                TextButton.icon(
                  onPressed: () {
                    ref.read(rosterSiteFilterProvider.notifier).setFilter(null);
                    ref
                        .read(rosterCostCenterFilterProvider.notifier)
                        .setFilter(null);
                    ref.read(rosterSearchQueryProvider.notifier).setQuery('');
                  },
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                  label: Text(
                    'Limpiar',
                    style: GoogleFonts.inter(fontSize: 11.5),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                ),
            ],
          ),
        ),

        // ---------------------------------------------------------------------
        // TABLA EN EXPANDED (80% DEL ESPACIO VISUAL ÚTIL)
        // ---------------------------------------------------------------------
        Expanded(
          child: Container(
            color: Colors.white,
            child: roster.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron asignaciones para los filtros seleccionados.',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  )
                : SingleChildScrollView(
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
                          _buildColumnHeader('COLABORADOR', 220),
                          _buildColumnHeader('CENTRO COSTO', 130),
                          _buildColumnHeader('SEDE ASIGNADA', 200),
                          _buildColumnHeader('TURNO PROGRAMADO', 190),
                          _buildColumnHeader('HORARIO DIARIO', 180),
                          _buildColumnHeader('VIGENCIA', 130),
                          _buildColumnHeader('ACCIONES', 100),
                        ],
                        rows: roster.map((item) {
                          return DataRow(
                            cells: [
                              // Colaborador
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      size: 15,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.employeeName,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Centro de Costo
                              DataCell(
                                Text(
                                  item.serviceLineCode,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                              ),

                              // Sede Asignada
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.place_outlined,
                                      size: 13,
                                      color: Color(0xFF0D9488),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.siteName,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Turno Programado
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDFA),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFFCCFBF1),
                                    ),
                                  ),
                                  child: Text(
                                    item.shiftName,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0F766E),
                                    ),
                                  ),
                                ),
                              ),

                              // Horario Diario
                              DataCell(
                                Text(
                                  item.scheduleSummary,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                              ),

                              // Vigencia
                              DataCell(
                                Text(
                                  'Desde ${dateFormat.format(item.startDate)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),

                              // Acciones
                              DataCell(
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    size: 18,
                                    color: Color(0xFF64748B),
                                  ),
                                  tooltip: 'Opciones de Cuadrante',
                                  padding: EdgeInsets.zero,
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  onSelected: (action) {
                                    if (action == 'rotar') {
                                      EliteRosterAssignmentDialog.show(
                                        context,
                                        existingAssignment: item,
                                      );
                                    }
                                  },
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(
                                      value: 'rotar',
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.sync_alt_outlined,
                                            size: 16,
                                            color: Color(0xFF0D9488),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Rotar Personal / Sede',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
