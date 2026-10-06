import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/rrhh_organization_tab_areas.dart';
import '../widgets/rrhh_organization_tab_positions.dart';
import '../widgets/rrhh_organization_tab_specialties.dart';
import '../widgets/rrhh_state_widgets.dart';
import '../widgets/rrhh_turnos_tab_schedules.dart';
import '../widgets/rrhh_turnos_tab_shifts.dart';

/// Pantalla 06 / 07: Organización y Turnos.
/// Contenedor ejecutivo que agrupa:
/// 1. Áreas Departamentales
/// 2. Cargos de Trabajo
/// 3. Especialidades Operativas
/// 4. Turnos de Trabajo
/// 5. Horarios Base (Plantillas)
class RrhhOrganizationView extends StatefulWidget {
  final String? initialTab;
  final bool hasPermission;

  const RrhhOrganizationView({
    super.key,
    this.initialTab,
    this.hasPermission = true,
  });

  @override
  State<RrhhOrganizationView> createState() => _RrhhOrganizationViewState();
}

class _RrhhOrganizationViewState extends State<RrhhOrganizationView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final tab = widget.initialTab?.toLowerCase();
    if (tab == 'cargos' || tab == 'puestos') {
      tabIndex = 1;
    } else if (tab == 'especialidades' || tab == 'tecnicas') {
      tabIndex = 2;
    } else if (tab == 'turnos' || tab == 'turno') {
      tabIndex = 3;
    } else if (tab == 'horarios' || tab == 'base' || tab == 'plantillas') {
      tabIndex = 4;
    }

    _activeTabIndex = tabIndex;
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: tabIndex,
    );

    _tabController.addListener(() {
      if (_tabController.index != _activeTabIndex) {
        setState(() {
          _activeTabIndex = _tabController.index;
        });
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
    if (!widget.hasPermission) {
      return const RrhhForbiddenState(
        requiredPermission: 'rrhh.organization.view',
      );
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Tab 1: Áreas Departamentales
              RrhhOrganizationTabAreas(),
              // Tab 2: Cargos de Trabajo
              RrhhOrganizationTabPositions(),
              // Tab 3: Especialidades Operativas
              RrhhOrganizationTabSpecialties(),
              // Tab 4: Turnos de Trabajo
              RrhhTurnosTabShifts(),
              // Tab 5: Horarios Base
              RrhhTurnosTabSchedules(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isShiftsSection = _activeTabIndex >= 3;

    final title = isShiftsSection
        ? 'Turnos y Horarios Base'
        : 'Estructura Organizacional';
    final subtitle = isShiftsSection
        ? 'Catálogo de turnos de trabajo y horarios plantilla'
        : 'Catálogos maestros de áreas, cargos y especialidades';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF090D16) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
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
                child: Icon(
                  isShiftsSection
                      ? Icons.schedule_rounded
                      : Icons.account_tree_outlined,
                  color: const Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                    subtitle,
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
                    Icon(Icons.corporate_fare_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('1. Áreas'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.badge_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('2. Cargos'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('3. Especialidades'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('4. Turnos'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('5. Horarios Base'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
