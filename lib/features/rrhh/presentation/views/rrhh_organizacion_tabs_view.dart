import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rrhh_placeholder_view.dart';

/// Vista contenedora de Organización y Turnos (Entrada 03 del menú RRHH).
/// Agrupa:
/// - Tab 1: Áreas Corporativas (Pantalla 06)
/// - Tab 2: Cargos y Especialidades
/// - Tab 3: Turnos y Horarios Base (Pantalla 07)
class RrhhOrganizacionTabsView extends StatefulWidget {
  final String? initialTab;
  final void Function(int index)? onNavigateToTab;

  const RrhhOrganizacionTabsView({
    super.key,
    this.initialTab,
    this.onNavigateToTab,
  });

  @override
  State<RrhhOrganizacionTabsView> createState() =>
      _RrhhOrganizacionTabsViewState();
}

class _RrhhOrganizacionTabsViewState extends State<RrhhOrganizacionTabsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final tab = widget.initialTab?.toLowerCase();
    if (tab == 'cargos' || tab == 'especialidades') {
      tabIndex = 1;
    } else if (tab == 'turnos' || tab == 'horarios') {
      tabIndex = 2;
    }

    _tabController = TabController(
      length: 3,
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
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
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
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_tree_outlined,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '03. Organización y Turnos',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Estructura de áreas, cargos operativos y catálogo de turnos base',
                        style: GoogleFonts.inter(
                          fontSize: 12,
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
                    icon: Icon(Icons.corporate_fare_outlined, size: 18),
                    text: 'Áreas',
                  ),
                  Tab(
                    icon: Icon(Icons.work_outline, size: 18),
                    text: 'Cargos y Especialidades',
                  ),
                  Tab(
                    icon: Icon(Icons.schedule_outlined, size: 18),
                    text: 'Turnos y Horarios Base',
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
              RrhhPlaceholderView(
                title: '06. Áreas Corporativas',
                blockName: 'Bloque 2',
                description:
                    'Administración de departamentos y áreas funcionales de la organización.',
                icon: Icons.corporate_fare_outlined,
              ),
              RrhhPlaceholderView(
                title: '06. Cargos y Especialidades Técnicas',
                blockName: 'Bloque 2',
                description:
                    'Administración de puestos de trabajo y especialidades operativas de campo.',
                icon: Icons.work_outline,
              ),
              RrhhPlaceholderView(
                title: '07. Catálogo de Horarios y Turnos Base',
                blockName: 'Bloque 2',
                description:
                    'Gestión del catálogo oficial de jornadas y turnos de trabajo que RRHH publica para Operaciones.',
                icon: Icons.schedule_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
