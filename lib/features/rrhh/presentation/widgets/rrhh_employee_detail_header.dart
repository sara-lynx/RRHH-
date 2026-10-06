import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_personal_status_chip.dart';

/// Cabecera ejecutiva del expediente del colaborador (Pantalla 03).
/// Integra avatar, nombre prominente, chips de estado, resumen organizacional y acciones.
class RrhhEmployeeDetailHeader extends StatelessWidget {
  final RrhhEmployee employee;
  final bool canEdit;
  final bool canModifyContract;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onModifyContract;

  const RrhhEmployeeDetailHeader({
    super.key,
    required this.employee,
    this.canEdit = true,
    this.canModifyContract = true,
    required this.onClose,
    required this.onEdit,
    required this.onModifyContract,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(employee.fullName);
    final antiquity = _calculateAntiquity(employee.realStartDate);
    final isActive = employee.status.toUpperCase() == 'ACTIVO';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de navegación superior del modal: Código a la izquierda, botones a la derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'EXPEDIENTE • ${employee.code}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF93C5FD),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ficha Técnica 360°',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Botón 1: [Editar Ficha]
                  Tooltip(
                    message: canEdit
                        ? 'Editar datos personales y de contacto'
                        : 'No tienes permisos para editar la ficha.',
                    child: OutlinedButton.icon(
                      onPressed: canEdit ? onEdit : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFCBD5E1),
                        disabledForegroundColor: const Color(0xFF64748B),
                        side: BorderSide(
                          color: canEdit
                              ? const Color(0xFF334155)
                              : const Color(0xFF1E293B),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 14),
                      label: Text(
                        'Editar Ficha',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Botón 2: [Modificar Datos Contractuales]
                  Tooltip(
                    message: canModifyContract
                        ? 'Modificar condiciones contractuales y de asignación'
                        : 'No tienes permisos para modificar datos contractuales.',
                    child: OutlinedButton.icon(
                      onPressed: canModifyContract ? onModifyContract : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF59E0B),
                        disabledForegroundColor: const Color(0xFF64748B),
                        side: BorderSide(
                          color: canModifyContract
                              ? const Color(0xFFB45309)
                              : const Color(0xFF1E293B),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      icon: const Icon(Icons.history_edu_outlined, size: 14),
                      label: Text(
                        'Modificar Datos Contractuales',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 18),
                    color: const Color(0xFF94A3B8),
                    tooltip: 'Cerrar (Esc)',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cuerpo de la cabecera: Avatar + Nombre + Metadatos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF334155),
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Información del perfil
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            employee.fullName,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF8FAFC),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Badge Estado
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (isActive
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF64748B))
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  (isActive
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF64748B))
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            isActive ? 'Activo' : 'Inactivo',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Badge Disponibilidad
                        RrhhPersonalStatusChip(
                          status: employee.availabilityStatus,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Línea de Cargo, Área y Antigüedad
                    Text(
                      '${employee.position}  •  ${employee.area} (${employee.employeeType})  •  Antigüedad: $antiquity',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Email Corporativo si existe
                    if (employee.corporateEmail != null &&
                        employee.corporateEmail!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.mail_outline,
                            size: 13,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            employee.corporateEmail!,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF60A5FA),
                            ),
                          ),
                          if (RrhhRepository.current.isMock) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              child: Text(
                                'DEMO',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.isNotEmpty && parts[0].isNotEmpty
        ? parts[0][0].toUpperCase()
        : 'EM';
  }

  String _calculateAntiquity(DateTime start) {
    final now = DateTime.now();
    int years = now.year - start.year;
    int months = now.month - start.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    final formattedDate =
        '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';

    if (years <= 0 && months <= 0) {
      return 'Recién ingresado ($formattedDate)';
    } else if (years <= 0) {
      return '$months ${months == 1 ? 'mes' : 'meses'} ($formattedDate)';
    } else {
      return '$years ${years == 1 ? 'año' : 'años'}, $months ${months == 1 ? 'mes' : 'meses'} ($formattedDate)';
    }
  }
}
