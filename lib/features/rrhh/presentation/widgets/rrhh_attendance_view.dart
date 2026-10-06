import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_attendance_detail_drawer.dart';
import 'rrhh_attendance_kpis.dart';
import 'rrhh_attendance_record_row.dart';
import 'rrhh_state_widgets.dart';

/// Vista consolidada de Asistencia de Campo (Pantalla 13 — Bloque 4).
///
/// Pantalla de solo lectura para RRHH que consume los registros sincronizados
/// desde la APK móvil del personal operativo de campo de Operaciones.
class RrhhAttendanceView extends StatefulWidget {
  final RrhhRepository? repository;
  final VoidCallback? onNavigateToIncidents;

  const RrhhAttendanceView({
    super.key,
    this.repository,
    this.onNavigateToIncidents,
  });

  @override
  State<RrhhAttendanceView> createState() => _RrhhAttendanceViewState();
}

class _RrhhAttendanceViewState extends State<RrhhAttendanceView> {
  late final RrhhRepository _repository;

  bool _isLoading = true;
  String? _errorMessage;
  List<RrhhAttendanceRecord> _records = [];

  // Filtros
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String _selectedStatus = 'TODOS';
  String _selectedClient = 'TODOS';
  String _selectedService = 'TODOS';

  final TextEditingController _searchController = TextEditingController();

  // Registro seleccionado para el Drawer lateral
  RrhhAttendanceRecord? _selectedRecord;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? RrhhRepository.current;
    _loadRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _repository.listAttendanceRecords(
        query: _searchQuery,
        dateRange: _selectedDateRange,
        status: _selectedStatus == 'TODOS' ? null : _selectedStatus,
        clientName: _selectedClient == 'TODOS' ? null : _selectedClient,
        serviceName: _selectedService == 'TODOS' ? null : _selectedService,
      );

