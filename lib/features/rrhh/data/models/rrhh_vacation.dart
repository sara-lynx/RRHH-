/// Modelo oficial de Control de Vacaciones (Ley General del Trabajo - Bolivia).
/// Incluye RrhhVacationRecord (goce programado o ejecutado), RrhhVacationBalance (saldo calculado)
/// y RrhhVacationCalculator con las reglas de escala legal y cómputo de goces.
library;

class RrhhVacationRecordStatus {
  static const String programado = 'programado';
  static const String enCurso = 'en_curso';
  static const String gozado = 'gozado';
  static const String cancelado = 'cancelado';

  static const List<String> all = [programado, enCurso, gozado, cancelado];

  static String getLabel(String status) {
    switch (status.toLowerCase()) {
      case programado:
        return 'Programado';
      case enCurso:
        return 'En curso';
      case gozado:
        return 'Gozado';
      case cancelado:
        return 'Cancelado';
      default:
        return status;
    }
  }
}

class RrhhVacationBalanceStatus {
  static const String disponible = 'disponible';
  static const String parcial = 'parcial';
  static const String agotado = 'agotado';
  static const String vencido = 'vencido';
  static const String sinDerecho = 'sin_derecho';

  static const List<String> all = [
    disponible,
    parcial,
    agotado,
    vencido,
    sinDerecho,
  ];

  static String getLabel(String status) {
    switch (status.toLowerCase()) {
      case disponible:
        return 'Disponible';
      case parcial:
        return 'Parcial (próx. a vencer)';
      case agotado:
        return 'Agotado';
      case vencido:
        return 'Vencido sin usar';
      case sinDerecho:
        return 'Sin derecho todavía';
      default:
        return status;
    }
  }
}

