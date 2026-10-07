import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import '../../widgets/elite_searchable_select.dart';

/// Tab 2: Visor de Boletas de Pago Formales individuales conforme a Ley Boliviana.
class ElitePaySlipsTab extends ConsumerWidget {
  const ElitePaySlipsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payrollItems = ref.watch(rrhhPayrollProvider);
    final selectedEmpId = ref.watch(selectedPaySlipEmployeeIdProvider);

    final currentItem = payrollItems.firstWhere(
      (p) => p.employeeId == selectedEmpId,
      orElse: () => payrollItems.first,
    );

    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        // =====================================================================
        // SELECTOR SUPERIOR COMPACTO DE COLABORADOR (~46px)
        // =====================================================================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            children: [
              Text(
                'COLABORADOR:',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 10),

              // Selector con buscador integrado (100% Light Mode)
              SizedBox(
                width: 360,
                child: EliteSearchableSelect<ElitePayrollItem>(
                  value: currentItem,
                  items: payrollItems,
                  placeholder: 'Seleccione un colaborador...',
                  searchPlaceholder:
                      'Escriba para filtrar por nombre, CI o Centro de Costo...',
                  itemTitle: (item) => item.employeeName,
                  itemSubtitle: (item) => '${item.ci} • ${item.position}',
                  itemCostCenter: (item) => item.serviceLineCode,
                  onChanged: (item) {
                    if (item != null) {
                      ref
                          .read(selectedPaySlipEmployeeIdProvider.notifier)
                          .selectEmployee(item.employeeId);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Chip de Centro de Costo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  currentItem.serviceLineCode,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),

              const Spacer(),

              // Botón Imprimir / PDF
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      backgroundColor: const Color(0xFF0F172A),
                      content: Text(
                        'Generando documento PDF de Boleta de Pago de ${currentItem.employeeName}...',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.print_outlined,
                  size: 14,
                  color: Color(0xFF334155),
                ),
                label: Text(
                  'Imprimir Boleta',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 0),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ),
        ),

        // =====================================================================
        // VISOR DE BOLETA FORMAL EN EXPANDED (80% DEL ESPACIO)
        // =====================================================================
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Membrete Corporativo
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'NIT: 1028475028 • Registro Min. Trabajo: 04-2022-ELT • Santa Cruz, Bolivia',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'BOLETA DE PAGO • OCTUBRE 2026',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2. Datos del Trabajador
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildWorkerDataField(
                                  'TRABAJADOR',
                                  currentItem.employeeName,
                                ),
                                _buildWorkerDataField(
                                  'C.I. / DOCUMENTO',
                                  currentItem.ci,
                                ),
                                _buildWorkerDataField(
                                  'CÓDIGO EMPLEADO',
                                  currentItem.employeeId,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildWorkerDataField(
                                  'CARGO / PUESTO',
                                  currentItem.position,
                                ),
                                _buildWorkerDataField(
                                  'CENTRO DE COSTO',
                                  currentItem.serviceLineCode,
                                ),
                                _buildWorkerDataField(
                                  'CUENTA BANCARIA',
                                  currentItem.bankAccount,
                                ),
                              ],
                            ),
                            if (currentItem.hireDate != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildWorkerDataField(
                                    'FECHA DE INGRESO',
                                    dateFormat.format(currentItem.hireDate!),
                                  ),
                                  _buildWorkerDataField(
                                    'RÉGIMEN LABORAL',
                                    'Ley General del Trabajo (LGT)',
                                  ),
                                  _buildWorkerDataField(
                                    'PERÍODO DE PAGO',
                                    '01/10/2026 - 31/10/2026 (30 días)',
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: Color(0xFFCBD5E1)),

                      // 3. Dos Columnas Simétricas: INGRESOS vs DESCUENTOS
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Columna 1: INGRESOS (Haber Básico + Bono Antigüedad)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.add_circle_outline,
                                          size: 15,
                                          color: Color(0xFF0D9488),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'INGRESOS Y HABERES',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildMoneyRow(
                                      'Haber Básico Mensual',
                                      currentItem.baseSalary,
                                    ),
                                    const SizedBox(height: 8),
                                    _buildMoneyRow(
                                      'Bono de Antigüedad (LGT)',
                                      currentItem.seniorityBonus,
                                    ),
                                    const Divider(
                                      height: 20,
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    _buildMoneyRow(
                                      'TOTAL GANADO (BRUTO)',
                                      currentItem.totalEarned,
                                      isBold: true,
                                      textColor: const Color(0xFF0F172A),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Columna 2: DESCUENTOS (Gestora + Multas)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.remove_circle_outline,
                                          size: 15,
                                          color: Color(0xFFDC2626),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'DESCUENTOS Y DEDUCCIONES',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildMoneyRow(
                                      'Aporte Laboral Gestora (12.71%)',
                                      currentItem.gestoraDeduction,
                                    ),
                                    const SizedBox(height: 8),
                                    _buildMoneyRow(
                                      'Descuento Tardanzas / Faltas',
                                      currentItem.penaltyDeductions,
                                      textColor: currentItem.penaltyDeductions > 0
                                          ? const Color(0xFFDC2626)
                                          : null,
                                    ),
                                    const Divider(
                                      height: 20,
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    _buildMoneyRow(
                                      'TOTAL DESCUENTOS',
                                      currentItem.totalDeductions,
                                      isBold: true,
                                      textColor: const Color(0xFFB91C1C),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. Bloque Central: Líquido Pagable
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCCFBF1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LÍQUIDO PAGABLE A PERCIBIR',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0F766E),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  'Importe neto transferido a cuenta bancaria del trabajador',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: const Color(0xFF0D9488),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Bs. ${currentItem.netPayable.toStringAsFixed(2)}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F766E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 5. Bloque de Firmas Ejecutivas
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        child: Row(
                          children: [
                            // Firma del Trabajador
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: 1,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'FIRMA DEL TRABAJADOR',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  Text(
                                    currentItem.employeeName,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'C.I.: ${currentItem.ci}',
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 80),

                            // Firma del Empleador
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: 1,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'FIRMA Y SELLO EMPLEADOR',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  Text(
                                    'Elite Multiservicios S.R.L.',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'Gerencia General / RRHH',
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerDataField(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyRow(
    String label,
    double amount, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: textColor ?? const Color(0xFF475569),
          ),
        ),
        Text(
          'Bs. ${amount.toStringAsFixed(2)}',
          style: GoogleFonts.jetBrainsMono(
            fontSize: isBold ? 12.5 : 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: textColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
