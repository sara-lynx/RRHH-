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

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '--';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

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
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                    final tableWidth = constraints.maxWidth < 1360
                        ? 1360.0
                        : constraints.maxWidth;

                    const horizMargin = 16.0;
                    final netColumnsWidth = tableWidth - (horizMargin * 2);

                    // Distribución holgada y espaciosa - Cero choques de cabecera
                    final colWorker = netColumnsWidth * 0.18;
                    final colPunchTime = netColumnsWidth * 0.08;
                    final colSite = netColumnsWidth * 0.13;
                    final colGps = netColumnsWidth * 0.12;
                    final colDistance = netColumnsWidth * 0.12;
                    final colGeofence = netColumnsWidth * 0.13;
                    final colMethod = netColumnsWidth * 0.12;
                    final colTelemetry = netColumnsWidth * 0.12;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowHeight: 46.0,
                              dataRowMinHeight: 52.0,
                              dataRowMaxHeight: 56.0,
                              horizontalMargin: horizMargin,
                              columnSpacing: 0,
                              border: const TableBorder(
                                horizontalInside: BorderSide(
                                  color: Color(0xFFF1F5F9),
                                  width: 1.0,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                        color: const Color(0xFF64748B),
                                        letterSpacing: 0.6,
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
                                    // Colaborador con Avatar Circular
                                    DataCell(
                                      SizedBox(
                                        width: colWorker,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFCCFBF1),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                _getInitials(rec.employeeName),
                                                style: GoogleFonts.inter(
                                                  color: const Color(0xFF0F766E),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    rec.employeeName,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF0F172A),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 1),
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
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              rec.assignedSite,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF475569),
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
                                            color: const Color(0xFF64748B),
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

                                    // Validación Geocerca (Pill cápsula)
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
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isWithin
                                                    ? const Color(0xFFECFDF5)
                                                    : const Color(0xFFFEF2F2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    isWithin
                                                        ? Icons.check_circle_outline
                                                        : Icons.error_outline,
                                                    size: 13,
                                                    color: isWithin
                                                        ? const Color(0xFF047857)
                                                        : const Color(0xFFB91C1C),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    rec.geofenceStatus.label,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w700,
                                                      color: isWithin
                                                          ? const Color(0xFF047857)
                                                          : const Color(0xFFB91C1C),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Método Captura
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
                                                    horizontal: 9,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0FDFA),
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    'APK GPS Automático',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF0F766E),
                                                    ),
                                                  ),
                                                ),
                                                if (rec.isOfflineSync) ...[
                                                  const SizedBox(width: 4),
                                                  Tooltip(
                                                    message: 'Captura offline sincronizada',
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 3,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFFFBEB),
                                                        borderRadius:
                                                            BorderRadius.circular(20),
                                                      ),
                                                      child: const Icon(
                                                        Icons.cloud_off_outlined,
                                                        size: 12,
                                                        color: Color(0xFFB45309),
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

                                    // Telemetría GPS: Botón cápsula minimalista
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
                                                size: 13,
                                                color: Color(0xFF64748B),
                                              ),
                                              label: Text(
                                                'Detalle GPS',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF475569),
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: Color(0xFFE2E8F0),
                                                  width: 1,
                                                ),
                                                backgroundColor: Colors.white,
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 0,
                                                ),
                                                minimumSize: const Size(0, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
