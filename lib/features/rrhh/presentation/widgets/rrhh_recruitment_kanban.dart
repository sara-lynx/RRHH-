import 'package:flutter/material.dart';

import '../../data/models/rrhh_applicant_summary_dto.dart';
import 'rrhh_recruitment_kanban_column.dart';

/// Reglas de negocio para las transiciones permitidas en el embudo de contratación.
class RrhhPipelineTransitionRules {
  static const List<String> _activeStages = [
    'NUEVO',
    'EN_REVISION',
    'ENTREVISTA',
    'PRUEBAS',
    'SELECCIONADO',
  ];

  static bool isAllowed(String fromStage, String toStage) {
    final from = fromStage.toUpperCase();
    final to = toStage.toUpperCase();
    if (from == to) return false;

    // Descarte a RECHAZADO permitido desde cualquier etapa (excepto ya rechazado o contratado)
    if (to == 'RECHAZADO') {
      return from != 'RECHAZADO' && from != 'CONTRATADO';
    }

    if (from == 'RECHAZADO' || from == 'CONTRATADO') {
      return false; // Rechazados requieren reactivación formal; Contratados están en nómina
    }

    final fromIndex = _activeStages.indexOf(from);
    final toIndex = _activeStages.indexOf(to);
    if (fromIndex == -1 || toIndex == -1) return false;

    // 1. RETROCESO / CORRECCIÓN DE ERROR:
    // Siempre permitido retroceder a cualquier etapa previa del embudo
    if (toIndex < fromIndex) {
      return true;
    }

    // 2. AVANCE EN EL PIPELINE (Secuencial y controlado):
    switch (from) {
      case 'NUEVO':
        return to == 'EN_REVISION';
      case 'EN_REVISION':
        return to == 'ENTREVISTA';
      case 'ENTREVISTA':
        return to == 'PRUEBAS' || to == 'SELECCIONADO';
      case 'PRUEBAS':
        return to == 'SELECCIONADO';
      case 'SELECCIONADO':
        return false; // El paso siguiente es la contratación formal vía asistente
      default:
        return false;
    }
  }

  static String getDisallowedReason(String fromStage, String toStage) {
    final from = fromStage.toUpperCase();
    final to = toStage.toUpperCase();
    if (from == 'RECHAZADO') {
      return 'Las candidaturas rechazadas deben reactivarse formalmente desde su expediente para registrar el motivo y auditoría.';
    }
    if (from == 'CONTRATADO') {
      return 'Un colaborador ya contratado forma parte de la nómina y no puede devolverse al embudo de postulantes.';
    }
    if (from == 'SELECCIONADO' && to != 'RECHAZADO') {
      return 'Para avanzar a un candidato Seleccionado debe iniciarse su contratación formal desde el botón del expediente.';
    }
    return 'Transición no permitida de $from a $to. No se pueden saltar etapas hacia adelante (el flujo es: Nuevo → En Revisión → Entrevista → Pruebas/Seleccionado).';
  }
}

/// Tablero Kanban con las 6 etapas del embudo de contratación de Elite Multiservicios.
/// 1. NUEVOS
/// 2. EN_REVISION
/// 3. ENTREVISTA
/// 4. PRUEBAS
/// 5. SELECCIONADOS
/// 6. RECHAZADOS
class RrhhRecruitmentKanban extends StatelessWidget {
  final List<RrhhApplicantSummaryDto> applicants;
  final void Function(RrhhApplicantSummaryDto applicant) onCardTap;
  final void Function(RrhhApplicantSummaryDto applicant, String targetStage)
  onApplicantDropped;

  const RrhhRecruitmentKanban({
    super.key,
    required this.applicants,
    required this.onCardTap,
    required this.onApplicantDropped,
  });

  @override
  Widget build(BuildContext context) {
    final nuevos = applicants
        .where((a) => a.status.toUpperCase() == 'NUEVO')
        .toList();
    final enRevision = applicants
        .where((a) => a.status.toUpperCase() == 'EN_REVISION')
        .toList();
    final entrevista = applicants
        .where((a) => a.status.toUpperCase() == 'ENTREVISTA')
        .toList();
    final pruebas = applicants
        .where((a) => a.status.toUpperCase() == 'PRUEBAS')
        .toList();
    final seleccionados = applicants
        .where((a) => a.status.toUpperCase() == 'SELECCIONADO')
        .toList();
    final rechazados = applicants
        .where((a) => a.status.toUpperCase() == 'RECHAZADO')
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double gap = 12.0;
        const double totalGaps = gap * 5; // 5 separaciones entre 6 columnas
        const double minColWidth = 250.0;
        const double maxColWidth = 340.0;
        final double calculatedColWidth =
            (constraints.maxWidth - totalGaps) / 6;
        final double colWidth = calculatedColWidth.clamp(
          minColWidth,
          maxColWidth,
        );
        final bool needsScroll =
            constraints.maxWidth < ((minColWidth * 6) + totalGaps);

        final kanbanRow = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RrhhRecruitmentKanbanColumn(
              stageTitle: '1. Nuevos',
              stageKey: 'NUEVO',
              stageColor: const Color(0xFF38BDF8),
              applicants: nuevos,
              width: colWidth,
              margin: const EdgeInsets.only(right: gap),
              onCardTap: onCardTap,
              onApplicantDropped: onApplicantDropped,
            ),
            RrhhRecruitmentKanbanColumn(
              stageTitle: '2. En Revisión',
              stageKey: 'EN_REVISION',
              stageColor: const Color(0xFF818CF8),
              applicants: enRevision,
              width: colWidth,
              margin: const EdgeInsets.only(right: gap),
              onCardTap: onCardTap,
              onApplicantDropped: onApplicantDropped,
            ),
            RrhhRecruitmentKanbanColumn(
              stageTitle: '3. Entrevista',
              stageKey: 'ENTREVISTA',
              stageColor: const Color(0xFFF59E0B),
              applicants: entrevista,
              width: colWidth,
              margin: const EdgeInsets.only(right: gap),
              onCardTap: onCardTap,
              onApplicantDropped: onApplicantDropped,
            ),
            RrhhRecruitmentKanbanColumn(
              stageTitle: '4. Pruebas',
              stageKey: 'PRUEBAS',
              stageColor: const Color(0xFFA855F7),
              applicants: pruebas,
              width: colWidth,
              margin: const EdgeInsets.only(right: gap),
              onCardTap: onCardTap,
              onApplicantDropped: onApplicantDropped,
            ),
            RrhhRecruitmentKanbanColumn(
              stageTitle: '5. Seleccionados',
              stageKey: 'SELECCIONADO',
              stageColor: const Color(0xFF10B981),
              applicants: seleccionados,
              width: colWidth,
              margin: const EdgeInsets.only(right: gap),
              onCardTap: onCardTap,
              onApplicantDropped: onApplicantDropped,
            ),
            RrhhRecruitmentKanbanColumn(
              stageTitle: '6. Rechazados',
              stageKey: 'RECHAZADO',
              stageColor: const Color(0xFFEF4444),
              applicants: rechazados,
              width: colWidth,
              margin: EdgeInsets.zero,
              onCardTap: onCardTap,
              onApplicantDropped: onApplicantDropped,
            ),
          ],
        );

        if (needsScroll) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: (minColWidth * 6) + totalGaps,
              child: kanbanRow,
            ),
          );
        }

        return kanbanRow;
      },
    );
  }
}
