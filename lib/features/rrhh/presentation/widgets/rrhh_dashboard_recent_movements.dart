import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Feed de novedades recientes de personal para el Dashboard de RRHH.
/// Visualiza altas, licencias, cambios salariales y desvinculaciones recientes.
class RrhhDashboardRecentMovements extends StatelessWidget {
  final List<RrhhRecentMovementDto> movements;
  final bool isLoading;

  const RrhhDashboardRecentMovements({
    super.key,
    required this.movements,
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
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'FEED DE NOVEDADES RECIENTES',
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
                          'Eventos y transiciones de personal (Últimas 24h)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'EN VIVO',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (movements.isEmpty)
                  _buildEmptyState()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movements.length,
                    separatorBuilder: (_, _) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFF1E293B), height: 1),
                    ),
                    itemBuilder: (context, index) {
                      return _buildMovementItem(movements[index]);
                    },
                  ),
              ],
            ),
    );
  }

  Widget _buildMovementItem(RrhhRecentMovementDto movement) {
    final (icon, color) = _getMovementVisuals(movement.type);
    final timeStr = _formatTimestamp(movement.timestamp);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      movement.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF8FAFC),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeStr,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                movement.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                  height: 1.35,
                ),
              ),
              if (movement.employeeCode.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    movement.employeeCode,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF93C5FD),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  (IconData, Color) _getMovementVisuals(String type) {
    switch (type.toUpperCase()) {
      case 'CONTRATACION':
        return (Icons.person_add_alt_1_outlined, const Color(0xFF10B981));
      case 'PERMISO':
        return (Icons.event_note_outlined, const Color(0xFF2563EB));
      case 'AJUSTE_SALARIAL':
        return (Icons.payments_outlined, const Color(0xFF7C3AED));
      case 'DESVINCULACION':
        return (Icons.person_remove_outlined, const Color(0xFFEF4444));
      case 'INCIDENCIA':
        return (Icons.warning_amber_rounded, const Color(0xFFF59E0B));
      default:
        return (Icons.notifications_none_outlined, const Color(0xFF94A3B8));
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes.clamp(1, 59)}m';
    } else if (diff.inHours < 24) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$hour:$min';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else {
      return '${dt.day}/${dt.month}';
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: Color(0xFF475569),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay movimientos recientes registrados.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 190,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
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
