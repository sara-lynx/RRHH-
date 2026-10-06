import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest, RrhhVacation;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_snack_bar.dart';
import 'rrhh_vacation_balance_chip.dart';
import 'rrhh_vacation_edit_dialog.dart';
import 'rrhh_vacation_status_chip.dart';

/// Drawer lateral para el detalle 360° y resolución de un registro de vacaciones.
class RrhhVacationDetailDrawer extends StatefulWidget {
  final int vacationRecordId;
  final VoidCallback? onModified;

  const RrhhVacationDetailDrawer({
    super.key,
    required this.vacationRecordId,
    this.onModified,
  });

  static Future<bool?> show(
    BuildContext context,
    int vacationRecordId, {
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
          child: RrhhVacationDetailDrawer(
            vacationRecordId: vacationRecordId,
            onModified: onModified,
          ),
        ),
      ),
    );
  }

  @override
  State<RrhhVacationDetailDrawer> createState() =>
      _RrhhVacationDetailDrawerState();
}

class _RrhhVacationDetailDrawerState extends State<RrhhVacationDetailDrawer> {
  bool _isLoading = true;
  bool _isActionRunning = false;
  String? _errorMessage;

  RrhhVacationRecord? _record;
  RrhhVacationBalance? _balance;
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
      final rec = await repo.getVacationRecordById(widget.vacationRecordId);
      if (rec == null) {
        throw StateError('Registro de vacaciones no encontrado');
      }

      RrhhVacationBalance? bal;
      RrhhEmployee? emp;

      try {
        bal = await repo.getVacationBalanceByEmployee(rec.employeeId);
      } catch (_) {}

      try {
        emp = await repo.getEmployeeById(rec.employeeId);
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _record = rec;
        _balance = bal;
        _employee = emp;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar el detalle: $e';
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

  Future<void> _handleStart() async {
    if (_record == null) return;
    setState(() => _isActionRunning = true);

    try {
      await RrhhRepository.current.updateVacationStatus(
        _record!.id,
        RrhhVacationRecordStatus.enCurso,
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Período ${_record!.code} iniciado y marcado en curso.',
      );
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al iniciar goce: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleFinish() async {
    if (_record == null) return;
    setState(() => _isActionRunning = true);

    try {
      await RrhhRepository.current.updateVacationStatus(
        _record!.id,
        RrhhVacationRecordStatus.gozado,
      );
      if (!mounted) return;
      RrhhSnackBar.showSuccess(
        context,
        'Período ${_record!.code} finalizado y computado como gozado.',
      );
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al finalizar goce: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleCancel() async {
    if (_record == null) return;

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
              'Cancelar Vacaciones',
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
                'Indica el motivo por el cual se cancela el período ${_record!.code}:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Motivo de la cancelación...',
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
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 5) {
                    return 'Ingresa un motivo válido.';
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
              'Cerrar',
              style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              'Confirmar Cancelación',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isActionRunning = true);
    try {
      await RrhhRepository.current.updateVacationStatus(
        _record!.id,
        RrhhVacationRecordStatus.cancelado,
        reason: reasonCtrl.text.trim(),
      );
      if (!mounted) return;
      RrhhSnackBar.showInfo(context, 'Período ${_record!.code} cancelado.');
      widget.onModified?.call();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      RrhhSnackBar.showError(context, 'Error al cancelar: $e');
    } finally {
      if (mounted) setState(() => _isActionRunning = false);
    }
  }

  Future<void> _handleEdit() async {
    if (_record == null) return;
    final updated = await RrhhVacationEditDialog.show(
      context,
      initialRecord: _record,
    );
    if (updated == true) {
      widget.onModified?.call();
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = (size.width * 0.38).clamp(420.0, 560.0);

    return Container(
      width: width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(left: BorderSide(color: Color(0xFF1E293B))),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 20,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            )
          : _errorMessage != null
          ? _buildErrorWidget()
          : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 40),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
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
    final isProgramado = rec.status == RrhhVacationRecordStatus.programado;
    final isEnCurso = rec.status == RrhhVacationRecordStatus.enCurso;

    return Column(
      children: [
        // 1. Header
        _buildDrawerHeader(rec),

        // 2. Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colaborador Card
                _buildEmployeeCard(),
                const SizedBox(height: 18),

                // Período de Goce Card
                _buildPeriodCard(rec),
                const SizedBox(height: 18),

                // Saldo Card
                if (_balance != null) ...[
                  _buildBalanceImpactCard(rec, _balance!),
                  const SizedBox(height: 18),
                ],

                // Observaciones / Notas
                _buildNotesCard(rec),
                const SizedBox(height: 18),

                // Metadatos de auditoría
                _buildAuditInfo(rec),
              ],
            ),
          ),
        ),

        // 3. Footer de Acciones
        if (isProgramado || isEnCurso)
          _buildFooterActions(isProgramado, isEnCurso),
      ],
    );
  }