/// Registro individual de un período de goce de vacaciones.
class RrhhVacationRecord {
  final int id;
  final String code; // 'VAC-001', 'VAC-002', ...
  final int employeeId;
  final String employeeCode; // 'EMP-XXX' (snapshot)
  final String employeeName; // (snapshot)
  final DateTime startDate; // fecha inicio del goce
  final DateTime endDate; // fecha fin del goce
  final int daysCounted; // días (hábiles o calendario)
  final String countingMode; // 'habiles' | 'calendario'
  final String status; // 'programado' | 'en_curso' | 'gozado' | 'cancelado'
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const RrhhVacationRecord({
    required this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.daysCounted,
    required this.countingMode,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  RrhhVacationRecord copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCounted,
    String? countingMode,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return RrhhVacationRecord(
      id: id ?? this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCounted: daysCounted ?? this.daysCounted,
      countingMode: countingMode ?? this.countingMode,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  factory RrhhVacationRecord.fromJson(Map<String, dynamic> json) {
    return RrhhVacationRecord(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      employeeId: json['employeeId'] as int? ?? 0,
      employeeCode: json['employeeCode'] as String? ?? '',
      employeeName: json['employeeName'] as String? ?? '',
      startDate:
          DateTime.tryParse(json['startDate'] as String? ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(json['endDate'] as String? ?? '') ?? DateTime.now(),
      daysCounted: json['daysCounted'] as int? ?? 0,
      countingMode: json['countingMode'] as String? ?? 'habiles',
      status: json['status'] as String? ?? RrhhVacationRecordStatus.programado,
      notes: json['notes'] as String?,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      createdBy: json['createdBy'] as String? ?? 'Sistema RRHH',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'daysCounted': daysCounted,
      'countingMode': countingMode,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}

/// Saldo consolidado de vacaciones por empleado (calculado dinámicamente).
class RrhhVacationBalance {
  final int employeeId;
  final String employeeCode;
  final String employeeName;
  final String? position;
  final String? area;
  final DateTime hireDate;
  final Duration antiquity; // antigüedad calculada
  final int assignedDays; // días asignados según antigüedad legal boliviana
  final int usedDays; // días gozados en el período actual
  final int pendingDays; // assignedDays - usedDays
  final String
  balanceStatus; // 'disponible' | 'parcial' | 'agotado' | 'vencido' | 'sin_derecho'
  final DateTime? nextAnniversary; // próximo aniversario laboral
  final int? daysUntilAnniversary;

  const RrhhVacationBalance({
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    this.position,
    this.area,
    required this.hireDate,
    required this.antiquity,
    required this.assignedDays,
    required this.usedDays,
    required this.pendingDays,
    required this.balanceStatus,
    this.nextAnniversary,
    this.daysUntilAnniversary,
  });

  /// Antigüedad legible: "3 años, 4 meses" o "8 meses"
  String get formattedAntiquity =>
      RrhhVacationCalculator.formatAntiquity(hireDate, DateTime.now());

  /// Porcentaje de uso del saldo (para barras de progreso visual)
  double get usageRatio {
    if (assignedDays == 0) return 0.0;
    final r = usedDays / assignedDays;
    return r.clamp(0.0, 1.0);
  }

  /// Porcentaje pendiente
  double get pendingRatio {
    if (assignedDays == 0) return 0.0;
    final r = pendingDays / assignedDays;
    return r.clamp(0.0, 1.0);
  }
}

/// Motor de cómputo para la escala legal y saldos de vacaciones en Bolivia.
class RrhhVacationCalculator {
  /// Retorna los años completos cumplidos de servicio continuo
  static int getCompletedYears(DateTime hireDate, DateTime asOf) {
    int years = asOf.year - hireDate.year;
    if (asOf.month < hireDate.month ||
        (asOf.month == hireDate.month && asOf.day < hireDate.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  /// Retorna los meses restantes después de los años completos
  static int getRemainingMonths(DateTime hireDate, DateTime asOf) {
    int months = asOf.month - hireDate.month;
    if (asOf.day < hireDate.day) {
      months--;
    }
    if (months < 0) {
      months += 12;
    }
    return months;
  }

  /// Escala oficial de vacaciones de la Ley General del Trabajo (Bolivia):
  /// - 1 a 5 años: 15 días hábiles
  /// - 5 a 10 años: 20 días hábiles
  /// - 10+ años: 30 días hábiles
  /// - < 1 año: 0 días (Sin derecho todavía)
  static int getAssignedDays(DateTime hireDate, [DateTime? asOf]) {
    final ref = asOf ?? DateTime.now();
    final years = getCompletedYears(hireDate, ref);

    if (years < 1) return 0;
    if (years < 5) return 15;
    if (years < 10) return 20;
    return 30;
  }

  /// Formatea la antigüedad en lenguaje natural
  static String formatAntiquity(DateTime hireDate, [DateTime? asOf]) {
    final ref = asOf ?? DateTime.now();
    final years = getCompletedYears(hireDate, ref);
    final months = getRemainingMonths(hireDate, ref);

    if (years == 0) {
      if (months == 0) return 'Menos de 1 mes';
      return '$months ${months == 1 ? "mes" : "meses"}';
    }

    final yearStr = '$years ${years == 1 ? "año" : "años"}';
    if (months == 0) return yearStr;
    return '$yearStr, $months ${months == 1 ? "mes" : "meses"}';
  }

  /// Calcula la fecha del próximo aniversario laboral
  static DateTime getNextAnniversary(DateTime hireDate, [DateTime? asOf]) {
    final ref = asOf ?? DateTime.now();
    var anniv = DateTime(ref.year, hireDate.month, hireDate.day);
    if (anniv.isBefore(ref)) {
      anniv = DateTime(ref.year + 1, hireDate.month, hireDate.day);
    }
    return anniv;
  }

  /// Cómputo de días según modo de cálculo ('habiles' o 'calendario')
  static int calculateDays(DateTime start, DateTime end, String mode) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    if (e.isBefore(s)) return 0;

    if (mode.toLowerCase() == 'calendario') {
      return e.difference(s).inDays + 1;
    }

    // Modo hábiles: Lunes (1) a Viernes (5)
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

  /// Alias conveniente para [calculateDays]
  static int countDays(
    DateTime start,
    DateTime end, {
    String countingMode = 'habiles',
  }) {
    return calculateDays(start, end, countingMode);
  }
}
