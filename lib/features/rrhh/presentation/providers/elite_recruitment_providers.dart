import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/elite_recruitment_models.dart';
import '../../domain/models/elite_rrhh_models.dart';
import 'elite_rrhh_providers.dart';

/// Semilla de datos inicial de postulantes en diversas etapas del embudo.
final List<EliteApplicant> _initialApplicants = [
  EliteApplicant(
    id: 'APP-001',
    code: 'POST-001',
    fullName: 'Rosa Elena Flores Choque',
    ci: '8492011 LP',
    phone: '77218490',
    email: 'rosa.flores@gmail.com',
    targetPosition: 'Auxiliar de Limpieza',
    expectedSalary: 2600.0,
    registrationDate: DateTime(2026, 10, 2),
    stage: RecruitmentStage.nuevos,
    workplaceType: EmployeeWorkplaceType.campo,
    serviceLineCode: EliteCostCenter.limpieza,
    assignedSite: 'Centro Empresarial Los Tajibos',
    checklist: const LegalDocumentChecklist(ciCopy: true),
  ),
  EliteApplicant(
    id: 'APP-002',
    code: 'POST-002',
    fullName: 'Carlos Alberto Mendoza Ramos',
    ci: '7291044 SC',
    phone: '76543210',
    email: 'carlos.mendoza.sec@hotmail.com',
    targetPosition: 'Guardia de Seguridad',
    expectedSalary: 3200.0,
    registrationDate: DateTime(2026, 9, 28),
    stage: RecruitmentStage.entrevista,
    workplaceType: EmployeeWorkplaceType.campo,
    serviceLineCode: EliteCostCenter.seguridad,
    assignedSite: 'Banco Ganadero - Sucursal Central',
    checklist: const LegalDocumentChecklist(
      ciCopy: true,
      basicUtilityBill: true,
    ),
  ),
  EliteApplicant(
    id: 'APP-003',
    code: 'POST-003',
    fullName: 'Valeria Sofía Ríos Vargas',
    ci: '9102845 CB',
    phone: '71982345',
    email: 'valeria.rios.cont@gmail.com',
    targetPosition: 'Auxiliar Contable',
    expectedSalary: 4200.0,
    registrationDate: DateTime(2026, 9, 25),
    stage: RecruitmentStage.evaluacion,
    workplaceType: EmployeeWorkplaceType.oficina,
    serviceLineCode: EliteCostCenter.adm,
    assignedSite: 'Sede Central',
    checklist: const LegalDocumentChecklist(
      ciCopy: true,
      basicUtilityBill: true,
      homeSketch: true,
    ),
  ),
  EliteApplicant(
    id: 'APP-004',
    code: 'POST-004',
    fullName: 'Mauricio Gonzalo Aguilar Pérez',
    ci: '6749102 LP',
    phone: '78912340',
    email: 'mauricio.aguilar.tec@gmail.com',
    targetPosition: 'Operador de Mantenimiento',
    expectedSalary: 3500.0,
    registrationDate: DateTime(2026, 9, 20),
    stage: RecruitmentStage.seleccionados,
    workplaceType: EmployeeWorkplaceType.campo,
    serviceLineCode: EliteCostCenter.mantenimiento,
    assignedSite: 'Planta Industrial Warnes',
    checklist: const LegalDocumentChecklist(
      ciCopy: true,
      basicUtilityBill: true,
      homeSketch: true,
      felccCertificate: true,
      felcnCertificate: false,
      healthInsuranceCertificate: false,
    ),
  ),
  EliteApplicant(
    id: 'APP-005',
    code: 'POST-005',
    fullName: 'Jorge Luis Fernández Ticona',
    ci: '5910283 LP',
    phone: '73456712',
    email: 'jorge.fernandez@yahoo.com',
    targetPosition: 'Guardia de Seguridad',
    expectedSalary: 4500.0,
    registrationDate: DateTime(2026, 9, 18),
    stage: RecruitmentStage.descartados,
    workplaceType: EmployeeWorkplaceType.campo,
    serviceLineCode: EliteCostCenter.seguridad,
    assignedSite: 'Banco Unión - Zona Sur',
    discardReason: 'Pretensión salarial fuera del rango presupuestario',
  ),
];

/// Notifier para la gestión de postulantes y embudo de selección.
class RrhhApplicantsNotifier extends Notifier<List<EliteApplicant>> {
  @override
  List<EliteApplicant> build() {
    return List<EliteApplicant>.from(_initialApplicants);
  }

  /// Mueve un postulante a una nueva etapa del Kanban.
  void moveStage(String applicantId, RecruitmentStage targetStage) {
    state = [
      for (final app in state)
        if (app.id == applicantId) app.copyWith(stage: targetStage) else app,
    ];
  }

  /// Registra un nuevo postulante en la etapa inicial.
  void registerApplicant({
    required String fullName,
    required String ci,
    required String phone,
    required String email,
    required String targetPosition,
    required double expectedSalary,
    required EmployeeWorkplaceType workplaceType,
    required String serviceLineCode,
    required String assignedSite,
    String? notes,
  }) {
    final newIndex = state.length + 1;
    final code = 'POST-${newIndex.toString().padLeft(3, '0')}';
    final applicant = EliteApplicant(
      id: 'APP-${DateTime.now().millisecondsSinceEpoch}',
      code: code,
      fullName: fullName.trim(),
      ci: ci.trim(),
      phone: phone.trim(),
      email: email.trim(),
      targetPosition: targetPosition.trim(),
      expectedSalary: expectedSalary,
      registrationDate: DateTime.now(),
      stage: RecruitmentStage.nuevos,
      workplaceType: workplaceType,
      serviceLineCode: serviceLineCode,
      assignedSite: assignedSite,
      notes: notes,
    );

    state = [applicant, ...state];
  }

