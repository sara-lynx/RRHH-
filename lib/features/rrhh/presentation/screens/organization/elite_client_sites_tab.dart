import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/elite_rrhh_models.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_client_site_form_dialog.dart';

/// Tab 2: Sedes de Clientes y Geocercas GPS.
/// Configuración de puntos de control perimetral para la APK móvil de campo.
class EliteClientSitesTab extends ConsumerWidget {
  const EliteClientSitesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sites = ref.watch(rrhhClientSitesProvider);

    return Column(
      children: [
        // Barra superior compacta con botón Nueva Sede
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
              const Icon(
                Icons.share_location_outlined,
                size: 16,
                color: Color(0xFF0D9488),
              ),
              const SizedBox(width: 8),
              Text(
                'Perímetro de Geocercas GPS y Dotación Exigida por Contrato',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => EliteClientSiteFormDialog.show(context),
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: Text(
                  'Nueva Sede',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(0, 30),
                ),
              ),
            ],
          ),
        ),

        // Tabla en Expanded (80% del espacio)
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 38,
                  dataRowMaxHeight: 46,
                  horizontalMargin: 16,
                  columnSpacing: 16,
                  headingRowColor: const WidgetStatePropertyAll(
                    Color(0xFFF8FAFC),
                  ),
                  dividerThickness: 1,
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: Color(0xFFF1F5F9),
                      width: 1,
                    ),
                  ),
                  columns: [
                    _buildColumnHeader('CÓDIGO', 120),
                    _buildColumnHeader('SEDE / CLIENTE', 220),
                    _buildColumnHeader('CENTRO COSTO', 140),
                    _buildColumnHeader('COORDENADAS GPS', 200),
                    _buildColumnHeader('RADIO GEOCERCA', 140),
                    _buildColumnHeader('DOTACIÓN (REQ / CUB)', 160),
                    _buildColumnHeader('ESTADO COBERTURA', 140),
                  ],
                  rows: sites.map((site) {
                    final isCovered = site.isFullyCovered;

                    return DataRow(
                      cells: [
                        // Código
                        DataCell(
                          Text(
                            site.code,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),

                        // Sede / Cliente
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.business_outlined,
                                size: 14,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                site.name,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Centro de Costo
                        DataCell(
                          Text(
                            EliteCostCenter.getLabel(site.serviceLineCode),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),

                        // Coordenadas GPS
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.my_location,
                                size: 12,
                                color: Color(0xFF0D9488),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${site.latitude.toStringAsFixed(4)}, ${site.longitude.toStringAsFixed(4)}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11.5,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Radio Geocerca
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFDBEAFE)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.radar,
                                  size: 11,
                                  color: Color(0xFF2563EB),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${site.geofenceRadiusMeters.toInt()} metros',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E40AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dotación
                        DataCell(
                          Text(
                            '${site.currentAssigned} cubiertos de ${site.requiredPersonnel} pactados',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),

                        // Estado Cobertura
                        DataCell(
                          isCovered
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFFDCFCE7),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 11,
                                        color: Color(0xFF16A34A),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '100% Cubierto',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF16A34A),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFFFECACA),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        size: 11,
                                        color: Color(0xFFDC2626),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Puesto Descubierto',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataColumn _buildColumnHeader(String label, double width) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF475569),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
