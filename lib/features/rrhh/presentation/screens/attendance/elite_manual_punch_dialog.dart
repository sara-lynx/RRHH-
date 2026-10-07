import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import '../../widgets/elite_searchable_select.dart';

/// Modal de alta para Marcación Manual de Asistencia autorizada por Supervisor.
class EliteManualPunchDialog extends ConsumerStatefulWidget {
  const EliteManualPunchDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const EliteManualPunchDialog(),
    );
  }

  @override
  ConsumerState<EliteManualPunchDialog> createState() =>
      _EliteManualPunchDialogState();
}

class _EliteManualPunchDialogState
    extends ConsumerState<EliteManualPunchDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedEmployeeId;
  AttendancePunchType _punchType = AttendancePunchType.entrada;
  TimeOfDay _punchTime = TimeOfDay.now();
  AttendanceEvaluation _evaluation = AttendanceEvaluation.puntual;
  int _lateMinutes = 0;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _punchTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0D9488),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Color(0xFF0F172A),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() => _punchTime = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmployeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFDC2626),
          content: Text('Seleccione un colaborador obligatorio.'),
        ),
      );
      return;
    }

    final employees = ref.read(rrhhEmployeesProvider);
    final emp = employees.firstWhere((e) => e.id == _selectedEmployeeId);

    final now = DateTime.now();
    final punchDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _punchTime.hour,
      _punchTime.minute,
    );

    final newRecord = EliteAttendanceRecord(
      id: 'ATT-MAN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      employeeId: emp.id,
      employeeName: emp.fullName,
      employeeJobTitle: emp.position,
      workplaceType: emp.workplaceType,
      serviceLineCode: emp.serviceLineCode,
      assignedSite: emp.assignedSite,
      shiftName: emp.isOffice
          ? 'Administrativo Central 8h'
          : 'Turno Operativo Asignado',
      punchType: _punchType,
      timestamp: punchDateTime,
      source: AttendanceSource.manualSupervisor,
      evaluation: _evaluation,
      lateMinutes: _evaluation == AttendanceEvaluation.retraso ? _lateMinutes : 0,
      ipAddress: emp.isOffice ? 'Manual Supervisor (ERP)' : null,
      deviceBrowser: 'Portal Administrativo Elite',
      geofenceStatus: GeofenceStatus.noAplica,
    );

    ref.read(rrhhAttendanceProvider.notifier).addRecord(newRecord);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0D9488),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Marcación manual registrada para ${emp.fullName} (${_punchType.label} - ${_formatTimeOfDay(_punchTime)}).',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(rrhhEmployeesProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header del Modal (~44px)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    child: const Icon(
                      Icons.more_time_outlined,
                      size: 16,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrar Marcación Manual',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Autorización directa de Supervisor • Auditoría trazable',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 16,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: const Color(0xFF64748B),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Formulario Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Colaborador
                    Text(
                      'Colaborador',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    EliteSearchableSelect<EliteEmployee>(
                      value: employees
                          .where((e) => e.id == _selectedEmployeeId)
                          .firstOrNull,
                      items: employees,
                      placeholder: 'Seleccione el colaborador...',
                      searchPlaceholder:
                          'Escriba para filtrar por nombre, CI o Centro de Costo...',
                      itemTitle: (emp) => emp.fullName,
                      itemSubtitle: (emp) => '${emp.ci} • ${emp.position}',
                      itemCostCenter: (emp) => emp.serviceLineCode,
                      onChanged: (emp) {
                        setState(() => _selectedEmployeeId = emp?.id);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Tipo de Marcación y Hora
                    Row(
                      children: [
                        // Tipo Punch
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo de Marcación',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<AttendancePunchType>(
                                initialValue: _punchType,
                                dropdownColor: Colors.white,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
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
                                items: AttendancePunchType.values.map((t) {
                                  return DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      t.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _punchType = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Hora Punch
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hora de Registro',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _selectTime,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_outlined,
                                        size: 16,
                                        color: Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatTimeOfDay(_punchTime),
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 18,
                                        color: Color(0xFF64748B),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Evaluación y Minutos Retraso
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Evaluación Reglamentaria',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<AttendanceEvaluation>(
                                initialValue: _evaluation,
                                dropdownColor: Colors.white,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
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
                                items: AttendanceEvaluation.values.map((ev) {
                                  return DropdownMenuItem(
                                    value: ev,
                                    child: Text(
                                      ev.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: ev.badgeColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _evaluation = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (_evaluation == AttendanceEvaluation.retraso) ...[
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Minutos de Retraso',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  initialValue: '$_lateMinutes',
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    suffixText: 'min',
                                    suffixStyle: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFF64748B),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
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
                                  onChanged: (val) {
                                    setState(() {
                                      _lateMinutes = int.tryParse(val) ?? 0;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Justificación / Motivo
                    Text(
                      'Motivo o Justificación del Supervisor',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        hintText:
                            'Ej: Falla en transporte público, reposición de guardia o autorización de gerencia...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF94A3B8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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
                ),
              ),
            ),

            // Footer de Acciones (~48px)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check, size: 14, color: Colors.white),
                    label: Text(
                      'Guardar Marcación',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 32),
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
