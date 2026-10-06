import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_attendance_record.dart';
import 'rrhh_attendance_lateness_chip.dart';
import 'rrhh_attendance_status_chip.dart';

/// Fila individual de registro de asistencia de campo para la tabla full-width.
class RrhhAttendanceRecordRow extends StatefulWidget {
  final RrhhAttendanceRecord record;
  final bool isEven;
  final VoidCallback onTap;

  const RrhhAttendanceRecordRow({
    super.key,
    required this.record,
    required this.isEven,
    required this.onTap,
  });

  @override
  State<RrhhAttendanceRecordRow> createState() =>
      _RrhhAttendanceRecordRowState();
}

class _RrhhAttendanceRecordRowState extends State<RrhhAttendanceRecordRow> {
  bool _isHovered = false;

  String _formatTime(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.record;
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final dateStr = dateFormatter.format(r.date);

    final entryProg = _formatTime(r.scheduledEntry);
    final entryReal = r.actualEntry != null ? _formatTime(r.actualEntry!) : '—';

    final exitProg = _formatTime(r.scheduledExit);
    final exitReal = r.actualExit != null ? _formatTime(r.actualExit!) : '—';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                : (widget.isEven
                      ? const Color(0xFF0F1523)
                      : const Color(0xFF0D111C)),
            border: const Border(
              bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. FECHA (flex: 9)
              Expanded(
                flex: 9,
                child: Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),

              // 2. EMPLEADO (flex: 20)
              Expanded(
                flex: 20,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(
                        0xFF2563EB,
                      ).withValues(alpha: 0.25),
                      child: Text(
                        _getInitials(r.employeeName),
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
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
                            r.employeeName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            r.employeeCode,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. CLIENTE / SERVICIO (flex: 18)
              Expanded(
                flex: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      r.clientName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF1F5F9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      r.serviceName,
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

              // 4. SEDE (flex: 13)
              Expanded(
                flex: 13,
                child: Tooltip(
                  message: r.location,
                  child: Text(
                    r.location,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // 5. ENTRADA (PROG / REAL) (flex: 9)
              Expanded(
                flex: 9,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    children: [
                      TextSpan(text: '$entryProg / '),
                      TextSpan(
                        text: entryReal,
                        style: TextStyle(
                          color: r.isLate
                              ? const Color(0xFFFBBF24)
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. SALIDA (PROG / REAL) (flex: 9)
              Expanded(
                flex: 9,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    children: [
                      TextSpan(text: '$exitProg / '),
                      TextSpan(
                        text: exitReal,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 7. HORAS (flex: 7)
              Expanded(
                flex: 7,
                child: Text(
                  r.workedHours != null && r.workedHours! > 0
                      ? '${r.workedHours!.toStringAsFixed(1)}h'
                      : '—',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: r.workedHours != null && r.workedHours! > 0
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),

              // 8. TARDANZA (flex: 11)
              Expanded(
                flex: 11,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhAttendanceLatenessChip(
                    lateMinutes: r.lateMinutes,
                    isAbsent: r.isAbsent || r.isJustified,
                  ),
                ),
              ),

              // 9. ESTADO (flex: 11)
              Expanded(
                flex: 11,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhAttendanceStatusChip(status: r.status),
                ),
              ),

              // 10. OBSERVACIONES (flex: 18)
              Expanded(
                flex: 18,
                child: Tooltip(
                  message: r.incidents ?? 'Sin observaciones',
                  child: Text(
                    r.incidents ?? '—',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // 11. ACCIONES (flex: 7)
              Expanded(
                flex: 7,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: widget.onTap,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      side: const BorderSide(color: Color(0xFF334155)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 12,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ver',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return 'EM';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
