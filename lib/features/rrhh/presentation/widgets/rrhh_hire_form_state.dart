import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../../data/models/rrhh_applicant_companion.dart';

import 'rrhh_hire_type_config.dart';

/// Contenedor de datos y validaciones adaptativas para el Wizard de Contratación (Opción C).
class RrhhHireFormState {
  // ---------------------------------------------------------------------------
  // PASO 1: Datos Laborales
  // ---------------------------------------------------------------------------
  String employeeType = 'CAMPO'; // 'OFICINA' | 'CAMPO'
  RrhhArea? selectedArea;
  RrhhPosition? selectedPosition;
  RrhhSpecialty? selectedSpecialty;
  RrhhSchedule? selectedSchedule;
  String supervisor = '';
  DateTime realStartDate = DateTime.now();

  // ---------------------------------------------------------------------------
  // PASO 2: Contrato & Sueldo
  // ---------------------------------------------------------------------------
  String contractType = 'Plazo Fijo';
  DateTime? contractEndDate;
  double agreedSalary = 0.0;
  String paymentModality = 'JORNAL';
  String workScheduleType = 'TIEMPO_COMPLETO_48H';
  String observations = '';

  // ---------------------------------------------------------------------------
  // PASO 3: Datos Personales & Documentos
  // ---------------------------------------------------------------------------
  String fullName = '';
  String identityCard = '';
  DateTime? birthDate;
  String birthPlace = 'Santa Cruz de la Sierra';
  String phone = '';
  String address = '';
  String occupation = '';
  String personalReference = '';
  String referencePhone = '';

  // Checklist de 6 Documentos Físicos de Ley
  bool hasCiCopy = true;
  bool hasFelccRecord = false;
  bool hasUtilityBill = true;
  bool hasHomeSketch = true;
  bool hasPhoto3x4 = true;
  bool hasSusInsurance = true;

  RrhhHireTypeConfig get config => RrhhHireTypeConfig.forType(employeeType);

  RrhhHireFormState() {
    applyTypeDefaults();
  }

  /// Aplica los defaults contractuales según el tipo de trabajador activo
  void applyTypeDefaults() {
    final cfg = config;
    contractType = cfg.defaultContractType;
    paymentModality = cfg.defaultPaymentModality;
    workScheduleType = cfg.defaultScheduleType;
    if (contractType == 'Plazo Fijo' && contractEndDate == null) {
      contractEndDate = realStartDate.add(const Duration(days: 365));
    } else if (contractType != 'Plazo Fijo') {
      contractEndDate = null;
    }
  }

  /// Limpia selecciones dependientes al cambiar de tipo (Paso 1)
  void resetDependentSelections() {
    selectedArea = null;
    selectedPosition = null;
    selectedSpecialty = null;
    selectedSchedule = null;
    supervisor = '';
    applyTypeDefaults();
  }

  /// Inicializa datos precargados si se abre desde Reclutamiento con un postulante.
  void initFromApplicant(
    RrhhApplicant applicant, {
    RrhhApplicantCompanion? companion,
    List<RrhhArea>? availableAreas,
    List<RrhhPosition>? availablePositions,
    List<RrhhSpecialty>? availableSpecialties,
  }) {
    fullName = applicant.fullName;
    identityCard = applicant.identityCard;
    phone = applicant.phone;
    address = applicant.address ?? '';
    birthDate = applicant.birthDate;
    personalReference =
        applicant.referencePerson ?? applicant.emergencyContact ?? '';
    referencePhone = applicant.referencePhone ?? applicant.emergencyPhone ?? '';
    employeeType = applicant.targetType.isNotEmpty
        ? applicant.targetType
        : 'CAMPO';
    applyTypeDefaults();

    if (applicant.expectedSalary != null && applicant.expectedSalary! > 0) {
      agreedSalary = applicant.expectedSalary!;
    }

    if (companion != null) {
      hasCiCopy = companion.documents.hasCiCopy;
      hasFelccRecord = companion.documents.hasFelcc;
      hasUtilityBill = companion.documents.hasUtilityBill;
      hasHomeSketch = companion.documents.hasHomeSketch;
      hasPhoto3x4 = companion.documents.hasPhoto3x4;
      hasSusInsurance = companion.documents.hasSus;

      if (companion.evaluation.salaryExpectation != null &&
          companion.evaluation.salaryExpectation! > 0) {
        agreedSalary = companion.evaluation.salaryExpectation!;
      }
      if (companion.evaluation.experienceSummary != null &&
          companion.evaluation.experienceSummary!.isNotEmpty) {
        occupation = companion.evaluation.experienceSummary!;
      }
    }

    if (availableAreas != null && applicant.targetArea != null) {
      final match = availableAreas.where(
        (a) => a.name == applicant.targetArea || a.id == applicant.areaId,
      );
      if (match.isNotEmpty) selectedArea = match.first;
    }

    if (availablePositions != null && applicant.targetPosition != null) {
      final match = availablePositions.where(
        (p) =>
            p.name == applicant.targetPosition || p.id == applicant.positionId,
      );
      if (match.isNotEmpty) {
        selectedPosition = match.first;
        if (selectedPosition?.suggestedSalary != null && agreedSalary <= 0) {
          agreedSalary = selectedPosition!.suggestedSalary!;
        }
      }
    }

    if (availableSpecialties != null && applicant.specialty != null) {
      final match = availableSpecialties.where(
        (s) => s.name == applicant.specialty || s.id == applicant.specialtyId,
      );
      if (match.isNotEmpty) selectedSpecialty = match.first;
    }
  }