  Widget _buildDrawerHeader(RrhhVacationRecord rec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  rec.code,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF60A5FA),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RrhhVacationStatusChip(status: rec.status),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard() {
    final emp = _employee;
    final empName = emp?.fullName ?? _record!.employeeName;
    final empCode = emp?.code ?? _record!.employeeCode;
    final pos = emp?.position ?? 'Colaborador';
    final area = emp?.area ?? 'Operaciones';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.2),
            child: Text(
              empName.isNotEmpty ? empName[0].toUpperCase() : 'E',
              style: GoogleFonts.inter(
                fontSize: 14,
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
                  empName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$empCode • $pos • $area',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          if (emp != null)
            IconButton(
              icon: const Icon(
                Icons.open_in_new,
                size: 16,
                color: Color(0xFF60A5FA),
              ),
              tooltip: 'Ver expediente completo',
              onPressed: () {
                RrhhEmployeeDetailDialog.show(context, emp.id ?? 0);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(RrhhVacationRecord rec) {
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
          Text(
            'DETALLES DEL GOCE',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailTile(
                  'Fecha Inicio',
                  _formatDate(rec.startDate),
                  Icons.calendar_today_outlined,
                ),
              ),
              Expanded(
                child: _buildDetailTile(
                  'Fecha Fin',
                  _formatDate(rec.endDate),
                  Icons.event_available_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailTile(
                  'Días Computados',
                  '${rec.daysCounted} días',
                  Icons.timer_outlined,
                  highlight: true,
                ),
              ),
              Expanded(
                child: _buildDetailTile(
                  'Modo de Cómputo',
                  rec.countingMode == 'habiles'
                      ? 'Hábiles (L-V)'
                      : 'Calendario',
                  Icons.view_week_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(
    String label,
    String value,
    IconData icon, {
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            color: highlight ? const Color(0xFF38BDF8) : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceImpactCard(
    RrhhVacationRecord rec,
    RrhhVacationBalance bal,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'IMPACTO EN SALDO DEL COLABORADOR',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF64748B),
                ),
              ),
              RrhhVacationBalanceChip(status: bal.balanceStatus),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniMetric(
                'Asignados',
                '${bal.assignedDays} d',
                const Color(0xFF38BDF8),
              ),
              _buildMiniMetric(
                'Gozados acumulados',
                '${bal.usedDays} d',
                const Color(0xFF94A3B8),
              ),
              _buildMiniMetric(
                'Saldo pendiente',
                '${bal.pendingDays} d',
                const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard(RrhhVacationRecord rec) {
    final hasNotes = rec.notes != null && rec.notes!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OBSERVACIONES Y NOTAS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasNotes
                ? rec.notes!
                : 'Sin observaciones registradas para este período.',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: hasNotes
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditInfo(RrhhVacationRecord rec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registrado el ${_formatDateTime(rec.createdAt)} por ${rec.createdBy}',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Última actualización: ${_formatDateTime(rec.updatedAt)}',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions(bool isProgramado, bool isEnCurso) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: _isActionRunning ? null : _handleCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFF7F1D1D)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancelar Goce',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isProgramado) ...[
            OutlinedButton(
              onPressed: _isActionRunning ? null : _handleEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF60A5FA),
                side: const BorderSide(color: Color(0xFF2563EB)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Editar',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isActionRunning ? null : _handleStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isActionRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Iniciar Goce',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ],
          if (isEnCurso) ...[
            ElevatedButton(
              onPressed: _isActionRunning ? null : _handleFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isActionRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Finalizar Goce (Gozado)',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
