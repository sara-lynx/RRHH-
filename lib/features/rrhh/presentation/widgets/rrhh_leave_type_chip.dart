import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/rrhh_leave_request.dart';

/// Chip de tipo de permiso laboral con estilo visual y colores temáticos.
class RrhhLeaveTypeChip extends StatelessWidget {
  final String leaveType;

  const RrhhLeaveTypeChip({super.key, required this.leaveType});

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = _getTypeConfig(leaveType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, IconData) _getTypeConfig(String type) {
    switch (type.toUpperCase()) {
      case RrhhLeaveTypes.maternidad:
        return (
          const Color(0xFFF472B6),
          'Maternidad',
          Icons.child_care_outlined,
        );
      case RrhhLeaveTypes.paternidad:
        return (
          const Color(0xFF818CF8),
          'Paternidad',
          Icons.family_restroom_outlined,
        );
      case RrhhLeaveTypes.enfermedad:
        return (
          const Color(0xFF34D399),
          'Enfermedad',
          Icons.medical_services_outlined,
        );
      case RrhhLeaveTypes.accidente:
        return (const Color(0xFFFB923C), 'Accidente', Icons.emergency_outlined);
      case RrhhLeaveTypes.duelo:
        return (
          const Color(0xFFA78BFA),
          'Duelo',
          Icons.sentiment_very_dissatisfied_outlined,
        );
      case RrhhLeaveTypes.matrimonio:
        return (
          const Color(0xFFFB7185),
          'Matrimonio',
          Icons.favorite_border_outlined,
        );
      case RrhhLeaveTypes.estudio:
        return (const Color(0xFF38BDF8), 'Estudio', Icons.school_outlined);
      case RrhhLeaveTypes.personalConGoce:
        return (
          const Color(0xFF2DD4BF),
          'Personal c/ Goce',
          Icons.person_outline,
        );
      case RrhhLeaveTypes.personalSinGoce:
        return (
          const Color(0xFF94A3B8),
          'Personal s/ Goce',
          Icons.person_off_outlined,
        );
      case RrhhLeaveTypes.tramitePersonal:
        return (
          const Color(0xFFFBBF24),
          'Trámite',
          Icons.assignment_late_outlined,
        );
      case RrhhLeaveTypes.calamidadDomestica:
        return (
          const Color(0xFFF87171),
          'Calamidad',
          Icons.home_repair_service_outlined,
        );
      case RrhhLeaveTypes.otro:
      default:
        return (
          const Color(0xFF94A3B8),
          RrhhLeaveTypes.getLabel(type),
          Icons.more_horiz_outlined,
        );
    }
  }
}
