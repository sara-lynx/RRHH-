import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_attendance_record.dart';

/// Chip de estado para la asistencia de campo con punto semántico.
class RrhhAttendanceStatusChip extends StatelessWidget {
  final String status;

  const RrhhAttendanceStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case RrhhAttendanceStatus.presente:
        dotColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF064E3B).withValues(alpha: 0.35);
        textColor = const Color(0xFF34D399);
        label = 'Presente';
        break;
      case RrhhAttendanceStatus.tarde:
        dotColor = const Color(0xFFF59E0B);
        bgColor = const Color(0xFF78350F).withValues(alpha: 0.35);
        textColor = const Color(0xFFFBBF24);
        label = 'Tarde';
        break;
      case RrhhAttendanceStatus.ausente:
        dotColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFF7F1D1D).withValues(alpha: 0.35);
        textColor = const Color(0xFFF87171);
        label = 'Ausente';
        break;
      case RrhhAttendanceStatus.justificado:
        dotColor = const Color(0xFF3B82F6);
        bgColor = const Color(0xFF1E3A8A).withValues(alpha: 0.35);
        textColor = const Color(0xFF60A5FA);
        label = 'Justificado';
        break;
      default:
        dotColor = const Color(0xFF94A3B8);
        bgColor = const Color(0xFF334155).withValues(alpha: 0.35);
        textColor = const Color(0xFFCBD5E1);
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
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
