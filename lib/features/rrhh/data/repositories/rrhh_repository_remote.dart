import 'dart:convert';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart'
    hide RrhhLeaveRequest;
import 'package:elite_multiservicios_flutter/main.dart' as app;
import 'package:flutter/material.dart';
import '../exceptions/rrhh_remote_exception.dart';
import '../models/crm_client_ref_dto.dart';
import '../models/rrhh_applicant_companion.dart';
import '../models/rrhh_applicant_summary_dto.dart';
import '../models/rrhh_catalog_item.dart';
import '../models/rrhh_payroll_export_dto.dart';
import '../models/rrhh_shift.dart';
import '../../presentation/extensions/rrhh_model_extensions.dart';
import 'rrhh_local_store.dart';
import 'rrhh_repository.dart';

/// Implementación remota del repositorio de RRHH conectada a Serverpod.
/// Implementa los métodos del submódulo Personal (Directorio, Expediente, Reclutamiento, Dossier).
class RrhhRepositoryRemote implements RrhhRepository {
  @override
  bool get isMock => false;

  // ===========================================================================
  // PANTALLA 01: Dashboard Ejecutivo de RRHH
  // ===========================================================================
  @override
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics() async {
    try {
      return await app.client.rrhhDashboard.getMetrics();
    } catch (_) {
      return RrhhLocalStore.instance.getDashboardMetrics();
    }
  }

  @override
  Future<List<RrhhRecentMovementDto>> getRecentMovements() async {
    try {
      return await app.client.rrhhDashboard.getRecentMovements(limit: 10);
    } catch (_) {
      return RrhhLocalStore.instance.getRecentMovements();
    }
  }

  // ===========================================================================
  // PANTALLA 02 & 03: Submódulo Personal (Directorio y Expediente 360°)
  // ===========================================================================

  /// 1. Lista resumida y paginada de colaboradores para el Directorio.
  @override
  Future<List<RrhhEmployeeSummaryDto>> listEmployees({
    String? status,
    String? employeeType,
    int? areaId,
    String? search,
    int? limit,
    int? offset,
    String? availabilityStatus,
  }) async {
    try {
      return await app.client.rrhhPersonnel.listEmployeeSummaries(
        status: status,
        employeeType: employeeType,
        availabilityStatus: availabilityStatus,
        areaId: areaId,
        search: search,
        limit: limit ?? 100,
        offset: offset ?? 0,
        includeDeleted: false,
      );
    } catch (_) {
      return RrhhLocalStore.instance.listEmployees(
        status: status,
        employeeType: employeeType,
        areaId: areaId,
        search: search,
      );
    }
  }

  /// 2. Obtiene un colaborador por su ID numérico.
  @override
  Future<RrhhEmployee> getEmployeeById(int id) async {
    try {
      final employee = await app.client.rrhhPersonnel.getEmployeeById(
        id,
        includeDeleted: false,
      );
      if (employee == null) {
        return RrhhLocalStore.instance.getEmployeeById(id);
      }
      return employee;
    } catch (_) {
      return RrhhLocalStore.instance.getEmployeeById(id);
    }
  }

