import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_shift.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_shift_edit_dialog.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Anchos proporcionales calculados para la tabla de Turnos de Trabajo.
class _RrhhShiftTableWidths {
  final double codigo;
  final double nombre;
  final double horario;
  final double duracion;
  final double dias;
  final double tipo;
  final double empleados;
  final double estado;
  final double acciones;
  final double total;

  _RrhhShiftTableWidths({
    required this.codigo,
    required this.nombre,
    required this.horario,
    required this.duracion,
    required this.dias,
    required this.tipo,
    required this.empleados,
    required this.estado,
    required this.acciones,
  }) : total =
           codigo +
           nombre +
           horario +
           duracion +
           dias +
           tipo +
           empleados +
           estado +
           acciones;

  factory _RrhhShiftTableWidths.calculate(double availableWidth) {
    const fixedWidth =
        110.0 + 115.0 + 85.0 + 145.0 + 105.0 + 95.0 + 100.0 + 125.0; // 880.0
    const minNombre = 180.0;
    const minTotal = fixedWidth + minNombre; // 1060.0

    final effectiveWidth = availableWidth > minTotal
        ? availableWidth
        : minTotal;
    final nombre = effectiveWidth - fixedWidth;

    return _RrhhShiftTableWidths(
      codigo: 110.0,
      nombre: nombre,
      horario: 115.0,
      duracion: 85.0,
      dias: 145.0,
      tipo: 105.0,
      empleados: 95.0,
      estado: 100.0,
      acciones: 125.0,
    );
  }
}

/// Tab 1: Turnos de Trabajo dentro de Turnos y Horarios Base (Pantalla 07).
class RrhhTurnosTabShifts extends StatefulWidget {
  const RrhhTurnosTabShifts({super.key});

  @override
  State<RrhhTurnosTabShifts> createState() => _RrhhTurnosTabShiftsState();
}

