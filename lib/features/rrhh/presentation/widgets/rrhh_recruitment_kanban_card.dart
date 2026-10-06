import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_summary_dto.dart';

/// Tarjeta de candidato en el tablero Kanban de Reclutamiento.
/// Soporta drag & drop nativo y apertura de drawer lateral de evaluación al hacer clic.
class RrhhRecruitmentKanbanCard extends StatefulWidget {
  final RrhhApplicantSummaryDto applicant;
  final VoidCallback onTap;

  const RrhhRecruitmentKanbanCard({
    super.key,
    required this.applicant,
    required this.onTap,
  });

  @override
  State<RrhhRecruitmentKanbanCard> createState() =>
      _RrhhRecruitmentKanbanCardState();
}

class _RrhhRecruitmentKanbanCardState extends State<RrhhRecruitmentKanbanCard> {
  bool _isHovered = false;

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'P';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.applicant;

    return Draggable<RrhhApplicantSummaryDto>(
      data: a,
      rootOverlay: true,
      ignoringFeedbackSemantics: true,
      feedback: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 290,
            child: Opacity(
              opacity: 0.92,
              child: _buildCardUi(isHovered: true, isDragging: true),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: _buildCardUi(isDragging: true),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: _buildCardUi(isHovered: _isHovered),
        ),
      ),
    );
  }

  Widget _buildCardUi({bool isHovered = false, bool isDragging = false}) {
    final a = widget.applicant;
    final isCampo = a.targetType.toUpperCase() == 'CAMPO';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHovered ? const Color(0xFF141D30) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHovered
              ? const Color(0xFF38BDF8).withValues(alpha: 0.5)
              : const Color(0xFF1E293B),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.25 : 0.12),
            blurRadius: isHovered ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila Superior: Código y tipo (OFICINA / CAMPO)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                a.code,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (isCampo
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFFA78BFA))
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:
                        (isCampo
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFFA78BFA))
                            .withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  a.targetType.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isCampo
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFFA78BFA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Candidato: Avatar con iniciales + Nombre completo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                alignment: Alignment.center,
                child: Text(
                  _getInitials(a.fullName),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  a.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF8FAFC),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Cargo aspirado
          Text(
            a.targetPosition,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFE2E8F0),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Especialidad (si existe)
          if (a.specialty.isNotEmpty &&
              a.specialty.toLowerCase() != 'general') ...[
            const SizedBox(height: 2),
            Text(
              a.specialty,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF94A3B8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),

          // Separador sutil
          Container(
            height: 1,
            color: const Color(0xFF1E293B).withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),

          // Fila Inferior: Fecha de postulación e Indicador CV
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(a.applicationDate),
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              if (a.hasCv)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'CV ✓',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Sin CV',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
