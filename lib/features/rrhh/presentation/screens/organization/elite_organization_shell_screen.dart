import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/elite_rrhh_providers.dart';
import 'elite_client_sites_tab.dart';
import 'elite_roster_assignment_dialog.dart';
import 'elite_roster_tab.dart';
import 'elite_shifts_tab.dart';

/// Pantalla contenedora de alta densidad para el Submódulo 2: "Organización y Cuadrantes".
class EliteOrganizationShellScreen extends ConsumerStatefulWidget {
  const EliteOrganizationShellScreen({super.key});

  @override
  ConsumerState<EliteOrganizationShellScreen> createState() =>
      _EliteOrganizationShellScreenState();
}

class _EliteOrganizationShellScreenState
    extends ConsumerState<EliteOrganizationShellScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _currentTab) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shifts = ref.watch(rrhhShiftsProvider);
    final sites = ref.watch(rrhhClientSitesProvider);
    final roster = ref.watch(rrhhRosterProvider);
    final metrics = ref.watch(rrhhOrganizationMetricsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // -------------------------------------------------------------------
          // CABECERA SUPERIOR COMPACTA (FILA 1 + FILA 2)
          // -------------------------------------------------------------------
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              children: [
                // =============================================================
                // FILA 1 (~38px): Título + Botones de Acción
                // =============================================================
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Organización y Cuadrantes',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),

                      // Botón Outline: Exportar Malla
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: const Color(0xFF0F172A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              content: Text(
                                'Exportando Malla Operativa y Geocercas (${roster.length} asignaciones) en formato Excel/CSV...',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 15,
                          color: Color(0xFF475569),
                        ),
                        label: Text(
                          'Exportar Malla',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botón Primario: + Asignar Puesto
                      ElevatedButton.icon(
                        onPressed: () =>
                            EliteRosterAssignmentDialog.show(context),
                        icon: const Icon(
                          Icons.add_task_outlined,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Asignar Puesto',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 0,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                ),

                // =============================================================
                // FILA 2 (~36px en fila única): Pill Tabs (Izq) + Métricas (Der)
                // =============================================================
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Izquierda: Pill Tabs compactas
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildPillTab(
                                      index: 0,
                                      icon: Icons.alarm_outlined,
                                      label: 'Catálogo de Turnos',
                                      badgeText: '(${shifts.length})',
                                    ),
                                    _buildPillTab(
                                      index: 1,
                                      icon: Icons.share_location_outlined,
                                      label: 'Sedes y Geocercas',
                                      badgeText: '(${sites.length})',
                                    ),
                                    _buildPillTab(
                                      index: 2,
                                      icon: Icons.calendar_month_outlined,
                                      label: 'Malla de Cuadrantes',
                                      badgeText: '(${roster.length})',
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Derecha: Chips Métricos Inline (En la misma fila)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildMetricChip(
                                    icon: Icons.location_on_outlined,
                                    iconColor: const Color(0xFF2563EB),
                                    label:
                                        'Sedes Cubiertas: ${metrics.coveredSites} de ${metrics.totalSites}',
                                    bgColor: const Color(0xFFEFF6FF),
                                    borderColor: const Color(0xFFDBEAFE),
                                    textColor: const Color(0xFF1E40AF),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildMetricChip(
                                    icon: Icons.shield_outlined,
                                    iconColor: const Color(0xFF0D9488),
                                    label:
                                        'Puestos de Campo: ${metrics.fieldAssignments} asignados',
                                    bgColor: const Color(0xFFF0FDFA),
                                    borderColor: const Color(0xFFCCFBF1),
                                    textColor: const Color(0xFF0F766E),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildMetricChip(
                                    icon: Icons.verified_outlined,
                                    iconColor: const Color(0xFF16A34A),
                                    label:
                                        'Cobertura: ${metrics.coveragePercent.toStringAsFixed(0)}%',
                                    bgColor: const Color(0xFFF0FDF4),
                                    borderColor: const Color(0xFFDCFCE7),
                                    textColor: const Color(0xFF166534),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------------
          // ÁREA PRINCIPAL EN EXPANDED (80% DEL ESPACIO VISUAL ÚTIL)
          // -------------------------------------------------------------------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                EliteShiftsTab(),
                EliteClientSitesTab(),
                EliteRosterTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constructor de pestaña tipo Pill Tab compacta
  Widget _buildPillTab({
    required int index,
    required IconData icon,
    required String label,
    required String badgeText,
  }) {
    final isSelected = _currentTab == index;

    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
        setState(() => _currentTab = index);
      },
      borderRadius: BorderRadius.circular(4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color:
                  isSelected ? const Color(0xFF0D9488) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              badgeText,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Chip métrico compacto con ícono y texto con fondo suave
  Widget _buildMetricChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
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