  /// Actualiza el checklist de documentación legal obligatoria.
  void updateChecklist(String applicantId, LegalDocumentChecklist checklist) {
    state = [
      for (final app in state)
        if (app.id == applicantId) app.copyWith(checklist: checklist) else app,
    ];
  }

  /// Aprueba la contratación, crea el empleado formal en el Directorio y marca como contratado.
  String approveHiringAndOnboard({
    required WidgetRef ref,
    required String applicantId,
    required ContractType contractType,
    required double baseSalary,
    required String serviceLineCode,
    required String assignedSite,
    required EmployeeWorkplaceType workplaceType,
  }) {
    final applicantIndex = state.indexWhere((a) => a.id == applicantId);
    if (applicantIndex == -1) return '';

    final applicant = state[applicantIndex];

    // Obtener siguiente correlativo EMP-0XX
    final currentEmployees = ref.read(rrhhEmployeesProvider);
    final nextEmpNumber = currentEmployees.length + 1;
    final newEmpCode = 'EMP-${nextEmpNumber.toString().padLeft(3, '0')}';

    // 1. Crear nuevo colaborador oficial en nómina
    final newEmployee = EliteEmployee(
      id: newEmpCode,
      ci: applicant.ci,
      fullName: applicant.fullName,
      phone: applicant.phone,
      email: applicant.email.isNotEmpty
          ? applicant.email
          : '${applicant.fullName.toLowerCase().replaceAll(' ', '.')}@elitemultiservicios.com',
      workplaceType: workplaceType,
      serviceLineCode: serviceLineCode,
      position: applicant.targetPosition,
      assignedSite: assignedSite,
      contractType: contractType,
      hireDate: DateTime.now(),
      baseSalary: baseSalary,
      hasPendingLegalDocs: !applicant.checklist.isAllCompleted,
      status: EmployeeStatus.activo,
    );

    // 2. Insertar en el Notifier de Colaboradores
    ref.read(rrhhEmployeesProvider.notifier).addEmployee(newEmployee);

    // 3. Marcar postulante como contratado
    final updatedApplicant = applicant.copyWith(
      isHired: true,
      hiredEmployeeCode: newEmpCode,
      stage: RecruitmentStage.seleccionados,
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == applicantIndex) updatedApplicant else state[i],
    ];

    return newEmpCode;
  }
}

/// Provider principal de postulantes
final rrhhApplicantsProvider =
    NotifierProvider<RrhhApplicantsNotifier, List<EliteApplicant>>(
  RrhhApplicantsNotifier.new,
);

/// Query de búsqueda para el Kanban
class RecruitmentSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String q) => state = q.trim().toLowerCase();
}

final recruitmentSearchQueryProvider =
    NotifierProvider<RecruitmentSearchQueryNotifier, String>(
  RecruitmentSearchQueryNotifier.new,
);

/// Postulantes filtrados por texto
final rrhhFilteredApplicantsProvider = Provider<List<EliteApplicant>>((ref) {
  final list = ref.watch(rrhhApplicantsProvider);
  final query = ref.watch(recruitmentSearchQueryProvider);

  if (query.isEmpty) return list;

  return list.where((a) {
    return a.fullName.toLowerCase().contains(query) ||
        a.code.toLowerCase().contains(query) ||
        a.targetPosition.toLowerCase().contains(query) ||
        a.ci.toLowerCase().contains(query);
  }).toList();
});

/// Postulantes seleccionados pendientes de contratación
final rrhhSelectedApplicantsForHiringProvider =
    Provider<List<EliteApplicant>>((ref) {
  final all = ref.watch(rrhhApplicantsProvider);
  return all
      .where((a) => a.stage == RecruitmentStage.seleccionados && !a.isHired)
      .toList();
});

/// Métricas del embudo de selección
class RecruitmentMetrics {
  final int total;
  final int active;
  final int selected;
  final int discarded;

  const RecruitmentMetrics({
    required this.total,
    required this.active,
    required this.selected,
    required this.discarded,
  });
}

final recruitmentMetricsProvider = Provider<RecruitmentMetrics>((ref) {
  final all = ref.watch(rrhhApplicantsProvider);
  final total = all.length;
  final active = all.where((a) {
    return a.stage == RecruitmentStage.nuevos ||
        a.stage == RecruitmentStage.enRevision ||
        a.stage == RecruitmentStage.entrevista ||
        a.stage == RecruitmentStage.evaluacion;
  }).length;
  final selected =
      all.where((a) => a.stage == RecruitmentStage.seleccionados).length;
  final discarded =
      all.where((a) => a.stage == RecruitmentStage.descartados).length;

  return RecruitmentMetrics(
    total: total,
    active: active,
    selected: selected,
    discarded: discarded,
  );
});

final rrhhRecruitmentMetricsProvider = recruitmentMetricsProvider;

