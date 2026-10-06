import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_new_payroll_period_dialog.dart';
import 'rrhh_payroll_item_row.dart';
import 'rrhh_payroll_kpis.dart';
import 'rrhh_payroll_period_selector.dart';
import 'rrhh_primary_action_button.dart';
import 'rrhh_snack_bar.dart';

/// Pantalla 12 (Bloque 4) — Novedades para Nómina (Entrega a Contabilidad).
///
/// Consolida todos los permisos, vacaciones, incidencias y desvinculaciones
/// del mes y las entrega a Contabilidad con reportes en pantalla, exportación
/// a Excel/CSV y handoff para el backend contable.
class RrhhPayrollView extends StatefulWidget {
  final RrhhRepository? repository;

  const RrhhPayrollView({
    super.key,
    this.repository,
  });

  @override
  State<RrhhPayrollView> createState() => _RrhhPayrollViewState();
}

class _RrhhPayrollViewState extends State<RrhhPayrollView>
    with SingleTickerProviderStateMixin {
  late final RrhhRepository _repo;

  bool _isLoading = true;
  String? _errorMessage;

  List<RrhhPayrollPeriod> _periods = [];
  RrhhPayrollPeriod? _selectedPeriod;
  List<RrhhPayrollItem> _allItems = [];

  // Tab interna de filtrado por fuente: 0: Todos, 1: Permisos, 2: Vacaciones, 3: Incidencias, 4: Desvinculaciones
  late final TabController _tabController;

  // Búsqueda y filtro de impacto
  final _searchController = TextEditingController();
  String _selectedImpactFilter =
      'todos'; // 'todos' | 'descuento' | 'pago_extra' | 'sin_impacto'

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? RrhhRepository.current;
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final periods = await _repo.listPayrollPeriods();
      _periods = periods;

      if (_periods.isNotEmpty) {
        // Seleccionar por defecto el período abierto o el primero (más reciente)
        if (_selectedPeriod == null) {
          _selectedPeriod = _periods.firstWhere(
            (p) => p.isOpen,
            orElse: () => _periods.first,
          );
        } else {
          // Mantener o refrescar la instancia seleccionada
          final currentId = _selectedPeriod!.id;
          _selectedPeriod = _periods.firstWhere(
            (p) => p.id == currentId,
            orElse: () => _periods.first,
          );
        }

        // Cargar items del período seleccionado
        _allItems = await _repo.listPayrollItems(_selectedPeriod!.id);
      } else {
        _selectedPeriod = null;
        _allItems = [];
      }
    } catch (e) {
      _errorMessage = 'Error al cargar novedades para nómina: $e';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _onPeriodChanged(RrhhPayrollPeriod period) async {
    setState(() {
      _selectedPeriod = period;
      _isLoading = true;
    });

    try {
      final items = await _repo.listPayrollItems(period.id);
      if (mounted) {
        setState(() {
          _allItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cambiar período: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openNewPeriodDialog() async {
    final created = await showDialog<RrhhPayrollPeriod>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhNewPayrollPeriodDialog(repository: _repo),
    );

    if (created != null) {
      _selectedPeriod = created;
      await _loadData();
    }
  }

  Future<void> _handleClosePeriod() async {
    if (_selectedPeriod == null) return;

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
              Icons.lock_outline_rounded,
              color: Color(0xFFA855F7),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Cerrar Período de Nómina',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Está seguro de cerrar el período ${_selectedPeriod!.displayName}? Una vez cerrado no se podrán agregar más novedades hasta su reapertura y quedará listo para su remisión a Contabilidad.',
          style: GoogleFonts.inter(
            color: const Color(0xFFCBD5E1),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
            child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA855F7),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Confirmar Cierre',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final updated = await _repo.closePayrollPeriod(_selectedPeriod!.id);
        _selectedPeriod = updated;
        await _loadData();
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Período ${updated.code} cerrado exitosamente.',
          );
        }
      } catch (e) {
        if (mounted) {
          RrhhSnackBar.showError(context, 'Error al cerrar período: $e');
        }
      }
    }
  }

  Future<void> _handleSendToAccounting() async {
    if (_selectedPeriod == null) return;

    if (_selectedPeriod!.isOpen) {
      RrhhSnackBar.showWarning(
        context,
        'Debe cerrar el período antes de poder remitirlo a Contabilidad.',
      );
      return;
    }

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
            const Icon(Icons.send_rounded, color: Color(0xFF10B981), size: 22),
            const SizedBox(width: 10),
            Text(
              'Enviar Novedades a Contabilidad',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Desea remitir formalmente el consolidado de ${_selectedPeriod!.displayName} al departamento contable? Las novedades pasarán al estado "Enviado" para su liquidación.',
          style: GoogleFonts.inter(
            color: const Color(0xFFCBD5E1),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF334155)),
            ),
            child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Remitir a Contabilidad',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final updated = await _repo.sendPayrollPeriodToAccounting(
          _selectedPeriod!.id,
        );
        _selectedPeriod = updated;
        await _loadData();
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Consolidado de novedades para nómina remitido formalmente a Contabilidad.',
          );
        }
      } catch (e) {
        if (mounted) {
          RrhhSnackBar.showError(
            context,
            'Error al remitir a contabilidad: $e',
          );
        }
      }
    }
  }

  Future<void> _handleExport(String format) async {
    if (_selectedPeriod == null) return;

    try {
      final content = await _repo.exportPayrollPeriod(
        _selectedPeriod!.id,
        format,
      );
      if (mounted) {
        final formatUpper = format.toUpperCase();
        RrhhSnackBar.showSuccess(
          context,
          'Archivo $formatUpper exportado exitosamente (${content.length} bytes generados).',
        );
      }
    } catch (e) {
      if (mounted) {
        RrhhSnackBar.showError(context, 'Error al exportar: $e');
      }
    }
  }

  void _showHistoryDialog() {
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
              Icons.history_rounded,
              color: Color(0xFF60A5FA),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Historial de Períodos de Nómina',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _periods.map((p) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.displayName,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          p.code,
                          style: GoogleFonts.jetBrainsMono(
                            color: const Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        RrhhPayrollPeriodStatus.label(p.status),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            child: Text('Cerrar', style: GoogleFonts.inter(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // Filtrado reactivo de items
  List<RrhhPayrollItem> _getFilteredItems() {
    final search = _searchController.text.trim().toLowerCase();

    // 1. Filtrar por Tab interna (fuente)
    String? requiredSource;
    switch (_tabController.index) {
      case 1:
        requiredSource = RrhhPayrollSourceType.permiso;
        break;
      case 2:
        requiredSource = RrhhPayrollSourceType.vacacion;
        break;
      case 3:
        requiredSource = RrhhPayrollSourceType.incidencia;
        break;
      case 4:
        requiredSource = RrhhPayrollSourceType.desvinculacion;
        break;
      default:
        requiredSource = null;
    }

    return _allItems.where((item) {
      if (requiredSource != null &&
          item.sourceType.toLowerCase() != requiredSource.toLowerCase()) {
        return false;
      }

      if (_selectedImpactFilter != 'todos') {
        if (item.impactType.toLowerCase() !=
            _selectedImpactFilter.toLowerCase()) {
          return false;
        }
      }

      if (search.isNotEmpty) {
        final matchName = item.employeeName.toLowerCase().contains(search);
        final matchCode = item.employeeCode.toLowerCase().contains(search);
        final matchSource = item.sourceCode.toLowerCase().contains(search);
        final matchDesc = item.description.toLowerCase().contains(search);
        if (!matchName && !matchCode && !matchSource && !matchDesc)
          return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final filteredItems = _getFilteredItems();

    return LayoutBuilder(
      builder: (context, constraints) {
        const minTableWidth = 980.0;
        final contentWidth = constraints.maxWidth - 48.0;
        final tableWidth = contentWidth > minTableWidth
            ? contentWidth
            : minTableWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header de la sección compacto (FIX 1)
              _buildSectionHeader(),
              const SizedBox(height: 12),

              // Selector de período mensual compacto (FIX 2 y FIX 3)
              if (_periods.isNotEmpty && _selectedPeriod != null)
                RrhhPayrollPeriodSelector(
                  periods: _periods,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: _onPeriodChanged,
                )
              else
                _buildNoPeriodsBanner(),

              const SizedBox(height: 14),

              // Panel de KPIs
              if (_selectedPeriod != null)
                RrhhPayrollKpis(
                  period: _selectedPeriod!,
                  items: _allItems,
                ),

              const SizedBox(height: 16),

              // Filtros y Tabs internas
              _buildFilterTabsAndSearch(),

              const SizedBox(height: 14),

              // Tabla consolidada full-width (FIX 4)
              _buildConsolidatedTableCard(filteredItems, tableWidth),

              const SizedBox(height: 16),

              // Acciones del período (Footer)
              if (_selectedPeriod != null) _buildPeriodActionsFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Novedades para Nómina',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF8FAFC),
            ),
          ),
          RrhhPrimaryActionButton(
            label: 'Nuevo Período',
            onPressed: _openNewPeriodDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildNoPeriodsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: Color(0xFF64748B),
            ),
            const SizedBox(height: 10),
            Text(
              'No existen períodos de nómina registrados todavía.',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Haga clic en "+ Nuevo Período" para iniciar la consolidación mensual de novedades.',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _openNewPeriodDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Crear Primer Período'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabsAndSearch() {
    // Contadores por fuente
    final countTodos = _allItems.length;
    final countPermisos = _allItems
        .where((i) => i.sourceType == RrhhPayrollSourceType.permiso)
        .length;
    final countVacaciones = _allItems
        .where((i) => i.sourceType == RrhhPayrollSourceType.vacacion)
        .length;
    final countIncidencias = _allItems
        .where((i) => i.sourceType == RrhhPayrollSourceType.incidencia)
        .length;
    final countBajas = _allItems
        .where((i) => i.sourceType == RrhhPayrollSourceType.desvinculacion)
        .length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          // Fila superior: Tabs internas (fuente de novedad)
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(6),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF94A3B8),
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            padding: EdgeInsets.zero,
            tabs: [
              Tab(height: 32, child: Text('1. Todos ($countTodos)')),
              Tab(height: 32, child: Text('2. Permisos ($countPermisos)')),
              Tab(height: 32, child: Text('3. Vacaciones ($countVacaciones)')),
              Tab(
                height: 32,
                child: Text('4. Incidencias ($countIncidencias)'),
              ),
              Tab(height: 32, child: Text('5. Desvinculaciones ($countBajas)')),
            ],
          ),
          const SizedBox(height: 12),

          // Fila inferior: Buscador + Filtro de impacto
          Row(
            children: [
              // Buscador
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Buscar por colaborador, código o detalle...',
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 16,
                        color: Color(0xFF64748B),
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
                      fillColor: const Color(0xFF0F172A),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF1E293B)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF1E293B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF2563EB)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Filtro por impacto económico
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedImpactFilter,
                    dropdownColor: const Color(0xFF0F172A),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF94A3B8),
                      size: 18,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'todos',
                        child: Text('Impacto: Todos'),
                      ),
                      DropdownMenuItem(
                        value: RrhhPayrollImpactType.descuento,
                        child: Text('Solo Descuentos'),
                      ),
                      DropdownMenuItem(
                        value: RrhhPayrollImpactType.pagoExtra,
                        child: Text('Solo Pagos Extra / Bajas'),
                      ),
                      DropdownMenuItem(
                        value: RrhhPayrollImpactType.sinImpacto,
                        child: Text('Sin Impacto'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null)
                        setState(() => _selectedImpactFilter = val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsolidatedTableCard(
    List<RrhhPayrollItem> items,
    double tableWidth,
  ) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabecera de la tabla con anchos proporcionales
              _buildTableHeader(),

              // Filas de datos
              if (items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inbox_rounded,
                        size: 36,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No se encontraron novedades para este período o filtro.',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Intente cambiando el término de búsqueda o seleccione otra categoría.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...items.asMap().entries.map((entry) {
                  return RrhhPayrollItemRow(
                    item: entry.value,
                    isEven: entry.key.isEven,
                  );
                }),

              // Contador al pie de la tabla
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF111827),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                  border: Border(top: BorderSide(color: Color(0xFF1E293B))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mostrando ${items.length} de ${_allItems.length} novedades consolidadas',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (_selectedPeriod != null)
                      Text(
                        'Período: ${_selectedPeriod!.displayName} (${_selectedPeriod!.code})',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 24,
            child: Text(
              'EMPLEADO',
              style: _headerStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 14,
            child: Text(
              'TIPO DE NOVEDAD',
              style: _headerStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 11,
            child: Text(
              'CÓDIGO ORIGEN',
              style: _headerStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 11,
            child: Text(
              'FECHA EFECTIVA',
              style: _headerStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 26,
            child: Text(
              'DESCRIPCIÓN',
              style: _headerStyle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'IMPACTO NÓMINA',
                style: _headerStyle,
              ),
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

  Widget _buildPeriodActionsFooter() {
    final isClosed =
        _selectedPeriod!.isClosed ||
        _selectedPeriod!.isSent ||
        _selectedPeriod!.isProcessed;
    final isSent = _selectedPeriod!.isSent || _selectedPeriod!.isProcessed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Grupo de exportación
          Wrap(
            spacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => _handleExport('excel'),
                icon: const Icon(
                  Icons.table_chart_outlined,
                  size: 16,
                  color: Color(0xFF10B981),
                ),
                label: Text(
                  'Exportar a Excel (.xlsx)',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFCBD5E1),
                  side: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _handleExport('csv'),
                icon: const Icon(
                  Icons.file_present_outlined,
                  size: 16,
                  color: Color(0xFF3B82F6),
                ),
                label: Text(
                  'Exportar a CSV',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFCBD5E1),
                  side: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _showHistoryDialog,
                icon: const Icon(
                  Icons.history_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                label: Text(
                  'Ver Histórico',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFCBD5E1),
                  side: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          // Grupo de ciclo de vida
          Wrap(
            spacing: 10,
            children: [
              // Cerrar período
              if (!isClosed)
                OutlinedButton.icon(
                  onPressed: _handleClosePeriod,
                  icon: const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xFFA855F7),
                  ),
                  label: Text(
                    'Cerrar Período',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFA855F7),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFA855F7)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

              // Enviar a Contabilidad
              ElevatedButton.icon(
                onPressed: isSent ? null : _handleSendToAccounting,
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(
                  isSent ? 'Remitido a Contabilidad' : 'Enviar a Contabilidad',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF1E293B),
                  disabledForegroundColor: const Color(0xFF64748B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
