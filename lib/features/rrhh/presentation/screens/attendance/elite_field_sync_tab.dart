import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_field_evidence_dialog.dart';

/// Tab 3: Sincronización APK de Campo, telemetría GPS, geocercas y consolidación.
class EliteFieldSyncTab extends ConsumerWidget {
  const EliteFieldSyncTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecords = ref.watch(rrhhAttendanceProvider);
    final fieldRecords = allRecords
        .where((r) => r.workplaceType == EmployeeWorkplaceType.campo)
        .toList();
    final offlineCount = fieldRecords.where((r) => r.isOfflineSync).length;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // =====================================================================
          // BARRA DE CONTROL DE SINCRONIZACIÓN APK (~44px)
          // =====================================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                // Indicador de conexión en vivo con APKs
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gateway APK Campo: Activo • Sincronización continua de Telemetría GPS Automática',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (offlineCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFFEF3C7)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_sync_outlined,
                          size: 12,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$offlineCount pendientes de consolidar',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(width: 12),

                // Botón Consolidar Marcaciones de Campo
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(rrhhAttendanceProvider.notifier)
                        .consolidateFieldSync();
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
                              Icons.check_circle_outline,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Marcaciones offline consolidadas y validadas con el servidor central.',
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
                  icon: const Icon(
                    Icons.sync_outlined,
                    size: 14,
                    color: Color(0xFF0D9488),
                  ),
                  label: Text(
                    'Consolidar Marcaciones de Campo',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D9488),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0D9488)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 30),
                  ),
                ),
              ],
            ),
          ),

          // =====================================================================
          // TABLA DE CAMPO EN EXPANDED DENTRO DE TARJETA CORPORATIVA
          // =====================================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                    final tableWidth = constraints.maxWidth < 1050
                        ? 1050.0
                        : constraints.maxWidth;

                    const horizMargin = 12.0;
                    final netColumnsWidth = tableWidth - (horizMargin * 2);

                    // Distribución proporcional 100% full-width
                    final colWorker = netColumnsWidth * 0.18;
                    final colPunchTime = netColumnsWidth * 0.08;
                    final colSite = netColumnsWidth * 0.14;
                    final colGps = netColumnsWidth * 0.13;
                    final colDistance = netColumnsWidth * 0.08;
                    final colGeofence = netColumnsWidth * 0.12;
                    final colMethod = netColumnsWidth * 0.14;
                    final colTelemetry = netColumnsWidth * 0.13;

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
                              horizontalMargin: 12,
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
                                    width: colWorker,
                                    child: Text(
                                      'COLABORADOR',
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
                                    width: colPunchTime,
                                    child: Text(
                                      'HORA PUNCH',
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
                                    width: colSite,
                                    child: Text(
                                      'SEDE ASIGNADA',
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
                                    width: colGps,
                                    child: Text(
                                      'COORDENADAS GPS',
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
                                    width: colDistance,
                                    child: Text(
                                      'DISTANCIA AL PUESTO',
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
                                    width: colGeofence,
                                    child: Text(
                                      'VALIDACIÓN GEOCERCA',
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
                                    width: colMethod,
                                    child: Text(
                                      'MÉTODO CAPTURA',
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
                                    width: colTelemetry,
                                    child: Text(
                                      'TELEMETRÍA GPS',
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
                              rows: fieldRecords.map((rec) {
                                final timeStr = rec.evaluation ==
                                        AttendanceEvaluation.faltaInjustificada
                                    ? 'Sin Marcación'
                                    : DateFormat('HH:mm:ss').format(rec.timestamp);

                                final isWithin = rec.geofenceStatus ==
                                    GeofenceStatus.dentroDeRadio;

                                return DataRow(
                                  cells: [
                                    // Colaborador
                                    DataCell(
                                      SizedBox(
                                        width: colWorker,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rec.employeeName,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0F172A),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${rec.employeeJobTitle} • ${rec.serviceLineCode}',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                color: const Color(0xFF64748B),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Hora Punch
                                    DataCell(
                                      SizedBox(
                                        width: colPunchTime,
                                        child: Text(
                                          timeStr,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: rec.evaluation ==
                                                    AttendanceEvaluation
                                                        .faltaInjustificada
                                                ? const Color(0xFFB91C1C)
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Sede Asignada
                                    DataCell(
                                      SizedBox(
                                        width: colSite,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFE2E8F0),
                                              ),
                                            ),
                                            child: Text(
                                              rec.assignedSite,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF334155),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Coordenadas GPS
                                    DataCell(
                                      SizedBox(
                                        width: colGps,
                                        child: Text(
                                          rec.latitude != null &&
                                                  rec.longitude != null
                                              ? '${rec.latitude!.toStringAsFixed(4)}, ${rec.longitude!.toStringAsFixed(4)}'
                                              : 'Sin telemetría',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Distancia al Puesto
                                    DataCell(
                                      SizedBox(
                                        width: colDistance,
                                        child: rec.distanceToSiteMeters != null
                                            ? Text(
                                                '${rec.distanceToSiteMeters!.toStringAsFixed(0)} m',
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: isWithin
                                                      ? const Color(0xFF047857)
                                                      : const Color(0xFFB91C1C),
                                                ),
                                              )
                                            : Text(
                                                '--',
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 12,
                                                  color: const Color(0xFF94A3B8),
                                                ),
                                              ),
                                      ),
                                    ),

                                    // Validación Geocerca
                                    DataCell(
                                      SizedBox(
                                        width: colGeofence,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: rec.geofenceStatus.badgeBgColor,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: rec.geofenceStatus.badgeBorderColor,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    isWithin
                                                        ? Icons.check_circle_outline
                                                        : Icons.error_outline,
                                                    size: 11,
                                                    color: rec.geofenceStatus.badgeColor,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    rec.geofenceStatus.label,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: rec.geofenceStatus.badgeColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Método Captura (APK GPS Automático)
                                    DataCell(
                                      SizedBox(
                                        width: colMethod,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0FDFA),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    border: Border.all(
                                                      color: const Color(0xFF99F6E4),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'APK GPS Automático',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF0D9488),
                                                    ),
                                                  ),
                                                ),
                                                if (rec.isOfflineSync) ...[
                                                  const SizedBox(width: 4),
                                                  Tooltip(
                                                    message: 'Captura guardada offline y sincronizada',
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFFFBEB),
                                                        borderRadius:
                                                            BorderRadius.circular(3),
                                                        border: Border.all(
                                                          color: const Color(0xFFFEF3C7),
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.cloud_off_outlined,
                                                        size: 11,
                                                        color: Color(0xFFD97706),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Telemetría GPS: Botón outline [ Icon(Icons.location_searching, size: 14) Detalle GPS ]
                                    DataCell(
                                      SizedBox(
                                        width: colTelemetry,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: OutlinedButton.icon(
                                              onPressed: () =>
                                                  EliteFieldEvidenceDialog.show(
                                                context,
                                                rec,
                                              ),
                                              icon: const Icon(
                                                Icons.location_searching,
                                                size: 14,
                                                color: Color(0xFF0D9488),
                                              ),
                                              label: Text(
                                                'Detalle GPS',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF0F766E),
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: Color(0xFF99F6E4),
                                                ),
                                                backgroundColor:
                                                    const Color(0xFFF0FDFA),
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 0,
                                                ),
                                                minimumSize: const Size(0, 28),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
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
        ],
      ),
    );
  }
}
