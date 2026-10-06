import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_specialty_edit_dialog.dart';
import 'rrhh_state_widgets.dart';

/// Anchos proporcionales calculados para la tabla de Especialidades Operativas.
class _RrhhSpecialtyTableWidths {
  final double codigo;
  final double nombre;
  final double descripcion;
  final double color;
  final double estado;
  final double acciones;
  final double total;

  _RrhhSpecialtyTableWidths({
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.color,
    required this.estado,
    required this.acciones,
  }) : total = codigo + nombre + descripcion + color + estado + acciones;

  factory _RrhhSpecialtyTableWidths.calculate(double availableWidth) {
    const fixedWidth =
        110.0 +
        110.0 +
        95.0 +
        125.0; // codigo + color + estado + acciones = 440.0
    const minNombre = 190.0;
    const minDesc = 220.0;
    const minTotal = fixedWidth + minNombre + minDesc; // 850.0

    final effectiveWidth = availableWidth > minTotal
        ? availableWidth
        : minTotal;
    final extra = effectiveWidth - minTotal;
    final nombre = minNombre + (extra * 0.45);
    final descripcion = minDesc + (extra * 0.55);

    return _RrhhSpecialtyTableWidths(
      codigo: 110.0,
      nombre: nombre,
      descripcion: descripcion,
      color: 110.0,
      estado: 95.0,
      acciones: 125.0,
    );
  }
}

/// Tab 3: Especialidades Operativas dentro de Estructura Organizacional.
class RrhhOrganizationTabSpecialties extends StatefulWidget {
  const RrhhOrganizationTabSpecialties({super.key});

  @override
  State<RrhhOrganizationTabSpecialties> createState() =>
      _RrhhOrganizationTabSpecialtiesState();
}

class _RrhhOrganizationTabSpecialtiesState
    extends State<RrhhOrganizationTabSpecialties> {
  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhSpecialty> _specialties = [];

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
      final results = await repo.listSpecialties();

      if (!mounted) return;
      setState(() {
        _specialties = List<RrhhSpecialty>.from(results);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar especialidades: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openCreateSpecialty() async {
    final created = await RrhhSpecialtyEditDialog.show(
      context: context,
      existingSpecialties: _specialties,
    );

    if (created != null) {
      try {
        final saved = await RrhhRepository.current.createSpecialty(created);
        if (!mounted) return;
        setState(() {
          _specialties = [..._specialties, saved];
        });
        RrhhSnackBar.showSuccess(
          context,
          'Especialidad "${saved.name}" creada exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al crear especialidad: $e');
      }
    }
  }

  Future<void> _openEditSpecialty(RrhhSpecialty specialty) async {
    final updated = await RrhhSpecialtyEditDialog.show(
      context: context,
      specialty: specialty,
      existingSpecialties: _specialties,
    );

    if (updated != null) {
      try {
        final saved = await RrhhRepository.current.updateSpecialty(updated);
        if (!mounted) return;
        setState(() {
          final idx = _specialties.indexWhere((s) => s.id == saved.id);
          if (idx != -1) _specialties[idx] = saved;
        });
        RrhhSnackBar.showInfo(
          context,
          'Especialidad "${saved.name}" actualizada exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al actualizar especialidad: $e');
      }
    }
  }

  Future<void> _toggleSpecialtyStatus(RrhhSpecialty specialty) async {
    if (specialty.isActive) {
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
                'Desactivar Especialidad',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Text(
            '¿Confirma que desea desactivar la especialidad "${specialty.name}"? No se ofrecerá para nuevos colaboradores o postulantes.',
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
      final updated = specialty.copyWith(
        isActive: !specialty.isActive,
        updatedAt: DateTime.now(),
      );
      final saved = await RrhhRepository.current.updateSpecialty(updated);

      if (!mounted) return;
      setState(() {
        final idx = _specialties.indexWhere((s) => s.id == saved.id);
        if (idx != -1) _specialties[idx] = saved;
      });

      if (saved.isActive) {
        RrhhSnackBar.showSuccess(
          context,
          'Especialidad "${saved.name}" reactivada',
        );
      } else {
        RrhhSnackBar.showInfo(
          context,
          'Especialidad "${saved.name}" desactivada',
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

    final filtered = _specialties.where((s) {
      if (_statusFilter == 'ACTIVE' && !s.isActive) return false;
      if (_statusFilter == 'INACTIVE' && s.isActive) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.code.toLowerCase().contains(q);
    }).toList();

    final totalCount = _specialties.length;
    final activeCount = _specialties.where((s) => s.isActive).length;
    final inactiveCount = totalCount - activeCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 48.0;
        final widths = _RrhhSpecialtyTableWidths.calculate(contentWidth - 32.0);
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
                              title:
                                  'No se encontraron especialidades operativas',
                              description:
                                  'Intente ajustando el término de búsqueda o el filtro de estado.',
                              icon: Icons.workspace_premium_outlined,
                            ),
                          )
                        else
                          ...filtered.map(
                            (spec) => _RrhhSpecialtyTableRow(
                              specialty: spec,
                              widths: widths,
                              parseHex: _parseHex,
                              onEdit: () => _openEditSpecialty(spec),
                              onToggleStatus: () =>
                                  _toggleSpecialtyStatus(spec),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (!_isLoading && _specialties.isNotEmpty)
                Text(
                  'Mostrando ${filtered.length} de $totalCount especialidades operativas',
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
              'Especialidades Operativas',
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
              'Catálogo de competencias técnicas y especialidades laborales de campo',
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
          onPressed: _openCreateSpecialty,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            'Nueva Especialidad',
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
              _buildFilterChip('Todas ($total)', 'ALL'),
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

  Widget _buildTableHeader(_RrhhSpecialtyTableWidths widths) {
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
          _buildTh('NOMBRE DE ESPECIALIDAD', widths.nombre),
          _buildTh('DESCRIPCIÓN', widths.descripcion),
          _buildTh('COLOR', widths.color),
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

  Widget _buildSkeletonRows(_RrhhSpecialtyTableWidths widths) {
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

/// Fila individual con hover e interactividad para la tabla de especialidades.
class _RrhhSpecialtyTableRow extends StatefulWidget {
  final RrhhSpecialty specialty;
  final _RrhhSpecialtyTableWidths widths;
  final Color Function(String?) parseHex;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _RrhhSpecialtyTableRow({
    required this.specialty,
    required this.widths,
    required this.parseHex,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  State<_RrhhSpecialtyTableRow> createState() => _RrhhSpecialtyTableRowState();
}

class _RrhhSpecialtyTableRowState extends State<_RrhhSpecialtyTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.specialty;
    final w = widget.widths;
    final color = widget.parseHex(s.colorTag);

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
                s.code,
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
                s.name,
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
                s.description ?? '—',
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
                    s.colorTag ?? '—',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
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
                            : const Color(0xFF94A3B8),
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
                                    ? 'Desactivar Especialidad'
                                    : 'Activar Especialidad',
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
