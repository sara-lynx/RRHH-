import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Gráfico y desglose de Distribución Operativa de Personal para el Dashboard RRHH.
/// Presenta dotación por especialidad y estado de disponibilidad publicado a Operaciones.
class RrhhDashboardDistributionChart extends StatelessWidget {
  final int activeEmployees;
  final int availableCount;
  final int onLeaveCount;
  final int suspendedCount;
  final bool isLoading;

  const RrhhDashboardDistributionChart({
    super.key,
    required this.activeEmployees,
    required this.availableCount,
    required this.onLeaveCount,
    required this.suspendedCount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: isLoading
          ? _buildSkeleton()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'DISTRIBUCIÓN POR ESPECIALIDAD',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.04,
                                color: const Color(0xFFF8FAFC),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dotación operativa consolidada por área de servicio',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Total Activos: $activeEmployees',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF93C5FD),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildBarRow(
                  label: 'Limpieza Integral',
                  count: 11,
                  total: activeEmployees > 0 ? activeEmployees : 25,
                  roleTag: '11 operarios de cuadrilla',
                  barColor: const Color(0xFF2563EB),
                ),
                const SizedBox(height: 16),
                _buildBarRow(
                  label: 'Seguridad Física',
                  count: 7,
                  total: activeEmployees > 0 ? activeEmployees : 25,
                  roleTag: '7 guardias y vigilantes',
                  barColor: const Color(0xFF059669),
                ),
                const SizedBox(height: 16),
                _buildBarRow(
                  label: 'Administrativo & RRHH',
                  count: 4,
                  total: activeEmployees > 0 ? activeEmployees : 25,
                  roleTag: '4 personal de sede central',
                  barColor: const Color(0xFF7C3AED),
                ),
                const SizedBox(height: 16),
                _buildBarRow(
                  label: 'Comercial & Supervisión',
                  count: 3,
                  total: activeEmployees > 0 ? activeEmployees : 25,
                  roleTag: '3 ejecutivos y coordinadores',
                  barColor: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 28),
                const Divider(color: Color(0xFF1E293B), height: 1),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ESTADO DE DISPONIBILIDAD PUBLICADO A OPERACIONES',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sincronizado',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildAvailabilityChip(
                      label: '$availableCount Disponibles',
                      subtext: 'Listos para asignación',
                      color: const Color(0xFF10B981),
                    ),
                    _buildAvailabilityChip(
                      label: '$onLeaveCount Con Permiso',
                      subtext: 'Licencias activas',
                      color: const Color(0xFFF59E0B),
                    ),
                    _buildAvailabilityChip(
                      label: '$suspendedCount Suspendidos',
                      subtext: 'Sanción temporal',
                      color: const Color(0xFF64748B),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildBarRow({
    required String label,
    required int count,
    required int total,
    required String roleTag,
    required Color barColor,
  }) {
    final double pct = (count / total).clamp(0.0, 1.0);
    final String pctText = '${(pct * 100).toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• $roleTag',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            Text(
              '$count ($pctText)',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: const Color(0xFF1E293B),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityChip({
    required String label,
    required String subtext,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
