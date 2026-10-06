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

/// Bitácora inmutable de cambios y movimientos de personal.
abstract class RrhhMovementHistory implements _i1.SerializableModel {
  RrhhMovementHistory._({
    this.id,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.movementType,
    this.previousValue,
    required this.newValue,
    required this.effectiveDate,
    required this.reason,
    required this.authorizedBy,
    required this.createdAt,
  });

  factory RrhhMovementHistory({
    int? id,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
    required DateTime createdAt,
  }) = _RrhhMovementHistoryImpl;

  factory RrhhMovementHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhMovementHistory(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      movementType: jsonSerialization['movementType'] as String,
      previousValue: jsonSerialization['previousValue'] as String?,
      newValue: jsonSerialization['newValue'] as String,
      effectiveDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['effectiveDate'],
      ),
      reason: jsonSerialization['reason'] as String,
      authorizedBy: jsonSerialization['authorizedBy'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Colaborador afectado
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Tipo: 'INGRESO', 'ASCENSO', 'TRASLADO_AREA', 'ROTACION_SEDE', 'AJUSTE_SALARIAL', 'CAMBIO_TURNO', 'SUSPENSION', 'DESVINCULACION', 'REINCORPORACION'
  String movementType;

  /// Valores previos y nuevos
  String? previousValue;

  String newValue;

  /// Fecha efectiva y justificación
  DateTime effectiveDate;

  String reason;

  String authorizedBy;

  /// Auditoría inmutable
  DateTime createdAt;

  /// Returns a shallow copy of this [RrhhMovementHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhMovementHistory copyWith({
    int? id,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? movementType,
    String? previousValue,
    String? newValue,
    DateTime? effectiveDate,
    String? reason,
    String? authorizedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhMovementHistory',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'movementType': movementType,
      if (previousValue != null) 'previousValue': previousValue,
      'newValue': newValue,
      'effectiveDate': effectiveDate.toJson(),
      'reason': reason,
      'authorizedBy': authorizedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhMovementHistoryImpl extends RrhhMovementHistory {
  _RrhhMovementHistoryImpl({
    int? id,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         movementType: movementType,
         previousValue: previousValue,
         newValue: newValue,
         effectiveDate: effectiveDate,
         reason: reason,
         authorizedBy: authorizedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RrhhMovementHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhMovementHistory copyWith({
    Object? id = _Undefined,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? movementType,
    Object? previousValue = _Undefined,
    String? newValue,
    DateTime? effectiveDate,
    String? reason,
    String? authorizedBy,
    DateTime? createdAt,
  }) {
    return RrhhMovementHistory(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      movementType: movementType ?? this.movementType,
      previousValue: previousValue is String?
          ? previousValue
          : this.previousValue,
      newValue: newValue ?? this.newValue,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      reason: reason ?? this.reason,
      authorizedBy: authorizedBy ?? this.authorizedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
