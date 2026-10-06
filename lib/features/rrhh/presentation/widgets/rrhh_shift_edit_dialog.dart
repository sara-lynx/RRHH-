import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_shift.dart';
import '../../data/repositories/rrhh_repository.dart';

/// Modal estilizado para crear o editar un Turno de Trabajo (Catálogo RRHH).
/// Sigue la estética ejecutiva del sistema (Canvas #0B0F19, Contenedores #0F172A).
class RrhhShiftEditDialog extends StatefulWidget {
  final RrhhShift? shift;
  final VoidCallback onSaved;

  const RrhhShiftEditDialog({
    super.key,
    this.shift,
    required this.onSaved,
  });

  @override
  State<RrhhShiftEditDialog> createState() => _RrhhShiftEditDialogState();
}

class _RrhhShiftEditDialogState extends State<RrhhShiftEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late List<int> _selectedDays;
  late String _shiftType;
  late bool _isActive;
  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditing => widget.shift != null;

  @override
  void initState() {
    super.initState();
    final s = widget.shift;
    _codeCtrl = TextEditingController(text: s?.code ?? '');
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _descCtrl = TextEditingController(text: s?.description ?? '');

    _startTime = s != null
        ? _parseTime(s.startTime)
        : const TimeOfDay(hour: 8, minute: 0);
    _endTime = s != null
        ? _parseTime(s.endTime)
        : const TimeOfDay(hour: 16, minute: 0);
    _selectedDays = s != null ? List<int>.from(s.workDays) : [1, 2, 3, 4, 5];
    _shiftType = s?.shiftType ?? 'Completa';
    _isActive = s?.isActive ?? true;

    if (!_isEditing) {
      _generateNextCode();
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final h = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 8 : 8;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _generateNextCode() async {
    try {
      final shifts = await RrhhRepository.current.listShifts();
      int highest = 0;
      for (final s in shifts) {
        final match = RegExp(
          r'^TURNO-(\d+)$',
          caseSensitive: false,
        ).firstMatch(s.code);
        if (match != null) {
          final n = int.tryParse(match.group(1)!) ?? 0;
          if (n > highest) highest = n;
        }
      }
      final nextNumber = (highest + 1).toString().padLeft(3, '0');
      if (mounted && _codeCtrl.text.isEmpty) {
        setState(() {
          _codeCtrl.text = 'TURNO-$nextNumber';
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _isCrossMidnight {
    final startMin = _startTime.hour * 60 + _startTime.minute;
    final endMin = _endTime.hour * 60 + _endTime.minute;
    return endMin <= startMin;
  }

  double get _calculatedDurationHours {
    final startMin = _startTime.hour * 60 + _startTime.minute;
    final endMin = _endTime.hour * 60 + _endTime.minute;
    int diff;
    if (endMin > startMin) {
      diff = endMin - startMin;
    } else {
      diff = (24 * 60 - startMin) + endMin;
    }
    return diff / 60.0;
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2563EB),
              surface: Color(0xFF0F172A),
              onSurface: Color(0xFFF8FAFC),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        // Auto-sugerir jornada nocturna si cruza medianoche
        if (_isCrossMidnight && _shiftType != 'Nocturna') {
          _shiftType = 'Nocturna';
        }
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDays.isEmpty) {
      setState(
        () => _errorMessage = 'Debe seleccionar al menos un día de la semana.',
      );
      return;
    }

    if (_startTime.hour == _endTime.hour &&
        _startTime.minute == _endTime.minute) {
      setState(
        () => _errorMessage =
            'La hora de inicio y fin no pueden ser exactamente iguales.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final existingShifts = await repo.listShifts();

      final codeNorm = _codeCtrl.text.trim().toUpperCase();
      final nameNorm = _nameCtrl.text.trim().toLowerCase();

      final codeDup = existingShifts.any(
        (s) => s.code.toUpperCase() == codeNorm && s.id != widget.shift?.id,
      );
      if (codeDup) {
        setState(() {
          _isSaving = false;
          _errorMessage =
              'El código "$codeNorm" ya está en uso por otro turno.';
        });
        return;
      }

      final nameDup = existingShifts.any(
        (s) =>
            s.name.trim().toLowerCase() == nameNorm && s.id != widget.shift?.id,
      );
      if (nameDup) {
        setState(() {
          _isSaving = false;
          _errorMessage =
              'El nombre "${_nameCtrl.text.trim()}" ya existe en el catálogo.';
        });
        return;
      }

      final startStr = _formatTime(_startTime);
      final endStr = _formatTime(_endTime);

      if (_isEditing) {
        final updated = widget.shift!.copyWith(
          code: codeNorm,
          name: _nameCtrl.text.trim(),
          startTime: startStr,
          endTime: endStr,
          workDays: _selectedDays,
          shiftType: _shiftType,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
          isActive: _isActive,
          updatedAt: DateTime.now(),
        );
        await repo.updateShift(updated);
      } else {
        final newShift = RrhhShift(
          id: 0,
          code: codeNorm,
          name: _nameCtrl.text.trim(),
          startTime: startStr,
          endTime: endStr,
          workDays: _selectedDays,
          shiftType: _shiftType,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
          isActive: _isActive,
          assignedEmployeesCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await repo.createShift(newShift);
      }

      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Error al guardar turno: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B), width: 1.2),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModalHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage != null) _buildErrorBanner(),

                      // Fila: Código y Nombre
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: _buildTextField(
                              label: 'Código de Turno *',
                              controller: _codeCtrl,
                              hint: 'TURNO-001',
                              isMonospace: true,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'El código es obligatorio';
                                }
                                if (!RegExp(
                                  r'^TURNO-[A-Z0-9]+$',
                                  caseSensitive: false,
                                ).hasMatch(val.trim())) {
                                  return 'Formato: TURNO-XXX';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 6,
                            child: _buildTextField(
                              label: 'Nombre del Turno *',
                              controller: _nameCtrl,
                              hint: 'Ej: Turno Mañana Operativo',
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'El nombre es obligatorio';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Horarios (Inicio y Fin) + Duración calculada
                      Text(
                        'Horario de Trabajo (24h) *',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePickerCard(
                              label: 'Hora Inicio',
                              time: _startTime,
                              onTap: () => _pickTime(true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTimePickerCard(
                              label: 'Hora Fin',
                              time: _endTime,
                              onTap: () => _pickTime(false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Badge de duración y advertencia de medianoche
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
                          children: [
                            Icon(
                              _isCrossMidnight
                                  ? Icons.nights_stay_outlined
                                  : Icons.timer_outlined,
                              size: 16,
                              color: _isCrossMidnight
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF60A5FA),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Duración: ${_calculatedDurationHours.toStringAsFixed(1)} horas / día',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            if (_isCrossMidnight) ...[
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Cruza medianoche (+1 día)',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Días de la semana (L M X J V S D)
                      Text(
                        'Días de Aplicación Semanal *',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDaysSelector(),
                      const SizedBox(height: 18),

                      // Tipo de Jornada (Segmented)
                      Text(
                        'Tipo de Jornada Laboral *',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildShiftTypeSelector(),
                      const SizedBox(height: 18),

                      // Descripción (opcional)
                      _buildTextField(
                        label: 'Descripción u Observaciones (Opcional)',
                        controller: _descCtrl,
                        hint:
                            'Especificaciones de alcance, sedes sugeridas o notas operativas',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Toggle Estado Activo
                      _buildActiveToggle(),
                    ],
                  ),
                ),
              ),
            ),
            _buildModalFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.schedule_rounded,
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
                  _isEditing
                      ? 'Editar Turno de Trabajo'
                      : 'Nuevo Turno de Trabajo',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _isEditing
                      ? 'Actualice los parámetros horarios y días laborables del turno'
                      : 'Defina un nuevo bloque horario reutilizable para la asignación de personal',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerCard({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 18,
              color: Color(0xFF60A5FA),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(time),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
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

  Widget _buildDaysSelector() {
    const days = [
      (1, 'L', 'Lunes'),
      (2, 'M', 'Martes'),
      (3, 'X', 'Miércoles'),
      (4, 'J', 'Jueves'),
      (5, 'V', 'Viernes'),
      (6, 'S', 'Sábado'),
      (7, 'D', 'Domingo'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) {
        final isSelected = _selectedDays.contains(d.$1);
        final isWeekend = d.$1 == 6 || d.$1 == 7;
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDays.remove(d.$1);
              } else {
                _selectedDays.add(d.$1);
              }
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Tooltip(
            message: d.$3,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isWeekend
                          ? const Color(0xFF8B5CF6)
                          : const Color(0xFF2563EB))
                    : const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? (isWeekend
                            ? const Color(0xFFA78BFA)
                            : const Color(0xFF3B82F6))
                      : const Color(0xFF1E293B),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                d.$2,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShiftTypeSelector() {
    final types = [
      ('Completa', 'Jornada Completa', const Color(0xFF10B981)),
      ('Parcial', 'Media Jornada / Parcial', const Color(0xFF38BDF8)),
      ('Nocturna', 'Jornada Nocturna', const Color(0xFFF59E0B)),
    ];

    return Row(
      children: types.map((t) {
        final isSelected = _shiftType == t.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => setState(() => _shiftType = t.$1),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? t.$3.withValues(alpha: 0.15)
                      : const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? t.$3 : const Color(0xFF1E293B),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  t.$1,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? t.$3 : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActiveToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _isActive ? Icons.check_circle_outline : Icons.block_flipped,
                size: 18,
                color: _isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado del Turno',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _isActive
                        ? 'Activo para asignación de nuevos horarios'
                        : 'Inactivo (No elegible en nuevas plantillas)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _isActive,
            activeThumbColor: const Color(0xFF10B981),
            onChanged: (val) => setState(() => _isActive = val),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: Color(0xFFEF4444)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFFCA5A5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    bool isMonospace = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: isMonospace
              ? GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                )
              : GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 12.5,
            ),
            filled: true,
            fillColor: const Color(0xFF111827),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
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
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildModalFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF1E293B)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 13)),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: _isSaving
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 16),
            label: Text(
              _isSaving
                  ? 'Guardando...'
                  : (_isEditing ? 'Guardar Cambios' : 'Crear Turno'),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
