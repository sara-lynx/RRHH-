import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../extensions/rrhh_model_extensions.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_edit_employee_dialog.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_hire_wizard.dart';
import 'rrhh_personal_filters_bar.dart';
import 'rrhh_personal_table_constants.dart';
import 'rrhh_personal_table_row.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_state_widgets.dart';
import 'rrhh_termination_edit_dialog.dart';

/// Tab 1: Directorio / Nómina de Personal.
/// Consulta, filtrado y apertura de expediente 360° con RrhhEmployeeDetailDialog.
class RrhhPersonalDirectorioTab extends StatefulWidget {
  final bool canManage;
  final bool canModifyContract;

  const RrhhPersonalDirectorioTab({
    super.key,
    this.canManage = true,
    this.canModifyContract = true,
  });

  @override
  State<RrhhPersonalDirectorioTab> createState() =>
      RrhhPersonalDirectorioTabState();
}

class RrhhPersonalDirectorioTabState extends State<RrhhPersonalDirectorioTab> {
  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhEmployeeSummaryDto> _employees = [];
  List<RrhhArea> _areas = [];

  String? _quickStatus;
  String? _employeeType;
  int? _areaId;
  String? _availabilityStatus;
  String? _searchQuery;

  int _currentPage = 1;
  static const int _pageSize = 10;
  int _totalCount = 0;
  int _activeCount = 0;
  int _inactiveCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final areas = await RrhhRepository.current.listAreas();
      if (mounted) setState(() => _areas = areas);
    } catch (_) {}
    await loadEmployees();
  }

  Future<void> loadEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final all = await repo.listEmployees();
      _totalCount = all.length;
      _activeCount = all.where((e) => e.isActive).length;
      _inactiveCount = all.where((e) => !e.isActive).length;

      final filtered = await repo.listEmployees(
        status: _quickStatus,
        employeeType: _employeeType,
        areaId: _areaId,
        search: _searchQuery,
      );

      var result = filtered;
      if (_availabilityStatus != null && _availabilityStatus!.isNotEmpty) {
        result = result
            .where(
              (e) =>
                  e.availabilityStatus.toUpperCase() ==
                  _availabilityStatus!.toUpperCase(),
            )
            .toList();
      }

      if (mounted)
        setState(() {
          _employees = result;
          _isLoading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _errorMessage = 'Error al cargar directorio: $e';
          _isLoading = false;
        });
    }
  }

  void _onFilterUpdated({VoidCallback? update}) {
    if (update != null) update();
    _currentPage = 1;
    loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return RrhhErrorState(
        errorMessage: _errorMessage,
        onRetry: loadEmployees,
      );
    }
    final totalPages = (_employees.length / _pageSize).ceil().clamp(1, 999);
    final startIndex = (_currentPage - 1) * _pageSize;
    final pageItems = _employees.skip(startIndex).take(_pageSize).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 48.0;
        final widths = RrhhTableWidths.calculate(contentWidth);
        final tableWidth = widths.total + 32;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 14),
              RrhhPersonalFiltersBar(
                totalCount: _totalCount,
                activeCount: _activeCount,
                inactiveCount: _inactiveCount,
                selectedQuickStatus: _quickStatus,
                selectedType: _employeeType,
                selectedAreaId: _areaId,
                selectedAvailability: _availabilityStatus,
                areas: _areas,
                onSearchChanged: (q) => _onFilterUpdated(
                  update: () => _searchQuery = q.isEmpty ? null : q,
                ),
                onQuickStatusChanged: (s) =>
                    _onFilterUpdated(update: () => _quickStatus = s),
                onTypeChanged: (t) =>
                    _onFilterUpdated(update: () => _employeeType = t),
                onAreaChanged: (a) =>
                    _onFilterUpdated(update: () => _areaId = a),
                onAvailabilityChanged: (v) =>
                    _onFilterUpdated(update: () => _availabilityStatus = v),
                onResetFilters: () => _onFilterUpdated(
                  update: () {
                    _quickStatus = _employeeType = _areaId =
                        _availabilityStatus = _searchQuery = null;
                  },
                ),
              ),
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
                        else if (pageItems.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: RrhhEmptyState(
                              title: 'No se encontraron colaboradores',
                              description:
                                  'Intente ajustando o limpiando los filtros seleccionados.',
                              icon: Icons.person_off_outlined,
                            ),
                          )
                        else
                          ...pageItems.map(
                            (emp) => RrhhPersonalTableRow(
                              employee: emp,
                              widths: widths,
                              onViewDetails: () =>
                                  RrhhEmployeeDetailDialog.show(
                                    context,
                                    emp.id,
                                    canEdit: widget.canManage,
                                    canModifyContract: widget.canModifyContract,
                                  ),
                              onEdit: () async {
                                final repo = RrhhRepository.current;
                                final fullEmp = await repo.getEmployeeById(
                                  emp.id,
                                );
                                if (context.mounted) {
                                  final updated =
                                      await RrhhEditEmployeeDialog.show(
                                        context,
                                        fullEmp,
                                      );
                                  if (updated == true && context.mounted) {
                                    loadEmployees();
                                    RrhhSnackBar.showSuccess(
                                      context,
                                      'Ficha actualizada correctamente',
                                    );
                                  }
                                }
                              },
                              onTerminate: () async {
                                final success =
                                    await RrhhTerminationEditDialog.show(
                                      context,
                                      employeeId: emp.id,
                                    );
                                if (success == true && context.mounted) {
                                  loadEmployees();
                                  RrhhSnackBar.showSuccess(
                                    context,
                                    'Desvinculación registrada correctamente',
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (!_isLoading && _employees.isNotEmpty)
                _buildPaginationBar(totalPages, startIndex, pageItems.length),
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
              'Directorio de Personal',
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
              'Listado oficial de colaboradores activos e inactivos',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        if (widget.canManage)
          RrhhPrimaryActionButton(
            label: 'Contratar Colaborador',
            icon: Icons.person_add_alt_1,
            onPressed: () => RrhhEmployeeHireWizard.show(
              context,
              onCompleted: loadEmployees,
            ),
          ),
      ],
    );
  }

  Widget _buildTableHeader(RrhhTableWidths widths) {
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
          _buildTh('FOTO', widths.foto),
          _buildTh('COLABORADOR', widths.nombre),
          _buildTh('TIPO', widths.tipo),
          _buildTh('ÁREA / CARGO', widths.areaCargo),
          _buildTh('ESPECIALIDAD', widths.especialidad),
          _buildTh('DISPONIBILIDAD', widths.disponibilidad),
          _buildTh('EXPED.', widths.expediente),
          _buildTh('ACCIONES', widths.acciones, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildTh(
    String title,
    double width, {
    TextAlign align = TextAlign.left,
  }) => SizedBox(
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

  Widget _buildPaginationBar(int totalPages, int startIndex, int currentCount) {
    final start = startIndex + 1, end = startIndex + currentCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mostrando $start-$end de ${_employees.length} colaboradores',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: _currentPage > 1
                  ? () => setState(() => _currentPage--)
                  : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFCBD5E1),
                side: const BorderSide(color: Color(0xFF1E293B)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: const Text('Anterior', style: TextStyle(fontSize: 11.5)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                '$_currentPage / $totalPages',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _currentPage < totalPages
                  ? () => setState(() => _currentPage++)
                  : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFCBD5E1),
                side: const BorderSide(color: Color(0xFF1E293B)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: const Text('Siguiente', style: TextStyle(fontSize: 11.5)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonRows(RrhhTableWidths widths) {
    return Column(
      children: List.generate(
        6,
        (_) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widths.codigo,
                child: Container(
                  width: 60,
                  height: 10,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(
                width: widths.foto,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              SizedBox(
                width: widths.nombre,
                child: Container(height: 10, color: const Color(0xFF1E293B)),
              ),
              SizedBox(
                width: widths.tipo,
                child: Container(
                  width: 50,
                  height: 10,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(
                width: widths.areaCargo,
                child: Container(height: 10, color: const Color(0xFF1E293B)),
              ),
              SizedBox(
                width: widths.especialidad,
                child: Container(
                  width: 70,
                  height: 10,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(
                width: widths.disponibilidad,
                child: Container(
                  width: 80,
                  height: 10,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(
                width: widths.expediente,
                child: Container(
                  width: 35,
                  height: 10,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(
                width: widths.acciones,
                child: Container(
                  width: 50,
                  height: 10,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
