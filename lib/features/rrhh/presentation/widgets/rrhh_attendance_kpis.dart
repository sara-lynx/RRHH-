import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_attendance_record.dart';

/// Panel de resumen con 4 KPIs de asistencia de campo (Pantalla 13 — Bloque 4).
class RrhhAttendanceKpis extends StatelessWidget {
  final List<RrhhAttendanceRecord> records;

  const RrhhAttendanceKpis({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Asistencias registradas (presentes o con tardanza)
    final registeredCount = records
        .where((r) => r.isPresent || r.isLate)
        .length;

    // 2. Tardanzas y minutos acumulados
    final lateRecords = records.where((r) => r.isLate).toList();
    final lateCount = lateRecords.length;
    final totalLateMinutes = lateRecords.fold<int>(
      0,
      (sum, r) => sum + (r.lateMinutes ?? 0),
    );

    // 3. Ausencias (justificadas e injustificadas)
    final justifiedCount = records.where((r) => r.isJustified).length;
    final unjustifiedCount = records.where((r) => r.isAbsent).length;
    final totalAbsences = justifiedCount + unjustifiedCount;

    // 4. Horas trabajadas totales
    final totalHours = records.fold<double>(
      0.0,
      (sum, r) => sum + (r.workedHours ?? 0.0),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final cardWidth = isNarrow
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        final cards = [
          _buildKpiCard(
            title: 'Asistencias registradas',
            value: '$registeredCount jornadas',
            subtitle: 'En el período consultado',
            icon: Icons.how_to_reg_rounded,
            iconColor: const Color(0xFF10B981),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Tardanzas',
            value: '$lateCount registros',
            subtitle: '$totalLateMinutes min acumulados',
            icon: Icons.schedule_rounded,
            iconColor: const Color(0xFFF59E0B),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Ausencias',
            value: '$totalAbsences totales',
            subtitle: '$justifiedCount justif. · $unjustifiedCount injustif.',
            icon: Icons.event_busy_rounded,
            iconColor: const Color(0xFFEF4444),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Horas trabajadas totales',
            value: '${totalHours.toStringAsFixed(1)} hrs',
            subtitle: 'Efectivas según APK móvil',
            icon: Icons.timelapse_rounded,
            iconColor: const Color(0xFF3B82F6),
            width: cardWidth,
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards,
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
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
    );
  }
}
