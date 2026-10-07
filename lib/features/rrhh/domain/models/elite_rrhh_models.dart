import 'package:flutter/material.dart';

/// Clasificación operativa del personal: Oficina o Campo.
enum EmployeeWorkplaceType {
  oficina,
  campo;

  String get label => switch (this) {
        EmployeeWorkplaceType.oficina => 'OFICINA',
        EmployeeWorkplaceType.campo => 'CAMPO',
      };

  Color get badgeColor => switch (this) {
        EmployeeWorkplaceType.oficina => const Color(0xFF2563EB),
        EmployeeWorkplaceType.campo => const Color(0xFF0D9488),
      };

  Color get badgeBgColor => switch (this) {
        EmployeeWorkplaceType.oficina => const Color(0xFFEFF6FF),
        EmployeeWorkplaceType.campo => const Color(0xFFF0FDFA),
      };

  Color get badgeBorderColor => switch (this) {
        EmployeeWorkplaceType.oficina => const Color(0xFFDBEAFE),
        EmployeeWorkplaceType.campo => const Color(0xFFCCFBF1),
      };
}

/// Estado laboral administrativo del colaborador.
enum EmployeeStatus {
  activo,
  periodoPrueba,
  deBaja,
  suspendido;

  String get label => switch (this) {
        EmployeeStatus.activo => 'Activo',
        EmployeeStatus.periodoPrueba => 'Período de Prueba',
        EmployeeStatus.deBaja => 'De Baja',
        EmployeeStatus.suspendido => 'Suspendido',
      };

  Color get badgeColor => switch (this) {
        EmployeeStatus.activo => const Color(0xFF16A34A),
        EmployeeStatus.periodoPrueba => const Color(0xFFD97706),
        EmployeeStatus.deBaja => const Color(0xFFDC2626),
        EmployeeStatus.suspendido => const Color(0xFF64748B),
      };

  Color get badgeBgColor => switch (this) {
        EmployeeStatus.activo => const Color(0xFFF0FDF4),
        EmployeeStatus.periodoPrueba => const Color(0xFFFFFBEB),
        EmployeeStatus.deBaja => const Color(0xFFFEF2F2),
        EmployeeStatus.suspendido => const Color(0xFFF8FAFC),
      };

  Color get badgeBorderColor => switch (this) {
        EmployeeStatus.activo => const Color(0xFFDCFCE7),
        EmployeeStatus.periodoPrueba => const Color(0xFFFEF3C7),
        EmployeeStatus.deBaja => const Color(0xFFFEE2E2),
        EmployeeStatus.suspendido => const Color(0xFFE2E8F0),
      };
}

/// Tipo de contrato legal según la Ley General del Trabajo.
enum ContractType {
  indefinido,
  plazoFijo,
  pasantia;

  String get label => switch (this) {
        ContractType.indefinido => 'Indefinido',
        ContractType.plazoFijo => 'Plazo Fijo',
        ContractType.pasantia => 'Pasantía',
      };
}

/// Constantes y catálogo de Centros de Costo de Elite Multiservicios.
abstract class EliteCostCenter {
  static const String seg = 'CC-SEG';
  static const String lim = 'CC-LIM';
  static const String jar = 'CC-JAR';
  static const String man = 'CC-MAN';
  static const String adm = 'CC-ADM';
  static const String com = 'CC-COM';
  static const String rrhh = 'CC-RRHH';

  static const List<String> all = [
    seg,
    lim,
    jar,
    man,
    adm,
    com,
    rrhh,
  ];

  static String getLabel(String code) => switch (code) {
        seg => 'CC-SEG • Seguridad',
        lim => 'CC-LIM • Limpieza',
        jar => 'CC-JAR • Jardinería',
        man => 'CC-MAN • Mantenimiento',
        adm => 'CC-ADM • Administración',
        com => 'CC-COM • Comercial & Ventas',
        rrhh => 'CC-RRHH • Recursos Humanos',
        _ => code,
      };

  static String getShortName(String code) => switch (code) {
        seg => 'Seguridad',
        lim => 'Limpieza',
        jar => 'Jardinería',
        man => 'Mantenimiento',
        adm => 'Administración',
        com => 'Comercial',
        rrhh => 'RRHH',
        _ => code,
      };
}

/// Entidad central del Colaborador / Empleado de Elite Multiservicios S.R.L.
class EliteEmployee {
  final String id;
  final String ci;
  final String fullName;
  final String phone;
  final String email;

  // Clasificación laboral
  final EmployeeWorkplaceType workplaceType;
  final String serviceLineCode; // CC-SEG, CC-LIM, CC-JAR, CC-MAN, CC-ADM, CC-COM, CC-RRHH
  final String position;
  final String assignedSite; // Cliente/sucursal o 'Sede Central'

  // Aspectos contractuales y salariales
  final ContractType contractType;
  final DateTime hireDate;
  final DateTime? contractEndDate;
  final double baseSalary;
  final bool hasPendingLegalDocs;
  final EmployeeStatus status;

  const EliteEmployee({
    required this.id,
    required this.ci,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.workplaceType,
    required this.serviceLineCode,
    required this.position,
    required this.assignedSite,
    required this.contractType,
    required this.hireDate,
    this.contractEndDate,
    required this.baseSalary,
    required this.hasPendingLegalDocs,
    this.status = EmployeeStatus.activo,
  });

