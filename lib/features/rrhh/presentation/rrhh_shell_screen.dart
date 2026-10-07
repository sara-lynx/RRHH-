import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../security/services/auth_service.dart';
import 'screens/attendance/elite_attendance_shell_screen.dart';
import 'screens/incidents/elite_incidents_shell_screen.dart';
import 'screens/legal/elite_legal_shell_screen.dart';
import 'screens/organization/elite_organization_shell_screen.dart';
import 'screens/payroll/elite_payroll_shell_screen.dart';
import 'screens/personal/elite_personal_shell_screen.dart';
import 'widgets/elite_office_punch_button.dart';

/// Shell principal corporativo del Módulo de Recursos Humanos (RRHH).
/// Implementa el Sistema de Diseño Light de Alta Densidad para Elite Multiservicios.
class RrhhShellScreen extends ConsumerStatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;
  final AuthService? authService;

  const RrhhShellScreen({
    super.key,
    this.onToggleTheme,
    this.isDarkMode = false,
    this.authService,
  });

  @override
  ConsumerState<RrhhShellScreen> createState() => _RrhhShellScreenState();
}

class _RrhhShellScreenState extends ConsumerState<RrhhShellScreen> {
  int _selectedModuleIndex = 0;

  static const List<({String title, IconData icon, String subtitle})> _modules = [
    (
      title: 'Personal y Estructura',
      icon: Icons.people_outline,
      subtitle: 'Directorio, contratos y cargos',
    ),
    (
      title: 'Control de Asistencia',
      icon: Icons.fingerprint,
      subtitle: 'Marcación web y APK campo',
    ),
    (
      title: 'Organización y Cuadrantes',
      icon: Icons.calendar_month_outlined,
      subtitle: 'Turnos, sedes y geocercas',
    ),
    (
      title: 'Novedades y Permisos',
      icon: Icons.assignment_outlined,
      subtitle: 'Vacaciones, licencias y faltas',
    ),
    (
      title: 'Nómina y Sueldos',
      icon: Icons.payments_outlined,
      subtitle: 'Pre-planilla y vouchers contables',
    ),
    (
      title: 'Auditoría y Legajos',
      icon: Icons.history_outlined,
      subtitle: 'Bitácora y trazabilidad laboral',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // -------------------------------------------------------------------
          // SIDEBAR CORPORATIVO FIJO (240px)
          // -------------------------------------------------------------------
          Container(
            width: 240,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branding Header del Sidebar
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.business_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ELITE MULTISERVICIOS',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Recursos Humanos (RRHH)',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    'SUBMÓDULOS RRHH',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                // Lista de los 6 submódulos
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _modules.length,
                    itemBuilder: (context, index) {
                      final mod = _modules[index];
                      final isSelected = _selectedModuleIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() => _selectedModuleIndex = index);
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF0FDFA)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFCCFBF1)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    mod.icon,
                                    size: 17,
                                    color: isSelected
                                        ? const Color(0xFF0D9488)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mod.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? const Color(0xFF0F766E)
                                                : const Color(0xFF1E293B),
                                          ),
                                        ),
                                        Text(
                                          mod.subtitle,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 4,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D9488),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer del Sidebar con versión
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: Color(0xFF0D9488),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Elite ERP • v2.0 Light High-Density',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------------
          // CONTENIDO PRINCIPAL (HEADER GLOBAL + SUBMÓDULO ACTIVO)
          // -------------------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                // Header superior global
                _buildGlobalHeader(),

                // Submódulo seleccionado
                Expanded(
                  child: switch (_selectedModuleIndex) {
                    0 => const ElitePersonalShellScreen(),
                    1 => const EliteAttendanceShellScreen(),
                    2 => const EliteOrganizationShellScreen(),
                    3 => const EliteIncidentsShellScreen(),
                    4 => const ElitePayrollShellScreen(),
                    5 => const EliteLegalShellScreen(),
                    _ => _buildPlaceholderModule(_modules[_selectedModuleIndex]),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          // Breadcrumb / Título activo
          Text(
            'Recursos Humanos',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text(
            _modules[_selectedModuleIndex].title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),

          const Spacer(),

          // COMPONENTE OBLIGATORIO: Botón de marcación web rápida de oficina
          const EliteOfficePunchButton(),

          const SizedBox(width: 16),
          Container(
            height: 24,
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),
          const SizedBox(width: 16),

          // Perfil de Usuario en Sesión (Paola Torrico - RRHH)
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'PT',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paola Torrico Vaca',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Encargada de RRHH • CC-RRHH',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderModule(
    ({String title, IconData icon, String subtitle}) mod,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDFA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                mod.icon,
                size: 32,
                color: const Color(0xFF0D9488),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              mod.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mod.subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Próximo Submódulo en Implementación',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
