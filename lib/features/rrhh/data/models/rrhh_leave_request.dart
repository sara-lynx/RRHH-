/// Entidad que representa una solicitud o registro de permiso/licencia laboral.
class RrhhLeaveRequest {
  final int id;
  final String code; // 'PERM-001', 'PERM-002', ...
  final int employeeId; // Referencia a RrhhEmployee
  final String employeeCode; // Snapshot: 'EMP-XXX'
  final String employeeName; // Snapshot: nombre completo
  final String leaveType; // Ver RrhhLeaveTypes
  final DateTime startDate;
  final DateTime endDate;
  final int durationDays; // Días calendario o hábiles calculados
  final bool isPaid; // ¿Con goce de haberes?
  final String reason; // Motivo (obligatorio, >= 20 caracteres)
  final String? evidenceFile; // Nombre del archivo adjunto
  final String? notes; // Observaciones internas (solo RRHH)
  final String
  status; // 'pendiente' | 'aprobado' | 'rechazado' | 'en_curso' | 'finalizado' | 'cancelado'
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy; // Usuario que registró
  final DateTime? approvedAt; // Cuándo se aprobó
  final String? approvedBy;
  final String? rejectionReason; // Si fue rechazado o motivo de cancelación

  const RrhhLeaveRequest({
    required this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    required this.isPaid,
    required this.reason,
    this.evidenceFile,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.approvedAt,
    this.approvedBy,
    this.rejectionReason,
  });

  RrhhLeaveRequest copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? durationDays,
    bool? isPaid,
    String? reason,
    String? evidenceFile,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    DateTime? approvedAt,
    String? approvedBy,
    String? rejectionReason,
  }) {
    return RrhhLeaveRequest(
      id: id ?? this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      durationDays: durationDays ?? this.durationDays,
      isPaid: isPaid ?? this.isPaid,
      reason: reason ?? this.reason,
      evidenceFile: evidenceFile ?? this.evidenceFile,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  factory RrhhLeaveRequest.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return RrhhLeaveRequest(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      employeeId: json['employeeId'] as int? ?? 0,
      employeeCode: json['employeeCode'] as String? ?? '',
      employeeName: json['employeeName'] as String? ?? '',
      leaveType: json['leaveType'] as String? ?? RrhhLeaveTypes.otro,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String) ?? now
          : now,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String) ?? now
          : now,
      durationDays: json['durationDays'] as int? ?? 1,
      isPaid: json['isPaid'] as bool? ?? false,
      reason: json['reason'] as String? ?? '',
      evidenceFile: json['evidenceFile'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? RrhhLeaveStatus.pendiente,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? now
          : now,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? now
          : now,
      createdBy: json['createdBy'] as String? ?? 'RRHH',
      approvedAt: json['approvedAt'] != null
          ? DateTime.tryParse(json['approvedAt'] as String)
          : null,
      approvedBy: json['approvedBy'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'leaveType': leaveType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'durationDays': durationDays,
      'isPaid': isPaid,
      'reason': reason,
      'evidenceFile': evidenceFile,
      'notes': notes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'approvedBy': approvedBy,
      'rejectionReason': rejectionReason,
    };
  }
}

/// Estados válidos de un permiso
class RrhhLeaveStatus {
  static const String pendiente = 'pendiente';
  static const String aprobado = 'aprobado';
  static const String rechazado = 'rechazado';
  static const String enCurso = 'en_curso';
  static const String finalizado = 'finalizado';
  static const String cancelado = 'cancelado';

  static const List<String> all = [
    pendiente,
    aprobado,
    enCurso,
    finalizado,
    rechazado,
    cancelado,
  ];
}