  bool get isOffice => workplaceType == EmployeeWorkplaceType.oficina;
  bool get isField => workplaceType == EmployeeWorkplaceType.campo;

  /// Retorna si el contrato a plazo fijo está próximo a vencer en menos de 30 días.
  bool get isContractNearExpiry {
    if (contractType != ContractType.plazoFijo || contractEndDate == null) {
      return false;
    }
    final now = DateTime.now();
    final difference = contractEndDate!.difference(now).inDays;
    return difference >= 0 && difference <= 30;
  }

  /// Retorna si el contrato ya venció.
  bool get isContractExpired {
    if (contractType != ContractType.plazoFijo || contractEndDate == null) {
      return false;
    }
    return contractEndDate!.isBefore(DateTime.now());
  }

  EliteEmployee copyWith({
    String? id,
    String? ci,
    String? fullName,
    String? phone,
    String? email,
    EmployeeWorkplaceType? workplaceType,
    String? serviceLineCode,
    String? position,
    String? assignedSite,
    ContractType? contractType,
    DateTime? hireDate,
    DateTime? contractEndDate,
    double? baseSalary,
    bool? hasPendingLegalDocs,
    EmployeeStatus? status,
  }) {
    return EliteEmployee(
      id: id ?? this.id,
      ci: ci ?? this.ci,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      workplaceType: workplaceType ?? this.workplaceType,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      position: position ?? this.position,
      assignedSite: assignedSite ?? this.assignedSite,
      contractType: contractType ?? this.contractType,
      hireDate: hireDate ?? this.hireDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      baseSalary: baseSalary ?? this.baseSalary,
      hasPendingLegalDocs: hasPendingLegalDocs ?? this.hasPendingLegalDocs,
      status: status ?? this.status,
    );
  }
}

/// Escala salarial y dotación por cargo de Elite Multiservicios.
class PositionSalaryScale {
  final String position;
  final String serviceLineCode;
  final EmployeeWorkplaceType workplaceType;
  final double minSalary;
  final double maxSalary;
  final int headcount;

  const PositionSalaryScale({
    required this.position,
    required this.serviceLineCode,
    required this.workplaceType,
    required this.minSalary,
    required this.maxSalary,
    required this.headcount,
  });
}

/// Clasificación de alcance para turnos.
enum ShiftWorkplaceType {
  oficina,
  campo;

  String get label => switch (this) {
        ShiftWorkplaceType.oficina => 'OFICINA',
        ShiftWorkplaceType.campo => 'CAMPO',
      };

  Color get badgeColor => switch (this) {
        ShiftWorkplaceType.oficina => const Color(0xFF2563EB),
        ShiftWorkplaceType.campo => const Color(0xFF0D9488),
      };

  Color get badgeBgColor => switch (this) {
        ShiftWorkplaceType.oficina => const Color(0xFFEFF6FF),
        ShiftWorkplaceType.campo => const Color(0xFFF0FDFA),
      };

  Color get badgeBorderColor => switch (this) {
        ShiftWorkplaceType.oficina => const Color(0xFFDBEAFE),
        ShiftWorkplaceType.campo => const Color(0xFFCCFBF1),
      };
}

/// Turno u horario laboral programable en Elite Multiservicios.
class EliteShift {
  final String id;
  final String code; // Ej: TUR-ADM-01, TUR-SEG-12D
  final String name; // Ej: Administrativo Central 8h
  final ShiftWorkplaceType workplaceType;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int gracePeriodMinutes; // Tolerancia en minutos
  final bool crossesMidnight;
  final String activeDays; // Ej: 'Lunes a Viernes', 'Rotativo Continuo'

  const EliteShift({
    required this.id,
    required this.code,
    required this.name,
    required this.workplaceType,
    required this.startTime,
    required this.endTime,
    required this.gracePeriodMinutes,
    this.crossesMidnight = false,
    required this.activeDays,
  });

  String get formattedSchedule {
    final start =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end${crossesMidnight ? ' (+1d)' : ''}';
  }

  EliteShift copyWith({
    String? id,
    String? code,
    String? name,
    ShiftWorkplaceType? workplaceType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? gracePeriodMinutes,
    bool? crossesMidnight,
    String? activeDays,
  }) {
    return EliteShift(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      workplaceType: workplaceType ?? this.workplaceType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      gracePeriodMinutes: gracePeriodMinutes ?? this.gracePeriodMinutes,
      crossesMidnight: crossesMidnight ?? this.crossesMidnight,
      activeDays: activeDays ?? this.activeDays,
    );
  }
}

/// Sede operativa de un cliente con configuración de Geocerca GPS para la APK.
class EliteClientSite {
  final String id;
  final String code; // SITE-PALMAS, SITE-VENTURA, etc.
  final String name; // Condominio Las Palmas
  final String serviceLineCode; // CC-SEG, CC-LIM, CC-MAN, etc.
  final double latitude;
  final double longitude;
  final double geofenceRadiusMeters; // 50m, 80m, 100m
  final int requiredPersonnel; // Dotación pactada en contrato
  final int currentAssigned; // Dotación cubierta actualmente

