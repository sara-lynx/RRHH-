import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_position_edit_dialog.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Anchos proporcionales calculados para la tabla de Cargos de Trabajo.
class _RrhhPositionTableWidths {
  final double codigo;
  final double nombre;
  final double area;
  final double tipo;
  final double sueldo;
  final double estado;
  final double acciones;
  final double total;

  _RrhhPositionTableWidths({
    required this.codigo,
    required this.nombre,
    required this.area,
    required this.tipo,
    required this.sueldo,
    required this.estado,
    required this.acciones,
  }) : total = codigo + nombre + area + tipo + sueldo + estado + acciones;

  factory _RrhhPositionTableWidths.calculate(double availableWidth) {
    const fixedWidth = 110.0 + 95.0 + 155.0 + 95.0 + 125.0; // 580.0
    const minNombre = 190.0;
    const minArea = 170.0;
    const minTotal = fixedWidth + minNombre + minArea; // 940.0

    final effectiveWidth = availableWidth > minTotal
        ? availableWidth
        : minTotal;
    final extra = effectiveWidth - minTotal;
    final nombre = minNombre + (extra * 0.52);
    final area = minArea + (extra * 0.48);

    return _RrhhPositionTableWidths(
      codigo: 110.0,
      nombre: nombre,
      area: area,
      tipo: 95.0,
      sueldo: 155.0,
      estado: 95.0,
      acciones: 125.0,
    );
  }
}

/// Tab 2: Cargos de Trabajo dentro de Estructura Organizacional.
class RrhhOrganizationTabPositions extends StatefulWidget {
  final bool hasCompensationPermission;

  const RrhhOrganizationTabPositions({
    super.key,
    this.hasCompensationPermission = true,
  });

  @override
  State<RrhhOrganizationTabPositions> createState() =>
      _RrhhOrganizationTabPositionsState();
}

