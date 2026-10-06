import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_summary_dto.dart';
import 'rrhh_recruitment_kanban.dart';
import 'rrhh_recruitment_kanban_card.dart';

/// Columna individual del Tablero Kanban de Reclutamiento.
/// Admite DragTarget para mover candidatos entre columnas y scroll vertical propio.
class RrhhRecruitmentKanbanColumn extends StatefulWidget {
  final String stageTitle;
  final String stageKey;
  final Color stageColor;
  final List<RrhhApplicantSummaryDto> applicants;
  final void Function(RrhhApplicantSummaryDto applicant) onCardTap;
  final void Function(RrhhApplicantSummaryDto applicant, String targetStage)
  onApplicantDropped;
  final double width;
  final EdgeInsetsGeometry margin;

  const RrhhRecruitmentKanbanColumn({
    super.key,
    required this.stageTitle,
    required this.stageKey,
    required this.stageColor,
    required this.applicants,
    required this.onCardTap,
    required this.onApplicantDropped,
    this.width = 300.0,
    this.margin = const EdgeInsets.only(right: 14),
  });

  @override
  State<RrhhRecruitmentKanbanColumn> createState() =>
      _RrhhRecruitmentKanbanColumnState();
}

class _RrhhRecruitmentKanbanColumnState
    extends State<RrhhRecruitmentKanbanColumn> {
  bool _isDragTargetActive = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<RrhhApplicantSummaryDto>(
      onWillAcceptWithDetails: (details) {
        final sameColumn = details.data.status.toUpperCase() == widget.stageKey;
        if (sameColumn) return false;

        final isAllowed = RrhhPipelineTransitionRules.isAllowed(
          details.data.status,
          widget.stageKey,
        );
        if (!isAllowed) return false;

        if (!_isDragTargetActive) {
          setState(() => _isDragTargetActive = true);
        }
        return true;
      },
      onLeave: (_) {
        if (_isDragTargetActive) {
          setState(() => _isDragTargetActive = false);
        }
      },
      onAcceptWithDetails: (details) {
        setState(() => _isDragTargetActive = false);
        widget.onApplicantDropped(details.data, widget.stageKey);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: widget.width,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isDragTargetActive
                  ? widget.stageColor
                  : const Color(0xFF1E293B),
              width: _isDragTargetActive ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildCardsList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: _isDragTargetActive
                ? widget.stageColor.withValues(alpha: 0.5)
                : const Color(0xFF1E293B),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: widget.stageColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.stageTitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF8FAFC),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${widget.applicants.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: widget.stageColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList() {
    if (widget.applicants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Sin candidatos en esta etapa',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: widget.applicants.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final applicant = widget.applicants[index];
        return RrhhRecruitmentKanbanCard(
          key: ValueKey('applicant_card_${applicant.id}'),
          applicant: applicant,
          onTap: () => widget.onCardTap(applicant),
        );
      },
    );
  }
}
