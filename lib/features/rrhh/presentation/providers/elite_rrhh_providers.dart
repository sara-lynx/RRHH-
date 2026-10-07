import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/elite_rrhh_local_store.dart';
import '../../domain/models/elite_rrhh_models.dart';

/// Notifier para gestionar la lista de colaboradores de Elite Multiservicios.
class RrhhEmployeesNotifier extends Notifier<List<EliteEmployee>> {
  @override
  List<EliteEmployee> build() {
    return EliteRrhhLocalStore.instance.getEmployees();
  }

  void addEmployee(EliteEmployee employee) {
    EliteRrhhLocalStore.instance.addEmployee(employee);
    state = [employee, ...state];
  }

  void updateEmployee(EliteEmployee employee) {
    EliteRrhhLocalStore.instance.updateEmployee(employee);
    state = [
      for (final emp in state)
        if (emp.id == employee.id) employee else emp
    ];
  }

  void terminateEmployee(String id) {
    EliteRrhhLocalStore.instance.terminateEmployee(id);
    state = [
      for (final emp in state)
        if (emp.id == id) emp.copyWith(status: EmployeeStatus.deBaja) else emp
    ];
  }

  void updateContract(
    String id, {
    required ContractType contractType,
    DateTime? contractEndDate,
    required double baseSalary,
  }) {
    state = [
      for (final emp in state)
        if (emp.id == id)
          emp.copyWith(
            contractType: contractType,
            contractEndDate: contractEndDate,
            baseSalary: baseSalary,
          )
        else
          emp
    ];
  }
}

/// Provider de lista completa de colaboradores
final rrhhEmployeesProvider =
    NotifierProvider<RrhhEmployeesNotifier, List<EliteEmployee>>(
  RrhhEmployeesNotifier.new,
);

/// Notifier y Provider de Filtro por Workplace (Oficina / Campo)
class WorkplaceFilterNotifier extends Notifier<EmployeeWorkplaceType?> {
  @override
  EmployeeWorkplaceType? build() => null;
  void setFilter(EmployeeWorkplaceType? value) => state = value;
}

final rrhhWorkplaceFilterProvider =
    NotifierProvider<WorkplaceFilterNotifier, EmployeeWorkplaceType?>(
  WorkplaceFilterNotifier.new,
);

/// Notifier y Provider de Filtro por Centro de Costo
class CostCenterFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void setFilter(String? value) => state = value;
}

final rrhhCostCenterFilterProvider =
    NotifierProvider<CostCenterFilterNotifier, String?>(
  CostCenterFilterNotifier.new,
);

/// Notifier y Provider de Filtro por Estado
class StatusFilterNotifier extends Notifier<EmployeeStatus?> {
  @override
  EmployeeStatus? build() => null;
  void setFilter(EmployeeStatus? value) => state = value;
}

final rrhhStatusFilterProvider =
    NotifierProvider<StatusFilterNotifier, EmployeeStatus?>(
  StatusFilterNotifier.new,
);

/// Notifier y Provider de Filtro por Texto de Búsqueda
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String value) => state = value;
}

final rrhhSearchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

