import 'package:flutter/foundation.dart';

/// Tipos de causales de desvinculación laboral (LGT Bolivia)
class RrhhTerminationTypes {
  static const String renunciaVoluntaria = 'renuncia_voluntaria';
  static const String despidoJustificado = 'despido_justificado';
  static const String despidoInjustificado = 'despido_injustificado';
  static const String finDeContrato = 'fin_de_contrato';
  static const String jubilacion = 'jubilacion';
  static const String abandonoDeTrabajo = 'abandono_de_trabajo';

  static const List<String> all = [
    renunciaVoluntaria,
    despidoJustificado,
    despidoInjustificado,
    finDeContrato,
    jubilacion,
    abandonoDeTrabajo,
  ];

  static String label(String type) {
    switch (type.toLowerCase()) {
      case renunciaVoluntaria:
        return 'Renuncia Voluntaria';
      case despidoJustificado:
        return 'Despido Justificado (Art. 16)';
      case despidoInjustificado:
        return 'Despido Injustificado';
      case finDeContrato:
        return 'Fin de Contrato';
      case jubilacion:
        return 'Jubilación';
      case abandonoDeTrabajo:
        return 'Abandono de Trabajo';
      default:
        return type;
    }
  }

  static bool isDismissal(String type) {
    final lower = type.toLowerCase();
    return lower == despidoJustificado || lower == despidoInjustificado;
  }

  static bool isResignation(String type) {
    return type.toLowerCase() == renunciaVoluntaria;
  }
}

/// Causales justificadas de despido según el Artículo 16 de la Ley General del Trabajo (Bolivia)
class RrhhJustifiedCauses {
  static const String perjuicioMaterial =
      'Perjuicio material intencional en los instrumentos de trabajo';
  static const String revelacionSecretos =
      'Revelación de secretos industriales o comerciales';
  static const String imprudenciasSeguridad =
      'Imprudencias o descuidos que afecten a la seguridad o higiene';
  static const String incumplimientoContrato =
      'Incumplimiento total o parcial del convenio o contrato de trabajo';
  static const String abusoConfianzaRobo =
      'Abuso de confianza, robo o hurto por el trabajador';
  static const String viasDeHecho =
      'Vías de hecho, injurias o conducta inmoral en el trabajo';
  static const String abandonoMasa =
      'Abandono de trabajo (3 días consecutivos o 6 discontinuos)';

  static const List<String> all = [
    perjuicioMaterial,
    revelacionSecretos,
    imprudenciasSeguridad,
    incumplimientoContrato,
    abusoConfianzaRobo,
    viasDeHecho,
    abandonoMasa,
  ];
}

/// Estados del expediente de desvinculación
class RrhhTerminationStatus {
  static const String registrada = 'registrada';
  static const String enProceso = 'en_proceso';
  static const String finalizada = 'finalizada';
  static const String cancelada = 'cancelada';

  static const List<String> all = [
    registrada,
    enProceso,
    finalizada,
    cancelada,
  ];

  static String label(String status) {
    switch (status.toLowerCase()) {
      case registrada:
        return 'Registrada';
      case enProceso:
        return 'En proceso';
      case finalizada:
        return 'Finalizada';
      case cancelada:
        return 'Cancelada';
      default:
        return status;
    }
  }
}

/// Entidad que representa un registro/expediente de desvinculación laboral
@immutable
class RrhhTerminationRecord {
  final int id;
  final String code; // 'BAJA-001', 'BAJA-002', etc.
  final int employeeId;
  final String employeeCode; // Snapshot 'EMP-XXX'
  final String employeeName; // Snapshot nombre completo
  final String terminationType; // RrhhTerminationTypes
  final String?
  justifiedCause; // Causa específica si es despido justificado (Art. 16 LGT)
  final DateTime terminationDate; // Fecha efectiva de baja
  final DateTime lastWorkDay; // Último día trabajado
  final String reason; // Motivo detallado (≥30 caracteres)

  // Documentos
  final String? resignationLetterFile;
  final String? terminationMemoFile;
  final String? workCertificateFile;
  final String? settlementFile;

  // Proceso y obligaciones
  final bool hasPendingObligations;
  final String? pendingObligationsDetail;
  final DateTime? paymentDeadline; // lastWorkDay + 15 días calendario
  final bool paymentCompleted;
  final DateTime? paymentCompletedAt;

  // Notificaciones
  final bool notifiedEmployee;
  final DateTime? notifiedAt;

  // Estado y auditoría
  final String
  status; // 'registrada' | 'en_proceso' | 'finalizada' | 'cancelada'
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final DateTime? processedAt;
  final String? processedBy;
  final String? notes;

  const RrhhTerminationRecord({
    required this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.terminationType,
    this.justifiedCause,
    required this.terminationDate,
    required this.lastWorkDay,
    required this.reason,
    this.resignationLetterFile,
    this.terminationMemoFile,
    this.workCertificateFile,
    this.settlementFile,
    this.hasPendingObligations = false,
    this.pendingObligationsDetail,
    this.paymentDeadline,
    this.paymentCompleted = false,
    this.paymentCompletedAt,
    this.notifiedEmployee = true,
    this.notifiedAt,
    this.status = RrhhTerminationStatus.registrada,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.processedAt,
    this.processedBy,
    this.notes,
  });

