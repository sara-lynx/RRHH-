import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest, RrhhVacation;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../extensions/rrhh_model_extensions.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';

/// Modal para registrar o editar una desvinculación laboral (Pantalla 11 — Bloque 3).
class RrhhTerminationEditDialog extends StatefulWidget {
  final RrhhTerminationRecord? initialRecord;
  final int? initialEmployeeId;

  const RrhhTerminationEditDialog({
    super.key,
    this.initialRecord,
    this.initialEmployeeId,
  });

  static Future<bool?> show(
    BuildContext context, {
    RrhhTerminationRecord? record,
    int? employeeId,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhTerminationEditDialog(
        initialRecord: record,
        initialEmployeeId: employeeId,
      ),
    );
  }

  @override
  State<RrhhTerminationEditDialog> createState() =>
      _RrhhTerminationEditDialogState();
}

class _RrhhTerminationEditDialogState extends State<RrhhTerminationEditDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingEmployees = true;
  List<RrhhEmployeeSummaryDto> _employees = [];
  RrhhEmployeeSummaryDto? _selectedEmployee;
  RrhhEmployee? _employeeDetail;

  // Bloque B: Tipo y causal
  String _terminationType = RrhhTerminationTypes.renunciaVoluntaria;
  String? _justifiedCause = RrhhJustifiedCauses.perjuicioMaterial;
  final TextEditingController _reasonController = TextEditingController();

  // Bloque C: Fechas
  late DateTime _lastWorkDay;
  late DateTime _terminationDate;
  late DateTime _paymentDeadline;

  // Bloque D: Documentos y obligaciones
  final TextEditingController _resignationFileController =
      TextEditingController();
  final TextEditingController _memoFileController = TextEditingController();
  bool _deliveryWorkCertificate = true;
  bool _hasPendingObligations = false;
  final TextEditingController _obligationsDetailController =
      TextEditingController();
  bool _notifiedEmployee = true;

  bool _isSaving = false;

  bool get isEditing => widget.initialRecord != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialRecord;
    final now = DateTime.now();

    if (item != null) {
      _terminationType = item.terminationType;
      _justifiedCause =
          item.justifiedCause ?? RrhhJustifiedCauses.perjuicioMaterial;
      _reasonController.text = item.reason;
      _lastWorkDay = item.lastWorkDay;
      _terminationDate = item.terminationDate;
      _paymentDeadline =
          item.paymentDeadline ??
          item.lastWorkDay.add(const Duration(days: 15));
      _resignationFileController.text = item.resignationLetterFile ?? '';
      _memoFileController.text = item.terminationMemoFile ?? '';
      _deliveryWorkCertificate = item.workCertificateFile != null;
      _hasPendingObligations = item.hasPendingObligations;
      _obligationsDetailController.text = item.pendingObligationsDetail ?? '';
      _notifiedEmployee = item.notifiedEmployee;
    } else {
      _lastWorkDay = now;
      _terminationDate = now;
      _paymentDeadline = now.add(const Duration(days: 15));
      _resignationFileController.text = 'carta_renuncia_firmada.pdf';
      _memoFileController.text = 'memorandum_despido_notificado.pdf';
    }

    _loadEmployees();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _resignationFileController.dispose();
    _memoFileController.dispose();
    _obligationsDetailController.dispose();
    super.dispose();
  }

  void _onLastWorkDayChanged(DateTime picked) {
    setState(() {
      _lastWorkDay = picked;
      if (_terminationDate.isBefore(_lastWorkDay)) {
        _terminationDate = _lastWorkDay;
      }
      _paymentDeadline = _lastWorkDay.add(const Duration(days: 15));
    });
  }

  Future<void> _loadEmployees() async {
    try {
      final list = await RrhhRepository.current.listEmployees(status: 'ACTIVO');
      if (mounted) {
        setState(() {
          _employees = list;
          _isLoadingEmployees = false;
          final targetEmpId =
              widget.initialRecord?.employeeId ?? widget.initialEmployeeId;
          if (targetEmpId != null) {
            _selectedEmployee = list.cast<RrhhEmployeeSummaryDto?>().firstWhere(
              (e) => e?.id == targetEmpId,
              orElse: () => null,
            );
            if (_selectedEmployee != null) {
              _loadEmployeeDetail(_selectedEmployee!.id);
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingEmployees = false);
        RrhhSnackBar.showError(context, 'Error al cargar empleados: $e');
      }
    }
  }

  Future<void> _loadEmployeeDetail(int empId) async {
    try {
      final detail = await RrhhRepository.current.getEmployeeById(empId);
      if (mounted) {
        setState(() => _employeeDetail = detail);
      }
    } catch (_) {}
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEmployee == null && widget.initialRecord == null) {
      RrhhSnackBar.showWarning(
        context,
        'Debe seleccionar al empleado a desvincular.',
      );
      return;
    }

    // Validación carta de renuncia si es renuncia voluntaria
    if (_terminationType == RrhhTerminationTypes.renunciaVoluntaria &&
        _resignationFileController.text.trim().isEmpty) {
      RrhhSnackBar.showWarning(
        context,
        'Debe adjuntar la carta de renuncia para este tipo de baja.',
      );
      return;
    }

    // Validación memorándum si es despido
    if ((_terminationType == RrhhTerminationTypes.despidoJustificado ||
            _terminationType == RrhhTerminationTypes.despidoInjustificado) &&
        _memoFileController.text.trim().isEmpty) {
      RrhhSnackBar.showWarning(
        context,
        'Debe adjuntar el memorándum de despido notificado.',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = RrhhRepository.current;
      final empId = _selectedEmployee?.id ?? widget.initialRecord!.employeeId;
      final empCode =
          _selectedEmployee?.code ?? widget.initialRecord!.employeeCode;
      final empName =
          _selectedEmployee?.fullName ?? widget.initialRecord!.employeeName;

      final recordToSave = RrhhTerminationRecord(
        id: widget.initialRecord?.id ?? 0,
        code: widget.initialRecord?.code ?? '',
        employeeId: empId,
        employeeCode: empCode,
        employeeName: empName,
        terminationType: _terminationType,
        justifiedCause:
            _terminationType == RrhhTerminationTypes.despidoJustificado
            ? _justifiedCause
            : null,
        terminationDate: _terminationDate,
        lastWorkDay: _lastWorkDay,
        reason: _reasonController.text.trim(),
        resignationLetterFile:
            _terminationType == RrhhTerminationTypes.renunciaVoluntaria
            ? _resignationFileController.text.trim()
            : null,
        terminationMemoFile:
            (_terminationType == RrhhTerminationTypes.despidoJustificado ||
                _terminationType == RrhhTerminationTypes.despidoInjustificado)
            ? _memoFileController.text.trim()
            : null,
        workCertificateFile: _deliveryWorkCertificate
            ? 'certificado_trabajo_${empCode.toLowerCase()}.pdf'
            : null,
        hasPendingObligations: _hasPendingObligations,
        pendingObligationsDetail: _hasPendingObligations
            ? _obligationsDetailController.text.trim()
            : null,
        paymentDeadline: _paymentDeadline,
        paymentCompleted: widget.initialRecord?.paymentCompleted ?? false,
        paymentCompletedAt: widget.initialRecord?.paymentCompletedAt,
        notifiedEmployee: _notifiedEmployee,
        notifiedAt: _notifiedEmployee ? DateTime.now() : null,
        status:
            widget.initialRecord?.status ?? RrhhTerminationStatus.registrada,
        createdAt: widget.initialRecord?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: widget.initialRecord?.createdBy ?? 'RRHH',
      );

      if (isEditing) {
        await repo.updateTerminationRecord(recordToSave);
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Expediente ${recordToSave.code} actualizado correctamente.',
          );
          Navigator.of(context).pop(true);
        }
      } else {
        final created = await repo.createTerminationRecord(recordToSave);
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Desvinculación registrada con código ${created.code}.',
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        RrhhSnackBar.showError(context, 'Error al guardar desvinculación: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 860),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Body con Scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Banner de Advertencia Legal
                      _buildLegalWarningBanner(),
                      const SizedBox(height: 20),

                      // BLOQUE A: Datos del Empleado
                      _buildBlockA(),
                      const SizedBox(height: 20),

                      // BLOQUE B: Tipo y Causal
                      _buildBlockB(),
                      const SizedBox(height: 20),

                      // BLOQUE C: Fechas y Plazo Legal (15 días)
                      _buildBlockC(),
                      const SizedBox(height: 20),

                      // BLOQUE D: Documentos y Obligaciones
                      _buildBlockD(),
                    ],
                  ),
                ),
              ),

              // Footer con Acciones
              _buildFooter(),
            ],
          ),
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
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_remove_outlined,
              color: Color(0xFFEF4444),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Editar Desvinculación'
                      : 'Registrar Desvinculación',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Gestión de bajas, causales Art. 16 LGT y plazo perentorio de liquidación',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advertencia Legal de Baja Laboral',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFDE68A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Esta acción iniciará el proceso de baja del empleado. Al finalizar el proceso, el colaborador pasará a estado BAJA, desaparecerá de las asignaciones operativas activas y se expondrán los datos a Contabilidad para el cálculo de liquidación dentro del plazo de 15 días calendario.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFCBD5E1),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockA() {
    return _buildCardWrapper(
      title: 'BLOQUE A — DATOS DEL EMPLEADO',
      icon: Icons.person_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEditing)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    color: Color(0xFF38BDF8),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.initialRecord!.employeeName} (${widget.initialRecord!.employeeCode})',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Text('Seleccione el colaborador activo *', style: _labelStyle),
            const SizedBox(height: 6),
            if (_isLoadingEmployees)
              const LinearProgressIndicator(minHeight: 2)
            else
              DropdownButtonFormField<RrhhEmployeeSummaryDto>(
                initialValue: _selectedEmployee,
                isExpanded: true,
                dropdownColor: const Color(0xFF0F172A),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: _inputDecoration(hint: 'Buscar empleado activo...'),
                items: _employees.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      '${e.fullName} (${e.code}) — ${e.position}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedEmployee = val;
                  });
                  if (val != null) {
                    _loadEmployeeDetail(val.id);
                  }
                },
                validator: (val) =>
                    val == null ? 'Seleccione un empleado' : null,
              ),
          ],

          // Tarjeta de información snapshot si está seleccionado
          if (_selectedEmployee != null || _employeeDetail != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Cargo & Área',
                      '${_employeeDetail?.position ?? _selectedEmployee?.position ?? "Operario"} / ${_employeeDetail?.area ?? _selectedEmployee?.area ?? "Operaciones"}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Fecha Ingreso',
                      _employeeDetail != null
                          ? _fmtDate(_employeeDetail!.realStartDate)
                          : (_selectedEmployee != null
                                ? _fmtDate(_selectedEmployee!.realStartDate)
                                : '—'),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Salario Base',
                      _employeeDetail != null
                          ? 'Bs. ${(_employeeDetail!.agreedSalary ?? 0.0).toStringAsFixed(2)}'
                          : '—',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBlockB() {
    final isDismissalJustified =
        _terminationType == RrhhTerminationTypes.despidoJustificado;

    return _buildCardWrapper(
      title: 'BLOQUE B — TIPO Y CAUSAL DE DESVINCULACIÓN',
      icon: Icons.gavel_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tipo de Desvinculación *', style: _labelStyle),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _terminationType,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF0F172A),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: _inputDecoration(),
                      items: RrhhTerminationTypes.all.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(RrhhTerminationTypes.label(t)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _terminationType = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (isDismissalJustified) ...[
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Causal Art. 16 LGT (Bolivia) *',
                        style: _labelStyle,
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _justifiedCause,
                        dropdownColor: const Color(0xFF0F172A),
                        isExpanded: true,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12.5,
                        ),
                        decoration: _inputDecoration(),
                        items: RrhhJustifiedCauses.all.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null)
                            setState(() => _justifiedCause = val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),

          // Motivo / Descripción (mínimo 30 caracteres)
          Text(
            'Motivo / Justificación detallada * (mínimo 30 caracteres)',
            style: _labelStyle,
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _reasonController,
            maxLines: 3,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
            decoration: _inputDecoration(
              hint:
                  'Detalle claramente las causas, antecedentes o documentación que sustentan la desvinculación...',
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty)
                return 'El motivo es obligatorio';
              if (val.trim().length < 30) {
                return 'El motivo debe tener al menos 30 caracteres (${val.trim().length}/30)';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBlockC() {
    return _buildCardWrapper(
      title: 'BLOQUE C — FECHAS Y PLAZO LEGAL DE PAGO (15 DÍAS)',
      icon: Icons.calendar_month_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Último día trabajado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Último día trabajado *', style: _labelStyle),
                    const SizedBox(height: 6),
                    _buildDatePickerButton(
                      date: _lastWorkDay,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _lastWorkDay,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) _onLastWorkDayChanged(picked);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Fecha efectiva de baja
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha efectiva de baja *', style: _labelStyle),
                    const SizedBox(height: 6),
                    _buildDatePickerButton(
                      date: _terminationDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _terminationDate,
                          firstDate: _lastWorkDay,
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() => _terminationDate = picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Fecha límite de pago (Calculada automáticamente lastWorkDay + 15 días)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha límite de pago (Finiquito)',
                      style: _labelStyle,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_clock_outlined,
                            size: 16,
                            color: Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _fmtDate(_paymentDeadline),
                            style: GoogleFonts.jetBrainsMono(
                              color: const Color(0xFFFDE68A),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Plazo legal de 15 días calendario computables desde el último día trabajado para el pago total del finiquito sin multas (D.S. 28699 Art. 9).',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockD() {
    final isResignation =
        _terminationType == RrhhTerminationTypes.renunciaVoluntaria;
    final isDismissal =
        _terminationType == RrhhTerminationTypes.despidoJustificado ||
        _terminationType == RrhhTerminationTypes.despidoInjustificado;

    return _buildCardWrapper(
      title: 'BLOQUE D — DOCUMENTOS Y OBLIGACIONES PENDIENTES',
      icon: Icons.folder_open_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isResignation) ...[
            Text('Carta de Renuncia Voluntaria *', style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _resignationFileController,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              decoration: _inputDecoration(
                hint: 'ej. carta_renuncia_firmada.pdf',
                prefixIcon: const Icon(
                  Icons.attach_file,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ),
              validator: (val) {
                if (isResignation && (val == null || val.trim().isEmpty)) {
                  return 'Debe adjuntar la carta de renuncia';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
          ],

          if (isDismissal) ...[
            Text(
              'Memorándum de Despido / Comunicación Oficial *',
              style: _labelStyle,
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _memoFileController,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              decoration: _inputDecoration(
                hint: 'ej. memo_despido_notificado.pdf',
                prefixIcon: const Icon(
                  Icons.attach_file,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ),
              validator: (val) {
                if (isDismissal && (val == null || val.trim().isEmpty)) {
                  return 'Debe adjuntar el memorándum de despido';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
          ],

          // Checkboxes
          Material(
            type: MaterialType.transparency,
            child: CheckboxListTile(
              value: _deliveryWorkCertificate,
              onChanged: (val) =>
                  setState(() => _deliveryWorkCertificate = val ?? true),
              title: Text(
                'Emitir y entregar Certificado de Trabajo',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              ),
              subtitle: Text(
                'Obligatorio según LGT Art. 15 a la cesación del vínculo laboral',
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11.5,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF2563EB),
            ),
          ),

          Material(
            type: MaterialType.transparency,
            child: CheckboxListTile(
              value: _hasPendingObligations,
              onChanged: (val) =>
                  setState(() => _hasPendingObligations = val ?? false),
              title: Text(
                '¿Tiene obligaciones o activos corporativos pendientes?',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              ),
              subtitle: Text(
                'Herramientas, llaves, uniformes, credenciales magnéticas o deudas pendientes',
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11.5,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFF59E0B),
            ),
          ),

          if (_hasPendingObligations) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _obligationsDetailController,
              maxLines: 2,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              decoration: _inputDecoration(
                hint:
                    'Detalle de los bienes, activos o rendiciones que debe entregar antes del visado...',
              ),
              validator: (val) {
                if (_hasPendingObligations &&
                    (val == null || val.trim().isEmpty)) {
                  return 'Indique el detalle de las obligaciones pendientes';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
          ],

          Material(
            type: MaterialType.transparency,
            child: CheckboxListTile(
              value: _notifiedEmployee,
              onChanged: (val) =>
                  setState(() => _notifiedEmployee = val ?? true),
              title: Text(
                'Notificar formalmente al empleado sobre el registro de baja',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDatePickerButton({
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
            const SizedBox(width: 8),
            Text(
              _fmtDate(date),
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
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
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: const Text('Cancelar'),
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
                : const Icon(Icons.check, size: 16),
            label: Text(
              isEditing ? 'Guardar Cambios' : 'Registrar Desvinculación',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        color: const Color(0xFF64748B),
        fontSize: 12.5,
      ),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0xFF111827),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    );
  }

  TextStyle get _labelStyle => GoogleFonts.inter(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF94A3B8),
  );

  String _fmtDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
