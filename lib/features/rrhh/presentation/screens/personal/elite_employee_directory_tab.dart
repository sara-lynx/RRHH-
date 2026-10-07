import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 1: Directorio General de Colaboradores.
/// Tabla de alta densidad visual (80% espacio útil con Expanded).
class EliteEmployeeDirectoryTab extends ConsumerWidget {
  const EliteEmployeeDirectoryTab({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(rrhhFilteredEmployeesProvider);
    final selectedWorkplace = ref.watch(rrhhWorkplaceFilterProvider);
    final selectedCostCenter = ref.watch(rrhhCostCenterFilterProvider);
    final selectedStatus = ref.watch(rrhhStatusFilterProvider);
    final searchQuery = ref.watch(rrhhSearchQueryProvider);

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
                        ref.read(rrhhSearchQueryProvider.notifier).setQuery(val),
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: 'Buscar por CI, nombre, cargo o sede...',
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

              // Segmented Workplace (Todos / Oficina / Campo)
              Container(
                height: 32,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    _buildWorkplacePill(
                      label: 'Todos',
                      isSelected: selectedWorkplace == null,
                      onTap: () => ref
                          .read(rrhhWorkplaceFilterProvider.notifier)
                          .setFilter(null),
                    ),
                    _buildWorkplacePill(
                      label: 'Oficina',
                      isSelected:
                          selectedWorkplace == EmployeeWorkplaceType.oficina,
                      onTap: () => ref
                          .read(rrhhWorkplaceFilterProvider.notifier)
                          .setFilter(EmployeeWorkplaceType.oficina),
                    ),
                    _buildWorkplacePill(
                      label: 'Campo',
                      isSelected:
                          selectedWorkplace == EmployeeWorkplaceType.campo,
                      onTap: () => ref
                          .read(rrhhWorkplaceFilterProvider.notifier)
                          .setFilter(EmployeeWorkplaceType.campo),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Dropdown Centro de Costo
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
                        .read(rrhhCostCenterFilterProvider.notifier)
                        .setFilter(val),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Dropdown Estado
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<EmployeeStatus?>(
                    value: selectedStatus,
                    hint: Text(
                      'Estado',
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
                      const DropdownMenuItem<EmployeeStatus?>(
                        value: null,
                        child: Text('Todos los Estados'),
                      ),
                      ...EmployeeStatus.values.map((st) {
                        return DropdownMenuItem<EmployeeStatus?>(
                          value: st,
                          child: Text(st.label),
                        );
                      }),
                    ],
                    onChanged: (val) => ref
                        .read(rrhhStatusFilterProvider.notifier)
                        .setFilter(val),
                  ),
                ),
              ),
              const Spacer(),

              // Botón Limpiar filtros
              if (selectedWorkplace != null ||
                  selectedCostCenter != null ||
                  selectedStatus != null ||
                  searchQuery.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    ref.read(rrhhWorkplaceFilterProvider.notifier).setFilter(null);
                    ref.read(rrhhCostCenterFilterProvider.notifier).setFilter(null);
                    ref.read(rrhhStatusFilterProvider.notifier).setFilter(null);
                    ref.read(rrhhSearchQueryProvider.notifier).setQuery('');
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
        // TABLA EN EXPANDED DENTRO DE TARJETA CORPORATIVA
        // ---------------------------------------------------------------------
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
              child: employees.isEmpty
                  ? _buildEmptyState()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final tableWidth = constraints.maxWidth < 1100
                            ? 1100.0
                            : constraints.maxWidth;
                        const horizMargin = 16.0;
                        final netColumnsWidth = tableWidth - (horizMargin * 2);

                        final colCi = netColumnsWidth * 0.10;
                        final colEmployee = netColumnsWidth * 0.22;
                        final colType = netColumnsWidth * 0.09;
                        final colCostCenter = netColumnsWidth * 0.10;
                        final colPosition = netColumnsWidth * 0.16;
                        final colSite = netColumnsWidth * 0.15;
                        final colStatus = netColumnsWidth * 0.11;
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
                                  _buildColumnHeader('CI / CÓDIGO', colCi),
                                  _buildColumnHeader('COLABORADOR', colEmployee),
                                  _buildColumnHeader('TIPO', colType),
                                  _buildColumnHeader('CENTRO COSTO', colCostCenter),
                                  _buildColumnHeader('CARGO', colPosition),
                                  _buildColumnHeader('SEDE ASIGNADA', colSite),
                                  _buildColumnHeader('ESTADO', colStatus),
                                  _buildColumnHeader('ACCIONES', colActions),
                                ],
                                rows: employees.map((emp) {
                                  final isField = emp.workplaceType == EmployeeWorkplaceType.campo;

                                  return DataRow(
                                    cells: [
                                      // 1. CI / Código
                                      DataCell(
                                        SizedBox(
                                          width: colCi,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                emp.ci,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF0F172A),
                                                ),
                                              ),
                                              Text(
                                                emp.id,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 10,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 2. Colaborador con Avatar Circular
                                      DataCell(
                                        SizedBox(
                                          width: colEmployee,
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.phone_outlined,
                                                          size: 11,
                                                          color: Color(0xFF64748B),
                                                        ),
                                                        const SizedBox(width: 3),
                                                        Flexible(
                                                          child: Text(
                                                            emp.phone,
                                                            style: GoogleFonts.inter(
                                                              fontSize: 10.5,
                                                              color: const Color(0xFF64748B),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 3. Tipo (Píldora cápsula suave)
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                          ),
                                        ),
                                      ),

                                      // 4. Centro de Costo (Píldora cápsula suave)
                                      DataCell(
                                        SizedBox(
                                          width: colCostCenter,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                emp.serviceLineCode,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF475569),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 5. Cargo
                                      DataCell(
                                        SizedBox(
                                          width: colPosition,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              emp.position,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: const Color(0xFF334155),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 6. Sede Asignada
                                      DataCell(
                                        SizedBox(
                                          width: colSite,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                emp.isOffice
                                                    ? Icons.apartment_outlined
                                                    : Icons.place_outlined,
                                                size: 13,
                                                color: emp.isOffice
                                                    ? const Color(0xFF2563EB)
                                                    : const Color(0xFF0D9488),
                                              ),
                                              const SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  emp.assignedSite,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: const Color(0xFF334155),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 7. Estado (Píldora cápsula pastel)
                                      DataCell(
                                        SizedBox(
                                          width: colStatus,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Builder(
                                              builder: (context) {
                                                Color bg;
                                                Color fg;
                                                if (emp.status == EmployeeStatus.activo) {
                                                  bg = const Color(0xFFECFDF5);
                                                  fg = const Color(0xFF047857);
                                                } else if (emp.status == EmployeeStatus.deBaja) {
                                                  bg = const Color(0xFFFEF2F2);
                                                  fg = const Color(0xFFB91C1C);
                                                } else {
                                                  bg = const Color(0xFFFFFBEB);
                                                  fg = const Color(0xFFB45309);
                                                }

                                                return Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 9,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: bg,
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    emp.status.label,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: fg,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 8. Acciones
                                      DataCell(
                                        SizedBox(
                                          width: colActions,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: PopupMenuButton<String>(
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                size: 18,
                                                color: Color(0xFF64748B),
                                              ),
                                              tooltip: 'Opciones',
                                              padding: EdgeInsets.zero,
                                              color: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: const BorderSide(
                                                  color: Color(0xFFE2E8F0),
                                                ),
                                              ),
                                              onSelected: (action) {
                                                if (action == 'baja') {
                                                  _showTerminateDialog(
                                                      context, ref, emp);
                                                } else if (action == 'detalle') {
                                                  _showDetailDialog(context, emp);
                                                }
                                              },
                                              itemBuilder: (ctx) => [
                                                PopupMenuItem(
                                                  value: 'detalle',
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.visibility_outlined,
                                                        size: 16,
                                                        color: Color(0xFF334155),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Ver Expediente',
                                                        style: GoogleFonts.inter(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'baja',
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .person_remove_outlined,
                                                        size: 16,
                                                        color: Color(0xFFDC2626),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Registrar Baja',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: const Color(
                                                              0xFFDC2626),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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

  Widget _buildWorkplacePill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF0F172A)
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline,
              size: 28,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'No se encontraron colaboradores',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Intenta ajustando los filtros de búsqueda o clasificación.',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, EliteEmployee emp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Ficha del Colaborador',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${emp.fullName}'),
            Text('CI: ${emp.ci} • Código: ${emp.id}'),
            Text('Cargo: ${emp.position}'),
            Text('Sede: ${emp.assignedSite}'),
            Text('Centro de Costo: ${EliteCostCenter.getLabel(emp.serviceLineCode)}'),
            Text('Salario Base: Bs ${emp.baseSalary.toStringAsFixed(2)}'),
            Text('Contrato: ${emp.contractType.label}'),
            Text('Documentación: ${emp.hasPendingLegalDocs ? "Pendiente" : "Completa"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTerminateDialog(
    BuildContext context,
    WidgetRef ref,
    EliteEmployee emp,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Confirmar Baja Laboral',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '¿Desea cambiar el estado de ${emp.fullName} (${emp.id}) a "De Baja"?',
          style: GoogleFonts.inter(fontSize: 12.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref.read(rrhhEmployeesProvider.notifier).terminateEmployee(emp.id);
              Navigator.pop(ctx);
            },
            child: const Text('Confirmar Baja'),
          ),
        ],
      ),
    );
  }
}
