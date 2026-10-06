import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modal que alerta sobre postulaciones previas asociadas a la misma cédula de identidad (CI).
/// Permite revisar el historial de candidaturas y decidir si se procede con un nuevo registro.
class RrhhDuplicateApplicantDialog extends StatelessWidget {
  final String identityCard;
  final List<RrhhApplicant> existingApplicants;

  const RrhhDuplicateApplicantDialog({
    super.key,
    required this.identityCard,
    required this.existingApplicants,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String identityCard,
    required List<RrhhApplicant> existingApplicants,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhDuplicateApplicantDialog(
        identityCard: identityCard,
        existingApplicants: existingApplicants,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.history_edu_outlined,
                      color: Color(0xFFF59E0B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Candidato con Postulaciones Previas',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'El CI $identityCard ya figura en el sistema con el siguiente historial:',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Lista de postulaciones anteriores
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: existingApplicants.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final app = existingApplicants[index];
                    return _buildApplicantHistoryCard(app);
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Advertencia de negocio
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF38BDF8),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Si continuas, se registrará una NUEVA postulación vinculada al historial previo para auditoría.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF94A3B8),
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancelar Registro',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.add_task, size: 16),
                    label: Text(
                      'Continuar con nuevo POST',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantHistoryCard(RrhhApplicant app) {
    Color statusColor;
    String statusLabel;
    switch (app.status.toUpperCase()) {
      case 'NUEVO':
        statusColor = const Color(0xFF38BDF8);
        statusLabel = 'NUEVO';
        break;
      case 'EN_REVISION':
        statusColor = const Color(0xFF818CF8);
        statusLabel = 'EN REVISIÓN';
        break;
      case 'ENTREVISTA':
        statusColor = const Color(0xFFF59E0B);
        statusLabel = 'ENTREVISTA';
        break;
      case 'PRUEBAS':
        statusColor = const Color(0xFFA855F7);
        statusLabel = 'PRUEBAS';
        break;
      case 'SELECCIONADO':
        statusColor = const Color(0xFF10B981);
        statusLabel = 'SELECCIONADO';
        break;
      case 'CONTRATADO':
        statusColor = const Color(0xFF059669);
        statusLabel = 'CONTRATADO';
        break;
      case 'RECHAZADO':
      default:
        statusColor = const Color(0xFFEF4444);
        statusLabel = 'RECHAZADO';
    }

    final dateStr =
        '${app.applicationDate.day.toString().padLeft(2, '0')}/${app.applicationDate.month.toString().padLeft(2, '0')}/${app.applicationDate.year}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    app.code,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•  $dateStr',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${app.targetPosition ?? 'Cargo'} (${app.targetType}) • ${app.targetArea}',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFE2E8F0),
            ),
          ),
          if (app.discardReason != null &&
              app.discardReason!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFEF4444),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Motivo de rechazo: ${app.discardReason}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFFFCA5A5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
