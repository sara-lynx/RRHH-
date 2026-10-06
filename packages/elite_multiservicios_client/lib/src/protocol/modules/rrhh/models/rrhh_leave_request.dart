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

/// Solicitudes y licencias de personal (médicas, personales, duelo, maternidad/paternidad).
abstract class RrhhLeaveRequest implements _i1.SerializableModel {
  RrhhLeaveRequest._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.hoursCount,
    required this.reason,
    this.medicalCertificateNumber,
    this.attachmentUrl,
    String? status,
    this.resolutionNotes,
    this.resolvedByUserId,
    this.resolvedAt,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'PENDIENTE',
       isDeleted = isDeleted ?? false;

  factory RrhhLeaveRequest({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    double? hoursCount,
    required String reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
    String? status,
    String? resolutionNotes,
    int? resolvedByUserId,
    DateTime? resolvedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhLeaveRequestImpl;

  factory RrhhLeaveRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhLeaveRequest(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      leaveType: jsonSerialization['leaveType'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      daysCount: jsonSerialization['daysCount'] as int,
      hoursCount: (jsonSerialization['hoursCount'] as num?)?.toDouble(),
      reason: jsonSerialization['reason'] as String,
      medicalCertificateNumber:
          jsonSerialization['medicalCertificateNumber'] as String?,
      attachmentUrl: jsonSerialization['attachmentUrl'] as String?,
      status: jsonSerialization['status'] as String?,
      resolutionNotes: jsonSerialization['resolutionNotes'] as String?,
      resolvedByUserId: jsonSerialization['resolvedByUserId'] as int?,
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
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

  /// Código único de solicitud (ej: LIC-2026-001)
  String code;

  /// Colaborador solicitante
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Tipo de licencia: 'MEDICA', 'PERSONAL', 'DUELO', 'MATERNIDAD_PATERNIDAD', 'ESTUDIO', 'OTRO'
  String leaveType;

  /// Fechas de inicio y fin
  DateTime startDate;

  DateTime endDate;

  int daysCount;

  double? hoursCount;

  /// Motivo detallado
  String reason;

  /// Respaldo médico / institucional
  String? medicalCertificateNumber;

  String? attachmentUrl;

  /// Estado: 'PENDIENTE', 'APROBADO', 'RECHAZADO', 'CANCELADO'
  String status;

  /// Resolución y auditoría administrativa
  String? resolutionNotes;

  int? resolvedByUserId;

  DateTime? resolvedAt;

  /// Eliminación lógica y fechas
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhLeaveRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhLeaveRequest copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    double? hoursCount,
    String? reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
    String? status,
    String? resolutionNotes,
    int? resolvedByUserId,
    DateTime? resolvedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhLeaveRequest',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'leaveType': leaveType,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'daysCount': daysCount,
      if (hoursCount != null) 'hoursCount': hoursCount,
      'reason': reason,
      if (medicalCertificateNumber != null)
        'medicalCertificateNumber': medicalCertificateNumber,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      'status': status,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (resolvedByUserId != null) 'resolvedByUserId': resolvedByUserId,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
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

class _RrhhLeaveRequestImpl extends RrhhLeaveRequest {
  _RrhhLeaveRequestImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    double? hoursCount,
    required String reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
    String? status,
    String? resolutionNotes,
    int? resolvedByUserId,
    DateTime? resolvedAt,
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
         leaveType: leaveType,
         startDate: startDate,
         endDate: endDate,
         daysCount: daysCount,
         hoursCount: hoursCount,
         reason: reason,
         medicalCertificateNumber: medicalCertificateNumber,
         attachmentUrl: attachmentUrl,
         status: status,
         resolutionNotes: resolutionNotes,
         resolvedByUserId: resolvedByUserId,
         resolvedAt: resolvedAt,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhLeaveRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhLeaveRequest copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    Object? hoursCount = _Undefined,
    String? reason,
    Object? medicalCertificateNumber = _Undefined,
    Object? attachmentUrl = _Undefined,
    String? status,
    Object? resolutionNotes = _Undefined,
    Object? resolvedByUserId = _Undefined,
    Object? resolvedAt = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhLeaveRequest(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
      hoursCount: hoursCount is double? ? hoursCount : this.hoursCount,
      reason: reason ?? this.reason,
      medicalCertificateNumber: medicalCertificateNumber is String?
          ? medicalCertificateNumber
          : this.medicalCertificateNumber,
      attachmentUrl: attachmentUrl is String?
          ? attachmentUrl
          : this.attachmentUrl,
      status: status ?? this.status,
      resolutionNotes: resolutionNotes is String?
          ? resolutionNotes
          : this.resolutionNotes,
      resolvedByUserId: resolvedByUserId is int?
          ? resolvedByUserId
          : this.resolvedByUserId,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
