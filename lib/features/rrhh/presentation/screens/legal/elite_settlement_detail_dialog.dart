import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Visor Oficial de Finiquito Ministerial de Beneficios Sociales según la Ley General del Trabajo de Bolivia.
class EliteSettlementDetailDialog extends ConsumerWidget {
  final EliteTerminationSettlement settlement;

  const EliteSettlementDetailDialog({
    super.key,
    required this.settlement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hireStr =
        '${settlement.hireDate.day.toString().padLeft(2, '0')}/${settlement.hireDate.month.toString().padLeft(2, '0')}/${settlement.hireDate.year}';
    final termStr =
        '${settlement.terminationDate.day.toString().padLeft(2, '0')}/${settlement.terminationDate.month.toString().padLeft(2, '0')}/${settlement.terminationDate.year}';

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera del diálogo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF99F6E4)),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      size: 18,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FINIQUITO MINISTERIAL DE BENEFICIOS SOCIALES',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${settlement.id} • Formato Oficial LGT • Estado: ${settlement.status}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: settlement.isPaid
                          ? const Color(0xFFECFDF5)
                          : settlement.isApproved
                              ? const Color(0xFFEFF6FF)
                              : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: settlement.isPaid
                            ? const Color(0xFFA7F3D0)
                            : settlement.isApproved
                                ? const Color(0xFFDBEAFE)
                                : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Text(
                      settlement.status.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: settlement.isPaid
                            ? const Color(0xFF047857)
                            : settlement.isApproved
                                ? const Color(0xFF1E40AF)
                                : const Color(0xFFB45309),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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

            // Contenido escroleable del documento oficial
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Membrete oficial
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'ESTADO PLURINACIONAL DE BOLIVIA',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'MINISTERIO DE TRABAJO, EMPLEO Y PREVISIÓN SOCIAL',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'FINIQUITO DE LEY (Art. 13 LGT y D.S. 110)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 14),

                    // I. DATOS GENERALES DE LA EMPRESA Y EL TRABAJADOR
                    Text(
                      'I. DATOS DE LA EMPRESA Y DEL TRABAJADOR',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Razón Social:', 'ELITE MULTISERVICIOS S.R.L. (NIT: 3948201024)'),
                          const SizedBox(height: 4),
                          _buildDetailRow('Colaborador:', '${settlement.employeeName} (C.I. ${settlement.ci})'),
                          const SizedBox(height: 4),
                          _buildDetailRow('Cargo / Función:', '${settlement.position} • CC: ${settlement.serviceLineCode}'),
                          const SizedBox(height: 4),
                          _buildDetailRow('Fecha de Ingreso:', hireStr),
                          const SizedBox(height: 4),
                          _buildDetailRow('Fecha de Retiro:', termStr),
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            'Tiempo de Servicio:',
                            '${settlement.yearsWorked} año(s), ${settlement.monthsWorked} mes(es) y ${settlement.daysWorked} día(s)',
                          ),
                          const SizedBox(height: 4),
                          _buildDetailRow('Motivo de Retiro:', settlement.reason.label),
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            'Sueldo Promedio Indemnizable:',
                            'Bs. ${settlement.averageSalary.toStringAsFixed(2)} (Promedio últimos 3 meses)',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // II. LIQUIDACIÓN DE BENEFICIOS SOCIALES
                    Text(
                      'II. LIQUIDACIÓN DE BENEFICIOS SOCIALES (EN BOLIVIANOS)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildSettlementConceptRow(
                            '1. Desahucio (3 meses de sueldo en caso de despido intempestivo)',
                            settlement.severancePay,
                            isSubtle: settlement.severancePay == 0,
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          _buildSettlementConceptRow(
                            '2. Indemnización por tiempo de servicios (${settlement.yearsWorked} años + ${settlement.monthsWorked} meses)',
                            settlement.indemnityPay,
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          _buildSettlementConceptRow(
                            '3. Duodécimas de Aguinaldo de Navidad (gestión en curso)',
                            settlement.proportionalBonus,
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          _buildSettlementConceptRow(
                            '4. Compensación de Vacaciones no gozadas / proporcionales',
                            settlement.vacationPay,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Total Líquido a Pagar en Destacado Esmeralda
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF99F6E4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL LÍQUIDO PAGABLE AL TRABAJADOR',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F766E),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Beneficios sociales consolidados libres de descuentos fiscales',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Bs. ${settlement.totalSettlement.toStringAsFixed(2)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Declaración de conformidad legal
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        'DECLARACIÓN: Yo, ${settlement.employeeName}, declaro de forma libre y voluntaria haber recibido a mi entera conformidad el importe total detallado en el presente finiquito, no teniendo reclamo ni acción legal posterior de ninguna naturaleza contra Elite Multiservicios S.R.L.',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          height: 1.45,
                          color: const Color(0xFF475569),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Casillas de 3 firmas (Trabajador, Empresa, Inspector de Trabajo)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(height: 1, color: const Color(0xFF94A3B8)),
                              const SizedBox(height: 4),
                              Text(
                                settlement.employeeName,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Firma del Trabajador',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Container(height: 1, color: const Color(0xFF94A3B8)),
                              const SizedBox(height: 4),
                              Text(
                                'Paola A. Torrico Vaca',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'Elite Multiservicios S.R.L.',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Container(height: 1, color: const Color(0xFF94A3B8)),
                              const SizedBox(height: 4),
                              Text(
                                'Sello y Visado Ministerial',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                'Ministerio de Trabajo',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
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
            ),

            // Footer de botones
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
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF0F172A),
                          content: Text(
                            'Generando Finiquito Ministerial oficial de ${settlement.employeeName} en PDF reglamentario...',
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
                      'Imprimir Finiquito Oficial',
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

                  const Spacer(),

                  if (!settlement.isPaid) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        final nextStatus =
                            settlement.isApproved ? 'Pagado' : 'Aprobado';
                        ref
                            .read(rrhhSettlementsProvider.notifier)
                            .updateStatus(settlement.id, nextStatus);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF0D9488),
                            content: Text(
                              'Finiquito ${settlement.id} actualizado a estado: $nextStatus.',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        settlement.isApproved
                            ? Icons.verified_outlined
                            : Icons.check_circle_outline,
                        size: 15,
                      ),
                      label: Text(
                        settlement.isApproved
                            ? 'Marcar como Pagado'
                            : 'Aprobar Finiquito',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settlement.isApproved
                            ? const Color(0xFF047857)
                            : const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 0),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
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
                    child: Text(
                      'Cerrar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementConceptRow(
    String concept,
    double amount, {
    bool isSubtle = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      color: isSubtle ? const Color(0xFFF8FAFC) : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              concept,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSubtle ? FontWeight.w400 : FontWeight.w500,
                color: isSubtle
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF334155),
              ),
            ),
          ),
          Text(
            'Bs. ${amount.toStringAsFixed(2)}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSubtle
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
