import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import '../models/crm_client_ref_dto.dart';
import '../models/rrhh_applicant_companion.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_catalog_item.dart';
import '../models/rrhh_leave_request.dart';
import '../models/rrhh_payroll_export_dto.dart';
import '../models/rrhh_shift.dart';
import '../models/rrhh_vacation.dart';
import '../models/rrhh_disciplinary_record.dart';
import '../models/rrhh_termination_record.dart';
import '../models/rrhh_payroll_period.dart';
import '../models/rrhh_attendance_record.dart';

export '../models/rrhh_timeline_event.dart';
import 'package:flutter/material.dart';

export '../models/rrhh_leave_request.dart';
export '../models/rrhh_vacation.dart';
export '../models/rrhh_disciplinary_record.dart';
export '../models/rrhh_termination_record.dart';
export '../models/rrhh_payroll_period.dart';
export '../models/rrhh_attendance_record.dart';

import 'rrhh_repository_remote.dart';

/// Interfaz abstracta del repositorio de Recursos Humanos (RRHH).
/// Define todos los contratos de datos y operaciones requeridos por las 14 pantallas.
/// Regla R1: La UI NO llama directamente a Serverpod, todo pasa por RrhhRepository.
/// Regla R2: La UI NO conoce si el repository es mock o remoto.
abstract class RrhhRepository {
  /// Instancia global activa apuntando al backend real (Serverpod).
  static RrhhRepository current = RrhhRepositoryRemote();

  /// Identifica si el repositorio está operando en modo Mock/Simulado.
  bool get isMock;

  // ---------------------------------------------------------------------------
  // PANTALLA 01: Dashboard Ejecutivo de RRHH
  // ---------------------------------------------------------------------------
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics();
  Future<List<RrhhRecentMovementDto>> getRecentMovements();