/// Catálogo de tipos de permiso y sus reglas de negocio
class RrhhLeaveTypes {
  static const String maternidad = 'MATERNIDAD';
  static const String paternidad = 'PATERNIDAD';
  static const String enfermedad = 'ENFERMEDAD';
  static const String accidente = 'ACCIDENTE';
  static const String duelo = 'DUELO';
  static const String matrimonio = 'MATRIMONIO';
  static const String estudio = 'ESTUDIO';
  static const String personalConGoce = 'PERSONAL_CON_GOCE';
  static const String personalSinGoce = 'PERSONAL_SIN_GOCE';
  static const String tramitePersonal = 'TRAMITE_PERSONAL';
  static const String calamidadDomestica = 'CALAMIDAD_DOMESTICA';
  static const String otro = 'OTRO';

  static const List<String> all = [
    maternidad,
    paternidad,
    enfermedad,
    accidente,
    duelo,
    matrimonio,
    estudio,
    personalConGoce,
    personalSinGoce,
    tramitePersonal,
    calamidadDomestica,
    otro,
  ];

  static String label(String type) => getLabel(type);

  static String getLabel(String type) {
    switch (type.toUpperCase()) {
      case maternidad:
        return 'Maternidad';
      case paternidad:
        return 'Paternidad';
      case enfermedad:
        return 'Enfermedad (Médica)';
      case accidente:
        return 'Accidente Laboral';
      case duelo:
        return 'Duelo Familiar';
      case matrimonio:
        return 'Matrimonio';
      case estudio:
        return 'Estudios / Exámenes';
      case personalConGoce:
        return 'Personal c/ Goce';
      case personalSinGoce:
        return 'Personal s/ Goce';
      case tramitePersonal:
        return 'Trámite Personal';
      case calamidadDomestica:
        return 'Calamidad Doméstica';
      case otro:
      default:
        return 'Otro';
    }
  }

  /// Retorna si el tipo de permiso por ley o política es obligatoriamente pagado
  static bool isMandatoryPaid(String type) {
    switch (type.toUpperCase()) {
      case maternidad:
      case paternidad:
      case enfermedad:
      case accidente:
      case duelo:
      case matrimonio:
        return true;
      default:
        return false;
    }
  }

  /// Retorna si el tipo de permiso es obligatoriamente no pagado
  static bool isMandatoryUnpaid(String type) {
    switch (type.toUpperCase()) {
      case personalSinGoce:
      case tramitePersonal:
        return true;
      default:
        return false;
    }
  }

  /// Retorna el valor sugerido inicial de `isPaid`
  static bool defaultIsPaid(String type) {
    if (isMandatoryPaid(type)) return true;
    if (isMandatoryUnpaid(type)) return false;
    // Estudio, personalConGoce, calamidadDomestica, otro
    if (type.toUpperCase() == personalConGoce ||
        type.toUpperCase() == calamidadDomestica ||
        type.toUpperCase() == estudio) {
      return true;
    }
    return false;
  }

  /// Retorna si el usuario puede alterar el switch de `isPaid`
  static bool canTogglePaid(String type) {
    return !isMandatoryPaid(type) && !isMandatoryUnpaid(type);
  }

  /// Retorna si requiere certificado/archivo adjunto obligatorio
  static bool requiresEvidence(String type) {
    return type.toUpperCase() == enfermedad || type.toUpperCase() == accidente;
  }

  /// Retorna si el tipo de permiso permite goce a criterio/discreción de la empresa
  static bool isDiscretionaryPaid(String type) => canTogglePaid(type);

  /// Calcula los días calendario entre dos fechas (inclusive)
  static int calculateCalendarDays(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    if (e.isBefore(s)) return 0;
    return e.difference(s).inDays + 1;
  }

  /// Calcula los días hábiles (Lunes a Viernes) entre dos fechas (inclusive)
  static int calculateWorkingDays(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    if (e.isBefore(s)) return 0;

    int days = 0;
    DateTime cur = s;
    while (!cur.isAfter(e)) {
      if (cur.weekday != DateTime.saturday && cur.weekday != DateTime.sunday) {
        days++;
      }
      cur = cur.add(const Duration(days: 1));
    }
    return days;
  }
}
