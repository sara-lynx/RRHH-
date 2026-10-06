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

/// Registro inmutable de desvinculación formal (egreso laboral sin borrado físico).
abstract class RrhhTermination implements _i1.SerializableModel {
  RrhhTermination._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.employeeCi,
    required this.contractType,
    required this.entryDate,
    required this.terminationDate,
    required this.lastWorkingDay,
    required this.reason,
    required this.detailedReason,
    required this.yearsOfService,
    this.severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    this.processedByUserId,
    this.handoverNotes,
    required this.createdAt,
  }) : clearanceCompleted = clearanceCompleted ?? false,
       isEligibleForRehire = isEligibleForRehire ?? true;

  factory RrhhTermination({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String employeeCi,
    required String contractType,
    required DateTime entryDate,
    required DateTime terminationDate,
    required DateTime lastWorkingDay,
    required String reason,
    required String detailedReason,
    required double yearsOfService,
    double? severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
    required DateTime createdAt,
  }) = _RrhhTerminationImpl;

  factory RrhhTermination.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhTermination(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      employeeCi: jsonSerialization['employeeCi'] as String,
      contractType: jsonSerialization['contractType'] as String,
      entryDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['entryDate'],
      ),
      terminationDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['terminationDate'],
      ),
      lastWorkingDay: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastWorkingDay'],
      ),
      reason: jsonSerialization['reason'] as String,
      detailedReason: jsonSerialization['detailedReason'] as String,
      yearsOfService: (jsonSerialization['yearsOfService'] as num).toDouble(),
      severanceAmount: (jsonSerialization['severanceAmount'] as num?)
          ?.toDouble(),
      clearanceCompleted: jsonSerialization['clearanceCompleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['clearanceCompleted'],
            ),
      isEligibleForRehire: jsonSerialization['isEligibleForRehire'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isEligibleForRehire'],
            ),
      processedByUserId: jsonSerialization['processedByUserId'] as int?,
      handoverNotes: jsonSerialization['handoverNotes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Código de desvinculación (ej: DESV-2026-001)
  String code;

  /// Colaborador desvinculado (se mantiene intacto en rrhh_employee como INACTIVO)
  int employeeId;

  String employeeCode;

  String employeeName;

  String employeeCi;

  /// Régimen de contratación y antigüedad
  String contractType;

  DateTime entryDate;

  DateTime terminationDate;

  DateTime lastWorkingDay;

  /// Motivo: 'RENUNCIA_VOLUNTARIA', 'FIN_DE_CONTRATO', 'DESPIDO_JUSTIFICADO', 'DESPIDO_INJUSTIFICADO', 'MUTUO_ACUERDO', 'JUBILACION'
  String reason;

  String detailedReason;

  double yearsOfService;

  /// Liquidación y entrega de activos
  double? severanceAmount;

  bool clearanceCompleted;

  bool isEligibleForRehire;

  /// Auditoría administrativa
  int? processedByUserId;

  String? handoverNotes;

  /// Fecha inmutable de registro
  DateTime createdAt;

  /// Returns a shallow copy of this [RrhhTermination]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhTermination copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? employeeCi,
    String? contractType,
    DateTime? entryDate,
    DateTime? terminationDate,
    DateTime? lastWorkingDay,
    String? reason,
    String? detailedReason,
    double? yearsOfService,
    double? severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhTermination',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'employeeCi': employeeCi,
      'contractType': contractType,
      'entryDate': entryDate.toJson(),
      'terminationDate': terminationDate.toJson(),
      'lastWorkingDay': lastWorkingDay.toJson(),
      'reason': reason,
      'detailedReason': detailedReason,
      'yearsOfService': yearsOfService,
      if (severanceAmount != null) 'severanceAmount': severanceAmount,
      'clearanceCompleted': clearanceCompleted,
      'isEligibleForRehire': isEligibleForRehire,
      if (processedByUserId != null) 'processedByUserId': processedByUserId,
      if (handoverNotes != null) 'handoverNotes': handoverNotes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhTerminationImpl extends RrhhTermination {
  _RrhhTerminationImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String employeeCi,
    required String contractType,
    required DateTime entryDate,
    required DateTime terminationDate,
    required DateTime lastWorkingDay,
    required String reason,
    required String detailedReason,
    required double yearsOfService,
    double? severanceAmount,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         code: code,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         employeeCi: employeeCi,
         contractType: contractType,
         entryDate: entryDate,
         terminationDate: terminationDate,
         lastWorkingDay: lastWorkingDay,
         reason: reason,
         detailedReason: detailedReason,
         yearsOfService: yearsOfService,
         severanceAmount: severanceAmount,
         clearanceCompleted: clearanceCompleted,
         isEligibleForRehire: isEligibleForRehire,
         processedByUserId: processedByUserId,
         handoverNotes: handoverNotes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RrhhTermination]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhTermination copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? employeeCi,
    String? contractType,
    DateTime? entryDate,
    DateTime? terminationDate,
    DateTime? lastWorkingDay,
    String? reason,
    String? detailedReason,
    double? yearsOfService,
    Object? severanceAmount = _Undefined,
    bool? clearanceCompleted,
    bool? isEligibleForRehire,
    Object? processedByUserId = _Undefined,
    Object? handoverNotes = _Undefined,
    DateTime? createdAt,
  }) {
    return RrhhTermination(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      employeeCi: employeeCi ?? this.employeeCi,
      contractType: contractType ?? this.contractType,
      entryDate: entryDate ?? this.entryDate,
      terminationDate: terminationDate ?? this.terminationDate,
      lastWorkingDay: lastWorkingDay ?? this.lastWorkingDay,
      reason: reason ?? this.reason,
      detailedReason: detailedReason ?? this.detailedReason,
      yearsOfService: yearsOfService ?? this.yearsOfService,
      severanceAmount: severanceAmount is double?
          ? severanceAmount
          : this.severanceAmount,
      clearanceCompleted: clearanceCompleted ?? this.clearanceCompleted,
      isEligibleForRehire: isEligibleForRehire ?? this.isEligibleForRehire,
      processedByUserId: processedByUserId is int?
          ? processedByUserId
          : this.processedByUserId,
      handoverNotes: handoverNotes is String?
          ? handoverNotes
          : this.handoverNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
