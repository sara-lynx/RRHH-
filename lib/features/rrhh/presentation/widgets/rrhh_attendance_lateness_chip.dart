import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Chip indicador de minutos de tardanza con código de colores semántico.
class RrhhAttendanceLatenessChip extends StatelessWidget {
  final int? lateMinutes;
  final bool isAbsent;

  const RrhhAttendanceLatenessChip({
    super.key,
    required this.lateMinutes,
    this.isAbsent = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isAbsent || lateMinutes == null) {
      return Text(
        '—',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (lateMinutes! <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: const Color(0xFF064E3B).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Sin tardanza',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF34D399),
              ),
            ),
          ],
        ),
      );
    }

    final bool isSevere = lateMinutes! > 15;
    final Color dotColor = isSevere
        ? const Color(0xFFEF4444)
        : const Color(0xFFF59E0B);
    final Color bgColor = isSevere
        ? const Color(0xFF7F1D1D).withValues(alpha: 0.3)
        : const Color(0xFF78350F).withValues(alpha: 0.3);
    final Color textColor = isSevere
        ? const Color(0xFFF87171)
        : const Color(0xFFFBBF24);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$lateMinutes min',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
