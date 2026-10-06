import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';

/// Modal de registro y edición de Permisos y Licencias Laborales.
class RrhhLeaveRequestEditDialog extends StatefulWidget {
  final RrhhLeaveRequest? initialRequest;

  const RrhhLeaveRequestEditDialog({super.key, this.initialRequest});

  static Future<bool?> show(
    BuildContext context, {
    RrhhLeaveRequest? leave,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhLeaveRequestEditDialog(initialRequest: leave),
    );
  }

  @override
  State<RrhhLeaveRequestEditDialog> createState() =>
      _RrhhLeaveRequestEditDialogState();
}

class _RrhhLeaveRequestEditDialogState
    extends State<RrhhLeaveRequestEditDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingEmployees = true;
  List<RrhhEmployeeSummaryDto> _employees = [];
  RrhhEmployeeSummaryDto? _selectedEmployee;

  String _selectedLeaveType = RrhhLeaveTypes.enfermedad;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isPaid = true;

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _evidenceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSaving = false;

  bool get isEditing => widget.initialRequest != null;

  @override
  void initState() {
    super.initState();
    final req = widget.initialRequest;

    if (req != null) {
      _selectedLeaveType = req.leaveType;
      _startDate = req.startDate;
      _endDate = req.endDate;
      _isPaid = req.isPaid;
      _reasonController.text = req.reason;
      _evidenceController.text = req.evidenceFile ?? '';
      _notesController.text = req.notes ?? '';
    } else {
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      _applyTypeRules(_selectedLeaveType);
    }

    _loadEmployees();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _evidenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyTypeRules(String type) {
    if (RrhhLeaveTypes.isMandatoryPaid(type)) {
      _isPaid = true;
    } else if (RrhhLeaveTypes.isMandatoryUnpaid(type)) {
      _isPaid = false;
    } else {
      _isPaid = RrhhLeaveTypes.defaultIsPaid(type);
    }
  }

  Future<void> _loadEmployees() async {
    try {
      final list = await RrhhRepository.current.listEmployees(status: 'ACTIVO');
      if (mounted) {
        setState(() {
          _employees = list;
          _isLoadingEmployees = false;
          if (widget.initialRequest != null) {
            final empId = widget.initialRequest!.employeeId;
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

  int get _calculatedDuration {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day);
    final diff = end.difference(start).inDays;
    return diff >= 0 ? diff + 1 : 0;
  }

  Future<void> _handleSave({required bool approveImmediately}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmployee == null) {
      RrhhSnackBar.showWarning(context, 'Debe seleccionar un colaborador.');
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      RrhhSnackBar.showError(
        context,
        'La fecha de fin no puede ser anterior a la fecha de inicio.',
      );
      return;
    }

    if (_calculatedDuration <= 0) {
      RrhhSnackBar.showError(context, 'La duración debe ser mayor a 0 días.');
      return;
    }

    // Validación de motivo mínimo 20 caracteres
    final reasonText = _reasonController.text.trim();
    if (reasonText.length < 20) {
      RrhhSnackBar.showWarning(
        context,
        'El motivo debe contener al menos 20 caracteres descriptivos.',
      );
      return;
    }

    // Validación de certificado para enfermedad o accidente
    if (RrhhLeaveTypes.requiresEvidence(_selectedLeaveType) &&
        _evidenceController.text.trim().isEmpty) {
      RrhhSnackBar.showError(
        context,
        'Para licencias de Enfermedad o Accidente es obligatorio adjuntar el certificado médico.',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = RrhhRepository.current;

      // Validación preventiva contra solapamiento con permisos aprobados del mismo empleado
      final allLeaves = await repo.listLeaveRequests(
        status: RrhhLeaveStatus.aprobado,
      );
      final overlapping = allLeaves.where((l) {
        if (l.employeeId != _selectedEmployee!.id) return false;
        if (isEditing && l.id == widget.initialRequest!.id) return false;
        // Solapamiento: [startDate, endDate] se intersecta con [l.startDate, l.endDate]
        return !(l.endDate.isBefore(_startDate) ||
            l.startDate.isAfter(_endDate));
      });

      if (overlapping.isNotEmpty) {
        final conflict = overlapping.first;
        if (mounted) {
          setState(() => _isSaving = false);
          RrhhSnackBar.showError(
            context,
            'El colaborador ya cuenta con el permiso ${conflict.code} aprobado que se solapa con este período.',
          );
        }
        return;
      }

      final now = DateTime.now();
      final status = approveImmediately
          ? RrhhLeaveStatus.aprobado
          : (isEditing
                ? widget.initialRequest!.status
                : RrhhLeaveStatus.pendiente);

      final leaveObj = RrhhLeaveRequest(
        id: isEditing ? widget.initialRequest!.id : 0,
        code: isEditing ? widget.initialRequest!.code : '',
        employeeId: _selectedEmployee!.id,
        employeeCode: _selectedEmployee!.code,
        employeeName: _selectedEmployee!.fullName,
        leaveType: _selectedLeaveType,
        startDate: _startDate,
        endDate: _endDate,
        durationDays: _calculatedDuration,
        isPaid: _isPaid,
        reason: reasonText,
        evidenceFile: _evidenceController.text.trim().isNotEmpty
            ? _evidenceController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        status: status,
        createdAt: isEditing ? widget.initialRequest!.createdAt : now,
        updatedAt: now,
        createdBy: isEditing
            ? widget.initialRequest!.createdBy
            : 'Lic. Laura Mendoza',
        approvedAt: approveImmediately
            ? now
            : widget.initialRequest?.approvedAt,
        approvedBy: approveImmediately
            ? 'Lic. Laura Mendoza'
            : widget.initialRequest?.approvedBy,
        rejectionReason: widget.initialRequest?.rejectionReason,
      );

      if (isEditing) {
        await repo.updateLeaveRequest(leaveObj);
      } else {
        await repo.createLeaveRequest(leaveObj);
      }

      if (mounted) {
        RrhhSnackBar.showSuccess(
          context,
          approveImmediately
              ? 'Permiso registrado y aprobado exitosamente.'
              : (isEditing
                    ? 'Permiso actualizado correctamente.'
                    : 'Permiso guardado como Pendiente.'),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        RrhhSnackBar.showError(context, 'Error al guardar permiso: $e');
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
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 780),
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
                            _buildEmployeeSelector(),
                            const SizedBox(height: 18),
                            _buildLeaveTypeAndPaidRow(),
                            const SizedBox(height: 18),
                            _buildDatesAndDurationRow(),
                            const SizedBox(height: 18),
                            _buildReasonField(),
                            const SizedBox(height: 18),
                            _buildEvidenceField(),
                            const SizedBox(height: 18),
                            _buildNotesField(),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.fact_check_outlined,
              color: Color(0xFF38BDF8),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Editar Solicitud de Permiso'
                      : 'Registrar Permiso o Licencia',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Registro administrativo de ausencia justificada para control de asistencia y nómina.',
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
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('COLABORADOR *'),
        const SizedBox(height: 6),
        DropdownButtonFormField<RrhhEmployeeSummaryDto>(
          initialValue: _selectedEmployee,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E293B),
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
          decoration: _inputDecoration(
            hint: 'Seleccionar colaborador activo...',
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
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.badge_outlined,
                  size: 16,
                  color: Color(0xFF38BDF8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_selectedEmployee!.code} • ${_selectedEmployee!.position} • ${_selectedEmployee!.area} • ${_selectedEmployee!.workplace}',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLeaveTypeAndPaidRow() {
    final isMandatoryPaid = RrhhLeaveTypes.isMandatoryPaid(_selectedLeaveType);
    final isMandatoryUnpaid = RrhhLeaveTypes.isMandatoryUnpaid(
      _selectedLeaveType,
    );
    final canToggle = RrhhLeaveTypes.canTogglePaid(_selectedLeaveType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown de tipo de permiso
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('TIPO DE PERMISO / LICENCIA *'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLeaveType,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E293B),
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF94A3B8),
                    ),
                    decoration: _inputDecoration(),
                    items: RrhhLeaveTypes.all.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(
                          RrhhLeaveTypes.getLabel(t),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLeaveType = val;
                          _applyTypeRules(val);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // ¿Pagado / Con goce?
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('CONDICIÓN DE REMUNERACIÓN'),
                  const SizedBox(height: 6),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isPaid
                              ? 'Con goce de haberes'
                              : 'Sin goce de haberes',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: _isPaid
                                ? const Color(0xFF10B981)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                        if (canToggle)
                          Switch(
                            value: _isPaid,
                            onChanged: (val) => setState(() => _isPaid = val),
                            activeThumbColor: const Color(0xFF10B981),
                          )
                        else
                          Tooltip(
                            message: isMandatoryPaid
                                ? 'Este permiso es obligatoriamente pagado por ley.'
                                : 'Este permiso no contempla goce de haberes.',
                            child: const Icon(
                              Icons.lock_outline,
                              size: 16,
                              color: Color(0xFF64748B),
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
        if (isMandatoryPaid) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 14,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Text(
                'Este tipo de permiso es pagado por ley y no afectará el salario del colaborador.',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ] else if (isMandatoryUnpaid) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 14,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 6),
              Text(
                'Permiso sin goce de haberes: se reportará a nómina para deducción proporcional.',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDatesAndDurationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fecha desde
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('FECHA DESDE *'),
              const SizedBox(height: 6),
              _buildDatePickerButton(
                date: _startDate,
                onSelect: (dt) {
                  setState(() {
                    _startDate = dt;
                    if (_endDate.isBefore(_startDate)) {
                      _endDate = _startDate;
                    }
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Fecha hasta
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('FECHA HASTA *'),
              const SizedBox(height: 6),
              _buildDatePickerButton(
                date: _endDate,
                firstDate: _startDate,
                onSelect: (dt) {
                  setState(() => _endDate = dt);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Duración calculada
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('DURACIÓN CALCULADA'),
              const SizedBox(height: 6),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  '$_calculatedDuration ${_calculatedDuration == 1 ? 'día' : 'días'} calendario',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerButton({
    required DateTime date,
    required ValueChanged<DateTime> onSelect,
    DateTime? firstDate,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: firstDate ?? DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF2563EB),
                  onPrimary: Colors.white,
                  surface: Color(0xFF0F172A),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onSelect(picked);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155)),
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
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _fieldLabel('MOTIVO / JUSTIFICACIÓN (OBLIGATORIO) *'),
            Text(
              'Mínimo 20 caracteres',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _reasonController,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: _inputDecoration(
            hint:
                'Detallar el motivo formal de la ausencia, solicitud o licencia médica...',
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'El motivo es obligatorio';
            }
            if (val.trim().length < 20) {
              return 'El motivo debe contener al menos 20 caracteres (actual: ${val.trim().length})';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEvidenceField() {
    final requiresEvidence = RrhhLeaveTypes.requiresEvidence(
      _selectedLeaveType,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _fieldLabel(
              requiresEvidence
                  ? 'CERTIFICADO MÉDICO O RESPALDO (OBLIGATORIO) *'
                  : 'DOCUMENTO DE RESPALDO / EVIDENCIA (OPCIONAL)',
            ),
            if (requiresEvidence)
              Text(
                'Requerido por tipo de licencia',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: const Color(0xFFF59E0B),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _evidenceController,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: _inputDecoration(
                  hint: requiresEvidence
                      ? 'Ej: certificado_baja_cns_99412.pdf'
                      : 'Ej: carta_solicitud_notariada.pdf',
                ),
                validator: (val) {
                  if (requiresEvidence && (val == null || val.trim().isEmpty)) {
                    return 'El certificado médico es obligatorio para este tipo de licencia';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                final defaultName = requiresEvidence
                    ? 'certificado_cns_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.pdf'
                    : 'adjunto_permiso_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.pdf';
                setState(() => _evidenceController.text = defaultName);
                RrhhSnackBar.showInfo(
                  context,
                  'Archivo adjuntado: $defaultName',
                );
              },
              icon: const Icon(Icons.attach_file, size: 16),
              label: const Text('Adjuntar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: const Color(0xFF38BDF8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF334155)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _fieldLabel('OBSERVACIONES INTERNAS (SOLO RRHH)'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'CONFIDENCIAL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: _inputDecoration(
            hint:
                'Anotaciones administrativas, seguimiento interno de RRHH o cobertura...',
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
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
          OutlinedButton(
            onPressed: _isSaving
                ? null
                : () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF334155)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
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
          OutlinedButton.icon(
            onPressed: _isSaving
                ? null
                : () => _handleSave(approveImmediately: false),
            icon: const Icon(Icons.pending_actions_outlined, size: 16),
            label: Text(
              isEditing ? 'Guardar Cambios' : 'Guardar como Pendiente',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF59E0B),
              side: const BorderSide(color: Color(0xFFF59E0B)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _isSaving
                ? null
                : () => _handleSave(approveImmediately: true),
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
              _isSaving ? 'Guardando...' : 'Guardar y Aprobar',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
