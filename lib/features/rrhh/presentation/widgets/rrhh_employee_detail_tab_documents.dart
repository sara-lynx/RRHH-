import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab 3: Documentación Física y Checklist de Ley (6 Documentos Requeridos).
/// Incluye alerta crítica para personal de seguridad sin certificado FELCC.
class RrhhEmployeeDetailTabDocuments extends StatelessWidget {
  final RrhhEmployee employee;
  final List<RrhhEmployeeDocument> documents;

  const RrhhEmployeeDetailTabDocuments({
    super.key,
    required this.employee,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    final requiredDocs = [
      _DocItem(
        'CI',
        'Fotocopia Cédula de Identidad Vigente',
        employee.hasCiCopy,
      ),
      _DocItem(
        'FELCC',
        'Certificado de Antecedentes FELCC',
        employee.hasFelccRecord,
        isSecurityCritical: true,
      ),
      _DocItem(
        'AVISO_LUZ_AGUA',
        'Factura de Luz o Agua (Domicilio)',
        employee.hasUtilityBill,
      ),
      _DocItem(
        'CROQUIS',
        'Croquis de Ubicación Domiciliaria',
        employee.hasHomeSketch,
      ),
      _DocItem(
        'FOTO',
        'Fotografía 3x4 Fondo Rojo Institucional',
        employee.hasPhoto3x4,
      ),
      _DocItem(
        'SEGURO_SUS',
        'Constancia de Afiliación Seguro SUS',
        employee.hasSusInsurance,
      ),
    ];

    final completedCount = requiredDocs.where((d) => d.isComplete).length;
    final isSecurityRole =
        employee.area.toLowerCase().contains('seguridad') ||
        employee.position.toLowerCase().contains('guardia') ||
        employee.specialty.toLowerCase().contains('seguridad');
    final showSecurityAlert = isSecurityRole && !employee.hasFelccRecord;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showSecurityAlert) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ALERTA: FALTA ANTECEDENTES FELCC EN SEGURIDAD',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                        Text(
                          'El colaborador está catalogado en Seguridad física, pero no cuenta con antecedentes policiales homologados.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFFFCA5A5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          _buildProgressIndicator(completedCount, requiredDocs.length),
          const SizedBox(height: 18),
          _buildSectionHeader('CHECKLIST DE EXPEDIENTE FÍSICO (6 DE LEY)'),
          const SizedBox(height: 10),
          ...requiredDocs.map((item) {
            final matchingDoc = documents
                .cast<RrhhEmployeeDocument?>()
                .firstWhere(
                  (d) =>
                      d?.documentType.toUpperCase() == item.type.toUpperCase(),
                  orElse: () => null,
                );
            return _buildDocumentRow(context, item, matchingDoc);
          }),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int count, int total) {
    final progress = count / total;
    final statusColor = count == total
        ? const Color(0xFF10B981)
        : (count >= 4 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));
    final statusText = count == total
        ? 'Expediente completo y al día ($count de $total)'
        : (count >= 4
              ? 'Expediente parcial en regularización ($count de $total)'
              : 'Expediente deficiente ($count de $total)');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              Text(
                '$count / $total Documentos',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(
    BuildContext context,
    _DocItem item,
    RrhhEmployeeDocument? doc,
  ) {
    final hasFile = doc != null && doc.fileUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isComplete
              ? const Color(0xFF1E293B)
              : (item.isSecurityCritical
                    ? const Color(0xFFEF4444).withValues(alpha: 0.35)
                    : const Color(0xFF1E293B)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            item.isComplete ? Icons.check_circle : Icons.cancel_outlined,
            size: 18,
            color: item.isComplete
                ? const Color(0xFF10B981)
                : (item.isSecurityCritical
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF64748B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: item.isComplete
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                Text(
                  item.isComplete
                      ? (doc != null
                            ? 'Verificado en archivo físico • ${doc.fileName}'
                            : 'Verificado en archivo físico')
                      : 'Pendiente de entrega por el trabajador',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: item.isComplete
                        ? const Color(0xFF64748B)
                        : (item.isSecurityCritical
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          if (hasFile)
            OutlinedButton.icon(
              onPressed: () {
                RrhhSnackBar.showInfo(
                  context,
                  'Visualizando documento: ${doc.fileName}',
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF60A5FA),
                side: const BorderSide(color: Color(0xFF334155)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.visibility_outlined, size: 13),
              label: Text(
                'Ver',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              item.isComplete ? 'Físico' : 'Faltante',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: item.isComplete
                    ? const Color(0xFF64748B)
                    : const Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

class _DocItem {
  final String type;
  final String name;
  final bool isComplete;
  final bool isSecurityCritical;

  const _DocItem(
    this.type,
    this.name,
    this.isComplete, {
    this.isSecurityCritical = false,
  });
}