  const EliteClientSite({
    required this.id,
    required this.code,
    required this.name,
    required this.serviceLineCode,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadiusMeters,
    required this.requiredPersonnel,
    required this.currentAssigned,
  });

  bool get isFullyCovered => currentAssigned >= requiredPersonnel;

  double get coveragePercent =>
      requiredPersonnel > 0 ? (currentAssigned / requiredPersonnel) : 1.0;

  EliteClientSite copyWith({
    String? id,
    String? code,
    String? name,
    String? serviceLineCode,
    double? latitude,
    double? longitude,
    double? geofenceRadiusMeters,
    int? requiredPersonnel,
    int? currentAssigned,
  }) {
    return EliteClientSite(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geofenceRadiusMeters: geofenceRadiusMeters ?? this.geofenceRadiusMeters,
      requiredPersonnel: requiredPersonnel ?? this.requiredPersonnel,
      currentAssigned: currentAssigned ?? this.currentAssigned,
    );
  }
}

/// Asignación activa en la Malla de Cuadrantes.
class EliteRosterAssignment {
  final String id;
  final String employeeId;
  final String employeeName;
  final String serviceLineCode; // CC-SEG, CC-LIM, etc.
  final String siteId;
  final String siteName;
  final String shiftId;
  final String shiftName;
  final String scheduleSummary;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // 'activo', 'rotado'

  const EliteRosterAssignment({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.serviceLineCode,
    required this.siteId,
    required this.siteName,
    required this.shiftId,
    required this.shiftName,
    required this.scheduleSummary,
    required this.startDate,
    this.endDate,
    this.status = 'activo',
  });

  bool get isActive => status == 'activo';

  EliteRosterAssignment copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? serviceLineCode,
    String? siteId,
    String? siteName,
    String? shiftId,
    String? shiftName,
    String? scheduleSummary,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return EliteRosterAssignment(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      siteId: siteId ?? this.siteId,
      siteName: siteName ?? this.siteName,
      shiftId: shiftId ?? this.shiftId,
      shiftName: shiftName ?? this.shiftName,
      scheduleSummary: scheduleSummary ?? this.scheduleSummary,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }
}

// =============================================================================
// SUBMÓDULO 3: CONTROL DE ASISTENCIA DUAL (OFICINA Y CAMPO APK)
// =============================================================================

/// Tipo de marcación de asistencia: Entrada o Salida.
enum AttendancePunchType {
  entrada,
  salida;

  String get label => switch (this) {
        AttendancePunchType.entrada => 'Entrada',
        AttendancePunchType.salida => 'Salida',
      };
}

/// Origen tecnológico del registro de asistencia.
enum AttendanceSource {
  webOficina,
  apkCampoGps,
  manualSupervisor;

  String get label => switch (this) {
        AttendanceSource.webOficina => 'Web Oficina',
        AttendanceSource.apkCampoGps => 'APK GPS Automático',
        AttendanceSource.manualSupervisor => 'Autorización Manual',
      };

  Color get badgeColor => switch (this) {
        AttendanceSource.webOficina => const Color(0xFF2563EB),
        AttendanceSource.apkCampoGps => const Color(0xFF0D9488),
        AttendanceSource.manualSupervisor => const Color(0xFFD97706),
      };

  Color get badgeBgColor => switch (this) {
        AttendanceSource.webOficina => const Color(0xFFEFF6FF),
        AttendanceSource.apkCampoGps => const Color(0xFFF0FDFA),
        AttendanceSource.manualSupervisor => const Color(0xFFFFFBEB),
      };

  Color get badgeBorderColor => switch (this) {
        AttendanceSource.webOficina => const Color(0xFFDBEAFE),
        AttendanceSource.apkCampoGps => const Color(0xFF99F6E4),
        AttendanceSource.manualSupervisor => const Color(0xFFFEF3C7),
      };
}

/// Estado de validación perimetral por Geocerca satelital.
enum GeofenceStatus {
  dentroDeRadio,
  fueraDePerimetro,
  noAplica;

  String get label => switch (this) {
        GeofenceStatus.dentroDeRadio => 'Dentro de Radio',
        GeofenceStatus.fueraDePerimetro => 'Fuera de Perímetro',
        GeofenceStatus.noAplica => 'No Aplica (Oficina)',
      };

  Color get badgeColor => switch (this) {
        GeofenceStatus.dentroDeRadio => const Color(0xFF047857),
        GeofenceStatus.fueraDePerimetro => const Color(0xFFB91C1C),
        GeofenceStatus.noAplica => const Color(0xFF64748B),
      };

  Color get badgeBgColor => switch (this) {
        GeofenceStatus.dentroDeRadio => const Color(0xFFECFDF5),
        GeofenceStatus.fueraDePerimetro => const Color(0xFFFEF2F2),
        GeofenceStatus.noAplica => const Color(0xFFF8FAFC),
      };

  Color get badgeBorderColor => switch (this) {
        GeofenceStatus.dentroDeRadio => const Color(0xFFA7F3D0),
        GeofenceStatus.fueraDePerimetro => const Color(0xFFFECACA),
        GeofenceStatus.noAplica => const Color(0xFFE2E8F0),
      };
}

