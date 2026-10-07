import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Modal para creación de nuevo turno u horario laboral.
class EliteShiftFormDialog extends ConsumerStatefulWidget {
  const EliteShiftFormDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const EliteShiftFormDialog(),
    );
  }

  @override
  ConsumerState<EliteShiftFormDialog> createState() =>
      _EliteShiftFormDialogState();
}

class _EliteShiftFormDialogState extends ConsumerState<EliteShiftFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController(text: 'TUR-SEG-08');
  final _nameController = TextEditingController(text: 'Seguridad 8h Tarde');
  final _graceController = TextEditingController(text: '5');
  final _activeDaysController =
      TextEditingController(text: 'Lunes a Sábado');

  ShiftWorkplaceType _workplaceType = ShiftWorkplaceType.campo;
  TimeOfDay _startTime = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 22, minute: 0);
  bool _crossesMidnight = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _graceController.dispose();
    _activeDaysController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final shiftsCount = ref.read(rrhhShiftsProvider).length;
    final newShift = EliteShift(
      id: 'SFT-${(shiftsCount + 1).toString().padLeft(3, '0')}',
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      workplaceType: _workplaceType,
      startTime: _startTime,
      endTime: _endTime,
      gracePeriodMinutes: int.tryParse(_graceController.text.trim()) ?? 5,
      crossesMidnight: _crossesMidnight,
      activeDays: _activeDaysController.text.trim(),
    );

    ref.read(rrhhShiftsProvider.notifier).addShift(newShift);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0D9488),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          'Turno ${newShift.name} (${newShift.code}) registrado correctamente.',
          style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.alarm_add_outlined,
                      size: 18,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nuevo Turno / Horario',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Catálogo oficial de cuadrantes y tolerancias de ingreso',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alcance (Oficina / Campo)
                    Text(
                      'TIPO DE ALCANCE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildScopeOption(
                            type: ShiftWorkplaceType.campo,
                            label: 'Personal de Campo',
                            icon: Icons.engineering_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildScopeOption(
                            type: ShiftWorkplaceType.oficina,
                            label: 'Personal de Oficina',
                            icon: Icons.apartment_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: _buildTextField(
                            controller: _codeController,
                            label: 'Código de Turno',
                            hint: 'TUR-SEG-08',
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 6,
                          child: _buildTextField(
                            controller: _nameController,
                            label: 'Nombre Descriptivo',
                            hint: 'Seguridad 8h Tarde',
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Horas de inicio y fin
                    Text(
                      'HORARIO DIARIO Y TOLERANCIA',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerBox(
                            label: 'Hora Inicio',
                            time: _startTime,
                            onTap: () => _pickTime(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTimePickerBox(
                            label: 'Hora Fin',
                            time: _endTime,
                            onTap: () => _pickTime(isStart: false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _graceController,
                            label: 'Tolerancia (min)',
                            hint: '5',
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Switch cruza medianoche
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.nights_stay_outlined,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Turno Nocturno (Cruza Medianoche)',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  'Marca la jornada como finalizada al día siguiente (+1d)',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _crossesMidnight,
                            activeTrackColor: const Color(0xFF0D9488),
                            activeThumbColor: Colors.white,
                            onChanged: (val) =>
                                setState(() => _crossesMidnight = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildTextField(
                      controller: _activeDaysController,
                      label: 'Días Laborables / Frecuencia',
                      hint: 'Ej: Lunes a Viernes, Rotativo Continuo 4x2',
                      validator: (v) =>
                          v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                  ],
                ),
              ),
            ),

            // Footer modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(
                      'Guardar Turno',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
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

  Widget _buildScopeOption({
    required ShiftWorkplaceType type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _workplaceType == type;
    final color = type == ShiftWorkplaceType.oficina
        ? const Color(0xFF2563EB)
        : const Color(0xFF0D9488);

    return InkWell(
      onTap: () => setState(() => _workplaceType = type),
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (type == ShiftWorkplaceType.oficina
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF0FDFA))
              : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? color : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerBox({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeStr,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
