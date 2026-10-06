import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_timeline_event.dart';

/// Panel de resumen con 4 KPIs de auditoría para la Bitácora de Movimientos (Pantalla 14 — Bloque 4).
class RrhhAuditKpis extends StatelessWidget {
  final List<RrhhTimelineEvent> events;

  const RrhhAuditKpis({
    super.key,
    required this.events,
  });

  String _formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.isNegative) {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
    if (diff.inMinutes < 1) {
      return 'Hace un momento';
    } else if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} h';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} d';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Eventos del período
    final totalEvents = events.length;

    // 2. Usuarios activos (responsables únicos)
    final uniqueUsers = events
        .map((e) => e.registeredBy)
        .where((u) => u.isNotEmpty)
        .toSet();
    final activeUsersCount = uniqueUsers.length;

    // 3. Categoría más frecuente
    String mostFrequentCategoryName = 'Ninguna';
    String mostFrequentCategorySub = 'Sin registros';
    if (events.isNotEmpty) {
      final categoryCounts = <String, int>{};
      for (final e in events) {
        categoryCounts[e.category] = (categoryCounts[e.category] ?? 0) + 1;
      }
      final sortedEntries = categoryCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topEntry = sortedEntries.first;
      mostFrequentCategoryName = RrhhTimelineCategory.getLabel(topEntry.key);
      mostFrequentCategorySub =
          '${topEntry.value} eventos (${((topEntry.value / totalEvents) * 100).toStringAsFixed(0)}%)';
    }

    // 4. Última actividad
    String lastActivityStr = 'Sin actividad';
    String lastActivitySub = 'En espera de eventos';
    if (events.isNotEmpty) {
      // events ya vienen ordenados DESC
      final latest = events.first;
      lastActivityStr = _formatRelativeTime(latest.date);
      lastActivitySub = 'Por ${latest.registeredBy}';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final cardWidth = isNarrow
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        final cards = [
          _buildKpiCard(
            title: 'Eventos del período',
            value: '$totalEvents registros',
            subtitle: 'Trazabilidad 100% auditada',
            icon: Icons.fact_check_outlined,
            iconColor: const Color(0xFF10B981),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Usuarios activos',
            value: '$activeUsersCount usuarios',
            subtitle: 'Con registros generados',
            icon: Icons.people_outline_rounded,
            iconColor: const Color(0xFF3B82F6),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Categoría más frecuente',
            value: mostFrequentCategoryName,
            subtitle: mostFrequentCategorySub,
            icon: Icons.pie_chart_outline_rounded,
            iconColor: const Color(0xFFA855F7),
            width: cardWidth,
          ),
          _buildKpiCard(
            title: 'Última actividad',
            value: lastActivityStr,
            subtitle: lastActivitySub,
            icon: Icons.schedule_rounded,
            iconColor: const Color(0xFFF59E0B),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
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
                    color: const Color(0xFFF8FAFC),
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
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
