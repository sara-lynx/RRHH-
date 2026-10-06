import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_leave_request.dart';
import 'rrhh_leave_status_chip.dart';
import 'rrhh_leave_type_chip.dart';

/// Fila individual de la tabla de Permisos y Licencias.
class RrhhLeaveRequestRow extends StatefulWidget {
  final RrhhLeaveRequest request;
  final VoidCallback onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RrhhLeaveRequestRow({
    super.key,
    required this.request,
    required this.onTap,
    this.onApprove,
    this.onReject,
    this.onCancel,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<RrhhLeaveRequestRow> createState() => _RrhhLeaveRequestRowState();
}

class _RrhhLeaveRequestRowState extends State<RrhhLeaveRequestRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final isPendiente = req.status == RrhhLeaveStatus.pendiente;
    final isAprobado = req.status == RrhhLeaveStatus.aprobado;

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
              // Código PERM-XXX
              SizedBox(
                width: 95,
                child: Text(
                  req.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Empleado (Avatar + Nombre + Código)
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
                        _getInitials(req.employeeName),
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
                            req.employeeName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF8FAFC),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            req.employeeCode,
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

              // Tipo de Permiso
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhLeaveTypeChip(leaveType: req.leaveType),
                ),
              ),
              const SizedBox(width: 8),

              // Período (Desde → Hasta)
              SizedBox(
                width: 170,
                child: Text(
                  '${_fmt(req.startDate)} → ${_fmt(req.endDate)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Duración
              SizedBox(
                width: 80,
                child: Text(
                  '${req.durationDays} ${req.durationDays == 1 ? 'día' : 'días'}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ¿Pagado? (Chip Goce / Sin Goce)
              SizedBox(
                width: 95,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: req.isPaid
                          ? const Color(0xFF10B981).withValues(alpha: 0.12)
                          : const Color(0xFF64748B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: req.isPaid
                            ? const Color(0xFF10B981).withValues(alpha: 0.3)
                            : const Color(0xFF64748B).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      req.isPaid ? 'Pagado' : 'Sin goce',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: req.isPaid
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Estado
              SizedBox(
                width: 115,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhLeaveStatusChip(status: req.status),
                ),
              ),
              const SizedBox(width: 8),

              // Acciones: [Ver] y [⋯]
              SizedBox(
                width: 110,
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
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFF334155)),
                      ),
                      onSelected: (action) {
                        switch (action) {
                          case 'approve':
                            widget.onApprove?.call();
                            break;
                          case 'reject':
                            widget.onReject?.call();
                            break;
                          case 'cancel':
                            widget.onCancel?.call();
                            break;
                          case 'edit':
                            widget.onEdit?.call();
                            break;
                          case 'delete':
                            widget.onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (ctx) {
                        final items = <PopupMenuEntry<String>>[];

                        if (isPendiente) {
                          items.addAll([
                            PopupMenuItem(
                              value: 'approve',
                              child: _menuItem(
                                Icons.check_circle_outline,
                                'Aprobar permiso',
                                const Color(0xFF10B981),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'reject',
                              child: _menuItem(
                                Icons.cancel_outlined,
                                'Rechazar permiso',
                                const Color(0xFFEF4444),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: _menuItem(
                                Icons.edit_outlined,
                                'Editar solicitud',
                                const Color(0xFF38BDF8),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'cancel',
                              child: _menuItem(
                                Icons.block_outlined,
                                'Cancelar solicitud',
                                const Color(0xFFF59E0B),
                              ),
                            ),
                            const PopupMenuDivider(height: 1),
                            PopupMenuItem(
                              value: 'delete',
                              child: _menuItem(
                                Icons.delete_outline,
                                'Eliminar registro',
                                const Color(0xFFEF4444),
                              ),
                            ),
                          ]);
                        } else if (isAprobado) {
                          // Se puede cancelar si la fecha de inicio es futura
                          items.add(
                            PopupMenuItem(
                              value: 'cancel',
                              child: _menuItem(
                                Icons.block_outlined,
                                'Cancelar permiso',
                                const Color(0xFFF59E0B),
                              ),
                            ),
                          );
                        } else {
                          items.add(
                            PopupMenuItem(
                              enabled: false,
                              child: Text(
                                'Sin acciones disponibles',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          );
                        }

                        return items;
                      },
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

  Widget _menuItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _fmt(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'EM';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
