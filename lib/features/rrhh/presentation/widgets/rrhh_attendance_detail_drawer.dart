import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/rrhh_attendance_record.dart';
import 'rrhh_attendance_lateness_chip.dart';
import 'rrhh_attendance_status_chip.dart';
import 'rrhh_employee_detail_dialog.dart';
import 'rrhh_disciplinary_edit_dialog.dart';

/// Drawer lateral deslizable de detalle de registro de asistencia de campo.
class RrhhAttendanceDetailDrawer extends StatelessWidget {
  final RrhhAttendanceRecord record;
  final VoidCallback onClose;
  final VoidCallback? onNavigateToIncidents;

  const RrhhAttendanceDetailDrawer({
    super.key,
    required this.record,
    required this.onClose,
    this.onNavigateToIncidents,
  });

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '—';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat("EEEE, dd 'de' MMMM 'de' yyyy", 'es_BO');
    final formattedDate = dateFormatter.format(record.date);

    return Container(
      width: 480,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          left: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Header del Drawer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D111C),
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Detalle de Asistencia',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              record.code,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Registro sincronizado desde Operaciones/APK',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Color(0xFF94A3B8),
                  ),
                  tooltip: 'Cerrar detalle',
                  splashRadius: 18,
                ),
              ],
            ),
          ),

          // 2. Contenido Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Informativo
                  _buildSyncBanner(),
                  const SizedBox(height: 18),

                  // Sección 1: Datos del Empleado
                  _buildSectionTitle(
                    '1. DATOS DEL EMPLEADO',
                    Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildEmployeeCard(context),
                  const SizedBox(height: 18),

                  // Sección 2: Datos del Servicio
                  _buildSectionTitle(
                    '2. SERVICIO ASIGNADO',
                    Icons.business_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildServiceCard(),
                  const SizedBox(height: 18),

                  // Sección 3: Jornada y Horarios
                  _buildSectionTitle(
                    '3. JORNADA Y REGISTRO DE HORAS',
                    Icons.access_time_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildShiftCard(formattedDate),
                  const SizedBox(height: 18),

                  // Sección 4: Ubicación y Evidencias
                  _buildSectionTitle(
                    '4. GEOLOCALIZACIÓN Y EVIDENCIAS',
                    Icons.pin_drop_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildLocationCard(),
                  const SizedBox(height: 18),

                  // Sección 5: Incidencias y Acciones
                  _buildSectionTitle(
                    '5. INCIDENCIAS Y ACCIONES RRHH',
                    Icons.report_problem_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildIncidentsCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF60A5FA),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Este registro fue creado por Operaciones/APK. RRHH solo consulta los datos para la gestión de incidencias y novedades de nómina.',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: const Color(0xFFCBD5E1),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(
                  0xFF2563EB,
                ).withValues(alpha: 0.25),
                child: Text(
                  _getInitials(record.employeeName),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF60A5FA),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Código: ${record.employeeCode} · Operaciones de Campo',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => RrhhEmployeeDetailDialog(
                    employeeId: record.employeeId,
                  ),
                );
              },
              icon: const Icon(
                Icons.badge_outlined,
                size: 14,
                color: Color(0xFF38BDF8),
              ),
              label: Text(
                'Ver Expediente del Empleado',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF38BDF8),
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Cliente Titular', record.clientName),
          const SizedBox(height: 8),
          _buildInfoRow('Servicio Contratado', record.serviceName),
          const SizedBox(height: 8),
          _buildInfoRow('Sede / Puesto', record.location),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Supervisor de Cuadrilla',
            'Operaciones / Cuadrilla Turno Central',
          ),
        ],
      ),
    );
  }

  Widget _buildShiftCard(String formattedDate) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              RrhhAttendanceStatusChip(status: record.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTimeMetric(
                  'Entrada Programada',
                  _formatTime(record.scheduledEntry),
                  Icons.login_rounded,
                  const Color(0xFF94A3B8),
                ),
              ),
              Expanded(
                child: _buildTimeMetric(
                  'Entrada Real (APK)',
                  _formatTime(record.actualEntry),
                  Icons.how_to_reg_rounded,
                  record.isLate
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTimeMetric(
                  'Salida Programada',
                  _formatTime(record.scheduledExit),
                  Icons.logout_rounded,
                  const Color(0xFF94A3B8),
                ),
              ),
              Expanded(
                child: _buildTimeMetric(
                  'Salida Real (APK)',
                  _formatTime(record.actualExit),
                  Icons.check_circle_outline_rounded,
                  const Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horas Efectivas:',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.workedHours != null
                        ? '${record.workedHours!.toStringAsFixed(1)} horas'
                        : '0.0 horas',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Retraso / Tardanza:',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  RrhhAttendanceLatenessChip(
                    lateMinutes: record.lateMinutes,
                    isAbsent: record.isAbsent || record.isJustified,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    final hasCoords = record.latitude != null && record.longitude != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasCoords ? Icons.gps_fixed_rounded : Icons.gps_off_rounded,
                size: 16,
                color: hasCoords
                    ? const Color(0xFF10B981)
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                hasCoords
                    ? 'Coordenadas GPS: ${record.latitude!.toStringAsFixed(4)}, ${record.longitude!.toStringAsFixed(4)}'
                    : 'Sin geolocalización GPS registrada',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  color: hasCoords
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Simulación de mapa / radar de campo
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF161F30),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 30,
                        color: const Color(0xFF334155).withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Punto de Marcación APK: ${record.location}',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Radio 50m validado',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildIncidentsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D111C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observaciones del Registro:',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF141A28),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Text(
              record.incidents != null && record.incidents!.isNotEmpty
                  ? record.incidents!
                  : 'Sin incidencias u observaciones reportadas por el supervisor.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFCBD5E1),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Botones contextuales de acción RRHH
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final created = await RrhhDisciplinaryEditDialog.show(
                      context,
                    );
                    if (created == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Incidencia disciplinaria registrada con éxito.',
                          ),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.gavel_rounded,
                    size: 14,
                    color: Color(0xFFF59E0B),
                  ),
                  label: Text(
                    'Registrar Incidencia',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF78350F)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              if (onNavigateToIncidents != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      onClose();
                      onNavigateToIncidents!();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF38BDF8),
                    ),
                    label: Text(
                      'Ver Régimen Disciplinario',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF38BDF8),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFCBD5E1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeMetric(
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF141A28),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return 'EM';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
