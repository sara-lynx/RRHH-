import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_vacation.dart';
import 'rrhh_vacation_status_chip.dart';

/// Fila para la tabla de Historial de Goces de Vacaciones (Tab 2).
class RrhhVacationRecordRow extends StatelessWidget {
  final RrhhVacationRecord record;
  final bool isEven;
  final VoidCallback onView;
  final VoidCallback? onStart;
  final VoidCallback? onFinish;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  const RrhhVacationRecordRow({
    super.key,
    required this.record,
    required this.isEven,
    required this.onView,
    this.onStart,
    this.onFinish,
    this.onEdit,
    this.onCancel,
    this.onDelete,
  });

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isProgramado = record.status == RrhhVacationRecordStatus.programado;
    final isEnCurso = record.status == RrhhVacationRecordStatus.enCurso;
    final isCancelado = record.status == RrhhVacationRecordStatus.cancelado;

    return Container(
      decoration: BoxDecoration(
        color: isEven
            ? const Color(0xFF0F172A)
            : const Color(0xFF0B132B).withValues(alpha: 0.5),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 1. Código (VAC-XXX) - 10%
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    record.code,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF60A5FA),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Empleado (Avatar + Nombre + Código EMP-XXX) - 22%
          Expanded(
            flex: 22,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(
                    0xFF10B981,
                  ).withValues(alpha: 0.15),
                  child: Text(
                    record.employeeName.isNotEmpty
                        ? record.employeeName[0].toUpperCase()
                        : 'E',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF34D399),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        record.employeeName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record.employeeCode,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Período (desde → hasta) - 20%
          Expanded(
            flex: 20,
            child: Row(
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  size: 15,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${_formatDate(record.startDate)} → ${_formatDate(record.endDate)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFCBD5E1),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 4. Días computados - 10%
          Expanded(
            flex: 10,
            child: Text(
              '${record.daysCounted} días',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF38BDF8),
              ),
            ),
          ),

          // 5. Modo de cálculo - 12%
          Expanded(
            flex: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    record.countingMode == 'habiles' ? 'Hábiles' : 'Calendario',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Estado del goce - 14%
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RrhhVacationStatusChip(status: record.status),
            ),
          ),

          // 7. Acciones: [Ver] + [⋯] - 12%
          Expanded(
            flex: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onView,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF60A5FA),
                    side: BorderSide(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Ver',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                  color: const Color(0xFF0F172A),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF1E293B)),
                  ),
                  onSelected: (val) {
                    if (val == 'start') onStart?.call();
                    if (val == 'finish') onFinish?.call();
                    if (val == 'edit') onEdit?.call();
                    if (val == 'cancel') onCancel?.call();
                    if (val == 'delete') onDelete?.call();
                  },
                  itemBuilder: (ctx) => [
                    if (isProgramado) ...[
                      PopupMenuItem(
                        value: 'start',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Iniciar goce',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Color(0xFF38BDF8),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Editar período',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'cancel',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.block_outlined,
                              size: 16,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Cancelar',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Eliminar',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isEnCurso) ...[
                      PopupMenuItem(
                        value: 'finish',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Finalizar goce',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'cancel',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.block_outlined,
                              size: 16,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Cancelar goce',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isCancelado) ...[
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Eliminar registro',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
