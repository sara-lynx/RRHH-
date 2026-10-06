/// Solicitud de Permiso Laboral
class RrhhLeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final String
  leaveType; // 'Médico', 'Personal', 'Duelo', 'Maternidad/Paternidad', 'Comisión'
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final bool hasDoctorNoteOrProof;
  final String status; // 'PENDIENTE', 'APROBADO', 'RECHAZADO'
  final String? approvedBy;
  final DateTime? responseDate;
  final String? responseNotes;

  const RrhhLeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    this.hasDoctorNoteOrProof = false,
    required this.status,
    this.approvedBy,
    this.responseDate,
    this.responseNotes,
  });

  RrhhLeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeCode,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    String? reason,
    bool? hasDoctorNoteOrProof,
    String? status,
    String? approvedBy,
    DateTime? responseDate,
    String? responseNotes,
  }) {
    return RrhhLeaveRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeCode: employeeCode ?? this.employeeCode,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      hasDoctorNoteOrProof: hasDoctorNoteOrProof ?? this.hasDoctorNoteOrProof,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      responseDate: responseDate ?? this.responseDate,
      responseNotes: responseNotes ?? this.responseNotes,
    );
  }

  int get daysCount => totalDays;
}

/// Solicitud y registro de Vacaciones
class RrhhVacationRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime startDate;
  final DateTime endDate;
  final int requestedDays;
  final int availableDaysBalance;
  final String status; // 'PENDIENTE', 'APROBADO', 'RECHAZADO'
  final String notes;
  final String? approvedBy;

  int get daysRequested => requestedDays;
  int get remainingBalanceDays => availableDaysBalance;

  const RrhhVacationRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.startDate,
    required this.endDate,
    required this.requestedDays,
    required this.availableDaysBalance,
    required this.status,
    this.notes = '',
    this.approvedBy,
  });

  RrhhVacationRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeCode,
    DateTime? startDate,
    DateTime? endDate,
    int? requestedDays,
    int? availableDaysBalance,
    String? status,
    String? notes,
    String? approvedBy,
  }) {
    return RrhhVacationRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeCode: employeeCode ?? this.employeeCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requestedDays: requestedDays ?? this.requestedDays,
      availableDaysBalance: availableDaysBalance ?? this.availableDaysBalance,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      approvedBy: approvedBy ?? this.approvedBy,
    );
  }
}

/// Incidencia laboral o reporte disciplinario / mock de asistencia
class RrhhIncident {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime date;
  final String
  incidentType; // 'FALTA_INJUSTIFICADA', 'ATRASO_REITERADO', 'MEMORANDUM', 'LLAMADA_ATENCION', 'RECONOCIMIENTO', 'ABANDONO'
  final String severity; // 'BAJA', 'MEDIA', 'ALTA'
  final String description;
  final String
  administrativeResolution; // 'Justificado', 'Descuento aplicado', 'Advertencia formal', 'En revisión'
  final String registeredBy;

  String get type => incidentType;
  String get title => administrativeResolution.isNotEmpty
      ? administrativeResolution
      : incidentType;
  String get reportedBy => registeredBy;

  const RrhhIncident({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.date,
    required this.incidentType,
    required this.severity,
    required this.description,
    required this.administrativeResolution,
    required this.registeredBy,
  });
}

/// Movimiento laboral del empleado (ascenso, cambio de área, ajuste salarial, transferencia)
class RrhhLaborMovement {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime effectiveDate;
  final String
  movementType; // 'CAMBIO_CARGO', 'AJUSTE_SALARIAL', 'TRANSFERENCIA_SEDE', 'CAMBIO_TURNO', 'CAMBIO_CLIENTE'
  final String previousValue;
  final String newValue;
  final String justification;
  final String authorizedBy;

  String get type => movementType;
  DateTime get date => effectiveDate;
  String get description => '$justification ($previousValue ➔ $newValue)';
  String get approvedBy => authorizedBy;

  const RrhhLaborMovement({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.effectiveDate,
    required this.movementType,
    required this.previousValue,
    required this.newValue,
    required this.justification,
    required this.authorizedBy,
  });
}

/// Registro formal de desvinculación laboral
class RrhhExitRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime exitDate;
  final String
  reason; // 'Renuncia voluntaria', 'Conclusión de contrato', 'Despido justificado', 'Mutuo acuerdo'
  final String observations;
  final String documentationAttached;
  final String processedBy;
  final double severancePay;

  String get exitInterviewNotes => observations;

  const RrhhExitRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.exitDate,
    required this.reason,
    required this.observations,
    required this.documentationAttached,
    required this.processedBy,
    this.severancePay = 4500.0,
  });
}