class _RrhhTurnosTabShiftsState extends State<RrhhTurnosTabShifts> {
  List<RrhhShift> _shifts = [];
  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _statusFilter = 'ALL'; // 'ALL', 'ACTIVE', 'INACTIVE'
  String _typeFilter = 'ALL'; // 'ALL', 'Completa', 'Parcial', 'Nocturna'
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShifts();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadShifts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final list = await RrhhRepository.current.listShifts();
      if (!mounted) return;
      setState(() {
        _shifts = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar turnos: $e';
      });
    }
  }

  void _openCreateShift() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhShiftEditDialog(
        onSaved: () {
          _loadShifts();
          RrhhSnackBar.showSuccess(
            context,
            'Turno de trabajo creado exitosamente',
          );
        },
      ),
    );
  }

  void _openEditShift(RrhhShift shift) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhShiftEditDialog(
        shift: shift,
        onSaved: () {
          _loadShifts();
          RrhhSnackBar.showInfo(
            context,
            'Turno "${shift.name}" actualizado exitosamente',
          );
        },
      ),
    );
  }

  Future<void> _toggleShiftStatus(RrhhShift shift) async {
    final willDeactivate = shift.isActive;

    if (willDeactivate) {
      final confirm = await showDialog<bool>(
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
                Icons.warning_amber_rounded,
                color: Color(0xFFF59E0B),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Desactivar Turno',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Está seguro de desactivar el turno "${shift.name}" (${shift.code})?',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              if (shift.assignedEmployeesCount > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Atención: Este turno cuenta con ${shift.assignedEmployeesCount} colaboradores asignados.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFFFDE68A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Desactivar',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    try {
      final updated = shift.copyWith(
        isActive: !shift.isActive,
        updatedAt: DateTime.now(),
      );
      final saved = await RrhhRepository.current.updateShift(updated);

      setState(() {
        final idx = _shifts.indexWhere((s) => s.id == saved.id);
        if (idx != -1) _shifts[idx] = saved;
      });

      if (!mounted) return;
      if (saved.isActive) {
        RrhhSnackBar.showSuccess(
          context,
          'Turno "${saved.name}" reactivado',
        );
      } else {
        RrhhSnackBar.showInfo(
          context,
          'Turno "${saved.name}" desactivado',
        );
      }
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cambiar estado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return RrhhErrorState(errorMessage: _error!, onRetry: _loadShifts);
    }

    final filtered = _shifts.where((s) {
      if (_statusFilter == 'ACTIVE' && !s.isActive) return false;
      if (_statusFilter == 'INACTIVE' && s.isActive) return false;
      if (_typeFilter != 'ALL' &&
          s.shiftType.toLowerCase() != _typeFilter.toLowerCase())
        return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.code.toLowerCase().contains(q) ||
          s.shiftType.toLowerCase().contains(q);
    }).toList();

    final totalCount = _shifts.length;
    final activeCount = _shifts.where((s) => s.isActive).length;
    final inactiveCount = totalCount - activeCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 48.0;
        final widths = _RrhhShiftTableWidths.calculate(contentWidth - 32.0);
        final tableWidth = widths.total + 32.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 14),
              _buildFiltersBar(totalCount, activeCount, inactiveCount),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D111C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTableHeader(widths),
                        if (_isLoading)
                          _buildSkeletonRows(widths)
                        else if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: RrhhEmptyState(
                              title: 'No se encontraron turnos de trabajo',
                              description:
                                  'Intente ajustando el término de búsqueda o los filtros de jornada/estado.',
                              icon: Icons.schedule_outlined,
                            ),
                          )
                        else
                          ...filtered.map(
                            (sh) => _RrhhShiftTableRow(
                              shift: sh,
                              widths: widths,
                              onEdit: () => _openEditShift(sh),
                              onToggleStatus: () => _toggleShiftStatus(sh),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (!_isLoading && _shifts.isNotEmpty)
                Text(
                  'Mostrando ${filtered.length} de $totalCount turnos de trabajo',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turnos de Trabajo',
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
              'Bloques horarios reutilizables para la programación de personal',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: _openCreateShift,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            'Nuevo Turno',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersBar(int total, int active, int inactive) {
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
          // Buscador y Selector de Jornada
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 38,
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar turno...',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 12.5,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
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

              // Dropdown Jornada
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
                    value: _typeFilter,
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
                    items: const [
                      DropdownMenuItem(
                        value: 'ALL',
                        child: Text('Todas las jornadas'),
                      ),
                      DropdownMenuItem(
                        value: 'Completa',
                        child: Text('Completa'),
                      ),
                      DropdownMenuItem(
                        value: 'Parcial',
                        child: Text('Parcial'),
                      ),
                      DropdownMenuItem(
                        value: 'Nocturna',
                        child: Text('Nocturna'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _typeFilter = val);
                    },
                  ),
                ),
              ),
            ],
          ),

          // Filtro por Estado
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterChip('Todos ($total)', 'ALL'),
              const SizedBox(width: 6),
              _buildFilterChip('Activos ($active)', 'ACTIVE'),
              const SizedBox(width: 6),
              _buildFilterChip('Inactivos ($inactive)', 'INACTIVE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _statusFilter == value;
    return InkWell(
      onTap: () => setState(() => _statusFilter = value),
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
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF60A5FA)
                : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(_RrhhShiftTableWidths widths) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTh('CÓDIGO', widths.codigo),
          _buildTh('NOMBRE DEL TURNO', widths.nombre),
          _buildTh('HORARIO', widths.horario),
          _buildTh('DURACIÓN', widths.duracion),
          _buildTh('DÍAS', widths.dias),
          _buildTh('JORNADA', widths.tipo),
          _buildTh('EMPLEADOS', widths.empleados),
          _buildTh('ESTADO', widths.estado),
          _buildTh('ACCIONES', widths.acciones, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildTh(
    String title,
    double width, {
    TextAlign align = TextAlign.left,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSkeletonRows(_RrhhShiftTableWidths widths) {
    return Column(
      children: List.generate(
        4,
        (i) => Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
          ),
          child: Row(
            children: [
              Container(width: 80, height: 14, color: const Color(0xFF1E293B)),
              const SizedBox(width: 30),
              Container(width: 140, height: 14, color: const Color(0xFF1E293B)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fila individual con hover e interactividad para la tabla de turnos.
class _RrhhShiftTableRow extends StatefulWidget {
  final RrhhShift shift;
  final _RrhhShiftTableWidths widths;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _RrhhShiftTableRow({
    required this.shift,
    required this.widths,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  State<_RrhhShiftTableRow> createState() => _RrhhShiftTableRowState();
}

class _RrhhShiftTableRowState extends State<_RrhhShiftTableRow> {
  bool _isHovered = false;

  Color _getShiftTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'completa':
        return const Color(0xFF10B981);
      case 'parcial':
        return const Color(0xFF38BDF8);
      case 'nocturna':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.shift;
    final w = widget.widths;
    final typeColor = _getShiftTypeColor(s.shiftType);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF131C2E) : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: Color(0xFF1E293B), width: 0.8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Código (TURNO-XXX)
            SizedBox(
              width: w.codigo,
              child: Text(
                s.code,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF93C5FD),
                ),
              ),
            ),

            // Nombre
            SizedBox(
              width: w.nombre,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  s.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Horario (HH:mm - HH:mm)
            SizedBox(
              width: w.horario,
              child: Row(
                children: [
                  Icon(
                    s.isCrossMidnight
                        ? Icons.nights_stay_outlined
                        : Icons.access_time_rounded,
                    size: 13,
                    color: s.isCrossMidnight
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      s.formattedTimeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Duración
            SizedBox(
              width: w.duracion,
              child: Text(
                '${s.durationHours.toStringAsFixed(1)}h',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),

            // Días de la semana (L M X J V S D)
            SizedBox(
              width: w.dias,
              child: Row(
                children: [
                  _buildDayBadge('L', 1, s.workDays.contains(1)),
                  _buildDayBadge('M', 2, s.workDays.contains(2)),
                  _buildDayBadge('X', 3, s.workDays.contains(3)),
                  _buildDayBadge('J', 4, s.workDays.contains(4)),
                  _buildDayBadge('V', 5, s.workDays.contains(5)),
                  _buildDayBadge('S', 6, s.workDays.contains(6)),
                  _buildDayBadge('D', 7, s.workDays.contains(7)),
                ],
              ),
            ),

            // Tipo de Jornada (chip)
            SizedBox(
              width: w.tipo,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: typeColor.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    s.shiftType.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: typeColor,
                    ),
                  ),
                ),
              ),
            ),

            // Empleados Asignados
            SizedBox(
              width: w.empleados,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${s.assignedEmployeesCount} pers.',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            ),

            // Estado (Activo / Inactivo)
            SizedBox(
              width: w.estado,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (s.isActive
                                ? const Color(0xFF10B981)
                                : const Color(0xFF64748B))
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: s.isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFF64748B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        s.isActive ? 'Activo' : 'Inactivo',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: s.isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Acciones: [Editar] [⋯]
            SizedBox(
              width: w.acciones,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onEdit,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF60A5FA),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Editar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 15,
                        color: Color(0xFF64748B),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: const Color(0xFF0F172A),
                      onSelected: (val) {
                        if (val == 'toggle') widget.onToggleStatus();
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                s.isActive
                                    ? Icons.block_flipped
                                    : Icons.check_circle_outline,
                                size: 15,
                                color: s.isActive
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                s.isActive
                                    ? 'Desactivar Turno'
                                    : 'Activar Turno',
                                style: GoogleFonts.inter(fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBadge(String letter, int dayNumber, bool isIncluded) {
    final isWeekend = dayNumber == 6 || dayNumber == 7;
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        color: isIncluded
            ? (isWeekend ? const Color(0xFF8B5CF6) : const Color(0xFF2563EB))
            : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.inter(
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
          color: isIncluded ? Colors.white : const Color(0xFF64748B),
        ),
      ),
    );
  }
}
