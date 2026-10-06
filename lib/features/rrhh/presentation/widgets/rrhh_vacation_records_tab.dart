import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_vacation_detail_drawer.dart';
import 'rrhh_vacation_edit_dialog.dart';
import 'rrhh_vacation_record_row.dart';

/// Pestaña 2: Historial de Goces de Vacaciones (Pantalla 09).
class RrhhVacationRecordsTab extends StatefulWidget {
  final List<RrhhVacationRecord> records;
  final bool isLoading;
  final VoidCallback onRefresh;
  final String? initialFilterEmployee;

  const RrhhVacationRecordsTab({
    super.key,
    required this.records,
    required this.isLoading,
    required this.onRefresh,
    this.initialFilterEmployee,
  });

  @override
  State<RrhhVacationRecordsTab> createState() => _RrhhVacationRecordsTabState();
}

class _RrhhVacationRecordsTabState extends State<RrhhVacationRecordsTab> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'TODOS';
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilterEmployee != null &&
        widget.initialFilterEmployee!.isNotEmpty) {
      _searchController.text = widget.initialFilterEmployee!;
    }
  }

  @override
  void didUpdateWidget(covariant RrhhVacationRecordsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFilterEmployee != oldWidget.initialFilterEmployee &&
        widget.initialFilterEmployee != null) {
      setState(() {
        _searchController.text = widget.initialFilterEmployee!;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RrhhVacationRecord> get _filteredRecords {
    return widget.records.where((r) {
      if (_selectedStatus != 'TODOS') {
        if (r.status.toLowerCase() != _selectedStatus.toLowerCase()) {
          return false;
        }
      }

      if (_selectedDateRange != null) {
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end;
        if (r.endDate.isBefore(start) || r.startDate.isAfter(end)) {
          return false;
        }
      }

      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchesCode = r.code.toLowerCase().contains(query);
        final matchesName = r.employeeName.toLowerCase().contains(query);
        final matchesEmpCode = r.employeeCode.toLowerCase().contains(query);
        final matchesNotes = r.notes?.toLowerCase().contains(query) ?? false;
        if (!matchesCode && !matchesName && !matchesEmpCode && !matchesNotes) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'TODOS';
      _selectedDateRange = null;
    });
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        _selectedStatus != 'TODOS' ||
        _selectedDateRange != null;
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now().add(const Duration(days: 60)),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              surface: Color(0xFF0F172A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _handleView(RrhhVacationRecord rec) {
    RrhhVacationDetailDrawer.show(
      context,
      rec.id,
      onModified: widget.onRefresh,
    );
  }

  Future<void> _handleStart(RrhhVacationRecord rec) async {
    try {
      await RrhhRepository.current.updateVacationStatus(
        rec.id,
        RrhhVacationRecordStatus.enCurso,
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Período ${rec.code} marcado en curso.',
      );
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al iniciar goce: $e');
    }
  }

  Future<void> _handleFinish(RrhhVacationRecord rec) async {
    try {
      await RrhhRepository.current.updateVacationStatus(
        rec.id,
        RrhhVacationRecordStatus.gozado,
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Período ${rec.code} finalizado exitosamente.',
      );
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al finalizar goce: $e');
    }
  }

  Future<void> _handleEdit(RrhhVacationRecord rec) async {
    final success = await RrhhVacationEditDialog.show(
      context,
      initialRecord: rec,
    );
    if (success == true) {
      widget.onRefresh();
    }
  }

  Future<void> _handleCancel(RrhhVacationRecord rec) async {
    final reasonCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.block_outlined,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cancelar Goce de Vacaciones',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Indica el motivo de la cancelación de ${rec.code} (${rec.employeeName}):',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 2,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Motivo de la cancelación...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 5) {
                    return 'Ingresa un motivo válido.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cerrar',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              'Confirmar Cancelación',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await RrhhRepository.current.updateVacationStatus(
          rec.id,
          RrhhVacationRecordStatus.cancelado,
          reason: reasonCtrl.text.trim(),
        );
        if (!mounted) return;
        RrhhSnackBar.showInfo(context, 'Período ${rec.code} cancelado.');
        widget.onRefresh();
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al cancelar: $e');
      }
    }
  }

  Future<void> _handleDelete(RrhhVacationRecord rec) async {
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
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
          '¿Estás seguro de eliminar permanentemente el registro ${rec.code}?\nEsta acción no se puede deshacer.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
            height: 1.4,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Eliminar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await RrhhRepository.current.deleteVacationRecord(rec.id);
        if (!mounted) return;
        RrhhSnackBar.showSuccess(
          context,
          'Registro ${rec.code} eliminado correctamente.',
        );
        widget.onRefresh();
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al eliminar: $e');
      }
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;

    return Column(
      children: [
        // Filtros
        _buildFiltersBar(),

        // Tabla
        Expanded(
          child: widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                )
              : filtered.isEmpty
              ? _buildEmptyState()
              : _buildTable(filtered),
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    final statusList = [
      {'label': 'Todos los estados', 'val': 'TODOS'},
      {'label': 'Programados', 'val': RrhhVacationRecordStatus.programado},
      {'label': 'En curso', 'val': RrhhVacationRecordStatus.enCurso},
      {'label': 'Gozados', 'val': RrhhVacationRecordStatus.gozado},
      {'label': 'Cancelados', 'val': RrhhVacationRecordStatus.cancelado},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          // Buscador
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por código, empleado o notas...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Filtro por Estado
          SizedBox(
            height: 38,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF0F172A),
                  value: _selectedStatus,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                  style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
                  items: statusList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['val'],
                      child: Text(item['label']!),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Filtro por Rango de Fechas
          SizedBox(
            height: 38,
            child: OutlinedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(
                Icons.calendar_today,
                size: 15,
                color: Color(0xFF60A5FA),
              ),
              label: Text(
                _selectedDateRange == null
                    ? 'Rango de fechas'
                    : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: _selectedDateRange == null
                      ? const Color(0xFF94A3B8)
                      : Colors.white,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          if (_hasActiveFilters)
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(
                Icons.clear_all,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
              label: Text(
                'Limpiar',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTable(List<RrhhVacationRecord> list) {
    const minTableWidth = 980.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth > minTableWidth
            ? constraints.maxWidth
            : minTableWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                _buildTableHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final rec = list[index];
                      return RrhhVacationRecordRow(
                        record: rec,
                        isEven: index % 2 == 0,
                        onView: () => _handleView(rec),
                        onStart: () => _handleStart(rec),
                        onFinish: () => _handleFinish(rec),
                        onEdit: () => _handleEdit(rec),
                        onCancel: () => _handleCancel(rec),
                        onDelete: () => _handleDelete(rec),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          _buildTh('CÓDIGO', 10),
          _buildTh('EMPLEADO', 22),
          _buildTh('PERÍODO', 20),
          _buildTh('DÍAS', 10),
          _buildTh('MODO CÓMPUTO', 12),
          _buildTh('ESTADO', 12),
          _buildTh('ACCIONES', 14, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildTh(String label, int flex, {TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history_outlined,
              size: 48,
              color: Color(0xFF334155),
            ),
            const SizedBox(height: 14),
            Text(
              'No se encontraron registros de vacaciones',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Intenta modificar los filtros de búsqueda o rango de fechas.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