/// Evaluación reglamentaria de puntualidad y asistencia.
enum AttendanceEvaluation {
  puntual,
  retraso,
  faltaInjustificada,
  enJornada,
  jornadaCompletada;

  String get label => switch (this) {
        AttendanceEvaluation.puntual => 'Puntual',
        AttendanceEvaluation.retraso => 'Retraso',
        AttendanceEvaluation.faltaInjustificada => 'Ausente',
        AttendanceEvaluation.enJornada => 'En Jornada',
        AttendanceEvaluation.jornadaCompletada => 'Jornada Completa',
      };

  Color get badgeColor => switch (this) {
        AttendanceEvaluation.puntual => const Color(0xFF047857),
        AttendanceEvaluation.retraso => const Color(0xFFB45309),
        AttendanceEvaluation.faltaInjustificada => const Color(0xFFB91C1C),
        AttendanceEvaluation.enJornada => const Color(0xFF0284C7),
        AttendanceEvaluation.jornadaCompletada => const Color(0xFF0F766E),
      };

  Color get badgeBgColor => switch (this) {
        AttendanceEvaluation.puntual => const Color(0xFFECFDF5),
        AttendanceEvaluation.retraso => const Color(0xFFFFFBEB),
        AttendanceEvaluation.faltaInjustificada => const Color(0xFFFEF2F2),
        AttendanceEvaluation.enJornada => const Color(0xFFF0F9FF),
        AttendanceEvaluation.jornadaCompletada => const Color(0xFFF0FDFA),
      };

  Color get badgeBorderColor => switch (this) {
        AttendanceEvaluation.puntual => const Color(0xFFA7F3D0),
        AttendanceEvaluation.retraso => const Color(0xFFFDE68A),
        AttendanceEvaluation.faltaInjustificada => const Color(0xFFFECACA),
        AttendanceEvaluation.enJornada => const Color(0xFFBAE6FD),
        AttendanceEvaluation.jornadaCompletada => const Color(0xFF99F6E4),
      };
}

/// Modelo de registro de asistencia (Web y APK Campo).
class EliteAttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeJobTitle;
  final EmployeeWorkplaceType workplaceType;
  final String serviceLineCode;
  final String assignedSite;
  final String shiftName;
  final AttendancePunchType punchType;
  final DateTime timestamp;
  final DateTime? checkOutTimestamp;
  final AttendanceSource source;
  final AttendanceEvaluation evaluation;
  final int lateMinutes;

  // Datos específicos de Oficina
  final String? ipAddress;
  final String? deviceBrowser;

  // Datos específicos de Campo (APK)
  final double? latitude;
  final double? longitude;
  final double? distanceToSiteMeters;
  final GeofenceStatus geofenceStatus;
  final bool isOfflineSync;

  const EliteAttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    this.employeeJobTitle = '',
    required this.workplaceType,
    required this.serviceLineCode,
    required this.assignedSite,
    required this.shiftName,
    required this.punchType,
    required this.timestamp,
    this.checkOutTimestamp,
    required this.source,
    required this.evaluation,
    this.lateMinutes = 0,
    this.ipAddress,
    this.deviceBrowser,
    this.latitude,
    this.longitude,
    this.distanceToSiteMeters,
    this.geofenceStatus = GeofenceStatus.noAplica,
    this.isOfflineSync = false,
  });

  bool get isField => workplaceType == EmployeeWorkplaceType.campo;
  bool get isOffice => workplaceType == EmployeeWorkplaceType.oficina;

  EliteAttendanceRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeJobTitle,
    EmployeeWorkplaceType? workplaceType,
    String? serviceLineCode,
    String? assignedSite,
    String? shiftName,
    AttendancePunchType? punchType,
    DateTime? timestamp,
    DateTime? checkOutTimestamp,
    AttendanceSource? source,
    AttendanceEvaluation? evaluation,
    int? lateMinutes,
    String? ipAddress,
    String? deviceBrowser,
    double? latitude,
    double? longitude,
    double? distanceToSiteMeters,
    GeofenceStatus? geofenceStatus,
    bool? isOfflineSync,
  }) {
    return EliteAttendanceRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeJobTitle: employeeJobTitle ?? this.employeeJobTitle,
      workplaceType: workplaceType ?? this.workplaceType,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      assignedSite: assignedSite ?? this.assignedSite,
      shiftName: shiftName ?? this.shiftName,
      punchType: punchType ?? this.punchType,
      timestamp: timestamp ?? this.timestamp,
      checkOutTimestamp: checkOutTimestamp ?? this.checkOutTimestamp,
      source: source ?? this.source,
      evaluation: evaluation ?? this.evaluation,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceBrowser: deviceBrowser ?? this.deviceBrowser,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceToSiteMeters: distanceToSiteMeters ?? this.distanceToSiteMeters,
      geofenceStatus: geofenceStatus ?? this.geofenceStatus,
      isOfflineSync: isOfflineSync ?? this.isOfflineSync,
    );
  }
}

// =============================================================================
// SUBMÓDULO 4: NOVEDADES E INCIDENCIAS (PERMISOS, SANCIONES Y VACACIONES)
// =============================================================================

