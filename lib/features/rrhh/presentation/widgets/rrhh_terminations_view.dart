import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_termination_detail_drawer.dart';
import 'rrhh_termination_edit_dialog.dart';
import 'rrhh_termination_record_row.dart';

/// Vista principal de Desvinculaciones y Bajas Laborales (Pantalla 11 — Bloque 3).
class RrhhTerminationsView extends StatefulWidget {
  const RrhhTerminationsView({super.key});

  @override
  State<RrhhTerminationsView> createState() => _RrhhTerminationsViewState();
}

class _RrhhTerminationsViewState extends State<RrhhTerminationsView> {
  bool _isLoading = true;
  String? _errorMessage;
  List<RrhhTerminationRecord> _records = [];

  // Filtros
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'TODOS'; // 'TODOS' | causal
  String _selectedStatus =
      'TODOS'; // 'TODOS' | 'registrada' | 'en_proceso' | 'finalizada' | 'cancelada'
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final list = await repo.listTerminationRecords();
      if (!mounted) return;
      setState(() {
        _records = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar desvinculaciones: $e';
        _isLoading = false;
      });
    }
  }

  // --- FILTRADO EN MEMORIA ---

  List<RrhhTerminationRecord> get _filteredRecords {
    return _records.where((item) {
      // 1. Buscador
      final q = _searchController.text.trim().toLowerCase();
      if (q.isNotEmpty) {
        final matchCode = item.code.toLowerCase().contains(q);
        final matchName = item.employeeName.toLowerCase().contains(q);
        final matchEmpCode = item.employeeCode.toLowerCase().contains(q);
        final matchReason = item.reason.toLowerCase().contains(q);
        if (!matchCode && !matchName && !matchEmpCode && !matchReason) {
          return false;
        }
      }

      // 2. Filtro por tipo de desvinculación
      if (_selectedType != 'TODOS') {
        if (item.terminationType.toLowerCase() != _selectedType.toLowerCase()) {
          return false;
        }
      }

      // 3. Filtro por estado
      if (_selectedStatus != 'TODOS') {
        if (item.status.toLowerCase() != _selectedStatus.toLowerCase()) {
          return false;
        }
      }

      // 4. Filtro por rango de fechas
      if (_selectedDateRange != null) {
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end;
        if (item.terminationDate.isBefore(start) ||
            item.terminationDate.isAfter(end.add(const Duration(days: 1)))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        _selectedType != 'TODOS' ||
        _selectedStatus != 'TODOS' ||
        _selectedDateRange != null;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = 'TODOS';
      _selectedStatus = 'TODOS';
      _selectedDateRange = null;
    });
  }

  // --- ACCIONES CRUD / DIALOGS ---

  Future<void> _handleRegisterNew() async {
    final success = await RrhhTerminationEditDialog.show(context);
    if (success == true) {
      await _loadData();
    }
  }

  void _openDetailDrawer(RrhhTerminationRecord item) {
    RrhhTerminationDetailDrawer.show(
      context,
      item.id,
      onModified: _loadData,
    );
  }

  Future<void> _handleEdit(RrhhTerminationRecord item) async {
    final success = await RrhhTerminationEditDialog.show(context, record: item);
    if (success == true) {
      await _loadData();
    }
  }

  Future<void> _handleStartProcess(RrhhTerminationRecord item) async {
    try {
      await RrhhRepository.current.updateTerminationStatus(
        item.id,
        RrhhTerminationStatus.enProceso,
        reason: 'Proceso formal de baja iniciado por RRHH.',
      );
      if (mounted)
        RrhhSnackBar.showSuccess(
          context,
          'Expediente ${item.code} ahora está En Proceso.',
        );
      await _loadData();
    } catch (e) {
      if (mounted)
        RrhhSnackBar.showError(context, 'Error al iniciar proceso: $e');
    }
  }

  Future<void> _handleMarkPaymentCompleted(RrhhTerminationRecord item) async {
    try {
      await RrhhRepository.current.updateTerminationStatus(
        item.id,
        item.status,
        paymentCompleted: true,
        paymentCompletedAt: DateTime.now(),
      );
      if (mounted)
        RrhhSnackBar.showSuccess(
          context,
          'Pago de finiquito registrado exitosamente.',
        );
      await _loadData();
    } catch (e) {
      if (mounted) RrhhSnackBar.showError(context, 'Error al marcar pago: $e');
    }
  }

  Future<void> _handleFinalize(RrhhTerminationRecord item) async {
    try {
      await RrhhRepository.current.updateTerminationStatus(
        item.id,
        RrhhTerminationStatus.finalizada,
        reason: 'Desvinculación y baja laboral completada definitivamente.',
      );
      if (mounted)
        RrhhSnackBar.showSuccess(
          context,
          'Baja completada. El empleado pasó a estado BAJA.',
        );
      await _loadData();
    } catch (e) {
      if (mounted)
        RrhhSnackBar.showError(context, 'Error al finalizar baja: $e');
    }
  }

  Future<void> _handleCancel(RrhhTerminationRecord item) async {
    try {
      await RrhhRepository.current.updateTerminationStatus(
        item.id,
        RrhhTerminationStatus.cancelada,
        reason: 'Proceso de baja cancelado por jefatura de RRHH.',
      );
      if (mounted)
        RrhhSnackBar.showInfo(context, 'Expediente ${item.code} cancelado.');
      await _loadData();
    } catch (e) {
      if (mounted) RrhhSnackBar.showError(context, 'Error al cancelar: $e');
    }
  }

  Future<void> _handleDelete(RrhhTerminationRecord item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.delete_outline,
              color: Color(0xFFEF4444),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Eliminar Registro',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Eliminar permanentemente el registro ${item.code}? Esta acción solo está disponible en estado "Registrada".',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: Text(
              'Eliminar',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await RrhhRepository.current.deleteTerminationRecord(item.id);
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Registro ${item.code} eliminado correctamente.',
          );
        }
        await _loadData();
      } catch (e) {
        if (mounted) RrhhSnackBar.showError(context, 'Error al eliminar: $e');
      }
    }
  }

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    final filtered = _filteredRecords;
    final totalCount = _records.length;
    final registeredCount = _records
        .where((r) => r.status == RrhhTerminationStatus.registrada)
        .length;
    final inProgressCount = _records
        .where((r) => r.status == RrhhTerminationStatus.enProceso)
        .length;
    final finalizedCount = _records
        .where((r) => r.status == RrhhTerminationStatus.finalizada)
        .length;
    final cancelledCount = _records
        .where((r) => r.status == RrhhTerminationStatus.cancelada)
        .length;

    // Métricas para los 4 KPIs
    final now = DateTime.now();
    final monthTerminations = _records
        .where(
          (r) =>
              r.terminationDate.year == now.year &&
              r.terminationDate.month == now.month,
        )
        .length;
    final pendingPaymentCount = _records
        .where(
          (r) =>
              !r.paymentCompleted &&
              r.status != RrhhTerminationStatus.cancelada,
        )
        .length;
    final resignationsCount = _records
        .where(
          (r) => r.terminationType == RrhhTerminationTypes.renunciaVoluntaria,
        )
        .length;
    final dismissalsCount = _records
        .where((r) => RrhhTerminationTypes.isDismissal(r.terminationType))
        .length;
    final expiredFiniquitosCount = _records
        .where((r) => r.isPaymentExpired)
        .length;

    const minTableWidth = 980.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 48.0;
        final tableWidth = contentWidth > minTableWidth
            ? contentWidth
            : minTableWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header de Sección compacto
              _buildSectionHeader(),
              const SizedBox(height: 14),

              // 2. Panel de Resumen (4 KPIs)
              _buildKpisPanel(
                monthTerminations: monthTerminations,
                pendingPaymentCount: pendingPaymentCount,
                resignationsCount: resignationsCount,
                dismissalsCount: dismissalsCount,
                expiredFiniquitosCount: expiredFiniquitosCount,
              ),
              const SizedBox(height: 14),

              // 3. Barra de Filtros en Card redondeada
              _buildFiltersBar(
                total: totalCount,
                registered: registeredCount,
                inProgress: inProgressCount,
                finalized: finalizedCount,
                cancelled: cancelledCount,
              ),
              const SizedBox(height: 14),

              // 4. Tabla dentro de Card redondeada
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D111C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTableHeader(),
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (filtered.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 48,
                                horizontal: 20,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.inbox_outlined,
                                      size: 48,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _hasActiveFilters
                                          ? 'No se encontraron desvinculaciones que coincidan con los filtros aplicados.'
                                          : 'No hay desvinculaciones laborales registradas.',
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    if (_hasActiveFilters) ...[
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: _clearFilters,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2563EB,
                                          ),
                                        ),
                                        child: const Text('Limpiar filtros'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            )
                          else
                            ...filtered.map(
                              (item) => RrhhTerminationRecordRow(
                                record: item,
                                onTap: () => _openDetailDrawer(item),
                                onEdit: () => _handleEdit(item),
                                onStartProcess: () => _handleStartProcess(item),
                                onMarkPaymentCompleted: () =>
                                    _handleMarkPaymentCompleted(item),
                                onFinalize: () => _handleFinalize(item),
                                onCancel: () => _handleCancel(item),
                                onDelete: () => _handleDelete(item),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 5. Footer idéntico al submódulo
              const SizedBox(height: 14),
              if (!_isLoading && _records.isNotEmpty)
                Text(
                  'Mostrando ${filtered.length} de $totalCount desvinculaciones registradas',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Desvinculaciones',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Registro y gestión de bajas laborales, finiquitos y plazos legales (LGT Bolivia)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        RrhhPrimaryActionButton(
          label: 'Registrar Desvinculación',
          onPressed: _handleRegisterNew,
        ),
      ],
    );
  }

  Widget _buildKpisPanel({
    required int monthTerminations,
    required int pendingPaymentCount,
    required int resignationsCount,
    required int dismissalsCount,
    required int expiredFiniquitosCount,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - (12 * 3)) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _buildKpiCard(
              title: 'Bajas del mes',
              value: '$monthTerminations',
              subtitle: 'Cese de funciones este mes',
              icon: Icons.person_remove_outlined,
              color: const Color(0xFF38BDF8),
              width: cardWidth > 200 ? cardWidth : double.infinity,
            ),
            _buildKpiCard(
              title: 'Pendientes de pago',
              value: '$pendingPaymentCount',
              subtitle: 'Finiquitos en liquidación',
              icon: Icons.hourglass_top_outlined,
              color: const Color(0xFFF59E0B),
              width: cardWidth > 200 ? cardWidth : double.infinity,
            ),
            _buildKpiCard(
              title: 'Renuncias vs Despidos',
              value: '$resignationsCount / $dismissalsCount',
              subtitle: 'Voluntarias vs despidos',
              icon: Icons.compare_arrows_rounded,
              color: const Color(0xFFA855F7),
              width: cardWidth > 200 ? cardWidth : double.infinity,
            ),
            _buildKpiCard(
              title: 'Finiquitos vencidos',
              value: '$expiredFiniquitosCount',
              subtitle: expiredFiniquitosCount > 0
                  ? 'Alerta: Fuera de los 15 días'
                  : 'Sin moras legales',
              icon: Icons.warning_amber_rounded,
              color: expiredFiniquitosCount > 0
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF10B981),
              highlightRed: expiredFiniquitosCount > 0,
              width: cardWidth > 200 ? cardWidth : double.infinity,
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double width,
    bool highlightRed = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlightRed
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : const Color(0xFF1E293B),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: highlightRed
                        ? const Color(0xFFEF4444)
                        : Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: highlightRed
                        ? const Color(0xFFFCA5A5)
                        : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2563EB),
            surface: Color(0xFF1E293B),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  Widget _buildFiltersBar({
    required int total,
    required int registered,
    required int inProgress,
    required int finalized,
    required int cancelled,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Buscador y Selectores
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 38,
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar empleado o código BAJA...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 12.5,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF111827),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1E293B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
              ),

              // Dropdown Tipo de Desvinculación
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    dropdownColor: const Color(0xFF0F172A),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12.5,
                    ),
                    hint: Text(
                      'Todos los tipos',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12.5,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'TODOS',
                        child: Text('Todos los tipos'),
                      ),
                      DropdownMenuItem(
                        value: RrhhTerminationTypes.renunciaVoluntaria,
                        child: Text('Renuncia Voluntaria'),
                      ),
                      DropdownMenuItem(
                        value: RrhhTerminationTypes.despidoJustificado,
                        child: Text('Despido Justificado'),
                      ),
                      DropdownMenuItem(
                        value: RrhhTerminationTypes.despidoInjustificado,
                        child: Text('Despido Injustificado'),
                      ),
                      DropdownMenuItem(
                        value: RrhhTerminationTypes.finDeContrato,
                        child: Text('Fin de Contrato'),
                      ),
                      DropdownMenuItem(
                        value: RrhhTerminationTypes.jubilacion,
                        child: Text('Jubilación'),
                      ),
                      DropdownMenuItem(
                        value: RrhhTerminationTypes.abandonoDeTrabajo,
                        child: Text('Abandono de Trabajo'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                ),
              ),

              // Selector Rango Fechas
              InkWell(
                onTap: _pickDateRange,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _selectedDateRange != null
                        ? const Color(0xFF2563EB).withValues(alpha: 0.15)
                        : const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedDateRange != null
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 16,
                        color: _selectedDateRange != null
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDateRange != null
                            ? '${_fmtDate(_selectedDateRange!.start)} - ${_fmtDate(_selectedDateRange!.end)}'
                            : 'Rango de fechas',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: _selectedDateRange != null
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      if (_selectedDateRange != null) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _selectedDateRange = null),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (_hasActiveFilters)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 15),
                  label: const Text('Limpiar'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    textStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          // Filtro por Estado (Pills)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterChip('Todos ($total)', 'TODOS'),
              const SizedBox(width: 6),
              _buildFilterChip(
                'Registradas ($registered)',
                RrhhTerminationStatus.registrada,
              ),
              const SizedBox(width: 6),
              _buildFilterChip(
                'En proceso ($inProgress)',
                RrhhTerminationStatus.enProceso,
              ),
              const SizedBox(width: 6),
              _buildFilterChip(
                'Finalizadas ($finalized)',
                RrhhTerminationStatus.finalizada,
              ),
              const SizedBox(width: 6),
              _buildFilterChip(
                'Canceladas ($cancelled)',
                RrhhTerminationStatus.cancelada,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedStatus == value;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = value),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB).withValues(alpha: 0.15)
              : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFF1E293B),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? const Color(0xFF60A5FA)
                : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('CÓDIGO', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text('EMPLEADO', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text('TIPO DESVINCULACIÓN', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 95,
            child: Text('FECHA EFECTIVA', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 95,
            child: Text('ÚLTIMO DÍA', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 130,
            child: Text('PAGO FINIQUITO', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text('ESTADO', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 130,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('ACCIONES', style: _headerStyle),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF64748B),
    letterSpacing: 0.5,
  );

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 44),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13.5),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
