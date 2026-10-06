import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_area_edit_dialog.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Anchos calculados proporcionalmente para la tabla de Áreas Departamentales.
class _RrhhAreaTableWidths {
  final double codigo;
  final double nombre;
  final double descripcion;
  final double color;
  final double cargos;
  final double estado;
  final double acciones;
  final double total;

  _RrhhAreaTableWidths({
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.color,
    required this.cargos,
    required this.estado,
    required this.acciones,
  }) : total =
           codigo + nombre + descripcion + color + cargos + estado + acciones;

  factory _RrhhAreaTableWidths.calculate(double availableWidth) {
    const fixedWidth = 110.0 + 100.0 + 130.0 + 95.0 + 125.0; // 560.0
    const minNombre = 180.0;
    const minDesc = 220.0;
    const minTotal = fixedWidth + minNombre + minDesc; // 960.0

    final effectiveWidth = availableWidth > minTotal
        ? availableWidth
        : minTotal;
    final extra = effectiveWidth - minTotal;
    final nombre = minNombre + (extra * 0.40);
    final descripcion = minDesc + (extra * 0.60);

    return _RrhhAreaTableWidths(
      codigo: 110.0,
      nombre: nombre,
      descripcion: descripcion,
      color: 100.0,
      cargos: 130.0,
      estado: 95.0,
      acciones: 125.0,
    );
  }
}

/// Tab 1: Áreas Departamentales dentro de Estructura Organizacional.
class RrhhOrganizationTabAreas extends StatefulWidget {
  const RrhhOrganizationTabAreas({super.key});

  @override
  State<RrhhOrganizationTabAreas> createState() =>
      _RrhhOrganizationTabAreasState();
}