/// Tipo reglamentario de permiso o baja médica.
enum LeaveType {
  bajaMedica,
  tramiteParticular,
  duelo,
  matrimonio,
  capacitacion;

  String get label => switch (this) {
        LeaveType.bajaMedica => 'Baja Médica (SUS/CNS)',
        LeaveType.tramiteParticular => 'Trámite Particular',
        LeaveType.duelo => 'Duelo Familiar',
        LeaveType.matrimonio => 'Matrimonio',
        LeaveType.capacitacion => 'Capacitación Oficial',
      };

  Color get badgeColor => switch (this) {
        LeaveType.bajaMedica => const Color(0xFFDC2626),
        LeaveType.tramiteParticular => const Color(0xFF64748B),
        LeaveType.duelo => const Color(0xFF475569),
        LeaveType.matrimonio => const Color(0xFF7C3AED),
        LeaveType.capacitacion => const Color(0xFF2563EB),
      };

  Color get badgeBgColor => switch (this) {
        LeaveType.bajaMedica => const Color(0xFFFEF2F2),
        LeaveType.tramiteParticular => const Color(0xFFF8FAFC),
        LeaveType.duelo => const Color(0xFFF1F5F9),
        LeaveType.matrimonio => const Color(0xFFF5F3FF),
        LeaveType.capacitacion => const Color(0xFFEFF6FF),
      };

  Color get badgeBorderColor => switch (this) {
        LeaveType.bajaMedica => const Color(0xFFFEE2E2),
        LeaveType.tramiteParticular => const Color(0xFFE2E8F0),
        LeaveType.duelo => const Color(0xFFCBD5E1),
        LeaveType.matrimonio => const Color(0xFFDDD6FE),
        LeaveType.capacitacion => const Color(0xFFDBEAFE),
      };
}

/// Condición de remuneración del permiso según la Ley General del Trabajo.
enum LeavePaymentStatus {
  conGoce,
  sinGoce;

  String get label => switch (this) {
        LeavePaymentStatus.conGoce => 'Con Goce de Haberes',
        LeavePaymentStatus.sinGoce => 'Sin Goce de Haberes',
      };

  Color get badgeColor => switch (this) {
        LeavePaymentStatus.conGoce => const Color(0xFF16A34A),
        LeavePaymentStatus.sinGoce => const Color(0xFFD97706),
      };

  Color get badgeBgColor => switch (this) {
        LeavePaymentStatus.conGoce => const Color(0xFFF0FDF4),
        LeavePaymentStatus.sinGoce => const Color(0xFFFFFBEB),
      };

  Color get badgeBorderColor => switch (this) {
        LeavePaymentStatus.conGoce => const Color(0xFFDCFCE7),
        LeavePaymentStatus.sinGoce => const Color(0xFFFEF3C7),
      };
}

/// Estado administrativo de la solicitud de permiso.
enum LeaveRequestStatus {
  pendiente,
  aprobado,
  rechazado;

  String get label => switch (this) {
        LeaveRequestStatus.pendiente => 'Pendiente',
        LeaveRequestStatus.aprobado => 'Aprobado',
        LeaveRequestStatus.rechazado => 'Rechazado',
      };

  Color get badgeColor => switch (this) {
        LeaveRequestStatus.pendiente => const Color(0xFFD97706),
        LeaveRequestStatus.aprobado => const Color(0xFF16A34A),
        LeaveRequestStatus.rechazado => const Color(0xFFDC2626),
      };

  Color get badgeBgColor => switch (this) {
        LeaveRequestStatus.pendiente => const Color(0xFFFFFBEB),
        LeaveRequestStatus.aprobado => const Color(0xFFF0FDF4),
        LeaveRequestStatus.rechazado => const Color(0xFFFEF2F2),
      };

  Color get badgeBorderColor => switch (this) {
        LeaveRequestStatus.pendiente => const Color(0xFFFEF3C7),
        LeaveRequestStatus.aprobado => const Color(0xFFDCFCE7),
        LeaveRequestStatus.rechazado => const Color(0xFFFEE2E2),
      };
}

/// Solicitud de licencia, baja médica o permiso laboral.
class EliteLeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String serviceLineCode;
  final EmployeeWorkplaceType workplaceType;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final String? attachmentUrl;
  final LeavePaymentStatus paymentStatus;
  final LeaveRequestStatus status;
  final String source; // "APK Móvil Campo" o "Portal Oficina"

  const EliteLeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.serviceLineCode,
    required this.workplaceType,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    this.attachmentUrl,
    required this.paymentStatus,
    this.status = LeaveRequestStatus.pendiente,
    required this.source,
  });

  bool get isApproved => status == LeaveRequestStatus.aprobado;
  bool get isRejected => status == LeaveRequestStatus.rechazado;
  bool get isPending => status == LeaveRequestStatus.pendiente;

  EliteLeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? serviceLineCode,
    EmployeeWorkplaceType? workplaceType,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    String? reason,
    String? attachmentUrl,
    LeavePaymentStatus? paymentStatus,
    LeaveRequestStatus? status,
    String? source,
  }) {
    return EliteLeaveRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      workplaceType: workplaceType ?? this.workplaceType,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      reason: reason ?? this.reason,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      source: source ?? this.source,
    );
  }
}

