import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_disciplinary_detail_drawer.dart';
import 'rrhh_disciplinary_edit_dialog.dart';
import 'rrhh_disciplinary_record_row.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_snack_bar.dart';

/// PANTALLA 10: Incidencias y Disciplina (Bloque 3: Novedades Laborales).
/// Gestión de faltas, procesos con descargo y régimen sancionatorio según la LGT Bolivia.
class RrhhDisciplinaryView extends StatefulWidget {
  const RrhhDisciplinaryView({super.key});

  @override
  State<RrhhDisciplinaryView> createState() => _RrhhDisciplinaryViewState();
}

class _RrhhDisciplinaryViewState extends State<RrhhDisciplinaryView> {
  bool _isLoading = true;
  String? _errorMessage;
  List<RrhhDisciplinaryRecord> _records = [];

  // Filtros
  final TextEditingController _searchController = TextEditingController();
  String _selectedFaultType =
      'TODOS'; // 'TODOS' | 'leve' | 'grave' | 'gravisima'
  String _selectedSanction =
      'TODAS'; // 'TODAS' | 'verbal' | 'escrita' | 'pecuniaria' | 'suspension' | 'retiro'
  String _selectedStatus =
      'TODOS'; // 'TODOS' | 'registrada' | 'en_descargo' | 'sancionada' | 'apelada' | 'archivada' | 'cerrada'
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
      final list = await repo.listDisciplinaryRecords();
      if (!mounted) return;
      setState(() {
        _records = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar registros disciplinarios: $e';
        _isLoading = false;
      });
    }
  }

  // --- FILTRADO EN MEMORIA ---

  List<RrhhDisciplinaryRecord> get _filteredRecords {
    return _records.where((item) {
      // 1. Buscador
      final q = _searchController.text.trim().toLowerCase();
      if (q.isNotEmpty) {
        final matchCode = item.code.toLowerCase().contains(q);
        final matchName = item.employeeName.toLowerCase().contains(q);
        final matchEmpCode = item.employeeCode.toLowerCase().contains(q);
        final matchDesc = item.incidentDescription.toLowerCase().contains(q);
        if (!matchCode && !matchName && !matchEmpCode && !matchDesc) {
          return false;
        }
      }

      // 2. Filtro por tipo de falta
      if (_selectedFaultType != 'TODOS') {
        if (item.faultType.toLowerCase() != _selectedFaultType.toLowerCase()) {
          return false;
        }
      }

      // 3. Filtro por sanción
      if (_selectedSanction != 'TODAS') {
        if (item.sanctionType == null ||
            item.sanctionType!.toLowerCase() !=
                _selectedSanction.toLowerCase()) {
          return false;
        }
      }

      // 4. Filtro por estado
      if (_selectedStatus != 'TODOS') {
        if (item.status.toLowerCase() != _selectedStatus.toLowerCase()) {
          return false;
        }
      }

      // 5. Filtro por rango de fechas del hecho
      if (_selectedDateRange != null) {
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end;
        if (item.incidentDate.isBefore(start) ||
            item.incidentDate.isAfter(end.add(const Duration(days: 1)))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        _selectedFaultType != 'TODOS' ||
        _selectedSanction != 'TODAS' ||
        _selectedStatus != 'TODOS' ||
        _selectedDateRange != null;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedFaultType = 'TODOS';
      _selectedSanction = 'TODAS';
      _selectedStatus = 'TODOS';
      _selectedDateRange = null;
    });
  }

  // --- KPIs CALCULADOS ---

  int get _activeSanctionsCount {
    return _records
        .where((r) => r.status == RrhhDisciplinaryStatus.sancionada)
        .length;
  }

  int get _inProgressProcessesCount {
    return _records
        .where(
          (r) =>
              r.status == RrhhDisciplinaryStatus.registrada ||
              r.status == RrhhDisciplinaryStatus.enDescargo ||
              r.status == RrhhDisciplinaryStatus.apelada,
        )
        .length;
  }

  // --- ACCIONES CRUD / DIALOGS ---

  Future<void> _handleRegisterNew() async {
    final success = await RrhhDisciplinaryEditDialog.show(context);
    if (success == true) {
      await _loadData();
    }
  }

  void _openDetailDrawer(RrhhDisciplinaryRecord item) {
    RrhhDisciplinaryDetailDrawer.show(
      context,
      item.id,
      onModified: _loadData,
    );
  }

  Future<void> _handleArchive(RrhhDisciplinaryRecord item) async {
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
              Icons.archive_outlined,
              color: Color(0xFF10B981),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Archivar Expediente',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Desea archivar el expediente ${item.code} sin sanción aplicada para ${item.employeeName}?',
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
              backgroundColor: const Color(0xFF10B981),
            ),
            child: Text(
              'Archivar',
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
        await RrhhRepository.current.updateDisciplinaryStatus(
          item.id,
          RrhhDisciplinaryStatus.archivada,
          reason: 'Archivado sin sanción',
        );
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Incidencia ${item.code} archivada sin sanción.',
          );
        }
        await _loadData();
      } catch (e) {
        if (mounted) RrhhSnackBar.showError(context, 'Error al archivar: $e');
      }
    }
  }

  Future<void> _handleDelete(RrhhDisciplinaryRecord item) async {
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
        await RrhhRepository.current.deleteDisciplinaryRecord(item.id);
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
    final activeCount = _activeSanctionsCount;
    final inProgressCount = _inProgressProcessesCount;
    final archivedCount = _records
        .where(
          (r) =>
              r.status == RrhhDisciplinaryStatus.archivada ||
              r.status == RrhhDisciplinaryStatus.cerrada,
        )
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
              // 1. Header de Sección (Idéntico a Image 2: Cargos de Trabajo / + Nuevo Cargo)
              _buildSectionHeader(),
              const SizedBox(height: 14),

              // 2. Barra de Filtros en Card redondeada
              _buildFiltersBar(
                totalCount,
                activeCount,
                inProgressCount,
                archivedCount,
              ),
              const SizedBox(height: 14),

              // 3. Tabla dentro de Card redondeada
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
                        _buildTableHeader(),
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          )
                        else if (filtered.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.inbox_outlined,
                                    size: 48,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _hasActiveFilters
                                        ? 'No se encontraron incidencias que coincidan con los filtros aplicados.'
                                        : 'No hay incidencias disciplinarias registradas.',
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
                            (item) => RrhhDisciplinaryRecordRow(
                              record: item,
                              onTap: () => _openDetailDrawer(item),
                              onRegisterDischarge: () =>
                                  _openDetailDrawer(item),
                              onApplySanction: () => _openDetailDrawer(item),
                              onArchive: () => _handleArchive(item),
                              onDelete: () => _handleDelete(item),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Footer idéntico a Image 2
              const SizedBox(height: 14),
              if (!_isLoading && _records.isNotEmpty)
                Text(
                  'Mostrando ${filtered.length} de $totalCount incidencias disciplinarias',
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
              'Incidencias y Régimen Disciplinario',
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
              'Registro de faltas laborales, debidos procesos, descargos y sanciones aplicadas',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        RrhhPrimaryActionButton(
          label: 'Nueva Incidencia',
          onPressed: _handleRegisterNew,
        ),
      ],
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

  Widget _buildFiltersBar(int total, int active, int inProgress, int archived) {
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
                    hintText: 'Buscar empleado o código INC...',
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

              // Dropdown Sanción
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
                    value: _selectedSanction,
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
                      'Todas las sanciones',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12.5,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'TODAS',
                        child: Text('Todas las sanciones'),
                      ),
                      DropdownMenuItem(
                        value: RrhhSanctionTypes.verbal,
                        child: Text('Amonestación verbal'),
                      ),
                      DropdownMenuItem(
                        value: RrhhSanctionTypes.escrita,
                        child: Text('Amonestación escrita'),
                      ),
                      DropdownMenuItem(
                        value: RrhhSanctionTypes.pecuniaria,
                        child: Text('Sanción pecuniaria'),
                      ),
                      DropdownMenuItem(
                        value: RrhhSanctionTypes.suspension,
                        child: Text('Suspensión sin goce'),
                      ),
                      DropdownMenuItem(
                        value: RrhhSanctionTypes.retiro,
                        child: Text('Retiro / Destitución'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSanction = val);
                    },
                  ),
                ),
              ),

              // Dropdown Tipo Falta
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
                    value: _selectedFaultType,
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
                      'Todas las faltas',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12.5,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'TODOS',
                        child: Text('Todas las faltas'),
                      ),
                      DropdownMenuItem(
                        value: RrhhFaultTypes.leve,
                        child: Text('Falta Leve'),
                      ),
                      DropdownMenuItem(
                        value: RrhhFaultTypes.grave,
                        child: Text('Falta Grave'),
                      ),
                      DropdownMenuItem(
                        value: RrhhFaultTypes.gravisima,
                        child: Text('Falta Gravísima'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedFaultType = val);
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

          // Filtro por Estado (Pills estilo Image 2)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterChip('Todos ($total)', 'TODOS'),
              const SizedBox(width: 6),
              _buildFilterChip(
                'Sancionadas ($active)',
                RrhhDisciplinaryStatus.sancionada,
              ),
              const SizedBox(width: 6),
              _buildFilterChip(
                'En descargo ($inProgress)',
                RrhhDisciplinaryStatus.enDescargo,
              ),
              const SizedBox(width: 6),
              _buildFilterChip(
                'Cerradas ($archived)',
                RrhhDisciplinaryStatus.cerrada,
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
          SizedBox(
            width: 95,
            child: Text('FECHA HECHO', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text('TIPO FALTA', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text('SANCIÓN', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 115,
            child: Text('ESTADO', style: _headerStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 85,
            child: Center(child: Text('SUSPENSIÓN', style: _headerStyle)),
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