  /// Regla de seguridad: ¿El cargo seleccionado es de vigilancia/seguridad?
  bool isSecurityPosition() {
    final posName = selectedPosition?.name.toLowerCase() ?? '';
    return posName.contains('seguridad') || posName.contains('guardia');
  }

  /// Validación Paso 1 según tipo de trabajador
  bool isStep1Valid() {
    if (selectedArea == null ||
        selectedPosition == null ||
        selectedSchedule == null) {
      return false;
    }
    if (supervisor.trim().isEmpty) return false;
    if (config.isSpecialtyRequired && selectedSpecialty == null) {
      return false;
    }
    return true;
  }

  /// Validación Paso 2
  bool isStep2Valid() {
    if (agreedSalary <= 0) return false;
    if (contractType == 'Plazo Fijo') {
      if (contractEndDate == null) return false;
      if (!contractEndDate!.isAfter(realStartDate)) return false;
    }
    return true;
  }

  /// Conteo de documentos requeridos que están marcados
  int getCheckedRequiredDocsCount() {
    int count = 0;
    if (hasCiCopy) count++;
    if (hasUtilityBill) count++;
    if (hasHomeSketch) count++;
    if (hasPhoto3x4) count++;
    if (hasSusInsurance) count++;

    if (employeeType == 'CAMPO' || isSecurityPosition()) {
      if (hasFelccRecord) count++;
    }
    return count;
  }

  /// Total de documentos exigidos según tipo y cargo
  int getTotalRequiredDocs() {
    if (employeeType == 'CAMPO' || isSecurityPosition()) return 6;
    return 5;
  }

  /// Validación Paso 3: datos personales + checklist de documentos
  bool isStep3Valid() {
    if (fullName.trim().isEmpty) return false;
    if (identityCard.trim().isEmpty) return false;
    if (birthPlace.trim().isEmpty) return false;
    if (phone.trim().isEmpty) return false;
    if (address.trim().isEmpty) return false;
    if (personalReference.trim().isEmpty) return false;
    if (referencePhone.trim().isEmpty) return false;

    // Los 5 documentos base son obligatorios siempre
    if (!hasCiCopy ||
        !hasUtilityBill ||
        !hasHomeSketch ||
        !hasPhoto3x4 ||
        !hasSusInsurance) {
      return false;
    }

    // Para CAMPO o cargo de seguridad: FELCC es OBLIGATORIO
    if ((employeeType == 'CAMPO' || isSecurityPosition()) && !hasFelccRecord) {
      return false;
    }

    return true;
  }

  /// Construye el objeto [RrhhEmployee] según el contrato de datos.
  RrhhEmployee buildEmployee({int? applicantId}) {
    final now = DateTime.now();
    final workplaceDefault = employeeType == 'OFICINA'
        ? 'Oficina Central (Equipetrol)'
        : 'Sede Cliente Asignada';
    final supervisorValue = supervisor.trim().isNotEmpty
        ? supervisor.trim()
        : (employeeType == 'OFICINA'
              ? 'Lic. Laura Mendoza'
              : 'Ricardo Montaño');

    return RrhhEmployee(
      code: '',
      fullName: fullName.trim(),
      birthDate: birthDate,
      birthPlace: birthPlace.trim(),
      identityCard: identityCard.trim(),
      phone: phone.trim(),
      address: address.trim(),
      occupation: occupation.isNotEmpty
          ? occupation
          : (selectedPosition?.name ?? 'Operario'),
      personalReference: personalReference.trim(),
      referencePhone: referencePhone.trim(),
      employeeType: employeeType,
      area: selectedArea?.name ?? 'Operaciones & Servicios',
      areaId: selectedArea?.id,
      position: selectedPosition?.name ?? 'Operario',
      positionId: selectedPosition?.id,
      specialty:
          selectedSpecialty?.name ??
          (employeeType == 'OFICINA' ? 'Administración' : 'General'),
      specialtyId: selectedSpecialty?.id,
      workplace: workplaceDefault,
      supervisor: supervisorValue,
      realStartDate: realStartDate,
      fiscalStartDate: realStartDate,
      agreedSalary: agreedSalary,
      contractType: contractType,
      contractEndDate: contractType == 'Plazo Fijo' ? contractEndDate : null,
      observations: observations.trim().isNotEmpty ? observations.trim() : null,
      status: 'ACTIVO',
      availabilityStatus: 'DISPONIBLE',
      paymentModality: paymentModality,
      workScheduleType: workScheduleType,
      hasCiCopy: hasCiCopy,
      hasUtilityBill: hasUtilityBill,
      hasHomeSketch: hasHomeSketch,
      hasFelccRecord: hasFelccRecord,
      hasPhoto3x4: hasPhoto3x4,
      hasSusInsurance: hasSusInsurance,
      applicantId: applicantId,
      createdAt: now,
      updatedAt: now,
    );
  }
}