class _RrhhOrganizationTabAreasState extends State<RrhhOrganizationTabAreas> {
  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhArea> _areas = [];
  List<RrhhPosition> _positions = [];

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'ALL'; // 'ALL', 'ACTIVE', 'INACTIVE'

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
        repo.listAreas(),
        repo.listPositions(),
      ]);

      if (!mounted) return;
      setState(() {
        _areas = List<RrhhArea>.from(results[0] as List<RrhhArea>);
        _positions = List<RrhhPosition>.from(results[1] as List<RrhhPosition>);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar áreas departamentales: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openCreateArea() async {
    final created = await RrhhAreaEditDialog.show(
      context: context,
      existingAreas: _areas,
    );

    if (created != null) {
      try {
        final saved = await RrhhRepository.current.createArea(created);
        if (!mounted) return;
        setState(() {
          _areas = [..._areas, saved];
        });
        RrhhSnackBar.showSuccess(
          context,
          'Área "${saved.name}" creada exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al crear área: $e');
      }
    }
  }

  Future<void> _openEditArea(RrhhArea area) async {
    final activePositionsCount = _positions
        .where((p) => p.areaId == area.id && p.isActive)
        .length;
    final updated = await RrhhAreaEditDialog.show(
      context: context,
      area: area,
      existingAreas: _areas,
      activePositionsCount: activePositionsCount,
    );

    if (updated != null) {
      try {
        final saved = await RrhhRepository.current.updateArea(updated);
        if (!mounted) return;
        setState(() {
          final idx = _areas.indexWhere((a) => a.id == saved.id);
          if (idx != -1) _areas[idx] = saved;
        });
        RrhhSnackBar.showInfo(
          context,
          'Área "${saved.name}" actualizada exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al actualizar área: $e');
      }
    }
  }

  Future<void> _toggleAreaStatus(RrhhArea area) async {
    final activePositionsCount = _positions
        .where((p) => p.areaId == area.id && p.isActive)
        .length;

    if (area.isActive) {
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
              Icon(
                activePositionsCount > 0
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline,
                color: activePositionsCount > 0
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF60A5FA),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Desactivar Área',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Text(
            activePositionsCount > 0
                ? 'El área "${area.name}" tiene $activePositionsCount cargo(s) activo(s) asociado(s).\n\n¿Desea desactivarla de todos modos? Los colaboradores y cargos mantendrán su relación pero el área no se ofrecerá para nuevas contrataciones.'
                : '¿Confirma que desea desactivar el área "${area.name}"?',
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
      final updated = area.copyWith(
        isActive: !area.isActive,
        updatedAt: DateTime.now(),
      );
      final saved = await RrhhRepository.current.updateArea(updated);

      if (!mounted) return;
      setState(() {
        final idx = _areas.indexWhere((a) => a.id == saved.id);
        if (idx != -1) _areas[idx] = saved;
      });

      if (saved.isActive) {
        RrhhSnackBar.showSuccess(
          context,
          'Área "${saved.name}" reactivada',
        );
      } else {
        RrhhSnackBar.showInfo(
          context,
          'Área "${saved.name}" desactivada',
        );
      }
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cambiar estado: $e');
    }
  }

  Color _parseHex(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF2563EB);
    final clean = hex.replaceAll('#', '');
    try {
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return RrhhErrorState(errorMessage: _errorMessage, onRetry: _loadData);
    }

    final filtered = _areas.where((a) {
      if (_statusFilter == 'ACTIVE' && !a.isActive) return false;
      if (_statusFilter == 'INACTIVE' && a.isActive) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return a.name.toLowerCase().contains(q) ||
          a.code.toLowerCase().contains(q);
    }).toList();

    final totalCount = _areas.length;
    final activeCount = _areas.where((a) => a.isActive).length;
    final inactiveCount = totalCount - activeCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 48.0;
        final widths = _RrhhAreaTableWidths.calculate(contentWidth - 32.0);
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
                              title: 'No se encontraron áreas departamentales',
                              description:
                                  'Intente ajustando el término de búsqueda o el filtro de estado.',
                              icon: Icons.corporate_fare_outlined,
                            ),
                          )
                        else
                          ...filtered.map(
                            (area) => _RrhhAreaTableRow(
                              area: area,
                              widths: widths,
                              positionsCount: _positions
                                  .where(
                                    (p) => p.areaId == area.id && p.isActive,
                                  )
                                  .length,
                              parseHex: _parseHex,
                              onEdit: () => _openEditArea(area),
                              onToggleStatus: () => _toggleAreaStatus(area),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (!_isLoading && _areas.isNotEmpty)
                Text(
                  'Mostrando ${filtered.length} de $totalCount áreas departamentales',
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
              'Áreas Departamentales',
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
              'Departamentos, divisiones corporativas y centros organizacionales',
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
          onPressed: _openCreateArea,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            'Nueva Área',
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
          // Buscador
          SizedBox(
            width: 280,
            height: 38,
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar por código o nombre...',
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

          // Filtro por Estado
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterChip('Todos ($total)', 'ALL'),
              const SizedBox(width: 6),
              _buildFilterChip('Activas ($active)', 'ACTIVE'),
              const SizedBox(width: 6),
              _buildFilterChip('Inactivas ($inactive)', 'INACTIVE'),
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

  Widget _buildTableHeader(_RrhhAreaTableWidths widths) {
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
          _buildTh('NOMBRE DEL ÁREA', widths.nombre),
          _buildTh('DESCRIPCIÓN', widths.descripcion),
          _buildTh('COLOR', widths.color),
          _buildTh('CARGOS ASOC.', widths.cargos),
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

  Widget _buildSkeletonRows(_RrhhAreaTableWidths widths) {
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

/// Fila individual con hover e interactividad para la tabla de áreas.
class _RrhhAreaTableRow extends StatefulWidget {
  final RrhhArea area;
  final _RrhhAreaTableWidths widths;
  final int positionsCount;
  final Color Function(String?) parseHex;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _RrhhAreaTableRow({
    required this.area,
    required this.widths,
    required this.positionsCount,
    required this.parseHex,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  State<_RrhhAreaTableRow> createState() => _RrhhAreaTableRowState();
}

class _RrhhAreaTableRowState extends State<_RrhhAreaTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.area;
    final w = widget.widths;
    final color = widget.parseHex(a.colorTag);

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
                a.code,
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
                a.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Descripción
            SizedBox(
              width: w.descripcion,
              child: Text(
                a.description ?? '—',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Color
            SizedBox(
              width: w.color,
              child: Row(
                children: [
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    a.colorTag ?? '—',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            // Cargos Asociados
            SizedBox(
              width: w.cargos,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.badge_outlined,
                        size: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.positionsCount} cargos',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Estado (Activo / Inactivo)
            SizedBox(
              width: w.estado,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      (a.isActive
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
                        color: a.isActive
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      a.isActive ? 'Activo' : 'Inactivo',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: a.isActive
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
                                a.isActive
                                    ? Icons.block_flipped
                                    : Icons.check_circle_outline,
                                size: 15,
                                color: a.isActive
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                a.isActive ? 'Desactivar Área' : 'Activar Área',
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
