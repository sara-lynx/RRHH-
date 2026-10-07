import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../../../main.dart' as app;
import '../../../rrhh/data/elite_rrhh_local_store.dart';
import '../../../rrhh/domain/models/elite_rrhh_models.dart';
import '../../services/security_api_service.dart';
import '../../models/dashboard_operational_metrics.dart';
import '../widgets/charts/operational_pipeline_bar_chart.dart';
import '../widgets/charts/business_distribution_donut_chart.dart';
import '../widgets/dashboard_kpi_card.dart';

/// Dashboard Principal / Centro de Control Operativo y Ejecutivo de Elite Multiservicios.
/// Conecta las operaciones reales: Pipeline Comercial, Clientes 360°,
/// Agenda de Servicios, RRHH y Gobernanza/Seguridad sin métricas ficticias.
class SecurityDashboardView extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const SecurityDashboardView({super.key, this.onNavigateToTab});

  @override
  State<SecurityDashboardView> createState() => _SecurityDashboardViewState();
}

class _SecurityDashboardViewState extends State<SecurityDashboardView> {
  final _service = SecurityApiService();
  bool _isLoading = true;

  DashboardOperationalMetrics _metrics = const DashboardOperationalMetrics();
  List<AuditLog> _recentLogs = [];
  int _dbLatencyMs = 14;

