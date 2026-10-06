import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/rrhh_hiring_dossiers_tab.dart';
import '../widgets/rrhh_personal_directorio_tab.dart';
import '../widgets/rrhh_recruitment_tab.dart';
import '../widgets/rrhh_snack_bar.dart';
import '../widgets/rrhh_state_widgets.dart';
import 'rrhh_hiring_dossier_detail_view.dart';

/// Vista raíz de Gestión de Personal (Entrada 02 del acordeón RRHH).
/// Contenedor ejecutivo con 3 tabs: Directorio, Reclutamiento y Contrataciones en Curso.
class RrhhPersonalView extends StatefulWidget {
  final String? initialTab;
  final int? initialDossierId;
  final bool hasPermission;
  final bool canManage;
  final bool canModifyContract;
  final void Function(int index)? onNavigateToTab;

  const RrhhPersonalView({
    super.key,
    this.initialTab,
    this.initialDossierId,
    this.hasPermission = true,
    this.canManage = true,
    this.canModifyContract = true,
    this.onNavigateToTab,
  });

  @override
  State<RrhhPersonalView> createState() => _RrhhPersonalViewState();
}

class _RrhhPersonalViewState extends State<RrhhPersonalView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int? _selectedDossierId;

  @override
  void initState() {
    super.initState();
    _selectedDossierId = widget.initialDossierId;

    int tabIndex = 0;
    final init = widget.initialTab?.toLowerCase();
    if (init == 'reclutamiento' || init == 'postulantes') {
      tabIndex = 1;
    } else if (init == 'contrataciones' ||
        init == 'contrataciones_en_curso' ||
        init == 'expediente' ||
        widget.initialDossierId != null) {
      tabIndex = 2;
    }

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: tabIndex,
    );
  }

  @override
  void didUpdateWidget(covariant RrhhPersonalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab &&
        widget.initialTab != null) {
      final init = widget.initialTab?.toLowerCase();
      int newIndex = 0;
      if (init == 'reclutamiento' || init == 'postulantes') {
        newIndex = 1;
      } else if (init == 'contrataciones' ||
          init == 'contrataciones_en_curso' ||
          init == 'expediente' ||
          widget.initialDossierId != null) {
        newIndex = 2;
      }
      if (_tabController.index != newIndex) {
        _tabController.animateTo(newIndex);
      }
    }
    if (widget.initialDossierId != oldWidget.initialDossierId &&
        widget.initialDossierId != null) {
      setState(() {
        _selectedDossierId = widget.initialDossierId;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasPermission) {
      return const RrhhForbiddenState(requiredPermission: 'rrhh.personal.view');
    }

    // Si hay un expediente seleccionado, mostramos la vista completa del expediente
    if (_selectedDossierId != null) {
      return RrhhHiringDossierDetailView(
        dossierId: _selectedDossierId!,
        onBack: () {
          setState(() {
            _selectedDossierId = null;
          });
        },
        onEmployeeCreated: (empCode) {
          setState(() {
            _selectedDossierId = null;
            _tabController.animateTo(0);
          });
          RrhhSnackBar.showSuccess(
            context,
            'Empleado creado exitosamente con código $empCode',
          );
        },
      );
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Directorio (Pantalla 02)
              RrhhPersonalDirectorioTab(
                canManage: widget.canManage,
                canModifyContract: widget.canModifyContract,
              ),

              // Tab 2: Reclutamiento & Postulantes (Pantalla 04)
              const RrhhRecruitmentTab(),

              // Tab 3: Contrataciones en Curso (NUEVA - FASE C1)
              RrhhHiringDossiersTab(
                onOpenDossier: (dossierId) {
                  setState(() {
                    _selectedDossierId = dossierId;
                  });
                },
              ),
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
          Text(
            'Gestión de Personal',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Directorio oficial de colaboradores, reclutamiento y contrataciones en curso',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
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
                    Icon(Icons.people_alt_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('Directorio'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_search_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('Reclutamiento'),
                  ],
                ),
              ),
              Tab(
                height: 38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment_outlined, size: 15),
                    SizedBox(width: 6),
                    Text('Contrataciones en Curso'),
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
