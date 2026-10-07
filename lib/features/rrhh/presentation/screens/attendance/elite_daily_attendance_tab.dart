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
                          // Ajuste al ancho real del contenedor (sin forzar scroll horizontal en pantallas estándar)
                          final tableWidth = constraints.maxWidth < 1000
                              ? 1000.0
                              : constraints.maxWidth;

                          const colSpacing = 12.0;
                          const horizMargin = 14.0;
                          // 7 columnas: 6 separaciones entre columnas + 2 márgenes laterales (6*12 + 2*14 = 100px)
                          const spacingAndMargins = (colSpacing * (7 - 1)) + (horizMargin * 2);
                          final netColumnsWidth = tableWidth - spacingAndMargins;

                          // Distribución proporcional exacta al 100% de las columnas útiles
                          final colWorker = netColumnsWidth * 0.24;
                          final colTypeAndLine = netColumnsWidth * 0.12;
                          final colShiftAndSite = netColumnsWidth * 0.18;
                          final colEntry = netColumnsWidth * 0.09;
                          final colExit = netColumnsWidth * 0.08;
                          final colOrigin = netColumnsWidth * 0.14;
                          final colEvaluation = netColumnsWidth * 0.15;

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
                                  columnSpacing: colSpacing,
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
                                          width: colWorker,
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
                                          width: colTypeAndLine,
                                          child: Text(
                                            'TIPO Y LÍNEA',
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
                                          width: colShiftAndSite,
                                          child: Text(
                                            'TURNO Y SEDE',
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
                                          width: colEntry,
                                          child: Center(
                                            child: Text(
                                              'ENTRADA',
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF475569),
                                                letterSpacing: 0.5,
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
                                                color: const Color(0xFF475569),
                                                letterSpacing: 0.5,
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
                                              color: const Color(0xFF475569),
                                              letterSpacing: 0.5,
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
                                              color: const Color(0xFF475569),
                                              letterSpacing: 0.5,
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

                                      return DataRow(
                                        cells: [
                                          // 1. Colaborador: 24% (Nombre en negrita 12.5px + subtítulo con CI y cargo)
                                          DataCell(
                                            SizedBox(
                                              width: colWorker,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    rec.employeeName,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF0F172A),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${rec.employeeJobTitle} • ${rec.employeeId}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      color: const Color(
                                                          0xFF64748B),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // 2. Tipo y Línea: 13% (Chip OFICINA/CAMPO + código CC-ADM, CC-SEG, etc.)
                                          DataCell(
                                            SizedBox(
                                              width: colTypeAndLine,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2.5,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: rec.workplaceType
                                                            .badgeBgColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                          color: rec
                                                              .workplaceType
                                                              .badgeBorderColor,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        rec.workplaceType.label
                                                            .toUpperCase(),
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 9.5,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: rec
                                                              .workplaceType
                                                              .badgeColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Flexible(
                                                      child: Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2.5,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFF1F5F9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFFE2E8F0),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          rec.serviceLineCode,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xFF334155),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // 3. Turno y Sede: 20% (Nombre de turno 11.5px negrita + sede cliente abajo en 10.5px gris)
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
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF0F172A),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 1),
                                                  Text(
                                                    rec.assignedSite,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      color: const Color(
                                                          0xFF64748B),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // 4. Entrada: 9% (Hora centrada en tipografía monoespaciada o chip Sin Registro)
                                          DataCell(
                                            SizedBox(
                                              width: colEntry,
                                              child: Center(
                                                child: rec.evaluation ==
                                                        AttendanceEvaluation
                                                            .faltaInjustificada
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFFEF2F2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFFFCA5A5),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Sin Registro',
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 9.5,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xFFDC2626),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        inStr,
                                                        style: GoogleFonts
                                                            .jetBrainsMono(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF0F172A),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          // 5. Salida: 9% (Hora centrada en tipografía monoespaciada)
                                          DataCell(
                                            SizedBox(
                                              width: colExit,
                                              child: Center(
                                                child: Text(
                                                  outStr,
                                                  style: GoogleFonts
                                                      .jetBrainsMono(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                        0xFF64748B),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // 6. Origen: 12% (Chip azul Web Oficina o chip esmeralda APK GPS Automático)
                                          DataCell(
                                            SizedBox(
                                              width: colOrigin,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 7,
                                                    vertical: 3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: rec
                                                        .source.badgeBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                      color: rec.source
                                                          .badgeBorderColor,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    rec.source.label,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: rec
                                                          .source.badgeColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // 7. Evaluación: 13% (Chip con padding holgado: Puntual, Retraso (8m), En Jornada, Ausente / Falta)
                                          DataCell(
                                            SizedBox(
                                              width: colEvaluation,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 3.5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: rec.evaluation
                                                        .badgeBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: rec.evaluation
                                                          .badgeBorderColor,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        rec.evaluation ==
                                                                AttendanceEvaluation
                                                                    .puntual
                                                            ? Icons
                                                                .check_circle_outline
                                                            : rec.evaluation ==
                                                                    AttendanceEvaluation
                                                                        .retraso
                                                                ? Icons
                                                                    .warning_amber_outlined
                                                                : rec.evaluation ==
                                                                        AttendanceEvaluation
                                                                            .faltaInjustificada
                                                                    ? Icons
                                                                        .cancel_outlined
                                                                    : Icons
                                                                        .timelapse,
                                                        size: 12,
                                                        color: rec.evaluation
                                                            .badgeColor,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          rec.evaluation ==
                                                                      AttendanceEvaluation
                                                                          .retraso &&
                                                                  rec.lateMinutes >
                                                                      0
                                                              ? '${rec.evaluation.label} (${rec.lateMinutes}m)'
                                                              : rec.evaluation ==
                                                                      AttendanceEvaluation
                                                                          .faltaInjustificada
                                                                  ? 'Ausente / Falta'
                                                                  : rec.evaluation
                                                                      .label,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 10.5,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: rec
                                                                .evaluation
                                                                .badgeColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
            ),
          ),
        ],
      ),
    );
  }
}
