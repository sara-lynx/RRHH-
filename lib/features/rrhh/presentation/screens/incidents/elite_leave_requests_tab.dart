import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_leave_request_dialog.dart';

/// Tab 1: Solicitudes de Permisos, Bajas Médicas y Licencias con aprobación en tiempo real.
class EliteLeaveRequestsTab extends ConsumerStatefulWidget {
  const EliteLeaveRequestsTab({super.key});

  @override
  ConsumerState<EliteLeaveRequestsTab> createState() =>
      _EliteLeaveRequestsTabState();
}

class _EliteLeaveRequestsTabState
    extends ConsumerState<EliteLeaveRequestsTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRequests = ref.watch(rrhhFilteredLeaveRequestsProvider);
    final statusFilter = ref.watch(leaveStatusFilterProvider);
    final typeFilter = ref.watch(leaveTypeFilterProvider);
    final costCenterFilter = ref.watch(leaveCostCenterFilterProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
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
                          .read(leaveSearchQueryProvider.notifier)
                          .setQuery(val);
                    },
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Buscar colaborador, motivo, diagnóstico o ID...',
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
                                    .read(leaveSearchQueryProvider.notifier)
                                    .setQuery('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: EdgeInsets.zero,
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

              // Selector: Estado
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
                    child: DropdownButton<LeaveRequestStatus?>(
                      value: statusFilter,
                      icon: const Icon(
                        Icons.rule_outlined,
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
                            .read(leaveStatusFilterProvider.notifier)
                            .setFilter(val);
                      },
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Estado: Todos'),
                        ),
                        ...LeaveRequestStatus.values.map((st) {
                          return DropdownMenuItem(
                            value: st,
                            child: Text(
                              st.label,
                              style: TextStyle(color: st.badgeColor),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Selector: Tipo de Permiso
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
                    child: DropdownButton<LeaveType?>(
                      value: typeFilter,
                      icon: const Icon(
                        Icons.category_outlined,
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
                            .read(leaveTypeFilterProvider.notifier)
                            .setFilter(val);
                      },
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Tipo: Todos'),
                        ),
                        ...LeaveType.values.map((lt) {
                          return DropdownMenuItem(
                            value: lt,
                            child: Text(
                              lt.label,
                              style: TextStyle(color: lt.badgeColor),
                            ),
                          );
                        }),
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
                        Icons.apartment_outlined,
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
                            .read(leaveCostCenterFilterProvider.notifier)
                            .setFilter(val);
                      },
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Centro Costo: Todos'),
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

              // Botón Limpiar filtros
              if (statusFilter != null ||
                  typeFilter != null ||
                  costCenterFilter != null ||
                  _searchController.text.isNotEmpty)
                IconButton(
                  tooltip: 'Limpiar filtros',
                  icon: const Icon(
                    Icons.filter_alt_off_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(leaveSearchQueryProvider.notifier)
                        .setQuery('');
                    ref
                        .read(leaveStatusFilterProvider.notifier)
                        .setFilter(null);
                    ref
                        .read(leaveTypeFilterProvider.notifier)
                        .setFilter(null);
                    ref
                        .read(leaveCostCenterFilterProvider.notifier)
                        .setFilter(null);
                  },
                ),

              const Spacer(),

              // Botón + Solicitar Permiso
              ElevatedButton.icon(
                onPressed: () => EliteLeaveRequestDialog.show(context),
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: Text(
                  'Solicitar Permiso',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 0),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ),
        ),

        // =====================================================================
        // TABLA DE SOLICITUDES EN EXPANDED (80% DEL ESPACIO)
        // =====================================================================
        Expanded(
          child: filteredRequests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inbox_outlined,
                        size: 38,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No hay solicitudes que coincidan con los filtros',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Puede registrar una nueva solicitud con el botón superior.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
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
                        final tableWidth = constraints.maxWidth < 1180
                            ? 1180.0
                            : constraints.maxWidth;

                        const colSpacing = 12.0;
                        const horizMargin = 16.0;
                        const spacingAndMargins = (colSpacing * (9 - 1)) + (horizMargin * 2);
                        final netColumnsWidth = tableWidth - spacingAndMargins;

                        final colWorker = netColumnsWidth * 0.20;
                        final colCostCenter = netColumnsWidth * 0.08;
                        final colLeaveType = netColumnsWidth * 0.18;
                        final colDates = netColumnsWidth * 0.13;
                        final colDays = netColumnsWidth * 0.06;
                        final colSource = netColumnsWidth * 0.08;
                        final colPayment = netColumnsWidth * 0.09;
                        final colStatus = netColumnsWidth * 0.10;
                        final colActions = netColumnsWidth * 0.08;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableWidth,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                headingRowHeight: 46,
                                dataRowMinHeight: 52,
                                dataRowMaxHeight: 56,
                                horizontalMargin: horizMargin,
                                columnSpacing: colSpacing,
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
                                      width: colCostCenter,
                                      child: Text(
                                        'CENTRO COSTO',
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
                                      width: colLeaveType,
                                      child: Text(
                                        'TIPO DE LICENCIA / PERMISO',
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
                                      width: colDates,
                                      child: Text(
                                        'VIGENCIA (FECHAS)',
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
                                      width: colDays,
                                      child: Text(
                                        'DÍAS',
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
                                      width: colSource,
                                      child: Text(
                                        'CANAL ORIGEN',
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
                                      width: colPayment,
                                      child: Text(
                                        'REMUNERACIÓN',
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
                                      width: colStatus,
                                      child: Text(
                                        'ESTADO',
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
                                        'RESOLUCIÓN',
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
                                rows: filteredRequests.map((req) {
                                  final startStr = dateFormat.format(req.startDate);
                                  final endStr = dateFormat.format(req.endDate);

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
                                                  _getInitials(req.employeeName),
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
                                                      req.employeeName,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.5,
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFF0F172A),
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      '${req.id} • ${req.employeeId}',
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

                                      // Centro de Costo
                                      DataCell(
                                        SizedBox(
                                          width: colCostCenter,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 9,
                                                vertical: 3.5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                req.serviceLineCode,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF334155),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Tipo de Licencia / Motivo
                                      DataCell(
                                        SizedBox(
                                          width: colLeaveType,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: req.leaveType.badgeBgColor,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  req.leaveType.label,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: req.leaveType.badgeColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                req.reason,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.5,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Vigencia (Fechas)
                                      DataCell(
                                        SizedBox(
                                          width: colDates,
                                          child: Text(
                                            '$startStr - $endStr',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF0F172A),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),

                                      // Días
                                      DataCell(
                                        SizedBox(
                                          width: colDays,
                                          child: Text(
                                            '${req.totalDays}d',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0D9488),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Canal Origen
                                      DataCell(
                                        SizedBox(
                                          width: colSource,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                req.source,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF475569),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Remuneración
                                      DataCell(
                                        SizedBox(
                                          width: colPayment,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: req.paymentStatus.badgeBgColor,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                req.paymentStatus.label,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: req.paymentStatus.badgeColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Estado
                                      DataCell(
                                        SizedBox(
                                          width: colStatus,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 9,
                                                vertical: 3.5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: req.status == LeaveRequestStatus.aprobado
                                                    ? const Color(0xFFECFDF5)
                                                    : req.status == LeaveRequestStatus.rechazado
                                                        ? const Color(0xFFFEF2F2)
                                                        : const Color(0xFFFFFBEB),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    req.status == LeaveRequestStatus.aprobado
                                                        ? Icons.check_circle_outline
                                                        : req.status == LeaveRequestStatus.rechazado
                                                            ? Icons.cancel_outlined
                                                            : Icons.pending_actions_outlined,
                                                    size: 13,
                                                    color: req.status == LeaveRequestStatus.aprobado
                                                        ? const Color(0xFF047857)
                                                        : req.status == LeaveRequestStatus.rechazado
                                                            ? const Color(0xFFB91C1C)
                                                            : const Color(0xFFB45309),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    req.status.label,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: req.status == LeaveRequestStatus.aprobado
                                                          ? const Color(0xFF047857)
                                                          : req.status == LeaveRequestStatus.rechazado
                                                              ? const Color(0xFFB91C1C)
                                                              : const Color(0xFFB45309),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Acciones de Aprobación / Rechazo
                                      DataCell(
                                        SizedBox(
                                          width: colActions,
                                          child: req.status == LeaveRequestStatus.pendiente
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Aprobar
                                                    PopupMenuButton<LeavePaymentStatus>(
                                                      tooltip: 'Aprobar Solicitud',
                                                      icon: Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFECFDF5),
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: const Icon(
                                                          Icons.check_circle_outline,
                                                          size: 16,
                                                          color: Color(0xFF047857),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(),
                                                      onSelected: (payStatus) {
                                                        ref
                                                            .read(
                                                                rrhhLeaveRequestsProvider
                                                                    .notifier)
                                                            .updateStatus(
                                                              req.id,
                                                              LeaveRequestStatus.aprobado,
                                                              payStatus,
                                                            );
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            behavior:
                                                                SnackBarBehavior.floating,
                                                            margin:
                                                                const EdgeInsets.all(16),
                                                            backgroundColor:
                                                                const Color(0xFF16A34A),
                                                            content: Text(
                                                              'Solicitud ${req.id} aprobada (${payStatus.label}).',
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          value:
                                                              LeavePaymentStatus.conGoce,
                                                          child: Text(
                                                            'Aprobar CON Goce',
                                                            style: GoogleFonts.inter(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color:
                                                                  const Color(0xFF16A34A),
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value:
                                                              LeavePaymentStatus.sinGoce,
                                                          child: Text(
                                                            'Aprobar SIN Goce',
                                                            style: GoogleFonts.inter(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color:
                                                                  const Color(0xFFD97706),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 6),

                                                    // Rechazar
                                                    IconButton(
                                                      tooltip: 'Rechazar Solicitud',
                                                      icon: Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFFEF2F2),
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: const Icon(
                                                          Icons.cancel_outlined,
                                                          size: 16,
                                                          color: Color(0xFFB91C1C),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(),
                                                      onPressed: () {
                                                        ref
                                                            .read(
                                                                rrhhLeaveRequestsProvider
                                                                    .notifier)
                                                            .updateStatus(
                                                              req.id,
                                                              LeaveRequestStatus.rechazado,
                                                              req.paymentStatus,
                                                            );
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            behavior:
                                                                SnackBarBehavior.floating,
                                                            margin:
                                                                const EdgeInsets.all(16),
                                                            backgroundColor:
                                                                const Color(0xFFDC2626),
                                                            content: Text(
                                                              'Solicitud ${req.id} rechazada.',
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  'Procesado',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    color: const Color(0xFF94A3B8),
                                                    fontStyle: FontStyle.italic,
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

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