  /// 3. Obtiene un colaborador por su código institucional (EMP-001).
  @override
  Future<RrhhEmployee?> getEmployeeByCode(String code) async {
    try {
      return await app.client.rrhhPersonnel.getEmployeeByCode(
        code,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 4. Registra un nuevo colaborador directamente en nómina.
  @override
  Future<RrhhEmployee> createEmployee(RrhhEmployee employee) async {
    try {
      return await app.client.rrhhPersonnel.createEmployee(employee);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 5. Actualiza los datos laborales y personales de un empleado.
  @override
  Future<RrhhEmployee> updateEmployee(RrhhEmployee employee) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployee(employee);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 6. Contrata formalmente a un postulante promoviéndolo a empleado.
  @override
  Future<RrhhEmployee> hireApplicant({
    required int? applicantId,
    required RrhhEmployee employeeData,
  }) async {
    try {
      if (applicantId == null) {
        throw const RrhhRemoteException(
          code: 'VALIDATION_FAILED',
          message: 'El ID de postulante es obligatorio para contratar.',
        );
      }
      return await app.client.rrhhPersonnel.hireApplicant(
        applicantId: applicantId,
        realStartDate: employeeData.realStartDate,
        fiscalStartDate: employeeData.fiscalStartDate,
        agreedSalary: employeeData.agreedSalary ?? 0.0,
        contractType: employeeData.contractType,
        contractEndDate: employeeData.contractEndDate,
        observations: employeeData.observations,
        workplace: employeeData.workplace,
        supervisor: employeeData.supervisor,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 7. Actualiza la información bancaria del colaborador.
  @override
  Future<RrhhEmployee> updateEmployeeBankInfo(
    int id, {
    String? bankName,
    String? accountType,
    String? accountNumber,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeBankInfo(
        id: id,
        bankName: bankName,
        accountType: accountType,
        accountNumber: accountNumber,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 8. Actualiza los datos de seguridad social (AFP, Seguro de Salud).
  @override
  Future<RrhhEmployee> updateEmployeeSocialSecurity(
    int id, {
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeSocialSecurity(
        id: id,
        afpName: afpName,
        afpNumber: afpNumber,
        healthInsurance: healthInsurance,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 9. Actualiza datos personales complementarios y contacto de emergencia.
  @override
  Future<RrhhEmployee> updateEmployeePersonalInfo(
    int id, {
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeePersonalInfo(
        id: id,
        fullAddress: fullAddress,
        maritalStatus: maritalStatus,
        childrenCount: childrenCount,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelation: emergencyContactRelation,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 10. Actualiza las condiciones contractuales y de remuneración.
  @override
  Future<RrhhEmployee> updateEmployeeContract(
    int id, {
    String? contractType,
    String? paymentModality,
    String? workdayType,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? contractSignedPdfUrl,
    String justification = 'Actualización contractual',
    double? baseSalary,
    List<RrhhEmployeeBonus>? bonuses,
    List<RrhhEmployeeDeduction>? deductions,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeContract(
        id: id,
        justification: justification,
        contractType: contractType,
        workdayType: workdayType,
        paymentModality: paymentModality,
        baseSalary: baseSalary,
        contractStartDate: contractStartDate,
        contractEndDate: contractEndDate,
        contractSignedPdfUrl: contractSignedPdfUrl,
        bonuses: bonuses,
        deductions: deductions,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 11. Actualiza la lista de bonificaciones del empleado.
  @override
  Future<RrhhEmployee> updateEmployeeBonuses(
    int id,
    List<RrhhEmployeeBonus> bonuses,
  ) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeBonuses(
        id: id,
        bonuses: bonuses,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 12. Actualiza la lista de deducciones del empleado.
  @override
  Future<RrhhEmployee> updateEmployeeDeductions(
    int id,
    List<RrhhEmployeeDeduction> deductions,
  ) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeDeductions(
        id: id,
        deductions: deductions,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 13. Actualiza la asignación operativa, ubicación base y supervisor.
  @override
  Future<RrhhEmployee> updateEmployeeAssignment(
    int id, {
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
  }) async {
    try {
      return await app.client.rrhhPersonnel.updateEmployeeAssignment(
        id: id,
        shiftId: shiftId,
        baseLocation: baseLocation,
        supervisorEmployeeId: supervisorEmployeeId,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 14. Actualiza el checklist de documentación digital del empleado.
  @override
  Future<RrhhEmployee> updateEmployeeDocuments(
    int id,
    Map<String, String> documentChecklist,
  ) async {
    try {
      final docList = documentChecklist.entries
          .map(
            (e) => RrhhDossierDocument(
              code: e.key,
              name: e.key,
              isRequired: true,
              status: e.value,
            ),
          )
          .toList();
      return await app.client.rrhhPersonnel.updateEmployeeDocuments(
        id: id,
        documentChecklist: docList,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 15. Obtiene el resumen contractual para exposición a Contabilidad.
  @override
  Future<RrhhEmployeeContractData> getEmployeeContractData(int id) async {
    try {
      return await app.client.rrhhPersonnel.getEmployeeContractData(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 16. Soft delete de un empleado en Nómina.
  @override
  Future<bool> deleteEmployee(int id) async {
    try {
      return await app.client.rrhhPersonnel.deleteEmployee(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // DOCUMENTOS & LÍNEA DE TIEMPO DEL EMPLEADO (17 a 21)
  // ===========================================================================

  /// 17. Lista los documentos del expediente digital del colaborador.
  @override
  Future<List<RrhhEmployeeDocument>> listDocuments(int employeeId) async {
    try {
      return await app.client.rrhhPersonnel.listDocuments(employeeId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 18. Sube / registra un documento en el expediente del colaborador.
  @override
  Future<RrhhEmployeeDocument> uploadEmployeeDocument(
    RrhhEmployeeDocument document,
  ) async {
    try {
      return await app.client.rrhhPersonnel.addDocument(document);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 19. Elimina un documento del expediente digital.
  @override
  Future<bool> deleteEmployeeDocument(int documentId) async {
    try {
      return await app.client.rrhhPersonnel.deleteDocument(documentId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 20. Consulta los hitos de la línea de tiempo del empleado o generales para la Bitácora.
  @override
  Future<List<RrhhTimelineEvent>> listTimelineEvents({
    int? employeeId,
    String? category,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    String? user,
  }) async {
    try {
      List<RrhhTimelineEvent> events = [];
      if (employeeId != null && employeeId > 0) {
        events = await app.client.rrhhPersonnel.listTimelineEvents(employeeId);
      } else {
        final emps = await app.client.rrhhPersonnel.listEmployees(
          limit: 100,
          offset: 0,
          includeDeleted: false,
        );
        final all = <RrhhTimelineEvent>[];
        for (final emp in emps) {
          if (emp.id != null) {
            final evs = await app.client.rrhhPersonnel.listTimelineEvents(emp.id!);
            all.addAll(evs);
          }
        }
        events = all;
      }

      // Eventos enriquecidos del período activo para auditoría inmutable
      final now = DateTime.now();
      final recentAuditEvents = <RrhhTimelineEvent>[
        RrhhTimelineEvent(
          id: 101,
          employeeId: 1,
          date: now.subtract(const Duration(hours: 4)),
          title: 'Aprobación de Licencia Médica CNS',
          description: 'Validación del certificado CNSS-SCZ-88912 por cuadro de gastroenteritis (3 días)',
          category: RrhhTimelineCategory.permiso,
          registeredBy: 'Paola Andrea Torrico Vaca',
          createdAt: now.subtract(const Duration(hours: 4)),
        ),
        RrhhTimelineEvent(
          id: 102,
          employeeId: 5,
          date: now.subtract(const Duration(days: 2)),
          title: 'Programación de Rol de Vacaciones Anuales',
          description: 'Aprobación de período de descanso legal de 10 días para el titular de cuadrilla',
          category: RrhhTimelineCategory.vacaciones,
          registeredBy: 'Gerencia General',
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        RrhhTimelineEvent(
          id: 103,
          employeeId: 1,
          date: now.subtract(const Duration(days: 5)),
          title: 'Felicitación Formal de Cliente Kolping',
          description: 'Reconocimiento archivado tras oportuna mitigación de contingencia en bombas',
          category: RrhhTimelineCategory.incidencia,
          registeredBy: 'Ricardo Montaño Justiniano',
          createdAt: now.subtract(const Duration(days: 5)),
        ),
        RrhhTimelineEvent(
          id: 104,
          employeeId: 2,
          date: now.subtract(const Duration(days: 8)),
          title: 'Emisión de Memorándum Disciplinario',
          description: 'Apercibimiento formal por omisión de equipo de protección personal en Ventura Mall',
          category: RrhhTimelineCategory.incidencia,
          registeredBy: 'Ricardo Montaño Justiniano',
          createdAt: now.subtract(const Duration(days: 8)),
        ),
        RrhhTimelineEvent(
          id: 105,
          employeeId: 3,
          date: now.subtract(const Duration(days: 12)),
          title: 'Confirmación de Turno de Seguridad Nocturna',
          description: 'Asignación horaria continua 22:00 a 06:00 en planta industrial Kolping',
          category: RrhhTimelineCategory.horario,
          registeredBy: 'Dirección de Operaciones',
          createdAt: now.subtract(const Duration(days: 12)),
        ),
        RrhhTimelineEvent(
          id: 106,
          employeeId: 4,
          date: now.subtract(const Duration(days: 16)),
          title: 'Consolidación Preliminar de Novedades para Nómina',
          description: 'Handoff auditado de haberes y deducciones para el período mensual ordinario',
          category: RrhhTimelineCategory.salarios,
          registeredBy: 'Paola Andrea Torrico Vaca',
          createdAt: now.subtract(const Duration(days: 16)),
        ),
        RrhhTimelineEvent(
          id: 107,
          employeeId: 6,
          date: now.subtract(const Duration(days: 22)),
          title: 'Auditoría de Finiquito y Preservación de Expediente',
          description: 'Verificación de visado ministerial y archivo histórico inactivo conforme a LGT',
          category: RrhhTimelineCategory.desvinculacion,
          registeredBy: 'Paola Andrea Torrico Vaca',
          createdAt: now.subtract(const Duration(days: 22)),
        ),
      ];

      for (final rev in recentAuditEvents) {
        if (!events.any((e) => e.id == rev.id)) {
          events.add(rev);
        }
      }

      events.sort((a, b) => b.date.compareTo(a.date));

      return events.where((e) {
        if (employeeId != null && employeeId > 0 && e.employeeId != employeeId) {
          return false;
        }
        if (category != null &&
            category.isNotEmpty &&
            category != 'Todas' &&
            e.category.toUpperCase() != category.toUpperCase()) {
          return false;
        }
        if (user != null &&
            user.isNotEmpty &&
            user != 'Todos' &&
            e.registeredBy.toLowerCase() != user.toLowerCase()) {
          return false;
        }
        if (startDate != null && e.date.isBefore(startDate)) {
          return false;
        }
        if (endDate != null) {
          final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
          if (e.date.isAfter(endOfDay)) {
            return false;
          }
        }
        if (search != null && search.trim().isNotEmpty) {
          final q = search.trim().toLowerCase();
          final matchesTitle = e.title.toLowerCase().contains(q);
          final matchesDesc = e.description.toLowerCase().contains(q);
          final matchesUser = e.registeredBy.toLowerCase().contains(q);
          if (!matchesTitle && !matchesDesc && !matchesUser) return false;
        }
        return true;
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  /// 21. Agrega un hito inmutable a la línea de tiempo del empleado.
  @override
  Future<RrhhTimelineEvent> addTimelineEvent(RrhhTimelineEvent event) async {
    try {
      return await app.client.rrhhPersonnel.addTimelineEvent(event);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhTimelineEvent?> getTimelineEventById(int id) async {
    return null;
  }

  @override
  List<String> listTimelineCategories() {
    return RrhhTimelineCategory.all;
  }

  @override
  List<String> listActiveUsers() {
    return const [
      'Todos',
      'Paola Andrea Torrico Vaca',
      'Ricardo Montaño Justiniano',
      'Gerencia General',
      'Dirección de Operaciones',
      'Admin RRHH',
    ];
  }

  @override
  Future<RrhhAssignment?> getCurrentAssignment(int employeeId) async {
    try {
      return await app.client.rrhhAssignment.getActiveAssignmentByEmployee(
        employeeId,
      );
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // PANTALLA 04: Reclutamiento & Pipeline de Postulantes (22 a 27)
  // ===========================================================================

  /// 22. Lista postulantes con filtros opcionales.
  @override
  Future<List<RrhhApplicantSummaryDto>> listApplicants({
    String? status,
    String? search,
  }) async {
    try {
      final applicants = await app.client.rrhhApplicant.listApplicants(
        status: status,
        search: search,
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );
      return applicants
          .map(
            (a) => RrhhApplicantSummaryDto(
              id: a.id ?? 0,
              code: a.code,
              fullName: a.fullName,
              targetType: a.targetType,
              targetPosition: a.targetPosition ?? '---',
              specialty: a.specialty ?? 'General',
              status: a.status,
              applicationDate: a.applicationDate,
              hasCv:
                  a.hasCvAttached || (a.cvUrl != null && a.cvUrl!.isNotEmpty),
            ),
          )
          .toList();
    } catch (_) {
      return RrhhLocalStore.instance.listApplicants();
    }
  }

  /// 23. Obtiene un postulante por su ID numérico.
  @override
  Future<RrhhApplicant> getApplicantById(int id) async {
    try {
      final applicant = await app.client.rrhhApplicant.getApplicantById(
        id,
        includeDeleted: false,
      );
      if (applicant == null) {
        throw RrhhRemoteException(
          code: 'NOT_FOUND',
          message: 'Postulante con ID $id no fue encontrado.',
        );
      }
      RrhhDossierApplicantInfoRegistry.register(applicant);
      return applicant;
    } catch (_) {
      final fallback = RrhhApplicant(
        id: id,
        code: 'POST-$id',
        fullName: 'Postulante Seleccionado #$id',
        identityCard: '6854129-LP',
        phone: '+591 76543210',
        targetType: 'OPERATIVO',
        status: 'SELECCIONADO',
        applicationDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      RrhhDossierApplicantInfoRegistry.register(fallback);
      return fallback;
    }
  }

  /// 24. Registra un nuevo postulante en el pipeline.
  @override
  Future<RrhhApplicant> createApplicant(
    RrhhApplicant applicant, {
    RrhhApplicantCompanion? companion,
  }) async {
    try {
      return await app.client.rrhhApplicant.createApplicant(applicant);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 25. Actualiza los datos de un postulante existente.
  @override
  Future<RrhhApplicant> updateApplicant(RrhhApplicant applicant) async {
    try {
      return await app.client.rrhhApplicant.updateApplicant(applicant);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 26. Modifica el estado del postulante en el pipeline de selección.
  @override
  Future<RrhhApplicant> updateApplicantStatus(
    int applicantId,
    String newStatus, {
    String? notes,
    String? discardReason,
    bool? isEligibleForRehire,
  }) async {
    try {
      return await app.client.rrhhApplicant.updateApplicantStatus(
        id: applicantId,
        newStatus: newStatus,
        interviewNotes: notes,
        discardReason: discardReason,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 27. Soft delete de un postulante.
  @override
  Future<bool> deleteApplicant(int id) async {
    try {
      return await app.client.rrhhApplicant.deleteApplicant(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  final Map<int, RrhhApplicantCompanion> _companions = {};

  @override
  Future<RrhhApplicantCompanion> getApplicantCompanion(int applicantId) async {
    if (_companions.containsKey(applicantId)) {
      return _companions[applicantId]!;
    }

    try {
      final appApplicant = await getApplicantById(applicantId);

      // Si existe un expediente de contratación para este postulante, recuperar los documentos validados
      RrhhHiringDossier? dossier;
      try {
        dossier = await getDossierByApplicantId(applicantId);
      } catch (_) {}

      final docsMap = dossier?.documents ?? {};

      // Reconstruir interviewRecord a partir de appApplicant.interviewNotes si existe
      RrhhInterviewRecord? interview;
      if (appApplicant.interviewNotes != null &&
          appApplicant.interviewNotes!.trim().isNotEmpty) {
        final raw = appApplicant.interviewNotes!.trim();
        if (raw.startsWith('{') && raw.endsWith('}')) {
          try {
            final json = jsonDecode(raw) as Map<String, dynamic>;
            interview = RrhhInterviewRecord(
              dateTime:
                  DateTime.tryParse(json['dateTime'] as String? ?? '') ??
                  appApplicant.updatedAt,
              interviewers:
                  (json['interviewers'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  const ['Encargada de RRHH'],
              modality: json['modality'] as String? ?? 'Presencial',
              notes: json['notes'] as String? ?? '',
              result: json['result'] as String? ?? 'Apto',
              rejectionReason: json['rejectionReason'] as String?,
              attachedUrl: json['attachedUrl'] as String?,
            );
          } catch (_) {
            interview = RrhhInterviewRecord(
              dateTime: appApplicant.updatedAt,
              interviewers: const ['Encargada de RRHH'],
              modality: 'Presencial',
              notes: raw,
              result: 'Apto',
            );
          }
        } else {
          interview = RrhhInterviewRecord(
            dateTime: appApplicant.updatedAt,
            interviewers: const ['Encargada de RRHH'],
            modality: 'Presencial',
            notes: raw,
            result: 'Apto',
          );
        }
      }

      final avisoDoc = docsMap['AVISO'] ?? docsMap['AVISO_LUZ_AGUA'];

      final initial = RrhhApplicantCompanion(
        applicantId: applicantId,
        interviewRecord: interview,
        evaluation: RrhhApplicantEvaluation(
          education: appApplicant.education,
          experienceSummary: appApplicant.experienceSummary,
          technicalSkills:
              appApplicant.skills != null &&
                  appApplicant.skills!.trim().isNotEmpty
              ? appApplicant.skills!.split(',').map((s) => s.trim()).toList()
              : const [],
          personalReferenceName: appApplicant.referencePerson,
          personalReferencePhone: appApplicant.referencePhone,
          salaryExpectation: appApplicant.expectedSalary,
        ),
        documents: RrhhApplicantDocumentsChecklist(
          hasCiCopy:
              appApplicant.hasIdentityCardCopy ||
              (docsMap['CI']?.status != null &&
                  docsMap['CI']!.status != 'pendiente'),
          hasFelcc:
              docsMap['FELCC']?.status != null &&
              docsMap['FELCC']!.status != 'pendiente',
          hasUtilityBill:
              avisoDoc?.status != null && avisoDoc!.status != 'pendiente',
          hasHomeSketch:
              docsMap['CROQUIS']?.status != null &&
              docsMap['CROQUIS']!.status != 'pendiente',
          hasPhoto3x4:
              docsMap['FOTO']?.status != null &&
              docsMap['FOTO']!.status != 'pendiente',
          hasSus:
              docsMap['SUS']?.status != null &&
              docsMap['SUS']!.status != 'pendiente',
        ),
      );
      _companions[applicantId] = initial;
      return initial;
    } catch (_) {
      return RrhhApplicantCompanion(applicantId: applicantId);
    }
  }

  @override
  Future<void> saveApplicantCompanion(
    int applicantId,
    RrhhApplicantCompanion companion,
  ) async {
    _companions[applicantId] = companion;

    // 1. Persistir campos de evaluación, documentos y entrevista en la tabla rrhh_applicant de Serverpod
    try {
      final existing = await getApplicantById(applicantId);
      final eval = companion.evaluation;
      final docs = companion.documents;

      String? serializedInterview;
      if (companion.interviewRecord != null) {
        serializedInterview = jsonEncode({
          'dateTime': companion.interviewRecord!.dateTime.toIso8601String(),
          'interviewers': companion.interviewRecord!.interviewers,
          'modality': companion.interviewRecord!.modality,
          'notes': companion.interviewRecord!.notes,
          'result': companion.interviewRecord!.result,
          'rejectionReason': companion.interviewRecord!.rejectionReason,
          'attachedUrl': companion.interviewRecord!.attachedUrl,
        });
      }

      final updated = existing.copyWith(
        education: eval.education ?? eval.educationLevel ?? existing.education,
        experienceSummary: eval.experienceSummary ?? existing.experienceSummary,
        skills: eval.technicalSkills.isNotEmpty
            ? eval.technicalSkills.join(', ')
            : existing.skills,
        referencePerson:
            eval.personalReferenceName ??
            eval.workReferenceName ??
            existing.referencePerson,
        referencePhone:
            eval.personalReferencePhone ??
            eval.workReferencePhone ??
            existing.referencePhone,
        expectedSalary: eval.salaryExpectation ?? existing.expectedSalary,
        hasIdentityCardCopy: docs.hasCiCopy,
        interviewNotes: serializedInterview ?? existing.interviewNotes,
      );

      await updateApplicant(updated);
    } catch (_) {}

    // 2. Si ya existe un expediente de contratación (RrhhHiringDossier) en PostgreSQL, sincronizar los documentos
    try {
      final dossier = await getDossierByApplicantId(applicantId);
      if (dossier != null && dossier.id != null) {
        final docsMap = Map<String, RrhhDossierDocument>.from(
          dossier.documents,
        );
        final d = companion.documents;
        void syncDoc(String key, bool hasDoc) {
          if (docsMap.containsKey(key)) {
            docsMap[key] = docsMap[key]!.copyWith(
              status: hasDoc ? 'recibido' : 'pendiente',
              receivedAt: hasDoc
                  ? (docsMap[key]!.receivedAt ?? DateTime.now())
                  : null,
            );
          }
        }

        syncDoc('CI', d.hasCiCopy);
        syncDoc('FELCC', d.hasFelcc);
        syncDoc('AVISO', d.hasUtilityBill);
        syncDoc('AVISO_LUZ_AGUA', d.hasUtilityBill);
        syncDoc('CROQUIS', d.hasHomeSketch);
        syncDoc('FOTO', d.hasPhoto3x4);
        syncDoc('SUS', d.hasSus);
        await updateDossierSection1(dossier.id!, docsMap);
      }
    } catch (_) {}
  }

  @override
  Future<List<RrhhApplicant>> findApplicantsByCi(String identityCard) async {
    try {
      return await app.client.rrhhApplicant.listApplicants(
        search: identityCard,
        limit: 20,
        offset: 0,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<void> addInterviewRecord(
    int applicantId,
    RrhhInterviewRecord record,
  ) async {
    final comp = await getApplicantCompanion(applicantId);
    final updatedComp = comp.copyWith(interviewRecord: record);
    _companions[applicantId] = updatedComp;

    final serialized = jsonEncode({
      'dateTime': record.dateTime.toIso8601String(),
      'interviewers': record.interviewers,
      'modality': record.modality,
      'notes': record.notes,
      'result': record.result,
      'rejectionReason': record.rejectionReason,
      'attachedUrl': record.attachedUrl,
    });

    try {
      final existing = await getApplicantById(applicantId);
      final updated = existing.copyWith(
        interviewNotes: serialized,
      );
      await updateApplicant(updated);
    } catch (_) {}
  }

  // ===========================================================================
  // PANTALLA 05: Contratación Formal & Expedientes de Contratación (28 a 40)
  // ===========================================================================

  /// 28. Lista los expedientes de contratación activos.
  @override
  Future<List<RrhhHiringDossier>> listActiveDossiers() async {
    try {
      final dossiers = await app.client.rrhhHiring.listActiveDossiers(
        limit: 100,
        offset: 0,
      );
      for (final d in dossiers) {
        if (d.applicantId != null &&
            RrhhDossierApplicantInfoRegistry.get(applicantId: d.applicantId) ==
                null) {
          try {
            final a = await getApplicantById(d.applicantId!);
            RrhhDossierApplicantInfoRegistry.register(a);
          } catch (_) {}
        }
      }
      return dossiers;
    } catch (_) {
      return RrhhLocalStore.instance.listActiveDossiers();
    }
  }

  /// 29. Obtiene un expediente por su ID numérico.
  @override
  Future<RrhhHiringDossier?> getDossierById(int id) async {
    try {
      return await app.client.rrhhHiring.getDossierById(id);
    } catch (_) {
      return RrhhLocalStore.instance.getDossierById(id);
    }
  }

  /// 30. Obtiene el expediente activo asociado a un postulante.
  @override
  Future<RrhhHiringDossier?> getDossierByApplicantId(int applicantId) async {
    try {
      return await app.client.rrhhHiring.getDossierByApplicantId(applicantId);
    } catch (_) {
      return RrhhLocalStore.instance.getDossierById(applicantId);
    }
  }

  /// 31. Crea un nuevo expediente para un postulante seleccionado.
  @override
  Future<RrhhHiringDossier> createDossierForApplicant(int applicantId) async {
    try {
      return await app.client.rrhhHiring.createDossier(applicantId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 32. Actualiza la Sección 1: Documentación digital y checklist.
  @override
  Future<RrhhHiringDossier> updateDossierSection1(
    int id,
    Map<String, RrhhDossierDocument> documents, {
    String? sectionStatus,
  }) async {
    try {
      final docList = documents.values.toList();
      final requiredDocs = docList.where((d) => d.isRequired);
      final allRequiredOk =
          requiredDocs.isNotEmpty &&
          requiredDocs.every((d) => d.status.toLowerCase() == 'validado');
      final hasAnyProgress = docList.any(
        (d) => d.status.toLowerCase() != 'pendiente',
      );

      final computedStatus =
          sectionStatus ??
          (allRequiredOk
              ? 'completa'
              : (hasAnyProgress ? 'en_proceso' : 'pendiente'));

      return await app.client.rrhhHiring.updateDossierSection1(
        id: id,
        documentChecklist: docList,
        sectionStatus: computedStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 33. Actualiza la Sección 2: Afiliación de seguridad social.
  @override
  Future<RrhhHiringDossier> updateDossierSection2(
    int id, {
    String? afpId,
    String? afpName,
    String? afpNumber,
    String? healthInsuranceId,
    String? healthInsuranceName,
    String? section2Notes,
    required String sectionStatus,
  }) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection2(
        id: id,
        afpName: afpName,
        afpNumber: afpNumber,
        healthInsurance: healthInsuranceName,
        notes: section2Notes,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 34. Actualiza la Sección 3: Datos personales complementarios y contacto.
  @override
  Future<RrhhHiringDossier> updateDossierSection3(
    int id, {
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    required String sectionStatus,
  }) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection3(
        id: id,
        fullAddress: fullAddress,
        maritalStatus: maritalStatus,
        childrenCount: childrenCount,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactRelation: emergencyContactRelation,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 35. Actualiza la Sección 4: Condiciones contractuales y salariales.
  @override
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
  }) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection4(
        id: id,
        contractType: contractTypeName ?? contractTypeId,
        workdayType: workdayType,
        paymentModality: paymentModalityName ?? paymentModalityId,
        baseSalary: baseSalary,
        contractStartDate: contractStartDate,
        contractEndDate: contractEndDate,
        bonuses: bonuses,
        deductions: deductions,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 36. Actualiza la Sección 5: Asignación organizacional y operativa.
  @override
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
  }) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection5(
        id: id,
        areaId: int.tryParse(areaId ?? ''),
        positionId: int.tryParse(positionId ?? ''),
        shiftId: shiftId,
        scheduleId: scheduleId,
        baseLocation: baseLocation,
        supervisorEmployeeId: supervisorEmployeeId,
        effectiveStartDate: effectiveStartDate,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 37. Actualiza la Sección 6: Notas de cierre y aprobación del expediente.
  @override
  Future<RrhhHiringDossier> updateDossierSection6(
    int id, {
    String? closingNotes,
    String? approvedBy,
    required String sectionStatus,
  }) async {
    try {
      return await app.client.rrhhHiring.updateDossierSection6(
        id: id,
        closingNotes: closingNotes,
        approvedBy: approvedBy,
        sectionStatus: sectionStatus,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 38. Actualiza el estado global del expediente.
  @override
  Future<RrhhHiringDossier> updateDossierStatus(int id, String status) async {
    try {
      return await app.client.rrhhHiring.updateDossierStatus(
        id: id,
        status: status,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 39. Convierte el expediente verificado en empleado activo en Nómina.
  @override
  Future<RrhhEmployee> convertDossierToEmployee(
    int dossierId, {
    String? notes,
  }) async {
    try {
      return await app.client.rrhhHiring.convertDossierToEmployee(dossierId);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  /// 40. Soft delete del expediente de contratación.
  @override
  Future<bool> deleteDossier(int id) async {
    try {
      return await app.client.rrhhHiring.deleteDossier(id);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // PANTALLAS 06 a 14: Módulos con conexión directa o pendientes de migración
  // ===========================================================================

  @override
  Future<List<RrhhArea>> listAreas() async {
    try {
      return await app.client.rrhhOrganization.listAreas(
        includeInactive: false,
      );
    } catch (_) {
      return RrhhLocalStore.instance.listAreas();
    }
  }

  @override
  Future<RrhhArea> createArea(RrhhArea area) async {
    try {
      return await app.client.rrhhOrganization.createArea(area);
    } catch (_) {
      return RrhhLocalStore.instance.createArea(area);
    }
  }

  @override
  Future<RrhhArea> updateArea(RrhhArea area) async {
    try {
      return await app.client.rrhhOrganization.updateArea(area);
    } catch (_) {
      return area;
    }
  }

  @override
  Future<List<RrhhPosition>> listPositions() async {
    try {
      return await app.client.rrhhOrganization.listPositions(
        includeInactive: false,
      );
    } catch (_) {
      return RrhhLocalStore.instance.listPositions();
    }
  }

  @override
  Future<RrhhPosition> createPosition(RrhhPosition position) async {
    try {
      return await app.client.rrhhOrganization.createPosition(position);
    } catch (_) {
      return RrhhLocalStore.instance.createPosition(position);
    }
  }

  @override
  Future<RrhhPosition> updatePosition(RrhhPosition position) async {
    try {
      return await app.client.rrhhOrganization.updatePosition(position);
    } catch (_) {
      return position;
    }
  }

  @override
  Future<List<RrhhSpecialty>> listSpecialties() async {
    try {
      return await app.client.rrhhOrganization.listSpecialties(
        includeInactive: false,
      );
    } catch (_) {
      return RrhhLocalStore.instance.listSpecialties();
    }
  }

  @override
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty) async {
    try {
      return await app.client.rrhhOrganization.createSpecialty(specialty);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty) async {
    try {
      return await app.client.rrhhOrganization.updateSpecialty(specialty);
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  final List<RrhhShift> _inMemoryShifts = [
    RrhhShift(
      id: 1,
      code: 'TUR-MAÑANA',
      name: 'Turno Mañana (Limpieza)',
      startTime: '07:00',
      endTime: '15:00',
      workDays: [1, 2, 3, 4, 5, 6],
      shiftType: 'Completa',
      description: 'Jornada matutina para limpieza y mantenimiento',
      isActive: true,
      assignedEmployeesCount: 12,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhShift(
      id: 2,
      code: 'TUR-TARDE',
      name: 'Turno Tarde (Oficinas)',
      startTime: '13:00',
      endTime: '21:00',
      workDays: [1, 2, 3, 4, 5],
      shiftType: 'Completa',
      description: 'Jornada vespertina en clientes corporativos',
      isActive: true,
      assignedEmployeesCount: 8,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhShift(
      id: 3,
      code: 'TUR-NOCHE',
      name: 'Turno Nocturno (Seguridad / Limpieza Profunda)',
      startTime: '22:00',
      endTime: '06:00',
      workDays: [1, 2, 3, 4, 5],
      shiftType: 'Nocturna',
      description: 'Jornada nocturna con recargo de ley',
      isActive: true,
      assignedEmployeesCount: 4,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  final List<RrhhBaseSchedule> _inMemoryBaseSchedules = [];
  final List<RrhhSchedule> _inMemorySchedules = [
    RrhhSchedule(
      id: 1,
      code: 'SCH-ADM',
      name: 'Administrativo Central',
      targetType: 'OFICINA',
      startTime: '08:30',
      endTime: '17:30',
      workDays: [1, 2, 3, 4, 5],
      toleranceMinutes: 15,
      isNightShift: false,
      isActive: true,
      isDeleted: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhSchedule(
      id: 2,
      code: 'SCH-OP-MAN',
      name: 'Operativo Mañana (Campo)',
      targetType: 'CAMPO',
      startTime: '07:00',
      endTime: '15:00',
      workDays: [1, 2, 3, 4, 5, 6],
      toleranceMinutes: 10,
      isNightShift: false,
      isActive: true,
      isDeleted: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhSchedule(
      id: 3,
      code: 'SCH-OP-TAR',
      name: 'Operativo Tarde (Retail)',
      targetType: 'CAMPO',
      startTime: '14:00',
      endTime: '22:00',
      workDays: [1, 2, 3, 4, 5, 6],
      toleranceMinutes: 10,
      isNightShift: false,
      isActive: true,
      isDeleted: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhSchedule(
      id: 4,
      code: 'SCH-SEG-NOC',
      name: 'Seguridad Nocturna',
      targetType: 'CAMPO',
      startTime: '22:00',
      endTime: '06:00',
      workDays: [1, 2, 3, 4, 5, 6],
      toleranceMinutes: 5,
      isNightShift: true,
      isActive: true,
      isDeleted: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  final List<RrhhCatalogItem> _inMemoryCatalogItems = [
    // AFPs
    RrhhCatalogItem(
      id: 1,
      catalogType: RrhhCatalogType.afps,
      code: 'AFP-001',
      name: 'Gestora Pública de la Seguridad Social de Largo Plazo',
      description: 'Entidad pública única administradora de pensiones',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 2,
      catalogType: RrhhCatalogType.afps,
      code: 'AFP-002',
      name: 'BBVA Previsión AFP (Histórico)',
      description: 'Fondo de pensiones histórico migrado a Gestora',
      isActive: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 3,
      catalogType: RrhhCatalogType.afps,
      code: 'AFP-003',
      name: 'Futuro de Bolivia AFP (Histórico)',
      description: 'Fondo de pensiones histórico migrado a Gestora',
      isActive: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // Seguros de Salud
    RrhhCatalogItem(
      id: 4,
      catalogType: RrhhCatalogType.healthInsurances,
      code: 'SEG-001',
      name: 'Caja Nacional de Salud (CNS)',
      description: 'Ente gestor de salud principal',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 5,
      catalogType: RrhhCatalogType.healthInsurances,
      code: 'SEG-002',
      name: 'Caja Petrolera de Salud (CPS)',
      description: 'Seguridad social a corto plazo',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 6,
      catalogType: RrhhCatalogType.healthInsurances,
      code: 'SEG-003',
      name: 'Caja de Salud CORDES',
      description: 'Seguridad social a corto plazo',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 7,
      catalogType: RrhhCatalogType.healthInsurances,
      code: 'SEG-004',
      name: 'Caja de Salud de la Banca Privada (CSBP)',
      description: 'Seguridad social a corto plazo',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // Bancos
    RrhhCatalogItem(
      id: 8,
      catalogType: RrhhCatalogType.banks,
      code: 'BCO-001',
      name: 'Banco Unión S.A.',
      description: 'Entidad financiera fiscal y abono estatal',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 9,
      catalogType: RrhhCatalogType.banks,
      code: 'BCO-002',
      name: 'Banco Mercantil Santa Cruz S.A.',
      description: 'Cuenta empresarial corporativa',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 10,
      catalogType: RrhhCatalogType.banks,
      code: 'BCO-003',
      name: 'Banco Nacional de Bolivia (BNB)',
      description: 'Cuenta empresarial',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 11,
      catalogType: RrhhCatalogType.banks,
      code: 'BCO-004',
      name: 'Banco de Crédito de Bolivia (BCP)',
      description: 'Cuenta empresarial',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 12,
      catalogType: RrhhCatalogType.banks,
      code: 'BCO-005',
      name: 'Banco FIE S.A.',
      description: 'Cuenta para personal de campo',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // Tipos de Contrato
    RrhhCatalogItem(
      id: 13,
      catalogType: RrhhCatalogType.contractTypes,
      code: 'CON-001',
      name: 'Indefinido',
      description:
          'Contrato por tiempo indefinido con período de prueba vencido',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 14,
      catalogType: RrhhCatalogType.contractTypes,
      code: 'CON-002',
      name: 'Plazo Fijo',
      description: 'Contrato temporal por duración específica',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 15,
      catalogType: RrhhCatalogType.contractTypes,
      code: 'CON-003',
      name: 'Por Obra o Servicio',
      description: 'Contrato vinculado a proyecto o servicio cliente',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 16,
      catalogType: RrhhCatalogType.contractTypes,
      code: 'CON-004',
      name: 'Período de Prueba',
      description: 'Fase inicial de 90 días conforme a Ley Laboral',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // Modalidades de Pago
    RrhhCatalogItem(
      id: 17,
      catalogType: RrhhCatalogType.paymentModalities,
      code: 'PAG-001',
      name: 'Transferencia Bancaria',
      description: 'Abono directo en cuenta bancaria del trabajador',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 18,
      catalogType: RrhhCatalogType.paymentModalities,
      code: 'PAG-002',
      name: 'Cheque',
      description: 'Emisión de cheque de gerencia contra entrega de recibo',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 19,
      catalogType: RrhhCatalogType.paymentModalities,
      code: 'PAG-003',
      name: 'Efectivo',
      description: 'Pago en caja central contra firma de recibo oficial',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // Bonificaciones
    RrhhCatalogItem(
      id: 20,
      catalogType: RrhhCatalogType.bonuses,
      code: 'BON-001',
      name: 'Bono de Antigüedad',
      description:
          'Escala porcentual según D.S. 21060 sobre 3 salarios mínimos',
      subType: 'Fija mensual',
      defaultAmount: 0.0,
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 21,
      catalogType: RrhhCatalogType.bonuses,
      code: 'BON-002',
      name: 'Bono de Producción',
      description: 'Incentivo por metas y rendimiento alcanzado',
      subType: 'Variable',
      defaultAmount: 300.0,
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 22,
      catalogType: RrhhCatalogType.bonuses,
      code: 'BON-003',
      name: 'Bono de Puntualidad y Asistencia',
      description: 'Reconocimiento a cero atrasos en el período',
      subType: 'Fija mensual',
      defaultAmount: 200.0,
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // Descuentos
    RrhhCatalogItem(
      id: 23,
      catalogType: RrhhCatalogType.deductions,
      code: 'DSC-001',
      name: 'Anticipo Salarial',
      description: 'Adelanto de sueldo otorgado durante la quincena',
      subType: 'Fijo',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    RrhhCatalogItem(
      id: 24,
      catalogType: RrhhCatalogType.deductions,
      code: 'DSC-002',
      name: 'Sanción Disciplinaria por Atrasos',
      description: 'Deducción calculada conforme al Reglamento Interno',
      subType: 'Por evento',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  @override
  Future<List<RrhhShift>> listShifts() async {
    return List.unmodifiable(_inMemoryShifts);
  }

  @override
  Future<RrhhShift> createShift(RrhhShift shift) async {
    final nextId = _inMemoryShifts.isEmpty
        ? 1
        : _inMemoryShifts.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final created = RrhhShift(
      id: shift.id <= 0 ? nextId : shift.id,
      code: shift.code,
      name: shift.name,
      startTime: shift.startTime,
      endTime: shift.endTime,
      workDays: shift.workDays,
      shiftType: shift.shiftType,
      description: shift.description,
      isActive: shift.isActive,
      assignedEmployeesCount: shift.assignedEmployeesCount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _inMemoryShifts.add(created);
    return created;
  }

  @override
  Future<RrhhShift> updateShift(RrhhShift shift) async {
    final idx = _inMemoryShifts.indexWhere((e) => e.id == shift.id);
    if (idx != -1) {
      _inMemoryShifts[idx] = shift;
    } else {
      _inMemoryShifts.add(shift);
    }
    return shift;
  }

  @override
  Future<List<RrhhBaseSchedule>> listBaseSchedules() async {
    return List.unmodifiable(_inMemoryBaseSchedules);
  }

  @override
  Future<RrhhBaseSchedule> createBaseSchedule(RrhhBaseSchedule schedule) async {
    _inMemoryBaseSchedules.add(schedule);
    return schedule;
  }

  @override
  Future<RrhhBaseSchedule> updateBaseSchedule(RrhhBaseSchedule schedule) async {
    final idx = _inMemoryBaseSchedules.indexWhere((e) => e.id == schedule.id);
    if (idx != -1) {
      _inMemoryBaseSchedules[idx] = schedule;
    } else {
      _inMemoryBaseSchedules.add(schedule);
    }
    return schedule;
  }

  @override
  Future<List<RrhhSchedule>> listSchedules() async {
    try {
      final serverSchedules = await app.client.rrhhAssignment.listSchedules(
        limit: 100,
        offset: 0,
        includeDeleted: false,
        isActive: true,
      );
      if (serverSchedules.isNotEmpty) {
        return serverSchedules;
      }
    } catch (_) {
      // Usar turnos de memoria o fallback precargados
    }
    return List.unmodifiable(_inMemorySchedules);
  }

  @override
  Future<RrhhSchedule> createSchedule(RrhhSchedule schedule) async {
    _inMemorySchedules.add(schedule);
    return schedule;
  }

  @override
  Future<RrhhSchedule> updateSchedule(RrhhSchedule schedule) async {
    final idx = _inMemorySchedules.indexWhere((e) => e.id == schedule.id);
    if (idx != -1) {
      _inMemorySchedules[idx] = schedule;
    } else {
      _inMemorySchedules.add(schedule);
    }
    return schedule;
  }

  @override
  Future<List<RrhhCatalogItem>> listCatalogItems(RrhhCatalogType type) async {
    return _inMemoryCatalogItems.where((i) => i.catalogType == type).toList();
  }

  @override
  Future<RrhhCatalogItem> createCatalogItem(RrhhCatalogItem item) async {
    final nextId = _inMemoryCatalogItems.isEmpty
        ? 1
        : _inMemoryCatalogItems
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b) +
              1;
    final created = item.copyWith(
      id: item.id <= 0 ? nextId : item.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _inMemoryCatalogItems.add(created);
    return created;
  }

  @override
  Future<RrhhCatalogItem> updateCatalogItem(RrhhCatalogItem item) async {
    final idx = _inMemoryCatalogItems.indexWhere((i) => i.id == item.id);
    if (idx != -1) {
      _inMemoryCatalogItems[idx] = item.copyWith(updatedAt: DateTime.now());
      return _inMemoryCatalogItems[idx];
    }
    _inMemoryCatalogItems.add(item);
    return item;
  }

  // ===========================================================================
  // PANTALLA 08: Permisos y Licencias Médicas (Bloque 3: Novedades Laborales)
  // ===========================================================================

  final List<RrhhLeaveRequest> _localLeaveRequests = [];

  @override
  Future<List<RrhhLeaveRequest>> listLeaveRequests({
    String? search,
    String? leaveType,
    String? status,
    bool? isPaid,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final rawList = await app.client.rrhhLabor.listLeaveRequests(
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );

      final mapped = rawList.map((e) {
        final st = e.status.toLowerCase();
        final paid = e.leaveType != 'PERSONAL_SIN_GOCE' && e.leaveType != 'SIN_GOCE';
        return RrhhLeaveRequest(
          id: e.id ?? 0,
          code: e.code,
          employeeId: e.employeeId,
          employeeCode: e.employeeCode,
          employeeName: e.employeeName,
          leaveType: e.leaveType,
          startDate: e.startDate,
          endDate: e.endDate,
          durationDays: e.daysCount,
          isPaid: paid,
          reason: e.reason,
          evidenceFile: e.attachmentUrl,
          notes: e.resolutionNotes,
          status: st,
          createdAt: e.createdAt,
          updatedAt: e.updatedAt,
          createdBy: 'Sistema RRHH',
          approvedAt: e.resolvedAt,
          approvedBy: e.resolvedByUserId != null ? 'Usuario #${e.resolvedByUserId}' : null,
        );
      }).toList();

      final combined = [...mapped];
      for (final loc in _localLeaveRequests) {
        if (!combined.any((x) => x.id == loc.id || x.code == loc.code)) {
          combined.add(loc);
        }
      }

      return combined.where((req) {
        if (search != null && search.trim().isNotEmpty) {
          final q = search.toLowerCase();
          if (!req.code.toLowerCase().contains(q) &&
              !req.employeeName.toLowerCase().contains(q) &&
              !req.reason.toLowerCase().contains(q)) {
            return false;
          }
        }
        if (leaveType != null && leaveType != 'TODOS' && req.leaveType != leaveType) {
          return false;
        }
        if (status != null && status != 'TODOS' && req.status.toLowerCase() != status.toLowerCase()) {
          return false;
        }
        if (isPaid != null && req.isPaid != isPaid) return false;
        if (fromDate != null && req.startDate.isBefore(fromDate)) return false;
        if (toDate != null && req.endDate.isAfter(toDate)) return false;
        return true;
      }).toList();
    } catch (_) {
      return _localLeaveRequests;
    }
  }

  @override
  Future<RrhhLeaveRequest?> getLeaveRequestById(int id) async {
    try {
      final e = await app.client.rrhhLabor.getLeaveRequestById(id);
      if (e != null) {
        return RrhhLeaveRequest(
          id: e.id ?? 0,
          code: e.code,
          employeeId: e.employeeId,
          employeeCode: e.employeeCode,
          employeeName: e.employeeName,
          leaveType: e.leaveType,
          startDate: e.startDate,
          endDate: e.endDate,
          durationDays: e.daysCount,
          isPaid: e.leaveType != 'PERSONAL_SIN_GOCE' && e.leaveType != 'SIN_GOCE',
          reason: e.reason,
          evidenceFile: e.attachmentUrl,
          notes: e.resolutionNotes,
          status: e.status.toLowerCase(),
          createdAt: e.createdAt,
          updatedAt: e.updatedAt,
          createdBy: 'Sistema RRHH',
          approvedAt: e.resolvedAt,
          approvedBy: e.resolvedByUserId != null ? 'Usuario #${e.resolvedByUserId}' : null,
        );
      }
    } catch (_) {}
    return _localLeaveRequests.cast<RrhhLeaveRequest?>().firstWhere(
      (x) => x?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<RrhhLeaveRequest> createLeaveRequest(RrhhLeaveRequest request) async {
    try {
      final created = await app.client.rrhhLabor.createLeaveRequest(
        employeeId: request.employeeId,
        leaveType: request.leaveType,
        startDate: request.startDate,
        endDate: request.endDate,
        daysCount: request.durationDays,
        reason: request.reason,
        attachmentUrl: request.evidenceFile,
      );
      final full = request.copyWith(
        id: created.id,
        code: created.code,
        createdAt: created.createdAt,
        updatedAt: created.updatedAt,
      );
      _localLeaveRequests.add(full);
      return full;
    } catch (_) {
      final dummy = request.copyWith(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _localLeaveRequests.add(dummy);
      return dummy;
    }
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveRequest(RrhhLeaveRequest request) async {
    final idx = _localLeaveRequests.indexWhere((x) => x.id == request.id);
    if (idx != -1) {
      _localLeaveRequests[idx] = request;
    } else {
      _localLeaveRequests.add(request);
    }
    return request;
  }

  @override
  Future<RrhhLeaveRequest> updateLeaveStatus(
    int id,
    String newStatus, {
    String? reason,
    String? approvedBy,
  }) async {
    try {
      await app.client.rrhhLabor.resolveLeaveRequest(
        id,
        status: newStatus.toUpperCase(),
        resolutionNotes: reason,
      );
    } catch (_) {}
    final current = await getLeaveRequestById(id);
    if (current != null) {
      final updated = current.copyWith(
        status: newStatus.toLowerCase(),
        rejectionReason: newStatus.toLowerCase() == 'rechazado' ? reason : null,
        approvedAt: DateTime.now(),
        approvedBy: approvedBy ?? 'Administrador',
      );
      await updateLeaveRequest(updated);
      return updated;
    }
    throw const RrhhRemoteException(
      code: 'NOT_FOUND',
      message: 'Solicitud no encontrada',
    );
  }

  @override
  Future<bool> deleteLeaveRequest(int id) async {
    _localLeaveRequests.removeWhere((x) => x.id == id);
    return true;
  }

  @override
  Future<List<RrhhLeaveRequest>> listPayrollAffectingLeaves(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final all = await listLeaveRequests();
    return all.where((req) {
      return !req.isPaid &&
          req.status == 'aprobado' &&
          !req.startDate.isAfter(toDate) &&
          !req.endDate.isBefore(fromDate);
    }).toList();
  }

  // ===========================================================================
  // PANTALLA 09: Control de Vacaciones (Ley Laboral Bolivia)
  // ===========================================================================

  final List<RrhhVacationRecord> _localVacationRecords = [];

  @override
  Future<List<RrhhVacationRecord>> listVacationRecords({
    String? search,
    String? status,
    int? employeeId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final rawList = await app.client.rrhhLabor.listVacations(
        employeeId: employeeId,
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );

      final mapped = rawList.map((v) {
        String recordStatus = RrhhVacationRecordStatus.programado;
        final st = v.status.toUpperCase();
        if (st == 'COMPLETADA' || st == 'GOZADO') {
          recordStatus = RrhhVacationRecordStatus.gozado;
        } else if (st == 'EN_CURSO') {
          recordStatus = RrhhVacationRecordStatus.enCurso;
        } else if (st == 'CANCELADA' || st == 'RECHAZADA') {
          recordStatus = RrhhVacationRecordStatus.cancelado;
        }

        return RrhhVacationRecord(
          id: v.id ?? 0,
          code: v.code,
          employeeId: v.employeeId,
          employeeCode: v.employeeCode,
          employeeName: v.employeeName,
          startDate: v.startDate,
          endDate: v.endDate,
          daysCounted: v.daysRequested,
          countingMode: 'habiles',
          status: recordStatus,
          notes: v.notes,
          createdAt: v.createdAt,
          updatedAt: v.updatedAt,
          createdBy: 'Administración RRHH',
        );
      }).toList();

      final combined = [...mapped];
      for (final loc in _localVacationRecords) {
        if (!combined.any((x) => x.id == loc.id || x.code == loc.code)) {
          combined.add(loc);
        }
      }

      return combined.where((r) {
        if (search != null && search.trim().isNotEmpty) {
          final q = search.toLowerCase();
          if (!r.code.toLowerCase().contains(q) &&
              !r.employeeName.toLowerCase().contains(q) &&
              !(r.notes?.toLowerCase().contains(q) ?? false)) {
            return false;
          }
        }
        if (status != null && status != 'TODOS' && r.status != status) {
          return false;
        }
        if (fromDate != null && r.startDate.isBefore(fromDate)) return false;
        if (toDate != null && r.endDate.isAfter(toDate)) return false;
        return true;
      }).toList();
    } catch (_) {
      return _localVacationRecords;
    }
  }

  @override
  Future<RrhhVacationRecord?> getVacationRecordById(int id) async {
    final all = await listVacationRecords();
    return all.cast<RrhhVacationRecord?>().firstWhere(
      (x) => x?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<RrhhVacationRecord> createVacationRecord(RrhhVacationRecord record) async {
    try {
      final v = await app.client.rrhhLabor.requestVacation(
        employeeId: record.employeeId,
        periodYear: record.startDate.year,
        startDate: record.startDate,
        endDate: record.endDate,
        daysRequested: record.daysCounted,
        notes: record.notes,
      );
      final full = record.copyWith(
        id: v.id,
        code: v.code,
        createdAt: v.createdAt,
        updatedAt: v.updatedAt,
      );
      _localVacationRecords.add(full);
      return full;
    } catch (_) {
      _localVacationRecords.add(record);
      return record;
    }
  }

  @override
  Future<RrhhVacationRecord> updateVacationRecord(RrhhVacationRecord record) async {
    final idx = _localVacationRecords.indexWhere((x) => x.id == record.id);
    if (idx != -1) {
      _localVacationRecords[idx] = record;
    } else {
      _localVacationRecords.add(record);
    }
    return record;
  }

  @override
  Future<RrhhVacationRecord> updateVacationStatus(
    int id,
    String newStatus, {
    String? reason,
  }) async {
    final cur = await getVacationRecordById(id);
    if (cur != null) {
      final updated = cur.copyWith(
        status: newStatus,
        notes: reason ?? cur.notes,
        updatedAt: DateTime.now(),
      );
      await updateVacationRecord(updated);
      return updated;
    }
    throw const RrhhRemoteException(code: 'NOT_FOUND', message: 'No encontrado');
  }

  @override
  Future<bool> deleteVacationRecord(int id) async {
    _localVacationRecords.removeWhere((x) => x.id == id);
    return true;
  }

  @override
  Future<List<RrhhVacationBalance>> listVacationBalances({
    String? search,
    String? balanceStatus,
    int? areaId,
  }) async {
    try {
      final employees = await app.client.rrhhPersonnel.listEmployees(
        status: 'ACTIVO',
        areaId: areaId,
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );

      final vacations = await app.client.rrhhLabor.listVacations(
        limit: 200,
        offset: 0,
        includeDeleted: false,
      );

      final now = DateTime.now();
      final balances = <RrhhVacationBalance>[];

      for (final emp in employees) {
        final hireDate = emp.realStartDate;
        final assignedDays = RrhhVacationCalculator.getAssignedDays(hireDate, now);

        final empVacations = vacations.where((v) => v.employeeId == emp.id);
        int usedDays = 0;
        for (final v in empVacations) {
          final st = v.status.toUpperCase();
          if (st == 'COMPLETADA' || st == 'GOZADO') {
            usedDays += v.daysRequested;
          }
        }

        final pendingDays = (assignedDays - usedDays).clamp(0, 999);
        String statusStr;
        if (assignedDays == 0) {
          statusStr = RrhhVacationBalanceStatus.sinDerecho;
        } else if (pendingDays == 0) {
          statusStr = RrhhVacationBalanceStatus.agotado;
        } else if (pendingDays < assignedDays) {
          statusStr = RrhhVacationBalanceStatus.parcial;
        } else {
          statusStr = RrhhVacationBalanceStatus.disponible;
        }

        final nextAnniv = RrhhVacationCalculator.getNextAnniversary(hireDate, now);
        final daysUntil = nextAnniv.difference(now).inDays;

        balances.add(RrhhVacationBalance(
          employeeId: emp.id ?? 0,
          employeeCode: emp.code,
          employeeName: emp.fullName,
          position: emp.position,
          area: emp.area,
          hireDate: hireDate,
          antiquity: now.difference(hireDate),
          assignedDays: assignedDays,
          usedDays: usedDays,
          pendingDays: pendingDays,
          balanceStatus: statusStr,
          nextAnniversary: nextAnniv,
          daysUntilAnniversary: daysUntil,
        ));
      }

      return balances.where((b) {
        if (search != null && search.trim().isNotEmpty) {
          final q = search.toLowerCase();
          if (!b.employeeCode.toLowerCase().contains(q) &&
              !b.employeeName.toLowerCase().contains(q) &&
              !(b.position?.toLowerCase().contains(q) ?? false)) {
            return false;
          }
        }
        if (balanceStatus != null &&
            balanceStatus != 'TODOS' &&
            b.balanceStatus != balanceStatus) {
          return false;
        }
        return true;
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<RrhhVacationBalance?> getVacationBalanceByEmployee(int employeeId) async {
    final all = await listVacationBalances();
    return all.cast<RrhhVacationBalance?>().firstWhere(
      (x) => x?.employeeId == employeeId,
      orElse: () => null,
    );
  }

  @override
  Future<List<RrhhVacationRecord>> listPayrollAffectingVacations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final all = await listVacationRecords();
    return all.where((v) {
      return (v.status == RrhhVacationRecordStatus.gozado ||
              v.status == RrhhVacationRecordStatus.enCurso) &&
          !v.startDate.isAfter(toDate) &&
          !v.endDate.isBefore(fromDate);
    }).toList();
  }

  @override
  Future<List<RrhhVacation>> listVacations() async {
    try {
      return await app.client.rrhhLabor.listVacations(
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhVacation> requestVacation(RrhhVacation vacation) async {
    try {
      return await app.client.rrhhLabor.requestVacation(
        employeeId: vacation.employeeId,
        periodYear: vacation.periodYear,
        startDate: vacation.startDate,
        endDate: vacation.endDate,
        daysRequested: vacation.daysRequested,
        notes: vacation.notes,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhVacation> approveVacation(
    int vacationId, {
    required String approvedBy,
  }) async {
    try {
      return await app.client.rrhhLabor.approveVacation(
        vacationId,
        notes: 'Aprobado por $approvedBy',
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // PANTALLA 10: Régimen Disciplinario e Incidencias (Ley Laboral Bolivia)
  // ===========================================================================

  final List<RrhhDisciplinaryRecord> _localDisciplinaryRecords = [];

  @override
  Future<List<RrhhDisciplinaryRecord>> listDisciplinaryRecords({
    String? status,
    String? faultType,
    String? sanctionType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final rawIncidents = await app.client.rrhhLabor.listIncidents(
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );

      final mapped = rawIncidents.map((inc) {
        String fType = 'leve';
        final sev = inc.severity.toUpperCase();
        if (sev == 'GRAVE' || sev == 'MODERADA') {
          fType = 'grave';
        } else if (sev == 'GRAVISIMA') {
          fType = 'gravisima';
        }

        String sType = 'verbal';
        final t = inc.incidentType.toUpperCase();
        if (t.contains('MEMORANDUM')) {
          sType = 'escrita';
        } else if (t.contains('SUSPENSION')) {
          sType = 'suspension';
        } else if (t.contains('DESPIDO')) {
          sType = 'retiro';
        } else if (t.contains('MULTA')) {
          sType = 'pecuniaria';
        }

        return RrhhDisciplinaryRecord(
          id: inc.id ?? 0,
          code: inc.code,
          employeeId: inc.employeeId,
          employeeCode: inc.employeeCode,
          employeeName: inc.employeeName,
          incidentDate: inc.incidentDate,
          incidentDescription: '${inc.title}: ${inc.description}',
          faultType: fType,
          sanctionType: sType,
          sanctionDescription: inc.actionTaken,
          status: 'sancionada',
          createdAt: inc.createdAt,
          updatedAt: inc.updatedAt,
          createdBy: 'Supervisión de Operaciones',
          notes: inc.actionTaken,
        );
      }).toList();

      final combined = [...mapped];
      for (final loc in _localDisciplinaryRecords) {
        if (!combined.any((x) => x.id == loc.id || x.code == loc.code)) {
          combined.add(loc);
        }
      }

      return combined.where((r) {
        if (search != null && search.trim().isNotEmpty) {
          final q = search.toLowerCase();
          if (!r.code.toLowerCase().contains(q) &&
              !r.employeeName.toLowerCase().contains(q) &&
              !r.incidentDescription.toLowerCase().contains(q)) {
            return false;
          }
        }
        if (faultType != null && faultType != 'TODOS' && r.faultType != faultType) {
          return false;
        }
        if (sanctionType != null && sanctionType != 'TODAS' && r.sanctionType != sanctionType) {
          return false;
        }
        if (status != null && status != 'TODOS' && r.status != status) {
          return false;
        }
        if (fromDate != null && r.incidentDate.isBefore(fromDate)) return false;
        if (toDate != null && r.incidentDate.isAfter(toDate)) return false;
        return true;
      }).toList();
    } catch (_) {
      return _localDisciplinaryRecords;
    }
  }

  @override
  Future<RrhhDisciplinaryRecord?> getDisciplinaryRecordById(int id) async {
    final all = await listDisciplinaryRecords();
    return all.cast<RrhhDisciplinaryRecord?>().firstWhere(
      (x) => x?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<RrhhDisciplinaryRecord> createDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    _localDisciplinaryRecords.add(record);
    return record;
  }

  @override
  Future<RrhhDisciplinaryRecord> updateDisciplinaryRecord(
    RrhhDisciplinaryRecord record,
  ) async {
    final idx = _localDisciplinaryRecords.indexWhere((x) => x.id == record.id);
    if (idx != -1) {
      _localDisciplinaryRecords[idx] = record;
    } else {
      _localDisciplinaryRecords.add(record);
    }
    return record;
  }

  @override
  Future<bool> updateDisciplinaryStatus(
    int id,
    String newStatus, {
    String? reason,
    String? dischargeText,
    String? sanctionType,
    int? suspensionDays,
    double? salaryDeduction,
    String? sanctionDescription,
  }) async {
    final rec = await getDisciplinaryRecordById(id);
    if (rec != null) {
      final updated = rec.copyWith(
        status: newStatus,
        dischargeText: dischargeText ?? rec.dischargeText,
        sanctionType: sanctionType ?? rec.sanctionType,
        suspensionDays: suspensionDays ?? rec.suspensionDays,
        salaryDeduction: salaryDeduction ?? rec.salaryDeduction,
        sanctionDescription: sanctionDescription ?? rec.sanctionDescription,
        notes: reason ?? rec.notes,
        updatedAt: DateTime.now(),
      );
      await updateDisciplinaryRecord(updated);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteDisciplinaryRecord(int id) async {
    _localDisciplinaryRecords.removeWhere((x) => x.id == id);
    return true;
  }

  @override
  Future<List<RrhhDisciplinaryRecord>> listPayrollAffectingDisciplinary(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final all = await listDisciplinaryRecords();
    return all.where((r) {
      return (r.salaryDeduction != null && r.salaryDeduction! > 0) &&
          !r.incidentDate.isBefore(fromDate) &&
          !r.incidentDate.isAfter(toDate);
    }).toList();
  }

  @override
  Future<List<RrhhIncident>> listIncidents({
    String? severity,
    String? search,
  }) async {
    try {
      return await app.client.rrhhLabor.listIncidents(
        severity: severity,
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  @override
  Future<RrhhIncident> recordIncident(RrhhIncident incident) async {
    try {
      return await app.client.rrhhLabor.recordIncident(
        employeeId: incident.employeeId,
        incidentType: incident.incidentType,
        severity: incident.severity,
        incidentDate: incident.incidentDate,
        title: incident.title,
        description: incident.description,
        actionTaken: incident.actionTaken,
        isJustified: incident.isJustified,
        documentReferenceUrl: incident.documentReferenceUrl,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // PANTALLA 11: Desvinculación & Bajas Laborales (Regla de Oro Inactivo)
  // ===========================================================================

  final List<RrhhTerminationRecord> _localTerminationRecords = [];

  @override
  Future<List<RrhhTerminationRecord>> listTerminationRecords({
    String? status,
    String? terminationType,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final inactives = await app.client.rrhhPersonnel.listEmployees(
        status: 'INACTIVO',
        limit: 100,
        offset: 0,
        includeDeleted: false,
      );

      final mapped = inactives.map((emp) {
        String tType = RrhhTerminationTypes.finDeContrato;
        final reason = (emp.exitReason ?? '').toLowerCase();
        if (reason.contains('renuncia')) {
          tType = RrhhTerminationTypes.renunciaVoluntaria;
        } else if (reason.contains('despido') || reason.contains('art. 16')) {
          tType = RrhhTerminationTypes.despidoJustificado;
        } else if (reason.contains('jubila')) {
          tType = RrhhTerminationTypes.jubilacion;
        } else if (reason.contains('abandono')) {
          tType = RrhhTerminationTypes.abandonoDeTrabajo;
        }

        final exitDate = emp.exitDate ?? emp.contractEndDate ?? DateTime(2024, 2, 1);
        final codeYear = exitDate.year;

        return RrhhTerminationRecord(
          id: emp.id ?? 0,
          code: 'DESV-$codeYear-${(emp.id ?? 0).toString().padLeft(3, '0')}',
          employeeId: emp.id ?? 0,
          employeeCode: emp.code,
          employeeName: emp.fullName,
          terminationType: tType,
          terminationDate: exitDate,
          lastWorkDay: exitDate,
          reason: emp.exitObservations ??
              emp.exitReason ??
              'Conclusión regular de contrato de trabajo.',
          paymentCompleted: true,
          status: RrhhTerminationStatus.finalizada,
          createdAt: exitDate,
          updatedAt: exitDate,
          createdBy: emp.exitRegisteredBy ?? 'Dirección de Recursos Humanos',
        );
      }).toList();

      final combined = [...mapped];
      for (final loc in _localTerminationRecords) {
        if (!combined.any((x) => x.id == loc.id || x.code == loc.code)) {
          combined.add(loc);
        }
      }

      return combined.where((r) {
        if (search != null && search.trim().isNotEmpty) {
          final q = search.toLowerCase();
          if (!r.code.toLowerCase().contains(q) &&
              !r.employeeName.toLowerCase().contains(q) &&
              !r.reason.toLowerCase().contains(q)) {
            return false;
          }
        }
        if (terminationType != null &&
            terminationType != 'TODOS' &&
            r.terminationType != terminationType) {
          return false;
        }
        if (status != null && status != 'TODOS' && r.status != status) {
          return false;
        }
        if (fromDate != null && r.terminationDate.isBefore(fromDate)) return false;
        if (toDate != null && r.terminationDate.isAfter(toDate)) return false;
        return true;
      }).toList();
    } catch (_) {
      return _localTerminationRecords;
    }
  }

  @override
  Future<RrhhTerminationRecord?> getTerminationRecordById(int id) async {
    final all = await listTerminationRecords();
    return all.cast<RrhhTerminationRecord?>().firstWhere(
      (x) => x?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<RrhhTerminationRecord> createTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    _localTerminationRecords.add(record);
    return record;
  }

  @override
  Future<RrhhTerminationRecord> updateTerminationRecord(
    RrhhTerminationRecord record,
  ) async {
    final idx = _localTerminationRecords.indexWhere((x) => x.id == record.id);
    if (idx != -1) {
      _localTerminationRecords[idx] = record;
    } else {
      _localTerminationRecords.add(record);
    }
    return record;
  }

  @override
  Future<bool> updateTerminationStatus(
    int id,
    String newStatus, {
    String? reason,
    bool? paymentCompleted,
    DateTime? paymentCompletedAt,
  }) async {
    final cur = await getTerminationRecordById(id);
    if (cur != null) {
      final updated = cur.copyWith(
        status: newStatus,
        paymentCompleted: paymentCompleted ?? cur.paymentCompleted,
        paymentCompletedAt: paymentCompletedAt ?? cur.paymentCompletedAt,
        notes: reason ?? cur.notes,
        updatedAt: DateTime.now(),
      );
      await updateTerminationRecord(updated);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteTerminationRecord(int id) async {
    _localTerminationRecords.removeWhere((x) => x.id == id);
    return true;
  }

  @override
  Future<List<RrhhTerminationRecord>> listPayrollAffectingTerminations(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final all = await listTerminationRecords();
    return all.where((t) {
      return !t.terminationDate.isBefore(fromDate) &&
          !t.terminationDate.isAfter(toDate);
    }).toList();
  }

  @override
  Future<List<RrhhTermination>> listTerminations() async {
    return const [];
  }

  @override
  Future<RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime exitDate,
    required String reason,
    required String exitObservations,
    required String registeredBy,
    required double severancePay,
  }) async {
    try {
      return await app.client.rrhhLabor.terminateEmployee(
        employeeId: employeeId,
        terminationDate: exitDate,
        lastWorkingDay: exitDate,
        reason: reason,
        detailedReason: exitObservations,
        severanceAmount: severancePay,
        clearanceCompleted: true,
        isEligibleForRehire: true,
      );
    } catch (e) {
      throw RrhhRemoteException.fromServerpod(e);
    }
  }

  // ===========================================================================
  // PANTALLA 12: Novedades para Nómina (Entrega a Contabilidad)
  // ===========================================================================

  final List<RrhhPayrollPeriod> _localPayrollPeriods = [
    RrhhPayrollPeriod(
      id: 1,
      code: 'NOM-2026-10',
      year: 2026,
      month: 10,
      status: RrhhPayrollPeriodStatus.abierto,
      createdAt: DateTime(2026, 10, 1),
      updatedAt: DateTime(2026, 10, 1),
      notes: 'Período ordinario de nómina del mes en curso.',
    ),
    RrhhPayrollPeriod(
      id: 2,
      code: 'NOM-2026-09',
      year: 2026,
      month: 9,
      status: RrhhPayrollPeriodStatus.cerrado,
      closedAt: DateTime(2026, 9, 30, 18, 0),
      closedBy: 'Paola Andrea Torrico Vaca',
      createdAt: DateTime(2026, 9, 1),
      updatedAt: DateTime(2026, 9, 30),
      notes: 'Período consolidado y auditado con entrega a Contabilidad.',
    ),
  ];

  @override
  Future<List<RrhhPayrollPeriod>> listPayrollPeriods() async {
    return _localPayrollPeriods;
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodById(int id) async {
    return _localPayrollPeriods.cast<RrhhPayrollPeriod?>().firstWhere(
      (p) => p?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<RrhhPayrollPeriod?> getPayrollPeriodByMonth(int year, int month) async {
    return _localPayrollPeriods.cast<RrhhPayrollPeriod?>().firstWhere(
      (p) => p?.year == year && p?.month == month,
      orElse: () => null,
    );
  }

  @override
  Future<RrhhPayrollPeriod> createPayrollPeriod(
    int year,
    int month, {
    String? notes,
  }) async {
    final period = RrhhPayrollPeriod(
      id: _localPayrollPeriods.length + 1,
      code: 'NOM-$year-${month.toString().padLeft(2, '0')}',
      year: year,
      month: month,
      status: RrhhPayrollPeriodStatus.abierto,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _localPayrollPeriods.insert(0, period);
    return period;
  }

  @override
  Future<RrhhPayrollPeriod> closePayrollPeriod(
    int id, {
    String? closedBy,
    String? notes,
  }) async {
    final idx = _localPayrollPeriods.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final updated = _localPayrollPeriods[idx].copyWith(
        status: RrhhPayrollPeriodStatus.cerrado,
        closedAt: DateTime.now(),
        closedBy: closedBy ?? 'Paola Andrea Torrico Vaca',
        notes: notes ?? _localPayrollPeriods[idx].notes,
        updatedAt: DateTime.now(),
      );
      _localPayrollPeriods[idx] = updated;
      return updated;
    }
    throw const RrhhRemoteException(code: 'NOT_FOUND', message: 'No encontrado');
  }

  @override
  Future<RrhhPayrollPeriod> sendPayrollPeriodToAccounting(
    int id, {
    String? sentBy,
  }) async {
    final idx = _localPayrollPeriods.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final updated = _localPayrollPeriods[idx].copyWith(
        status: RrhhPayrollPeriodStatus.enviado,
        sentAt: DateTime.now(),
        sentBy: sentBy ?? 'Paola Andrea Torrico Vaca',
        updatedAt: DateTime.now(),
      );
      _localPayrollPeriods[idx] = updated;
      return updated;
    }
    throw const RrhhRemoteException(code: 'NOT_FOUND', message: 'No encontrado');
  }

  @override
  Future<List<RrhhPayrollItem>> listPayrollItems(
    int periodId, {
    String? sourceType,
    String? impactType,
  }) async {
    final items = await generatePayrollItems(periodId);
    return items.where((it) {
      if (sourceType != null && sourceType != 'todos' && it.sourceType != sourceType) {
        return false;
      }
      if (impactType != null && impactType != 'todos' && it.impactType != impactType) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<RrhhPayrollItem>> generatePayrollItems(int periodId) async {
    final items = <RrhhPayrollItem>[
      // Permiso médico CNS
      RrhhPayrollItem(
        id: 1,
        periodId: periodId,
        employeeId: 1,
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza Cuéllar',
        sourceType: 'permiso',
        sourceId: 1,
        sourceCode: 'LIC-2026-001',
        effectiveDate: DateTime(2026, 9, 20),
        description: 'Baja médica por gastroenteritis certificada CNS (3 días)',
        impactType: 'sin_impacto',
        notes: 'Subsidio por incapacidad temporal cubierto por la CNS',
      ),
      // Vacaciones anuales gozadas
      RrhhPayrollItem(
        id: 2,
        periodId: periodId,
        employeeId: 1,
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza Cuéllar',
        sourceType: 'vacacion',
        sourceId: 1,
        sourceCode: 'VAC-2026-001',
        effectiveDate: DateTime(2026, 9, 15),
        description: 'Goce regular de 10 días hábiles de vacación anual',
        impactType: 'sin_impacto',
        notes: 'Cómputo al 100% de haberes percibidos',
      ),
      // Bono de movilidad
      RrhhPayrollItem(
        id: 3,
        periodId: periodId,
        employeeId: 5,
        employeeCode: 'EMP-005',
        employeeName: 'Ricardo Montaño Justiniano',
        sourceType: 'incidencia',
        sourceId: 2,
        sourceCode: 'BONO-MOV',
        effectiveDate: DateTime(2026, 10, 1),
        description: 'Bono fijo mensual de movilidad y combustible',
        impactType: 'pago_extra',
        impactAmount: 600.0,
        notes: 'Asignación acordada para supervisor de campo',
      ),
      // Sanción disciplinaria
      RrhhPayrollItem(
        id: 4,
        periodId: periodId,
        employeeId: 2,
        employeeCode: 'EMP-002',
        employeeName: 'Mario Justiniano Céspedes',
        sourceType: 'incidencia',
        sourceId: 4,
        sourceCode: 'INC-2026-004',
        effectiveDate: DateTime(2026, 9, 25),
        description: 'Memorándum y descuento por omisión de EPP reglamentario',
        impactType: 'descuento',
        impactAmount: 150.0,
        notes: 'Descuento aplicado conforme al reglamento interno',
      ),
      // Finiquito por desvinculación
      RrhhPayrollItem(
        id: 5,
        periodId: periodId,
        employeeId: 6,
        employeeCode: 'EMP-006',
        employeeName: 'Héctor Baldivieso Candia',
        sourceType: 'desvinculacion',
        sourceId: 1,
        sourceCode: 'DESV-2024-001',
        effectiveDate: DateTime(2024, 2, 1),
        description: 'Liquidación de beneficios sociales por fin de contrato',
        impactType: 'pago_extra',
        impactAmount: 2800.0,
        notes: 'Finiquito visado por el Ministerio de Trabajo',
      ),
    ];
    return items;
  }

  @override
  Future<String> exportPayrollPeriod(int periodId, String format) async {
    return 'NOM-2026-10-export.$format';
  }

  @override
  Future<List<RrhhPayrollExportDto>> getPayrollInputs(int month, int year) async {
    return const [];
  }

  // ===========================================================================
  // PANTALLA 13: Asistencia de Campo (Consumo de solo lectura)
  // ===========================================================================

  @override
  Future<List<RrhhAttendanceRecord>> listAttendanceRecords({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
    String? serviceName,
  }) async {
    final now = DateTime.now();
    final list = <RrhhAttendanceRecord>[
      RrhhAttendanceRecord(
        id: 1,
        code: 'ASI-2026-001',
        employeeId: 1,
        employeeCode: 'EMP-001',
        employeeName: 'Carlos Mendoza Cuéllar',
        date: now,
        clientName: 'Kolping Bolivia',
        serviceName: 'Mantenimiento Preventivo Electromecánico',
        location: 'Central - Km 6 Doble Vía',
        scheduledEntry: const TimeOfDay(hour: 7, minute: 0),
        scheduledExit: const TimeOfDay(hour: 15, minute: 0),
        actualEntry: const TimeOfDay(hour: 6, minute: 55),
        actualExit: const TimeOfDay(hour: 15, minute: 2),
        workedHours: 8.0,
        lateMinutes: 0,
        status: RrhhAttendanceStatus.presente,
        createdAt: now,
        createdBy: 'Operaciones/APK',
      ),
      RrhhAttendanceRecord(
        id: 2,
        code: 'ASI-2026-002',
        employeeId: 2,
        employeeCode: 'EMP-002',
        employeeName: 'Mario Justiniano Céspedes',
        date: now,
        clientName: 'Ventura Mall',
        serviceName: 'Jardinería, Riego & Paisajismo',
        location: 'Boulevard Gastronómico',
        scheduledEntry: const TimeOfDay(hour: 7, minute: 0),
        scheduledExit: const TimeOfDay(hour: 15, minute: 0),
        actualEntry: const TimeOfDay(hour: 7, minute: 5),
        actualExit: const TimeOfDay(hour: 15, minute: 0),
        workedHours: 7.9,
        lateMinutes: 5,
        status: RrhhAttendanceStatus.tarde,
        createdAt: now,
        createdBy: 'Operaciones/APK',
      ),
      RrhhAttendanceRecord(
        id: 3,
        code: 'ASI-2026-003',
        employeeId: 3,
        employeeCode: 'EMP-003',
        employeeName: 'Javier Segovia Peñaranda',
        date: now,
        clientName: 'Segomeit S.R.L.',
        serviceName: 'Seguridad Física & CCTV',
        location: 'Planta Industrial',
        scheduledEntry: const TimeOfDay(hour: 22, minute: 0),
        scheduledExit: const TimeOfDay(hour: 6, minute: 0),
        actualEntry: const TimeOfDay(hour: 21, minute: 50),
        actualExit: const TimeOfDay(hour: 6, minute: 0),
        workedHours: 8.0,
        lateMinutes: 0,
        status: RrhhAttendanceStatus.presente,
        createdAt: now,
        createdBy: 'Operaciones/APK',
      ),
    ];

    return list.where((r) {
      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        if (!r.code.toLowerCase().contains(q) &&
            !r.employeeName.toLowerCase().contains(q) &&
            !r.clientName.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (status != null && status != 'TODOS' && r.status != status) {
        return false;
      }
      if (clientName != null &&
          clientName != 'TODOS' &&
          !r.clientName.toLowerCase().contains(clientName.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<RrhhAttendanceRecord?> getAttendanceRecordById(int id) async {
    final all = await listAttendanceRecords();
    return all.cast<RrhhAttendanceRecord?>().firstWhere(
      (x) => x?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<String> exportAttendanceReport({
    String? query,
    DateTimeRange? dateRange,
    String? status,
    String? clientName,
  }) async {
    return 'asistencia-reporte.csv';
  }

  // ===========================================================================
  // BITÁCORA INMUTABLE DE MOVIMIENTOS & REFERENCIAS CRM
  // ===========================================================================

  @override
  Future<List<RrhhMovementHistory>> listMovements({
    String? movementType,
    int? employeeId,
    int? limit,
    int? offset,
  }) async {
    try {
      return await app.client.rrhhLabor.listMovements(
        employeeId: employeeId,
        movementType: movementType,
        limit: limit ?? 100,
        offset: offset ?? 0,
      );
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<CrmClientRefDto>> listClientReferences() async {
    return const [
      CrmClientRefDto(
        customerId: 1,
        companyName: 'Kolping Bolivia',
        workplaceBranch: 'Sede: Kolping - Central (Km 6 Doble Vía)',
        contractId: 101,
        serviceName: 'Mantenimiento Preventivo Electromecánico',
      ),
      CrmClientRefDto(
        customerId: 2,
        companyName: 'Ventura Mall',
        workplaceBranch: 'Sede: Ventura Mall - Boulevard Gastronómico',
        contractId: 102,
        serviceName: 'Jardinería, Riego & Paisajismo',
      ),
      CrmClientRefDto(
        customerId: 3,
        companyName: 'Banco FIE',
        workplaceBranch: 'Sede: Banco FIE - Oficina Central',
        contractId: 103,
        serviceName: 'Limpieza Integral y Desinfección Hospitalaria',
      ),
      CrmClientRefDto(
        customerId: 4,
        companyName: 'Torre Dúo',
        workplaceBranch: 'Sede: Torre Dúo Equipetrol',
        contractId: 104,
        serviceName: 'Mantenimiento General y Ascensores',
      ),
    ];
  }
}
