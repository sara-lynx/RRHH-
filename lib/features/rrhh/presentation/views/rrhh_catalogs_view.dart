import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_catalog_item.dart';
import '../../data/repositories/rrhh_repository.dart';
import '../widgets/rrhh_catalog_edit_dialog.dart';
import '../widgets/rrhh_snack_bar.dart';
import '../widgets/rrhh_state_widgets.dart';

/// Anchos calculados adaptativamente para las tablas de catálogos auxiliares.
class _RrhhCatalogTableWidths {
  final double codigo;
  final double nombre;
  final double? subTipo;
  final double? monto;
  final double? descripcion;
  final double estado;
  final double acciones;
  final double total;

  _RrhhCatalogTableWidths({
    required this.codigo,
    required this.nombre,
    this.subTipo,
    this.monto,
    this.descripcion,
    required this.estado,
    required this.acciones,
  }) : total =
           codigo +
           nombre +
           (subTipo ?? 0.0) +
           (monto ?? 0.0) +
           (descripcion ?? 0.0) +
           estado +
           acciones;

  factory _RrhhCatalogTableWidths.calculate({
    required double availableWidth,
    required RrhhCatalogType type,
  }) {
    const estado = 100.0;
    const acciones = 120.0;

    switch (type) {
      case RrhhCatalogType.bonuses:
        const codigo = 120.0;
        const subTipo = 130.0;
        const monto = 120.0;
        const fixed = codigo + subTipo + monto + estado + acciones; // 490.0
        const minNombre = 180.0;
        const minDesc = 220.0;
        const minTotal = fixed + minNombre + minDesc; // 890.0
        final effectiveWidth = availableWidth > minTotal
            ? availableWidth
            : minTotal;
        final extra = effectiveWidth - minTotal;
        final nombre = minNombre + (extra * 0.40);
        final desc = minDesc + (extra * 0.60);
        return _RrhhCatalogTableWidths(
          codigo: codigo,
          nombre: nombre,
          subTipo: subTipo,
          monto: monto,
          descripcion: desc,
          estado: estado,
          acciones: acciones,
        );

      case RrhhCatalogType.deductions:
        const codigo = 120.0;
        const subTipo = 140.0;
        const fixed = codigo + subTipo + estado + acciones; // 380.0
        const minNombre = 200.0;
        const minDesc = 240.0;
        const minTotal = fixed + minNombre + minDesc; // 820.0
        final effectiveWidth = availableWidth > minTotal
            ? availableWidth
            : minTotal;
        final extra = effectiveWidth - minTotal;
        final nombre = minNombre + (extra * 0.40);
        final desc = minDesc + (extra * 0.60);
        return _RrhhCatalogTableWidths(
          codigo: codigo,
          nombre: nombre,
          subTipo: subTipo,
          descripcion: desc,
          estado: estado,
          acciones: acciones,
        );

      case RrhhCatalogType.contractTypes:
      case RrhhCatalogType.paymentModalities:
      case RrhhCatalogType.banks:
      case RrhhCatalogType.afps:
      case RrhhCatalogType.healthInsurances:
        const codigo = 130.0;
        const fixed = codigo + estado + acciones; // 350.0
        const minNombre = 220.0;
        const minDesc = 260.0;
        const minTotal = fixed + minNombre + minDesc; // 830.0
        final effectiveWidth = availableWidth > minTotal
            ? availableWidth
            : minTotal;
        final extra = effectiveWidth - minTotal;
        final nombre = minNombre + (extra * 0.40);
        final desc = minDesc + (extra * 0.60);
        return _RrhhCatalogTableWidths(
          codigo: codigo,
          nombre: nombre,
          descripcion: desc,
          estado: estado,
          acciones: acciones,
        );
    }
  }
}

/// Submódulo RRHH → Catálogos (Catálogos Auxiliares Maestros).
/// Agrupa en un selector superior los 7 catálogos editables que alimentan el expediente:
/// 1. Bancos
/// 2. AFPs / Gestora
/// 3. Seguros de Salud
/// 4. Tipos de Contrato
/// 5. Modalidades de Pago
/// 6. Bonificaciones
/// 7. Descuentos
class RrhhCatalogsView extends StatefulWidget {
  final RrhhCatalogType? initialType;
  final bool hasPermission;

  const RrhhCatalogsView({
    super.key,
    this.initialType,
    this.hasPermission = true,
  });

  @override
  State<RrhhCatalogsView> createState() => _RrhhCatalogsViewState();
}