/// Provider reactivo de colaboradores filtrados
final rrhhFilteredEmployeesProvider = Provider<List<EliteEmployee>>((ref) {
  final all = ref.watch(rrhhEmployeesProvider);
  final workplaceFilter = ref.watch(rrhhWorkplaceFilterProvider);
  final costCenterFilter = ref.watch(rrhhCostCenterFilterProvider);
  final statusFilter = ref.watch(rrhhStatusFilterProvider);
  final query = ref.watch(rrhhSearchQueryProvider).trim().toLowerCase();

  return all.where((emp) {
    if (workplaceFilter != null && emp.workplaceType != workplaceFilter) {
      return false;
    }
    if (costCenterFilter != null && emp.serviceLineCode != costCenterFilter) {
      return false;
    }
    if (statusFilter != null && emp.status != statusFilter) {
      return false;
    }
    if (query.isNotEmpty) {
      final matchName = emp.fullName.toLowerCase().contains(query);
      final matchCi = emp.ci.toLowerCase().contains(query);
      final matchPosition = emp.position.toLowerCase().contains(query);
      final matchSite = emp.assignedSite.toLowerCase().contains(query);
      final matchId = emp.id.toLowerCase().contains(query);
      if (!matchName && !matchCi && !matchPosition && !matchSite && !matchId) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Métricas calculadas para la cabecera
final rrhhMetricsProvider =
    Provider<({int total, int office, int field, int active})>((ref) {
  final employees = ref.watch(rrhhEmployeesProvider);
  final officeCount = employees.where((e) => e.isOffice).length;
  final fieldCount = employees.where((e) => e.isField).length;
  final activeCount =
      employees.where((e) => e.status == EmployeeStatus.activo).length;

  return (
    total: employees.length,
    office: officeCount,
    field: fieldCount,
    active: activeCount,
  );
});

/// Escalas salariales vigentes
final rrhhSalaryScalesProvider = Provider<List<PositionSalaryScale>>((ref) {
  return EliteRrhhLocalStore.instance.getSalaryScales();
});

// =============================================================================
// ASISTENCIA WEB DE OFICINA (WEB PUNCH)
// =============================================================================

class OfficePunchState {
  final bool isClockedIn;
  final bool isCompleted;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final String ipAddress;
  final String workstation;

  const OfficePunchState({
    this.isClockedIn = false,
    this.isCompleted = false,
    this.clockInTime,
    this.clockOutTime,
    this.ipAddress = '192.168.1.45',
    this.workstation = 'Estación RRHH-Central-01',
  });

  OfficePunchState copyWith({
    bool? isClockedIn,
    bool? isCompleted,
    DateTime? clockInTime,
    DateTime? clockOutTime,
    String? ipAddress,
    String? workstation,
  }) {
    return OfficePunchState(
      isClockedIn: isClockedIn ?? this.isClockedIn,
      isCompleted: isCompleted ?? this.isCompleted,
      clockInTime: clockInTime ?? this.clockInTime,
      clockOutTime: clockOutTime ?? this.clockOutTime,
      ipAddress: ipAddress ?? this.ipAddress,
      workstation: workstation ?? this.workstation,
    );
  }
}

class OfficePunchNotifier extends Notifier<OfficePunchState> {
  @override
  OfficePunchState build() {
    final records = ref.watch(rrhhAttendanceProvider);
    final paola = records.where((r) => r.employeeId == 'EMP-002').firstOrNull;

    if (paola != null) {
      if (paola.checkOutTimestamp != null) {
        return OfficePunchState(
          isClockedIn: false,
          isCompleted: true,
          clockInTime: paola.timestamp,
          clockOutTime: paola.checkOutTimestamp,
          ipAddress: paola.ipAddress?.split(' ').first ?? '192.168.1.52',
          workstation: 'Estación RRHH-Central-01',
        );
      } else {
        return OfficePunchState(
          isClockedIn: true,
          isCompleted: false,
          clockInTime: paola.timestamp,
          clockOutTime: null,
          ipAddress: paola.ipAddress?.split(' ').first ?? '192.168.1.52',
          workstation: 'Estación RRHH-Central-01',
        );
      }
    }

    return const OfficePunchState();
  }

  void togglePunch() {
    final now = DateTime.now();
    final wasClockedIn = state.isClockedIn;

    ref.read(rrhhAttendanceProvider.notifier).recordOfficePunch(
          employeeId: 'EMP-002',
          isClockOut: wasClockedIn,
          timestamp: now,
          ipAddress: state.ipAddress,
          workstation: state.workstation,
        );
  }
}

final officePunchProvider =
    NotifierProvider<OfficePunchNotifier, OfficePunchState>(
  OfficePunchNotifier.new,
);

// =============================================================================
// SUBMÓDULO 2: ORGANIZACIÓN, TURNOS Y CUADRANTES
// =============================================================================

/// Notifier y Provider para el Catálogo de Turnos
class RrhhShiftsNotifier extends Notifier<List<EliteShift>> {
  @override
  List<EliteShift> build() {
    return EliteRrhhLocalStore.instance.getShifts();
  }

  void addShift(EliteShift shift) {
    EliteRrhhLocalStore.instance.addShift(shift);
    state = [...state, shift];
  }
}

final rrhhShiftsProvider =
    NotifierProvider<RrhhShiftsNotifier, List<EliteShift>>(
  RrhhShiftsNotifier.new,
);

/// Notifier y Provider para Sedes de Clientes y Geocercas
class RrhhClientSitesNotifier extends Notifier<List<EliteClientSite>> {
  @override
  List<EliteClientSite> build() {
    return EliteRrhhLocalStore.instance.getClientSites();
  }

  void addClientSite(EliteClientSite site) {
    EliteRrhhLocalStore.instance.addClientSite(site);
    state = [...state, site];
  }
}

final rrhhClientSitesProvider =
    NotifierProvider<RrhhClientSitesNotifier, List<EliteClientSite>>(
  RrhhClientSitesNotifier.new,
);

/// Notifier y Provider para Malla de Asignaciones / Cuadrantes
class RrhhRosterNotifier extends Notifier<List<EliteRosterAssignment>> {
  @override
  List<EliteRosterAssignment> build() {
    return EliteRrhhLocalStore.instance.getRosterAssignments();
  }

  void addAssignment(EliteRosterAssignment assignment) {
    EliteRrhhLocalStore.instance.addRosterAssignment(assignment);
    state = [assignment, ...state];
  }

  void rotateEmployee(String id, String newSiteId, String newSiteName) {
    EliteRrhhLocalStore.instance.rotateRosterAssignment(id, newSiteId, newSiteName);
    state = [
      for (final a in state)
        if (a.id == id)
          a.copyWith(siteId: newSiteId, siteName: newSiteName, status: 'rotado')
        else
          a
    ];
  }

  void reassignShift(String id, String newShiftId, String newShiftName, String newSchedule) {
    EliteRrhhLocalStore.instance.reassignShift(id, newShiftId, newShiftName, newSchedule);
    state = [
      for (final a in state)
        if (a.id == id)
          a.copyWith(shiftId: newShiftId, shiftName: newShiftName, scheduleSummary: newSchedule)
        else
          a
    ];
  }
}

final rrhhRosterProvider =
    NotifierProvider<RrhhRosterNotifier, List<EliteRosterAssignment>>(
  RrhhRosterNotifier.new,
);

/// Filtros para la Malla de Cuadrantes
class RosterSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String q) => state = q;
}

final rosterSearchQueryProvider =
    NotifierProvider<RosterSearchQueryNotifier, String>(
  RosterSearchQueryNotifier.new,
);

class RosterSiteFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void setFilter(String? s) => state = s;
}

final rosterSiteFilterProvider =
    NotifierProvider<RosterSiteFilterNotifier, String?>(
  RosterSiteFilterNotifier.new,
);

class RosterCostCenterFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void setFilter(String? cc) => state = cc;
}

final rosterCostCenterFilterProvider =
    NotifierProvider<RosterCostCenterFilterNotifier, String?>(
  RosterCostCenterFilterNotifier.new,
);

/// Provider de Malla de Cuadrantes filtrada
final rrhhFilteredRosterProvider = Provider<List<EliteRosterAssignment>>((ref) {
  final all = ref.watch(rrhhRosterProvider);
  final query = ref.watch(rosterSearchQueryProvider).trim().toLowerCase();
  final siteId = ref.watch(rosterSiteFilterProvider);
  final costCenter = ref.watch(rosterCostCenterFilterProvider);

  return all.where((item) {
    if (siteId != null && item.siteId != siteId) {
      return false;
    }
    if (costCenter != null && item.serviceLineCode != costCenter) {
      return false;
    }
    if (query.isNotEmpty) {
      final matchEmp = item.employeeName.toLowerCase().contains(query);
      final matchSite = item.siteName.toLowerCase().contains(query);
      final matchShift = item.shiftName.toLowerCase().contains(query);
      if (!matchEmp && !matchSite && !matchShift) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Métricas de Organización y Cuadrantes para la cabecera
final rrhhOrganizationMetricsProvider = Provider<({
  int totalSites,
  int coveredSites,
  int fieldAssignments,
  double coveragePercent,
})>((ref) {
  final sites = ref.watch(rrhhClientSitesProvider);
  final assignments = ref.watch(rrhhRosterProvider);

  final totalSites = sites.length;
  final coveredSites = sites.where((s) => s.isFullyCovered).length;
  final fieldAssignments = assignments.where((a) =>
      a.serviceLineCode == EliteCostCenter.seg ||
      a.serviceLineCode == EliteCostCenter.lim ||
      a.serviceLineCode == EliteCostCenter.jar ||
      a.serviceLineCode == EliteCostCenter.man).length;

  final coverage = totalSites > 0 ? (coveredSites / totalSites * 100) : 100.0;

  return (
    totalSites: totalSites,
    coveredSites: coveredSites,
    fieldAssignments: fieldAssignments,
    coveragePercent: coverage,
  );
});

// =============================================================================
// SUBMÓDULO 3: CONTROL DE ASISTENCIA DUAL (OFICINA Y APK CAMPO)
// =============================================================================

/// Notifier y Provider para el registro completo de asistencias diarias
class RrhhAttendanceNotifier extends Notifier<List<EliteAttendanceRecord>> {
  @override
  List<EliteAttendanceRecord> build() {
    return EliteRrhhLocalStore.instance.getAttendanceRecords();
  }

  void addRecord(EliteAttendanceRecord record) {
    EliteRrhhLocalStore.instance.addAttendanceRecord(record);
    state = [record, ...state];
  }

  void updateRecord(EliteAttendanceRecord record) {
    EliteRrhhLocalStore.instance.updateAttendanceRecord(record);
    state = state.map((r) => r.id == record.id ? record : r).toList();
  }

  void recordOfficePunch({
    required String employeeId,
    required bool isClockOut,
    required DateTime timestamp,
    required String ipAddress,
    required String workstation,
  }) {
    EliteRrhhLocalStore.instance.recordOfficePunch(
      employeeId: employeeId,
      isClockOut: isClockOut,
      timestamp: timestamp,
      ipAddress: ipAddress,
      workstation: workstation,
    );
    state = EliteRrhhLocalStore.instance.getAttendanceRecords();
  }

  void consolidateFieldSync() {
    EliteRrhhLocalStore.instance.consolidateFieldSync();
    state = EliteRrhhLocalStore.instance.getAttendanceRecords();
  }
}

final rrhhAttendanceProvider =
    NotifierProvider<RrhhAttendanceNotifier, List<EliteAttendanceRecord>>(
  RrhhAttendanceNotifier.new,
);

/// Buscador de asistencia por texto
class AttendanceSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final attendanceSearchQueryProvider =
    NotifierProvider<AttendanceSearchQueryNotifier, String>(
  AttendanceSearchQueryNotifier.new,
);

/// Filtro por Tipo de Personal (Todos, Oficina, Campo)
class AttendanceWorkplaceTypeFilterNotifier
    extends Notifier<EmployeeWorkplaceType?> {
  @override
  EmployeeWorkplaceType? build() => null;

  void setFilter(EmployeeWorkplaceType? val) => state = val;
}

final attendanceWorkplaceTypeFilterProvider =
    NotifierProvider<AttendanceWorkplaceTypeFilterNotifier,
        EmployeeWorkplaceType?>(
  AttendanceWorkplaceTypeFilterNotifier.new,
);

/// Filtro por Centro de Costo
class AttendanceCostCenterFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? val) => state = val;
}

final attendanceCostCenterFilterProvider =
    NotifierProvider<AttendanceCostCenterFilterNotifier, String?>(
  AttendanceCostCenterFilterNotifier.new,
);

/// Filtro por Evaluación de Asistencia (Puntual, Retraso, Falta, En Jornada)
class AttendanceEvaluationFilterNotifier
    extends Notifier<AttendanceEvaluation?> {
  @override
  AttendanceEvaluation? build() => null;

  void setFilter(AttendanceEvaluation? val) => state = val;
}

final attendanceEvaluationFilterProvider =
    NotifierProvider<AttendanceEvaluationFilterNotifier,
        AttendanceEvaluation?>(
  AttendanceEvaluationFilterNotifier.new,
);

/// Lista de asistencias filtradas reactivamente
final rrhhFilteredAttendanceProvider =
    Provider<List<EliteAttendanceRecord>>((ref) {
  final all = ref.watch(rrhhAttendanceProvider);
  final query = ref.watch(attendanceSearchQueryProvider).trim().toLowerCase();
  final workplaceType = ref.watch(attendanceWorkplaceTypeFilterProvider);
  final costCenter = ref.watch(attendanceCostCenterFilterProvider);
  final evaluation = ref.watch(attendanceEvaluationFilterProvider);

  return all.where((rec) {
    if (workplaceType != null && rec.workplaceType != workplaceType) {
      return false;
    }
    if (costCenter != null && rec.serviceLineCode != costCenter) {
      return false;
    }
    if (evaluation != null && rec.evaluation != evaluation) {
      return false;
    }
    if (query.isNotEmpty) {
      final nameMatches = rec.employeeName.toLowerCase().contains(query);
      final siteMatches = rec.assignedSite.toLowerCase().contains(query);
      final shiftMatches = rec.shiftName.toLowerCase().contains(query);
      final jobMatches = rec.employeeJobTitle.toLowerCase().contains(query);
      if (!nameMatches && !siteMatches && !shiftMatches && !jobMatches) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Métricas de Asistencia Dual para la cabecera
final rrhhAttendanceMetricsProvider = Provider<({
  int totalRoster,
  int presentCount,
  double presentPercentage,
  int lateCount,
  int lateMinutesTotal,
  int gpsAlertsCount,
})>((ref) {
  final records = ref.watch(rrhhAttendanceProvider);
  const totalRoster = 12;
  final presentCount = records
      .where((r) => r.evaluation != AttendanceEvaluation.faltaInjustificada)
      .length;
  final presentPercentage =
      totalRoster > 0 ? (presentCount / totalRoster * 100) : 0.0;
  final lateRecords =
      records.where((r) => r.evaluation == AttendanceEvaluation.retraso).toList();
  final lateCount = lateRecords.length;
  final lateMinutesTotal =
      lateRecords.fold<int>(0, (sum, r) => sum + r.lateMinutes);
  final gpsAlertsCount = records
      .where((r) => r.geofenceStatus == GeofenceStatus.fueraDePerimetro)
      .length;

  return (
    totalRoster: totalRoster,
    presentCount: presentCount,
    presentPercentage: presentPercentage,
    lateCount: lateCount,
    lateMinutesTotal: lateMinutesTotal,
    gpsAlertsCount: gpsAlertsCount,
  );
});

// =============================================================================
// SUBMÓDULO 4: NOVEDADES E INCIDENCIAS (PERMISOS, SANCIONES Y VACACIONES)
// =============================================================================

/// Notifier y Provider para Solicitudes de Permisos y Bajas
class RrhhLeaveRequestsNotifier extends Notifier<List<EliteLeaveRequest>> {
  @override
  List<EliteLeaveRequest> build() {
    return EliteRrhhLocalStore.instance.getLeaveRequests();
  }

  void addRequest(EliteLeaveRequest request) {
    EliteRrhhLocalStore.instance.addLeaveRequest(request);
    state = [request, ...state];
  }

  void updateStatus(
    String id,
    LeaveRequestStatus status,
    LeavePaymentStatus paymentStatus,
  ) {
    EliteRrhhLocalStore.instance.updateLeaveRequestStatus(
      id,
      status,
      paymentStatus,
    );
    state = EliteRrhhLocalStore.instance.getLeaveRequests();
  }
}

final rrhhLeaveRequestsProvider =
    NotifierProvider<RrhhLeaveRequestsNotifier, List<EliteLeaveRequest>>(
  RrhhLeaveRequestsNotifier.new,
);

/// Notifier y Provider para Tardanzas y Penalizaciones en Bs
class RrhhTardinessPenaltiesNotifier
    extends Notifier<List<EliteTardinessPenalty>> {
  @override
  List<EliteTardinessPenalty> build() {
    return EliteRrhhLocalStore.instance.getTardinessPenalties();
  }
}

final rrhhTardinessPenaltiesProvider = NotifierProvider<
    RrhhTardinessPenaltiesNotifier, List<EliteTardinessPenalty>>(
  RrhhTardinessPenaltiesNotifier.new,
);

/// Notifier y Provider para Saldo de Vacaciones según LGT
class RrhhVacationsNotifier extends Notifier<List<EliteVacationRecord>> {
  @override
  List<EliteVacationRecord> build() {
    return EliteRrhhLocalStore.instance.getVacationRecords();
  }

  void scheduleVacation(
    String employeeId,
    DateTime start,
    DateTime end,
    int days,
  ) {
    EliteRrhhLocalStore.instance.scheduleVacation(employeeId, start, end, days);
    state = EliteRrhhLocalStore.instance.getVacationRecords();
  }
}

final rrhhVacationsProvider =
    NotifierProvider<RrhhVacationsNotifier, List<EliteVacationRecord>>(
  RrhhVacationsNotifier.new,
);

/// Filtros de Solicitudes de Permiso
class LeaveSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final leaveSearchQueryProvider =
    NotifierProvider<LeaveSearchQueryNotifier, String>(
  LeaveSearchQueryNotifier.new,
);

class LeaveStatusFilterNotifier extends Notifier<LeaveRequestStatus?> {
  @override
  LeaveRequestStatus? build() => null;

  void setFilter(LeaveRequestStatus? val) => state = val;
}

final leaveStatusFilterProvider =
    NotifierProvider<LeaveStatusFilterNotifier, LeaveRequestStatus?>(
  LeaveStatusFilterNotifier.new,
);

class LeaveTypeFilterNotifier extends Notifier<LeaveType?> {
  @override
  LeaveType? build() => null;

  void setFilter(LeaveType? val) => state = val;
}

final leaveTypeFilterProvider =
    NotifierProvider<LeaveTypeFilterNotifier, LeaveType?>(
  LeaveTypeFilterNotifier.new,
);

class LeaveCostCenterFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? val) => state = val;
}

final leaveCostCenterFilterProvider =
    NotifierProvider<LeaveCostCenterFilterNotifier, String?>(
  LeaveCostCenterFilterNotifier.new,
);

final rrhhFilteredLeaveRequestsProvider =
    Provider<List<EliteLeaveRequest>>((ref) {
  final all = ref.watch(rrhhLeaveRequestsProvider);
  final query = ref.watch(leaveSearchQueryProvider).trim().toLowerCase();
  final status = ref.watch(leaveStatusFilterProvider);
  final type = ref.watch(leaveTypeFilterProvider);
  final costCenter = ref.watch(leaveCostCenterFilterProvider);

  return all.where((req) {
    if (status != null && req.status != status) return false;
    if (type != null && req.leaveType != type) return false;
    if (costCenter != null && req.serviceLineCode != costCenter) return false;
    if (query.isNotEmpty) {
      final nameMatches = req.employeeName.toLowerCase().contains(query);
      final reasonMatches = req.reason.toLowerCase().contains(query);
      final idMatches = req.id.toLowerCase().contains(query);
      if (!nameMatches && !reasonMatches && !idMatches) return false;
    }
    return true;
  }).toList();
});

/// Filtros de Penalizaciones
class PenaltySearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final penaltySearchQueryProvider =
    NotifierProvider<PenaltySearchQueryNotifier, String>(
  PenaltySearchQueryNotifier.new,
);

class PenaltyCostCenterFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? val) => state = val;
}

final penaltyCostCenterFilterProvider =
    NotifierProvider<PenaltyCostCenterFilterNotifier, String?>(
  PenaltyCostCenterFilterNotifier.new,
);

final rrhhFilteredPenaltiesProvider =
    Provider<List<EliteTardinessPenalty>>((ref) {
  final all = ref.watch(rrhhTardinessPenaltiesProvider);
  final query = ref.watch(penaltySearchQueryProvider).trim().toLowerCase();
  final costCenter = ref.watch(penaltyCostCenterFilterProvider);

  return all.where((pen) {
    if (costCenter != null && pen.serviceLineCode != costCenter) return false;
    if (query.isNotEmpty) {
      final nameMatches = pen.employeeName.toLowerCase().contains(query);
      final jobMatches = pen.employeeJobTitle.toLowerCase().contains(query);
      if (!nameMatches && !jobMatches) return false;
    }
    return true;
  }).toList();
});

/// Métricas de Novedades e Incidencias para la cabecera
final rrhhIncidentsMetricsProvider = Provider<({
  int pendingRequests,
  double totalPenaltyAmountBs,
  int employeesOnVacation,
})>((ref) {
  final requests = ref.watch(rrhhLeaveRequestsProvider);
  final penalties = ref.watch(rrhhTardinessPenaltiesProvider);

  final pendingRequests =
      requests.where((r) => r.status == LeaveRequestStatus.pendiente).length;
  final totalPenaltyAmountBs =
      penalties.fold<double>(0.0, (sum, p) => sum + p.penaltyAmountBs);
  const employeesOnVacation = 0;

  return (
    pendingRequests: pendingRequests,
    totalPenaltyAmountBs: totalPenaltyAmountBs,
    employeesOnVacation: employeesOnVacation,
  );
});

// =============================================================================
// SUBMÓDULO 5: NÓMINA, PRE-PLANILLA Y ASIENTO CONTABLE
// =============================================================================

/// Notifier y Provider para la lista de trabajadores en planilla mensual
class RrhhPayrollNotifier extends Notifier<List<ElitePayrollItem>> {
  @override
  List<ElitePayrollItem> build() {
    return EliteRrhhLocalStore.instance.getPayrollItems();
  }

  void updateItem(ElitePayrollItem item) {
    EliteRrhhLocalStore.instance.updatePayrollItem(item);
    state = state.map((p) => p.id == item.id ? item : p).toList();
  }
}

final rrhhPayrollProvider =
    NotifierProvider<RrhhPayrollNotifier, List<ElitePayrollItem>>(
  RrhhPayrollNotifier.new,
);

/// Notifier y Provider para el resumen y estado de cierre de la nómina
class RrhhPayrollSummaryNotifier extends Notifier<ElitePayrollPeriodSummary> {
  @override
  ElitePayrollPeriodSummary build() {
    return EliteRrhhLocalStore.instance.getPayrollSummary();
  }

  void closePeriod() {
    EliteRrhhLocalStore.instance.closePayrollPeriodAndGenerateVoucher();
    state = EliteRrhhLocalStore.instance.getPayrollSummary();
  }
}

final rrhhPayrollSummaryProvider =
    NotifierProvider<RrhhPayrollSummaryNotifier, ElitePayrollPeriodSummary>(
  RrhhPayrollSummaryNotifier.new,
);

/// Provider de solo lectura para el asiento contable por partida doble
final rrhhAccountingEntriesProvider =
    Provider<List<EliteAccountingEntryItem>>((ref) {
  ref.watch(rrhhPayrollSummaryProvider);
  return EliteRrhhLocalStore.instance.getAccountingEntries();
});

/// Buscador de texto en planilla
class PayrollSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final payrollSearchQueryProvider =
    NotifierProvider<PayrollSearchQueryNotifier, String>(
  PayrollSearchQueryNotifier.new,
);

/// Filtro por tipo de lugar de trabajo en nómina
class PayrollWorkplaceTypeFilterNotifier
    extends Notifier<EmployeeWorkplaceType?> {
  @override
  EmployeeWorkplaceType? build() => null;

  void setFilter(EmployeeWorkplaceType? val) => state = val;
}

final payrollWorkplaceTypeFilterProvider =
    NotifierProvider<PayrollWorkplaceTypeFilterNotifier,
        EmployeeWorkplaceType?>(
  PayrollWorkplaceTypeFilterNotifier.new,
);

/// Filtro por Centro de Costo en nómina
class PayrollCostCenterFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? val) => state = val;
}

final payrollCostCenterFilterProvider =
    NotifierProvider<PayrollCostCenterFilterNotifier, String?>(
  PayrollCostCenterFilterNotifier.new,
);

/// Lista de nómina filtrada reactivamente
final rrhhFilteredPayrollProvider = Provider<List<ElitePayrollItem>>((ref) {
  final all = ref.watch(rrhhPayrollProvider);
  final query = ref.watch(payrollSearchQueryProvider).trim().toLowerCase();
  final workplaceType = ref.watch(payrollWorkplaceTypeFilterProvider);
  final costCenter = ref.watch(payrollCostCenterFilterProvider);

  return all.where((item) {
    if (workplaceType != null && item.workplaceType != workplaceType) {
      return false;
    }
    if (costCenter != null && item.serviceLineCode != costCenter) {
      return false;
    }
    if (query.isNotEmpty) {
      final matchName = item.employeeName.toLowerCase().contains(query);
      final matchPos = item.position.toLowerCase().contains(query);
      final matchCi = item.ci.toLowerCase().contains(query);
      final matchId = item.id.toLowerCase().contains(query);
      if (!matchName && !matchPos && !matchCi && !matchId) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Empleado seleccionado para visualización de boleta de pago
class SelectedPaySlipEmployeeIdNotifier extends Notifier<String> {
  @override
  String build() => 'EMP-001';

  void selectEmployee(String id) => state = id;
}

final selectedPaySlipEmployeeIdProvider =
    NotifierProvider<SelectedPaySlipEmployeeIdNotifier, String>(
  SelectedPaySlipEmployeeIdNotifier.new,
);

// =============================================================================
// SUBMÓDULO 6: RÉGIMEN DISCIPLINARIO, FINIQUITOS Y AUDITORÍA INMUTABLE
// =============================================================================

/// Notifier y Provider para el registro de Memorándums y Sanciones
class RrhhDisciplinaryNotifier extends Notifier<List<EliteDisciplinaryRecord>> {
  @override
  List<EliteDisciplinaryRecord> build() {
    return EliteRrhhLocalStore.instance.getDisciplinaryRecords();
  }

  void addRecord(EliteDisciplinaryRecord record) {
    EliteRrhhLocalStore.instance.addDisciplinaryRecord(record);
    state = EliteRrhhLocalStore.instance.getDisciplinaryRecords();
    ref.invalidate(rrhhAuditLogsProvider);
  }
}

final rrhhDisciplinaryProvider = NotifierProvider<RrhhDisciplinaryNotifier,
    List<EliteDisciplinaryRecord>>(
  RrhhDisciplinaryNotifier.new,
);

/// Buscador de memorándums por texto
class DisciplinarySearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final disciplinarySearchQueryProvider =
    NotifierProvider<DisciplinarySearchQueryNotifier, String>(
  DisciplinarySearchQueryNotifier.new,
);

/// Filtro por Gravedad de sanción
class DisciplinarySeverityFilterNotifier
    extends Notifier<DisciplinarySeverity?> {
  @override
  DisciplinarySeverity? build() => null;

  void setFilter(DisciplinarySeverity? val) => state = val;
}

final disciplinarySeverityFilterProvider =
    NotifierProvider<DisciplinarySeverityFilterNotifier,
        DisciplinarySeverity?>(
  DisciplinarySeverityFilterNotifier.new,
);

/// Lista de memorándums filtrada reactivamente
final rrhhFilteredDisciplinaryProvider =
    Provider<List<EliteDisciplinaryRecord>>((ref) {
  final all = ref.watch(rrhhDisciplinaryProvider);
  final query = ref.watch(disciplinarySearchQueryProvider).trim().toLowerCase();
  final severity = ref.watch(disciplinarySeverityFilterProvider);

  return all.where((rec) {
    if (severity != null && rec.severity != severity) return false;
    if (query.isNotEmpty) {
      final nameMatches = rec.employeeName.toLowerCase().contains(query);
      final memoMatches = rec.memorandumCode.toLowerCase().contains(query);
      final infragMatches = rec.infractionType.toLowerCase().contains(query);
      final descMatches = rec.description.toLowerCase().contains(query);
      if (!nameMatches && !memoMatches && !infragMatches && !descMatches) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Notifier y Provider para Finiquitos y Liquidaciones
class RrhhSettlementsNotifier
    extends Notifier<List<EliteTerminationSettlement>> {
  @override
  List<EliteTerminationSettlement> build() {
    return EliteRrhhLocalStore.instance.getSettlements();
  }

  void addSettlement(EliteTerminationSettlement settlement) {
    EliteRrhhLocalStore.instance.addSettlement(settlement);
    state = EliteRrhhLocalStore.instance.getSettlements();
    ref.invalidate(rrhhAuditLogsProvider);
  }

  void updateStatus(String id, String newStatus) {
    EliteRrhhLocalStore.instance.updateSettlementStatus(id, newStatus);
    state = EliteRrhhLocalStore.instance.getSettlements();
    ref.invalidate(rrhhAuditLogsProvider);
  }
}

final rrhhSettlementsProvider = NotifierProvider<RrhhSettlementsNotifier,
    List<EliteTerminationSettlement>>(
  RrhhSettlementsNotifier.new,
);

/// Buscador de finiquitos por texto
class SettlementsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final settlementsSearchQueryProvider =
    NotifierProvider<SettlementsSearchQueryNotifier, String>(
  SettlementsSearchQueryNotifier.new,
);

/// Filtro por Motivo de Desvinculación
class SettlementsReasonFilterNotifier extends Notifier<TerminationReason?> {
  @override
  TerminationReason? build() => null;

  void setFilter(TerminationReason? val) => state = val;
}

final settlementsReasonFilterProvider =
    NotifierProvider<SettlementsReasonFilterNotifier, TerminationReason?>(
  SettlementsReasonFilterNotifier.new,
);

/// Lista de finiquitos filtrada reactivamente
final rrhhFilteredSettlementsProvider =
    Provider<List<EliteTerminationSettlement>>((ref) {
  final all = ref.watch(rrhhSettlementsProvider);
  final query = ref.watch(settlementsSearchQueryProvider).trim().toLowerCase();
  final reason = ref.watch(settlementsReasonFilterProvider);

  return all.where((set) {
    if (reason != null && set.reason != reason) return false;
    if (query.isNotEmpty) {
      final nameMatches = set.employeeName.toLowerCase().contains(query);
      final ciMatches = set.ci.toLowerCase().contains(query);
      final posMatches = set.position.toLowerCase().contains(query);
      final idMatches = set.id.toLowerCase().contains(query);
      if (!nameMatches && !ciMatches && !posMatches && !idMatches) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Notifier y Provider para la Bitácora de Auditoría Inmutable
class RrhhAuditLogsNotifier extends Notifier<List<EliteRrhhAuditLog>> {
  @override
  List<EliteRrhhAuditLog> build() {
    return EliteRrhhLocalStore.instance.getAuditLogs();
  }

  void addAuditLog(EliteRrhhAuditLog log) {
    EliteRrhhLocalStore.instance.addAuditLog(log);
    state = EliteRrhhLocalStore.instance.getAuditLogs();
  }
}

final rrhhAuditLogsProvider =
    NotifierProvider<RrhhAuditLogsNotifier, List<EliteRrhhAuditLog>>(
  RrhhAuditLogsNotifier.new,
);

/// Buscador de bitácora por texto
class AuditSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String val) => state = val;
}

final auditSearchQueryProvider =
    NotifierProvider<AuditSearchQueryNotifier, String>(
  AuditSearchQueryNotifier.new,
);

/// Filtro por Tipo de Acción en bitácora
class AuditActionFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? val) => state = val;
}

final auditActionFilterProvider =
    NotifierProvider<AuditActionFilterNotifier, String?>(
  AuditActionFilterNotifier.new,
);

/// Lista de auditoría filtrada reactivamente
final rrhhFilteredAuditLogsProvider = Provider<List<EliteRrhhAuditLog>>((ref) {
  final all = ref.watch(rrhhAuditLogsProvider);
  final query = ref.watch(auditSearchQueryProvider).trim().toLowerCase();
  final action = ref.watch(auditActionFilterProvider);

  return all.where((log) {
    if (action != null && log.action != action) return false;
    if (query.isNotEmpty) {
      final userMatches = log.userName.toLowerCase().contains(query);
      final actMatches = log.action.toLowerCase().contains(query);
      final refMatches = log.reference.toLowerCase().contains(query);
      final detMatches = log.detail.toLowerCase().contains(query);
      final hashMatches = log.sha256Hash.toLowerCase().contains(query);
      if (!userMatches &&
          !actMatches &&
          !refMatches &&
          !detMatches &&
          !hashMatches) {
        return false;
      }
    }
    return true;
  }).toList();
});

/// Métricas del Submódulo Legal y Disciplinario para la cabecera
final rrhhLegalMetricsProvider = Provider<({
  int activeSanctionsCount,
  double settlementsInProgressTotalBs,
  int auditLogsCount,
})>((ref) {
  final disciplinary = ref.watch(rrhhDisciplinaryProvider);
  final settlements = ref.watch(rrhhSettlementsProvider);
  final auditLogs = ref.watch(rrhhAuditLogsProvider);

  final activeSanctionsCount = disciplinary.length;
  final settlementsInProgressTotalBs =
      settlements.fold<double>(0.0, (sum, s) => sum + s.totalSettlement);
  final auditLogsCount = auditLogs.length;

  return (
    activeSanctionsCount: activeSanctionsCount,
    settlementsInProgressTotalBs: settlementsInProgressTotalBs,
    auditLogsCount: auditLogsCount,
  );
});
