import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 3: Enlace Contable y Cierre de Nómina por partida doble y Centro de Costo.
class ElitePayrollAccountingTab extends ConsumerWidget {
  const ElitePayrollAccountingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(rrhhPayrollSummaryProvider);
    final entries = ref.watch(rrhhAccountingEntriesProvider);
    final payrollItems = ref.watch(rrhhPayrollProvider);

    // Totales de partida doble
    final totalDebit = entries.fold<double>(0.0, (sum, e) => sum + e.debit);
    final totalCredit = entries.fold<double>(0.0, (sum, e) => sum + e.credit);
    final isBalanced = (totalDebit - totalCredit).abs() < 0.01;

    // Desglose por Centro de Costo
    final Map<String, double> costCenterTotals = {};
    for (final item in payrollItems) {
      costCenterTotals[item.serviceLineCode] =
          (costCenterTotals[item.serviceLineCode] ?? 0.0) + item.totalEarned;
    }

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // =====================================================================
          // PANEL SUPERIOR: DISTRIBUCIÓN PRESUPUESTARIA POR CENTRO DE COSTO
          // =====================================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pie_chart_outline,
                      size: 15,
                      color: Color(0xFF0D9488),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Distribución de Costo Laboral por Centro de Costo (Octubre 2026)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: summary.isClosed
                            ? const Color(0xFFF0FDFA)
                            : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: summary.isClosed
                              ? const Color(0xFFCCFBF1)
                              : const Color(0xFFFEF3C7),
                        ),
                      ),
                      child: Text(
                        summary.status,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: summary.isClosed
                              ? const Color(0xFF0F766E)
                              : const Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Chips de Centros de Costo
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: costCenterTotals.entries.map((e) {
                      final percent = summary.grossPayroll > 0
                          ? (e.value / summary.grossPayroll * 100)
                          : 0.0;

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  'Bs. ${e.value.toStringAsFixed(2)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${percent.toStringAsFixed(1)}%)',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    color: const Color(0xFF0D9488),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // =====================================================================
          // TABLA DEL ASIENTO CONTABLE FULL-WIDTH EN TARJETA CORPORATIVA (EXPANDED)
          // =====================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x040F172A),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tableWidth = constraints.maxWidth < 950
                        ? 950.0
                        : constraints.maxWidth;
                    const horizMargin = 12.0;
                    final netColumnsWidth = tableWidth - (horizMargin * 2);

                    // Reparto proporcional 100% exacto
                    final colAccountCode = netColumnsWidth * 0.14;
                    final colAccountName = netColumnsWidth * 0.36;
                    final colCostCenter = netColumnsWidth * 0.18;
                    final colDebit = netColumnsWidth * 0.16;
                    final colCredit = netColumnsWidth * 0.16;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowHeight: 44.0,
                              dataRowMinHeight: 48.0,
                              dataRowMaxHeight: 52.0,
                              horizontalMargin: horizMargin,
                              columnSpacing: 0,
                              border: const TableBorder(
                                horizontalInside: BorderSide(
                                  color: Color(0xFFF1F5F9),
                                  width: 1,
                                ),
                              ),
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF8FAFC),
                              ),
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: colAccountCode,
                                    child: Text(
                                      'CÓDIGO DE CUENTA',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF475569),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: colAccountName,
                                    child: Text(
                                      'NOMBRE DE CUENTA CONTABLE',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF475569),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: colCostCenter,
                                    child: Text(
                                      'CENTRO DE COSTO',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF475569),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: colDebit,
                                    child: Text(
                                      'DEBE (BS)',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF475569),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: colCredit,
                                    child: Text(
                                      'HABER (BS)',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF475569),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: entries.map((e) {
                                return DataRow(
                                  cells: [
                                    // Código de Cuenta
                                    DataCell(
                                      SizedBox(
                                        width: colAccountCode,
                                        child: Text(
                                          e.accountCode,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Nombre de Cuenta
                                    DataCell(
                                      SizedBox(
                                        width: colAccountName,
                                        child: Text(
                                          e.accountName,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: const Color(0xFF334155),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),

                                    // Centro de Costo
                                    DataCell(
                                      SizedBox(
                                        width: colCostCenter,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 2.5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFE2E8F0),
                                              ),
                                            ),
                                            child: Text(
                                              e.costCenter,
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF334155),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Debe (Bs)
                                    DataCell(
                                      SizedBox(
                                        width: colDebit,
                                        child: Text(
                                          e.debit > 0
                                              ? e.debit.toStringAsFixed(2)
                                              : '--',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            fontWeight: e.debit > 0
                                                ? FontWeight.w700
                                                : FontWeight.normal,
                                            color: e.debit > 0
                                                ? const Color(0xFF0F172A)
                                                : const Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Haber (Bs)
                                    DataCell(
                                      SizedBox(
                                        width: colCredit,
                                        child: Text(
                                          e.credit > 0
                                              ? e.credit.toStringAsFixed(2)
                                              : '--',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            fontWeight: e.credit > 0
                                                ? FontWeight.w700
                                                : FontWeight.normal,
                                            color: e.credit > 0
                                                ? const Color(0xFF0F172A)
                                                : const Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                ),
              ),
            ),
          ),

          // =====================================================================
          // BARRA INFERIOR DE PARTIDA DOBLE Y ACCIÓN DE CIERRE (~44px)
          // =====================================================================
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                // Indicador de balance contable
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isBalanced
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isBalanced
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isBalanced
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        size: 13,
                        color: isBalanced
                            ? const Color(0xFF047857)
                            : const Color(0xFFB91C1C),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isBalanced
                            ? 'Partida Doble Cuadrada'
                            : 'Descuadre Contable Detectado',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isBalanced
                              ? const Color(0xFF047857)
                              : const Color(0xFFB91C1C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                Text(
                  'TOTAL DEBE: Bs. ${totalDebit.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'TOTAL HABER: Bs. ${totalCredit.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),

                const Spacer(),

                // Botón: Confirmar Cierre y Enviar a Contabilidad
                ElevatedButton.icon(
                  onPressed: summary.isClosed
                      ? null
                      : () {
                          ref
                              .read(rrhhPayrollSummaryProvider.notifier)
                              .closePeriod();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: const Color(0xFF0D9488),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Planilla de Octubre 2026 asentada exitosamente. Comprobante Contable: CT-2026-0003.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                  icon: Icon(
                    summary.isClosed
                        ? Icons.verified
                        : Icons.account_balance_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                  label: Text(
                    summary.isClosed
                        ? 'Cerrada (${summary.accountingVoucherNumber ?? "CT-2026-0003"})'
                        : 'Confirmar Cierre y Enviar a Contabilidad',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: summary.isClosed
                        ? const Color(0xFF64748B)
                        : const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
