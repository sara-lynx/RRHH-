import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 2: Tardanzas, Faltas Injustificadas y Penalizaciones acumuladas en Bs.
class ElitePenaltiesTab extends ConsumerStatefulWidget {
  const ElitePenaltiesTab({super.key});

  @override
  ConsumerState<ElitePenaltiesTab> createState() => _ElitePenaltiesTabState();
}

class _ElitePenaltiesTabState extends ConsumerState<ElitePenaltiesTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPenalties = ref.watch(rrhhFilteredPenaltiesProvider);
    final costCenterFilter = ref.watch(penaltyCostCenterFilterProvider);

    final totalDeductions = filteredPenalties.fold<double>(
      0.0,
      (sum, p) => sum + p.penaltyAmountBs,
    );
    final totalLateMins = filteredPenalties.fold<int>(
      0,
      (sum, p) => sum + p.totalLateMinutes,
    );
    final totalAbsences = filteredPenalties.fold<int>(
      0,
      (sum, p) => sum + p.unexcusedAbsences,
    );

    return Column(
      children: [
        // =====================================================================
        // BARRA DE FILTROS SUPERIOR COMPACTA (~46px)
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
              // Buscador de texto
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref
                          .read(penaltySearchQueryProvider.notifier)
                          .setQuery(val);
                    },
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Buscar colaborador, cargo o ID...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 14),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(penaltySearchQueryProvider.notifier)
                                    .setQuery('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Color(0xFF0D9488),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Selector: Centro de Costo
              SizedBox(
                height: 32,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: costCenterFilter,
                      icon: const Icon(
                        Icons.apartment_outlined,
                        size: 15,
                        color: Color(0xFF64748B),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                      onChanged: (val) {
                        ref
                            .read(penaltyCostCenterFilterProvider.notifier)
                            .setFilter(val);
                      },
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Centro Costo: Todos'),
                        ),
                        ...EliteCostCenter.all.map((cc) {
                          return DropdownMenuItem(
                            value: cc,
                            child: Text(cc),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Botón Limpiar filtros
              if (costCenterFilter != null ||
                  _searchController.text.isNotEmpty)
                IconButton(
                  tooltip: 'Limpiar filtros',
                  icon: const Icon(
                    Icons.filter_alt_off_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(penaltySearchQueryProvider.notifier)
                        .setQuery('');
                    ref
                        .read(penaltyCostCenterFilterProvider.notifier)
                        .setFilter(null);
                  },
                ),

              const Spacer(),

              // Badge Informativo del Periodo
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Período Nómina: Octubre 2026',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // =====================================================================
        // TABLA DE PENALIZACIONES EN EXPANDED (80% DEL ESPACIO)
        // =====================================================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x040F172A),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tableWidth = constraints.maxWidth < 1180
                      ? 1180.0
                      : constraints.maxWidth;

                  const colSpacing = 12.0;
                  const horizMargin = 16.0;
                  const spacingAndMargins = (colSpacing * (9 - 1)) + (horizMargin * 2);
                  final netColumnsWidth = tableWidth - spacingAndMargins;

                  // Distribución proporcional exacta al 100%
                  final colWorker = netColumnsWidth * 0.20;
                  final colPosition = netColumnsWidth * 0.14;
                  final colCostCenter = netColumnsWidth * 0.08;
                  final colType = netColumnsWidth * 0.08;
                  final colLate = netColumnsWidth * 0.09;
                  final colAbsences = netColumnsWidth * 0.07;
                  final colDiscount = netColumnsWidth * 0.11;
                  final colStatus = netColumnsWidth * 0.13;
                  final colActions = netColumnsWidth * 0.10;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowHeight: 46,
                          dataRowMinHeight: 52,
                          dataRowMaxHeight: 56,
                          horizontalMargin: horizMargin,
                          columnSpacing: colSpacing,
                          headingRowColor: const WidgetStatePropertyAll(
                            Color(0xFFF8FAFC),
                          ),
                          border: const TableBorder(
                            horizontalInside: BorderSide(
                              color: Color(0xFFF1F5F9),
                              width: 1.0,
                            ),
                          ),
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: colWorker,
                                child: Text(
                                  'COLABORADOR',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colPosition,
                                child: Text(
                                  'CARGO / PUESTO',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colCostCenter,
                                child: Text(
                                  'CENTRO COSTO',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colType,
                                child: Text(
                                  'TIPO',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colLate,
                                child: Text(
                                  'RETRASO ACUM.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colAbsences,
                                child: Text(
                                  'FALTAS',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colDiscount,
                                child: Text(
                                  'DESCUENTO (BS)',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colStatus,
                                child: Text(
                                  'ESTADO DEDUCCIÓN',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: colActions,
                                child: Text(
                                  'ACCIONES',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: filteredPenalties.map((pen) {
                            final hasPenalty = pen.penaltyAmountBs > 0;
                            final isField = pen.workplaceType == EmployeeWorkplaceType.campo;

                            return DataRow(
                              cells: [
                                // Colaborador
                                DataCell(
                                  SizedBox(
                                    width: colWorker,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: isField
                                              ? const Color(0xFFCCFBF1)
                                              : const Color(0xFFE0F2FE),
                                          child: Text(
                                            _getInitials(pen.employeeName),
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: isField
                                                  ? const Color(0xFF0F766E)
                                                  : const Color(0xFF0369A1),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pen.employeeName,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF0F172A),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${pen.id} • ${pen.employeeId}',
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
                                      ],
                                    ),
                                  ),
                                ),

                                // Cargo
                                DataCell(
                                  SizedBox(
                                    width: colPosition,
                                    child: Text(
                                      pen.employeeJobTitle,
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

                                // Centro Costo
                                DataCell(
                                  SizedBox(
                                    width: colCostCenter,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          pen.serviceLineCode,
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

                                // Tipo
                                DataCell(
                                  SizedBox(
                                    width: colType,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: pen.workplaceType.badgeBgColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          pen.workplaceType.label,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: pen.workplaceType.badgeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Minutos Retraso
                                DataCell(
                                  SizedBox(
                                    width: colLate,
                                    child: Text(
                                      pen.totalLateMinutes > 0
                                          ? '${pen.totalLateMinutes} min'
                                          : '0 min',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: pen.totalLateMinutes > 0
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ),
                                ),

                                // Faltas Injustificadas
                                DataCell(
                                  SizedBox(
                                    width: colAbsences,
                                    child: Text(
                                      pen.unexcusedAbsences > 0
                                          ? '${pen.unexcusedAbsences} día${pen.unexcusedAbsences > 1 ? "s" : ""}'
                                          : '0',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: pen.unexcusedAbsences > 0
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),

                                // Descuento en Bs
                                DataCell(
                                  SizedBox(
                                    width: colDiscount,
                                    child: Text(
                                      'Bs. ${pen.penaltyAmountBs.toStringAsFixed(2)}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: hasPenalty
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ),
                                ),

                                // Estado Deducción
                                DataCell(
                                  SizedBox(
                                    width: colStatus,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 3.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: hasPenalty
                                              ? const Color(0xFFFFFBEB)
                                              : const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          hasPenalty
                                              ? pen.status
                                              : 'Sin Penalización',
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: hasPenalty
                                                ? const Color(0xFFB45309)
                                                : const Color(0xFF047857),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Acciones
                                DataCell(
                                  SizedBox(
                                    width: colActions,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              behavior: SnackBarBehavior.floating,
                                              margin: const EdgeInsets.all(16),
                                              backgroundColor: const Color(0xFF0F172A),
                                              content: Text(
                                                'Auditoría de marcaciones de ${pen.employeeName}: ${pen.totalLateMinutes} min retraso, ${pen.unexcusedAbsences} faltas. Descuento calculado: Bs. ${pen.penaltyAmountBs.toStringAsFixed(2)}.',
                                                style: GoogleFonts.inter(fontSize: 12),
                                              ),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Color(0xFFE2E8F0),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 0,
                                          ),
                                          minimumSize: const Size(0, 28),
                                        ),
                                        child: Text(
                                          'Auditar',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
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
        // BARRA FIJA AL PIE CON TOTALIZADOR EN BS (~38px)
        // =====================================================================
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(
              top: BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 15,
                color: Color(0xFF0D9488),
              ),
              const SizedBox(width: 8),
              Text(
                'Consolidado Octubre 2026:',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Minutos Tarde: $totalLateMins min',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Faltas: $totalAbsences días',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              Text(
                'TOTAL DESCUENTOS POR PENALIZACIÓN:',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFFEE2E2)),
                ),
                child: Text(
                  'Bs. ${totalDeductions.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
