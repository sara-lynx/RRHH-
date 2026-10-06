/// Modelo estructurado para el registro de entrevistas de postulantes.
class RrhhInterviewRecord {
  final DateTime dateTime;
  final List<String> interviewers; // 'Dueño', 'Encargada de RRHH', etc.
  final String modality; // 'Presencial', 'Virtual', 'Telefónica'
  final String notes;
  final String result; // 'Apto', 'No Apto', 'Dudoso'
  final String? rejectionReason;
  final String? attachedUrl;

  const RrhhInterviewRecord({
    required this.dateTime,
    required this.interviewers,
    required this.modality,
    required this.notes,
    required this.result,
    this.rejectionReason,
    this.attachedUrl,
  });

  RrhhInterviewRecord copyWith({
    DateTime? dateTime,
    List<String>? interviewers,
    String? modality,
    String? notes,
    String? result,
    String? rejectionReason,
    String? attachedUrl,
  }) {
    return RrhhInterviewRecord(
      dateTime: dateTime ?? this.dateTime,
      interviewers: interviewers ?? this.interviewers,
      modality: modality ?? this.modality,
      notes: notes ?? this.notes,
      result: result ?? this.result,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      attachedUrl: attachedUrl ?? this.attachedUrl,
    );
  }
}

/// Datos de Evaluación Completa (Fase 2) según perfil CAMPO u OFICINA.
class RrhhApplicantEvaluation {
  // Comunes
  final String? education;
  final String? experienceSummary;
  final List<String> technicalSkills;
  final String? personalReferenceName;
  final String? personalReferencePhone;
  final String? workReferenceName;
  final String? workReferencePhone;

  // Específicos CAMPO
  final bool rotatingShiftsAvailable;
  final bool clientBranchesAvailable;
  final String? drivingLicense;
  final bool physicalFitnessDeclared;

  // Específicos OFICINA
  final String? educationLevel; // Bachiller, Técnico, Licenciatura, Postgrado
  final String? professionalTitle;
  final String? professionalCertifications;
  final double? salaryExpectation;

  const RrhhApplicantEvaluation({
    this.education,
    this.experienceSummary,
    this.technicalSkills = const [],
    this.personalReferenceName,
    this.personalReferencePhone,
    this.workReferenceName,
    this.workReferencePhone,
    this.rotatingShiftsAvailable = true,
    this.clientBranchesAvailable = true,
    this.drivingLicense,
    this.physicalFitnessDeclared = true,
    this.educationLevel,
    this.professionalTitle,
    this.professionalCertifications,
    this.salaryExpectation,
  });

  bool isCompleteFor(String targetType) {
    if (targetType.toUpperCase() == 'CAMPO') {
      return (education != null && education!.trim().isNotEmpty) &&
          (experienceSummary != null && experienceSummary!.trim().isNotEmpty) &&
          physicalFitnessDeclared;
    } else {
      return (educationLevel != null && educationLevel!.trim().isNotEmpty) &&
          (experienceSummary != null && experienceSummary!.trim().isNotEmpty);
    }
  }

  RrhhApplicantEvaluation copyWith({
    String? education,
    String? experienceSummary,
    List<String>? technicalSkills,
    String? personalReferenceName,
    String? personalReferencePhone,
    String? workReferenceName,
    String? workReferencePhone,
    bool? rotatingShiftsAvailable,
    bool? clientBranchesAvailable,
    String? drivingLicense,
    bool? physicalFitnessDeclared,
    String? educationLevel,
    String? professionalTitle,
    String? professionalCertifications,
    double? salaryExpectation,
  }) {
    return RrhhApplicantEvaluation(
      education: education ?? this.education,
      experienceSummary: experienceSummary ?? this.experienceSummary,
      technicalSkills: technicalSkills ?? this.technicalSkills,
      personalReferenceName:
          personalReferenceName ?? this.personalReferenceName,
      personalReferencePhone:
          personalReferencePhone ?? this.personalReferencePhone,
      workReferenceName: workReferenceName ?? this.workReferenceName,
      workReferencePhone: workReferencePhone ?? this.workReferencePhone,
      rotatingShiftsAvailable:
          rotatingShiftsAvailable ?? this.rotatingShiftsAvailable,
      clientBranchesAvailable:
          clientBranchesAvailable ?? this.clientBranchesAvailable,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      physicalFitnessDeclared:
          physicalFitnessDeclared ?? this.physicalFitnessDeclared,
      educationLevel: educationLevel ?? this.educationLevel,
      professionalTitle: professionalTitle ?? this.professionalTitle,
      professionalCertifications:
          professionalCertifications ?? this.professionalCertifications,
      salaryExpectation: salaryExpectation ?? this.salaryExpectation,
    );
  }
}

