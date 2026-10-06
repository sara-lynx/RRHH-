import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../extensions/rrhh_model_extensions.dart';
import 'rrhh_personal_status_chip.dart';
import 'rrhh_personal_table_constants.dart';

/// Fila individual para la tabla de Directorio de Personal.
/// Ancho fijo estricto según RrhhPersonalTableColumns, sin flex ni Expanded.
/// Estilo unificado con el directorio corporativo de Usuarios y CRM.
class RrhhPersonalTableRow extends StatefulWidget {
  final RrhhEmployeeSummaryDto employee;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onTerminate;
  final RrhhTableWidths widths;

  const RrhhPersonalTableRow({
    super.key,
    required this.employee,
    required this.onViewDetails,
    required this.onEdit,
    required this.onTerminate,
    this.widths = const RrhhTableWidths(),
  });

  @override
  State<RrhhPersonalTableRow> createState() => _RrhhPersonalTableRowState();
}

class _RrhhPersonalTableRowState extends State<RrhhPersonalTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.employee;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onViewDetails,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF1E293B).withValues(alpha: 0.35)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.widths.codigo,
                child: Text(
                  e.code,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              SizedBox(
                width: widget.widths.foto,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _getInitials(e.fullName),
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: widget.widths.nombre,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.fullName,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFF8FAFC),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Ingreso: ${_formatDate(e.realStartDate)}',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: widget.widths.tipo,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: e.isField
                          ? const Color(0xFF059669).withValues(alpha: 0.12)
                          : const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: e.isField
                            ? const Color(0xFF059669).withValues(alpha: 0.25)
                            : const Color(0xFF2563EB).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      e.employeeType,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: e.isField
                            ? const Color(0xFF10B981)
                            : const Color(0xFF60A5FA),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: widget.widths.areaCargo,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.position ?? '---',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFCBD5E1),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        e.area ?? '---',
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
              ),
              SizedBox(
                width: widget.widths.especialidad,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    e.specialty,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(
                width: widget.widths.disponibilidad,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RrhhPersonalStatusChip(status: e.availabilityStatus),
                ),
              ),
              SizedBox(
                width: widget.widths.expediente,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      e.hasCompleteDocs
                          ? Icons.check_circle_outline
                          : Icons.pending_actions_outlined,
                      size: 13,
                      color: e.hasCompleteDocs
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${e.attachedDocsCount}/6',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: e.hasCompleteDocs
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: widget.widths.acciones,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onViewDetails,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF94A3B8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Ver',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 15,
                        color: Color(0xFF64748B),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: const Color(0xFF0F172A),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: Color(0xFF94A3B8),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Editar Ficha',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'terminate',
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_off_outlined,
                                size: 14,
                                color: Color(0xFFEF4444),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Registrar Desvinculación',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (val) {
                        if (val == 'edit') widget.onEdit();
                        if (val == 'terminate') widget.onTerminate();
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.isNotEmpty && parts[0].isNotEmpty
        ? parts[0][0].toUpperCase()
        : 'EP';
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
