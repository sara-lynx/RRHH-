import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';

/// Diálogo de previsualización de colaborador para el Directorio de Personal.
class RrhhEmployeePreviewDialog extends StatelessWidget {
  final RrhhEmployeeSummaryDto employee;

  const RrhhEmployeePreviewDialog({
    super.key,
    required this.employee,
  });

  static Future<void> show(
    BuildContext context,
    RrhhEmployeeSummaryDto employee,
  ) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => RrhhEmployeePreviewDialog(employee: employee),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.folder_shared_outlined,
            color: Color(0xFF2563EB),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Expediente 360° • ${employee.code}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.fullName,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${employee.position} • ${employee.area} (${employee.employeeType})',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'La ficha integral 360° con documentos de ley, asignación de operaciones e historial se implementará en la Pantalla 03.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF93C5FD),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cerrar',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }
}
