import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Selector desplegable de alta densidad con buscador en tiempo real 100% Light Mode.
/// Erradica dropdowns nativos oscuros y cuadros negros en formularios y boletas.
class EliteSearchableSelect<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T item) itemTitle;
  final String Function(T item)? itemSubtitle;
  final String Function(T item)? itemCostCenter;
  final String? Function(T item)? itemId;
  final bool Function(T item, String query)? filterFn;
  final String placeholder;
  final String searchPlaceholder;
  final double height;
  final bool enabled;

  const EliteSearchableSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemCostCenter,
    this.itemId,
    this.filterFn,
    this.placeholder = 'Seleccione un colaborador...',
    this.searchPlaceholder = 'Escriba para filtrar por nombre, CI o Centro de Costo...',
    this.height = 38.0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final currentItem = value;
    final title = currentItem != null ? itemTitle(currentItem) : null;
    final costCenter = currentItem != null ? itemCostCenter?.call(currentItem) : null;
    final subtitle = currentItem != null ? itemSubtitle?.call(currentItem) : null;

    return InkWell(
      onTap: enabled
          ? () => _openSearchDialog(context)
          : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: title != null
                  ? Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (costCenter != null && costCenter.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(
                              costCenter,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                        if (subtitle != null && subtitle.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '($subtitle)',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Text(
                      placeholder,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearchDialog(BuildContext context) {
    showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => _SearchDialog<T>(
        initialItems: items,
        selectedValue: value,
        itemTitle: itemTitle,
        itemSubtitle: itemSubtitle,
        itemCostCenter: itemCostCenter,
        filterFn: filterFn,
        searchPlaceholder: searchPlaceholder,
      ),
    ).then((selected) {
      if (selected != null) {
        onChanged(selected);
      }
    });
  }
}

class _SearchDialog<T> extends StatefulWidget {
  final List<T> initialItems;
  final T? selectedValue;
  final String Function(T item) itemTitle;
  final String Function(T item)? itemSubtitle;
  final String Function(T item)? itemCostCenter;
  final bool Function(T item, String query)? filterFn;
  final String searchPlaceholder;

  const _SearchDialog({
    required this.initialItems,
    required this.selectedValue,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemCostCenter,
    this.filterFn,
    required this.searchPlaceholder,
  });

  @override
  State<_SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<_SearchDialog<T>> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.initialItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredItems = widget.initialItems;
      } else {
        _filteredItems = widget.initialItems.where((item) {
          if (widget.filterFn != null) {
            return widget.filterFn!(item, q);
          }
          final title = widget.itemTitle(item).toLowerCase();
          final subtitle = widget.itemSubtitle?.call(item).toLowerCase() ?? '';
          final cc = widget.itemCostCenter?.call(item).toLowerCase() ?? '';
          return title.contains(q) || subtitle.contains(q) || cc.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera con Buscador en tiempo real
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _filter,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.searchPlaceholder,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 14),
                            splashRadius: 14,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _searchController.clear();
                              _filter('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFF0D9488),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Lista filtrada en vivo (máx 260px)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: _filteredItems.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 28,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No se encontraron coincidencias',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F5F9),
                        ),
                        itemBuilder: (ctx, index) {
                          final item = _filteredItems[index];
                          final isSelected = widget.selectedValue == item;
                          final title = widget.itemTitle(item);
                          final subtitle = widget.itemSubtitle?.call(item);
                          final cc = widget.itemCostCenter?.call(item);

                          return InkWell(
                            onTap: () => Navigator.of(context).pop(item),
                            hoverColor: const Color(0xFFF8FAFC),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              color: isSelected
                                  ? const Color(0xFFF0FDFA)
                                  : Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.inter(
                                            fontSize: 12.5,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? const Color(0xFF0F766E)
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        if (subtitle != null &&
                                            subtitle.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            subtitle,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (cc != null && cc.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        cc,
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF334155),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // Footer con botón cancelar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredItems.length} resultado(s)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 28),
                    ),
                    child: Text(
                      'Cerrar',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
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
