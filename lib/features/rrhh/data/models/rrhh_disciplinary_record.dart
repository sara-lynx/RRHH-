/// Entidad oficial para la gestión de incidencias, régimen disciplinario y sanciones
/// conforme a la Ley General del Trabajo de Bolivia y buenas prácticas empresariales.
class RrhhDisciplinaryRecord {
  final int id;
  final String code; // Ej: 'INC-001', 'INC-002'
  final int employeeId;
  final String employeeCode; // Snapshot EMP-XXX
  final String employeeName; // Snapshot Nombre
  final DateTime incidentDate; // Fecha del hecho
  final String incidentDescription; // Descripción detallada
  final String faultType; // 'leve' | 'grave' | 'gravisima'
  final String? evidenceFile; // Nombre del archivo adjunto
  final String? witnesses; // Nombres de testigos

  // Proceso de Descargo
  final bool requiresDischarge; // ¿Requiere descargo del trabajador?
  final DateTime? dischargeDeadline; // Fecha límite de descargo
  final String? dischargeText; // Texto del descargo presentado
  final DateTime? dischargeDate; // Fecha de presentación del descargo

  // Sanción
  final String?
  sanctionType; // 'verbal' | 'escrita' | 'pecuniaria' | 'suspension' | 'retiro'
  final int? suspensionDays; // Días de suspensión (máx 5 por ley)
  final String?
  sanctionDescription; // Texto legal / administrativo de la sanción
  final double? salaryDeduction; // Monto a descontar (si aplica)

  // Notificación
  final bool notifiedEmployee;
  final DateTime? notifiedAt;
  final String? notificationMethod; // 'email' | 'presencial' | 'memorandum'

  // Estado y Auditoría
  final String
  status; // 'registrada' | 'en_descargo' | 'sancionada' | 'apelada' | 'archivada' | 'cerrada'
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final DateTime? sanctionedAt;
  final String? sanctionedBy;
  final String? notes;

  const RrhhDisciplinaryRecord({
    required this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.incidentDate,
    required this.incidentDescription,
    required this.faultType,
    this.evidenceFile,
    this.witnesses,
    this.requiresDischarge = false,
    this.dischargeDeadline,
    this.dischargeText,
    this.dischargeDate,
    this.sanctionType,
    this.suspensionDays,
    this.sanctionDescription,
    this.salaryDeduction,
    this.notifiedEmployee = true,
    this.notifiedAt,
    this.notificationMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.sanctionedAt,
    this.sanctionedBy,
    this.notes,
  });

