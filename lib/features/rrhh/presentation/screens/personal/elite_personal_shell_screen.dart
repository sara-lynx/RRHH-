import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/elite_recruitment_providers.dart';
import '../../providers/elite_rrhh_providers.dart';
import '../../widgets/elite_employee_form_dialog.dart';
import 'elite_employee_directory_tab.dart';
import 'elite_hiring_wizard_tab.dart';
import 'elite_recruitment_kanban_tab.dart';

/// Pantalla contenedora de alta densidad para el Submódulo de Personal y Reclutamiento de RRHH.
/// Organizada en 3 pestañas principales: Directorio, Reclutamiento (Kanban) y Contrataciones (Wizard).
class ElitePersonalShellScreen extends ConsumerStatefulWidget {
  const ElitePersonalShellScreen({super.key});

  @override
  ConsumerState<ElitePersonalShellScreen> createState() =>
      _ElitePersonalShellScreenState();
}

class _ElitePersonalShellScreenState
    extends ConsumerState<ElitePersonalShellScreen>
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
    final metrics = ref.watch(rrhhMetricsProvider);
    final totalEmployees = metrics.total;
    final recruitmentMetrics = ref.watch(rrhhRecruitmentMetricsProvider);
    final selectedForHiring =
        ref.watch(rrhhSelectedApplicantsForHiringProvider);

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
                // FILA 1 (~42px): Título + Botones de Acción según pestaña
                // =============================================================
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Gestión de Personal & Talento',
                        style: GoogleFonts.inter(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          _currentTab == 0
                              ? 'Directorio Oficial'
                              : _currentTab == 1
                                  ? 'Embudo de Selección'
                                  : 'Legajos & Alta',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Botones contextuales
                      if (_currentTab == 0) ...[
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
                                  'Exportando directorio oficial ($totalEmployees registros) en formato Excel/CSV...',
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
                            'Exportar Directorio',
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
                        ElevatedButton.icon(
                          onPressed: () =>
                              EliteEmployeeFormDialog.show(context),
                          icon: const Icon(
                            Icons.person_add_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Nuevo Colaborador',
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
                    ],
                  ),
                ),

                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                // =============================================================
                // FILA 2 (~38px): Pill Tabs (Izq) + Métricas contextuales (Der)
                // =============================================================
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Izquierda: 3 Pill Tabs solicitadas
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildPillTab(
                                      index: 0,
                                      icon: Icons.badge_outlined,
                                      label: 'Directorio',
                                      badgeText: '(${metrics.active})',
                                    ),
                                    _buildPillTab(
                                      index: 1,
                                      icon: Icons.view_kanban_outlined,
                                      label: 'Reclutamiento',
                                      badgeText:
                                          '(${recruitmentMetrics.active})',
                                    ),
                                    _buildPillTab(
                                      index: 2,
                                      icon: Icons.how_to_reg_outlined,
                                      label: 'Contrataciones',
                                      badgeText: '(${selectedForHiring.length})',
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Derecha: Chips Métricos contextuales según pestaña activa
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_currentTab == 0) ...[
                                    _buildMetricChip(
                                      icon: Icons.apartment_outlined,
                                      iconColor: const Color(0xFF2563EB),
                                      label: 'Oficina: ${metrics.office}',
                                      bgColor: const Color(0xFFEFF6FF),
                                      borderColor: const Color(0xFFDBEAFE),
                                      textColor: const Color(0xFF1E40AF),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildMetricChip(
                                      icon: Icons.engineering_outlined,
                                      iconColor: const Color(0xFF0D9488),
                                      label: 'Campo: ${metrics.field}',
                                      bgColor: const Color(0xFFF0FDFA),
                                      borderColor: const Color(0xFFCCFBF1),
                                      textColor: const Color(0xFF0F766E),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildMetricChip(
                                      icon: Icons.verified_user_outlined,
                                      iconColor: const Color(0xFF16A34A),
                                      label: 'Activos: ${metrics.active}',
                                      bgColor: const Color(0xFFF0FDF4),
                                      borderColor: const Color(0xFFDCFCE7),
                                      textColor: const Color(0xFF166534),
                                    ),
                                  ] else if (_currentTab == 1) ...[
                                    _buildMetricChip(
                                      icon: Icons.people_outline,
                                      iconColor: const Color(0xFF0284C7),
                                      label: 'Postulantes: ${recruitmentMetrics.total}',
                                      bgColor: const Color(0xFFF0F9FF),
                                      borderColor: const Color(0xFFE0F2FE),
                                      textColor: const Color(0xFF0369A1),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildMetricChip(
                                      icon: Icons.schedule_outlined,
                                      iconColor: const Color(0xFFD97706),
                                      label: 'En Proceso: ${recruitmentMetrics.active}',
                                      bgColor: const Color(0xFFFFFBEB),
                                      borderColor: const Color(0xFFFEF3C7),
                                      textColor: const Color(0xFFB45309),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildMetricChip(
                                      icon: Icons.check_circle_outline,
                                      iconColor: const Color(0xFF059669),
                                      label: 'Seleccionados: ${recruitmentMetrics.selected}',
                                      bgColor: const Color(0xFFECFDF5),
                                      borderColor: const Color(0xFFA7F3D0),
                                      textColor: const Color(0xFF047857),
                                    ),
                                  ] else ...[
                                    _buildMetricChip(
                                      icon: Icons.person_search_outlined,
                                      iconColor: const Color(0xFF2563EB),
                                      label: 'Por Contratar: ${selectedForHiring.length}',
                                      bgColor: const Color(0xFFEFF6FF),
                                      borderColor: const Color(0xFFDBEAFE),
                                      textColor: const Color(0xFF1E40AF),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildMetricChip(
                                      icon: Icons.folder_shared_outlined,
                                      iconColor: const Color(0xFF059669),
                                      label:
                                          'Legajo Completo: ${selectedForHiring.where((a) => a.legalChecklist.isComplete).length}',
                                      bgColor: const Color(0xFFECFDF5),
                                      borderColor: const Color(0xFFA7F3D0),
                                      textColor: const Color(0xFF047857),
                                    ),
                                  ],
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
                EliteEmployeeDirectoryTab(),
                EliteRecruitmentKanbanTab(),
                EliteHiringWizardTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 3,
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
              color: isSelected
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              badgeText,
              style: GoogleFonts.inter(
                fontSize: 10.5,
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
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