/// Acumulado de tardanzas, faltas injustificadas y deducción legal en Bs.
class EliteTardinessPenalty {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeJobTitle;
  final String serviceLineCode;
  final EmployeeWorkplaceType workplaceType;
  final String monthPeriod; // "Octubre 2026"
  final int totalLateMinutes;
  final int unexcusedAbsences;
  final double penaltyAmountBs;
  final String status; // "Pendiente de Planilla", "Aplicado en Nómina"

  const EliteTardinessPenalty({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    this.employeeJobTitle = '',
    required this.serviceLineCode,
    required this.workplaceType,
    required this.monthPeriod,
    required this.totalLateMinutes,
    required this.unexcusedAbsences,
    required this.penaltyAmountBs,
    this.status = 'Pendiente de Planilla',
  });

  EliteTardinessPenalty copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeJobTitle,
    String? serviceLineCode,
    EmployeeWorkplaceType? workplaceType,
    String? monthPeriod,
    int? totalLateMinutes,
    int? unexcusedAbsences,
    double? penaltyAmountBs,
    String? status,
  }) {
    return EliteTardinessPenalty(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeJobTitle: employeeJobTitle ?? this.employeeJobTitle,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      workplaceType: workplaceType ?? this.workplaceType,
      monthPeriod: monthPeriod ?? this.monthPeriod,
      totalLateMinutes: totalLateMinutes ?? this.totalLateMinutes,
      unexcusedAbsences: unexcusedAbsences ?? this.unexcusedAbsences,
      penaltyAmountBs: penaltyAmountBs ?? this.penaltyAmountBs,
      status: status ?? this.status,
    );
  }
}

/// Registro y saldo de vacaciones según la Ley General del Trabajo.
class EliteVacationRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeJobTitle;
  final String serviceLineCode;
  final DateTime hireDate;
  final int yearsOfService;
  final int legalDaysTotal;
  final int daysUsed;
  final int daysRemaining;
  final String? currentRequest;

  const EliteVacationRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    this.employeeJobTitle = '',
    required this.serviceLineCode,
    required this.hireDate,
    required this.yearsOfService,
    required this.legalDaysTotal,
    required this.daysUsed,
    required this.daysRemaining,
    this.currentRequest,
  });

  EliteVacationRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeJobTitle,
    String? serviceLineCode,
    DateTime? hireDate,
    int? yearsOfService,
    int? legalDaysTotal,
    int? daysUsed,
    int? daysRemaining,
    String? currentRequest,
  }) {
    return EliteVacationRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeJobTitle: employeeJobTitle ?? this.employeeJobTitle,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      hireDate: hireDate ?? this.hireDate,
      yearsOfService: yearsOfService ?? this.yearsOfService,
      legalDaysTotal: legalDaysTotal ?? this.legalDaysTotal,
      daysUsed: daysUsed ?? this.daysUsed,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      currentRequest: currentRequest ?? this.currentRequest,
    );
  }
}

// =============================================================================
// SUBMÓDULO 5: NÓMINA Y PRE-PLANILLA (LGT BOLIVIANA Y ASIENTO CONTABLE)
// =============================================================================

/// Registro individual de nómina por trabajador para el período mensual.
class ElitePayrollItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String ci;
  final String position;
  final String serviceLineCode;
  final EmployeeWorkplaceType workplaceType;
  final double baseSalary;
  final double seniorityBonus;
  final double totalEarned;
  final double penaltyDeductions;
  final double gestoraDeduction;
  final double totalDeductions;
  final double netPayable;
  final String bankAccount;
  final DateTime? hireDate;

  const ElitePayrollItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.ci,
    required this.position,
    required this.serviceLineCode,
    required this.workplaceType,
    required this.baseSalary,
    required this.seniorityBonus,
    required this.totalEarned,
    required this.penaltyDeductions,
    required this.gestoraDeduction,
    required this.totalDeductions,
    required this.netPayable,
    required this.bankAccount,
    this.hireDate,
  });

  bool get isOffice => workplaceType == EmployeeWorkplaceType.oficina;
  bool get isField => workplaceType == EmployeeWorkplaceType.campo;

  ElitePayrollItem copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? ci,
    String? position,
    String? serviceLineCode,
    EmployeeWorkplaceType? workplaceType,
    double? baseSalary,
    double? seniorityBonus,
    double? totalEarned,
    double? penaltyDeductions,
    double? gestoraDeduction,
    double? totalDeductions,
    double? netPayable,
    String? bankAccount,
    DateTime? hireDate,
  }) {
    return ElitePayrollItem(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      ci: ci ?? this.ci,
      position: position ?? this.position,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      workplaceType: workplaceType ?? this.workplaceType,
      baseSalary: baseSalary ?? this.baseSalary,
      seniorityBonus: seniorityBonus ?? this.seniorityBonus,
      totalEarned: totalEarned ?? this.totalEarned,
      penaltyDeductions: penaltyDeductions ?? this.penaltyDeductions,
      gestoraDeduction: gestoraDeduction ?? this.gestoraDeduction,
      totalDeductions: totalDeductions ?? this.totalDeductions,
      netPayable: netPayable ?? this.netPayable,
      bankAccount: bankAccount ?? this.bankAccount,
      hireDate: hireDate ?? this.hireDate,
    );
  }
}

