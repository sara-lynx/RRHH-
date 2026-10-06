import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_leave_request_detail_drawer.dart';
import 'rrhh_leave_request_edit_dialog.dart';
import 'rrhh_leave_request_row.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_snack_bar.dart';

/// Vista raíz de Permisos y Licencias (Pantalla 08 — Bloque 3: Novedades Laborales).
/// Incluye header de sección, barra de filtros avanzados (búsqueda, tipo, estado, goce, fechas)
/// y tabla full-width con acciones y drawer lateral de detalle.
class RrhhLeaveRequestsView extends StatefulWidget {
  const RrhhLeaveRequestsView({super.key});

  @override
  State<RrhhLeaveRequestsView> createState() => _RrhhLeaveRequestsViewState();
}

class _RrhhLeaveRequestsViewState extends State<RrhhLeaveRequestsView> {
  bool _isLoading = true;
  String? _errorMessage;
  List<RrhhLeaveRequest> _allRequests = [];

  // Controladores y estados de filtros
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'TODOS';
  String _selectedType = 'TODOS';
  String _selectedPaidFilter = 'TODOS'; // 'TODOS' | 'PAGADOS' | 'NO_PAGADOS'
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
      final list = await repo.listLeaveRequests();
      if (!mounted) return;
      setState(() {
        _allRequests = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar las solicitudes de permiso: $e';
        _isLoading = false;
      });
    }
  }

  // Filtrado reactivo en memoria para máxima velocidad de respuesta en UI
  List<RrhhLeaveRequest> get _filteredRequests {
    return _allRequests.where((req) {
      // 1. Buscador
      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchCode = req.code.toLowerCase().contains(query);
        final matchName = req.employeeName.toLowerCase().contains(query);
        final matchEmpCode = req.employeeCode.toLowerCase().contains(query);
        final matchReason = req.reason.toLowerCase().contains(query);
        if (!matchCode && !matchName && !matchEmpCode && !matchReason) {
          return false;
        }
      }

      // 2. Filtro por tipo
      if (_selectedType != 'TODOS') {
        if (req.leaveType != _selectedType) return false;
      }

      // 3. Filtro por estado
      if (_selectedStatus != 'TODOS') {
        if (req.status != _selectedStatus) return false;
      }

      // 4. Filtro por goce de haberes
      if (_selectedPaidFilter == 'PAGADOS' && !req.isPaid) return false;
      if (_selectedPaidFilter == 'NO_PAGADOS' && req.isPaid) return false;

      // 5. Filtro por rango de fechas
      if (_selectedDateRange != null) {
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end;
        if (req.endDate.isBefore(start) || req.startDate.isAfter(end)) {
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
      _selectedType = 'TODOS';
      _selectedPaidFilter = 'TODOS';
      _selectedDateRange = null;
    });
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        _selectedStatus != 'TODOS' ||
        _selectedType != 'TODOS' ||
        _selectedPaidFilter != 'TODOS' ||
        _selectedDateRange != null;
  }

  // ===========================================================================
  // ACCIONES CRUD / RESOLUCIÓN DESDE LA TABLA
  // ===========================================================================

  void _openDetailDrawer(RrhhLeaveRequest req) {
    RrhhLeaveRequestDetailDrawer.show(
      context,
      req.id,
      onModified: _loadData,
    );
  }

  Future<void> _handleRegisterNew() async {
    final created = await RrhhLeaveRequestEditDialog.show(context);
    if (created == true) {
      await _loadData();
    }
  }

  Future<void> _handleEdit(RrhhLeaveRequest req) async {
    final updated = await RrhhLeaveRequestEditDialog.show(
      context,
      leave: req,
    );
    if (updated == true) {
      await _loadData();
    }
  }

  Future<void> _handleApprove(RrhhLeaveRequest req) async {
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
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Aprobar Solicitud',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Aprobar la solicitud ${req.code} de ${req.employeeName} por ${req.durationDays} día(s)?',
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
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Aprobar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await RrhhRepository.current.updateLeaveStatus(
        req.id,
        RrhhLeaveStatus.aprobado,
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Solicitud ${req.code} aprobada correctamente.',
      );
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al aprobar: $e');
    }
  }

  Future<void> _handleReject(RrhhLeaveRequest req) async {
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
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.cancel_outlined,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Rechazar Solicitud',
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
                'Indica el motivo por el cual se rechaza la solicitud ${req.code}:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Motivo del rechazo (mínimo 20 caracteres)...',
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                validator: (val) {
                  final text = val?.trim() ?? '';
                  if (text.length < 20) {
                    return 'El motivo debe tener al menos 20 caracteres (${text.length}/20)';
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
              'Cancelar',
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
              'Rechazar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await RrhhRepository.current.updateLeaveStatus(
        req.id,
        RrhhLeaveStatus.rechazado,
        reason: reasonCtrl.text.trim(),
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showWarning(context, 'Solicitud ${req.code} rechazada.');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al rechazar: $e');
    }
  }

  Future<void> _handleCancel(RrhhLeaveRequest req) async {
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
              'Cancelar Solicitud',
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
              if (req.isPaid) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF59E0B),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Este permiso fue pagado. Cancelarlo puede requerir ajuste en nómina.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFCD34D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Text(
                'Indica el motivo de la cancelación de la solicitud ${req.code}:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Motivo de la cancelación (obligatorio)...',
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'El motivo de cancelación es obligatorio';
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
              'Atrás',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              'Confirmar Cancelación',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await RrhhRepository.current.updateLeaveStatus(
        req.id,
        RrhhLeaveStatus.cancelado,
        reason: reasonCtrl.text.trim(),
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showInfo(context, 'Solicitud ${req.code} cancelada.');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cancelar: $e');
    }
  }

  Future<void> _handleDelete(RrhhLeaveRequest req) async {
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
              'Eliminar Solicitud',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de eliminar permanentemente la solicitud ${req.code} en estado Pendiente?\nEsta acción no se puede deshacer.',
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

    if (confirmed != true) return;

    try {
      await RrhhRepository.current.deleteLeaveRequest(req.id);
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Solicitud ${req.code} eliminada exitosamente.',
      );
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al eliminar: $e');
    }
  }

  // ===========================================================================
  // INTERFAZ DE USUARIO
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Column(
        children: [
          // 1. Barra de Filtros con [+ Registrar Permiso] integrado
          _buildFiltersBar(),

          // 2. Tabla y contenido
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  )
                : _errorMessage != null
                ? _buildErrorWidget()
                : _buildTableContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    final statusList = [
      {'label': 'Todos', 'val': 'TODOS'},
      {'label': 'Pendientes', 'val': RrhhLeaveStatus.pendiente},
      {'label': 'Aprobados', 'val': RrhhLeaveStatus.aprobado},
      {'label': 'En curso', 'val': RrhhLeaveStatus.enCurso},
      {'label': 'Finalizados', 'val': RrhhLeaveStatus.finalizado},
      {'label': 'Rechazados', 'val': RrhhLeaveStatus.rechazado},
      {'label': 'Cancelados', 'val': RrhhLeaveStatus.cancelado},
    ];

    final paidList = [
      {'label': 'Todos', 'val': 'TODOS'},
      {'label': 'Pagados', 'val': 'PAGADOS'},
      {'label': 'Sin goce', 'val': 'NO_PAGADOS'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B)),
          bottom: BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Buscador + Dropdown Tipo de Permiso + Selector de Rango de Fechas + Botón Limpiar
          Row(
            children: [
              // Buscador
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar por empleado, código PERM o motivo...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF64748B),
                        size: 18,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 16,
                                color: Color(0xFF94A3B8),
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
                        vertical: 0,
                        horizontal: 12,
                      ),
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
              ),
              const SizedBox(width: 12),

              // Dropdown Tipo de Permiso
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 38,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF0F172A),
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF111827),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1E293B)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1E293B)),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'TODOS',
                        child: Text(
                          'Todos los tipos de permiso',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ...RrhhLeaveTypes.all.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(
                            RrhhLeaveTypes.label(t),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Botón Selector de Rango de Fechas
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _selectedDateRange != null
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF94A3B8),
                  side: BorderSide(
                    color: _selectedDateRange != null
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF334155),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                ),
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                    initialDateRange: _selectedDateRange,
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color(0xFF2563EB),
                          onPrimary: Colors.white,
                          surface: Color(0xFF0F172A),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setState(() => _selectedDateRange = picked);
                  }
                },
                icon: const Icon(Icons.date_range, size: 16),
                label: Text(
                  _selectedDateRange == null
                      ? 'Filtrar por fecha'
                      : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (_selectedDateRange != null) ...[
                IconButton(
                  tooltip: 'Quitar filtro de fecha',
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFFEF4444),
                  ),
                  onPressed: () => setState(() => _selectedDateRange = null),
                ),
              ],

              if (_hasActiveFilters) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off, size: 15),
                  label: Text(
                    'Limpiar filtros',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                  ),
                ),
              ],
              const Spacer(),
              RrhhPrimaryActionButton(
                label: 'Registrar Permiso',
                onPressed: _handleRegisterNew,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila 2: Chips de Estados y Chips de Goce
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  'Estado:',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                ...statusList.map((item) {
                  final isSelected = _selectedStatus == item['val'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(item['label']!),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedStatus = item['val']!);
                        }
                      },
                      labelStyle: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                      backgroundColor: const Color(0xFF1E293B),
                      selectedColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF334155),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }),
                const SizedBox(width: 14),
                Container(width: 1, height: 20, color: const Color(0xFF334155)),
                const SizedBox(width: 14),
                Text(
                  'Goce:',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                ...paidList.map((item) {
                  final isSelected = _selectedPaidFilter == item['val'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(item['label']!),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedPaidFilter = item['val']!);
                        }
                      },
                      labelStyle: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                      backgroundColor: const Color(0xFF1E293B),
                      selectedColor: const Color(0xFF0284C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF334155),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContainer() {
    final list = _filteredRequests;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_late_outlined,
                color: Color(0xFF64748B),
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No se encontraron permisos ni licencias',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _hasActiveFilters
                  ? 'Intenta modificando los filtros de búsqueda o fecha'
                  : 'Aún no se han registrado solicitudes en el sistema',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            if (_hasActiveFilters)
              OutlinedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Limpiar filtros'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF38BDF8),
                  side: const BorderSide(color: Color(0xFF38BDF8)),
                ),
              )
            else
              RrhhPrimaryActionButton(
                label: 'Registrar Primer Permiso',
                onPressed: _handleRegisterNew,
              ),
          ],
        ),
      );
    }

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
                // Cabecera de la tabla
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF1E293B), width: 1.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 95,
                        child: Text(
                          'CÓDIGO',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'COLABORADOR',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'TIPO DE PERMISO',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 170,
                        child: Text(
                          'PERÍODO (DESDE → HASTA)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'DURACIÓN',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 95,
                        child: Text(
                          'GOCE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 115,
                        child: Text(
                          'ESTADO',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 110,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'ACCIONES',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Filas de datos
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final req = list[index];
                      return RrhhLeaveRequestRow(
                        request: req,
                        onTap: () => _openDetailDrawer(req),
                        onApprove: () => _handleApprove(req),
                        onReject: () => _handleReject(req),
                        onCancel: () => _handleCancel(req),
                        onEdit: () => _handleEdit(req),
                        onDelete: () => _handleDelete(req),
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

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFEF4444),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? 'Ocurrió un error inesperado',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: _loadData,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
