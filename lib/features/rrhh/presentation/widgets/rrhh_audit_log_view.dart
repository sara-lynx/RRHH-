import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_audit_kpis.dart';
import 'rrhh_audit_log_detail_drawer.dart';
import 'rrhh_audit_log_event_row.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';

/// Vista principal de la Bitácora de Movimientos y Auditoría (Pantalla 14 — Bloque 4).
///
/// Log de auditoría consolidado e inmutable que registra todos los eventos y
/// novedades del módulo RRHH con filtros avanzados y trazabilidad profunda.
class RrhhAuditLogView extends StatefulWidget {
  final RrhhRepository? repository;

  const RrhhAuditLogView({
    super.key,
    this.repository,
  });

  @override
  State<RrhhAuditLogView> createState() => _RrhhAuditLogViewState();
}

class _RrhhAuditLogViewState extends State<RrhhAuditLogView> {
  late final RrhhRepository _repository;

  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhTimelineEvent> _events = [];
  List<String> _categories = [];
  List<String> _activeUsers = [];
  List<RrhhEmployeeSummaryDto> _employees = [];

  // Filtros
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String _selectedCategory = 'Todas';
  String _selectedUser = 'Todos';
  int? _selectedEmployeeId;

  final TextEditingController _searchController = TextEditingController();

