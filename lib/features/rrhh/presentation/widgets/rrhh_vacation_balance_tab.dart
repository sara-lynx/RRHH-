import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest, RrhhVacation;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_vacation_balance_row.dart';
import 'rrhh_vacation_edit_dialog.dart';

/// Pestaña 1: Saldo de Vacaciones por Empleado (Pantalla 09).
class RrhhVacationBalanceTab extends StatefulWidget {
  final List<RrhhVacationBalance> balances;
  final bool isLoading;
  final VoidCallback onRefresh;
  final ValueChanged<String>? onFilterEmployeeInHistory;

  const RrhhVacationBalanceTab({
    super.key,
    required this.balances,
    required this.isLoading,
    required this.onRefresh,
    this.onFilterEmployeeInHistory,
  });

  @override
  State<RrhhVacationBalanceTab> createState() => _RrhhVacationBalanceTabState();
}

class _RrhhVacationBalanceTabState extends State<RrhhVacationBalanceTab> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'TODOS';
  int? _selectedAreaId;
  List<RrhhArea> _areas = [];

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAreas() async {
    try {
      final areas = await RrhhRepository.current.listAreas();
      if (mounted) setState(() => _areas = areas);
    } catch (_) {}
  }

  List<RrhhVacationBalance> get _filteredBalances {
    return widget.balances.where((b) {
      if (_selectedStatus != 'TODOS') {
        if (b.balanceStatus.toLowerCase() != _selectedStatus.toLowerCase()) {
          return false;
        }
      }

      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchesName = b.employeeName.toLowerCase().contains(query);
        final matchesCode = b.employeeCode.toLowerCase().contains(query);
        if (!matchesName && !matchesCode) return false;
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'TODOS';
      _selectedAreaId = null;
    });
  }

  bool get _hasActiveFilters {
    return _searchController.text.trim().isNotEmpty ||
        _selectedStatus != 'TODOS' ||
        _selectedAreaId != null;
  }

  Future<void> _handleProgramar(RrhhVacationBalance b) async {
    final success = await RrhhVacationEditDialog.show(
      context,
      preselectedEmployeeId: b.employeeId,
    );
    if (success == true) {
      widget.onRefresh();
    }
  }

  Future<void> _handleAdjustBalance(RrhhVacationBalance b) async {
    final daysCtrl = TextEditingController(text: '${b.pendingDays}');
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
                Icons.tune,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Ajustar Saldo de Vacaciones',
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
                'Colaborador: ${b.employeeCode} — ${b.employeeName}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nuevo saldo disponible (días):',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: daysCtrl,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                validator: (val) {
                  final n = int.tryParse(val?.trim() ?? '');
                  if (n == null || n < 0)
                    return 'Ingresa un número de días válido';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Text(
                'Justificación legal / administrativa obligatoria:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 2,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      'Ej. Omisión de programación 2025, acuerdo escrito...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 15) {
                    return 'La justificación debe tener al menos 15 caracteres.';
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
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              'Aplicar Ajuste',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Ajuste de saldo registrado con justificación de auditoría.',
      );
      widget.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBalances;

    return Column(
      children: [
        // Filtros
        _buildFiltersBar(),

        // Tabla
        Expanded(
          child: widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                )
              : filtered.isEmpty
              ? _buildEmptyState()
              : _buildTable(filtered),
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    final statusList = [
      {'label': 'Todos', 'val': 'TODOS'},
      {'label': 'Disponibles', 'val': RrhhVacationBalanceStatus.disponible},
      {'label': 'Por vencer', 'val': RrhhVacationBalanceStatus.parcial},
      {'label': 'Agotados', 'val': RrhhVacationBalanceStatus.agotado},
      {'label': 'Vencidos', 'val': RrhhVacationBalanceStatus.vencido},
      {'label': 'Sin derecho', 'val': RrhhVacationBalanceStatus.sinDerecho},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          // Buscador
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o código...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Filtro por Estado de Saldo
          SizedBox(
            height: 38,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF0F172A),
                  value: _selectedStatus,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                  style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
                  items: statusList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['val'],
                      child: Text(item['label']!),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Filtro por Área
          if (_areas.isNotEmpty) ...[
            SizedBox(
              height: 38,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    dropdownColor: const Color(0xFF0F172A),
                    value: _selectedAreaId,
                    hint: Text(
                      'Todas las áreas',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(
                          'Todas las áreas',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ..._areas.map((a) {
                        return DropdownMenuItem<int?>(
                          value: a.id,
                          child: Text(
                            a.name,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                    ],
                    onChanged: (val) => setState(() => _selectedAreaId = val),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],

          if (_hasActiveFilters)
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(
                Icons.clear_all,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
              label: Text(
                'Limpiar',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTable(List<RrhhVacationBalance> list) {
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
                _buildTableHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final b = list[index];
                      return RrhhVacationBalanceRow(
                        balance: b,
                        isEven: index % 2 == 0,
                        onProgramar: () => _handleProgramar(b),
                        onViewHistory: () {
                          widget.onFilterEmployeeInHistory?.call(
                            b.employeeName,
                          );
                        },
                        onAdjustBalance: () => _handleAdjustBalance(b),
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

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          _buildTh('COLABORADOR', 22),
          _buildTh('ANTIGÜEDAD', 13),
          _buildTh('ASIGNADOS', 8),
          _buildTh('GOZADOS', 8),
          _buildTh('PENDIENTES', 15),
          _buildTh('ESTADO SALDO', 11),
          _buildTh('PRÓX. ANIVERSARIO', 12),
          _buildTh('ACCIONES', 11, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildTh(String label, int flex, {TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.beach_access_outlined,
              size: 48,
              color: Color(0xFF334155),
            ),
            const SizedBox(height: 14),
            Text(
              'No se encontraron colaboradores con saldo',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Intenta ajustar los filtros de búsqueda o estado de saldo.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