  RrhhDisciplinaryRecord copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    DateTime? incidentDate,
    String? incidentDescription,
    String? faultType,
    String? evidenceFile,
    String? witnesses,
    bool? requiresDischarge,
    DateTime? dischargeDeadline,
    String? dischargeText,
    DateTime? dischargeDate,
    String? sanctionType,
    int? suspensionDays,
    String? sanctionDescription,
    double? salaryDeduction,
    bool? notifiedEmployee,
    DateTime? notifiedAt,
    String? notificationMethod,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    DateTime? sanctionedAt,
    String? sanctionedBy,
    String? notes,
  }) {
    return RrhhDisciplinaryRecord(
      id: id ?? this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      incidentDate: incidentDate ?? this.incidentDate,
      incidentDescription: incidentDescription ?? this.incidentDescription,
      faultType: faultType ?? this.faultType,
      evidenceFile: evidenceFile ?? this.evidenceFile,
      witnesses: witnesses ?? this.witnesses,
      requiresDischarge: requiresDischarge ?? this.requiresDischarge,
      dischargeDeadline: dischargeDeadline ?? this.dischargeDeadline,
      dischargeText: dischargeText ?? this.dischargeText,
      dischargeDate: dischargeDate ?? this.dischargeDate,
      sanctionType: sanctionType ?? this.sanctionType,
      suspensionDays: suspensionDays ?? this.suspensionDays,
      sanctionDescription: sanctionDescription ?? this.sanctionDescription,
      salaryDeduction: salaryDeduction ?? this.salaryDeduction,
      notifiedEmployee: notifiedEmployee ?? this.notifiedEmployee,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      notificationMethod: notificationMethod ?? this.notificationMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      sanctionedAt: sanctionedAt ?? this.sanctionedAt,
      sanctionedBy: sanctionedBy ?? this.sanctionedBy,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'incidentDate': incidentDate.toIso8601String(),
      'incidentDescription': incidentDescription,
      'faultType': faultType,
      'evidenceFile': evidenceFile,
      'witnesses': witnesses,
      'requiresDischarge': requiresDischarge,
      'dischargeDeadline': dischargeDeadline?.toIso8601String(),
      'dischargeText': dischargeText,
      'dischargeDate': dischargeDate?.toIso8601String(),
      'sanctionType': sanctionType,
      'suspensionDays': suspensionDays,
      'sanctionDescription': sanctionDescription,
      'salaryDeduction': salaryDeduction,
      'notifiedEmployee': notifiedEmployee,
      'notifiedAt': notifiedAt?.toIso8601String(),
      'notificationMethod': notificationMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'sanctionedAt': sanctionedAt?.toIso8601String(),
      'sanctionedBy': sanctionedBy,
      'notes': notes,
    };
  }

  factory RrhhDisciplinaryRecord.fromJson(Map<String, dynamic> json) {
    return RrhhDisciplinaryRecord(
      id: json['id'] as int,
      code: json['code'] as String,
      employeeId: json['employeeId'] as int,
      employeeCode: json['employeeCode'] as String,
      employeeName: json['employeeName'] as String,
      incidentDate: DateTime.parse(json['incidentDate'] as String),
      incidentDescription: json['incidentDescription'] as String,
      faultType: json['faultType'] as String,
      evidenceFile: json['evidenceFile'] as String?,
      witnesses: json['witnesses'] as String?,
      requiresDischarge: json['requiresDischarge'] as bool? ?? false,
      dischargeDeadline: json['dischargeDeadline'] != null
          ? DateTime.parse(json['dischargeDeadline'] as String)
          : null,
      dischargeText: json['dischargeText'] as String?,
      dischargeDate: json['dischargeDate'] != null
          ? DateTime.parse(json['dischargeDate'] as String)
          : null,
      sanctionType: json['sanctionType'] as String?,
      suspensionDays: json['suspensionDays'] as int?,
      sanctionDescription: json['sanctionDescription'] as String?,
      salaryDeduction: (json['salaryDeduction'] as num?)?.toDouble(),
      notifiedEmployee: json['notifiedEmployee'] as bool? ?? true,
      notifiedAt: json['notifiedAt'] != null
          ? DateTime.parse(json['notifiedAt'] as String)
          : null,
      notificationMethod: json['notificationMethod'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
      sanctionedAt: json['sanctionedAt'] != null
          ? DateTime.parse(json['sanctionedAt'] as String)
          : null,
      sanctionedBy: json['sanctionedBy'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

/// Constantes y etiquetas para Tipos de Falta
class RrhhFaultTypes {
  static const String leve = 'leve';
  static const String grave = 'grave';
  static const String gravisima = 'gravisima';

  static bool requiresMandatoryDischarge(String type) {
    final lower = type.toLowerCase();
    return lower == grave || lower == gravisima;
  }

  static String label(String type) {
    switch (type.toLowerCase()) {
      case leve:
        return 'Falta Leve';
      case grave:
        return 'Falta Grave';
      case gravisima:
        return 'Falta Gravísima';
      default:
        return type;
    }
  }
}

/// Constantes y etiquetas para Tipos de Sanción
class RrhhSanctionTypes {
  static const String verbal = 'verbal';
  static const String escrita = 'escrita';
  static const String pecuniaria = 'pecuniaria';
  static const String suspension = 'suspension';
  static const String retiro = 'retiro';

  static const int maxSuspensionDays = 5;

  static bool affectsPayroll(String? type) {
    if (type == null) return false;
    final lower = type.toLowerCase();
    return lower == suspension || lower == pecuniaria;
  }

  static String label(String? type) {
    if (type == null) return 'Sin sanción';
    switch (type.toLowerCase()) {
      case verbal:
        return 'Amonestación Verbal';
      case escrita:
        return 'Amonestación Escrita';
      case pecuniaria:
        return 'Sanción Pecuniaria';
      case suspension:
        return 'Suspensión sin goce';
      case retiro:
        return 'Retiro / Destitución';
      default:
        return type;
    }
  }
}

/// Constantes y etiquetas para Estados Disciplinarios
class RrhhDisciplinaryStatus {
  static const String registrada = 'registrada';
  static const String enDescargo = 'en_descargo';
  static const String sancionada = 'sancionada';
  static const String apelada = 'apelada';
  static const String archivada = 'archivada';
  static const String cerrada = 'cerrada';

  static String label(String status) {
    switch (status.toLowerCase()) {
      case registrada:
        return 'Registrada';
      case enDescargo:
        return 'En Descargo';
      case sancionada:
        return 'Sancionada';
      case apelada:
        return 'Apelada';
      case archivada:
        return 'Archivada';
      case cerrada:
        return 'Cerrada';
      default:
        return status;
    }
  }
}
