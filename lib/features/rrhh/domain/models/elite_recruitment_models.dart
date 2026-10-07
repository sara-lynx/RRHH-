import 'package:flutter/material.dart';
import 'elite_rrhh_models.dart';

/// Etapas del embudo Kanban de Reclutamiento & Selección.
enum RecruitmentStage {
  nuevos,
  enRevision,
  entrevista,
  evaluacion,
  seleccionados,
  descartados;

  String get label => switch (this) {
        RecruitmentStage.nuevos => 'Nuevos Postulantes',
        RecruitmentStage.enRevision => 'En Revisión',
        RecruitmentStage.entrevista => 'Entrevista Agendada',
        RecruitmentStage.evaluacion => 'Evaluación & Pruebas',
        RecruitmentStage.seleccionados => 'Seleccionados',
        RecruitmentStage.descartados => 'Descartados',
      };

  Color get color => switch (this) {
        RecruitmentStage.nuevos => const Color(0xFF0284C7),
        RecruitmentStage.enRevision => const Color(0xFFD97706),
        RecruitmentStage.entrevista => const Color(0xFF9333EA),
        RecruitmentStage.evaluacion => const Color(0xFF4F46E5),
        RecruitmentStage.seleccionados => const Color(0xFF059669),
        RecruitmentStage.descartados => const Color(0xFFDC2626),
      };

  Color get bgColor => switch (this) {
        RecruitmentStage.nuevos => const Color(0xFFF0F9FF),
        RecruitmentStage.enRevision => const Color(0xFFFFFBEB),
        RecruitmentStage.entrevista => const Color(0xFFFAF5FF),
        RecruitmentStage.evaluacion => const Color(0xFFEEF2FF),
        RecruitmentStage.seleccionados => const Color(0xFFECFDF5),
        RecruitmentStage.descartados => const Color(0xFFFEF2F2),
      };

  Color get borderColor => switch (this) {
        RecruitmentStage.nuevos => const Color(0xFFBAE6FD),
        RecruitmentStage.enRevision => const Color(0xFFFDE68A),
        RecruitmentStage.entrevista => const Color(0xFFE9D5FF),
        RecruitmentStage.evaluacion => const Color(0xFFC7D2FE),
        RecruitmentStage.seleccionados => const Color(0xFFA7F3D0),
        RecruitmentStage.descartados => const Color(0xFFFECACA),
      };
}

/// Checklist Legal Boliviano para Expediente de Contratación.
class LegalDocumentChecklist {
  final bool ciCopy;
  final bool basicUtilityBill;
  final bool homeSketch;
  final bool felccCertificate;
  final bool felcnCertificate;
  final bool healthInsuranceCertificate;

  const LegalDocumentChecklist({
    this.ciCopy = false,
    this.basicUtilityBill = false,
    this.homeSketch = false,
    this.felccCertificate = false,
    this.felcnCertificate = false,
    this.healthInsuranceCertificate = false,
  });

  int get completedCount =>
      (ciCopy ? 1 : 0) +
      (basicUtilityBill ? 1 : 0) +
      (homeSketch ? 1 : 0) +
      (felccCertificate ? 1 : 0) +
      (felcnCertificate ? 1 : 0) +
      (healthInsuranceCertificate ? 1 : 0);

  bool get isAllCompleted => completedCount == 6;
  bool get isComplete => isAllCompleted;

  LegalDocumentChecklist copyWith({
    bool? ciCopy,
    bool? basicUtilityBill,
    bool? homeSketch,
    bool? felccCertificate,
    bool? felcnCertificate,
    bool? healthInsuranceCertificate,
  }) {
    return LegalDocumentChecklist(
      ciCopy: ciCopy ?? this.ciCopy,
      basicUtilityBill: basicUtilityBill ?? this.basicUtilityBill,
      homeSketch: homeSketch ?? this.homeSketch,
      felccCertificate: felccCertificate ?? this.felccCertificate,
      felcnCertificate: felcnCertificate ?? this.felcnCertificate,
      healthInsuranceCertificate:
          healthInsuranceCertificate ?? this.healthInsuranceCertificate,
    );
  }
}

/// Modelo de Postulante para el embudo de Selección y Legajo de Contratación.
class EliteApplicant {
  final String id;
  final String code;
  final String fullName;
  final String ci;
  final String phone;
  final String email;
  final String targetPosition;
  final double expectedSalary;
  final DateTime registrationDate;
  final RecruitmentStage stage;
  final EmployeeWorkplaceType workplaceType;
  final String serviceLineCode;
  final String assignedSite;
  final LegalDocumentChecklist checklist;
  final bool isHired;
  final String? hiredEmployeeCode;
  final String? discardReason;
  final String? notes;

  const EliteApplicant({
    required this.id,
    required this.code,
    required this.fullName,
    required this.ci,
    required this.phone,
    required this.email,
    required this.targetPosition,
    required this.expectedSalary,
    required this.registrationDate,
    required this.stage,
    required this.workplaceType,
    required this.serviceLineCode,
    required this.assignedSite,
    this.checklist = const LegalDocumentChecklist(),
    this.isHired = false,
    this.hiredEmployeeCode,
    this.discardReason,
    this.notes,
  });

  LegalDocumentChecklist get legalChecklist => checklist;

  EliteApplicant copyWith({
    String? id,
    String? code,
    String? fullName,
    String? ci,
    String? phone,
    String? email,
    String? targetPosition,
    double? expectedSalary,
    DateTime? registrationDate,
    RecruitmentStage? stage,
    EmployeeWorkplaceType? workplaceType,
    String? serviceLineCode,
    String? assignedSite,
    LegalDocumentChecklist? checklist,
    bool? isHired,
    String? hiredEmployeeCode,
    String? discardReason,
    String? notes,
  }) {
    return EliteApplicant(
      id: id ?? this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      ci: ci ?? this.ci,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      targetPosition: targetPosition ?? this.targetPosition,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      registrationDate: registrationDate ?? this.registrationDate,
      stage: stage ?? this.stage,
      workplaceType: workplaceType ?? this.workplaceType,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      assignedSite: assignedSite ?? this.assignedSite,
      checklist: checklist ?? this.checklist,
      isHired: isHired ?? this.isHired,
      hiredEmployeeCode: hiredEmployeeCode ?? this.hiredEmployeeCode,
      discardReason: discardReason ?? this.discardReason,
      notes: notes ?? this.notes,
    );
  }
}
