import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_catalog_item.dart';

/// Modal para crear o editar un elemento de Catálogo Auxiliar Maestro de RRHH.
/// Soporta de forma adaptativa los 7 catálogos:
/// Bancos, AFPs, Seguros de Salud, Tipos de Contrato, Modalidades de Pago, Bonificaciones y Descuentos.
class RrhhCatalogEditDialog extends StatefulWidget {
  final RrhhCatalogType catalogType;
  final RrhhCatalogItem? item;
  final List<RrhhCatalogItem> existingItems;

  const RrhhCatalogEditDialog({
    super.key,
    required this.catalogType,
    this.item,
    required this.existingItems,
  });

  static Future<RrhhCatalogItem?> show({
    required BuildContext context,
    required RrhhCatalogType catalogType,
    RrhhCatalogItem? item,
    required List<RrhhCatalogItem> existingItems,
  }) {
    return showDialog<RrhhCatalogItem>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhCatalogEditDialog(
        catalogType: catalogType,
        item: item,
        existingItems: existingItems,
      ),
    );
  }

  @override
  State<RrhhCatalogEditDialog> createState() => _RrhhCatalogEditDialogState();
}

class _RrhhCatalogEditDialogState extends State<RrhhCatalogEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _amountCtrl;

  late String _subType;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    final type = widget.catalogType;

    // Calcular código por defecto sugerido
    final nextNum = widget.existingItems.length + 1;
    final defaultCode = '${type.prefix}-${nextNum.toString().padLeft(3, '0')}';

    _codeCtrl = TextEditingController(text: item?.code ?? defaultCode);
    _nameCtrl = TextEditingController(text: item?.name ?? '');
    _descCtrl = TextEditingController(text: item?.description ?? '');
    _amountCtrl = TextEditingController(
      text: item?.defaultAmount != null
          ? item!.defaultAmount!.toStringAsFixed(2)
          : '',
    );

    if (type == RrhhCatalogType.bonuses) {
      _subType = item?.subType ?? 'Fija mensual';
    } else if (type == RrhhCatalogType.deductions) {
      _subType = item?.subType ?? 'Fijo';
    } else {
      _subType = item?.subType ?? '';
    }

    _isActive = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final code = _codeCtrl.text.trim().toUpperCase();
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final now = DateTime.now();

    double? amount;
    if (widget.catalogType == RrhhCatalogType.bonuses &&
        _amountCtrl.text.trim().isNotEmpty) {
      amount = double.tryParse(_amountCtrl.text.trim().replaceAll(',', '.'));
    }

    String? subTypeVal;
    if (widget.catalogType == RrhhCatalogType.bonuses ||
        widget.catalogType == RrhhCatalogType.deductions) {
      subTypeVal = _subType;
    }

    final result = RrhhCatalogItem(
      id: widget.item?.id ?? 0,
      catalogType: widget.catalogType,
      code: code,
      name: name,
      description: desc.isEmpty ? null : desc,
      subType: subTypeVal,
      defaultAmount: amount,
      isActive: _isActive,
      createdAt: widget.item?.createdAt ?? now,
      updatedAt: now,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    final type = widget.catalogType;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del Modal
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.collections_bookmark_outlined,
                        color: Color(0xFF60A5FA),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit
                                ? 'Editar en ${type.title}'
                                : 'Nuevo en ${type.title}',
                            style: GoogleFonts.inter(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            type.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 18),

                // Código y Nombre
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Código
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('CÓDIGO', isRequired: true),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _codeCtrl,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: _inputDecoration(
                              hintText: '${type.prefix}-001',
                              prefixIcon: Icons.tag,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Obligatorio';
                              }
                              final trimmed = val.trim().toUpperCase();
                              final duplicate = widget.existingItems.any(
                                (c) =>
                                    c.code.toUpperCase() == trimmed &&
                                    c.id != widget.item?.id,
                              );
                              if (duplicate) return 'Ya existe';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Nombre
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('NOMBRE', isRequired: true),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameCtrl,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            decoration: _inputDecoration(
                              hintText: 'Ej: Banco Unión, CNS, Indefinido...',
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'El nombre es obligatorio';
                              }
                              if (val.trim().length < 2) {
                                return 'Mínimo 2 caracteres';
                              }
                              final trimmed = val.trim().toLowerCase();
                              final duplicate = widget.existingItems.any(
                                (c) =>
                                    c.name.toLowerCase() == trimmed &&
                                    c.id != widget.item?.id,
                              );
                              if (duplicate)
                                return 'Ya existe un registro con este nombre';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Campos Específicos para Bonificaciones
                if (type == RrhhCatalogType.bonuses) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo de Bono
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              'TIPO DE BONIFICACIÓN',
                              isRequired: true,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF111827),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _subType.isEmpty
                                      ? 'Fija mensual'
                                      : _subType,
                                  dropdownColor: const Color(0xFF0F172A),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Fija mensual',
                                      child: Text('Fija mensual'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Por evento',
                                      child: Text('Por evento / Producción'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Variable',
                                      child: Text('Variable (Desempeño)'),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null)
                                      setState(() => _subType = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Monto o % por defecto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('MONTO SUGERIDO (BS)'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _amountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+[\.,]?\d{0,2}'),
                                ),
                              ],
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              decoration: _inputDecoration(
                                hintText: '0.00',
                                prefixText: 'Bs. ',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Campos Específicos para Descuentos
                if (type == RrhhCatalogType.deductions) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('TIPO DE DESCUENTO', isRequired: true),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _subType.isEmpty ? 'Fijo' : _subType,
                            dropdownColor: const Color(0xFF0F172A),
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: Color(0xFF94A3B8),
                            ),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Fijo',
                                child: Text('Fijo mensual'),
                              ),
                              DropdownMenuItem(
                                value: 'Porcentaje',
                                child: Text('Porcentaje sobre sueldo'),
                              ),
                              DropdownMenuItem(
                                value: 'Por evento',
                                child: Text('Por evento / Cuota única'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _subType = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Descripción
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('DESCRIPCIÓN / OBSERVACIONES'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.5,
                      ),
                      decoration: _inputDecoration(
                        hintText:
                            'Detalle sobre la aplicación legal, administrativa u operativa...',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Toggle Activo / Inactivo
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estado del Registro',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _isActive
                                ? 'Habilitado para selección en contratación y nómina'
                                : 'Deshabilitado temporalmente para nuevas asignaciones',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isActive,
                        activeThumbColor: const Color(0xFF10B981),
                        activeTrackColor: const Color(
                          0xFF10B981,
                        ).withValues(alpha: 0.25),
                        inactiveThumbColor: const Color(0xFF64748B),
                        inactiveTrackColor: const Color(0xFF1E293B),
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Botones Cancelar / Guardar
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF94A3B8),
                        side: const BorderSide(color: Color(0xFF334155)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: _handleSave,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 11,
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Actualizar Registro' : 'Crear Registro',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        color: const Color(0xFF64748B),
        fontSize: 12.5,
      ),
      prefixText: prefixText,
      prefixStyle: GoogleFonts.inter(
        color: const Color(0xFF60A5FA),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 16, color: const Color(0xFF64748B))
          : null,
      filled: true,
      fillColor: const Color(0xFF111827),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1E293B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2563EB)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
    );
  }
}