/// Resumen global del período de nómina y estado de cierre contable.
class ElitePayrollPeriodSummary {
  final String period; // "Octubre 2026"
  final double totalBaseSalary;
  final double totalSeniorityBonus;
  final double grossPayroll;
  final double totalPenaltiesDeducted;
  final double totalGestoraContributions;
  final double netPayrollPayable;
  final String status; // "Borrador Pre-Planilla", "Planilla Cerrada y Asentada"
  final String? accountingVoucherNumber;

  const ElitePayrollPeriodSummary({
    required this.period,
    required this.totalBaseSalary,
    required this.totalSeniorityBonus,
    required this.grossPayroll,
    required this.totalPenaltiesDeducted,
    required this.totalGestoraContributions,
    required this.netPayrollPayable,
    this.status = 'Borrador Pre-Planilla',
    this.accountingVoucherNumber,
  });

  bool get isClosed => status == 'Planilla Cerrada y Asentada';

  ElitePayrollPeriodSummary copyWith({
    String? period,
    double? totalBaseSalary,
    double? totalSeniorityBonus,
    double? grossPayroll,
    double? totalPenaltiesDeducted,
    double? totalGestoraContributions,
    double? netPayrollPayable,
    String? status,
    String? accountingVoucherNumber,
  }) {
    return ElitePayrollPeriodSummary(
      period: period ?? this.period,
      totalBaseSalary: totalBaseSalary ?? this.totalBaseSalary,
      totalSeniorityBonus: totalSeniorityBonus ?? this.totalSeniorityBonus,
      grossPayroll: grossPayroll ?? this.grossPayroll,
      totalPenaltiesDeducted:
          totalPenaltiesDeducted ?? this.totalPenaltiesDeducted,
      totalGestoraContributions:
          totalGestoraContributions ?? this.totalGestoraContributions,
      netPayrollPayable: netPayrollPayable ?? this.netPayrollPayable,
      status: status ?? this.status,
      accountingVoucherNumber:
          accountingVoucherNumber ?? this.accountingVoucherNumber,
    );
  }
}

/// Línea de asiento contable de doble partida para el enlace con Finanzas.
class EliteAccountingEntryItem {
  final String accountCode;
  final String accountName;
  final String costCenter;
  final double debit;
  final double credit;

  const EliteAccountingEntryItem({
    required this.accountCode,
    required this.accountName,
    required this.costCenter,
    required this.debit,
    required this.credit,
  });
}

// =============================================================================
// SUBMÓDULO 6: RÉGIMEN DISCIPLINARIO, FINIQUITOS Y AUDITORÍA INMUTABLE
// =============================================================================

/// Gravedad legal y disciplinaria de una infracción.
enum DisciplinarySeverity {
  leve,
  grave,
  muyGrave;

  String get label => switch (this) {
        DisciplinarySeverity.leve => 'Leve',
        DisciplinarySeverity.grave => 'Grave',
        DisciplinarySeverity.muyGrave => 'Muy Grave',
      };

  Color get badgeColor => switch (this) {
        DisciplinarySeverity.leve => const Color(0xFFD97706),
        DisciplinarySeverity.grave => const Color(0xFFEA580C),
        DisciplinarySeverity.muyGrave => const Color(0xFFDC2626),
      };

  Color get badgeBgColor => switch (this) {
        DisciplinarySeverity.leve => const Color(0xFFFFFBEB),
        DisciplinarySeverity.grave => const Color(0xFFFFF7ED),
        DisciplinarySeverity.muyGrave => const Color(0xFFFEF2F2),
      };

  Color get badgeBorderColor => switch (this) {
        DisciplinarySeverity.leve => const Color(0xFFFDE68A),
        DisciplinarySeverity.grave => const Color(0xFFFED7AA),
        DisciplinarySeverity.muyGrave => const Color(0xFFFECACA),
      };
}

/// Motivo de desvinculación laboral según Ley General del Trabajo boliviana.
enum TerminationReason {
  renunciaVoluntaria,
  despidoIntempestivo,
  finDeContrato;

  String get label => switch (this) {
        TerminationReason.renunciaVoluntaria => 'Retiro Voluntario',
        TerminationReason.despidoIntempestivo => 'Despido Intempestivo',
        TerminationReason.finDeContrato => 'Conclusión de Contrato',
      };

  Color get badgeColor => switch (this) {
        TerminationReason.renunciaVoluntaria => const Color(0xFF475569),
        TerminationReason.despidoIntempestivo => const Color(0xFFDC2626),
        TerminationReason.finDeContrato => const Color(0xFF0D9488),
      };

  Color get badgeBgColor => switch (this) {
        TerminationReason.renunciaVoluntaria => const Color(0xFFF1F5F9),
        TerminationReason.despidoIntempestivo => const Color(0xFFFEF2F2),
        TerminationReason.finDeContrato => const Color(0xFFF0FDFA),
      };

