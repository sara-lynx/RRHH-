import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/rrhh_disciplinary_view.dart';
import '../widgets/rrhh_leave_requests_view.dart';
import '../widgets/rrhh_vacations_view.dart';
import '../widgets/rrhh_terminations_view.dart';
import '../widgets/rrhh_payroll_view.dart';

/// Vista contenedora de Novedades Laborales (Entrada 04 del menú RRHH).
/// Agrupa:
/// - Tab 1: Permisos y Licencias (Pantalla 08)
/// - Tab 2: Control de Vacaciones (Pantalla 09)
/// - Tab 3: Régimen Disciplinario e Incidencias (Pantalla 10)
/// - Tab 4: Desvinculaciones y Bajas (Pantalla 11)
/// - Tab 5: Novedades para Nómina (Pantalla 12)
class RrhhNovedadesTabsView extends StatefulWidget {
  final String? initialTab;
  final void Function(int index)? onNavigateToTab;

  const RrhhNovedadesTabsView({
    super.key,
    this.initialTab,
    this.onNavigateToTab,
  });

  @override
  State<RrhhNovedadesTabsView> createState() => _RrhhNovedadesTabsViewState();
}

class _RrhhNovedadesTabsViewState extends State<RrhhNovedadesTabsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final tab = widget.initialTab?.toLowerCase();
    if (tab == 'vacaciones') {
      tabIndex = 1;
    } else if (tab == 'incidencias' || tab == 'disciplina') {
      tabIndex = 2;
    } else if (tab == 'bajas' ||
        tab == 'desvinculaciones' ||
        tab == 'finiquitos') {
      tabIndex = 3;
    } else if (tab == 'nomina' ||
        tab == 'novedades_nomina' ||
        tab == 'novedades-nomina') {
      tabIndex = 4;
    }

    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: tabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Encabezado y Barra de Pestañas
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF090D16) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Novedades Laborales',
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFF8FAFC)
                              : const Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Control de permisos, vacaciones, incidencias y desvinculaciones',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFF2563EB),
                indicatorWeight: 2.5,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                labelStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fact_check_outlined, size: 15),
                        SizedBox(width: 6),
                        Text('1. Permisos'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.beach_access_outlined, size: 15),
                        SizedBox(width: 6),
                        Text('2. Vacaciones'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gavel_outlined, size: 15),
                        SizedBox(width: 6),
                        Text('3. Incidencias'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_remove_outlined, size: 15),
                        SizedBox(width: 6),
                        Text('4. Desvinculaciones'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 15),
                        SizedBox(width: 6),
                        Text('5. Novedades para Nómina'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Contenido de cada Tab
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              RrhhLeaveRequestsView(),
              RrhhVacationsView(),
              RrhhDisciplinaryView(),
              RrhhTerminationsView(),
              RrhhPayrollView(),
            ],
          ),
        ),
      ],
    );
  }
}
