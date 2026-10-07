import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/elite_rrhh_models.dart';

/// Modal técnico de Telemetría GPS y Validación Perimetral desde la APK de Campo.
class EliteFieldEvidenceDialog extends StatelessWidget {
  final EliteAttendanceRecord record;

  const EliteFieldEvidenceDialog({super.key, required this.record});

  static Future<void> show(BuildContext context, EliteAttendanceRecord record) {
    return showDialog(
      context: context,
      builder: (ctx) => EliteFieldEvidenceDialog(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWithin = record.geofenceStatus == GeofenceStatus.dentroDeRadio;
    final timeStr = DateFormat('dd/MM/yyyy • HH:mm:ss').format(record.timestamp);
    const contractedRadiusMeters = 80; // Radio estándar contratado en geocerca

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =================================================================
            // CABECERA DEL DIÁLOGO TÉCNICO (~54px)
            // =================================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
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
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_searching,
                      size: 16,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Telemetría Satelital y Geocerca GPS',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Validación de Presencia en Terreno • APK Móvil Automática',
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
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 16,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: const Color(0xFF64748B),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // =================================================================
            // CUERPO: DATOS DEL COLABORADOR + CUADRÍCULA DE TELEMETRÍA
            // =================================================================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ficha Resumen del Colaborador y Puesto
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_pin_circle_outlined,
                            size: 22,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.employeeName,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${record.employeeJobTitle} • ${record.serviceLineCode} • Sede: ${record.assignedSite}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDFA),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF99F6E4)),
                          ),
                          child: Text(
                            record.shiftName,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F766E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'PARÁMETROS TÉCNICOS DE CAPTURA SATELITAL',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Cuadrícula técnica de telemetría (fondo #F8FAFC)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildDataRow(
                          icon: Icons.satellite_alt_outlined,
                          label: 'Coordenadas Satelitales (Lat/Lng):',
                          valueWidget: Text(
                            record.latitude != null && record.longitude != null
                                ? '${record.latitude!.toStringAsFixed(5)}, ${record.longitude!.toStringAsFixed(5)}'
                                : 'Sin telemetría GPS',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        _buildDataRow(
                          icon: Icons.straighten_outlined,
                          label: 'Distancia al Puesto Asignado:',
                          valueWidget: Text(
                            record.distanceToSiteMeters != null
                                ? '${record.distanceToSiteMeters!.toStringAsFixed(0)} metros'
                                : 'No disponible',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isWithin
                                  ? const Color(0xFF047857)
                                  : const Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        _buildDataRow(
                          icon: Icons.radar_outlined,
                          label: 'Radio Contratado de Geocerca:',
                          valueWidget: Text(
                            '$contractedRadiusMeters metros de tolerancia',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        _buildDataRow(
                          icon: Icons.security_outlined,
                          label: 'Estado de Geocerca Perimetral:',
                          valueWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isWithin
                                  ? const Color(0xFFECFDF5)
                                  : const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isWithin
                                    ? const Color(0xFFA7F3D0)
                                    : const Color(0xFFFECACA),
                              ),
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
                                const SizedBox(width: 5),
                                Text(
                                  isWithin ? 'Dentro de Radio' : 'Fuera de Perímetro',
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
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        _buildDataRow(
                          icon: Icons.access_time_outlined,
                          label: 'Fecha y Hora de Registro:',
                          valueWidget: Text(
                            timeStr,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        _buildDataRow(
                          icon: Icons.wifi_tethering_outlined,
                          label: 'Estado de Conexión de Captura:',
                          valueWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: record.isOfflineSync
                                  ? const Color(0xFFFFFBEB)
                                  : const Color(0xFFF0FDFA),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: record.isOfflineSync
                                    ? const Color(0xFFFDE68A)
                                    : const Color(0xFF99F6E4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  record.isOfflineSync
                                      ? Icons.cloud_off_outlined
                                      : Icons.wifi,
                                  size: 12,
                                  color: record.isOfflineSync
                                      ? const Color(0xFFB45309)
                                      : const Color(0xFF0F766E),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  record.isOfflineSync
                                      ? 'Sincronizado Offline'
                                      : 'En Línea',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: record.isOfflineSync
                                        ? const Color(0xFFB45309)
                                        : const Color(0xFF0F766E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =================================================================
            // FOOTER CON BOTÓN DE CIERRE
            // =================================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 0,
                      ),
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

  Widget _buildDataRow({
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF64748B)),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        valueWidget,
      ],
    );
  }
}
