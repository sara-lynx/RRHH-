import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_disciplinary_record.dart';
import 'rrhh_disciplinary_status_chip.dart';
import 'rrhh_fault_type_chip.dart';
import 'rrhh_sanction_type_chip.dart';

/// Fila individual de la tabla de Incidencias y Disciplina.
class RrhhDisciplinaryRecordRow extends StatefulWidget {
  final RrhhDisciplinaryRecord record;
  final VoidCallback onTap;
  final VoidCallback? onRegisterDischarge;
  final VoidCallback? onApplySanction;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const RrhhDisciplinaryRecordRow({
    super.key,
    required this.record,
    required this.onTap,
    this.onRegisterDischarge,
    this.onApplySanction,
    this.onArchive,
    this.onDelete,
  });

  @override
  State<RrhhDisciplinaryRecordRow> createState() =>
      _RrhhDisciplinaryRecordRowState();
}

class _RrhhDisciplinaryRecordRowState extends State<RrhhDisciplinaryRecordRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.record;
    final isRegistrada = item.status == RrhhDisciplinaryStatus.registrada;
    final isEnDescargo = item.status == RrhhDisciplinaryStatus.enDescargo;
    final canRegisterDischarge =
        (isRegistrada || isEnDescargo) &&
        item.requiresDischarge &&
        (item.dischargeText == null || item.dischargeText!.isEmpty);
    final canApplySanction =
        isEnDescargo || (isRegistrada && !item.requiresDischarge);
    final canArchive =
        item.status != RrhhDisciplinaryStatus.archivada &&
        item.status != RrhhDisciplinaryStatus.cerrada;

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
              // Código INC-XXX
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

              // Fecha del hecho
              SizedBox(
                width: 95,
                child: Text(
                  _fmt(item.incidentDate),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tipo de falta
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhFaultTypeChip(faultType: item.faultType),
                ),
              ),
              const SizedBox(width: 8),

              // Sanción
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhSanctionTypeChip(sanctionType: item.sanctionType),
                ),
              ),
              const SizedBox(width: 8),

              // Estado del proceso
              SizedBox(
                width: 115,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhDisciplinaryStatusChip(status: item.status),
                ),
              ),
              const SizedBox(width: 8),

              // Días suspendidos (si aplica)
              SizedBox(
                width: 85,
                child: Center(
                  child: item.suspensionDays != null && item.suspensionDays! > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF97316,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(
                                0xFFF97316,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '${item.suspensionDays}d',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF97316),
                            ),
                          ),
                        )
                      : Text(
                          '-',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF475569),
                          ),
                        ),
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
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFF334155)),
                      ),
                      onSelected: (action) {
                        switch (action) {
                          case 'detail':
                            widget.onTap();
                            break;
                          case 'discharge':
                            widget.onRegisterDischarge?.call();
                            break;
                          case 'sanction':
                            widget.onApplySanction?.call();
                            break;
                          case 'archive':
                            widget.onArchive?.call();
                            break;
                          case 'delete':
                            widget.onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (ctx) {
                        final items = <PopupMenuEntry<String>>[];

                        items.add(
                          PopupMenuItem(
                            value: 'detail',
                            height: 36,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 15,
                                  color: Color(0xFF38BDF8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ver detalle',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        if (canRegisterDischarge) {
                          items.add(
                            PopupMenuItem(
                              value: 'discharge',
                              height: 36,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.assignment_outlined,
                                    size: 15,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Registrar descargo',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (canApplySanction) {
                          items.add(
                            PopupMenuItem(
                              value: 'sanction',
                              height: 36,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.gavel_outlined,
                                    size: 15,
                                    color: Color(0xFFEF4444),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Aplicar sanción',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (canArchive) {
                          items.add(
                            PopupMenuItem(
                              value: 'archive',
                              height: 36,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.archive_outlined,
                                    size: 15,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Archivar',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (isRegistrada) {
                          items.add(const PopupMenuDivider(height: 8));
                          items.add(
                            PopupMenuItem(
                              value: 'delete',
                              height: 36,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    size: 15,
                                    color: Color(0xFFEF4444),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Eliminar',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
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

  String _fmt(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'EM';
    if (parts.length == 1)
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
