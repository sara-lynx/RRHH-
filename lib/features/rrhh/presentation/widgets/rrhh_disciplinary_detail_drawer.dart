import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest, RrhhVacation;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_disciplinary_status_chip.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_fault_type_chip.dart';
import 'rrhh_sanction_type_chip.dart';
import 'rrhh_snack_bar.dart';

/// Drawer lateral 360° para detalle, descargo, resolución y trazabilidad de incidencias disciplinarias.
class RrhhDisciplinaryDetailDrawer extends StatefulWidget {
  final int recordId;
  final VoidCallback? onModified;

  const RrhhDisciplinaryDetailDrawer({
    super.key,
    required this.recordId,
    this.onModified,
  });

  static Future<bool?> show(
    BuildContext context,
    int recordId, {
    VoidCallback? onModified,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (ctx, a1, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOutCubic)),
        child: child,
      ),
      pageBuilder: (ctx, _, _) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: RrhhDisciplinaryDetailDrawer(
            recordId: recordId,
            onModified: onModified,
          ),
        ),
      ),
    );
  }

  @override
  State<RrhhDisciplinaryDetailDrawer> createState() =>
      _RrhhDisciplinaryDetailDrawerState();
}

class _RrhhDisciplinaryDetailDrawerState
    extends State<RrhhDisciplinaryDetailDrawer> {
  bool _isLoading = true;
  bool _isActionRunning = false;
  String? _errorMessage;

  RrhhDisciplinaryRecord? _record;
  RrhhEmployee? _employee;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = RrhhRepository.current;
      final rec = await repo.getDisciplinaryRecordById(widget.recordId);
      if (rec == null) {
        throw StateError('Registro disciplinario no encontrado');
      }

      RrhhEmployee? emp;
      try {
        emp = await repo.getEmployeeById(rec.employeeId);
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _record = rec;
        _employee = emp;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar detalle: $e';
        _isLoading = false;
      });
    }
  }

  String _fmt(DateTime? d) {
    if (d == null) return '-';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _fmtTime(DateTime? d) {
    if (d == null) return '-';
    return '${_fmt(d)} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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

  // --- ACCIONES DE NEGOCIO ---

  Future<void> _handleRegisterDischarge() async {
    final dischargeCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.assignment_turned_in_outlined,
              color: Color(0xFF38BDF8),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Registrar Descargo del Empleado',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingrese la fundamentación y alegatos presentados por el colaborador dentro del plazo otorgado:',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dischargeCtrl,
                  maxLines: 5,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Alegatos, circunstancias eximentes, justificaciones...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: const Color(0xFF64748B),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF111827),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1E293B)),
                    ),
                  ),
                  validator: (v) => v == null || v.trim().length < 15
                      ? 'Ingrese al menos 15 caracteres'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: Text(
              'Guardar Descargo',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && dischargeCtrl.text.trim().isNotEmpty) {
      setState(() => _isActionRunning = true);
      try {
        final now = DateTime.now();
        final updated = _record!.copyWith(
          dischargeText: dischargeCtrl.text.trim(),
          dischargeDate: now,
          status: RrhhDisciplinaryStatus.enDescargo,
          updatedAt: now,
        );
        await RrhhRepository.current.updateDisciplinaryRecord(updated);
        widget.onModified?.call();
        await _loadData();
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Descargo registrado correctamente. Caso en evaluación.',
          );
        }
      } catch (e) {
        if (mounted) {
          RrhhSnackBar.showError(context, 'Error al guardar descargo: $e');
        }
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleApplySanction() async {
    String selectedSanction =
        _record!.sanctionType ?? RrhhSanctionTypes.escrita;
    final reasonCtrl = TextEditingController(
      text: _record!.sanctionDescription ?? '',
    );
    final daysCtrl = TextEditingController(
      text: (_record!.suspensionDays ?? 1).toString(),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.gavel_outlined,
                color: Color(0xFFEF4444),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Aplicar Resolución y Sanción Final',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Habiéndose valorado la falta y los descargos correspondientes, defina la sanción definitiva:',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'TIPO DE SANCIÓN',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: selectedSanction,
                  dropdownColor: const Color(0xFF1E293B),
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF111827),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: RrhhSanctionTypes.verbal,
                      child: Text('Amonestación verbal'),
                    ),
                    DropdownMenuItem(
                      value: RrhhSanctionTypes.escrita,
                      child: Text('Amonestación escrita (memorándum)'),
                    ),
                    DropdownMenuItem(
                      value: RrhhSanctionTypes.pecuniaria,
                      child: Text('Sanción pecuniaria'),
                    ),
                    DropdownMenuItem(
                      value: RrhhSanctionTypes.suspension,
                      child: Text('Suspensión sin goce'),
                    ),
                    DropdownMenuItem(
                      value: RrhhSanctionTypes.retiro,
                      child: Text('Retiro / Destitución'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedSanction = val);
                    }
                  },
                ),
                if (selectedSanction == RrhhSanctionTypes.suspension) ...[
                  const SizedBox(height: 12),
                  Text(
                    'DÍAS DE SUSPENSIÓN (1-5)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: daysCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF111827),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  'RESOLUCIÓN / MEMORÁNDUM',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Fundamentación de la resolución emitida...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF111827),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              child: Text(
                'Confirmar Sanción',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      setState(() => _isActionRunning = true);
      try {
        final now = DateTime.now();
        int? suspDays;
        double? deduction;
        if (selectedSanction == RrhhSanctionTypes.suspension) {
          suspDays = int.tryParse(daysCtrl.text.trim()) ?? 1;
          deduction = suspDays * 150.0;
        } else if (selectedSanction == RrhhSanctionTypes.pecuniaria) {
          deduction = _record!.salaryDeduction ?? 300.0;
        }

        final updated = _record!.copyWith(
          sanctionType: selectedSanction,
          suspensionDays: suspDays,
          salaryDeduction: deduction,
          sanctionDescription: reasonCtrl.text.trim(),
          status: RrhhDisciplinaryStatus.sancionada,
          sanctionedAt: now,
          sanctionedBy: 'Lic. Laura Mendoza',
          updatedAt: now,
        );
        await RrhhRepository.current.updateDisciplinaryRecord(updated);
        widget.onModified?.call();
        await _loadData();
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Sanción aplicada exitosamente y registrada en legajo.',
          );
        }
      } catch (e) {
        if (mounted) {
          RrhhSnackBar.showError(context, 'Error al aplicar sanción: $e');
        }
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleUpdateStatus(String newStatus, {String? reason}) async {
    setState(() => _isActionRunning = true);
    try {
      await RrhhRepository.current.updateDisciplinaryStatus(
        widget.recordId,
        newStatus,
        reason: reason,
      );
      widget.onModified?.call();
      await _loadData();
      if (mounted) {
        RrhhSnackBar.showSuccess(context, 'Estado actualizado a "$newStatus".');
      }
    } catch (e) {
      if (mounted) {
        RrhhSnackBar.showError(context, 'Error al actualizar estado: $e');
      }
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  // --- INTERFAZ GRÁFICA ---

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 580,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(left: BorderSide(color: Color(0xFF1E293B), width: 1)),
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
            )
          : _errorMessage != null
          ? _buildErrorView()
          : _buildContent(),
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final rec = _record!;

    return Column(
      children: [
        // Drawer Header
        _buildDrawerHeader(rec),
        const Divider(height: 1, color: Color(0xFF1E293B)),

        // Drawer Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection1Employee(rec),
                const SizedBox(height: 20),
                _buildSection2Incident(rec),
                const SizedBox(height: 20),
                if (rec.requiresDischarge) ...[
                  _buildSection3Discharge(rec),
                  const SizedBox(height: 20),
                ],
                _buildSection4Sanction(rec),
                const SizedBox(height: 20),
                _buildSection5Documents(rec),
                const SizedBox(height: 20),
                _buildSection6Timeline(rec),
              ],
            ),
          ),
        ),

        // Drawer Footer Actions
        const Divider(height: 1, color: Color(0xFF1E293B)),
        _buildDrawerFooter(rec),
      ],
    );
  }

  Widget _buildDrawerHeader(RrhhDisciplinaryRecord rec) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              rec.code,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF38BDF8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          RrhhDisciplinaryStatusChip(status: rec.status),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            splashRadius: 18,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildSection1Employee(RrhhDisciplinaryRecord rec) {
    return _sectionBox(
      title: '1. DATOS DEL EMPLEADO',
      icon: Icons.person_outline,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.2),
            child: Text(
              _getInitials(rec.employeeName),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.employeeName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rec.employeeCode} • ${_employee?.position ?? "Operario de Servicios"}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                Text(
                  'Área: ${_employee?.area ?? "Operaciones"} | Sede: ${_employee?.workplace ?? "Central"}',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Supervisor: ${_getSupervisorForArea(_employee?.area ?? "Operaciones")}',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    RrhhEmployeeDetailDialog.show(context, rec.employeeId);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.folder_shared_outlined,
                        size: 14,
                        color: Color(0xFF38BDF8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ver Expediente Completo',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF38BDF8),
                          decoration: TextDecoration.underline,
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
    );
  }

  Widget _buildSection2Incident(RrhhDisciplinaryRecord rec) {
    return _sectionBox(
      title: '2. DATOS DE LA INCIDENCIA',
      icon: Icons.error_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _dataField('FECHA DEL HECHO', _fmt(rec.incidentDate)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TIPO DE FALTA', style: _labelStyle),
                    const SizedBox(height: 4),
                    RrhhFaultTypeChip(faultType: rec.faultType),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('DESCRIPCIÓN DEL HECHO', style: _labelStyle),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Text(
              rec.incidentDescription,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFFE2E8F0),
                height: 1.4,
              ),
            ),
          ),
          if (rec.witnesses != null && rec.witnesses!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _dataField('TESTIGOS REGISTRADOS', rec.witnesses!),
          ],
          if (rec.evidenceFile != null && rec.evidenceFile!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _dataField('EVIDENCIA ADJUNTA', rec.evidenceFile!),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    RrhhSnackBar.showInfo(
                      context,
                      'Visualizando archivo: ${rec.evidenceFile}',
                    );
                  },
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text('Ver archivo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    side: const BorderSide(color: Color(0xFF38BDF8)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    textStyle: GoogleFonts.inter(fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Registrado por: ${rec.createdBy} el ${_fmtTime(rec.createdAt)}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection3Discharge(RrhhDisciplinaryRecord rec) {
    final hasDischarge =
        rec.dischargeText != null && rec.dischargeText!.isNotEmpty;
    final isWithinDeadline =
        rec.dischargeDeadline != null &&
        rec.dischargeDeadline!.isAfter(DateTime.now());

    return _sectionBox(
      title: '3. DEBIDO PROCESO Y DESCARGO',
      icon: Icons.shield_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _dataField(
                  'FECHA LÍMITE DE DESCARGO',
                  _fmt(rec.dischargeDeadline),
                ),
              ),
              Expanded(
                child: _dataField(
                  'ESTADO DEL DESCARGO',
                  hasDischarge
                      ? 'Presentado'
                      : (isWithinDeadline
                            ? 'En espera (vigente)'
                            : 'Plazo vencido'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (hasDischarge) ...[
            Text('TEXTO DEL DESCARGO DEL TRABAJADOR', style: _labelStyle),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec.dischargeText!,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: const Color(0xFFE2E8F0),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Presentado el: ${_fmtTime(rec.dischargeDate)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.pending_actions,
                    size: 20,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No se ha registrado aún el descargo formal del empleado para este expediente.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  if (rec.status == RrhhDisciplinaryStatus.registrada ||
                      rec.status == RrhhDisciplinaryStatus.enDescargo) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _handleRegisterDischarge,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Registrar descargo',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection4Sanction(RrhhDisciplinaryRecord rec) {
    return _sectionBox(
      title: '4. SANCIÓN Y RESOLUCIÓN',
      icon: Icons.gavel_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TIPO DE SANCIÓN', style: _labelStyle),
                    const SizedBox(height: 4),
                    RrhhSanctionTypeChip(sanctionType: rec.sanctionType),
                  ],
                ),
              ),
              if (rec.suspensionDays != null && rec.suspensionDays! > 0)
                Expanded(
                  child: _dataField(
                    'DÍAS SUSPENSIÓN',
                    '${rec.suspensionDays} días sin goce',
                  ),
                ),
              if (rec.salaryDeduction != null && rec.salaryDeduction! > 0)
                Expanded(
                  child: _dataField(
                    'DESCUENTO SALARIAL',
                    'Bs. ${rec.salaryDeduction!.toStringAsFixed(2)}',
                  ),
                ),
            ],
          ),
          if (rec.sanctionDescription != null &&
              rec.sanctionDescription!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('FUNDAMENTO DE LA RESOLUCIÓN', style: _labelStyle),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Text(
                rec.sanctionDescription!,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _dataField(
                  'NOTIFICACIÓN AL EMPLEADO',
                  rec.notifiedEmployee
                      ? 'Notificado (${rec.notificationMethod ?? "Físico"})'
                      : 'No notificado',
                ),
              ),
              if (rec.sanctionedAt != null)
                Expanded(
                  child: _dataField(
                    'FECHA RESOLUCIÓN',
                    _fmtTime(rec.sanctionedAt),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection5Documents(RrhhDisciplinaryRecord rec) {
    final docs = <Map<String, String>>[];
    if (rec.sanctionType != null && rec.sanctionType != 'archivar') {
      docs.add({
        'title': 'Memorándum de Sanción (${rec.code}).pdf',
        'type': 'Memorándum formal de RRHH',
      });
    }
    if (rec.dischargeText != null) {
      docs.add({
        'title': 'Carta_de_Descargo_${rec.employeeCode}.pdf',
        'type': 'Descargo firmado por trabajador',
      });
    }
    if (rec.evidenceFile != null) {
      docs.add({
        'title': rec.evidenceFile!,
        'type': 'Evidencia probatoria adjunta',
      });
    }

    return _sectionBox(
      title: '5. DOCUMENTOS Y EXPEDIENTES GENERADOS',
      icon: Icons.attach_file,
      child: docs.isEmpty
          ? Text(
              'No hay documentos adjuntos generados aún.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            )
          : Column(
              children: docs.map((d) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
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
                      const Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d['title']!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              d['type']!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.download_outlined,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                        tooltip: 'Descargar archivo',
                        onPressed: () {
                          RrhhSnackBar.showInfo(
                            context,
                            'Descargando ${d['title']}...',
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildSection6Timeline(RrhhDisciplinaryRecord rec) {
    final events = <Map<String, dynamic>>[];

    events.add({
      'title': 'Incidencia registrada',
      'user': rec.createdBy,
      'date': rec.createdAt,
      'color': const Color(0xFF38BDF8),
    });

    if (rec.dischargeDate != null) {
      events.add({
        'title': 'Descargo presentado por colaborador',
        'user': rec.employeeName,
        'date': rec.dischargeDate!,
        'color': const Color(0xFFF59E0B),
      });
    }

    if (rec.sanctionedAt != null) {
      events.add({
        'title': 'Sanción aplicada: ${rec.sanctionType ?? "Resuelta"}',
        'user': rec.sanctionedBy ?? 'Jefatura de RRHH',
        'date': rec.sanctionedAt!,
        'color': const Color(0xFFEF4444),
      });
    }

    if (rec.status == RrhhDisciplinaryStatus.apelada) {
      events.add({
        'title': 'Proceso apelado ante tribunal/comité',
        'user': rec.employeeName,
        'date': rec.updatedAt,
        'color': const Color(0xFFF59E0B),
      });
    }

    if (rec.status == RrhhDisciplinaryStatus.archivada) {
      events.add({
        'title': 'Expediente archivado sin sanción',
        'user': 'Comité Disciplinario',
        'date': rec.updatedAt,
        'color': const Color(0xFF10B981),
      });
    }

    if (rec.status == RrhhDisciplinaryStatus.cerrada) {
      events.add({
        'title': 'Caso formalmente cerrado y remitido a nómina',
        'user': 'Jefatura de RRHH',
        'date': rec.updatedAt,
        'color': const Color(0xFF64748B),
      });
    }

    return _sectionBox(
      title: '6. HISTORIAL DEL PROCESO',
      icon: Icons.history,
      child: Column(
        children: events.asMap().entries.map((entry) {
          final idx = entry.key;
          final ev = entry.value;
          final isLast = idx == events.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: ev['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 32,
                      color: const Color(0xFF1E293B),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ev['title'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${ev['user']} • ${_fmtTime(ev['date'] as DateTime)}',
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrawerFooter(RrhhDisciplinaryRecord rec) {
    if (_isActionRunning) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
        ),
      );
    }

    final status = rec.status;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.end,
        children: [
          // Si 'registrada' y requiere descargo
          if (status == RrhhDisciplinaryStatus.registrada &&
              rec.requiresDischarge) ...[
            OutlinedButton(
              onPressed: () => _handleUpdateStatus(
                RrhhDisciplinaryStatus.archivada,
                reason: 'Proceso cancelado antes de descargo',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF94A3B8),
              ),
              child: const Text('Archivar / Cancelar'),
            ),
            ElevatedButton.icon(
              onPressed: _handleRegisterDischarge,
              icon: const Icon(Icons.assignment_outlined, size: 15),
              label: const Text('Registrar descargo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
            ),
          ],

          // Si 'en_descargo'
          if (status == RrhhDisciplinaryStatus.enDescargo) ...[
            OutlinedButton(
              onPressed: () => _handleUpdateStatus(
                RrhhDisciplinaryStatus.archivada,
                reason: 'Archivado sin sanción tras descargo',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF10B981),
              ),
              child: const Text('Archivar sin sanción'),
            ),
            ElevatedButton.icon(
              onPressed: _handleApplySanction,
              icon: const Icon(Icons.gavel_outlined, size: 15),
              label: const Text('Aplicar sanción'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
            ),
          ],

          // Si 'sancionada'
          if (status == RrhhDisciplinaryStatus.sancionada) ...[
            OutlinedButton(
              onPressed: () => _handleUpdateStatus(
                RrhhDisciplinaryStatus.apelada,
                reason: 'Apelación interpuesta por el trabajador',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF59E0B),
              ),
              child: const Text('Marcar como apelada'),
            ),
            ElevatedButton.icon(
              onPressed: () => _handleUpdateStatus(
                RrhhDisciplinaryStatus.cerrada,
                reason: 'Sanción cumplida y cerrada',
              ),
              icon: const Icon(Icons.check_circle_outline, size: 15),
              label: const Text('Cerrar caso'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
              ),
            ),
          ],

          // Si 'apelada'
          if (status == RrhhDisciplinaryStatus.apelada) ...[
            OutlinedButton(
              onPressed: _handleApplySanction,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF38BDF8),
              ),
              child: const Text('Revisar sanción'),
            ),
            ElevatedButton.icon(
              onPressed: () => _handleUpdateStatus(
                RrhhDisciplinaryStatus.cerrada,
                reason: 'Apelación resuelta y caso cerrado',
              ),
              icon: const Icon(Icons.check_circle_outline, size: 15),
              label: const Text('Cerrar caso'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
              ),
            ),
          ],

          // Si 'archivada' o 'cerrada'
          if (status == RrhhDisciplinaryStatus.archivada ||
              status == RrhhDisciplinaryStatus.cerrada) ...[
            Text(
              'Caso ${status.toUpperCase()} (Solo lectura)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionBox({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: const Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
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

  Widget _dataField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  TextStyle get _labelStyle => GoogleFonts.inter(
    fontSize: 10.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: const Color(0xFF64748B),
  );

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'EM';
    if (parts.length == 1)
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