  // ---------------------------------------------------------------------------
  // PANTALLA 02: Directorio / Nómina de Personal
  // ---------------------------------------------------------------------------
  Future<List<RrhhEmployeeSummaryDto>> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
    int? limit,
    int? offset,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 03: Expediente del Empleado (Detalle 360°)
  // ---------------------------------------------------------------------------
  Future<RrhhEmployee> getEmployeeById(int id);
  Future<RrhhEmployee?> getEmployeeByCode(String code);
  Future<RrhhEmployee> createEmployee(RrhhEmployee employee);
  Future<bool> deleteEmployee(int id);
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId);
  Future<RrhhEmployeeDocument> uploadEmployeeDocument(
    RrhhEmployeeDocument document,
  );
  Future<bool> deleteEmployeeDocument(int documentId);
  Future<List<RrhhTimelineEvent>> listTimelineEvents({
    int? employeeId,
    String? category,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? user,
  });

  /// Asignación activa reportada por Operaciones (Solo Lectura desde Operaciones)
  Future<RrhhAssignment?> getCurrentAssignment(int employeeId);
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee);

  // Métodos FASE B: Actualizaciones por sección del Expediente de Contratación
  Future<RrhhEmployee> updateEmployeeBankInfo(
    int id, {
    String? bankName,
    String? accountType,
    String? accountNumber,
  });

  Future<RrhhEmployee> updateEmployeeSocialSecurity(
    int id, {
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
  });

  Future<RrhhEmployee> updateEmployeePersonalInfo(
    int id, {
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
  });

  Future<RrhhEmployee> updateEmployeeContract(
    int id, {
    String? contractType,
    String? paymentModality,
    String? workdayType,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? contractSignedPdfUrl,
  });

  Future<RrhhEmployee> updateEmployeeBonuses(
    int id,
    List<RrhhEmployeeBonus> bonuses,
  );

  Future<RrhhEmployee> updateEmployeeDeductions(
    int id,
    List<RrhhEmployeeDeduction> deductions,
  );

  Future<RrhhEmployee> updateEmployeeAssignment(
    int id, {
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
  });

  Future<RrhhEmployee> updateEmployeeDocuments(
    int id,
    Map<String, String> documentChecklist,
  );

  // ---------------------------------------------------------------------------
  // EXPOSICIÓN PARA CONTABILIDAD (Solo Lectura)
  // ---------------------------------------------------------------------------
  Future<RrhhEmployeeContractData> getEmployeeContractData(int id);

  // ---------------------------------------------------------------------------
  // PANTALLA 04: Reclutamiento & Pipeline de Postulantes
  // ---------------------------------------------------------------------------
  Future<List<RrhhApplicantSummaryDto>> listApplicants({
    String? status,
    String? search,
  });
  Future<RrhhApplicant> getApplicantById(int id);
  Future<RrhhApplicantCompanion> getApplicantCompanion(int applicantId);
  Future<void> saveApplicantCompanion(
    int applicantId,
    RrhhApplicantCompanion companion,
  );
  Future<List<RrhhApplicant>> findApplicantsByCi(String identityCard);
  Future<RrhhApplicant> createApplicant(
    RrhhApplicant applicant, {
    RrhhApplicantCompanion? companion,
  });
  Future<RrhhApplicant> updateApplicant(RrhhApplicant applicant);
  Future<bool> deleteApplicant(int id);
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
    String? discardReason,
    bool? isEligibleForRehire,
  });
  Future<void> addInterviewRecord(
    int applicantId,
    RrhhInterviewRecord record,
  );

  // ---------------------------------------------------------------------------
  // PANTALLA 05: Contratación Formal & Expedientes de Contratación (FASE C)
  // ---------------------------------------------------------------------------
  Future<List<RrhhHiringDossier>> listActiveDossiers();
  Future<RrhhHiringDossier?> getDossierByApplicantId(int applicantId);
  Future<RrhhHiringDossier?> getDossierById(int id);
  Future<RrhhHiringDossier> createDossierForApplicant(int applicantId);
  Future<RrhhHiringDossier> updateDossierSection1(
    int id,
    Map<String, RrhhDossierDocument> documents, {
    String? sectionStatus,
  });
  Future<RrhhHiringDossier> updateDossierSection2(
    int id, {
    String? afpId,
    String? afpName,
    String? afpNumber,
    String? healthInsuranceId,
    String? healthInsuranceName,
    String? section2Notes,
    required String sectionStatus,
  });
  Future<RrhhHiringDossier> updateDossierSection3(
    int id, {
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    required String sectionStatus,
  });
  Future<RrhhHiringDossier> updateDossierSection4(
    int id, {
    String? contractTypeId,
    String? contractTypeName,
    String? workdayType,
    String? paymentModalityId,
    String? paymentModalityName,
    double? baseSalary,
    String? currency,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
    required String sectionStatus,
  });
  Future<RrhhHiringDossier> updateDossierSection5(
    int id, {
    String? areaId,
    String? areaName,
    String? positionId,
    String? positionName,
    String? shiftId,
    String? shiftName,
    String? scheduleId,
    String? scheduleName,
    String? baseLocation,
    String? supervisorEmployeeId,
    String? supervisorName,
    DateTime? effectiveStartDate,
    required String sectionStatus,
  });
  Future<RrhhHiringDossier> updateDossierSection6(
    int id, {
    String? closingNotes,
    String? approvedBy,
    required String sectionStatus,
  });
  Future<RrhhHiringDossier> updateDossierStatus(int id, String status);
  Future<bool> deleteDossier(int id);

  /// Convierte un expediente formalizado en empleado activo y actualiza el postulante.
  Future<RrhhEmployee> convertDossierToEmployee(int dossierId, {String? notes});

  Future<RrhhEmployee> hireApplicant({
    required int? applicantId,
    required RrhhEmployee employeeData,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 06: Estructura Organizacional
  // ---------------------------------------------------------------------------
  Future<List<RrhhArea>> listAreas();
  Future<RrhhArea> createArea(RrhhArea area);
  Future<RrhhArea> updateArea(RrhhArea area);

  Future<List<RrhhPosition>> listPositions();
  Future<RrhhPosition> createPosition(RrhhPosition position);
  Future<RrhhPosition> updatePosition(RrhhPosition position);

  Future<List<RrhhSpecialty>> listSpecialties();
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty);
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty);

  // ---------------------------------------------------------------------------
  // PANTALLA 07: Catálogo de Horarios y Turnos Base
  // ---------------------------------------------------------------------------
  Future<List<RrhhShift>> listShifts();
  Future<RrhhShift> createShift(RrhhShift shift);
  Future<RrhhShift> updateShift(RrhhShift shift);

  Future<List<RrhhBaseSchedule>> listBaseSchedules();
  Future<RrhhBaseSchedule> createBaseSchedule(RrhhBaseSchedule schedule);
  Future<RrhhBaseSchedule> updateBaseSchedule(RrhhBaseSchedule schedule);

  Future<List<RrhhSchedule>> listSchedules();
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule);
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule);

  // ---------------------------------------------------------------------------
  // CATÁLOGOS AUXILIARES MAESTROS (Bancos, AFPs, Seguros, Contratos, etc.)
  // ---------------------------------------------------------------------------
  Future<List<RrhhCatalogItem>> listCatalogItems(RrhhCatalogType type);
  Future<RrhhCatalogItem> createCatalogItem(RrhhCatalogItem item);
  Future<RrhhCatalogItem> updateCatalogItem(RrhhCatalogItem item);

  // ---------------------------------------------------------------------------
  // PANTALLA 08: Permisos y Licencias Médicas (Bloque 3)
  // ---------------------------------------------------------------------------
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    String? search,
    String? leaveType,
    String? status,
    bool? isPaid,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Future<RrhhLeaveRequest?> getLeaveRequestById(int id);
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request);
  Future<RrhhLeaveRequest> updateLeaveRequest(RrhhLeaveRequest request);
  Future<RrhhLeaveRequest> updateLeaveStatus(
    int id,
    String newStatus, {
    String? reason,
    String? approvedBy,
  });
  Future<bool> deleteLeaveRequest(int id);
  Future<List<RrhhLeaveRequest>> listPayrollAffectingLeaves(
    DateTime fromDate,
    DateTime toDate,
  );

  // ---------------------------------------------------------------------------
  // PANTALLA 09: Control de Vacaciones (Ley Laboral Bolivia)
  // ---------------------------------------------------------------------------
  Future<List<RrhhVacationRecord>> listVacationRecords({
    String? search,
    String? status,
    int? employeeId,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Future<RrhhVacationRecord?> getVacationRecordById(int id);
  Future<RrhhVacationRecord> createVacationRecord(RrhhVacationRecord record);
  Future<RrhhVacationRecord> updateVacationRecord(RrhhVacationRecord record);
  Future<RrhhVacationRecord> updateVacationStatus(
    int id,
    String newStatus, {
    String? reason,
  });
  Future<bool> deleteVacationRecord(int id);
  Future<List<RrhhVacationBalance>> listVacationBalances({
    String? search,
    String? balanceStatus,
    int? areaId,
  });
  Future<RrhhVacationBalance?> getVacationBalanceByEmployee(int employeeId);
  Future<List<RrhhVacationRecord>> listPayrollAffectingVacations(
    DateTime fromDate,
    DateTime toDate,
  );
  Future<List<RrhhVacation>> listVacations();
  Future<RrhhVacation> requestVacation(RrhhVacation vacation);
  Future<RrhhVacation> approveVacation(
    int vacationId, {
    required String approvedBy,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 10: Régimen Disciplinario e Incidencias (Ley Laboral Bolivia)
  // ---------------------------------------------------------------------------
  Future<List<RrhhDisciplinaryRecord>> listDisciplinaryRecords({
    String? status,
    String? faultType,
    String? sanctionType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Future<RrhhDisciplinaryRecord?> getDisciplinaryRecordById(int id);
  Future<RrhhDisciplinaryRecord> createDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  );
  Future<RrhhDisciplinaryRecord> updateDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  );
  Future<bool> updateDisciplinaryStatus(
    int id,
    String newStatus, {
    String? reason,
    String? dischargeText,
    String? sanctionType,
    int? suspensionDays,
    double? salaryDeduction,
    String? sanctionDescription,
  });
  Future<bool> deleteDisciplinaryRecord(int id);
  Future<List<RrhhDisciplinaryRecord>> listPayrollAffectingDisciplinary(
    DateTime fromDate,
    DateTime toDate,
  );

  Future<List<RrhhIncident>> listIncidents({
    String? severity,
    String? search,
  });
  Future<RrhhIncident> recordIncident(RrhhIncident incident);

  // ---------------------------------------------------------------------------
  // PANTALLA 11: Desvinculación & Bajas Laborales (Regla de Oro Inactivo / LGT Bolivia)
  // ---------------------------------------------------------------------------
  Future<List<RrhhTerminationRecord>> listTerminationRecords({
    String? status,
    String? terminationType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Future<RrhhTerminationRecord?> getTerminationRecordById(int id);
  Future<RrhhTerminationRecord> createTerminationRecord(
    RrhhTerminationRecord record,
  );
  Future<RrhhTerminationRecord> updateTerminationRecord(
    RrhhTerminationRecord record,
  );
  Future<bool> updateTerminationStatus(
    int id,
    String newStatus, {
    String? reason,
    bool? paymentCompleted,
    DateTime? paymentCompletedAt,
  });
  Future<bool> deleteTerminationRecord(int id);
  Future<List<RrhhTerminationRecord>> listPayrollAffectingTerminations(
    DateTime fromDate,
    DateTime toDate,
  );

  // Métodos legacy conservados para retrocompatibilidad
  Future<List<RrhhTermination>> listTerminations();
  Future<RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime exitDate,
    required String reason,
    required String exitObservations,
    required String registeredBy,
    required double severancePay,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 12: Novedades para Nómina (Entrega a Contabilidad)
  // ---------------------------------------------------------------------------
  Future<List<RrhhPayrollPeriod>> listPayrollPeriods();
  Future<RrhhPayrollPeriod?> getPayrollPeriodById(int id);
  Future<RrhhPayrollPeriod?> getPayrollPeriodByMonth(int year, int month);
  Future<RrhhPayrollPeriod> createPayrollPeriod(
    int year,
    int month, {
    String? notes,
  });
  Future<RrhhPayrollPeriod> closePayrollPeriod(
    int id, {
    String? closedBy,
    String? notes,
  });

  /// Este método será reemplazado por un endpoint HTTP cuando se conecte el backend real.
  /// Contabilidad consumirá los datos consolidados a través de este endpoint.
  Future<RrhhPayrollPeriod> sendPayrollPeriodToAccounting(
    int id, {
    String? sentBy,
  });
  Future<List<RrhhPayrollItem>> listPayrollItems(
    int periodId, {
    String? sourceType,
    String? impactType,
  });
  Future<List<RrhhPayrollItem>> generatePayrollItems(int periodId);
  Future<String> exportPayrollPeriod(int periodId, String format);
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(int month, int year);

  // ---------------------------------------------------------------------------
  // PANTALLA 13: Asistencia de Campo Consolidada (Recepción APK)
  // ---------------------------------------------------------------------------
  Future<List<RrhhAttendanceRecord>> listAttendanceRecords({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
    String? serviceName,
  });

  Future<RrhhAttendanceRecord?> getAttendanceRecordById(int id);

  Future<String> exportAttendanceReport({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
  });

  // ---------------------------------------------------------------------------
  // PANTALLA 14: Bitácora de Movimientos y Auditoría (Trazabilidad Inmutable)
  // ---------------------------------------------------------------------------
  Future<RrhhTimelineEvent?> getTimelineEventById(int id);
  List<String> listTimelineCategories();
  List<String> listActiveUsers();
  Future<RrhhTimelineEvent> addTimelineEvent(RrhhTimelineEvent event);
  Future<List<RrhhMovementHistory>> listMovements({
    String? movementType,
    int? employeeId,
    int? limit,
    int? offset,
  });

  // ---------------------------------------------------------------------------
  // Servicios de soporte / Referencias externas
  // ---------------------------------------------------------------------------
  Future<List<CrmClientRefDto>> listClientReferences();
}
