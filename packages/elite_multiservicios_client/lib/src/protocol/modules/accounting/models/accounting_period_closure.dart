/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Registro y control de Cierres de Periodo Contable (Mes / Año) y Bloqueo de Modificaciones.
abstract class AccountingPeriodClosure implements _i1.SerializableModel {
  AccountingPeriodClosure._({
    this.id,
    required this.periodName,
    required this.periodType,
    required this.startDate,
    required this.endDate,
    String? status,
    required this.totalIncome,
    required this.totalExpense,
    required this.netResult,
    this.closedBy,
    required this.closedAt,
    this.closureNotes,
    bool? isLocked,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'CLOSED',
       isLocked = isLocked ?? true;

  factory AccountingPeriodClosure({
    int? id,
    required String periodName,
    required String periodType,
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    required double totalIncome,
    required double totalExpense,
    required double netResult,
    String? closedBy,
    required DateTime closedAt,
    String? closureNotes,
    bool? isLocked,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingPeriodClosureImpl;

  factory AccountingPeriodClosure.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPeriodClosure(
      id: jsonSerialization['id'] as int?,
      periodName: jsonSerialization['periodName'] as String,
      periodType: jsonSerialization['periodType'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String?,
      totalIncome: (jsonSerialization['totalIncome'] as num).toDouble(),
      totalExpense: (jsonSerialization['totalExpense'] as num).toDouble(),
      netResult: (jsonSerialization['netResult'] as num).toDouble(),
      closedBy: jsonSerialization['closedBy'] as String?,
      closedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['closedAt'],
      ),
      closureNotes: jsonSerialization['closureNotes'] as String?,
      isLocked: jsonSerialization['isLocked'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Nombre del periodo (ej. "Septiembre 2026", "Cierre Anual 2025").
  String periodName;

  /// Tipo de periodo: MONTHLY, ANNUAL.
  String periodType;

  /// Fecha de inicio del periodo contable.
  DateTime startDate;

  /// Fecha de fin del periodo contable.
  DateTime endDate;

  /// Estado: CLOSED, AUDITED, REOPENED.
  String status;

  /// Total de ingresos reconocidos en el periodo.
  double totalIncome;

  /// Total de egresos/gastos en el periodo.
  double totalExpense;

  /// Resultado neto del ejercicio (Utilidad o Pérdida).
  double netResult;

  /// Usuario que ejecutó el cierre.
  String? closedBy;

  /// Fecha y hora exacta de ejecución del cierre.
  DateTime closedAt;

  /// Notas u observaciones del cierre.
  String? closureNotes;

  /// Bloqueo activo para impedir crear/editar transacciones en el rango de fechas.
  bool isLocked;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AccountingPeriodClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPeriodClosure copyWith({
    int? id,
    String? periodName,
    String? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalIncome,
    double? totalExpense,
    double? netResult,
    String? closedBy,
    DateTime? closedAt,
    String? closureNotes,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPeriodClosure',
      if (id != null) 'id': id,
      'periodName': periodName,
      'periodType': periodType,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'status': status,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netResult': netResult,
      if (closedBy != null) 'closedBy': closedBy,
      'closedAt': closedAt.toJson(),
      if (closureNotes != null) 'closureNotes': closureNotes,
      'isLocked': isLocked,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPeriodClosureImpl extends AccountingPeriodClosure {
  _AccountingPeriodClosureImpl({
    int? id,
    required String periodName,
    required String periodType,
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    required double totalIncome,
    required double totalExpense,
    required double netResult,
    String? closedBy,
    required DateTime closedAt,
    String? closureNotes,
    bool? isLocked,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         periodName: periodName,
         periodType: periodType,
         startDate: startDate,
         endDate: endDate,
         status: status,
         totalIncome: totalIncome,
         totalExpense: totalExpense,
         netResult: netResult,
         closedBy: closedBy,
         closedAt: closedAt,
         closureNotes: closureNotes,
         isLocked: isLocked,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingPeriodClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPeriodClosure copyWith({
    Object? id = _Undefined,
    String? periodName,
    String? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalIncome,
    double? totalExpense,
    double? netResult,
    Object? closedBy = _Undefined,
    DateTime? closedAt,
    Object? closureNotes = _Undefined,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingPeriodClosure(
      id: id is int? ? id : this.id,
      periodName: periodName ?? this.periodName,
      periodType: periodType ?? this.periodType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netResult: netResult ?? this.netResult,
      closedBy: closedBy is String? ? closedBy : this.closedBy,
      closedAt: closedAt ?? this.closedAt,
      closureNotes: closureNotes is String? ? closureNotes : this.closureNotes,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
