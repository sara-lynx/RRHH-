import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';

/// Modelo de consolidación ejecutiva para el Dashboard Principal.
/// Agrupa las dimensiones de negocio: Pipeline Comercial, Clientes 360°,
/// Agenda Operativa, RRHH y Gobernanza/Seguridad.
class DashboardOperationalMetrics {
  // --- Pipeline Comercial ---
  final int totalOpportunities;
  final double totalPipelineValue;
  final double weightedValue;
  final double winRate;
  final int qualificationCount;
  final int technicalVisitCount;
  final int proposalCount;
  final int negotiationCount;
  final int wonCount;

  // --- Clientes & Contratos ---
  final int totalActiveCustomers;
  final double totalMrr;
  final double totalProjectVolume;
  final int totalBranches;
  final int totalContracts;
  final int totalB2b;
  final int totalB2c;
  final int expiringContractsCount;

  // --- Agenda de Servicios ---
  final int todayTasksCount;
  final int pendingTasksCount;
  final int completedTasksCount;
  final int overdueTasksCount;

  // --- Personal & Operaciones ---
  final int activeEmployees;
  final int fieldEmployees;
  final int officeEmployees;

  // --- Seguridad & Telemetría ---
  final int totalUsers;
  final int activeSessions;
  final int totalAuditLogs;
  final int dbLatencyMs;

  const DashboardOperationalMetrics({
    this.totalOpportunities = 0,
    this.totalPipelineValue = 0.0,
    this.weightedValue = 0.0,
    this.winRate = 0.0,
    this.qualificationCount = 0,
    this.technicalVisitCount = 0,
    this.proposalCount = 0,
    this.negotiationCount = 0,
    this.wonCount = 0,
    this.totalActiveCustomers = 0,
    this.totalMrr = 0.0,
    this.totalProjectVolume = 0.0,
    this.totalBranches = 0,
    this.totalContracts = 0,
    this.totalB2b = 0,
    this.totalB2c = 0,
    this.expiringContractsCount = 0,
    this.todayTasksCount = 0,
    this.pendingTasksCount = 0,
    this.completedTasksCount = 0,
    this.overdueTasksCount = 0,
    this.activeEmployees = 0,
    this.fieldEmployees = 0,
    this.officeEmployees = 0,
    this.totalUsers = 0,
    this.activeSessions = 0,
    this.totalAuditLogs = 0,
    this.dbLatencyMs = 14,
  });

  factory DashboardOperationalMetrics.fromResponses({
    CrmPipelineMetricsResponse? pipeline,
    CrmCustomerMetricsResponse? customers,
    CrmAgendaMetricsResponse? agenda,
    int? activeEmployees,
    int? fieldEmployees,
    int? officeEmployees,
    int? totalUsers,
    int? activeSessions,
    int? totalAuditLogs,
    int? dbLatencyMs,
  }) {
    return DashboardOperationalMetrics(
      totalOpportunities: pipeline?.totalOpportunities ?? 0,
      totalPipelineValue: pipeline?.totalPipelineValue ?? 0.0,
      weightedValue: pipeline?.weightedValue ?? 0.0,
      winRate: pipeline?.winRate ?? 0.0,
      qualificationCount: pipeline?.qualificationCount ?? 0,
      technicalVisitCount: pipeline?.technicalVisitCount ?? 0,
      proposalCount: pipeline?.proposalCount ?? 0,
      negotiationCount: pipeline?.negotiationCount ?? 0,
      wonCount: pipeline?.wonCount ?? 0,
      totalActiveCustomers: customers?.totalActiveCustomers ?? 0,
      totalMrr: customers?.totalMrr ?? 0.0,
      totalProjectVolume: customers?.totalProjectVolume ?? 0.0,
      totalBranches: customers?.totalBranches ?? 0,
      totalContracts: customers?.totalContracts ?? 0,
      totalB2b: customers?.totalB2b ?? 0,
      totalB2c: customers?.totalB2c ?? 0,
      expiringContractsCount: customers?.expiringContractsCount ?? 0,
      todayTasksCount: agenda?.todayTasksCount ?? 0,
      pendingTasksCount: agenda?.pendingTasksCount ?? 0,
      completedTasksCount: agenda?.completedTasksCount ?? 0,
      overdueTasksCount: agenda?.overdueTasksCount ?? 0,
      activeEmployees: activeEmployees ?? 0,
      fieldEmployees: fieldEmployees ?? 0,
      officeEmployees: officeEmployees ?? 0,
      totalUsers: totalUsers ?? 0,
      activeSessions: activeSessions ?? 0,
      totalAuditLogs: totalAuditLogs ?? 0,
      dbLatencyMs: dbLatencyMs ?? 14,
    );
  }
}
