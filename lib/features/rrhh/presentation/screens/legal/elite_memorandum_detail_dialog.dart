import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';

/// Modal formal de visualización de Memorándum Disciplinario Oficial de "Elite Multiservicios S.R.L.".
class EliteMemorandumDetailDialog extends StatelessWidget {
  final EliteDisciplinaryRecord record;

  const EliteMemorandumDetailDialog({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${record.date.day.toString().padLeft(2, '0')}/${record.date.month.toString().padLeft(2, '0')}/${record.date.year}';

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera institucional del diálogo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: record.severity.badgeBgColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: record.severity.badgeBorderColor),
                    ),
                    child: Icon(
                      Icons.gavel_outlined,
                      size: 18,
                      color: record.severity.badgeColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MEMORÁNDUM DISCIPLINARIO',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${record.memorandumCode} • Registro Legal Oficial',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 18),
                    color: const Color(0xFF64748B),
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Cuerpo del documento membretado
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Membrete formal de la empresa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ELITE MULTISERVICIOS S.R.L.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'NIT: 3948201024 • Santa Cruz de la Sierra, Bolivia',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            'Departamento de Recursos Humanos y Régimen Laboral',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: record.severity.badgeBgColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: record.severity.badgeBorderColor),
                        ),
                        child: Text(
                          'FALTA ${record.severity.label.toUpperCase()}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: record.severity.badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),

                  // Fila de Metadatos: A, DE, FECHA, REFERENCIA
                  _buildMetadataRow('A:', '${record.employeeName} (${record.employeeId})'),
                  const SizedBox(height: 6),
                  _buildMetadataRow('DE:', 'Lic. Paola Andrea Torrico Vaca — Jefatura de RRHH'),
                  const SizedBox(height: 6),
                  _buildMetadataRow('FECHA:', formattedDate),
                  const SizedBox(height: 6),
                  _buildMetadataRow('CENTRO DE COSTO:', '${record.serviceLineCode} • ${record.workplaceType.label}'),
                  const SizedBox(height: 6),
                  _buildMetadataRow('MOTIVO / FALTA:', record.infractionType),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),

                  // Descripción circunstanciada de los hechos
                  Text(
                    '1. ANTECEDENTES Y RELACIÓN DE LOS HECHOS:',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      record.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.5,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Sanción y marco regulatorio
                  Text(
                    '2. SANCIÓN DISCIPLINARIA IMPUESTA:',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            record.sanction,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF92400E),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bloque formal de firmas
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 1,
                              color: const Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Paola A. Torrico Vaca',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Jefe de Recursos Humanos',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 1,
                              color: const Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              record.employeeName,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Firma de Notificación del Colaborador',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pie de página de acciones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF0F172A),
                          content: Text(
                            'Enviando ${record.memorandumCode} a la impresora institucional...',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.print_outlined,
                      size: 15,
                      color: Color(0xFF475569),
                    ),
                    label: Text(
                      'Imprimir Copia Legal',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      'Cerrar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF475569),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
