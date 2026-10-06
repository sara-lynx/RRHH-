import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_leave_request_edit_dialog.dart';
import 'rrhh_leave_status_chip.dart';
import 'rrhh_leave_type_chip.dart';
import 'rrhh_snack_bar.dart';

/// Drawer lateral para el detalle 360° y resolución de una solicitud de Permiso o Licencia.
class RrhhLeaveRequestDetailDrawer extends StatefulWidget {
  final int leaveId;
  final VoidCallback? onModified;

  const RrhhLeaveRequestDetailDrawer({
    super.key,
    required this.leaveId,
    this.onModified,
  });

  static Future<bool?> show(
    BuildContext context,
    int leaveId, {
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
          child: RrhhLeaveRequestDetailDrawer(
            leaveId: leaveId,
            onModified: onModified,
          ),
        ),
      ),
    );
  }

  @override
  State<RrhhLeaveRequestDetailDrawer> createState() =>
      _RrhhLeaveRequestDetailDrawerState();
}

class _RrhhLeaveRequestDetailDrawerState
    extends State<RrhhLeaveRequestDetailDrawer> {
  bool _isLoading = true;
  bool _isActionRunning = false;
  String? _errorMessage;

  RrhhLeaveRequest? _leave;
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
      final leave = await repo.getLeaveRequestById(widget.leaveId);
      if (leave == null) {
        throw StateError('Solicitud de permiso no encontrada');
      }

      RrhhEmployee? emp;
      try {
        emp = await repo.getEmployeeById(leave.employeeId);
      } catch (_) {
        // Fallback a los datos snapshot si no se encuentra en el directorio
      }

      if (!mounted) return;
      setState(() {
        _leave = leave;
        _employee = emp;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar la solicitud: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _formatDateTime(DateTime d) {
    return '${_formatDate(d)} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  // ===========================================================================
  // ACCIONES DE RESOLUCIÓN
  // ===========================================================================

  Future<void> _handleApprove() async {
    final leave = _leave;
    if (leave == null) return;

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF10B981),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Aprobar Solicitud',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de aprobar la solicitud ${leave.code} de ${leave.employeeName} por ${leave.durationDays} día(s)?\n\n'
          'Esta acción actualizará el estatus a "Aprobado" y se notificará para el registro de novedades.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Aprobar Permiso',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isActionRunning = true);
    try {
      await RrhhRepository.current.updateLeaveStatus(
        leave.id,
        RrhhLeaveStatus.aprobado,
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Solicitud ${leave.code} aprobada exitosamente.',
      );
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al aprobar: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleReject() async {
    final leave = _leave;
    if (leave == null) return;

    final reasonCtrl = TextEditingController();
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.cancel_outlined,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Rechazar Solicitud',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Indica el motivo por el cual se rechaza la solicitud ${leave.code}. Este motivo quedará registrado en el historial de la novedad.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      'Motivo del rechazo (obligatorio, mínimo 20 caracteres)...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111827),
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
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                ),
                validator: (val) {
                  final text = val?.trim() ?? '';
                  if (text.length < 20) {
                    return 'El motivo debe tener al menos 20 caracteres (${text.length}/20)';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              'Rechazar Solicitud',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isActionRunning = true);
    try {
      await RrhhRepository.current.updateLeaveStatus(
        leave.id,
        RrhhLeaveStatus.rechazado,
        reason: reasonCtrl.text.trim(),
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showWarning(
        context,
        'Solicitud ${leave.code} marcada como Rechazada.',
      );
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al rechazar: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleCancel() async {
    final leave = _leave;
    if (leave == null) return;

    final reasonCtrl = TextEditingController();
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.block_outlined,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cancelar Permiso',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leave.isPaid) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Este permiso fue pagado. Cancelarlo puede requerir ajuste en nómina.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFCD34D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Text(
                'Indica el motivo de la cancelación de la solicitud ${leave.code}:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Motivo de la cancelación (obligatorio)...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111827),
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
                    borderSide: const BorderSide(color: Color(0xFFF59E0B)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'El motivo de cancelación es obligatorio';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Atrás',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              'Confirmar Cancelación',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isActionRunning = true);
    try {
      await RrhhRepository.current.updateLeaveStatus(
        leave.id,
        RrhhLeaveStatus.cancelado,
        reason: reasonCtrl.text.trim(),
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showInfo(context, 'Solicitud ${leave.code} cancelada.');
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cancelar: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleFinalize() async {
    final leave = _leave;
    if (leave == null) return;

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF64748B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_box_outlined,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Finalizar Permiso',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          'El período establecido finalizó. ¿Marcar la solicitud ${leave.code} como Finalizada para cierre de novedades?',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
            height: 1.4,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Marcar Finalizado',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isActionRunning = true);
    try {
      await RrhhRepository.current.updateLeaveStatus(
        leave.id,
        RrhhLeaveStatus.finalizado,
        approvedBy: 'Encargada RRHH',
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Solicitud ${leave.code} marcada como Finalizada.',
      );
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al finalizar: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleEdit() async {
    final leave = _leave;
    if (leave == null) return;

    final updated = await RrhhLeaveRequestEditDialog.show(
      context,
      leave: leave,
    );

    if (updated == true) {
      widget.onModified?.call();
      await _loadData();
    }
  }

  // ===========================================================================
  // CONSTRUCCIÓN VISUAL
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth < 560 ? screenWidth * 0.95 : 520.0;

    return Container(
      width: drawerWidth,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(left: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            )
          : _leave == null
          ? Center(
              child: Text(
                _errorMessage ?? 'Solicitud no encontrada',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionEmployee(),
                        const SizedBox(height: 16),
                        _buildSectionLeaveData(),
                        const SizedBox(height: 16),
                        _buildSectionReason(),
                        const SizedBox(height: 16),
                        _buildSectionEvidence(),
                        const SizedBox(height: 16),
                        _buildSectionInternalNotes(),
                        const SizedBox(height: 16),
                        _buildSectionTimeline(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    final leave = _leave!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 14, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        leave.code,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      RrhhLeaveStatusChip(status: leave.status),
                    ],
                  ),
                  Text(
                    'Detalle de Novedad Laboral',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Sección 1: Empleado
  Widget _buildSectionEmployee() {
    final leave = _leave!;
    final emp = _employee;
    final initials = leave.employeeName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.2),
                child: Text(
                  initials.isNotEmpty ? initials : 'EM',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF60A5FA),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leave.employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${leave.employeeCode} • ${emp?.position ?? "Personal"} (${emp?.area ?? "Operaciones"})',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  emp?.status.toUpperCase() ?? 'ACTIVO',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF34D399),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF334155), height: 1),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              RrhhEmployeeDetailDialog.show(context, leave.employeeId);
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 15,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ver Expediente completo del empleado',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 11,
                    color: Color(0xFF38BDF8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sección 2: Datos del permiso
  Widget _buildSectionLeaveData() {
    final leave = _leave!;
    final isWorkingDaysType =
        leave.leaveType == RrhhLeaveTypes.maternidad ||
        leave.leaveType == RrhhLeaveTypes.paternidad;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_note_outlined,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Text(
                'Datos de la Solicitud',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Tipo de Permiso',
            RrhhLeaveTypeChip(leaveType: leave.leaveType),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Período',
            Text(
              '${_formatDate(leave.startDate)} → ${_formatDate(leave.endDate)}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Duración',
            Text(
              '${leave.durationDays} ${isWorkingDaysType ? "días hábiles" : "días calendario"}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Goce de haberes',
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: leave.isPaid
                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                    : const Color(0xFF64748B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: leave.isPaid
                      ? const Color(0xFF10B981).withValues(alpha: 0.3)
                      : const Color(0xFF64748B).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                leave.isPaid ? 'Pagado (con goce)' : 'Sin goce de haberes',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: leave.isPaid
                      ? const Color(0xFF34D399)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Registrado por',
            Text(
              '${leave.createdBy} • ${_formatDateTime(leave.createdAt)}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, Widget valueWidget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(child: valueWidget),
      ],
    );
  }

  // Sección 3: Motivo
  Widget _buildSectionReason() {
    final leave = _leave!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 15,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Text(
                'Motivo Justificado',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            leave.reason,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: const Color(0xFFCBD5E1),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // Sección 4: Evidencia
  Widget _buildSectionEvidence() {
    final leave = _leave!;
    final hasFile =
        leave.evidenceFile != null && leave.evidenceFile!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.attach_file,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Text(
                'Evidencia Adjunta',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (hasFile) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF38BDF8),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      leave.evidenceFile!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      RrhhSnackBar.showInfo(
                        context,
                        'Descarga simulada de archivo: ${leave.evidenceFile}',
                      );
                    },
                    icon: const Icon(Icons.download, size: 15),
                    label: Text(
                      'Descargar',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'No se adjuntó archivo de respaldo.',
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

  // Sección 5: Observaciones internas
  Widget _buildSectionInternalNotes() {
    final leave = _leave!;
    final hasNotes = leave.notes != null && leave.notes!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline,
                size: 15,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              Text(
                'Observaciones Internas',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Solo RRHH',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFCD34D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasNotes ? leave.notes! : 'Sin observaciones internas registradas.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: hasNotes
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF64748B),
              fontStyle: hasNotes ? FontStyle.normal : FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Sección 6: Historial de cambios
  Widget _buildSectionTimeline() {
    final leave = _leave!;

    final events = <Map<String, dynamic>>[];

    // 1. Registrado
    events.add({
      'title': 'Solicitud Registrada',
      'subtitle': 'Registrada por ${leave.createdBy}',
      'date': _formatDateTime(leave.createdAt),
      'color': const Color(0xFF38BDF8),
      'icon': Icons.add_circle_outline,
    });

    // 2. Aprobado
    if (leave.approvedAt != null ||
        leave.status == RrhhLeaveStatus.aprobado ||
        leave.status == RrhhLeaveStatus.enCurso ||
        leave.status == RrhhLeaveStatus.finalizado) {
      events.add({
        'title': 'Permiso Aprobado',
        'subtitle': leave.approvedBy != null
            ? 'Aprobado por ${leave.approvedBy}'
            : 'Aprobación oficial RRHH',
        'date': leave.approvedAt != null
            ? _formatDateTime(leave.approvedAt!)
            : _formatDateTime(leave.updatedAt),
        'color': const Color(0xFF10B981),
        'icon': Icons.check_circle_outline,
      });
    }

    // 3. Rechazado
    if (leave.status == RrhhLeaveStatus.rechazado) {
      events.add({
        'title': 'Solicitud Rechazada',
        'subtitle':
            '${leave.rejectionReason ?? "Sin motivo registrado"} • Por ${leave.approvedBy ?? "RRHH"}',
        'date': _formatDateTime(leave.updatedAt),
        'color': const Color(0xFFEF4444),
        'icon': Icons.cancel_outlined,
      });
    }

    // 4. Cancelado
    if (leave.status == RrhhLeaveStatus.cancelado) {
      events.add({
        'title': 'Permiso Cancelado',
        'subtitle':
            '${leave.rejectionReason ?? "Cancelado por el solicitante/RRHH"} • Por ${leave.approvedBy ?? "RRHH"}',
        'date': _formatDateTime(leave.updatedAt),
        'color': const Color(0xFFF59E0B),
        'icon': Icons.block_outlined,
      });
    }

    // 5. Finalizado
    if (leave.status == RrhhLeaveStatus.finalizado) {
      events.add({
        'title': 'Permiso Finalizado',
        'subtitle': 'Cierre del período de ausencia justificada',
        'date': _formatDateTime(leave.updatedAt),
        'color': const Color(0xFF64748B),
        'icon': Icons.done_all,
      });
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.timeline,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 8),
              Text(
                'Línea de Tiempo de Cambios',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(events.length, (idx) {
              final ev = events[idx];
              final isLast = idx == events.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (ev['color'] as Color).withValues(
                              alpha: 0.15,
                            ),
                            border: Border.all(
                              color: ev['color'] as Color,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            ev['icon'] as IconData,
                            size: 11,
                            color: ev['color'] as Color,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 1.5,
                              color: const Color(0xFF334155),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ev['title'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ev['date'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ev['subtitle'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Barra de acciones inferior según estado
  Widget _buildBottomBar() {
    final leave = _leave!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: _isActionRunning
          ? const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF2563EB),
                ),
              ),
            )
          : Row(
              children: [
                if (leave.status == RrhhLeaveStatus.pendiente) ...[
                  // Pendiente: [Aprobar] [Rechazar] [Editar] [Cancelar]
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _handleApprove,
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        'Aprobar',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _handleReject,
                      icon: const Icon(Icons.close, size: 16),
                      label: Text(
                        'Rechazar',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Editar Solicitud',
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF38BDF8),
                      size: 19,
                    ),
                    onPressed: _handleEdit,
                  ),
                  IconButton(
                    tooltip: 'Cancelar Solicitud',
                    icon: const Icon(
                      Icons.block_outlined,
                      color: Color(0xFF94A3B8),
                      size: 19,
                    ),
                    onPressed: _handleCancel,
                  ),
                ] else if (leave.status == RrhhLeaveStatus.aprobado) ...[
                  // Aprobado: Cancelar si startDate > hoy
                  if (leave.startDate.isAfter(today)) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFF59E0B),
                          side: const BorderSide(color: Color(0xFFF59E0B)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _handleCancel,
                        icon: const Icon(Icons.block, size: 16),
                        label: Text(
                          'Cancelar Permiso',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        'Permiso aprobado y en fecha de vigencia.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ],
                ] else if (leave.status == RrhhLeaveStatus.enCurso) ...[
                  // En curso: Finalizar si endDate <= hoy
                  if (leave.endDate.isBefore(today) ||
                      leave.endDate.isAtSameMomentAs(today)) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _handleFinalize,
                        icon: const Icon(Icons.done_all, size: 16),
                        label: Text(
                          'Marcar como Finalizado',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        'Permiso en curso actualmente.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  // Finalizado, Rechazado, Cancelado -> Solo lectura
                  Expanded(
                    child: Text(
                      'Esta solicitud se encuentra en modo sólo lectura (${leave.status.toUpperCase()}).',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
