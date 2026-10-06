import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Gráfico de Barras Operativo del Embudo Comercial de Elite Multiservicios.
/// Muestra las 5 compuertas comerciales reales: Calificación, Visita Técnica,
/// Propuesta, Negociación y Ganado.
class OperationalPipelineBarChart extends StatefulWidget {
  final bool isDark;
  final int qualificationCount;
  final int technicalVisitCount;
  final int proposalCount;
  final int negotiationCount;
  final int wonCount;
  final double totalPipelineValue;
  final double winRate;
  final VoidCallback? onOpenPipeline;

  const OperationalPipelineBarChart({
    super.key,
    required this.isDark,
    required this.qualificationCount,
    required this.technicalVisitCount,
    required this.proposalCount,
    required this.negotiationCount,
    required this.wonCount,
    required this.totalPipelineValue,
    required this.winRate,
    this.onOpenPipeline,
  });

  @override
  State<OperationalPipelineBarChart> createState() =>
      _OperationalPipelineBarChartState();
}

class _OperationalPipelineBarChartState
    extends State<OperationalPipelineBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _growthAnimation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _growthAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(OperationalPipelineBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qualificationCount != widget.qualificationCount ||
        oldWidget.technicalVisitCount != widget.technicalVisitCount ||
        oldWidget.proposalCount != widget.proposalCount ||
        oldWidget.negotiationCount != widget.negotiationCount ||
        oldWidget.wonCount != widget.wonCount) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Bs. ${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return 'Bs. ${(amount / 1000).toStringAsFixed(1)}k';
    }
    return 'Bs. ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final stages = [
      _StageData(
        name: 'Calificación',
        count: widget.qualificationCount,
        color: const Color(0xFF3B82F6),
        description: 'Prospección inicial y contacto',
      ),
      _StageData(
        name: 'Visita Técnica',
        count: widget.technicalVisitCount,
        color: const Color(0xFF06B6D4),
        description: 'Relevamiento en sede de cliente',
      ),
      _StageData(
        name: 'Propuesta',
        count: widget.proposalCount,
        color: const Color(0xFF6366F1),
        description: 'Cotización formal emitida',
      ),
      _StageData(
        name: 'Negociación',
        count: widget.negotiationCount,
        color: const Color(0xFFF59E0B),
        description: 'Ajuste de alcance y tarifas',
      ),
      _StageData(
        name: 'Ganado',
        count: widget.wonCount,
        color: const Color(0xFF10B981),
        description: 'Contrato firmado / Traspaso 360°',
      ),
    ];

    final maxCount = stages
        .map((s) => s.count)
        .fold(0, (max, count) => count > max ? count : max);
    final totalDeals = stages.fold(0, (sum, s) => sum + s.count);

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            size: 18,
                            color: widget.isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Embudo Comercial & Pipeline',
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Oportunidades de servicios en curso por compuerta de conversión',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: widget.isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Badges de conversión y valor
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Valor: ',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: widget.isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            _formatCurrency(widget.totalPipelineValue),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: widget.isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${widget.winRate.toStringAsFixed(0)}% Cierre',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: widget.isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
          ),

          // Área del gráfico
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _growthAnimation,
                builder: (context, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(stages.length, (index) {
                      final stage = stages[index];
                      final isHovered = _hoveredIndex == index;

                      // Altura proporcional (mínimo 16px para visualización formal)
                      final normalized = maxCount > 0
                          ? (stage.count / maxCount)
                          : (totalDeals == 0 ? 0.08 : 0.0);
                      final barHeight =
                          (130 * normalized * _growthAnimation.value).clamp(
                            14.0,
                            130.0,
                          );

                      return Expanded(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: widget.onOpenPipeline,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Valor numérico sobre la barra
                                Text(
                                  '${stage.count}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: isHovered
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isHovered
                                        ? stage.color
                                        : (widget.isDark
                                              ? const Color(0xFFCBD5E1)
                                              : const Color(0xFF475569)),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Barra con gradiente
                                Container(
                                  height: barHeight,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        stage.color,
                                        stage.color.withValues(
                                          alpha: widget.isDark ? 0.4 : 0.6,
                                        ),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                    boxShadow: isHovered
                                        ? [
                                            BoxShadow(
                                              color: stage.color.withValues(
                                                alpha: 0.35,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, -2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Etiqueta de la etapa
                                Text(
                                  stage.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: isHovered
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isHovered
                                        ? (widget.isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A))
                                        : (widget.isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),

          // Sub-barra descriptiva de la etapa seleccionada o tip operativo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? const Color(0xFF111827).withValues(alpha: 0.7)
                  : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _hoveredIndex != null
                        ? 'Etapa: ${stages[_hoveredIndex!].name} — ${stages[_hoveredIndex!].description}'
                        : (totalDeals == 0
                              ? 'Pipeline inicializado: Todas las oportunidades registradas en CRM impactarán este embudo.'
                              : '$totalDeals oportunidades activas gestionadas en el pipeline comercial.'),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: widget.isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.onOpenPipeline != null)
                  InkWell(
                    onTap: widget.onOpenPipeline,
                    child: Text(
                      'Ver Pipeline →',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF0284C7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageData {
  final String name;
  final int count;
  final Color color;
  final String description;

  const _StageData({
    required this.name,
    required this.count,
    required this.color,
    required this.description,
  });
}
