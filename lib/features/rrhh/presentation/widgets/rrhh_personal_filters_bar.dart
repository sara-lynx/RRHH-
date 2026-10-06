import 'dart:async';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Barra de filtros avanzados y buscador con debounce (300ms) para el Directorio de Personal.
/// Estilo homologado con el toolbar del módulo de Seguridad y CRM.
class RrhhPersonalFiltersBar extends StatefulWidget {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final String? selectedQuickStatus;
  final String? selectedType;
  final int? selectedAreaId;
  final String? selectedAvailability;
  final List<RrhhArea> areas;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onQuickStatusChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onAreaChanged;
  final ValueChanged<String?> onAvailabilityChanged;
  final VoidCallback onResetFilters;

  const RrhhPersonalFiltersBar({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.selectedQuickStatus,
    required this.selectedType,
    required this.selectedAreaId,
    required this.selectedAvailability,
    required this.areas,
    required this.onSearchChanged,
    required this.onQuickStatusChanged,
    required this.onTypeChanged,
    required this.onAreaChanged,
    required this.onAvailabilityChanged,
    required this.onResetFilters,
  });

  @override
  State<RrhhPersonalFiltersBar> createState() => _RrhhPersonalFiltersBarState();
}

class _RrhhPersonalFiltersBarState extends State<RrhhPersonalFiltersBar> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchInputChanged(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final query = text.trim();
      if (query.isEmpty || query.length >= 2) {
        widget.onSearchChanged(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveFilters =
        widget.selectedType != null ||
        widget.selectedAreaId != null ||
        widget.selectedAvailability != null ||
        _searchController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-tabs segmentados de filtro rápido: [Todos (N)] [Activos (N)] [Inactivos (N)]
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSegmentPill(
                label: 'Todos (${widget.totalCount})',
                isSelected:
                    widget.selectedQuickStatus == null ||
                    widget.selectedQuickStatus == 'TODOS',
                onTap: () => widget.onQuickStatusChanged(null),
              ),
              _buildSegmentPill(
                label: 'Activos (${widget.activeCount})',
                isSelected: widget.selectedQuickStatus == 'ACTIVO',
                onTap: () => widget.onQuickStatusChanged('ACTIVO'),
              ),
              _buildSegmentPill(
                label: 'Inactivos (${widget.inactiveCount})',
                isSelected: widget.selectedQuickStatus == 'INACTIVO',
                onTap: () => widget.onQuickStatusChanged('INACTIVO'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Barra de Controles y Filtros
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D111C),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 960;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildTypeDropdown(),
                        _buildAreaDropdown(),
                        _buildAvailabilityDropdown(),
                        if (hasActiveFilters) _buildClearButton(),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 3, child: _buildSearchField()),
                  const SizedBox(width: 10),
                  _buildTypeDropdown(),
                  const SizedBox(width: 8),
                  _buildAreaDropdown(),
                  const SizedBox(width: 8),
                  _buildAvailabilityDropdown(),
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 8),
                    _buildClearButton(),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: const Color(0xFF334155))
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchInputChanged,
        style: GoogleFonts.inter(
          fontSize: 12.5,
          color: const Color(0xFFF8FAFC),
        ),
        decoration: InputDecoration(
          hintText: 'Buscar colaborador por nombre, CI, cargo...',
          hintStyle: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 16,
            color: Color(0xFF64748B),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return _buildDropdownContainer(
      child: DropdownButton<String?>(
        value: widget.selectedType,
        isDense: true,
        underline: const SizedBox.shrink(),
        dropdownColor: const Color(0xFF0F172A),
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 18,
          color: Color(0xFF94A3B8),
        ),
        items: const [
          DropdownMenuItem(value: null, child: Text('Tipo: TODOS')),
          DropdownMenuItem(value: 'OFICINA', child: Text('Tipo: OFICINA')),
          DropdownMenuItem(value: 'CAMPO', child: Text('Tipo: CAMPO')),
        ],
        onChanged: widget.onTypeChanged,
        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFF8FAFC)),
      ),
    );
  }

  Widget _buildAreaDropdown() {
    final items = <DropdownMenuItem<int?>>[
      const DropdownMenuItem(value: null, child: Text('Área: TODAS')),
      ...widget.areas.map(
        (area) => DropdownMenuItem(
          value: area.id,
          child: Text(area.name),
        ),
      ),
    ];

    return _buildDropdownContainer(
      child: DropdownButton<int?>(
        value: widget.selectedAreaId,
        isDense: true,
        underline: const SizedBox.shrink(),
        dropdownColor: const Color(0xFF0F172A),
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 18,
          color: Color(0xFF94A3B8),
        ),
        items: items,
        onChanged: widget.onAreaChanged,
        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFF8FAFC)),
      ),
    );
  }

  Widget _buildAvailabilityDropdown() {
    return _buildDropdownContainer(
      child: DropdownButton<String?>(
        value: widget.selectedAvailability,
        isDense: true,
        underline: const SizedBox.shrink(),
        dropdownColor: const Color(0xFF0F172A),
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 18,
          color: Color(0xFF94A3B8),
        ),
        items: const [
          DropdownMenuItem(value: null, child: Text('Disponibilidad: TODAS')),
          DropdownMenuItem(value: 'DISPONIBLE', child: Text('DISPONIBLE')),
          DropdownMenuItem(value: 'ASIGNADO', child: Text('ASIGNADO')),
          DropdownMenuItem(value: 'CON_PERMISO', child: Text('CON PERMISO')),
          DropdownMenuItem(
            value: 'DE_VACACIONES',
            child: Text('DE VACACIONES'),
          ),
          DropdownMenuItem(value: 'SUSPENDIDO', child: Text('SUSPENDIDO')),
        ],
        onChanged: widget.onAvailabilityChanged,
        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFF8FAFC)),
      ),
    );
  }

  Widget _buildDropdownContainer({required Widget child}) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _buildClearButton() {
    return SizedBox(
      height: 36,
      child: IconButton(
        tooltip: 'Limpiar Filtros',
        icon: const Icon(
          Icons.filter_alt_off_outlined,
          size: 17,
          color: Color(0xFFEF4444),
        ),
        onPressed: () {
          _searchController.clear();
          widget.onResetFilters();
        },
      ),
    );
  }
}
