import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest, RrhhVacation;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_termination_status_chip.dart';
import 'rrhh_termination_type_chip.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_termination_edit_dialog.dart';
import 'rrhh_snack_bar.dart';

/// Drawer lateral 360° para detalle, trazabilidad, pago de finiquito y finalización de bajas laborales.
class RrhhTerminationDetailDrawer extends StatefulWidget {
  final int recordId;
  final VoidCallback? onModified;

  const RrhhTerminationDetailDrawer({
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
          child: RrhhTerminationDetailDrawer(
            recordId: recordId,
            onModified: onModified,
          ),
        ),
      ),
    );
  }

  @override
  State<RrhhTerminationDetailDrawer> createState() =>
      _RrhhTerminationDetailDrawerState();
}

class _RrhhTerminationDetailDrawerState
    extends State<RrhhTerminationDetailDrawer> {
  bool _isLoading = true;
  bool _isActionRunning = false;
  String? _errorMessage;

  RrhhTerminationRecord? _record;
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
      final rec = await repo.getTerminationRecordById(widget.recordId);
      if (rec == null) {
        throw StateError('Registro de desvinculación no encontrado');
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

  Future<void> _handleStartProcess() async {
    final confirmed = await _confirmDialog(
      title: 'Iniciar Proceso de Baja',
      message:
          '¿Desea cambiar el estado del expediente ${_record!.code} a "En Proceso"?',
      actionLabel: 'Iniciar Proceso',
      actionColor: const Color(0xFFF59E0B),
    );

    if (confirmed == true) {
      setState(() => _isActionRunning = true);
      try {
        await RrhhRepository.current.updateTerminationStatus(
          _record!.id,
          RrhhTerminationStatus.enProceso,
          reason: 'Proceso formal de baja iniciado por RRHH.',
        );
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Expediente ${_record!.code} ahora está En Proceso.',
          );
        }
        widget.onModified?.call();
        await _loadData();
      } catch (e) {
        if (mounted)
          RrhhSnackBar.showError(context, 'Error al iniciar proceso: $e');
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleMarkPaymentCompleted() async {
    final confirmed = await _confirmDialog(
      title: 'Registrar Pago de Finiquito',
      message:
          '¿Confirma que se completó el pago de liquidación/finiquito para ${_record!.employeeName} dentro del plazo legal?',
      actionLabel: 'Marcar Pagado',
      actionColor: const Color(0xFF10B981),
    );

    if (confirmed == true) {
      setState(() => _isActionRunning = true);
      try {
        await RrhhRepository.current.updateTerminationStatus(
          _record!.id,
          _record!.status,
          paymentCompleted: true,
          paymentCompletedAt: DateTime.now(),
        );
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Pago de finiquito registrado exitosamente.',
          );
        }
        widget.onModified?.call();
        await _loadData();
      } catch (e) {
        if (mounted)
          RrhhSnackBar.showError(context, 'Error al registrar pago: $e');
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleFinalizeTermination() async {
    final confirmed = await _confirmDialog(
      title: 'Finalizar Baja Laboral',
      message:
          'ATENCIÓN: Al finalizar la baja, el colaborador ${_record!.employeeName} pasará formalmente a estado "BAJA", desaparecerá de las asignaciones operativas activas y el expediente quedará cerrado.',
      actionLabel: 'Finalizar Baja',
      actionColor: const Color(0xFF10B981),
    );

    if (confirmed == true) {
      setState(() => _isActionRunning = true);
      try {
        await RrhhRepository.current.updateTerminationStatus(
          _record!.id,
          RrhhTerminationStatus.finalizada,
          reason: 'Desvinculación y baja laboral completada definitivamente.',
        );
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Baja laboral completada. El colaborador pasó a estado BAJA.',
          );
        }
        widget.onModified?.call();
        await _loadData();
      } catch (e) {
        if (mounted)
          RrhhSnackBar.showError(context, 'Error al finalizar baja: $e');
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleCancelProcess() async {
    final reasonCtrl = TextEditingController();
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
            const Icon(Icons.block, color: Color(0xFFEF4444), size: 20),
            const SizedBox(width: 8),
            Text(
              'Cancelar Proceso de Baja',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indique el motivo por el cual se anula la baja:',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'ej. Reincorporación por acuerdo mutuo...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 12,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Volver'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Confirmar Anulación'),
          ),
        ],
      ),
    );

    if (confirmed == true && reasonCtrl.text.trim().isNotEmpty) {
      setState(() => _isActionRunning = true);
      try {
        await RrhhRepository.current.updateTerminationStatus(
          _record!.id,
          RrhhTerminationStatus.cancelada,
          reason: reasonCtrl.text.trim(),
        );
        if (mounted)
          RrhhSnackBar.showInfo(context, 'Proceso de baja cancelado.');
        widget.onModified?.call();
        await _loadData();
      } catch (e) {
        if (mounted)
          RrhhSnackBar.showError(context, 'Error al cancelar proceso: $e');
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await _confirmDialog(
      title: 'Eliminar Registro',
      message:
          '¿Desea eliminar permanentemente el expediente ${_record!.code}? Esta acción solo está disponible en estado Registrada.',
      actionLabel: 'Eliminar',
      actionColor: const Color(0xFFEF4444),
    );

    if (confirmed == true) {
      setState(() => _isActionRunning = true);
      try {
        await RrhhRepository.current.deleteTerminationRecord(_record!.id);
        if (mounted) {
          RrhhSnackBar.showSuccess(
            context,
            'Registro ${_record!.code} eliminado.',
          );
          Navigator.of(context).pop(true);
        }
        widget.onModified?.call();
      } catch (e) {
        if (mounted) RrhhSnackBar.showError(context, 'Error al eliminar: $e');
      } finally {
        if (mounted) setState(() => _isActionRunning = false);
      }
    }
  }

  Future<void> _handleEdit() async {
    final updated = await RrhhTerminationEditDialog.show(
      context,
      record: _record,
    );
    if (updated == true) {
      widget.onModified?.call();
      await _loadData();
    }
  }

  Future<bool?> _confirmDialog({
    required String title,
    required String message,
    required String actionLabel,
    required Color actionColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: actionColor),
            child: Text(
              actionLabel,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final width = media.width > 680 ? 620.0 : media.width * 0.94;

    return Container(
      width: width,
      height: media.height,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(left: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 24)],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? _buildErrorWidget()
                  : _buildDrawerBody(),
            ),

            // Bottom Actions Bar
            if (!_isLoading && _record != null) _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.person_remove_outlined,
                    color: Color(0xFFEF4444),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _record != null
                            ? 'Expediente ${_record!.code}'
                            : 'Expediente de Desvinculación',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Detalle integral de baja laboral y liquidación',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerBody() {
    final item = _record!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Alerta si el pago está vencido
          if (item.isPaymentExpired) ...[
            _buildExpiredAlertBanner(),
            const SizedBox(height: 16),
          ],

          // Sección 1: Datos del Empleado
          _buildSectionCard(
            title: '1. DATOS DEL EMPLEADO',
            icon: Icons.person_outline,
            child: _buildEmployeeInfo(),
          ),
          const SizedBox(height: 16),

          // Sección 2: Datos de la Desvinculación
          _buildSectionCard(
            title: '2. DETALLE DE LA DESVINCULACIÓN',
            icon: Icons.gavel_outlined,
            child: _buildTerminationInfo(),
          ),
          const SizedBox(height: 16),

          // Sección 3: Documentación
          _buildSectionCard(
            title: '3. DOCUMENTACIÓN ADJUNTA',
            icon: Icons.folder_open_outlined,
            child: _buildDocumentsInfo(),
          ),
          const SizedBox(height: 16),

          // Sección 4: Obligaciones Pendientes
          _buildSectionCard(
            title: '4. OBLIGACIONES Y ACTIVOS CORPORATIVOS',
            icon: Icons.inventory_2_outlined,
            child: _buildObligationsInfo(),
          ),
          const SizedBox(height: 16),

          // Sección 5: Liquidación y Finiquito (Plazo 15 días)
          _buildSectionCard(
            title: '5. PLAZO LEGAL Y PAGO DE FINIQUITO',
            icon: Icons.payments_outlined,
            child: _buildPaymentInfo(),
          ),
          const SizedBox(height: 16),

          // Sección 6: Historial del Proceso
          _buildSectionCard(
            title: '6. HISTORIAL DEL PROCESO',
            icon: Icons.history_toggle_off,
            child: _buildHistoryTimeline(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALERTA LEGAL: PLAZO DE 15 DÍAS VENCIDO',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFCA5A5),
                  ),
                ),
                Text(
                  'El plazo legal improrrogable establecido por el D.S. 28699 para el pago total del finiquito ha vencido. Aplica multa del 30% más mantenimiento de valor.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfo() {
    final item = _record!;
    final emp = _employee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.2),
              child: Text(
                _getInitials(item.employeeName),
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
                    item.employeeName,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${item.employeeCode} · ${emp?.position ?? "Operario"}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            if (emp != null)
              OutlinedButton.icon(
                onPressed: () =>
                    RrhhEmployeeDetailDialog.show(context, item.employeeId),
                icon: const Icon(Icons.open_in_new, size: 13),
                label: const Text('Expediente'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF38BDF8),
                  side: const BorderSide(color: Color(0xFF38BDF8)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  textStyle: GoogleFonts.inter(fontSize: 11),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFF1E293B)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children: [
            _buildDetailField('Área', emp?.area ?? 'Operaciones & Servicios'),
            _buildDetailField(
              'Supervisor',
              emp?.supervisor ?? 'Jefatura Operativa',
            ),
            _buildDetailField(
              'Fecha de Ingreso',
              emp != null ? _fmtDate(emp.realStartDate) : '—',
            ),
            _buildDetailField('Estado Actual', emp?.status ?? 'ACTIVO'),
          ],
        ),
      ],
    );
  }

  Widget _buildTerminationInfo() {
    final item = _record!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo de Baja',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                RrhhTerminationTypeChip(type: item.terminationType),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Estado del Proceso',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                RrhhTerminationStatusChip(status: item.status),
              ],
            ),
          ],
        ),
        if (item.justifiedCause != null) ...[
          const SizedBox(height: 12),
          _buildDetailField('Causal Legal (Art. 16 LGT)', item.justifiedCause!),
        ],
        const SizedBox(height: 12),
        _buildDetailField('Motivo / Justificación', item.reason),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailField(
                'Último día trabajado',
                _fmtDate(item.lastWorkDay),
              ),
            ),
            Expanded(
              child: _buildDetailField(
                'Fecha efectiva de baja',
                _fmtDate(item.terminationDate),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentsInfo() {
    final item = _record!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.resignationLetterFile != null)
          _buildDocRow(
            'Carta de Renuncia',
            item.resignationLetterFile!,
            Icons.description_outlined,
          ),
        if (item.terminationMemoFile != null)
          _buildDocRow(
            'Memorándum de Despido',
            item.terminationMemoFile!,
            Icons.mail_outline,
          ),
        if (item.workCertificateFile != null)
          _buildDocRow(
            'Certificado de Trabajo',
            item.workCertificateFile!,
            Icons.verified_outlined,
          ),
        if (item.settlementFile != null)
          _buildDocRow(
            'Finiquito Visado',
            item.settlementFile!,
            Icons.receipt_long_outlined,
          ),
        if (item.resignationLetterFile == null &&
            item.terminationMemoFile == null &&
            item.workCertificateFile == null &&
            item.settlementFile == null)
          Text(
            'No hay documentos adjuntos registrados.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
            ),
          ),
      ],
    );
  }

  Widget _buildDocRow(String label, String fileName, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF38BDF8)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Text(
                  fileName,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
          const Icon(Icons.download, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Widget _buildObligationsInfo() {
    final item = _record!;

    if (!item.hasPendingObligations) {
      return Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF10B981),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sin obligaciones ni activos corporativos pendientes de entrega.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF10B981),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.inventory_2, color: Color(0xFFF59E0B), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Activos / Bienes pendientes de devolución:',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFDE68A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          item.pendingObligationsDetail ?? 'Sin detalle especificado.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: const Color(0xFFCBD5E1),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    final item = _record!;
    final deadline =
        item.paymentDeadline ?? item.lastWorkDay.add(const Duration(days: 15));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailField(
                'Fecha límite de pago (15 días)',
                _fmtDate(deadline),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado del Pago',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.paymentCompleted)
                    Text(
                      'COMPLETADO (${_fmtDate(item.paymentCompletedAt ?? DateTime.now())})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    )
                  else if (item.isPaymentExpired)
                    Text(
                      'VENCIDO (${item.daysUntilPaymentDeadline.abs()} días de mora)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEF4444),
                      ),
                    )
                  else
                    Text(
                      'PENDIENTE (${item.daysUntilPaymentDeadline} días restantes)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Base Legal: Art. 9 D.S. 28699 dispone que en caso de no cancelarse el finiquito en el plazo de 15 días calendario, el empleador deberá cancelar el monto con una multa del 30% y mantenimiento de valor.',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF64748B),
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTimeline() {
    final item = _record!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineItem(
          title: 'Expediente Registrado',
          subtitle: 'Registrado por ${item.createdBy}',
          date: _fmtDateTime(item.createdAt),
          isDone: true,
        ),
        if (item.notifiedEmployee)
          _buildTimelineItem(
            title: 'Notificación al Colaborador',
            subtitle: 'Notificación oficial enviada al empleado',
            date: item.notifiedAt != null
                ? _fmtDateTime(item.notifiedAt!)
                : '—',
            isDone: true,
          ),
        if (item.paymentCompleted)
          _buildTimelineItem(
            title: 'Liquidación / Finiquito Pagado',
            subtitle: 'Monto liquidado conforme a cálculo contable',
            date: item.paymentCompletedAt != null
                ? _fmtDateTime(item.paymentCompletedAt!)
                : '—',
            isDone: true,
          ),
        if (item.status == RrhhTerminationStatus.finalizada)
          _buildTimelineItem(
            title: 'Baja Laboral Completada',
            subtitle: 'Procesado por ${item.processedBy ?? "RRHH"}',
            date: item.processedAt != null
                ? _fmtDateTime(item.processedAt!)
                : '—',
            isDone: true,
          ),
        if (item.status == RrhhTerminationStatus.cancelada)
          _buildTimelineItem(
            title: 'Proceso Cancelado / Anulado',
            subtitle: item.notes ?? 'Anulado por RRHH',
            date: _fmtDateTime(item.updatedAt),
            isDone: true,
            isError: true,
          ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String date,
    required bool isDone,
    bool isError = false,
  }) {
    final color = isError
        ? const Color(0xFFEF4444)
        : (isDone ? const Color(0xFF10B981) : const Color(0xFF64748B));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final item = _record!;
    final isRegistrada = item.status == RrhhTerminationStatus.registrada;
    final isEnProceso = item.status == RrhhTerminationStatus.enProceso;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isRegistrada) ...[
            TextButton.icon(
              onPressed: _isActionRunning ? null : _handleDelete,
              icon: const Icon(
                Icons.delete_outline,
                size: 14,
                color: Color(0xFFEF4444),
              ),
              label: const Text(
                'Eliminar',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _isActionRunning ? null : _handleEdit,
              icon: const Icon(Icons.edit_outlined, size: 14),
              label: const Text('Editar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _isActionRunning ? null : _handleStartProcess,
              icon: const Icon(Icons.play_arrow_rounded, size: 16),
              label: const Text('Iniciar Proceso'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
            ),
          ],
          if (isEnProceso) ...[
            OutlinedButton.icon(
              onPressed: _isActionRunning ? null : _handleCancelProcess,
              icon: const Icon(Icons.close, size: 14),
              label: const Text('Cancelar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 8),
            if (!item.paymentCompleted)
              FilledButton.icon(
                onPressed: _isActionRunning
                    ? null
                    : _handleMarkPaymentCompleted,
                icon: const Icon(Icons.check_circle_outline, size: 15),
                label: const Text('Marcar Pagado'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                ),
              ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _isActionRunning ? null : _handleFinalizeTermination,
              icon: const Icon(Icons.task_alt, size: 15),
              label: const Text('Finalizar Baja'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Icon(icon, size: 15, color: const Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.5,
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

  Widget _buildDetailField(String label, String value) {
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
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 36),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'EM';
    if (parts.length == 1)
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _fmtDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _fmtDateTime(DateTime dt) {
    return '${_fmtDate(dt)} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