  /// Determina si el plazo legal de 15 días para pago de finiquito ha vencido
  bool get isPaymentExpired {
    if (paymentCompleted) return false;
    final deadline =
        paymentDeadline ?? lastWorkDay.add(const Duration(days: 15));
    final now = DateTime.now();
    return now.isAfter(deadline);
  }

  /// Días restantes antes del vencimiento del plazo legal de 15 días (o negativos si está vencido)
  int get daysUntilPaymentDeadline {
    final deadline =
        paymentDeadline ?? lastWorkDay.add(const Duration(days: 15));
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  RrhhTerminationRecord copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? terminationType,
    String? justifiedCause,
    DateTime? terminationDate,
    DateTime? lastWorkDay,
    String? reason,
    String? resignationLetterFile,
    String? terminationMemoFile,
    String? workCertificateFile,
    String? settlementFile,
    bool? hasPendingObligations,
    String? pendingObligationsDetail,
    DateTime? paymentDeadline,
    bool? paymentCompleted,
    DateTime? paymentCompletedAt,
    bool? notifiedEmployee,
    DateTime? notifiedAt,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    DateTime? processedAt,
    String? processedBy,
    String? notes,
  }) {
    return RrhhTerminationRecord(
      id: id ?? this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      terminationType: terminationType ?? this.terminationType,
      justifiedCause: justifiedCause ?? this.justifiedCause,
      terminationDate: terminationDate ?? this.terminationDate,
      lastWorkDay: lastWorkDay ?? this.lastWorkDay,
      reason: reason ?? this.reason,
      resignationLetterFile:
          resignationLetterFile ?? this.resignationLetterFile,
      terminationMemoFile: terminationMemoFile ?? this.terminationMemoFile,
      workCertificateFile: workCertificateFile ?? this.workCertificateFile,
      settlementFile: settlementFile ?? this.settlementFile,
      hasPendingObligations:
          hasPendingObligations ?? this.hasPendingObligations,
      pendingObligationsDetail:
          pendingObligationsDetail ?? this.pendingObligationsDetail,
      paymentDeadline: paymentDeadline ?? this.paymentDeadline,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
      paymentCompletedAt: paymentCompletedAt ?? this.paymentCompletedAt,
      notifiedEmployee: notifiedEmployee ?? this.notifiedEmployee,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      notes: notes ?? this.notes,
    );
  }

  factory RrhhTerminationRecord.fromJson(Map<String, dynamic> json) {
    return RrhhTerminationRecord(
      id: json['id'] as int,
      code: json['code'] as String,
      employeeId: json['employeeId'] as int,
      employeeCode: json['employeeCode'] as String,
      employeeName: json['employeeName'] as String,
      terminationType: json['terminationType'] as String,
      justifiedCause: json['justifiedCause'] as String?,
      terminationDate: DateTime.parse(json['terminationDate'] as String),
      lastWorkDay: DateTime.parse(json['lastWorkDay'] as String),
      reason: json['reason'] as String,
      resignationLetterFile: json['resignationLetterFile'] as String?,
      terminationMemoFile: json['terminationMemoFile'] as String?,
      workCertificateFile: json['workCertificateFile'] as String?,
      settlementFile: json['settlementFile'] as String?,
      hasPendingObligations: json['hasPendingObligations'] as bool? ?? false,
      pendingObligationsDetail: json['pendingObligationsDetail'] as String?,
      paymentDeadline: json['paymentDeadline'] != null
          ? DateTime.parse(json['paymentDeadline'] as String)
          : null,
      paymentCompleted: json['paymentCompleted'] as bool? ?? false,
      paymentCompletedAt: json['paymentCompletedAt'] != null
          ? DateTime.parse(json['paymentCompletedAt'] as String)
          : null,
      notifiedEmployee: json['notifiedEmployee'] as bool? ?? true,
      notifiedAt: json['notifiedAt'] != null
          ? DateTime.parse(json['notifiedAt'] as String)
          : null,
      status: json['status'] as String? ?? RrhhTerminationStatus.registrada,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'] as String)
          : null,
      processedBy: json['processedBy'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'terminationType': terminationType,
      'justifiedCause': justifiedCause,
      'terminationDate': terminationDate.toIso8601String(),
      'lastWorkDay': lastWorkDay.toIso8601String(),
      'reason': reason,
      'resignationLetterFile': resignationLetterFile,
      'terminationMemoFile': terminationMemoFile,
      'workCertificateFile': workCertificateFile,
      'settlementFile': settlementFile,
      'hasPendingObligations': hasPendingObligations,
      'pendingObligationsDetail': pendingObligationsDetail,
      'paymentDeadline': paymentDeadline?.toIso8601String(),
      'paymentCompleted': paymentCompleted,
      'paymentCompletedAt': paymentCompletedAt?.toIso8601String(),
      'notifiedEmployee': notifiedEmployee,
      'notifiedAt': notifiedAt?.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'processedAt': processedAt?.toIso8601String(),
      'processedBy': processedBy,
      'notes': notes,
    };
  }
}
