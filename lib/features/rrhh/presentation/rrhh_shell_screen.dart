import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/navigation/web_url_sync.dart';
import '../../security/services/auth_service.dart';
import '../rrhh_routes.dart';

/// Shell principal de navegación para el módulo de Recursos Humanos (RRHH).
/// Totalmente desacoplado e independiente, con estética ejecutiva suiza.
class RrhhShellScreen extends StatefulWidget {
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
  State<RrhhShellScreen> createState() => _RrhhShellScreenState();
}

class _RrhhShellScreenState extends State<RrhhShellScreen> {
  static const List<String> _tabSlugs = [
    'rrhh/dashboard',
    'rrhh/personal',
    'rrhh/organizacion',
    'rrhh/novedades',
    'rrhh/asistencia',
    'rrhh/turnos',
    'rrhh/nomina',
    'rrhh/reportes',
    'rrhh/catalogos',
  ];

  int _selectedIndex = 0;
  String? _currentSubTab;

  static int _indexFromRouteOrHash(String raw) {
    final clean = raw.toLowerCase().replaceAll('#', '').replaceAll('/', '-').trim();
    if (clean.contains('dashboard')) return 0;
    if (clean.contains('personal') || clean.contains('directorio') || clean.contains('postulante') || clean.contains('contrataci')) return 1;
    if (clean.contains('organizacion') || clean.contains('area') || clean.contains('cargo')) return 2;
    if (clean.contains('novedad') || clean.contains('permiso') || clean.contains('vacacion') || clean.contains('disciplina') || clean.contains('baja')) return 3;
    if (clean.contains('asistencia')) return 4;
    if (clean.contains('turno') || clean.contains('horario')) return 5;
    if (clean.contains('nomina')) return 6;
    if (clean.contains('reporte') || clean.contains('bitacora') || clean.contains('auditoria')) return 7;
    if (clean.contains('catalogo')) return 8;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    final initialHash = getBrowserHash();
    if (initialHash.isNotEmpty) {
      _selectedIndex = _indexFromRouteOrHash(initialHash);
    }
    listenBrowserHashChange((newHash) {
      if (mounted) {
        final newIndex = _indexFromRouteOrHash(newHash);
        if (newIndex != _selectedIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        }
      }
    });
  }

  void _onTabSelected(int index, {bool isDrawer = false, String? subTab}) {
    if (_selectedIndex != index || _currentSubTab != subTab) {
      setState(() {
        _selectedIndex = index;
        _currentSubTab = subTab;
      });
      if (index >= 0 && index < _tabSlugs.length) {
        setBrowserHash('/${_tabSlugs[index]}');
      }
    }

    if (isDrawer && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return RrhhRoutes.buildTopLevelView(RrhhRoutes.dashboard);
      case 1:
        return RrhhRoutes.buildTopLevelView(
          RrhhRoutes.personal,
          tab: _currentSubTab,
          onNavigateToTab: (tabIdx) {
            // handle navigation to sub-tab
          },
        );
      case 2:
        return RrhhRoutes.buildTopLevelView(RrhhRoutes.organizacion, tab: _currentSubTab);
      case 3:
        return RrhhRoutes.buildTopLevelView(
          RrhhRoutes.novedades,
          tab: _currentSubTab,
          onNavigateToTab: (idx) {},
        );
      case 4:
        return RrhhRoutes.buildTopLevelView(RrhhRoutes.asistenciaCampo);
      case 5:
        return RrhhRoutes.buildView(RrhhRoutes.turnos);
      case 6:
        return RrhhRoutes.buildView(RrhhRoutes.novedadesNomina);
      case 7:
        return RrhhRoutes.buildTopLevelView(RrhhRoutes.reportes, tab: _currentSubTab);
      case 8:
        return RrhhRoutes.buildTopLevelView(RrhhRoutes.catalogos);
      default:
        return RrhhRoutes.buildTopLevelView(RrhhRoutes.dashboard);
    }
  }

  Future<void> _confirmAndLogout() async {
    final isDark = widget.isDarkMode;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Color(0xFFEF4444),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar tu sesión en el módulo RRHH?',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cerrar Sesión',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      if (widget.authService != null) {
        await widget.authService!.logout();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    final navItems = [
      _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', 'Métricas y KPIs'),
      _NavItem(Icons.people_outline, Icons.people, 'Personal', 'Directorio y Expedientes'),
      _NavItem(Icons.account_tree_outlined, Icons.account_tree, 'Organización', 'Áreas y Cargos'),
      _NavItem(Icons.assignment_outlined, Icons.assignment, 'Novedades', 'Permisos y Sanciones'),
      _NavItem(Icons.how_to_reg_outlined, Icons.how_to_reg, 'Asistencias', 'Control de Campo'),
      _NavItem(Icons.calendar_month_outlined, Icons.calendar_month, 'Turnos & Horarios', 'Cuadrantes'),
      _NavItem(Icons.payments_outlined, Icons.payments, 'Nómina', 'Control de Sueldos'),
      _NavItem(Icons.history_outlined, Icons.history, 'Auditoría', 'Bitácora y Trazabilidad'),
      _NavItem(Icons.settings_suggest_outlined, Icons.settings_suggest, 'Catálogos', 'Tablas Maestras'),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              child: SafeArea(
                child: _buildSidebarContent(navItems, isDrawer: true),
              ),
            ),
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 270,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                border: Border(
                  right: BorderSide(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: _buildSidebarContent(navItems, isDrawer: false),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDesktop),
                Expanded(
                  child: _buildBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    final isDark = widget.isDarkMode;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'RRHH v2.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Módulo de Recursos Humanos',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (widget.onToggleTheme != null)
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                size: 20,
              ),
              tooltip: isDark ? 'Modo Claro' : 'Modo Oscuro',
              onPressed: widget.onToggleTheme,
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFEF4444),
              size: 20,
            ),
            tooltip: 'Cerrar Sesión',
            onPressed: _confirmAndLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(List<_NavItem> navItems, {required bool isDrawer}) {
    final isDark = widget.isDarkMode;
    return Column(
      children: [
        // Brand header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ELITE MULTISERVICIOS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Gestión de Talento',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Nav items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            itemCount: navItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, idx) {
              final item = navItems[idx];
              final isSelected = _selectedIndex == idx;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onTabSelected(idx, isDrawer: isDrawer),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(
                              color: isDark
                                  ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                                  : const Color(0xFFBFDBFE),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 20,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected
                                      ? (isDark ? Colors.white : const Color(0xFF1E3A8A))
                                      : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                                ),
                              ),
                              Text(
                                item.subtitle,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2563EB),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final String subtitle;

  const _NavItem(this.icon, this.activeIcon, this.title, this.subtitle);
}
