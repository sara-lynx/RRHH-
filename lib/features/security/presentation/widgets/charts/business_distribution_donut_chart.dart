import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Gráfico Circular / Donut de Distribución Operativa de Elite Multiservicios.
/// Permite alternar entre:
/// 1. Segmentación de Cartera: Cuentas Corporativas B2B vs Residenciales B2C.
/// 2. Composición de Facturación: Contratos Recurrentes (MRR) vs Proyectos y Eventos.
class BusinessDistributionDonutChart extends StatefulWidget {
  final bool isDark;
  final int totalActiveCustomers;
  final int totalB2b;
  final int totalB2c;
  final double totalMrr;
  final double totalProjectVolume;
  final VoidCallback? onOpenCustomers;

  const BusinessDistributionDonutChart({
    super.key,
    required this.isDark,
    required this.totalActiveCustomers,
    required this.totalB2b,
    required this.totalB2c,
    required this.totalMrr,
    required this.totalProjectVolume,
    this.onOpenCustomers,
  });

  @override
  State<BusinessDistributionDonutChart> createState() =>
      _BusinessDistributionDonutChartState();
}

class _BusinessDistributionDonutChartState
    extends State<BusinessDistributionDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sweepAnimation;
  bool _showRevenueMode = false;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _sweepAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(BusinessDistributionDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalActiveCustomers != widget.totalActiveCustomers ||
        oldWidget.totalB2b != widget.totalB2b ||
        oldWidget.totalB2c != widget.totalB2c ||
        oldWidget.totalMrr != widget.totalMrr ||
        oldWidget.totalProjectVolume != widget.totalProjectVolume) {
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
    final List<_DonutSegment> segments;
    final String centerPrimaryText;
    final String centerSubText;

    if (_showRevenueMode) {
      final totalRev = widget.totalMrr + widget.totalProjectVolume;
      final mrrPercent = totalRev > 0
          ? (widget.totalMrr / totalRev) * 100
          : 50.0;
      final projPercent = totalRev > 0
          ? (widget.totalProjectVolume / totalRev) * 100
          : 50.0;

      segments = [
        _DonutSegment(
          label: 'Recurrente (MRR)',
          value: widget.totalMrr,
          displayValue: _formatCurrency(widget.totalMrr),
          percentage: mrrPercent,
          color: const Color(0xFF2563EB),
        ),
        _DonutSegment(
          label: 'Proyectos & Eventos',
          value: widget.totalProjectVolume,
          displayValue: _formatCurrency(widget.totalProjectVolume),
          percentage: projPercent,
          color: const Color(0xFF10B981),
        ),
      ];

      centerPrimaryText = _formatCurrency(totalRev);
      centerSubText = 'TOTAL FACTURADO';
    } else {
      final totalCust = widget.totalB2b + widget.totalB2c;
      final b2bPercent = totalCust > 0
          ? (widget.totalB2b / totalCust) * 100
          : 50.0;
      final b2cPercent = totalCust > 0
          ? (widget.totalB2c / totalCust) * 100
          : 50.0;

      segments = [
        _DonutSegment(
          label: 'Corporativo B2B',
          value: widget.totalB2b.toDouble(),
          displayValue: '${widget.totalB2b} cuentas',
          percentage: b2bPercent,
          color: const Color(0xFF38BDF8),
        ),
        _DonutSegment(
          label: 'Residencial B2C',
          value: widget.totalB2c.toDouble(),
          displayValue: '${widget.totalB2c} clientes',
          percentage: b2cPercent,
          color: const Color(0xFF6366F1),
        ),
      ];

      centerPrimaryText = '${widget.totalActiveCustomers}';
      centerSubText = 'CLIENTES ACTIVOS';
    }

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
          // Header con selector de modo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.donut_large_rounded,
                            size: 18,
                            color: widget.isDark
                                ? const Color(0xFF10B981)
                                : const Color(0xFF059669),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _showRevenueMode
                                  ? 'Facturación & Modelos'
                                  : 'Composición de Cartera',
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
                        _showRevenueMode
                            ? 'MRR contratos fijos vs proyectos especiales'
                            : 'Distribución B2B corporativo vs B2C residencial',
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
                // Conmutador de vista
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton(
                        label: 'Cartera',
                        isActive: !_showRevenueMode,
                        onTap: () {
                          if (_showRevenueMode) {
                            setState(() => _showRevenueMode = false);
                            _animationController.reset();
                            _animationController.forward();
                          }
                        },
                      ),
                      _buildToggleButton(
                        label: 'Ingresos',
                        isActive: _showRevenueMode,
                        onTap: () {
                          if (!_showRevenueMode) {
                            setState(() => _showRevenueMode = true);
                            _animationController.reset();
                            _animationController.forward();
                          }
                        },
                      ),
                    ],
                  ),
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

          // Cuerpo: Donut + Leyenda
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 200,
              child: Row(
                children: [
                  // Donut Canvas
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _sweepAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                size: const Size(160, 160),
                                painter: _DonutChartPainter(
                                  segments: segments,
                                  sweepProgress: _sweepAnimation.value,
                                  hoveredIndex: _hoveredIndex,
                                  isDark: widget.isDark,
                                ),
                              );
                            },
                          ),
                          // Texto central
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                centerPrimaryText,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: _showRevenueMode ? 17 : 24,
                                  fontWeight: FontWeight.w700,
                                  color: widget.isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                centerSubText,
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: widget.isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Leyenda lateral interactiva
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(segments.length, (index) {
                        final seg = segments[index];
                        final isHovered = _hoveredIndex == index;

                        return MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isHovered
                                  ? (widget.isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFF1F5F9))
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: seg.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        seg.label,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: widget.isDark
                                              ? const Color(0xFFE2E8F0)
                                              : const Color(0xFF334155),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        seg.displayValue,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 11,
                                          color: widget.isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${seg.percentage.toStringAsFixed(0)}%',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: seg.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sub-barra descriptiva
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
                    _showRevenueMode
                        ? 'MRR: Facturación recurrente mensual asegurada en contratos activos.'
                        : 'Cartera diversificada con sedes corporativas y residenciales.',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: widget.isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.onOpenCustomers != null)
                  InkWell(
                    onTap: widget.onOpenCustomers,
                    child: Text(
                      'Ver Clientes →',
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

  Widget _buildToggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? (widget.isDark ? const Color(0xFF334155) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? (widget.isDark ? Colors.white : const Color(0xFF0F172A))
                : (widget.isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}

class _DonutSegment {
  final String label;
  final double value;
  final String displayValue;
  final double percentage;
  final Color color;

  const _DonutSegment({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.percentage,
    required this.color,
  });
}

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  final double sweepProgress;
  final int? hoveredIndex;
  final bool isDark;

  _DonutChartPainter({
    required this.segments,
    required this.sweepProgress,
    required this.hoveredIndex,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) / 2 - 8;
    const baseStrokeWidth = 14.0;

    // Fondo tenue del riel
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    canvas.drawCircle(center, baseRadius, trackPaint);

    final totalVal = segments.fold(0.0, (sum, s) => sum + s.value);
    if (totalVal <= 0) return;

    double startAngle = -math.pi / 2;
    const gapAngle = 0.06; // Pequeño espacio modular entre segmentos

    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final sweepAngle = (seg.value / totalVal) * (2 * math.pi) * sweepProgress;
      if (sweepAngle <= 0) continue;

      final isHovered = hoveredIndex == i;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = isHovered ? baseStrokeWidth + 4 : baseStrokeWidth
        ..color = seg.color;

      final radius = isHovered ? baseRadius + 2 : baseRadius;
      final rect = Rect.fromCircle(center: center, radius: radius);

      final adjustedSweep = math.max(0.01, sweepAngle - gapAngle);
      canvas.drawArc(
        rect,
        startAngle + (gapAngle / 2),
        adjustedSweep,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.sweepProgress != sweepProgress ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.segments != segments;
  }
}
