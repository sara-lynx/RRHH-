import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';

/// Modal para registrar o editar una incidencia disciplinaria.
class RrhhDisciplinaryEditDialog extends StatefulWidget {
  final RrhhDisciplinaryRecord? initialRecord;

  const RrhhDisciplinaryEditDialog({super.key, this.initialRecord});

  static Future<bool?> show(
    BuildContext context, {
    RrhhDisciplinaryRecord? record,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhDisciplinaryEditDialog(initialRecord: record),
    );
  }

  @override
  State<RrhhDisciplinaryEditDialog> createState() =>
      _RrhhDisciplinaryEditDialogState();
}

class _RrhhDisciplinaryEditDialogState
    extends State<RrhhDisciplinaryEditDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingEmployees = true;
  List<RrhhEmployeeSummaryDto> _employees = [];
  RrhhEmployeeSummaryDto? _selectedEmployee;

  // Bloque A
  late DateTime _incidentDate;
  TimeOfDay? _incidentTime;

  // Bloque B
  String _faultType = RrhhFaultTypes.leve;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _witnessesController = TextEditingController();
  final TextEditingController _evidenceController = TextEditingController();

  // Bloque C
  bool _requiresDischarge = false;
  late DateTime _dischargeDeadline;

  // Bloque D
  String _sanctionOption = RrhhSanctionTypes
      .verbal; // 'verbal' | 'escrita' | 'pecuniaria' | 'suspension' | 'retiro' | 'archivar'
  final TextEditingController _suspensionDaysController = TextEditingController(
    text: '1',
  );
  final TextEditingController _salaryDeductionController =
      TextEditingController();
  final TextEditingController _sanctionDescriptionController =
      TextEditingController();
  bool _notifiedEmployee = true;
  String _notificationMethod =
      'memorandum'; // 'email' | 'presencial' | 'memorandum'

  bool _isSaving = false;

  bool get isEditing => widget.initialRecord != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialRecord;
    final now = DateTime.now();

    if (item != null) {
      _incidentDate = item.incidentDate;
      _faultType = item.faultType;
      _descriptionController.text = item.incidentDescription;
      _witnessesController.text = item.witnesses ?? '';
      _evidenceController.text = item.evidenceFile ?? '';
      _requiresDischarge = item.requiresDischarge;
      _dischargeDeadline =
          item.dischargeDeadline ?? now.add(const Duration(days: 3));
      _sanctionOption = item.sanctionType ?? 'archivar';
      _suspensionDaysController.text = (item.suspensionDays ?? 1).toString();
      _salaryDeductionController.text = item.salaryDeduction != null
          ? item.salaryDeduction!.toStringAsFixed(2)
          : '';
      _sanctionDescriptionController.text = item.sanctionDescription ?? '';
      _notifiedEmployee = item.notifiedEmployee;
      _notificationMethod = item.notificationMethod ?? 'memorandum';
    } else {
      _incidentDate = now;
      _incidentTime = TimeOfDay.fromDateTime(now);
      _dischargeDeadline = _addWorkingDays(now, 3);
      _faultType = RrhhFaultTypes.leve;
      _sanctionOption = RrhhSanctionTypes.verbal;
      _onFaultTypeChanged(_faultType);
    }

    _loadEmployees();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _witnessesController.dispose();
    _evidenceController.dispose();
    _suspensionDaysController.dispose();
    _salaryDeductionController.dispose();
    _sanctionDescriptionController.dispose();
    super.dispose();
  }

  DateTime _addWorkingDays(DateTime start, int days) {
    var result = start;
    var added = 0;
    while (added < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        added++;
      }
    }
    return result;
  }

  Future<void> _loadEmployees() async {
    try {
      final list = await RrhhRepository.current.listEmployees(status: 'ACTIVO');
      if (mounted) {
        setState(() {
          _employees = list;
          _isLoadingEmployees = false;
          if (widget.initialRecord != null) {
            final empId = widget.initialRecord!.employeeId;
            final match = _employees.where((e) => e.id == empId);
            if (match.isNotEmpty) {
              _selectedEmployee = match.first;
            }
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingEmployees = false);
      }
    }
  }

  void _onFaultTypeChanged(String newType) {
    setState(() {
      _faultType = newType;
      if (newType == RrhhFaultTypes.grave ||
          newType == RrhhFaultTypes.gravisima) {
        _requiresDischarge = true;
        if (_dischargeDeadline.isBefore(DateTime.now())) {
          _dischargeDeadline = _addWorkingDays(DateTime.now(), 3);
        }
      } else {
        _requiresDischarge = false;
      }

      // Propuesta inicial sugerida según tipo de falta
      if (newType == RrhhFaultTypes.leve) {
        _sanctionOption = RrhhSanctionTypes.verbal;
      } else if (newType == RrhhFaultTypes.grave) {
        _sanctionOption = RrhhSanctionTypes.escrita;
      } else if (newType == RrhhFaultTypes.gravisima) {
        _sanctionOption = RrhhSanctionTypes.retiro;
      }
    });
  }

  String _getSupervisorForArea(String area) {
    final lower = area.toLowerCase();
    if (lower.contains('operacion') ||
        lower.contains('tecnic') ||
        lower.contains('campo')) {
      return 'Ing. Roberto Arteaga (Jefe de Operaciones)';
    } else if (lower.contains('admin') ||
        lower.contains('financ') ||
        lower.contains('rrhh')) {
      return 'Lic. Laura Mendoza (Jefa de RRHH / Admin)';
    } else if (lower.contains('comercial') || lower.contains('ventas')) {
      return 'Lic. Carlos Salinas (Gerente Comercial)';
    }
    return 'Ing. Mario Gutierrez (Supervisor General)';
  }

  double get _estimatedDailySalary => 150.0; // Salario base de cálculo en Bs.

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEmployee == null) {
      RrhhSnackBar.showWarning(context, 'Debe seleccionar un empleado.');
      return;
    }

    if (_descriptionController.text.trim().length < 30) {
      RrhhSnackBar.showWarning(
        context,
        'La descripción del hecho debe tener al menos 30 caracteres.',
      );
      return;
    }

    if (_sanctionOption != 'archivar' &&
        _sanctionDescriptionController.text.trim().isEmpty) {
      RrhhSnackBar.showWarning(
        context,
        'Debe ingresar el texto o descripción de la sanción.',
      );
      return;
    }

    int? suspensionDays;
    double? salaryDeduction;

    if (_sanctionOption == RrhhSanctionTypes.suspension) {
      suspensionDays = int.tryParse(_suspensionDaysController.text.trim()) ?? 1;
      if (suspensionDays <= 0 || suspensionDays > 5) {
        RrhhSnackBar.showError(
          context,
          'La suspensión debe ser entre 1 y 5 días según normativa.',
        );
        return;
      }
      salaryDeduction = suspensionDays * _estimatedDailySalary;
    } else if (_sanctionOption == RrhhSanctionTypes.pecuniaria) {
      salaryDeduction = double.tryParse(_salaryDeductionController.text.trim());
      if (salaryDeduction == null || salaryDeduction <= 0) {
        RrhhSnackBar.showError(context, 'Ingrese un monto válido a descontar.');
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final repo = RrhhRepository.current;

      String initialStatus;
      if (_sanctionOption == 'archivar') {
        initialStatus = RrhhDisciplinaryStatus.archivada;
      } else if (_requiresDischarge) {
        initialStatus = RrhhDisciplinaryStatus.registrada;
      } else {
        initialStatus = RrhhDisciplinaryStatus.sancionada;
      }

      final record = RrhhDisciplinaryRecord(
        id: isEditing ? widget.initialRecord!.id : 0,
        code: isEditing ? widget.initialRecord!.code : 'INC-TMP',
        employeeId: _selectedEmployee!.id,
        employeeCode: _selectedEmployee!.code,
        employeeName: _selectedEmployee!.fullName,
        incidentDate: _incidentDate,
        incidentDescription: _descriptionController.text.trim(),
        faultType: _faultType,
        evidenceFile: _evidenceController.text.trim().isNotEmpty
            ? _evidenceController.text.trim()
            : null,
        witnesses: _witnessesController.text.trim().isNotEmpty
            ? _witnessesController.text.trim()
            : null,
        requiresDischarge: _requiresDischarge,
        dischargeDeadline: _requiresDischarge ? _dischargeDeadline : null,
        dischargeText: widget.initialRecord?.dischargeText,
        dischargeDate: widget.initialRecord?.dischargeDate,
        sanctionType: _sanctionOption == 'archivar' ? null : _sanctionOption,
        suspensionDays: suspensionDays,
        sanctionDescription: _sanctionOption == 'archivar'
            ? null
            : _sanctionDescriptionController.text.trim(),
        salaryDeduction: salaryDeduction,
        notifiedEmployee: _notifiedEmployee,
        notifiedAt: _notifiedEmployee ? now : null,
        notificationMethod: _notifiedEmployee ? _notificationMethod : null,
        status: isEditing ? widget.initialRecord!.status : initialStatus,
        createdAt: isEditing ? widget.initialRecord!.createdAt : now,
        updatedAt: now,
        createdBy: isEditing
            ? widget.initialRecord!.createdBy
            : 'Lic. Laura Mendoza',
        sanctionedAt: initialStatus == RrhhDisciplinaryStatus.sancionada
            ? now
            : widget.initialRecord?.sanctionedAt,
        sanctionedBy: initialStatus == RrhhDisciplinaryStatus.sancionada
            ? 'Lic. Laura Mendoza'
            : widget.initialRecord?.sanctionedBy,
        notes: widget.initialRecord?.notes,
      );

      if (isEditing) {
        await repo.updateDisciplinaryRecord(record);
      } else {
        await repo.createDisciplinaryRecord(record);
      }

      if (mounted) {
        RrhhSnackBar.showSuccess(
          context,
          isEditing
              ? 'Incidencia actualizada correctamente.'
              : (_requiresDischarge
                    ? 'Incidencia registrada en espera de descargo.'
                    : (_sanctionOption == 'archivar'
                          ? 'Incidencia archivada sin sanción.'
                          : 'Incidencia y sanción registradas exitosamente.')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        RrhhSnackBar.showError(context, 'Error al procesar la incidencia: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 840),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Expanded(
              child: _isLoadingEmployees
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2563EB),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBlockA(),
                            const SizedBox(height: 24),
                            _buildBlockB(),
                            const SizedBox(height: 24),
                            _buildBlockC(),
                            const SizedBox(height: 24),
                            _buildBlockD(),
                          ],
                        ),
                      ),
                    ),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.gavel_outlined,
              size: 20,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Editar Incidencia Disciplinaria'
                      : 'Registrar Incidencia',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Gestión de faltas, debido proceso, descargo y sanciones conforme a ley',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            splashRadius: 18,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildBlockA() {
    return _buildBlockContainer(
      title: 'BLOQUE A — DATOS DEL EMPLEADO',
      icon: Icons.person_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('EMPLEADO *'),
          const SizedBox(height: 6),
          DropdownButtonFormField<RrhhEmployeeSummaryDto>(
            initialValue: _selectedEmployee,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
            decoration: _inputDecoration(
              hint: 'Seleccionar empleado involucrado...',
            ),
            items: _employees.map((emp) {
              return DropdownMenuItem<RrhhEmployeeSummaryDto>(
                value: emp,
                child: Text(
                  '${emp.code} — ${emp.fullName} (${emp.position})',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (emp) {
              setState(() => _selectedEmployee = emp);
            },
            validator: (val) =>
                val == null ? 'Debe seleccionar un empleado' : null,
          ),
          if (_selectedEmployee != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.badge_outlined,
                        size: 16,
                        color: Color(0xFF38BDF8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedEmployee!.code} • ${_selectedEmployee!.fullName}',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cargo: ${_selectedEmployee!.position ?? '---'} | Área: ${_selectedEmployee!.area ?? '---'}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Supervisor directo: ${_getSupervisorForArea(_selectedEmployee!.area ?? '')}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('FECHA DEL HECHO *'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _incidentDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF2563EB),
                                surface: Color(0xFF1E293B),
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          setState(() => _incidentDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _fmtDate(_incidentDate),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('HORA DEL HECHO (OPCIONAL)'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _incidentTime ?? TimeOfDay.now(),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF2563EB),
                                surface: Color(0xFF1E293B),
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          setState(() => _incidentTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              size: 16,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _incidentTime != null
                                  ? '${_incidentTime!.hour.toString().padLeft(2, '0')}:${_incidentTime!.minute.toString().padLeft(2, '0')}'
                                  : 'No especificada',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
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
        ],
      ),
    );
  }

  Widget _buildBlockB() {
    return _buildBlockContainer(
      title: 'BLOQUE B — DETALLE DE LA INCIDENCIA',
      icon: Icons.report_problem_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('TIPO DE FALTA *'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _faultType,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
            decoration: _inputDecoration(),
            items: const [
              DropdownMenuItem(
                value: RrhhFaultTypes.leve,
                child: Text(
                  'Falta Leve (llegadas tarde, incumplimiento menor)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: RrhhFaultTypes.grave,
                child: Text(
                  'Falta Grave (inasistencia injustificada, desobediencia, daño)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: RrhhFaultTypes.gravisima,
                child: Text(
                  'Falta Gravísima (robo, violencia, abandono de trabajo)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: (val) {
              if (val != null) _onFaultTypeChanged(val);
            },
          ),
          const SizedBox(height: 14),
          _fieldLabel('DESCRIPCIÓN DEL HECHO * (mínimo 30 caracteres)'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            decoration: _inputDecoration(
              hint:
                  'Detalle detalladamente lo sucedido, circunstancias de tiempo, lugar y modo...',
            ),
            validator: (val) {
              if (val == null || val.trim().length < 30) {
                return 'Debe ingresar al menos 30 caracteres descriptivos';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('TESTIGOS (OPCIONAL)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _witnessesController,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration(
                        hint: 'Ej: Juan Pérez, María López',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('EVIDENCIA ADJUNTA (OPCIONAL)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _evidenceController,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration(
                        hint: 'acta_hecho.pdf, foto_01.jpg',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            size: 18,
                            color: Color(0xFF38BDF8),
                          ),
                          tooltip: 'Adjuntar archivo simulado',
                          onPressed: () {
                            if (_evidenceController.text.isEmpty) {
                              _evidenceController.text =
                                  'evidencia_inc_${DateTime.now().millisecondsSinceEpoch}.pdf';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlockC() {
    return _buildBlockContainer(
      title: 'BLOQUE C — DEBIDO PROCESO Y DESCARGO',
      icon: Icons.shield_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _requiresDischarge,
                  activeColor: const Color(0xFF2563EB),
                  checkColor: Colors.white,
                  onChanged: (val) {
                    setState(() => _requiresDischarge = val ?? false);
                  },
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(
                      () => _requiresDischarge = !_requiresDischarge,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Requiere descargo del empleado?',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Obligatorio por normativa para Faltas Graves o Gravísimas antes de aplicar sanción',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_requiresDischarge) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('FECHA LÍMITE DE DESCARGO *'),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dischargeDeadline,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                            builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFF2563EB),
                                  surface: Color(0xFF1E293B),
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setState(() => _dischargeDeadline = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _fmtDate(_dischargeDeadline),
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12.5,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '(3 días hábiles sugeridos)',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
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
          ],
        ],
      ),
    );
  }

  Widget _buildBlockD() {
    return _buildBlockContainer(
      title: 'BLOQUE D — SANCIÓN PROPUESTA O ACCIÓN',
      icon: Icons.gavel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('SANCIÓN PROPUESTA *'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _sanctionOption,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
            decoration: _inputDecoration(),
            items: const [
              DropdownMenuItem(
                value: RrhhSanctionTypes.verbal,
                child: Text(
                  'Amonestación verbal',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: RrhhSanctionTypes.escrita,
                child: Text(
                  'Amonestación escrita (memorándum)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: RrhhSanctionTypes.pecuniaria,
                child: Text(
                  'Sanción pecuniaria (descuento salarial)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: RrhhSanctionTypes.suspension,
                child: Text(
                  'Suspensión sin goce (máx. 5 días)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: RrhhSanctionTypes.retiro,
                child: Text(
                  'Retiro / Destitución',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: 'archivar',
                child: Text(
                  'Archivar sin sanción',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _sanctionOption = val);
              }
            },
          ),
          if (_sanctionOption == RrhhSanctionTypes.suspension) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('DÍAS DE SUSPENSIÓN (1 a 5) *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _suspensionDaysController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        decoration: _inputDecoration(hint: '1 - 5'),
                        onChanged: (_) => setState(() {}),
                        validator: (val) {
                          final n = int.tryParse(val ?? '');
                          if (n == null || n < 1 || n > 5)
                            return 'Máximo 5 días';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('DESCUENTO SALARIAL ESTIMADO'),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              size: 16,
                              color: Color(0xFFF97316),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Bs. ${((int.tryParse(_suspensionDaysController.text.trim()) ?? 0) * _estimatedDailySalary).toStringAsFixed(2)}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF97316),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '(${_suspensionDaysController.text.trim().isEmpty ? "0" : _suspensionDaysController.text.trim()}d × Bs. 150/día)',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
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
          ],
          if (_sanctionOption == RrhhSanctionTypes.pecuniaria) ...[
            const SizedBox(height: 14),
            _fieldLabel('MONTO A DESCONTAR (Bs.) *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _salaryDeductionController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              decoration: _inputDecoration(
                hint: 'Ej: 300.00 (descuento salarial por falta injustificada)',
                prefixText: 'Bs. ',
              ),
              validator: (val) {
                final d = double.tryParse(val ?? '');
                if (d == null || d <= 0) return 'Monto obligatorio mayor a 0';
                return null;
              },
            ),
          ],
          if (_sanctionOption != 'archivar') ...[
            const SizedBox(height: 14),
            _fieldLabel('DESCRIPCIÓN DE LA SANCIÓN (MEMORÁNDUM) *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _sanctionDescriptionController,
              maxLines: 2,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              decoration: _inputDecoration(
                hint:
                    'Texto que se plasmará en el memorándum formal y legajo personal...',
              ),
              validator: (val) {
                if (_sanctionOption != 'archivar' &&
                    (val == null || val.trim().isEmpty)) {
                  return 'Debe ingresar la descripción de la sanción';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Checkbox(
                value: _notifiedEmployee,
                activeColor: const Color(0xFF2563EB),
                checkColor: Colors.white,
                onChanged: (val) =>
                    setState(() => _notifiedEmployee = val ?? false),
              ),
              Text(
                'Notificar al empleado involucrado',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              ),
              if (_notifiedEmployee) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _notificationMethod,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E293B),
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF94A3B8),
                    ),
                    decoration: _inputDecoration(hint: 'Método'),
                    items: const [
                      DropdownMenuItem(
                        value: 'memorandum',
                        child: Text(
                          'Memorándum físico firmado',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'email',
                        child: Text(
                          'Correo corporativo',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'presencial',
                        child: Text(
                          'Notificación presencial',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null)
                        setState(() => _notificationMethod = val);
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlockContainer({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: _isSaving
                ? null
                : () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF334155)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check, size: 16, color: Colors.white),
            label: Text(
              isEditing ? 'Guardar Cambios' : 'Registrar Incidencia',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    String? prefixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      prefixStyle: GoogleFonts.inter(
        color: const Color(0xFFF97316),
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: suffixIcon,
      hintStyle: GoogleFonts.inter(
        fontSize: 12.5,
        color: const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: const Color(0xFF111827),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }

  String _fmtDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