/// Checklist de Documentos (Fase 3).
class RrhhApplicantDocumentsChecklist {
  final bool hasCiCopy;
  final bool hasFelcc;
  final bool hasUtilityBill;
  final bool hasHomeSketch;
  final bool hasPhoto3x4;
  final bool hasSus;

  const RrhhApplicantDocumentsChecklist({
    this.hasCiCopy = false,
    this.hasFelcc = false,
    this.hasUtilityBill = false,
    this.hasHomeSketch = false,
    this.hasPhoto3x4 = false,
    this.hasSus = false,
  });

  /// Para CAMPO: 6 documentos obligatorios.
  /// Para OFICINA: 5 base obligatorios (FELCC opcional a menos que sea seguridad).
  bool isCompleteFor(String targetType) {
    final baseOk =
        hasCiCopy && hasUtilityBill && hasHomeSketch && hasPhoto3x4 && hasSus;
    if (targetType.toUpperCase() == 'CAMPO') {
      return baseOk && hasFelcc;
    }
    return baseOk;
  }

  int completedCount(String targetType) {
    int c = 0;
    if (hasCiCopy) c++;
    if (hasUtilityBill) c++;
    if (hasHomeSketch) c++;
    if (hasPhoto3x4) c++;
    if (hasSus) c++;
    if (hasFelcc) c++;
    return c;
  }

  int totalRequired(String targetType) =>
      targetType.toUpperCase() == 'CAMPO' ? 6 : 5;

  RrhhApplicantDocumentsChecklist copyWith({
    bool? hasCiCopy,
    bool? hasFelcc,
    bool? hasUtilityBill,
    bool? hasHomeSketch,
    bool? hasPhoto3x4,
    bool? hasSus,
  }) {
    return RrhhApplicantDocumentsChecklist(
      hasCiCopy: hasCiCopy ?? this.hasCiCopy,
      hasFelcc: hasFelcc ?? this.hasFelcc,
      hasUtilityBill: hasUtilityBill ?? this.hasUtilityBill,
      hasHomeSketch: hasHomeSketch ?? this.hasHomeSketch,
      hasPhoto3x4: hasPhoto3x4 ?? this.hasPhoto3x4,
      hasSus: hasSus ?? this.hasSus,
    );
  }
}

/// Entrada en la línea de tiempo de transiciones del postulante.
class RrhhStatusHistoryEntry {
  final String fromStatus;
  final String toStatus;
  final DateTime timestamp;
  final String author;
  final String? notes;

  const RrhhStatusHistoryEntry({
    required this.fromStatus,
    required this.toStatus,
    required this.timestamp,
    required this.author,
    this.notes,
  });
}

/// Objeto de acompañamiento para postulantes que extiende los datos del mock sin tocar .spy.yaml.
class RrhhApplicantCompanion {
  final int applicantId;
  final List<int> previousApplicationIds;
  final bool isEligibleForRehire;
  final RrhhInterviewRecord? interviewRecord;
  final RrhhApplicantEvaluation evaluation;
  final RrhhApplicantDocumentsChecklist documents;
  final List<RrhhStatusHistoryEntry> history;

  const RrhhApplicantCompanion({
    required this.applicantId,
    this.previousApplicationIds = const [],
    this.isEligibleForRehire = true,
    this.interviewRecord,
    this.evaluation = const RrhhApplicantEvaluation(),
    this.documents = const RrhhApplicantDocumentsChecklist(),
    this.history = const [],
  });

  RrhhApplicantCompanion copyWith({
    int? applicantId,
    List<int>? previousApplicationIds,
    bool? isEligibleForRehire,
    RrhhInterviewRecord? interviewRecord,
    RrhhApplicantEvaluation? evaluation,
    RrhhApplicantDocumentsChecklist? documents,
    List<RrhhStatusHistoryEntry>? history,
  }) {
    return RrhhApplicantCompanion(
      applicantId: applicantId ?? this.applicantId,
      previousApplicationIds:
          previousApplicationIds ?? this.previousApplicationIds,
      isEligibleForRehire: isEligibleForRehire ?? this.isEligibleForRehire,
      interviewRecord: interviewRecord ?? this.interviewRecord,
      evaluation: evaluation ?? this.evaluation,
      documents: documents ?? this.documents,
      history: history ?? this.history,
    );
  }
}