class _RrhhOrganizationTabPositionsState
    extends State<RrhhOrganizationTabPositions> {
  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhPosition> _positions = [];
  List<RrhhArea> _areas = [];

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'ALL'; // 'ALL', 'ACTIVE', 'INACTIVE'
  int? _areaFilter; // null = Todas las áreas

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final results = await Future.wait([
        repo.listPositions(),
        repo.listAreas(),
      ]);

      if (!mounted) return;
      setState(() {
        _positions = List<RrhhPosition>.from(results[0] as List<RrhhPosition>);
        _areas = List<RrhhArea>.from(results[1] as List<RrhhArea>);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar cargos de trabajo: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openCreatePosition() async {
    final activeAreas = _areas.where((a) => a.isActive).toList();
    if (activeAreas.isEmpty) {
      RrhhSnackBar.showError(
        context,
        'Debe existir al menos un área activa para crear un cargo',
      );
      return;
    }

    final created = await RrhhPositionEditDialog.show(
      context: context,
      availableAreas: activeAreas,
      existingPositions: _positions,
    );

    if (created != null) {
      try {
        final saved = await RrhhRepository.current.createPosition(created);
        if (!mounted) return;
        setState(() {
          _positions = [..._positions, saved];
        });
        RrhhSnackBar.showSuccess(
          context,
          'Cargo "${saved.name}" creado exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al crear cargo: $e');
      }
    }
  }

  Future<void> _openEditPosition(RrhhPosition position) async {
    final updated = await RrhhPositionEditDialog.show(
      context: context,
      position: position,
      availableAreas: _areas,
      existingPositions: _positions,
    );

    if (updated != null) {
      try {
        final saved = await RrhhRepository.current.updatePosition(updated);
        if (!mounted) return;
        setState(() {
          final idx = _positions.indexWhere((p) => p.id == saved.id);
          if (idx != -1) _positions[idx] = saved;
        });
        RrhhSnackBar.showInfo(
          context,
          'Cargo "${saved.name}" actualizado exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al actualizar cargo: $e');
      }
    }
  }

  Future<void> _togglePositionStatus(RrhhPosition position) async {
    if (position.isActive) {
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
                Icons.info_outline,
                color: Color(0xFF60A5FA),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Desactivar Cargo',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Text(
            '¿Confirma que desea desactivar el cargo "${position.name}"? No se ofrecerá para nuevas vacantes.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
              height: 1.45,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
                side: const BorderSide(color: Color(0xFF1E293B)),
              ),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              child: const Text('Desactivar'),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    try {
      final updated = position.copyWith(
        isActive: !position.isActive,
        updatedAt: DateTime.now(),
      );
      final saved = await RrhhRepository.current.updatePosition(updated);

      if (!mounted) return;
      setState(() {
        final idx = _positions.indexWhere((p) => p.id == saved.id);
        if (idx != -1) _positions[idx] = saved;
      });

      if (saved.isActive) {
        RrhhSnackBar.showSuccess(
          context,
          'Cargo "${saved.name}" reactivado',
        );
      } else {
        RrhhSnackBar.showInfo(
          context,
          'Cargo "${saved.name}" desactivado',
        );
      }
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cambiar estado: $e');
    }
  }

  String _formatSalary(double? salary) {
    if (!widget.hasCompensationPermission) return '••••••';
    if (salary == null || salary <= 0) return '—';
    final parts = salary.toStringAsFixed(2).split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Bs. $integerPart,${parts[1]}';
  }

  String _getAreaName(int areaId) {
    final area = _areas.where((a) => a.id == areaId).firstOrNull;
    return area?.name ?? 'Área #$areaId';
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return RrhhErrorState(errorMessage: _errorMessage, onRetry: _loadData);
    }

    final filtered = _positions.where((p) {
      if (_areaFilter != null && p.areaId != _areaFilter) return false;
      if (_statusFilter == 'ACTIVE' && !p.isActive) return false;
      if (_statusFilter == 'INACTIVE' && p.isActive) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final areaName = _getAreaName(p.areaId).toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q) ||
          areaName.contains(q);
    }).toList();

    final totalCount = _positions.length;
    final activeCount = _positions.where((p) => p.isActive).length;
    final inactiveCount = totalCount - activeCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 48.0;
        final widths = _RrhhPositionTableWidths.calculate(contentWidth - 32.0);
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
                              title: 'No se encontraron cargos de trabajo',
                              description:
                                  'Intente ajustando el término de búsqueda o los filtros de área/estado.',
                              icon: Icons.badge_outlined,
                            ),
                          )
                        else
                          ...filtered.map(
                            (pos) => _RrhhPositionTableRow(
                              position: pos,
                              widths: widths,
                              areaName: _getAreaName(pos.areaId),
                              formattedSalary: _formatSalary(
                                pos.suggestedSalary,
                              ),
                              onEdit: () => _openEditPosition(pos),
                              onToggleStatus: () => _togglePositionStatus(pos),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (!_isLoading && _positions.isNotEmpty)
                Text(
                  'Mostrando ${filtered.length} de $totalCount cargos de trabajo',
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
              'Cargos de Trabajo',
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
              'Puestos operativos de campo y perfiles administrativos de oficina',
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
          onPressed: _openCreatePosition,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            'Nuevo Cargo',
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
          // Buscador y Dropdown de Área
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
                    hintText: 'Buscar cargo o área...',
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

              // Dropdown Área Padre
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: _areaFilter,
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
                      'Todas las áreas',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12.5,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(
                          'Todas las áreas (${_areas.length})',
                          style: GoogleFonts.inter(fontSize: 12.5),
                        ),
                      ),
                      ..._areas.map(
                        (a) => DropdownMenuItem<int?>(
                          value: a.id,
                          child: Text(
                            a.name,
                            style: GoogleFonts.inter(fontSize: 12.5),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _areaFilter = val),
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

  Widget _buildTableHeader(_RrhhPositionTableWidths widths) {
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
          _buildTh('NOMBRE DEL CARGO', widths.nombre),
          _buildTh('ÁREA PADRE', widths.area),
          _buildTh('ENTORNO', widths.tipo),
          _buildTh('SUELDO SUGERIDO', widths.sueldo),
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

  Widget _buildSkeletonRows(_RrhhPositionTableWidths widths) {
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

/// Fila individual con hover e interactividad para la tabla de cargos.
class _RrhhPositionTableRow extends StatefulWidget {
  final RrhhPosition position;
  final _RrhhPositionTableWidths widths;
  final String areaName;
  final String formattedSalary;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _RrhhPositionTableRow({
    required this.position,
    required this.widths,
    required this.areaName,
    required this.formattedSalary,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  State<_RrhhPositionTableRow> createState() => _RrhhPositionTableRowState();
}

class _RrhhPositionTableRowState extends State<_RrhhPositionTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.position;
    final w = widget.widths;
    final isCampo = p.workplaceType.toUpperCase() == 'CAMPO';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF141D30) : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: Color(0xFF1E293B), width: 0.8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Código
            SizedBox(
              width: w.codigo,
              child: Text(
                p.code,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF60A5FA),
                ),
              ),
            ),

            // Nombre
            SizedBox(
              width: w.nombre,
              child: Text(
                p.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Área Padre
            SizedBox(
              width: w.area,
              child: Text(
                widget.areaName,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Tipo / Entorno (CAMPO / OFICINA)
            SizedBox(
              width: w.tipo,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color:
                      (isCampo
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFFA78BFA))
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:
                        (isCampo
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFA78BFA))
                            .withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  p.workplaceType.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isCampo
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFFA78BFA),
                  ),
                ),
              ),
            ),

            // Sueldo Sugerido
            SizedBox(
              width: w.sueldo,
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 12,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.formattedSalary,
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

            // Estado (Activo / Inactivo)
            SizedBox(
              width: w.estado,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      (p.isActive
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
                        color: p.isActive
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      p.isActive ? 'Activo' : 'Inactivo',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: p.isActive
                            ? const Color(0xFF34D399)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Acciones
            SizedBox(
              width: w.acciones,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onEdit,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF94A3B8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Editar',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF60A5FA),
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
                                p.isActive
                                    ? Icons.block_flipped
                                    : Icons.check_circle_outline,
                                size: 15,
                                color: p.isActive
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                p.isActive
                                    ? 'Desactivar Cargo'
                                    : 'Activar Cargo',
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
}
