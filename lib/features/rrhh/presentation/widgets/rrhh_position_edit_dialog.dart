import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modal para crear o editar un Cargo de Trabajo (RrhhPosition).
class RrhhPositionEditDialog extends StatefulWidget {
  final RrhhPosition? position;
  final List<RrhhArea> availableAreas;
  final List<RrhhPosition> existingPositions;

  const RrhhPositionEditDialog({
    super.key,
    this.position,
    required this.availableAreas,
    required this.existingPositions,
  });

  static Future<RrhhPosition?> show({
    required BuildContext context,
    RrhhPosition? position,
    required List<RrhhArea> availableAreas,
    required List<RrhhPosition> existingPositions,
  }) {
    return showDialog<RrhhPosition>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhPositionEditDialog(
        position: position,
        availableAreas: availableAreas,
        existingPositions: existingPositions,
      ),
    );
  }

  @override
  State<RrhhPositionEditDialog> createState() => _RrhhPositionEditDialogState();
}

class _RrhhPositionEditDialogState extends State<RrhhPositionEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _salaryCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _reqsCtrl;
  int? _selectedAreaId;
  String _workplaceType = 'CAMPO';
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final p = widget.position;
    final nextNum = widget.existingPositions.length + 1;
    _codeCtrl = TextEditingController(
      text: p?.code ?? 'CARGO-${nextNum.toString().padLeft(3, '0')}',
    );
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _salaryCtrl = TextEditingController(
      text: (p?.suggestedSalary != null && p!.suggestedSalary! > 0)
          ? p.suggestedSalary!.toStringAsFixed(0)
          : '',
    );
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _reqsCtrl = TextEditingController(text: p?.requirements ?? '');
    _selectedAreaId =
        p?.areaId ??
        (widget.availableAreas.isNotEmpty
            ? widget.availableAreas.first.id
            : null);
    _workplaceType = p?.workplaceType.toUpperCase() == 'OFICINA'
        ? 'OFICINA'
        : 'CAMPO';
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _salaryCtrl.dispose();
    _descCtrl.dispose();
    _reqsCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAreaId == null) {
      RrhhSnackBar.showWarning(context, 'Seleccione un área departamental');
      return;
    }
    final salary = _salaryCtrl.text.trim().isNotEmpty
        ? double.tryParse(_salaryCtrl.text.trim().replaceAll(',', '.'))
        : null;
    final now = DateTime.now();
    Navigator.of(context).pop(
      RrhhPosition(
        id: widget.position?.id,
        code: _codeCtrl.text.trim().toUpperCase(),
        areaId: _selectedAreaId!,
        name: _nameCtrl.text.trim(),
        workplaceType: _workplaceType,
        suggestedSalary: salary,
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        requirements: _reqsCtrl.text.trim().isEmpty
            ? null
            : _reqsCtrl.text.trim(),
        isActive: _isActive,
        createdAt: widget.position?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.position != null;
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isEdit),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _buildCodeField()),
                      const SizedBox(width: 12),
                      Expanded(flex: 6, child: _buildTypeSelector()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNameField(),
                  const SizedBox(height: 12),
                  _buildAreaDropdown(),
                  const SizedBox(height: 12),
                  _buildSalaryField(),
                  const SizedBox(height: 12),
                  _buildDescField(),
                  const SizedBox(height: 12),
                  _buildReqsField(),
                  const SizedBox(height: 12),
                  _buildActiveSwitch(),
                  const SizedBox(height: 20),
                  _buildActions(),
                ],
              ),
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
                Icons.badge_outlined,
                color: Color(0xFF60A5FA),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isEdit ? 'Editar Cargo de Trabajo' : 'Nuevo Cargo de Trabajo',
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
      decoration: _inputDeco('Código *', 'CARGO-001'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Requerido';
        final val = v.trim().toUpperCase();
        if (widget.existingPositions.any(
          (p) => p.code.toUpperCase() == val && p.id != widget.position?.id,
        ))
          return 'Duplicado';
        return null;
      },
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entorno *',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: ['CAMPO', 'OFICINA'].map((t) {
            final isSel = _workplaceType == t;
            final col = t == 'CAMPO'
                ? const Color(0xFFF59E0B)
                : const Color(0xFF3B82F6);
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: t == 'CAMPO' ? 6 : 0),
                child: InkWell(
                  onTap: () => setState(() => _workplaceType = t),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: isSel
                          ? col.withValues(alpha: 0.18)
                          : const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSel ? col : const Color(0xFF1E293B),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? Colors.white : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameCtrl,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
      decoration: _inputDeco(
        'Título del Cargo *',
        'ej. Guardia de Seguridad Operativo',
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'El título es obligatorio' : null,
    );
  }

  Widget _buildAreaDropdown() {
    return DropdownButtonFormField<int>(
      initialValue: _selectedAreaId,
      dropdownColor: const Color(0xFF0F172A),
      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
      decoration: _inputDeco('Área Departamental Padre *', ''),
      items: widget.availableAreas
          .map(
            (a) => DropdownMenuItem<int>(
              value: a.id,
              child: Text(
                '${a.name} (${a.code})',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => _selectedAreaId = val),
      validator: (val) => val == null ? 'Área requerida' : null,
    );
  }

  Widget _buildSalaryField() {
    return TextFormField(
      controller: _salaryCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 13),
      decoration: _inputDeco('Sueldo Sugerido (Bs.) 🔒', 'ej. 3200 (Opcional)')
          .copyWith(
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 16,
              color: Color(0xFFF59E0B),
            ),
          ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        final numVal = double.tryParse(v.trim().replaceAll(',', '.'));
        if (numVal == null || numVal <= 0) return 'Debe ser mayor a 0';
        return null;
      },
    );
  }

  Widget _buildDescField() => TextFormField(
    controller: _descCtrl,
    maxLines: 2,
    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
    decoration: _inputDeco(
      'Descripción del Cargo (Opcional)',
      'Responsabilidades',
    ),
  );

  Widget _buildReqsField() => TextFormField(
    controller: _reqsCtrl,
    maxLines: 2,
    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
    decoration: _inputDeco(
      'Requisitos / Perfil (Opcional)',
      'Experiencia, licencias',
    ),
  );

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
          'Estado del Puesto',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _isActive
              ? 'Puesto activo para contrataciones'
              : 'Puesto inactivo / congelado',
          style: GoogleFonts.inter(
            fontSize: 11,
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
            widget.position == null ? 'Crear Cargo' : 'Guardar Cambios',
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
