import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/rrhh_state_widgets.dart';
import '../widgets/rrhh_turnos_tab_schedules.dart';
import '../widgets/rrhh_turnos_tab_shifts.dart';

/// Pantalla 07: Catálogo de Horarios y Turnos Base.
/// Contenedor ejecutivo con 2 tabs: 1. Turnos, 2. Horarios Base.
/// Respeta estrictamente el patrón visual de RrhhPersonalView y RrhhOrganizationView.
class RrhhTurnosView extends StatefulWidget {
  final String? initialTab;
  final bool hasPermission;

  const RrhhTurnosView({
    super.key,
    this.initialTab,
    this.hasPermission = true,
  });

  @override
  State<RrhhTurnosView> createState() => _RrhhTurnosViewState();
}

class _RrhhTurnosViewState extends State<RrhhTurnosView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final tab = widget.initialTab?.toLowerCase();
    if (tab == 'horarios' || tab == 'plantillas' || tab == 'base') {
      tabIndex = 1;
    }

    _tabController = TabController(
      length: 2,
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
    if (!widget.hasPermission) {
      return const RrhhForbiddenState(
        requiredPermission: 'rrhh.shifts.view',
      );
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Tab 1: Turnos de Trabajo
              RrhhTurnosTabShifts(),
              // Tab 2: Horarios Base
              RrhhTurnosTabSchedules(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                child: const Icon(
                  Icons.schedule_rounded,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Turnos y Horarios Base',
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
                    'Catálogo de turnos de trabajo y horarios plantilla',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(
                icon: Icon(Icons.timer_outlined, size: 17),
                text: '1. Turnos',
              ),
              Tab(
                icon: Icon(Icons.date_range_outlined, size: 17),
                text: '2. Horarios Base',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