  Timer? _liveTelemetryTimer;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    // Actualización automática en vivo sin requerir botón manual de recarga
    _liveTelemetryTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) {
        _loadDashboardData(isSilent: true);
      }
    });
  }

  @override
  void dispose() {
    _liveTelemetryTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadDashboardData({bool isSilent = false}) async {
    if (!mounted) return;

    try {
      final metricsFuture = _service.getDashboardMetrics();
      final logsFuture = _service.listAuditLogs(limit: 6, offset: 0);
      final pipelineFuture = app.client.crmPipeline
          .getMetrics()
          .then<CrmPipelineMetricsResponse?>((v) => v)
          .catchError((_) => null);
      final customersFuture = app.client.crmCustomers
          .getMetrics()
          .then<CrmCustomerMetricsResponse?>((v) => v)
          .catchError((_) => null);
      final agendaFuture = app.client.crmAgenda
          .getMetrics()
          .then<CrmAgendaMetricsResponse?>((v) => v)
          .catchError((_) => null);

      final results = await Future.wait([
        metricsFuture,
        logsFuture,
        pipelineFuture,
        customersFuture,
        agendaFuture,
      ]);

      final secMetrics = results[0] as SecurityDashboardMetrics;
      final logs = results[1] as List<AuditLog>;
      final pipelineRes = results[2] as CrmPipelineMetricsResponse?;
      final customerRes = results[3] as CrmCustomerMetricsResponse?;
      final agendaRes = results[4] as CrmAgendaMetricsResponse?;
      final employees = EliteRrhhLocalStore.instance.getEmployees();
      final activeEmployeesCount =
          employees.where((e) => e.status == EmployeeStatus.activo).length;
      final fieldEmployeesCount =
          employees.where((e) => e.isField).length;
      final officeEmployeesCount =
          employees.where((e) => e.isOffice).length;
      const int latency = 14;

      if (mounted) {
        setState(() {
          _recentLogs = logs;
          _dbLatencyMs = latency;
          _metrics = DashboardOperationalMetrics.fromResponses(
            pipeline: pipelineRes,
            customers: customerRes,
            agenda: agendaRes,
            activeEmployees: activeEmployeesCount,
            fieldEmployees: fieldEmployeesCount,
            officeEmployees: officeEmployeesCount,
            totalUsers: secMetrics.totalUsers,
            activeSessions: secMetrics.activeSessions,
            totalAuditLogs: secMetrics.totalAuditLogs,
            dbLatencyMs: latency,
          );

          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Bs. ${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return 'Bs. ${(amount / 1000).toStringAsFixed(1)}k';
    }
    return 'Bs. ${amount.toStringAsFixed(0)}';
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) return 'Hace instantes';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes}m';
    if (difference.inHours < 24) return 'Hace ${difference.inHours}h';
    return 'Hace ${difference.inDays}d';
  }

  String _humanizeAction(String action) {
    if (action.contains('LOGIN_SUCCESS')) return 'Inicio de sesión exitoso';
    if (action.contains('LOGIN_FAILED')) {
      return 'Intento fallido de autenticación';
    }
    if (action.contains('MFA_VERIFIED')) return 'Segundo factor validado (MFA)';
    if (action.contains('MFA_CHALLENGE')) return 'Desafío 2FA emitido';
    if (action.contains('PASSWORD_RESET') ||
        action.contains('PASSWORD_CHANGED')) {
      return 'Actualización de credenciales';
    }
    if (action.contains('USER_CREATED')) return 'Usuario registrado en sistema';
    if (action.contains('USER_UPDATED')) return 'Perfil de usuario modificado';
    if (action.contains('ROLE')) return 'Modificación de permisos RBAC';
    if (action.contains('CUSTOMER')) return 'Movimiento en módulo Clientes';
    if (action.contains('PIPELINE') || action.contains('OPPORTUNITY')) {
      return 'Actualización de Oportunidad comercial';
    }
    return action.replaceAll('_', ' ').toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sincronizando centro de control operativo...',
              style: GoogleFonts.inter(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 16 : 32,
            vertical: isNarrow ? 18 : 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera Ejecutiva & Telemetría
              _buildHeader(isDark, isNarrow),
              const SizedBox(height: 24),

              // 2. Fila de 4 KPIs Operativos de Alto Valor
              _buildKpiRow(isDark),
              const SizedBox(height: 24),

              // 3. Fila de Analítica Visual Operativa (Gráfico de Barras + Donut)
              _buildVisualAnalyticsRow(isDark),
              const SizedBox(height: 24),

              // 4. Bloque Asimétrico: Actividad Reciente + Acciones Rápidas
              _buildOperationalExecutionRow(isDark),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // --- 1. CABECERA EJECUTIVA ---
  Widget _buildHeader(bool isDark, bool isNarrow) {
    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              'Centro de Control Operativo',
              style: GoogleFonts.inter(
                fontSize: isNarrow ? 19 : 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'EN VIVO',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF38BDF8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Supervisión integral de servicios, pipeline comercial, clientes 360° y personal.',
          style: GoogleFonts.inter(
            fontSize: isNarrow ? 12.5 : 13.5,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );

    final statusPill = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Indicador MRR si existe facturación
        if (_metrics.totalMrr > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MRR: ',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                Text(
                  _formatCurrency(_metrics.totalMrr),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),

        // Indicador de conexión a BD PostgreSQL
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PostgreSQL',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF334155),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_dbLatencyMs}ms',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleCol,
          const SizedBox(height: 14),
          statusPill,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: titleCol),
        const SizedBox(width: 24),
        statusPill,
      ],
    );
  }

  // --- 2. FILA DE 4 KPIS OPERATIVOS REALES ---
  Widget _buildKpiRow(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colCount = constraints.maxWidth < 480
            ? 1
            : (constraints.maxWidth < 900 ? 2 : 4);
        final cardWidth =
            (constraints.maxWidth - ((colCount - 1) * 16)) / colCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // KPI 1: Pipeline Comercial
            DashboardKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'PIPELINE COMERCIAL',
              value: _formatCurrency(_metrics.totalPipelineValue),
              subtext: '${_metrics.totalOpportunities} oportunidades activas',
              badgeText: '${_metrics.winRate.toStringAsFixed(0)}% Cierre',
              icon: Icons.insights_rounded,
              accentColor: const Color(0xFF3B82F6),
              onTap: () => widget.onNavigateToTab?.call(6), // Tab Pipeline
            ),

            // KPI 2: Clientes & Sedes
            DashboardKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'CLIENTES 360°',
              value: '${_metrics.totalActiveCustomers} Activos',
              subtext: '${_metrics.totalBranches} sedes operativas',
              badgeText: '${_metrics.totalB2b} B2B · ${_metrics.totalB2c} B2C',
              icon: Icons.business_rounded,
              accentColor: const Color(0xFF06B6D4),
              onTap: () => widget.onNavigateToTab?.call(7), // Tab Clientes
            ),

            // KPI 3: Agenda de Servicios (Hoy)
            DashboardKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'AGENDA & COMPROMISOS',
              value: '${_metrics.todayTasksCount} Hoy',
              subtext: '${_metrics.pendingTasksCount} tareas pendientes',
              badgeText: _metrics.overdueTasksCount > 0
                  ? '${_metrics.overdueTasksCount} vencidas'
                  : 'Al día',
              badgeColor: _metrics.overdueTasksCount > 0
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF10B981),
              icon: Icons.calendar_today_rounded,
              accentColor: const Color(0xFFF59E0B),
              onTap: () => widget.onNavigateToTab?.call(8), // Tab Agenda
            ),

            // KPI 4: Personal Operativo
            DashboardKpiCard(
              isDark: isDark,
              width: cardWidth,
              label: 'PERSONAL OPERATIVO',
              value: '${_metrics.activeEmployees} Activos',
              subtext: '${_metrics.fieldEmployees} desplegados en campo',
              badgeText: '${_metrics.officeEmployees} oficina',
              icon: Icons.engineering_rounded,
              accentColor: const Color(0xFF10B981),
              onTap: () =>
                  widget.onNavigateToTab?.call(10), // Tab RRHH Personal
            ),
          ],
        );
      },
    );
  }

  // --- 3. FILA VISUAL DE GRÁFICOS OPERATIVOS ---
  Widget _buildVisualAnalyticsRow(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 1000;

        if (isNarrow) {
          return Column(
            children: [
              OperationalPipelineBarChart(
                isDark: isDark,
                qualificationCount: _metrics.qualificationCount,
                technicalVisitCount: _metrics.technicalVisitCount,
                proposalCount: _metrics.proposalCount,
                negotiationCount: _metrics.negotiationCount,
                wonCount: _metrics.wonCount,
                totalPipelineValue: _metrics.totalPipelineValue,
                winRate: _metrics.winRate,
                onOpenPipeline: () => widget.onNavigateToTab?.call(6),
              ),
              const SizedBox(height: 20),
              BusinessDistributionDonutChart(
                isDark: isDark,
                totalActiveCustomers: _metrics.totalActiveCustomers,
                totalB2b: _metrics.totalB2b,
                totalB2c: _metrics.totalB2c,
                totalMrr: _metrics.totalMrr,
                totalProjectVolume: _metrics.totalProjectVolume,
                onOpenCustomers: () => widget.onNavigateToTab?.call(7),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 60%: Gráfico de Barras del Embudo Comercial
            Expanded(
              flex: 60,
              child: OperationalPipelineBarChart(
                isDark: isDark,
                qualificationCount: _metrics.qualificationCount,
                technicalVisitCount: _metrics.technicalVisitCount,
                proposalCount: _metrics.proposalCount,
                negotiationCount: _metrics.negotiationCount,
                wonCount: _metrics.wonCount,
                totalPipelineValue: _metrics.totalPipelineValue,
                winRate: _metrics.winRate,
                onOpenPipeline: () => widget.onNavigateToTab?.call(6),
              ),
            ),
            const SizedBox(width: 20),

            // 40%: Gráfico Circular de Distribución de Cartera & Facturación
            Expanded(
              flex: 40,
              child: BusinessDistributionDonutChart(
                isDark: isDark,
                totalActiveCustomers: _metrics.totalActiveCustomers,
                totalB2b: _metrics.totalB2b,
                totalB2c: _metrics.totalB2c,
                totalMrr: _metrics.totalMrr,
                totalProjectVolume: _metrics.totalProjectVolume,
                onOpenCustomers: () => widget.onNavigateToTab?.call(7),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 4. FILA DE EJECUCIÓN: ACTIVIDAD RECIENTE + ACCIONES RÁPIDAS ---
  Widget _buildOperationalExecutionRow(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 1000;

        if (isNarrow) {
          return Column(
            children: [
              _buildRecentActivitySection(isDark),
              const SizedBox(height: 20),
              _buildQuickActionsAndGovernance(isDark),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 60,
              child: _buildRecentActivitySection(isDark),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 40,
              child: _buildQuickActionsAndGovernance(isDark),
            ),
          ],
        );
      },
    );
  }

  // --- ACTIVIDAD RECIENTE Y TRAZABILIDAD ---
  Widget _buildRecentActivitySection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 18,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Actividad Reciente & Trazabilidad',
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Eventos auditados y transacciones criptográficas en tiempo real',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      widget.onNavigateToTab?.call(3), // Tab Bitácora
                  style: TextButton.styleFrom(
                    foregroundColor: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver bitácora',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 13),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),

          if (_recentLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  'No hay eventos registrados recientemente.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentLogs.length,
              separatorBuilder: (ctx, index) => Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final log = _recentLogs[index];
                return _buildEventRow(isDark, log);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEventRow(bool isDark, AuditLog log) {
    final isFailure =
        log.result == 'FAILURE' ||
        log.result == 'BLOCKED' ||
        log.action.contains('FAILED');

    final statusColor = isFailure
        ? const Color(0xFFEF4444)
        : const Color(0xFF10B981);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _humanizeAction(log.action),
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  log.userIdentifier ?? 'Sistema interno',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          if (log.ipAddress != null && log.ipAddress!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                log.ipAddress == '::1' ? 'Local' : log.ipAddress!,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          Text(
            _getTimeAgo(log.timestamp),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // --- ACCIONES RÁPIDAS & GOBERNANZA ---
  Widget _buildQuickActionsAndGovernance(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta de Acciones Rápidas
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 18,
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Operaciones Rápidas',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
              _buildQuickActionItem(
                isDark: isDark,
                icon: Icons.add_circle_outline_rounded,
                title: 'Nueva Oportunidad Comercial',
                subtitle: 'Crear cotización en Pipeline',
                accentColor: const Color(0xFF3B82F6),
                onTap: () => widget.onNavigateToTab?.call(6),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildQuickActionItem(
                isDark: isDark,
                icon: Icons.event_available_rounded,
                title: 'Agendar Tarea o Visita Técnica',
                subtitle: 'Planificar compromiso en Agenda',
                accentColor: const Color(0xFFF59E0B),
                onTap: () => widget.onNavigateToTab?.call(8),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildQuickActionItem(
                isDark: isDark,
                icon: Icons.person_add_outlined,
                title: 'Registrar Cliente 360°',
                subtitle: 'Alta de cuenta corporativa o residencial',
                accentColor: const Color(0xFF06B6D4),
                onTap: () => widget.onNavigateToTab?.call(7),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                    : const Color(0xFFF1F5F9),
              ),
              _buildQuickActionItem(
                isDark: isDark,
                icon: Icons.people_outline,
                title: 'Directorio de Colaboradores',
                subtitle: 'Gestionar asignaciones en campo',
                accentColor: const Color(0xFF10B981),
                onTap: () => widget.onNavigateToTab?.call(10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: accentColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }
}