  Color get badgeBorderColor => switch (this) {
        TerminationReason.renunciaVoluntaria => const Color(0xFFCBD5E1),
        TerminationReason.despidoIntempestivo => const Color(0xFFFECACA),
        TerminationReason.finDeContrato => const Color(0xFF99F6E4),
      };
}

/// Registro formal de memorándum y sanción disciplinaria.
class EliteDisciplinaryRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final String serviceLineCode;
  final EmployeeWorkplaceType workplaceType;
  final DateTime date;
  final DisciplinarySeverity severity;
  final String infractionType;
  final String description;
  final String memorandumCode;
  final String sanction;

  const EliteDisciplinaryRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.serviceLineCode,
    required this.workplaceType,
    required this.date,
    required this.severity,
    required this.infractionType,
    required this.description,
    required this.memorandumCode,
    required this.sanction,
  });

  EliteDisciplinaryRecord copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? serviceLineCode,
    EmployeeWorkplaceType? workplaceType,
    DateTime? date,
    DisciplinarySeverity? severity,
    String? infractionType,
    String? description,
    String? memorandumCode,
    String? sanction,
  }) {
    return EliteDisciplinaryRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      workplaceType: workplaceType ?? this.workplaceType,
      date: date ?? this.date,
      severity: severity ?? this.severity,
      infractionType: infractionType ?? this.infractionType,
      description: description ?? this.description,
      memorandumCode: memorandumCode ?? this.memorandumCode,
      sanction: sanction ?? this.sanction,
    );
  }
}

/// Liquidación y cálculo de finiquito ministerial de beneficios sociales.
class EliteTerminationSettlement {
  final String id;
  final String employeeId;
  final String employeeName;
  final String ci;
  final String serviceLineCode;
  final String position;
  final DateTime hireDate;
  final DateTime terminationDate;
  final TerminationReason reason;
  final int yearsWorked;
  final int monthsWorked;
  final int daysWorked;
  final double averageSalary;
  final double severancePay; // Desahucio (3 sueldos si es despido)
  final double indemnityPay; // 1 sueldo por año trabajado + duodécimas
  final double proportionalBonus; // Aguinaldo trunco
  final double vacationPay; // Vacaciones no gozadas
  final double totalSettlement; // Total a pagar en Bs
  final String status; // "Borrador", "Aprobado", "Pagado"

  const EliteTerminationSettlement({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.ci,
    required this.serviceLineCode,
    required this.position,
    required this.hireDate,
    required this.terminationDate,
    required this.reason,
    required this.yearsWorked,
    required this.monthsWorked,
    required this.daysWorked,
    required this.averageSalary,
    required this.severancePay,
    required this.indemnityPay,
    required this.proportionalBonus,
    required this.vacationPay,
    required this.totalSettlement,
    this.status = 'Borrador',
  });

  bool get isApproved => status == 'Aprobado';
  bool get isPaid => status == 'Pagado';

  EliteTerminationSettlement copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? ci,
    String? serviceLineCode,
    String? position,
    DateTime? hireDate,
    DateTime? terminationDate,
    TerminationReason? reason,
    int? yearsWorked,
    int? monthsWorked,
    int? daysWorked,
    double? averageSalary,
    double? severancePay,
    double? indemnityPay,
    double? proportionalBonus,
    double? vacationPay,
    double? totalSettlement,
    String? status,
  }) {
    return EliteTerminationSettlement(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      ci: ci ?? this.ci,
      serviceLineCode: serviceLineCode ?? this.serviceLineCode,
      position: position ?? this.position,
      hireDate: hireDate ?? this.hireDate,
      terminationDate: terminationDate ?? this.terminationDate,
      reason: reason ?? this.reason,
      yearsWorked: yearsWorked ?? this.yearsWorked,
      monthsWorked: monthsWorked ?? this.monthsWorked,
      daysWorked: daysWorked ?? this.daysWorked,
      averageSalary: averageSalary ?? this.averageSalary,
      severancePay: severancePay ?? this.severancePay,
      indemnityPay: indemnityPay ?? this.indemnityPay,
      proportionalBonus: proportionalBonus ?? this.proportionalBonus,
      vacationPay: vacationPay ?? this.vacationPay,
      totalSettlement: totalSettlement ?? this.totalSettlement,
      status: status ?? this.status,
    );
  }
}

/// Registro inmutable en la bitácora de auditoría legal de RRHH.
class EliteRrhhAuditLog {
  final String id;
  final DateTime timestamp;
  final String userName;
  final String action;
  final String reference;
  final String detail;
  final String sha256Hash;

  const EliteRrhhAuditLog({
    required this.id,
    required this.timestamp,
    required this.userName,
    required this.action,
    required this.reference,
    required this.detail,
    required this.sha256Hash,
  });

  EliteRrhhAuditLog copyWith({
    String? id,
    DateTime? timestamp,
    String? userName,
    String? action,
    String? reference,
    String? detail,
    String? sha256Hash,
  }) {
    return EliteRrhhAuditLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      action: action ?? this.action,
      reference: reference ?? this.reference,
      detail: detail ?? this.detail,
      sha256Hash: sha256Hash ?? this.sha256Hash,
    );
  }
}
