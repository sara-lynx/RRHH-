import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modal para crear o editar una Especialidad Operativa (RrhhSpecialty).
class RrhhSpecialtyEditDialog extends StatefulWidget {
  final RrhhSpecialty? specialty;
  final List<RrhhSpecialty> existingSpecialties;

  const RrhhSpecialtyEditDialog({
    super.key,
    this.specialty,
    required this.existingSpecialties,
  });

  static Future<RrhhSpecialty?> show({
    required BuildContext context,
    RrhhSpecialty? specialty,
    required List<RrhhSpecialty> existingSpecialties,
  }) {
    return showDialog<RrhhSpecialty>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhSpecialtyEditDialog(
        specialty: specialty,
        existingSpecialties: existingSpecialties,
      ),
    );
  }

  @override
  State<RrhhSpecialtyEditDialog> createState() =>
      _RrhhSpecialtyEditDialogState();
}

class _RrhhSpecialtyEditDialogState extends State<RrhhSpecialtyEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late String _selectedColor;
  late bool _isActive;

  static const List<String> _palette = [
    '#0284C7',
    '#16A34A',
    '#D97706',
    '#DC2626',
    '#9333EA',
    '#0D9488',
    '#475569',
    '#E11D48',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.specialty;
    final nextNum = widget.existingSpecialties.length + 1;
    _codeCtrl = TextEditingController(
      text: s?.code ?? 'ESP-${nextNum.toString().padLeft(3, '0')}',
    );
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _descCtrl = TextEditingController(text: s?.description ?? '');
    _selectedColor = s?.colorTag ?? _palette.first;
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.of(context).pop(
      RrhhSpecialty(
        id: widget.specialty?.id,
        code: _codeCtrl.text.trim().toUpperCase(),
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        colorTag: _selectedColor,
        isActive: _isActive,
        createdAt: widget.specialty?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Color _parseHex(String hex) =>
      Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.specialty != null;

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
                Icons.build_outlined,
                color: Color(0xFF60A5FA),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isEdit ? 'Editar Especialidad' : 'Nueva Especialidad',
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
      decoration: _inputDeco('Código de Especialidad *', 'ej. ESP-001'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'El código es obligatorio';
        final val = v.trim().toUpperCase();
        if (widget.existingSpecialties.any(
          (s) => s.code.toUpperCase() == val && s.id != widget.specialty?.id,
        )) {
          return 'Ya existe una especialidad con este código';
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
        'Nombre de la Especialidad *',
        'ej. Limpieza Hospitalaria',
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
        final val = v.trim().toLowerCase();
        if (widget.existingSpecialties.any(
          (s) => s.name.toLowerCase() == val && s.id != widget.specialty?.id,
        )) {
          return 'Ya existe una especialidad con este nombre';
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
        'Descripción Técnica (Opcional)',
        'Alcance o certificaciones requeridas',
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
          'Estado de la Especialidad',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _isActive
              ? 'Especialidad activa y asignable'
              : 'Especialidad inactiva',
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
          child: Text(
            widget.specialty == null ? 'Crear Especialidad' : 'Guardar Cambios',
          ),
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
