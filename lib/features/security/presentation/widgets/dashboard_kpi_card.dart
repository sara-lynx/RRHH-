import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tarjeta de KPI Ejecutiva y Operativa para Elite Multiservicios.
/// Diseñada con microinteracciones táctiles, escala modular 8pt y bordes hairline.
class DashboardKpiCard extends StatefulWidget {
  final bool isDark;
  final double width;
  final String label;
  final String value;
  final String subtext;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final String? badgeText;
  final Color? badgeColor;

  const DashboardKpiCard({
    super.key,
    required this.isDark,
    required this.width,
    required this.label,
    required this.value,
    required this.subtext,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.badgeText,
    this.badgeColor,
  });

  @override
  State<DashboardKpiCard> createState() => _DashboardKpiCardState();
}

class _DashboardKpiCardState extends State<DashboardKpiCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBadgeColor = widget.badgeColor ?? widget.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: widget.width,
        transform: Matrix4.translationValues(0.0, _isHovered ? -2.5 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.5)
                : (widget.isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0)),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.accentColor.withValues(
                      alpha: widget.isDark ? 0.18 : 0.08,
                    ),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.2 : 0.02,
                    ),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Fila superior: Label + Icono / Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.label,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: widget.isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withValues(
                            alpha: widget.isDark ? 0.15 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.icon,
                          size: 16,
                          color: widget.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Valor Numérico / Métrico
                  Text(
                    widget.value,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                      color: widget.isDark
                          ? Colors.white
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtexto + Badge opcional
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.subtext,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: widget.isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      if (widget.badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: effectiveBadgeColor.withValues(
                              alpha: widget.isDark ? 0.15 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.badgeText!,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: effectiveBadgeColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
