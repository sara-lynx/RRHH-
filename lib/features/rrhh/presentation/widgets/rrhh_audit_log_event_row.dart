import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_timeline_event.dart';
import 'rrhh_audit_category_chip.dart';

/// Fila individual para la tabla full-width de la Bitácora de Movimientos (Pantalla 14).
class RrhhAuditLogEventRow extends StatefulWidget {
  final RrhhTimelineEvent event;
  final bool isEven;
  final VoidCallback onTap;

  const RrhhAuditLogEventRow({
    super.key,
    required this.event,
    required this.isEven,
    required this.onTap,
  });

  @override
  State<RrhhAuditLogEventRow> createState() => _RrhhAuditLogEventRowState();
}

class _RrhhAuditLogEventRowState extends State<RrhhAuditLogEventRow> {
  bool _isHovered = false;

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'RH';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final dateStr = DateFormat('dd/MM/yyyy').format(e.date);
    final timeStr = DateFormat('HH:mm').format(e.date);

    final empName =
        e.employeeName ??
        (e.employeeId > 0 ? 'Colaborador #${e.employeeId}' : 'General');
    final empCode =
        e.employeeCode ??
        (e.employeeId > 0
            ? 'EMP-${e.employeeId.toString().padLeft(3, '0')}'
            : null);

    final changesCount = e.fieldChanges?.length ?? 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF1E293B).withValues(alpha: 0.65)
                : (widget.isEven
                      ? const Color(0xFF0F1523)
                      : const Color(0xFF0D111C)),
            border: const Border(
              bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. FECHA + HORA (flex: 12)
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.event_outlined,
                          size: 12,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        timeStr,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. USUARIO (flex: 15)
              Expanded(
                flex: 15,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: 0.2),
                      child: Text(
                        _getInitials(e.registeredBy),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            e.registeredBy,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF1F5F9),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            e.userRole ?? 'Responsable RRHH',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. CATEGORÍA (flex: 14)
              Expanded(
                flex: 14,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhAuditCategoryChip(category: e.category),
                ),
              ),

              // 4. EMPLEADO AFECTADO (flex: 16)
              Expanded(
                flex: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (empCode != null) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF334155),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              empCode,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF93C5FD),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              empName,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFE2E8F0),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        empName,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // 5. DESCRIPCIÓN (flex: 23)
              Expanded(
                flex: 23,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF8FAFC),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e.description,
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
              ),

              // 6. CAMBIOS (flex: 11)
              Expanded(
                flex: 11,
                child: changesCount > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.tune_rounded,
                              size: 12,
                              color: Color(0xFF60A5FA),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$changesCount ${changesCount == 1 ? 'cambio' : 'cambios'}',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF93C5FD),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (e.sourceCode != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e.sourceCode!,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            )
                          : Text(
                              '—',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            )),
              ),

              // 7. ACCIONES (flex: 9)
              Expanded(
                flex: 9,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: widget.onTap,
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 13,
                      color: Color(0xFF60A5FA),
                    ),
                    label: Text(
                      'Detalle',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF93C5FD),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 0.8,
                      ),
                      backgroundColor: const Color(
                        0xFF1E293B,
                      ).withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