class _RrhhCatalogsViewState extends State<RrhhCatalogsView> {
  late RrhhCatalogType _selectedType;
  List<RrhhCatalogItem> _items = [];
  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _statusFilter = 'ALL'; // 'ALL', 'ACTIVE', 'INACTIVE'
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType ?? RrhhCatalogType.banks;
    _loadItems();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final list = await RrhhRepository.current.listCatalogItems(_selectedType);
      if (!mounted) return;
      setState(() {
        _items = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar catálogo: $e';
      });
    }
  }

  void _onTypeChanged(RrhhCatalogType type) {
    if (_selectedType == type) return;
    setState(() {
      _selectedType = type;
      _searchQuery = '';
      _statusFilter = 'ALL';
      _searchCtrl.clear();
    });
    _loadItems();
  }

  List<RrhhCatalogItem> get _filteredItems {
    return _items.where((item) {
      if (_statusFilter == 'ACTIVE' && !item.isActive) return false;
      if (_statusFilter == 'INACTIVE' && item.isActive) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchCode = item.code.toLowerCase().contains(q);
        final matchName = item.name.toLowerCase().contains(q);
        final matchDesc = item.description?.toLowerCase().contains(q) ?? false;
        final matchSubType = item.subType?.toLowerCase().contains(q) ?? false;
        if (!matchCode && !matchName && !matchDesc && !matchSubType)
          return false;
      }

      return true;
    }).toList();
  }

  Future<void> _openCreateDialog() async {
    final newItem = await RrhhCatalogEditDialog.show(
      context: context,
      catalogType: _selectedType,
      existingItems: _items,
    );

    if (newItem != null && mounted) {
      try {
        final created = await RrhhRepository.current.createCatalogItem(newItem);
        if (!mounted) return;
        setState(() {
          _items.add(created);
        });
        RrhhSnackBar.showSuccess(
          context,
          'Registro ${created.code} creado exitosamente',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al guardar: $e');
      }
    }
  }

  Future<void> _openEditDialog(RrhhCatalogItem item) async {
    final updatedItem = await RrhhCatalogEditDialog.show(
      context: context,
      catalogType: _selectedType,
      item: item,
      existingItems: _items,
    );

    if (updatedItem != null && mounted) {
      try {
        final saved = await RrhhRepository.current.updateCatalogItem(
          updatedItem,
        );
        if (!mounted) return;
        setState(() {
          final idx = _items.indexWhere((c) => c.id == saved.id);
          if (idx != -1) _items[idx] = saved;
        });
        RrhhSnackBar.showInfo(
          context,
          'Registro ${saved.code} actualizado',
        );
      } catch (e) {
        if (!mounted) return;
        RrhhSnackBar.showError(context, 'Error al actualizar: $e');
      }
    }
  }

  Future<void> _toggleStatus(RrhhCatalogItem item) async {
    if (item.isActive) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          title: Text(
            'Desactivar Registro',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          content: Text(
            '¿Está seguro de desactivar "${item.name}" (${item.code})?\n\nNo podrá ser seleccionado en nuevos expedientes de contratación.',
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              child: const Text(
                'Desactivar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    try {
      final updated = item.copyWith(
        isActive: !item.isActive,
        updatedAt: DateTime.now(),
      );
      final saved = await RrhhRepository.current.updateCatalogItem(updated);
      if (!mounted) return;
      setState(() {
        final idx = _items.indexWhere((c) => c.id == saved.id);
        if (idx != -1) _items[idx] = saved;
      });
      if (saved.isActive) {
        RrhhSnackBar.showSuccess(context, '${saved.code} activado');
      } else {
        RrhhSnackBar.showInfo(context, '${saved.code} desactivado');
      }
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cambiar estado: $e');
    }
  }

  IconData _iconForType(RrhhCatalogType type) {
    switch (type) {
      case RrhhCatalogType.banks:
        return Icons.account_balance_outlined;
      case RrhhCatalogType.afps:
        return Icons.security_outlined;
      case RrhhCatalogType.healthInsurances:
        return Icons.medical_services_outlined;
      case RrhhCatalogType.contractTypes:
        return Icons.description_outlined;
      case RrhhCatalogType.paymentModalities:
        return Icons.payments_outlined;
      case RrhhCatalogType.bonuses:
        return Icons.card_giftcard_outlined;
      case RrhhCatalogType.deductions:
        return Icons.money_off_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasPermission) {
      return const RrhhForbiddenState(
        requiredPermission: 'rrhh.catalogs.view',
      );
    }

    final totalCount = _items.length;
    final activeCount = _items.where((c) => c.isActive).length;
    final inactiveCount = totalCount - activeCount;
    final filtered = _filteredItems;

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Container(
            color: const Color(0xFF090D16),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de Selector y Acciones
                _buildCatalogSelectorBar(
                  totalCount,
                  activeCount,
                  inactiveCount,
                ),
                const SizedBox(height: 16),

                // Contenido: Tabla con LayoutBuilder
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D111C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          )
                        : _error != null
                        ? RrhhErrorState(
                            errorMessage: _error!,
                            onRetry: _loadItems,
                          )
                        : filtered.isEmpty
                        ? RrhhEmptyState(
                            title: 'No hay registros en ${_selectedType.title}',
                            description: _searchQuery.isNotEmpty
                                ? 'No se encontraron coincidencias para "$_searchQuery".'
                                : 'Aún no se han configurado elementos para este catálogo.',
                            icon: _iconForType(_selectedType),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final widths = _RrhhCatalogTableWidths.calculate(
                                availableWidth: constraints.maxWidth - 32,
                                type: _selectedType,
                              );

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: (widths.total + 32).clamp(
                                    constraints.maxWidth,
                                    3000.0,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildTableHeader(widths),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: filtered.length,
                                          itemBuilder: (ctx, index) {
                                            final item = filtered[index];
                                            return _RrhhCatalogTableRow(
                                              item: item,
                                              widths: widths,
                                              onEdit: () =>
                                                  _openEditDialog(item),
                                              onToggleStatus: () =>
                                                  _toggleStatus(item),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF090D16) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Color(0xFF2563EB),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catálogos del Sistema',
                style: GoogleFonts.inter(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Listas maestras de RRHH',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogSelectorBar(int total, int active, int inactive) {
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
          // Selector de Catálogo Dropdown y Buscador
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Dropdown de los 7 Catálogos
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<RrhhCatalogType>(
                    value: _selectedType,
                    dropdownColor: const Color(0xFF0F172A),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xFF60A5FA),
                    ),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    items: RrhhCatalogType.values.map((type) {
                      return DropdownMenuItem<RrhhCatalogType>(
                        value: type,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconForType(type),
                              size: 16,
                              color: const Color(0xFF60A5FA),
                            ),
                            const SizedBox(width: 8),
                            Text(type.title),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) _onTypeChanged(val);
                    },
                  ),
                ),
              ),

              // Buscador en catálogo actual
              SizedBox(
                width: 230,
                height: 38,
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar en ${_selectedType.title}...',
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
            ],
          ),

          // Filtros por Estado y Botón [+ Nuevo Elemento]
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterChip('Todos ($total)', 'ALL'),
                  const SizedBox(width: 6),
                  _buildFilterChip('Activos ($active)', 'ACTIVE'),
                  const SizedBox(width: 6),
                  _buildFilterChip('Inactivos ($inactive)', 'INACTIVE'),
                ],
              ),
              FilledButton.icon(
                onPressed: _openCreateDialog,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(
                  'Nuevo ${_selectedType.prefix}',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                ),
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
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
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF60A5FA)
                : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(_RrhhCatalogTableWidths widths) {
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
          _buildTh('NOMBRE', widths.nombre),
          if (widths.subTipo != null)
            _buildTh(
              _selectedType == RrhhCatalogType.bonuses
                  ? 'TIPO BONO'
                  : 'TIPO DESCUENTO',
              widths.subTipo!,
            ),
          if (widths.monto != null) _buildTh('MONTO SUG.', widths.monto!),
          if (widths.descripcion != null)
            _buildTh('DESCRIPCIÓN', widths.descripcion!),
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
}

/// Fila individual con hover para la tabla del catálogo seleccionado.
class _RrhhCatalogTableRow extends StatefulWidget {
  final RrhhCatalogItem item;
  final _RrhhCatalogTableWidths widths;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _RrhhCatalogTableRow({
    required this.item,
    required this.widths,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  State<_RrhhCatalogTableRow> createState() => _RrhhCatalogTableRowState();
}

class _RrhhCatalogTableRowState extends State<_RrhhCatalogTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final w = widget.widths;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF131C2E) : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Código (Chip azul)
            SizedBox(
              width: w.codigo,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.code,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF60A5FA),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

            // Nombre
            SizedBox(
              width: w.nombre,
              child: Text(
                item.name,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // SubTipo (Bono o Descuento)
            if (w.subTipo != null)
              SizedBox(
                width: w.subTipo!,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.subType ?? 'Estándar',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF38BDF8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

            // Monto sugerido (Bs)
            if (w.monto != null)
              SizedBox(
                width: w.monto!,
                child: Text(
                  item.defaultAmount != null
                      ? 'Bs. ${item.defaultAmount!.toStringAsFixed(2)}'
                      : '—',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: item.defaultAmount != null
                        ? const Color(0xFF10B981)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),

            // Descripción
            if (w.descripcion != null)
              SizedBox(
                width: w.descripcion!,
                child: Text(
                  item.description ?? 'Sin descripción adicional',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: item.description != null
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontStyle: item.description != null
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Estado (Activo / Inactivo)
            SizedBox(
              width: w.estado,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (item.isActive
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
                          color: item.isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFF64748B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.isActive ? 'Activo' : 'Inactivo',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Acciones: [Editar] [⋯]
            SizedBox(
              width: w.acciones,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onEdit,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF60A5FA),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Editar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                                item.isActive
                                    ? Icons.block_flipped
                                    : Icons.check_circle_outline,
                                size: 15,
                                color: item.isActive
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.isActive ? 'Desactivar' : 'Activar',
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