      if (mounted) {
        setState(() {
          _records = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar registros de asistencia: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleExportReport() async {
    try {
      final csvData = await _repository.exportAttendanceReport(
        query: _searchQuery,
        dateRange: _selectedDateRange,
        status: _selectedStatus == 'TODOS' ? null : _selectedStatus,
        clientName: _selectedClient == 'TODOS' ? null : _selectedClient,
      );

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
                'Reporte de Asistencia Generado',
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
                'Se generó el consolidado de asistencia (${_records.length} registros) en formato tabular CSV para nómina.',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Text(
                  '${csvData.split('\n').take(4).join('\n')}\n...',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Descargando archivo asistencia_campo_export.csv...',
                    ),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('Descargar CSV'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar reporte: $e'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedDateRange = null;
      _selectedStatus = 'TODOS';
      _selectedClient = 'TODOS';
      _selectedService = 'TODOS';
    });
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Compacto
                _buildHeader(),
                const SizedBox(height: 14),

                // 2. Panel de KPIs
                RrhhAttendanceKpis(records: _records),
                const SizedBox(height: 14),

                // 3. Barra de Filtros
                _buildFiltersBar(),
                const SizedBox(height: 14),

                // 4. Tabla de Registros
                _buildTableCard(),
              ],
            ),
          ),

          // Drawer lateral si hay registro seleccionado
          if (_selectedRecord != null) ...[
            GestureDetector(
              onTap: () => setState(() => _selectedRecord = null),
              child: Container(
                color: Colors.black45,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: RrhhAttendanceDetailDrawer(
                record: _selectedRecord!,
                onClose: () => setState(() => _selectedRecord = null),
                onNavigateToIncidents: widget.onNavigateToIncidents,
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
                    'Asistencia de Campo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF8FAFC),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Solo lectura',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Consulta de asistencia registrada por Operaciones/APK (solo lectura)',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _handleExportReport,
          icon: const Icon(
            Icons.download_rounded,
            size: 14,
            color: Color(0xFF94A3B8),
          ),
          label: Text(
            'Exportar reporte',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFCBD5E1),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF334155)),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            backgroundColor: const Color(0xFF0D111C),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    final hasActiveFilters =
        _searchQuery.isNotEmpty ||
        _selectedDateRange != null ||
        _selectedStatus != 'TODOS' ||
        _selectedClient != 'TODOS' ||
        _selectedService != 'TODOS';

    final clients = [
      'TODOS',
      'Banco Mercantil Santa Cruz',
      'Kolping Bolivia',
      'Ventura Mall',
      'Manzana 40 Plaza Empresarial',
      'Fancesa Cemento',
      'Hipermaxi Los Pozos',
    ];

    final services = [
      'TODOS',
      'Seguridad Física Bancaria',
      'Limpieza y Desinfección',
      'Seguridad y Vigilancia',
      'Limpieza Integral',
      'Custodia y Control de Accesos',
      'Seguridad Operativa Retail',
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Buscador + Rango de fechas + Clientes + Servicios
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Buscador
                  SizedBox(
                    width: isNarrow ? constraints.maxWidth : 280,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar empleado, cliente...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF161F30),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        _searchQuery = val;
                        _loadRecords();
                      },
                    ),
                  ),

                  // Selector de rango de fechas
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2030),
                        initialDateRange:
                            _selectedDateRange ??
                            DateTimeRange(
                              start: DateTime(2026, 9, 20),
                              end: DateTime(2026, 9, 26),
                            ),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
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
                        _loadRecords();
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    label: Text(
                      _selectedDateRange != null
                          ? '${DateFormat('dd/MM').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM').format(_selectedDateRange!.end)}'
                          : 'Rango de fechas',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _selectedDateRange != null
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _selectedDateRange != null
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF1E293B),
                      ),
                      backgroundColor: const Color(0xFF161F30),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  // Dropdown Cliente
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161F30),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedClient,
                        dropdownColor: const Color(0xFF0F172A),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFFCBD5E1),
                        ),
                        items: clients.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c == 'TODOS' ? 'Cliente: Todos' : c),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedClient = val);
                            _loadRecords();
                          }
                        },
                      ),
                    ),
                  ),

                  // Dropdown Servicio
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161F30),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedService,
                        dropdownColor: const Color(0xFF0F172A),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFFCBD5E1),
                        ),
                        items: services.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s == 'TODOS' ? 'Servicio: Todos' : s),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedService = val);
                            _loadRecords();
                          }
                        },
                      ),
                    ),
                  ),

                  if (hasActiveFilters)
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(
                        Icons.clear_rounded,
                        size: 14,
                        color: Color(0xFFEF4444),
                      ),
                      label: Text(
                        'Limpiar filtros',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 10),

          // Fila 2: Chips / Pills de Estado
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilterPill('TODOS', 'Todos'),
                const SizedBox(width: 8),
                _buildStatusFilterPill(
                  RrhhAttendanceStatus.presente,
                  'Presentes',
                ),
                const SizedBox(width: 8),
                _buildStatusFilterPill(
                  RrhhAttendanceStatus.tarde,
                  'Con Tardanza',
                ),
                const SizedBox(width: 8),
                _buildStatusFilterPill(
                  RrhhAttendanceStatus.ausente,
                  'Ausentes',
                ),
                const SizedBox(width: 8),
                _buildStatusFilterPill(
                  RrhhAttendanceStatus.justificado,
                  'Justificados',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterPill(String statusKey, String label) {
    final isSelected = _selectedStatus.toUpperCase() == statusKey.toUpperCase();

    return InkWell(
      onTap: () {
        setState(() => _selectedStatus = statusKey);
        _loadRecords();
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF161F30),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF1E293B),
          ),
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

  Widget _buildTableCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const minWidth = 1180.0;
          final tableWidth = constraints.maxWidth > minWidth
              ? constraints.maxWidth
              : minWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scroll horizontal solo si la pantalla es menor a 1180px
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      // Header de columnas
                      _buildTableHeader(),

                      // Filas de datos
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        )
                      else if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: RrhhErrorState(
                            errorMessage: _errorMessage!,
                            onRetry: _loadRecords,
                          ),
                        )
                      else if (_records.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.inbox_outlined,
                                  size: 40,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No se encontraron registros de asistencia de campo',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Intenta modificar los filtros de búsqueda o el rango de fechas.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _records.length,
                          itemBuilder: (context, index) {
                            final item = _records[index];
                            return RrhhAttendanceRecordRow(
                              record: item,
                              isEven: index.isEven,
                              onTap: () {
                                setState(() => _selectedRecord = item);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Footer de la tabla
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF0D111C),
                  border: Border(top: BorderSide(color: Color(0xFF1E293B))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mostrando ${_records.length} jornadas consolidadas desde la APK móvil',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Sincronización en tiempo real · Operaciones',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF111726),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildColumnHeader('FECHA', flex: 9),
          _buildColumnHeader('EMPLEADO', flex: 20),
          _buildColumnHeader('CLIENTE / SERVICIO', flex: 18),
          _buildColumnHeader('SEDE', flex: 13),
          _buildColumnHeader('ENTRADA (P/R)', flex: 9),
          _buildColumnHeader('SALIDA (P/R)', flex: 9),
          _buildColumnHeader('HORAS', flex: 7),
          _buildColumnHeader('TARDANZA', flex: 11),
          _buildColumnHeader('ESTADO', flex: 11),
          _buildColumnHeader('OBSERVACIONES', flex: 18),
          _buildColumnHeader(
            'ACCIONES',
            flex: 7,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(
    String label, {
    required int flex,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
