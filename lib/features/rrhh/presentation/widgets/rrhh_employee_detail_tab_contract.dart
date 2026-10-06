import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_employee_detail_field.dart';

/// Tab 2: Contrato y Compensación Salarial del Colaborador.
/// Protegido con rol `rrhh.compensation.view`. Si no tiene permiso, el salario
/// se enmascara con '••••••' sin ocultar el campo.
class RrhhEmployeeDetailTabContract extends StatelessWidget {
  final RrhhEmployee employee;
  final bool hasCompensationPermission;

  const RrhhEmployeeDetailTabContract({
    super.key,
    required this.employee,
    this.hasCompensationPermission = true,
  });

  @override
  Widget build(BuildContext context) {
    final formattedSalary = employee.agreedSalary != null
        ? 'Bs. ${_formatCurrency(employee.agreedSalary!)}'
        : '---';
    final contractEndStr = employee.contractEndDate != null
        ? _formatDate(employee.contractEndDate!)
        : 'Indefinido (Sin vencimiento)';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner informativo para contabilidad
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Este salario base pactado es la referencia oficial para la liquidación mensual de novedades en Contabilidad.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF93C5FD),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _buildSectionHeader('TÉRMINOS CONTRACTUALES'),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              final colWidth = isWide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Tipo de Contrato',
                      value: employee.contractType,
                      icon: Icons.history_edu_outlined,
                      valueColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Vigencia / Fin de Contrato',
                      value: contractEndStr,
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Modalidad de Pago',
                      value: employee.paymentModality,
                      icon: Icons.payments_outlined,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: RrhhEmployeeDetailField(
                      label: 'Jornada Laboral Base',
                      value: _formatSchedule(employee.workScheduleType),
                      icon: Icons.schedule_outlined,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),

          _buildSectionHeader('COMPENSACIÓN & SALARIO BASE PACTADO'),
          const SizedBox(height: 10),
          RrhhEmployeeDetailField(
            label: 'Salario Base Pactado',
            value: formattedSalary,
            icon: Icons.monetization_on_outlined,
            isSensitive: true,
            isMasked: !hasCompensationPermission,
            valueColor: const Color(0xFF10B981),
          ),
          if (employee.observations != null &&
              employee.observations!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSectionHeader('OBSERVACIONES CONTRACTUALES'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Text(
                employee.observations!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _formatSchedule(String? raw) {
    if (raw == null) return '48 Horas Semanales';
    if (raw.contains('48H')) return 'Tiempo Completo (48h Semanales)';
    if (raw.contains('24H')) return 'Medio Tiempo (24h Semanales)';
    if (raw.contains('ROTATIVO')) return 'Turnos Rotativos (Operaciones)';
    return raw.replaceAll('_', ' ');
  }
}
