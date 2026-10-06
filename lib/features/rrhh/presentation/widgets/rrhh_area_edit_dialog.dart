import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modal para crear o editar un Área Departamental (RrhhArea).
class RrhhAreaEditDialog extends StatefulWidget {
  final RrhhArea? area;
  final List<RrhhArea> existingAreas;
  final int activePositionsCount;

  const RrhhAreaEditDialog({
    super.key,
    this.area,
    required this.existingAreas,
    this.activePositionsCount = 0,
  });

  static Future<RrhhArea?> show({
    required BuildContext context,
    RrhhArea? area,
    required List<RrhhArea> existingAreas,
    int activePositionsCount = 0,
  }) {
    return showDialog<RrhhArea>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhAreaEditDialog(
        area: area,
        existingAreas: existingAreas,
        activePositionsCount: activePositionsCount,
      ),
    );
  }

  @override
  State<RrhhAreaEditDialog> createState() => _RrhhAreaEditDialogState();
}

class _RrhhAreaEditDialogState extends State<RrhhAreaEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late String _selectedColor;
  late bool _isActive;

  static const List<String> _palette = [
    '#2563EB',
    '#10B981',
    '#F59E0B',
    '#EF4444',
    '#8B5CF6',
    '#06B6D4',
    '#EC4899',
    '#475569',
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.area;
    final nextNum = widget.existingAreas.length + 1;
    _codeCtrl = TextEditingController(
      text: a?.code ?? 'AREA-${nextNum.toString().padLeft(3, '0')}',
    );
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    _descCtrl = TextEditingController(text: a?.description ?? '');
    _selectedColor = a?.colorTag ?? _palette.first;
    _isActive = a?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.area != null &&
        widget.area!.isActive &&
        !_isActive &&
        widget.activePositionsCount > 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          title: Text(
            'Advertencia de Dependencia',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Esta área tiene ${widget.activePositionsCount} cargo(s) activo(s) asociado(s).\n\n¿Desea desactivar el área de todos modos?',
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

    final now = DateTime.now();
    if (!mounted) return;
    Navigator.of(context).pop(
      RrhhArea(
        id: widget.area?.id,
        code: _codeCtrl.text.trim().toUpperCase(),
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        colorTag: _selectedColor,
        isActive: _isActive,
        createdAt: widget.area?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Color _parseHex(String hex) =>
      Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.area != null;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isEdit),
                const SizedBox(height: 16),
                _buildCodeField(),
                const SizedBox(height: 12),
                _buildNameField(),
                const SizedBox(height: 12),
                _buildDescField(),
                const SizedBox(height: 12),
                _buildColorSelector(),
                const SizedBox(height: 12),
                _buildActiveSwitch(),
                const SizedBox(height: 20),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: Color(0xFF60A5FA),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isEdit ? 'Editar Área Departamental' : 'Nueva Área Departamental',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
          tooltip: 'Cerrar',
        ),
      ],
    );
  }

  Widget _buildCodeField() {
    return TextFormField(
      controller: _codeCtrl,
      textCapitalization: TextCapitalization.characters,
      style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 13),
      decoration: _inputDeco('Código de Área *', 'ej. AREA-OPS'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'El código es obligatorio';
        final val = v.trim().toUpperCase();
        if (widget.existingAreas.any(
          (a) => a.code.toUpperCase() == val && a.id != widget.area?.id,
        )) {
          return 'Ya existe un área con este código';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameCtrl,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
      decoration: _inputDeco(
        'Nombre del Área *',
        'ej. Operaciones & Servicios',
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
        final val = v.trim().toLowerCase();
        if (widget.existingAreas.any(
          (a) => a.name.toLowerCase() == val && a.id != widget.area?.id,
        )) {
          return 'Ya existe un área con este nombre';
        }
        return null;
      },
    );
  }

  Widget _buildDescField() {
    return TextFormField(
      controller: _descCtrl,
      maxLines: 2,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
      decoration: _inputDeco(
        'Descripción (Opcional)',
        'Propósito funcional del departamento',
      ),
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Identificador',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _palette.map((hex) {
            final isSel = _selectedColor.toUpperCase() == hex.toUpperCase();
            final c = _parseHex(hex);
            return InkWell(
              onTap: () => setState(() => _selectedColor = hex),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSel ? Colors.white : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSel
                      ? [
                          BoxShadow(
                            color: c.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                child: isSel
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActiveSwitch() {
    return Material(
      color: const Color(0xFF111C30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SwitchListTile(
        title: Text(
          'Estado Operativo',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _isActive
              ? 'Área activa para asignaciones'
              : 'Área desactivada (Inactiva)',
          style: GoogleFonts.inter(
            fontSize: 11.5,
            color: const Color(0xFF94A3B8),
          ),
        ),
        value: _isActive,
        activeThumbColor: const Color(0xFF10B981),
        onChanged: (val) => setState(() => _isActive = val),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF94A3B8),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
          ),
          child: Text(widget.area == null ? 'Crear Área' : 'Guardar Cambios'),
        ),
      ],
    );
  }

  InputDecoration _inputDeco(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.inter(
        color: const Color(0xFF94A3B8),
        fontSize: 12.5,
      ),
      hintStyle: GoogleFonts.inter(
        color: const Color(0xFF475569),
        fontSize: 12,
      ),
      filled: true,
      fillColor: const Color(0xFF111827),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
    );
  }
}