  // Evento seleccionado para el Drawer lateral
  RrhhTimelineEvent? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? RrhhRepository.current;
    _initDefaultDateRange();
    _loadInitialData();
  }

  void _initDefaultDateRange() {
    final now = DateTime.now();
    // Default últimos 30 días
    _selectedDateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final categories = _repository.listTimelineCategories();
      final users = _repository.listActiveUsers();
      final emps = await _repository.listEmployees();

      if (mounted) {
        setState(() {
          _categories = categories;
          _activeUsers = users;
          _employees = emps;
        });
      }
      await _loadEvents();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al inicializar la bitácora: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _repository.listTimelineEvents(
        search: _searchQuery.trim().isEmpty ? null : _searchQuery.trim(),
        category: _selectedCategory == 'Todas' ? null : _selectedCategory,
        user: _selectedUser == 'Todos' ? null : _selectedUser,
        employeeId: _selectedEmployeeId,
        startDate: _selectedDateRange?.start,
        endDate: _selectedDateRange?.end,
      );

      if (mounted) {
        setState(() {
          _events = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar eventos de auditoría: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedCategory = 'Todas';
      _selectedUser = 'Todos';
      _selectedEmployeeId = null;
      _initDefaultDateRange();
    });
    _loadEvents();
  }

  bool get _hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _selectedCategory != 'Todas' ||
        _selectedUser != 'Todos' ||
        _selectedEmployeeId != null;
  }

  Future<void> _handleExportAuditLog() async {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm:ss');

    final buffer = StringBuffer();
    buffer.writeln(
      'Código,Fecha,Hora,Usuario,Categoría,Empleado,Título,Descripción,Referencia',
    );

    for (final e in _events) {
      final date = dateFormatter.format(e.date);
      final time = timeFormatter.format(e.date);
      final user = '"${e.registeredBy.replaceAll('"', '""')}"';
      final cat = '"${e.category.replaceAll('"', '""')}"';
      final emp =
          '"${(e.employeeName ?? (e.employeeId > 0 ? 'EMP-${e.employeeId}' : 'N/A')).replaceAll('"', '""')}"';
      final title = '"${e.title.replaceAll('"', '""')}"';
      final desc = '"${e.description.replaceAll('"', '""')}"';
      final ref = '"${(e.sourceCode ?? e.code).replaceAll('"', '""')}"';

      buffer.writeln('${e.code},$date,$time,$user,$cat,$emp,$title,$desc,$ref');
    }

    if (!mounted) return;

    showDialog(
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
              Icons.download_done_rounded,
              color: Color(0xFF10B981),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Bitácora de Auditoría Exportada',
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
              'Se preparó el libro consolidado de auditoría (${_events.length} eventos) con sello temporal y firma de integridad.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formato: CSV Oficial de Auditoría RRHH',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF93C5FD),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Registros: ${_events.length} eventos auditados',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    'Generado: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cerrar',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              RrhhSnackBar.showSuccess(
                context,
                'Bitácora de auditoría (${_events.length} registros) exportada exitosamente.',
              );
            },
            icon: const Icon(Icons.file_download_outlined, size: 16),
            label: Text(
              'Descargar Archivo',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Compacto
                _buildHeader(),
                const SizedBox(height: 18),

                // 2. Panel de Resumen (4 KPIs)
                RrhhAuditKpis(events: _events),
                const SizedBox(height: 18),

                // 3. Barra de Filtros
                _buildFiltersBar(),
                const SizedBox(height: 18),

                // 4. Tabla de Eventos Full-Width
                _buildTableCard(),
              ],
            ),
          ),

          // Drawer lateral si hay evento seleccionado
          if (_selectedEvent != null) ...[
            GestureDetector(
              onTap: () => setState(() => _selectedEvent = null),
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: RrhhAuditLogDetailDrawer(
                event: _selectedEvent!,
                onClose: () => setState(() => _selectedEvent = null),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bitácora de Movimientos',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF8FAFC),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF334155),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      'Trazabilidad Inmutable',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF93C5FD),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Registro completo de eventos del módulo RRHH',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _handleExportAuditLog,
          icon: const Icon(
            Icons.download_rounded,
            size: 15,
            color: Color(0xFF93C5FD),
          ),
          label: Text(
            'Exportar bitácora',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE2E8F0),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF334155)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color(0xFF0D111C),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final dateRangeLabel = _selectedDateRange == null
        ? 'Rango de fechas'
        : '${dateFormatter.format(_selectedDateRange!.start)} - ${dateFormatter.format(_selectedDateRange!.end)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Buscador de texto
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                    _loadEvents();
                  },
                  style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Buscar por código EVT, título, usuario o colaborador...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                              _loadEvents();
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1E293B)),
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
              const SizedBox(width: 12),

              // Rango de fechas
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2025, 1, 1),
                    lastDate: DateTime(2027, 12, 31),
                    initialDateRange:
                        _selectedDateRange ??
                        DateTimeRange(
                          start: DateTime.now().subtract(
                            const Duration(days: 30),
                          ),
                          end: DateTime.now(),
                        ),
                    builder: (ctx, child) {
                      return Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xFF2563EB),
                            onPrimary: Colors.white,
                            surface: Color(0xFF0F172A),
                            onSurface: Color(0xFFE2E8F0),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    setState(() => _selectedDateRange = picked);
                    _loadEvents();
                  }
                },
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
                label: Text(
                  dateRangeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _selectedDateRange != null
                        ? const Color(0xFF93C5FD)
                        : const Color(0xFFCBD5E1),
                    fontWeight: _selectedDateRange != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _selectedDateRange != null
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF1E293B),
                  ),
                  backgroundColor: const Color(0xFF090D16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila de Filtros Desplegables
          Row(
            children: [
              // Categoría
              Expanded(
                flex: 3,
                child: _buildFilterDropdown<String>(
                  label: 'Categoría',
                  value: _selectedCategory,
                  items: _categories.isEmpty ? ['Todas'] : _categories,
                  itemLabel: (cat) => RrhhTimelineCategory.getLabel(cat),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCategory = val);
                      _loadEvents();
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Usuario
              Expanded(
                flex: 3,
                child: _buildFilterDropdown<String>(
                  label: 'Usuario',
                  value: _selectedUser,
                  items: [
                    'Todos',
                    ..._activeUsers.where((u) => u != 'Todos').toSet(),
                  ],
                  itemLabel: (user) => user,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedUser = val);
                      _loadEvents();
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Empleado
              Expanded(
                flex: 4,
                child: _buildEmployeeFilterDropdown(),
              ),

              // Botón limpiar filtros
              if (_hasActiveFilters) ...[
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(
                    Icons.filter_alt_off_outlined,
                    size: 14,
                    color: Color(0xFFEF4444),
                  ),
                  label: Text(
                    'Limpiar filtros',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF87171),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          dropdownColor: const Color(0xFF0F172A),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: Color(0xFF64748B),
          ),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFFE2E8F0),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFE2E8F0),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEmployeeFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: _selectedEmployeeId,
          isExpanded: true,
          dropdownColor: const Color(0xFF0F172A),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: Color(0xFF64748B),
          ),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFFE2E8F0),
          ),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(
                'Todos los colaboradores',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFE2E8F0),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ..._employees.map((emp) {
              return DropdownMenuItem<int?>(
                value: emp.id,
                child: Text(
                  '${emp.code} · ${emp.fullName}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFE2E8F0),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: (val) {
            setState(() => _selectedEmployeeId = val);
            _loadEvents();
          },
        ),
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la tabla full-width
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: const BoxDecoration(
              color: Color(0xFF090D16),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              children: [
                _buildHeaderColumn('FECHA + HORA', flex: 12),
                _buildHeaderColumn('USUARIO', flex: 15),
                _buildHeaderColumn('CATEGORÍA', flex: 14),
                _buildHeaderColumn('EMPLEADO AFECTADO', flex: 16),
                _buildHeaderColumn('DESCRIPCIÓN', flex: 23),
                _buildHeaderColumn('CAMBIOS', flex: 11),
                _buildHeaderColumn('ACCIONES', flex: 9, alignRight: true),
              ],
            ),
          ),

          // Cuerpo de la tabla
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              ),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: RrhhErrorState(
                errorMessage: _errorMessage!,
                onRetry: _loadEvents,
              ),
            )
          else if (_events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.history_edu_outlined,
                      size: 40,
                      color: Color(0xFF475569),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No se encontraron eventos en la bitácora',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Intenta ajustar el rango de fechas, los filtros seleccionados o el término de búsqueda.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return RrhhAuditLogEventRow(
                  event: event,
                  isEven: index.isEven,
                  onTap: () => setState(() => _selectedEvent = event),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderColumn(
    String title, {
    required int flex,
    bool alignRight = false,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
