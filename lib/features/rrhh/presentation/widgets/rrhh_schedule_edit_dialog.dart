import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_shift.dart';
import '../../data/repositories/rrhh_repository.dart';

/// Modal estilizado para crear o editar un Horario Base (Plantilla semanal de turnos).
class RrhhScheduleEditDialog extends StatefulWidget {
  final RrhhBaseSchedule? schedule;
  final VoidCallback onSaved;

  const RrhhScheduleEditDialog({
    super.key,
    this.schedule,
    required this.onSaved,
  });

  @override
  State<RrhhScheduleEditDialog> createState() => _RrhhScheduleEditDialogState();
}

class _RrhhScheduleEditDialogState extends State<RrhhScheduleEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;

  late String _workerType; // 'CAMPO', 'OFICINA', 'Ambos'
  late bool _isActive;
  bool _isSaving = false;
  String? _errorMessage;

  List<RrhhShift> _availableShifts = [];
  bool _isLoadingShifts = true;

  // Asignación de turno por día de la semana (1=Lun, ..., 7=Dom)
  // Map<dayNumber, shiftCode?>
  final Map<int, String?> _dayShiftAssignments = {
    1: null,
    2: null,
    3: null,
    4: null,
    5: null,
    6: null,
    7: null,
  };

  bool get _isEditing => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _codeCtrl = TextEditingController(text: s?.code ?? '');
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _descCtrl = TextEditingController(text: s?.description ?? '');
    _workerType = s?.workerType ?? 'CAMPO';
    _isActive = s?.isActive ?? true;

    if (s != null && s.shiftDays.isNotEmpty) {
      for (final sd in s.shiftDays) {
        if (sd.dayOfWeek >= 1 && sd.dayOfWeek <= 7) {
          _dayShiftAssignments[sd.dayOfWeek] = sd.shiftCode;
        }
      }
    }

    _loadAvailableShifts();
    if (!_isEditing) {
      _generateNextCode();
    }
  }

  Future<void> _loadAvailableShifts() async {
    try {
      final list = await RrhhRepository.current.listShifts();
      if (!mounted) return;
      setState(() {
        _availableShifts = list.where((sh) => sh.isActive).toList();
        _isLoadingShifts = false;

        // Si es nuevo y no hay asignación, sugerir de lunes a viernes con el primer turno disponible
        if (!_isEditing && _availableShifts.isNotEmpty) {
          final defaultShift = _availableShifts.first;
          for (int d = 1; d <= 5; d++) {
            _dayShiftAssignments[d] = defaultShift.code;
          }
        }
      });
    } catch (_) {
      if (mounted) setState(() => _isLoadingShifts = false);
    }
  }

  Future<void> _generateNextCode() async {
    try {
      final schedules = await RrhhRepository.current.listBaseSchedules();
      int highest = 0;
      for (final s in schedules) {
        final match = RegExp(
          r'^HORARIO-(\d+)$',
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
          _codeCtrl.text = 'HORARIO-$nextNumber';
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

  double get _calculatedWeeklyHours {
    double total = 0.0;
    for (final entry in _dayShiftAssignments.entries) {
      final code = entry.value;
      if (code != null) {
        final shift = _availableShifts.firstWhere(
          (s) => s.code == code,
          orElse: () => RrhhShift(
            id: 0,
            code: code,
            name: '',
            startTime: '08:00',
            endTime: '16:00',
            workDays: const [],
            shiftType: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        total += shift.durationHours;
      }
    }
    return total;
  }

  List<String> get _distinctShiftCodes {
    final set = <String>{};
    for (final code in _dayShiftAssignments.values) {
      if (code != null && code.isNotEmpty) {
        set.add(code);
      }
    }
    return set.toList();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final distinctShifts = _distinctShiftCodes;
    if (distinctShifts.isEmpty) {
      setState(
        () => _errorMessage =
            'Debe asignar al menos un turno a algún día de la semana.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final existing = await repo.listBaseSchedules();

      final codeNorm = _codeCtrl.text.trim().toUpperCase();
      final nameNorm = _nameCtrl.text.trim().toLowerCase();

      final codeDup = existing.any(
        (s) => s.code.toUpperCase() == codeNorm && s.id != widget.schedule?.id,
      );
      if (codeDup) {
        setState(() {
          _isSaving = false;
          _errorMessage =
              'El código "$codeNorm" ya está en uso por otro horario.';
        });
        return;
      }

      final nameDup = existing.any(
        (s) =>
            s.name.trim().toLowerCase() == nameNorm &&
            s.id != widget.schedule?.id,
      );
      if (nameDup) {
        setState(() {
          _isSaving = false;
          _errorMessage =
              'El nombre "${_nameCtrl.text.trim()}" ya existe en el catálogo.';
        });
        return;
      }

      final shiftDays = <RrhhScheduleShiftDay>[];
      for (final entry in _dayShiftAssignments.entries) {
        final day = entry.key;
        final shiftCode = entry.value;
        if (shiftCode != null) {
          final sh = _availableShifts.firstWhere(
            (s) => s.code == shiftCode,
            orElse: () => RrhhShift(
              id: 0,
              code: shiftCode,
              name: shiftCode,
              startTime: '',
              endTime: '',
              workDays: const [],
              shiftType: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          shiftDays.add(
            RrhhScheduleShiftDay(
              shiftCode: shiftCode,
              shiftName: sh.name,
              dayOfWeek: day,
            ),
          );
        }
      }

      final weeklyHrs = _calculatedWeeklyHours;

      if (_isEditing) {
        final updated = widget.schedule!.copyWith(
          code: codeNorm,
          name: _nameCtrl.text.trim(),
          includedShiftCodes: distinctShifts,
          shiftDays: shiftDays,
          workerType: _workerType,
          totalWeeklyHours: weeklyHrs,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
          isActive: _isActive,
          updatedAt: DateTime.now(),
        );
        await repo.updateBaseSchedule(updated);
      } else {
        final newSched = RrhhBaseSchedule(
          id: 0,
          code: codeNorm,
          name: _nameCtrl.text.trim(),
          includedShiftCodes: distinctShifts,
          shiftDays: shiftDays,
          workerType: _workerType,
          totalWeeklyHours: weeklyHrs,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
          isActive: _isActive,
          assignedEmployeesCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await repo.createBaseSchedule(newSched);
      }

      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Error al guardar horario: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const daysMeta = [
      (1, 'Lunes', 'Lun'),
      (2, 'Martes', 'Mar'),
      (3, 'Miércoles', 'Mié'),
      (4, 'Jueves', 'Jue'),
      (5, 'Viernes', 'Vie'),
      (6, 'Sábado', 'Sáb'),
      (7, 'Domingo', 'Dom'),
    ];

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B), width: 1.2),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 760),
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

                      // Código y Nombre
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: _buildTextField(
                              label: 'Código de Horario *',
                              controller: _codeCtrl,
                              hint: 'HORARIO-001',
                              isMonospace: true,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'El código es obligatorio';
                                }
                                if (!RegExp(
                                  r'^HORARIO-[A-Z0-9]+$',
                                  caseSensitive: false,
                                ).hasMatch(val.trim())) {
                                  return 'Formato: HORARIO-XXX';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 6,
                            child: _buildTextField(
                              label: 'Nombre de la Plantilla *',
                              controller: _nameCtrl,
                              hint: 'Ej: Horario Administrativo Central',
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

                      // Tipo de Trabajador (Segmented)
                      Text(
                        'Perfil de Trabajador Destino *',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildWorkerTypeSelector(),
                      const SizedBox(height: 18),

                      // Asignación de Turnos por Día de la Semana
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Configuración de Turnos por Día *',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Total Semanal: ${_calculatedWeeklyHours.toStringAsFixed(1)} horas',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF60A5FA),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_isLoadingShifts)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else if (_availableShifts.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF59E0B,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'No hay turnos activos creados. Debe registrar al menos un turno en la pestaña "Turnos" antes de configurar un horario base.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFFDE68A),
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: Column(
                            children: daysMeta.map((d) {
                              final currentShiftCode =
                                  _dayShiftAssignments[d.$1];
                              final isWeekend = d.$1 == 6 || d.$1 == 7;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF1E293B),
                                      width: 0.7,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isWeekend
                                            ? const Color(
                                                0xFF8B5CF6,
                                              ).withValues(alpha: 0.2)
                                            : const Color(
                                                0xFF2563EB,
                                              ).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        d.$3,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isWeekend
                                              ? const Color(0xFFA78BFA)
                                              : const Color(0xFF60A5FA),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String?>(
                                          value: currentShiftCode,
                                          isDense: true,
                                          dropdownColor: const Color(
                                            0xFF0F172A,
                                          ),
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 16,
                                            color: Color(0xFF64748B),
                                          ),
                                          hint: Text(
                                            'Día Libre / Sin turno asignado',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem<String?>(
                                              value: null,
                                              child: Text(
                                                '— Día Libre (Sin Turno) —',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: const Color(
                                                    0xFF94A3B8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ..._availableShifts.map(
                                              (sh) => DropdownMenuItem<String?>(
                                                value: sh.code,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '${sh.code}: ${sh.name} (${sh.formattedTimeRange})',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              _dayShiftAssignments[d.$1] = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    if (currentShiftCode != null)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Color(0xFF64748B),
                                        ),
                                        tooltip: 'Quitar turno de este día',
                                        onPressed: () {
                                          setState(() {
                                            _dayShiftAssignments[d.$1] = null;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(height: 18),

                      // Descripción
                      _buildTextField(
                        label: 'Descripción de la Plantilla (Opcional)',
                        controller: _descCtrl,
                        hint:
                            'Detalles operativos, rotaciones o recomendaciones de uso',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Toggle Activo
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
              Icons.date_range_rounded,
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
                      ? 'Editar Horario Base'
                      : 'Nuevo Horario Base (Plantilla)',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _isEditing
                      ? 'Modifique la combinación semanal de turnos y tipo de personal'
                      : 'Configure una plantilla semanal que combina turnos para el personal',
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

  Widget _buildWorkerTypeSelector() {
    final types = [
      ('CAMPO', 'Personal de Campo', const Color(0xFF38BDF8)),
      ('OFICINA', 'Personal de Oficina', const Color(0xFFA78BFA)),
      ('Ambos', 'Ambos Perfiles', const Color(0xFF10B981)),
    ];

    return Row(
      children: types.map((t) {
        final isSelected = _workerType == t.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => setState(() => _workerType = t.$1),
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
                  t.$2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
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
                    'Estado del Horario Base',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _isActive
                        ? 'Activo para asignación de nuevos expedientes'
                        : 'Inactivo (No elegible)',
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
                  : (_isEditing ? 'Guardar Cambios' : 'Crear Horario'),
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
