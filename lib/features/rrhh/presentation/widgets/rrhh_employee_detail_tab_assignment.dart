import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_employee_detail_field.dart';

/// Tab 4: Asignación Operativa Vigente (Solo Lectura desde Operaciones / CRM).
/// Informa a RRHH en qué cuenta, sede, turno y servicio se encuentra prestando
/// labores el colaborador.
class RrhhEmployeeDetailTabAssignment extends StatelessWidget {
  final RrhhAssignment? assignment;

  const RrhhEmployeeDetailTabAssignment({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de aviso de frontera: Administrado por Operaciones / CRM
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_clock_outlined,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Las asignaciones de cuadrilla, cliente y servicio son administradas en tiempo real por el Módulo de Operaciones & CRM.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (assignment == null)
            _buildEmptyAssignmentState()
          else
            _buildAssignmentContent(assignment!),
        ],
      ),
    );
  }

  Widget _buildEmptyAssignmentState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF10B981),
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Sin asignación vigente',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'El colaborador se encuentra en dotación disponible para cuadrillas de reemplazo o nuevas órdenes de servicio.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentContent(RrhhAssignment a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('DESTINO & SERVICIO EN CAMPO'),
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
                    label: 'Cliente (Cuenta CRM)',
                    value: a.customerCompanyName ?? 'No asignado',
                    icon: Icons.business_center_outlined,
                    valueColor: const Color(0xFF60A5FA),
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Sede / Sucursal Asignada',
                    value: a.workplaceBranch ?? 'Sede Principal',
                    icon: Icons.store_outlined,
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Servicio Contratado',
                    value: a.contractedServiceName ?? 'Servicio General',
                    icon: Icons.cleaning_services_outlined,
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Supervisor de Cuadrilla',
                    value: a.supervisorName,
                    icon: Icons.person_pin_outlined,
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Horario Operativo',
                    value: a.scheduleName,
                    icon: Icons.alarm_on_outlined,
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Fecha Inicio Asignación',
                    value: _formatDate(a.startDate),
                    icon: Icons.date_range_outlined,
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Código de Asignación',
                    value: a.code,
                    icon: Icons.tag,
                  ),
                ),
                SizedBox(
                  width: colWidth,
                  child: RrhhEmployeeDetailField(
                    label: 'Estado de Asignación',
                    value: a.status,
                    icon: Icons.info_outline,
                    valueColor: const Color(0xFF10B981),
                  ),
                ),
              ],
            );
          },
        ),
        if (a.notes != null && a.notes!.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('OBSERVACIONES DE CAMPO'),
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
              a.notes!,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ],
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

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
