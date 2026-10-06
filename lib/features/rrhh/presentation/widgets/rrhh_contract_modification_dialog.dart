import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../security/services/auth_service.dart';
import '../../data/models/rrhh_shift.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';

class RrhhContractModificationResult {
  final bool success;
  final bool isSensitive; // Si cambió salario o tipo de contrato

  const RrhhContractModificationResult({
    required this.success,
    required this.isSensitive,
  });
}

/// Modal en DOS PASOS para Modificar Datos Contractuales con trazabilidad obligatoria (Feature 2).
class RrhhContractModificationDialog extends StatefulWidget {
  final RrhhEmployee employee;

  const RrhhContractModificationDialog({
    super.key,
    required this.employee,
  });

  static Future<RrhhContractModificationResult?> show(
    BuildContext context,
    RrhhEmployee employee,
  ) {
    return showDialog<RrhhContractModificationResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhContractModificationDialog(employee: employee),
    );
  }

  @override
  State<RrhhContractModificationDialog> createState() =>
      _RrhhContractModificationDialogState();
}

class _RrhhContractModificationDialogState
    extends State<RrhhContractModificationDialog> {
  int _currentStep = 1; // 1: Justificación, 2: Formulario
  bool _isLoadingCatalogs = true;
  bool _isSaving = false;

  // Catálogos organizacionales
  List<RrhhArea> _areas = [];
  List<RrhhPosition> _allPositions = [];
  List<RrhhShift> _shifts = [];
  List<RrhhEmployee> _supervisors = [];

  // ── PASO 1: Campos de Justificación ──
  String? _selectedReason;
  late final TextEditingController _otherReasonController;
  late final TextEditingController _justificationController;
  DateTime _effectiveDate = DateTime.now();
  String? _attachedDocumentName;

  final List<String> _reasonOptions = [
    'Ascenso',
    'Ajuste salarial',
    'Cambio de cargo',
    'Cambio de área',
    'Cambio de turno',
    'Corrección de error de carga',
    'Adenda de contrato',
    'Otro',
  ];

  // ── PASO 2: Campos Contractuales ──
  // Bloque A: Identificación
  late final TextEditingController _fullNameController;
  late final TextEditingController _ciController;
  DateTime? _birthDate;

  // Bloque B: Contrato
  String _contractType = 'Indefinido';
  String _workdayType = 'Completa';
  DateTime _contractStartDate = DateTime.now();
  DateTime? _contractEndDate;

  // Bloque C: Compensación
  late final TextEditingController _salaryController;
  String _currency = 'BOB';
  String _paymentModality = 'MENSUAL';

  // Bloque D: Asignación
  String? _selectedAreaId;
  String? _selectedPositionId;
  String? _selectedShiftId;
  late final TextEditingController _baseLocationController;
  String? _selectedSupervisorId;

  final List<String> _contractTypeOptions = [
    'Indefinido',
    'Temporal',
    'Por obra',
    'Consultor',
    'Pasantía',
  ];

  final List<String> _workdayOptions = [
    'Completa',
    'Parcial',
    'Por horas',
  ];

  final List<String> _paymentModalityOptions = [
    'MENSUAL',
    'QUINCENAL',
    'SEMANAL',
  ];

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;

    // Inicializar Paso 1
    _otherReasonController = TextEditingController();
    _justificationController = TextEditingController();
    _effectiveDate = DateTime.now();

    // Inicializar Paso 2 - Bloque A
    _fullNameController = TextEditingController(text: emp.fullName);
    _ciController = TextEditingController(text: emp.identityCard);
    _birthDate = emp.birthDate;

    // Bloque B
    _contractType = _normalizeContractType(emp.contractType);
    _workdayType = _normalizeWorkdayType(emp.workdayType);
    _contractStartDate = emp.contractStartDate ?? emp.realStartDate;
    _contractEndDate = emp.contractEndDate;

    // Bloque C
    _salaryController = TextEditingController(
      text: (emp.agreedSalary ?? 0.0).toStringAsFixed(2),
    );
    _currency = 'BOB';
    _paymentModality = emp.paymentModality.isNotEmpty
        ? emp.paymentModality
        : 'MENSUAL';

    // Bloque D
    _selectedAreaId = emp.areaId?.toString();
    _selectedPositionId = emp.positionId?.toString();
    _selectedShiftId = emp.shiftId?.toString();
    _baseLocationController = TextEditingController(
      text: emp.baseLocation ?? emp.workplace,
    );
    _selectedSupervisorId = emp.supervisorEmployeeId?.toString();

    _loadCatalogs();
  }

  @override
  void dispose() {
    _otherReasonController.dispose();
    _justificationController.dispose();
    _fullNameController.dispose();
    _ciController.dispose();
    _salaryController.dispose();
    _baseLocationController.dispose();
    super.dispose();
  }

  String _normalizeContractType(String? val) {
    if (val == null) return 'Indefinido';
    final lower = val.toLowerCase();
    if (lower.contains('indef')) return 'Indefinido';
    if (lower.contains('temp')) return 'Temporal';
    if (lower.contains('obra')) return 'Por obra';
    if (lower.contains('consul')) return 'Consultor';
    if (lower.contains('pasant')) return 'Pasantía';
    return 'Indefinido';
  }

  String _normalizeWorkdayType(String? val) {
    if (val == null) return 'Completa';
    final lower = val.toLowerCase();
    if (lower.contains('parcial')) return 'Parcial';
    if (lower.contains('hora')) return 'Por horas';
    return 'Completa';
  }

  Future<void> _loadCatalogs() async {
    try {
      final repo = RrhhRepository.current;
      final results = await Future.wait([
        repo.listAreas(),
        repo.listPositions(),
        repo.listShifts(),
        repo.listEmployees(limit: 100),
      ]);

      if (mounted) {
        setState(() {
          _areas = results[0] as List<RrhhArea>;
          _allPositions = results[1] as List<RrhhPosition>;
          _shifts = results[2] as List<RrhhShift>;
          _supervisors = (results[3] as List<RrhhEmployee>)
              .where((e) => e.id != widget.employee.id)
              .toList();

          // Si el área del empleado coincide por nombre si no tiene id
          if (_selectedAreaId == null && widget.employee.area.isNotEmpty) {
            final match = _areas.where(
              (a) => a.name.toLowerCase() == widget.employee.area.toLowerCase(),
            );
            if (match.isNotEmpty) {
              _selectedAreaId = match.first.id?.toString();
            }
          }

          // Si el cargo coincide por nombre
          if (_selectedPositionId == null &&
              widget.employee.position.isNotEmpty) {
            final match = _allPositions.where(
              (p) =>
                  p.name.toLowerCase() ==
                  widget.employee.position.toLowerCase(),
            );
            if (match.isNotEmpty) {
              _selectedPositionId = match.first.id?.toString();
            }
          }

          _isLoadingCatalogs = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingCatalogs = false);
    }
  }

  List<RrhhPosition> get _filteredPositions {
    if (_selectedAreaId == null) return _allPositions;
    final aId = int.tryParse(_selectedAreaId!);
    if (aId == null) return _allPositions;
    final list = _allPositions.where((p) => p.areaId == aId).toList();
    return list.isNotEmpty ? list : _allPositions;
  }

  bool get _isStep1Valid {
    if (_selectedReason == null) return false;
    if (_selectedReason == 'Otro' &&
        _otherReasonController.text.trim().isEmpty) {
      return false;
    }
    if (_justificationController.text.trim().length < 20) return false;

    final maxFutureDate = DateTime.now().add(const Duration(days: 30));
    if (_effectiveDate.isAfter(maxFutureDate)) return false;

    return true;
  }

  Future<void> _handleApply() async {
    setState(() => _isSaving = true);
    final repo = RrhhRepository.current;
    final emp = widget.employee;

    final newSalary =
        double.tryParse(_salaryController.text.trim()) ??
        emp.agreedSalary ??
        0.0;
    final newFullName = _fullNameController.text.trim();
    final newCi = _ciController.text.trim();
    final newBaseLocation = _baseLocationController.text.trim();

    // Obtener nombres de entidades seleccionadas
    final areaObj = _areas.firstWhere(
      (a) => a.id?.toString() == _selectedAreaId,
      orElse: () => RrhhArea(
        id: 0,
        code: '',
        name: emp.area,
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    final posObj = _allPositions.firstWhere(
      (p) => p.id?.toString() == _selectedPositionId,
      orElse: () => RrhhPosition(
        id: 0,
        areaId: 0,
        code: '',
        name: emp.position,
        workplaceType: 'OFICINA',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    final supervisorObj = _supervisors.firstWhere(
      (s) => s.id?.toString() == _selectedSupervisorId,
      orElse: () => emp,
    );

    // Comparar y construir reporte de diferencias
    final List<String> diffLines = [];
    bool hasSalaryChange = false;
    bool hasContractTypeChange = false;

    if (newSalary != emp.agreedSalary) {
      hasSalaryChange = true;
      diffLines.add(
        '• Salario base: ${(emp.agreedSalary ?? 0.0).toStringAsFixed(2)} → ${newSalary.toStringAsFixed(2)} $_currency',
      );
    }
    if (_contractType != _normalizeContractType(emp.contractType)) {
      hasContractTypeChange = true;
      diffLines.add(
        '• Tipo de contrato: ${emp.contractType} → $_contractType',
      );
    }
    if (_workdayType != _normalizeWorkdayType(emp.workdayType)) {
      diffLines.add(
        '• Jornada laboral: ${emp.workdayType ?? "N/A"} → $_workdayType',
      );
    }
    if (areaObj.name != emp.area && _selectedAreaId != null) {
      diffLines.add('• Área: ${emp.area} → ${areaObj.name}');
    }
    if (posObj.name != emp.position && _selectedPositionId != null) {
      diffLines.add('• Cargo: ${emp.position} → ${posObj.name}');
    }
    if (_selectedShiftId != null &&
        _selectedShiftId != emp.shiftId?.toString()) {
      diffLines.add('• Turno asignado actualizado (ID: $_selectedShiftId)');
    }
    if (newBaseLocation.isNotEmpty &&
        newBaseLocation != (emp.baseLocation ?? emp.workplace)) {
      diffLines.add(
        '• Sede base: ${emp.baseLocation ?? emp.workplace} → $newBaseLocation',
      );
    }
    if (_selectedSupervisorId != null &&
        _selectedSupervisorId != emp.supervisorEmployeeId?.toString()) {
      diffLines.add(
        '• Supervisor directo: ${emp.supervisor} → ${supervisorObj.fullName}',
      );
    }
    if (newFullName != emp.fullName) {
      diffLines.add('• Nombre: ${emp.fullName} → $newFullName');
    }
    if (newCi != emp.identityCard) {
      diffLines.add('• Cédula de Identidad: ${emp.identityCard} → $newCi');
    }

    try {
      final updated = emp.copyWith(
        fullName: newFullName.isNotEmpty ? newFullName : emp.fullName,
        identityCard: newCi.isNotEmpty ? newCi : emp.identityCard,
        birthDate: _birthDate ?? emp.birthDate,
        contractType: _contractType,
        workdayType: _workdayType,
        contractStartDate: _contractStartDate,
        contractEndDate: _contractEndDate,
        agreedSalary: newSalary,
        paymentModality: _paymentModality,
        area: areaObj.name,
        areaId: int.tryParse(_selectedAreaId ?? ''),
        position: posObj.name,
        positionId: int.tryParse(_selectedPositionId ?? ''),
        shiftId: _selectedShiftId,
        baseLocation: newBaseLocation.isNotEmpty
            ? newBaseLocation
            : emp.baseLocation,
        supervisor: _selectedSupervisorId != null
            ? supervisorObj.fullName
            : emp.supervisor,
        supervisorEmployeeId: _selectedSupervisorId,
        updatedAt: DateTime.now(),
      );

      await repo.updateEmployee(updated);

      // Registrar evento en bitácora de historial
      final effectiveReason = _selectedReason == 'Otro'
          ? _otherReasonController.text.trim()
          : (_selectedReason ?? 'Ajuste contractual');

      final userName = AuthService().currentDisplayName ?? 'Administrador';
      final formattedEffective =
          '${_effectiveDate.day.toString().padLeft(2, '0')}/${_effectiveDate.month.toString().padLeft(2, '0')}/${_effectiveDate.year}';

      final descBuffer = StringBuffer();
      descBuffer.writeln(
        'Cambio contractual — Motivo: $effectiveReason — $formattedEffective por $userName',
      );
      descBuffer.writeln(
        'Justificación: ${_justificationController.text.trim()}',
      );
      if (diffLines.isNotEmpty) {
        descBuffer.writeln('Modificaciones registradas:');
        for (final line in diffLines) {
          descBuffer.writeln(line);
        }
      }
      if (_attachedDocumentName != null) {
        descBuffer.writeln('Documento de respaldo: $_attachedDocumentName');
      }

      final now = DateTime.now();
      final timelineEvent = RrhhTimelineEvent(
        employeeId: emp.id ?? 1,
        date: DateTime(
          _effectiveDate.year,
          _effectiveDate.month,
          _effectiveDate.day,
          now.hour,
          now.minute,
          now.second,
        ),
        title: 'Cambio contractual — Motivo: $effectiveReason',
        description: descBuffer.toString().trim(),
        category: 'CONTRATUAL',
        registeredBy: userName,
        createdAt: now,
      );

      await repo.addTimelineEvent(timelineEvent);

      if (mounted) {
        Navigator.of(context).pop(
          RrhhContractModificationResult(
            success: true,
            isSensitive: hasSalaryChange || hasContractTypeChange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        RrhhSnackBar.showError(
          context,
          'Error al modificar datos contractuales: $e',
        );
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
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 800),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Expanded(
              child: _isLoadingCatalogs
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2563EB),
                        ),
                      ),
                    )
                  : (_currentStep == 1
                        ? _buildStep1Justification()
                        : _buildStep2Form()),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.history_edu_outlined,
              color: Color(0xFFF59E0B),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Modificar Datos Contractuales',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        _currentStep == 1 ? 'PASO 1 / 2' : 'PASO 2 / 2',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF93C5FD),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Este cambio quedará registrado en el historial del empleado con trazabilidad completa.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // PASO 1 — Vista de Justificación y Motivo
  // ────────────────────────────────────────────────────────────────
  Widget _buildStep1Justification() {
    final maxFutureDate = DateTime.now().add(const Duration(days: 30));
    final isDateValid = !_effectiveDate.isAfter(maxFutureDate);
    final justificationLen = _justificationController.text.trim().length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner ámbar de advertencia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF78350F).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFF59E0B),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '⚠️ Estás por modificar datos contractuales del empleado. Todos los cambios quedarán registrados con fecha, usuario, motivo y valores anterior/nuevo.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: const Color(0xFFFEF3C7),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 1. Motivo del cambio
          Text(
            '1. Motivo del cambio *',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedReason,
            isExpanded: true,
            hint: Text(
              'Seleccionar motivo del cambio',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
            items: _reasonOptions
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(r, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedReason = val),
            dropdownColor: const Color(0xFF1E293B),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            decoration: _inputDecoration(),
          ),

          if (_selectedReason == 'Otro') ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _otherReasonController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              decoration: _inputDecoration(
                hint: 'Especificar el motivo en detalle *',
              ),
            ),
          ],
          const SizedBox(height: 20),

          // 2. Justificación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2. Justificación del cambio *',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              Text(
                '$justificationLen / 20 caracteres mín.',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: justificationLen >= 20
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _justificationController,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            decoration: _inputDecoration(
              hint:
                  'Explica brevemente por qué se realiza este cambio (mínimo 20 caracteres)...',
            ),
          ),
          const SizedBox(height: 20),

          // 3. Fecha efectiva
          Text(
            '3. Fecha efectiva del cambio *',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _effectiveDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Color(0xFF2563EB),
                        surface: Color(0xFF1E293B),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _effectiveDate = picked);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDateValid
                      ? const Color(0xFF334155)
                      : const Color(0xFFEF4444),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_effectiveDate.day.toString().padLeft(2, '0')}/${_effectiveDate.month.toString().padLeft(2, '0')}/${_effectiveDate.year}',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    'Cambiar fecha',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF38BDF8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isDateValid) ...[
            const SizedBox(height: 4),
            Text(
              'La fecha no puede ser mayor a 30 días en el futuro',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
          const SizedBox(height: 20),

          // 4. Documento de respaldo
          Text(
            '4. Documento de respaldo (opcional)',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Adjuntar memo de aprobación, adenda contractual firmada o solicitud formal (máx 5 MB - PDF, JPG, PNG).',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          if (_attachedDocumentName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    size: 16,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _attachedDocumentName!,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        setState(() => _attachedDocumentName = null),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFFEF4444),
                    ),
                    tooltip: 'Quitar documento',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                // Simulación de carga de documento para mock
                setState(() {
                  _attachedDocumentName =
                      'adenda_${widget.employee.code.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch % 1000}.pdf';
                });
              },
              icon: const Icon(Icons.upload_file_outlined, size: 16),
              label: Text(
                'Adjuntar archivo de respaldo',
                style: GoogleFonts.inter(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // PASO 2 — Formulario de Modificación de Campos Contractuales
  // ────────────────────────────────────────────────────────────────
  Widget _buildStep2Form() {
    final effectiveReason = _selectedReason == 'Otro'
        ? _otherReasonController.text.trim()
        : (_selectedReason ?? '');
    final formattedDate =
        '${_effectiveDate.day.toString().padLeft(2, '0')}/${_effectiveDate.month.toString().padLeft(2, '0')}/${_effectiveDate.year}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de contexto (solo lectura arriba)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Color(0xFF38BDF8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Motivo: $effectiveReason',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fecha efectiva: $formattedDate • Justificación: ${_justificationController.text.trim()}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  child: Text(
                    'Modificar justificación',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // BLOQUE A: Identificación
          _buildFormCard(
            title: 'BLOQUE A — IDENTIFICACIÓN (DATOS CRÍTICOS)',
            icon: Icons.badge_outlined,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildFormField(
                      label: 'Nombre completo *',
                      controller: _fullNameController,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 4,
                    child: _buildFormField(
                      label: 'Cédula de Identidad *',
                      controller: _ciController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildDatePickerRow(
                label: 'Fecha de nacimiento',
                currentDate: _birthDate,
                onSelected: (dt) => setState(() => _birthDate = dt),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // BLOQUE B: Contrato
          _buildFormCard(
            title: 'BLOQUE B — CONDICIONES CONTRACTUALES',
            icon: Icons.description_outlined,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildDropdown(
                      label: 'Tipo de contrato *',
                      value: _contractType,
                      items: _contractTypeOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _contractType = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 5,
                    child: _buildDropdown(
                      label: 'Jornada laboral *',
                      value: _workdayType,
                      items: _workdayOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _workdayType = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerRow(
                      label: 'Fecha inicio contrato *',
                      currentDate: _contractStartDate,
                      onSelected: (dt) =>
                          setState(() => _contractStartDate = dt),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _contractType != 'Indefinido'
                        ? _buildDatePickerRow(
                            label: 'Fecha fin contrato *',
                            currentDate: _contractEndDate,
                            onSelected: (dt) =>
                                setState(() => _contractEndDate = dt),
                          )
                        : Text(
                            'Contrato por tiempo indefinido (sin fecha de fin programada).',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // BLOQUE C: Compensación
          _buildFormCard(
            title: 'BLOQUE C — COMPENSACIÓN Y SALARIO',
            icon: Icons.payments_outlined,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildFormField(
                      label: 'Salario base pactado *',
                      controller: _salaryController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixText: 'Bs. ',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 3,
                    child: _buildDropdown(
                      label: 'Moneda',
                      value: _currency,
                      items: const [
                        DropdownMenuItem(
                          value: 'BOB',
                          child: Text('BOB (Bs.)'),
                        ),
                        DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _currency = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 4,
                    child: _buildDropdown(
                      label: 'Modalidad de pago',
                      value: _paymentModality,
                      items: _paymentModalityOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _paymentModality = val);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // BLOQUE D: Asignación
          _buildFormCard(
            title: 'BLOQUE D — ASIGNACIÓN ORGANIZACIONAL Y TURNO',
            icon: Icons.corporate_fare_outlined,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildDropdown(
                      label: 'Área de la empresa *',
                      value: _selectedAreaId,
                      items: _areas
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.id?.toString(),
                              child: Text(a.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedAreaId = val;
                          _selectedPositionId = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 5,
                    child: _buildDropdown(
                      label: 'Cargo / Posición *',
                      value: _selectedPositionId,
                      items: _filteredPositions
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id?.toString(),
                              child: Text(p.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedPositionId = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildDropdown(
                      label: 'Turno de trabajo *',
                      value: _selectedShiftId,
                      items: _shifts
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.id.toString(),
                              child: Text(
                                '${s.name} (${s.startTime} - ${s.endTime})',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedShiftId = val),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 5,
                    child: _buildFormField(
                      label: 'Sede / Ubicación base *',
                      controller: _baseLocationController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: 'Supervisor directo asignado',
                value: _selectedSupervisorId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('(Sin supervisor asignado)'),
                  ),
                  ..._supervisors.map(
                    (s) => DropdownMenuItem(
                      value: s.id?.toString(),
                      child: Text('${s.fullName} (${s.position})'),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedSupervisorId = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF38BDF8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: _inputDecoration(prefixText: prefixText),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF1E293B),
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _buildDatePickerRow({
    required String label,
    required DateTime? currentDate,
    required ValueChanged<DateTime> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: currentDate ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2050),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF2563EB),
                      surface: Color(0xFF1E293B),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) onSelected(picked);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF38BDF8),
                ),
                const SizedBox(width: 10),
                Text(
                  currentDate != null
                      ? '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}'
                      : 'Seleccionar fecha',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, String? prefixText}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      prefixStyle: GoogleFonts.inter(
        fontSize: 13,
        color: const Color(0xFF38BDF8),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 12.5,
        color: const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentStep == 1) ...[
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isStep1Valid
                  ? () => setState(() => _currentStep = 2)
                  : null,
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: Text(
                'Continuar al Paso 2',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF1E293B),
                disabledForegroundColor: const Color(0xFF475569),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ] else ...[
            OutlinedButton.icon(
              onPressed: _isSaving
                  ? null
                  : () => setState(() => _currentStep = 1),
              icon: const Icon(Icons.arrow_back, size: 15),
              label: Text(
                'Atrás',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _handleApply,
              icon: _isSaving
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline, size: 16),
              label: Text(
                _isSaving ? 'Aplicando...' : 'Aplicar cambios',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
