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

/// Control y registro de vacaciones del colaborador conforme a Ley Laboral.
abstract class RrhhVacation implements _i1.SerializableModel {
  RrhhVacation._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.periodYear,
    required this.startDate,
    required this.endDate,
    required this.daysRequested,
    required this.totalAccruedDays,
    required this.remainingBalanceDays,
    String? status,
    this.approvedByUserId,
    this.approvedAt,
    this.notes,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'SOLICITADA',
       isDeleted = isDeleted ?? false;

  factory RrhhVacation({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    required int totalAccruedDays,
    required int remainingBalanceDays,
    String? status,
    int? approvedByUserId,
    DateTime? approvedAt,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhVacationImpl;

  factory RrhhVacation.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhVacation(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      periodYear: jsonSerialization['periodYear'] as int,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      daysRequested: jsonSerialization['daysRequested'] as int,
      totalAccruedDays: jsonSerialization['totalAccruedDays'] as int,
      remainingBalanceDays: jsonSerialization['remainingBalanceDays'] as int,
      status: jsonSerialization['status'] as String?,
      approvedByUserId: jsonSerialization['approvedByUserId'] as int?,
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      notes: jsonSerialization['notes'] as String?,
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
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

  /// Código de solicitud de vacación (ej: VAC-2026-001)
  String code;

  /// Colaborador solicitante
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Período y vigencia
  int periodYear;

  DateTime startDate;

  DateTime endDate;

  int daysRequested;

  /// Saldo computado a la fecha de solicitud
  int totalAccruedDays;

  int remainingBalanceDays;

  /// Estado: 'SOLICITADA', 'APROBADA', 'EN_CURSO', 'COMPLETADA', 'RECHAZADA'
  String status;

  /// Aprobación
  int? approvedByUserId;

  DateTime? approvedAt;

  String? notes;

  /// Eliminación lógica y fechas
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhVacation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhVacation copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    int? periodYear,
    DateTime? startDate,
    DateTime? endDate,
    int? daysRequested,
    int? totalAccruedDays,
    int? remainingBalanceDays,
    String? status,
    int? approvedByUserId,
    DateTime? approvedAt,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhVacation',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'periodYear': periodYear,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'daysRequested': daysRequested,
      'totalAccruedDays': totalAccruedDays,
      'remainingBalanceDays': remainingBalanceDays,
      'status': status,
      if (approvedByUserId != null) 'approvedByUserId': approvedByUserId,
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
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

class _RrhhVacationImpl extends RrhhVacation {
  _RrhhVacationImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    required int totalAccruedDays,
    required int remainingBalanceDays,
    String? status,
    int? approvedByUserId,
    DateTime? approvedAt,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         periodYear: periodYear,
         startDate: startDate,
         endDate: endDate,
         daysRequested: daysRequested,
         totalAccruedDays: totalAccruedDays,
         remainingBalanceDays: remainingBalanceDays,
         status: status,
         approvedByUserId: approvedByUserId,
         approvedAt: approvedAt,
         notes: notes,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhVacation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhVacation copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    int? periodYear,
    DateTime? startDate,
    DateTime? endDate,
    int? daysRequested,
    int? totalAccruedDays,
    int? remainingBalanceDays,
    String? status,
    Object? approvedByUserId = _Undefined,
    Object? approvedAt = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhVacation(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      periodYear: periodYear ?? this.periodYear,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysRequested: daysRequested ?? this.daysRequested,
      totalAccruedDays: totalAccruedDays ?? this.totalAccruedDays,
      remainingBalanceDays: remainingBalanceDays ?? this.remainingBalanceDays,
      status: status ?? this.status,
      approvedByUserId: approvedByUserId is int?
          ? approvedByUserId
          : this.approvedByUserId,
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
