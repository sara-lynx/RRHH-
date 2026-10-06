import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_termination_record.dart';
import 'rrhh_termination_status_chip.dart';
import 'rrhh_termination_type_chip.dart';

/// Fila individual de la tabla de Desvinculaciones (Pantalla 11 — Bloque 3).
class RrhhTerminationRecordRow extends StatefulWidget {
  final RrhhTerminationRecord record;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onStartProcess;
  final VoidCallback? onMarkPaymentCompleted;
  final VoidCallback? onFinalize;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  const RrhhTerminationRecordRow({
    super.key,
    required this.record,
    required this.onTap,
    this.onEdit,
    this.onStartProcess,
    this.onMarkPaymentCompleted,
    this.onFinalize,
    this.onCancel,
    this.onDelete,
  });

  @override
  State<RrhhTerminationRecordRow> createState() =>
      _RrhhTerminationRecordRowState();
}

class _RrhhTerminationRecordRowState extends State<RrhhTerminationRecordRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.record;
    final isRegistrada = item.status == RrhhTerminationStatus.registrada;
    final isEnProceso = item.status == RrhhTerminationStatus.enProceso;
    final isFinalizada = item.status == RrhhTerminationStatus.finalizada;
    final isCancelada = item.status == RrhhTerminationStatus.cancelada;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF162032)
                : const Color(0xFF0F172A),
            border: const Border(
              bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
            ),
          ),
          child: Row(
            children: [
              // Código BAJA-XXX
              SizedBox(
                width: 90,
                child: Text(
                  item.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Empleado (Avatar + Nombre + Código EMP-XXX)
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: 0.2),
                      child: Text(
                        _getInitials(item.employeeName),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.employeeName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF8FAFC),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            item.employeeCode,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Tipo de desvinculación
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhTerminationTypeChip(type: item.terminationType),
                ),
              ),
              const SizedBox(width: 8),

              // Fecha efectiva
              SizedBox(
                width: 95,
                child: Text(
                  _fmt(item.terminationDate),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Último día trabajado
              SizedBox(
                width: 95,
                child: Text(
                  _fmt(item.lastWorkDay),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Estado del pago del Finiquito (Plazo 15 días)
              SizedBox(
                width: 130,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildPaymentBadge(item),
                ),
              ),
              const SizedBox(width: 8),

              // Estado del expediente
              SizedBox(
                width: 110,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhTerminationStatusChip(status: item.status),
                ),
              ),
              const SizedBox(width: 8),

              // Acciones: [Ver] y [⋯]
              SizedBox(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: widget.onTap,
                      icon: const Icon(Icons.visibility_outlined, size: 14),
                      label: const Text('Ver'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF38BDF8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        textStyle: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                      tooltip: 'Más opciones',
                      color: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFF334155)),
                      ),
                      onSelected: (val) {
                        switch (val) {
                          case 'edit':
                            widget.onEdit?.call();
                            break;
                          case 'start':
                            widget.onStartProcess?.call();
                            break;
                          case 'payment':
                            widget.onMarkPaymentCompleted?.call();
                            break;
                          case 'finalize':
                            widget.onFinalize?.call();
                            break;
                          case 'cancel':
                            widget.onCancel?.call();
                            break;
                          case 'delete':
                            widget.onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                        if (!isFinalizada && !isCancelada)
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: Color(0xFF38BDF8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Editar',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isRegistrada)
                          PopupMenuItem(
                            value: 'start',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow_outlined,
                                  size: 14,
                                  color: Color(0xFFF59E0B),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Iniciar proceso',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!item.paymentCompleted && !isCancelada)
                          PopupMenuItem(
                            value: 'payment',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Marcar pago completado',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isEnProceso)
                          PopupMenuItem(
                            value: 'finalize',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.task_alt,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Finalizar baja laboral',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!isFinalizada && !isCancelada)
                          PopupMenuItem(
                            value: 'cancel',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.block,
                                  size: 14,
                                  color: Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cancelar proceso',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isRegistrada)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_outline,
                                  size: 14,
                                  color: Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Eliminar registro',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBadge(RrhhTerminationRecord item) {
    if (item.paymentCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 11, color: Color(0xFF10B981)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Pagado',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (item.isPaymentExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFFEF4444).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 11,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Vencido',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    final days = item.daysUntilPaymentDeadline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            size: 11,
            color: Color(0xFFF59E0B),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              days >= 0 ? '$days d restantes' : 'Pendiente',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF59E0B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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

  String _fmt(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
