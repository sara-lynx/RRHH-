import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 1: Monitor Diario en Vivo con filtros ERP y tabla Full-Width en Tarjeta Corporativa.
class EliteDailyAttendanceTab extends ConsumerStatefulWidget {
  const EliteDailyAttendanceTab({super.key});

  @override
  ConsumerState<EliteDailyAttendanceTab> createState() =>
      _EliteDailyAttendanceTabState();
}

class _EliteDailyAttendanceTabState
    extends ConsumerState<EliteDailyAttendanceTab> {
  final _searchController = TextEditingController();

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords = ref.watch(rrhhFilteredAttendanceProvider);
    final workplaceFilter =
        ref.watch(attendanceWorkplaceTypeFilterProvider);
    final costCenterFilter = ref.watch(attendanceCostCenterFilterProvider);
    final evalFilter = ref.watch(attendanceEvaluationFilterProvider);

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
                            .read(attendanceSearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Buscar colaborador, cargo, puesto o sede...',
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
                                      .read(
                                          attendanceSearchQueryProvider.notifier)
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
                        isDense: true,
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
                                  attendanceWorkplaceTypeFilterProvider.notifier)
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
                        isDense: true,
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
                              .read(attendanceCostCenterFilterProvider.notifier)
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

                // Selector: Evaluación
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
                      child: DropdownButton<AttendanceEvaluation?>(
                        value: evalFilter,
                        isDense: true,
                        icon: const Icon(
                          Icons.verified_outlined,
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
                                  attendanceEvaluationFilterProvider.notifier)
                              .setFilter(val);
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Estado: Todos'),
                          ),
                          ...AttendanceEvaluation.values.map((ev) {
                            return DropdownMenuItem(
                              value: ev,
                              child: Text(
                                ev.label,
                                style: TextStyle(color: ev.badgeColor),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Contador de registros y botón de limpiar filtros
                if (workplaceFilter != null ||
                    costCenterFilter != null ||
                    evalFilter != null ||
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
                          .read(attendanceSearchQueryProvider.notifier)
                          .setQuery('');
                      ref
                          .read(attendanceWorkplaceTypeFilterProvider.notifier)
                          .setFilter(null);
                      ref
                          .read(attendanceCostCenterFilterProvider.notifier)
                          .setFilter(null);
                      ref
                          .read(attendanceEvaluationFilterProvider.notifier)
                          .setFilter(null);
                    },
                  ),
              ],
            ),
          ),

          // =====================================================================
          // TABLA DE ASISTENCIA DIARIA FULL-WIDTH EN TARJETA CORPORATIVA
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
                child: filteredRecords.isEmpty
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
                              'No se encontraron marcaciones para los filtros aplicados',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Intente ajustar la búsqueda o limpiar los filtros seleccionados.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final tableWidth = constraints.maxWidth < 1100
                              ? 1100.0
                              : constraints.maxWidth;

                          const colSpacing = 12.0;
                          const horizMargin = 16.0;
                          const spacingAndMargins = (colSpacing * (7 - 1)) + (horizMargin * 2);
                          final netColumnsWidth = tableWidth - spacingAndMargins;

                          final colWorker = netColumnsWidth * 0.25;
                          final colTypeAndLine = netColumnsWidth * 0.13;
                          final colShiftAndSite = netColumnsWidth * 0.19;
                          final colEntry = netColumnsWidth * 0.08;
                          final colExit = netColumnsWidth * 0.08;
                          final colOrigin = netColumnsWidth * 0.13;
                          final colEvaluation = netColumnsWidth * 0.14;

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
                                  headingRowColor: WidgetStateProperty.all(
                                    const Color(0xFFF8FAFC),
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
                                        width: colTypeAndLine,
                                        child: Text(
                                          'TIPO Y LÍNEA',
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
                                        width: colShiftAndSite,
                                        child: Text(
                                          'TURNO Y SEDE',
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
                                        width: colEntry,
                                        child: Center(
                                          child: Text(
                                            'ENTRADA',
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: colExit,
                                        child: Center(
                                          child: Text(
                                            'SALIDA',
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: colOrigin,
                                        child: Text(
                                          'ORIGEN',
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
                                        width: colEvaluation,
                                        child: Text(
                                          'EVALUACIÓN',
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
                                  rows: filteredRecords.map((rec) {
                                    final inStr = rec.evaluation ==
                                            AttendanceEvaluation
                                                .faltaInjustificada
                                        ? 'Sin Registro'
                                        : DateFormat('HH:mm')
                                            .format(rec.timestamp);

                                    final outStr = rec.checkOutTimestamp != null
                                        ? DateFormat('HH:mm')
                                            .format(rec.checkOutTimestamp!)
                                        : '--:--';

                                    final isField = rec.workplaceType == EmployeeWorkplaceType.campo;

                                    return DataRow(
                                      cells: [
                                        // 1. Colaborador con Avatar Circular
                                        DataCell(
                                          SizedBox(
                                            width: colWorker,
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
                                                    _getInitials(rec.employeeName),
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
                                                        rec.employeeName,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w700,
                                                          color: const Color(0xFF0F172A),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 1),
                                                      Text(
                                                        '${rec.employeeJobTitle} • ${rec.employeeId}',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 10.5,
                                                          color: const Color(0xFF64748B),
                                                          fontWeight: FontWeight.w500,
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

                                        // 2. Tipo y Línea (Píldoras redondeadas suaves)
                                        DataCell(
                                          SizedBox(
                                            width: colTypeAndLine,
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
                                                      borderRadius:
                                                          BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                      rec.workplaceType.label.toUpperCase(),
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
                                                        borderRadius:
                                                            BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        rec.serviceLineCode,
                                                        style: GoogleFonts.inter(
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

                                        // 3. Turno y Sede
                                        DataCell(
                                          SizedBox(
                                            width: colShiftAndSite,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  rec.shiftName,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF0F172A),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 1),
                                                Text(
                                                  rec.assignedSite,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.5,
                                                    color: const Color(0xFF64748B),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // 4. Entrada
                                        DataCell(
                                          SizedBox(
                                            width: colEntry,
                                            child: Center(
                                              child: rec.evaluation ==
                                                      AttendanceEvaluation
                                                          .faltaInjustificada
                                                  ? Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFEF2F2),
                                                        borderRadius:
                                                            BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        'Sin Registro',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xFFB91C1C),
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      inStr,
                                                      style: GoogleFonts.jetBrainsMono(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xFF0F172A),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),

                                        // 5. Salida
                                        DataCell(
                                          SizedBox(
                                            width: colExit,
                                            child: Center(
                                              child: Text(
                                                outStr,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 6. Origen (Píldora cápsula)
                                        DataCell(
                                          SizedBox(
                                            width: colOrigin,
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
                                                  rec.source.label,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFF475569),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 7. Evaluación (Píldora cápsula pastel)
                                        DataCell(
                                          SizedBox(
                                            width: colEvaluation,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Builder(
                                                builder: (context) {
                                                  Color bg;
                                                  Color fg;
                                                  IconData icon;

                                                  if (rec.evaluation == AttendanceEvaluation.puntual) {
                                                    bg = const Color(0xFFECFDF5);
                                                    fg = const Color(0xFF047857);
                                                    icon = Icons.check_circle_outline;
                                                  } else if (rec.evaluation == AttendanceEvaluation.retraso) {
                                                    bg = const Color(0xFFFFFBEB);
                                                    fg = const Color(0xFFB45309);
                                                    icon = Icons.warning_amber_outlined;
                                                  } else if (rec.evaluation == AttendanceEvaluation.faltaInjustificada) {
                                                    bg = const Color(0xFFFEF2F2);
                                                    fg = const Color(0xFFB91C1C);
                                                    icon = Icons.cancel_outlined;
                                                  } else {
                                                    bg = const Color(0xFFF1F5F9);
                                                    fg = const Color(0xFF475569);
                                                    icon = Icons.timelapse;
                                                  }

                                                  final text = rec.evaluation == AttendanceEvaluation.retraso && rec.lateMinutes > 0
                                                      ? '${rec.evaluation.label} (${rec.lateMinutes}m)'
                                                      : rec.evaluation == AttendanceEvaluation.faltaInjustificada
                                                          ? 'Ausente / Falta'
                                                          : rec.evaluation.label;

                                                  return Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: bg,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(icon, size: 13, color: fg),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                                          child: Text(
                                                            text,
                                                            style: GoogleFonts.inter(
                                                              fontSize: 10.5,
                                                              fontWeight: FontWeight.w700,
                                                              color: fg,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
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
