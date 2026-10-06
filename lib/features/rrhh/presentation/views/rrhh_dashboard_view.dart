import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/rrhh_repository.dart';
import '../widgets/rrhh_dashboard_distribution_chart.dart';
import '../widgets/rrhh_dashboard_header.dart';
import '../widgets/rrhh_dashboard_kpi_card.dart';
import '../widgets/rrhh_dashboard_recent_movements.dart';
import '../widgets/rrhh_state_widgets.dart';

/// Pantalla 01: Dashboard Ejecutivo de Recursos Humanos (RRHH).
/// Centro de control de telemetría de personal, disponibilidad y alertas legales.
class RrhhDashboardView extends StatefulWidget {
  final bool hasPermission;

  const RrhhDashboardView({
    super.key,
    this.hasPermission = true,
  });

  @override
  State<RrhhDashboardView> createState() => _RrhhDashboardViewState();
}

class _RrhhDashboardViewState extends State<RrhhDashboardView> {
  bool _isLoading = true;
  String? _errorMessage;

  RrhhDashboardMetricsResponse? _metrics;
  List<RrhhRecentMovementDto> _recentMovements = [];

  @override
  void initState() {
    super.initState();
    if (widget.hasPermission) {
      _loadDashboardData();
    }
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = RrhhRepository.current;
      final metrics = await repository.getDashboardMetrics();
      final movements = await repository.getRecentMovements();

      if (mounted) {
        setState(() {
          _metrics = metrics;
          _recentMovements = movements;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error de conexión al cargar telemetría: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasPermission) {
      return const RrhhForbiddenState(
        requiredPermission: 'rrhh.dashboard.view',
      );
    }

    if (_errorMessage != null) {
      return RrhhErrorState(
        errorMessage: _errorMessage,
        onRetry: _loadDashboardData,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1120;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 24,
            vertical: isMobile ? 16 : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RrhhDashboardHeader(
                isMobile: isMobile,
                isLoading: _isLoading,
                onRefresh: _loadDashboardData,
              ),
              const SizedBox(height: 20),
              if (!_isLoading &&
                  (_metrics == null || _metrics!.totalEmployeesCount == 0))
                const RrhhEmptyState(
                  title: 'No existen métricas registradas',
                  description:
                      'El sistema no cuenta con registros de telemetría activa en este período.',
                )
              else ...[
                _buildKpiGrid(isMobile, isTablet),
                const SizedBox(height: 24),
                _buildOperationalSection(isMobile || isTablet),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildKpiGrid(bool isMobile, bool isTablet) {
    final m = _metrics;
    final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    final cards = [
      RrhhDashboardKpiCard(
        label: 'Personal Activo',
        value: m != null ? '${m.activeEmployeesCount} Colaboradores' : '0',
        subtext: m != null
            ? '(${m.fieldEmployeesCount} Campo / ${m.officeEmployeesCount} Ofic)'
            : '',
        icon: Icons.people_alt_outlined,
        accentColor: const Color(0xFF2563EB),
        badgeText: 'Nómina',
        isLoading: _isLoading,
      ),
      RrhhDashboardKpiCard(
        label: 'Disponibilidad',
        value: m != null ? '${m.todayAttendanceRate}%' : '0%',
        subtext: m != null ? '${m.activeLeavesCount} Permiso, 0 Bajas' : '',
        icon: Icons.event_available_outlined,
        accentColor: const Color(0xFF10B981),
        badgeText: 'Operativo',
        badgeColor: const Color(0xFF10B981),
        isLoading: _isLoading,
      ),
      RrhhDashboardKpiCard(
        label: 'Expedientes Compl.',
        value: m != null ? '${m.expedientesPercentage}%' : '0%',
        subtext: m != null
            ? '${m.completeFilesCount} de ${m.totalEmployeesCount} Físicos'
            : '',
        icon: Icons.folder_shared_outlined,
        accentColor: const Color(0xFF7C3AED),
        badgeText: 'Al Día',
        badgeColor: const Color(0xFF7C3AED),
        isLoading: _isLoading,
      ),
      RrhhDashboardKpiCard(
        label: 'Contratos x Vencer',
        value: m != null ? '${m.expiringContractsCount} Próximos 30d' : '0',
        subtext: 'Alerta Preventiva Legal',
        icon: Icons.assignment_late_outlined,
        accentColor: const Color(0xFFEF4444),
        badgeText: 'Alerta',
        badgeColor: const Color(0xFFEF4444),
        isLoading: _isLoading,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 2.4 : (isTablet ? 2.2 : 1.95),
      children: cards,
    );
  }

  Widget _buildOperationalSection(bool stackVertical) {
    final m = _metrics;
    final int activeCount = m?.activeEmployeesCount ?? 25;
    final int onLeave = m?.activeLeavesCount ?? 2;
    final int available = (activeCount - onLeave).clamp(0, activeCount);

    final distribution = RrhhDashboardDistributionChart(
      activeEmployees: activeCount,
      availableCount: available,
      onLeaveCount: onLeave,
      suspendedCount: 0,
      isLoading: _isLoading,
    );

    final movements = RrhhDashboardRecentMovements(
      movements: _recentMovements,
      isLoading: _isLoading,
    );

    if (stackVertical) {
      return Column(
        children: [
          distribution,
          const SizedBox(height: 20),
          movements,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: distribution),
        const SizedBox(width: 20),
        Expanded(flex: 4, child: movements),
      ],
    );
  }
}
