/// Entidades para el Cierre de Novedades para Nómina (Pantalla 12 — Bloque 4).
///
/// Modela el ciclo mensual de consolidación y handoff con Contabilidad:
/// - [RrhhPayrollPeriod]: Período mensual ('abierto', 'cerrado', 'enviado', 'procesado').
/// - [RrhhPayrollItem]: Registro individual de novedad laboral que impacta o documenta la nómina.
class RrhhPayrollPeriod {
  final int id;
  final String code; // 'NOM-2026-09' (año-mes)
  final int year;
  final int month; // 1-12
  final String status; // 'abierto' | 'cerrado' | 'enviado' | 'procesado'
  final DateTime? closedAt;
  final String? closedBy;
  final DateTime? sentAt;
  final String? sentBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RrhhPayrollPeriod({
    required this.id,
    required this.code,
    required this.year,
    required this.month,
    required this.status,
    this.closedAt,
    this.closedBy,
    this.sentAt,
    this.sentBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOpen => status == RrhhPayrollPeriodStatus.abierto;
  bool get isClosed => status == RrhhPayrollPeriodStatus.cerrado;
  bool get isSent => status == RrhhPayrollPeriodStatus.enviado;
  bool get isProcessed => status == RrhhPayrollPeriodStatus.procesado;

  String get monthName {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return 'Mes $month';
  }

  String get displayName => '$monthName $year';

  RrhhPayrollPeriod copyWith({
    int? id,
    String? code,
    int? year,
    int? month,
    String? status,
    DateTime? closedAt,
    String? closedBy,
    DateTime? sentAt,
    String? sentBy,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhPayrollPeriod(
      id: id ?? this.id,
      code: code ?? this.code,
      year: year ?? this.year,
      month: month ?? this.month,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      sentAt: sentAt ?? this.sentAt,
      sentBy: sentBy ?? this.sentBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'year': year,
      'month': month,
      'status': status,
      'closedAt': closedAt?.toIso8601String(),
      'closedBy': closedBy,
      'sentAt': sentAt?.toIso8601String(),
      'sentBy': sentBy,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RrhhPayrollPeriod.fromJson(Map<String, dynamic> json) {
    return RrhhPayrollPeriod(
      id: json['id'] as int,
      code: json['code'] as String,
      year: json['year'] as int,
      month: json['month'] as int,
      status: json['status'] as String,
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'] as String)
          : null,
      closedBy: json['closedBy'] as String?,
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
      sentBy: json['sentBy'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Estados estándar para un período mensual de nómina.
abstract class RrhhPayrollPeriodStatus {
  static const String abierto = 'abierto';
  static const String cerrado = 'cerrado';
  static const String enviado = 'enviado';
  static const String procesado = 'procesado';

  static const List<String> all = [abierto, cerrado, enviado, procesado];

  static String label(String status) {
    switch (status.toLowerCase()) {
      case abierto:
        return 'Abierto';
      case cerrado:
        return 'Cerrado';
      case enviado:
        return 'Enviado';
      case procesado:
        return 'Procesado';
      default:
        return status.toUpperCase();
    }
  }
}

/// Novedad individual en el período mensual.
class RrhhPayrollItem {
  final int id;
  final int periodId;
  final int employeeId;
  final String employeeCode;
  final String employeeName;
  final String
  sourceType; // 'permiso' | 'vacacion' | 'incidencia' | 'desvinculacion'
  final int sourceId; // referencia al registro original
  final String sourceCode; // PERM-XXX, VAC-XXX, INC-XXX, BAJA-XXX
  final DateTime effectiveDate;
  final String description;
  final String impactType; // 'descuento' | 'pago_extra' | 'sin_impacto'
  final double? impactAmount; // monto en Bs. (positivo o negativo)
  final String? notes;

  const RrhhPayrollItem({
    required this.id,
    required this.periodId,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.sourceType,
    required this.sourceId,
    required this.sourceCode,
    required this.effectiveDate,
    required this.description,
    required this.impactType,
    this.impactAmount,
    this.notes,
  });

  bool get isDeduction => impactType == RrhhPayrollImpactType.descuento;
  bool get isExtraPayment => impactType == RrhhPayrollImpactType.pagoExtra;
  bool get isNoImpact => impactType == RrhhPayrollImpactType.sinImpacto;

  RrhhPayrollItem copyWith({
    int? id,
    int? periodId,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? sourceType,
    int? sourceId,
    String? sourceCode,
    DateTime? effectiveDate,
    String? description,
    String? impactType,
    double? impactAmount,
    String? notes,
  }) {
    return RrhhPayrollItem(
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      sourceCode: sourceCode ?? this.sourceCode,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      description: description ?? this.description,
      impactType: impactType ?? this.impactType,
      impactAmount: impactAmount ?? this.impactAmount,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'periodId': periodId,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'sourceCode': sourceCode,
      'effectiveDate': effectiveDate.toIso8601String(),
      'description': description,
      'impactType': impactType,
      'impactAmount': impactAmount,
      'notes': notes,
    };
  }

  factory RrhhPayrollItem.fromJson(Map<String, dynamic> json) {
    return RrhhPayrollItem(
      id: json['id'] as int,
      periodId: json['periodId'] as int,
      employeeId: json['employeeId'] as int,
      employeeCode: json['employeeCode'] as String,
      employeeName: json['employeeName'] as String,
      sourceType: json['sourceType'] as String,
      sourceId: json['sourceId'] as int,
      sourceCode: json['sourceCode'] as String,
      effectiveDate: DateTime.parse(json['effectiveDate'] as String),
      description: json['description'] as String,
      impactType: json['impactType'] as String,
      impactAmount: json['impactAmount'] != null
          ? (json['impactAmount'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
    );
  }
}

/// Tipos de fuente u origen de la novedad laboral.
abstract class RrhhPayrollSourceType {
  static const String permiso = 'permiso';
  static const String vacacion = 'vacacion';
  static const String incidencia = 'incidencia';
  static const String desvinculacion = 'desvinculacion';

  static const List<String> all = [
    permiso,
    vacacion,
    incidencia,
    desvinculacion,
  ];

  static String label(String type) {
    switch (type.toLowerCase()) {
      case permiso:
        return 'Permiso / Licencia';
      case vacacion:
        return 'Vacaciones';
      case incidencia:
        return 'Incidencia / Disciplina';
      case desvinculacion:
        return 'Desvinculación / Baja';
      default:
        return type.toUpperCase();
    }
  }
}

/// Tipos de impacto económico en nómina.
abstract class RrhhPayrollImpactType {
  static const String descuento = 'descuento';
  static const String pagoExtra = 'pago_extra';
  static const String sinImpacto = 'sin_impacto';

  static const List<String> all = [descuento, pagoExtra, sinImpacto];

  static String label(String type) {
    switch (type.toLowerCase()) {
      case descuento:
        return 'Descuento';
      case pagoExtra:
        return 'Pago Extra / Finiquito';
      case sinImpacto:
        return 'Sin Impacto Económico';
      default:
        return type.toUpperCase();
    }
  }
}
