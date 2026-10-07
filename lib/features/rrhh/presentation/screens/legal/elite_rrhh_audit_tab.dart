import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/elite_rrhh_providers.dart';

/// Tab 3: Bitácora de Auditoría Legal e Inmutable de Recursos Humanos.
class EliteRrhhAuditTab extends ConsumerStatefulWidget {
  const EliteRrhhAuditTab({super.key});

  @override
  ConsumerState<EliteRrhhAuditTab> createState() => _EliteRrhhAuditTabState();
}

class _EliteRrhhAuditTabState extends ConsumerState<EliteRrhhAuditTab> {
  final _searchController = TextEditingController();

  final List<String> _auditActionOptions = const [
    'APERTURA_SISTEMA',
    'SINCRONIZACION_ASISTENCIA',
    'EMISION_MEMORANDUM',
    'APROBACION_PERMISO',
    'CALCULO_FINIQUITO',
    'CIERRE_PREPLANILLA',
    'GENERACION_ASIENTO',
    'MODIFICACION_TURNO',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auditLogs = ref.watch(rrhhFilteredAuditLogsProvider);
    final selectedAction = ref.watch(auditActionFilterProvider);

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // ===================================================================
          // BARRA DE FILTROS SUPERIOR COMPACTA (~46px)
          // ===================================================================
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
                            .read(auditSearchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Buscar en bitácora por detalle, usuario, referencia o hash...',
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
                                      .read(auditSearchQueryProvider.notifier)
                                      .setQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
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

                // Selector: Tipo de Acción
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
                        value: selectedAction,
                        icon: const Icon(
                          Icons.filter_list,
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
                              .read(auditActionFilterProvider.notifier)
                              .setFilter(val);
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Acción: Todas'),
                          ),
                          ..._auditActionOptions.map((act) {
                            return DropdownMenuItem(
                              value: act,
                              child: Text(act),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Limpiar filtros
                if (selectedAction != null || _searchController.text.isNotEmpty)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 30),
                    ),
                    icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                    label: Text(
                      'Limpiar filtros',
                      style: GoogleFonts.inter(fontSize: 11),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref
                          .read(auditSearchQueryProvider.notifier)
                          .setQuery('');
                      ref
                          .read(auditActionFilterProvider.notifier)
                          .setFilter(null);
                    },
                  ),
              ],
            ),
          ),

          // ===================================================================
          // TABLA FULL-WIDTH EN TARJETA CORPORATIVA (EXPANDED)
          // ===================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                child: auditLogs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 38,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No se encontraron eventos en la bitácora de auditoría',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final tableWidth = constraints.maxWidth < 950
                              ? 950.0
                              : constraints.maxWidth;
                          const horizMargin = 12.0;
                          final netColumnsWidth = tableWidth - (horizMargin * 2);

                          // Reparto proporcional al 100%
                          final colTimestamp = netColumnsWidth * 0.13;
                          final colUser = netColumnsWidth * 0.15;
                          final colAction = netColumnsWidth * 0.15;
                          final colRef = netColumnsWidth * 0.10;
                          final colDetail = netColumnsWidth * 0.32;
                          final colHash = netColumnsWidth * 0.15;

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
                                        width: colTimestamp,
                                        child: Text(
                                          'FECHA / HORA EXACTA',
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
                                        width: colUser,
                                        child: Text(
                                          'USUARIO RESPONSABLE',
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
                                        width: colAction,
                                        child: Text(
                                          'ACCIÓN REGISTRADA',
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
                                        width: colRef,
                                        child: Text(
                                          'REFERENCIA',
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
                                        width: colDetail,
                                        child: Text(
                                          'DETALLE CIRCUNSTANCIADO',
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
                                        width: colHash,
                                        child: Text(
                                          'SELLO SHA-256 INMUTABLE',
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
                                  rows: auditLogs.map((log) {
                                    final dt = log.timestamp;
                                    final timeStr =
                                        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
                                    final truncatedHash = log.sha256Hash.length > 18
                                        ? '${log.sha256Hash.substring(0, 10)}...${log.sha256Hash.substring(log.sha256Hash.length - 6)}'
                                        : log.sha256Hash;

                                    return DataRow(
                                      cells: [
                                        // Fecha/Hora
                                        DataCell(
                                          SizedBox(
                                            width: colTimestamp,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                timeStr,
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF334155),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Usuario
                                        DataCell(
                                          SizedBox(
                                            width: colUser,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 11,
                                                  backgroundColor:
                                                      const Color(0xFFF0FDFA),
                                                  child: Text(
                                                    'PT',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 9.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF0F766E),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        log.userName,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 11.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF0F172A),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        'Encargada RRHH',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xFF64748B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Acción
                                        DataCell(
                                          SizedBox(
                                            width: colAction,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2.5),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF1F5F9),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFFE2E8F0)),
                                                ),
                                                child: Text(
                                                  log.action,
                                                  style:
                                                      GoogleFonts.jetBrainsMono(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                        0xFF334155),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Referencia
                                        DataCell(
                                          SizedBox(
                                            width: colRef,
                                            child: Text(
                                              log.reference,
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF0D9488),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Detalle
                                        DataCell(
                                          SizedBox(
                                            width: colDetail,
                                            child: Text(
                                              log.detail,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                color: const Color(0xFF1E293B),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        // SHA-256 Sello Inmutable
                                        DataCell(
                                          SizedBox(
                                            width: colHash,
                                            child: InkWell(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                      text: log.sha256Hash),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        const Color(0xFF0F172A),
                                                    content: Text(
                                                      'Hash SHA-256 copiado: ${log.sha256Hash}',
                                                      style: GoogleFonts
                                                          .jetBrainsMono(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF8FAFC),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: const Color(
                                                        0xFFE2E8F0),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.verified_outlined,
                                                      size: 13,
                                                      color: Color(0xFF0D9488),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Flexible(
                                                      child: Text(
                                                        truncatedHash,
                                                        style: GoogleFonts
                                                            .jetBrainsMono(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xFF64748B),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
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
        ],
      ),
    );
  }
}
