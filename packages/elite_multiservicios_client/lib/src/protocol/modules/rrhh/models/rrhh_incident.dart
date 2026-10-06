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

/// Régimen disciplinario, incidentes y reconocimientos en el expediente del trabajador.
abstract class RrhhIncident implements _i1.SerializableModel {
  RrhhIncident._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.incidentType,
    required this.severity,
    required this.incidentDate,
    required this.title,
    required this.description,
    required this.actionTaken,
    bool? isJustified,
    this.recordedByUserId,
    this.documentReferenceUrl,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isJustified = isJustified ?? false,
       isDeleted = isDeleted ?? false;

  factory RrhhIncident({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String incidentType,
    required String severity,
    required DateTime incidentDate,
    required String title,
    required String description,
    required String actionTaken,
    bool? isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhIncidentImpl;

  factory RrhhIncident.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhIncident(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      incidentType: jsonSerialization['incidentType'] as String,
      severity: jsonSerialization['severity'] as String,
      incidentDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['incidentDate'],
      ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      actionTaken: jsonSerialization['actionTaken'] as String,
      isJustified: jsonSerialization['isJustified'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isJustified']),
      recordedByUserId: jsonSerialization['recordedByUserId'] as int?,
      documentReferenceUrl:
          jsonSerialization['documentReferenceUrl'] as String?,
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

  /// Código de incidente (ej: INC-2026-001)
  String code;

  /// Colaborador afectado / reconocido
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Tipo: 'FALTA_INJUSTIFICADA', 'ATRASO_REITERADO', 'LLAMADO_ATENCION_LEVE', 'MEMORANDUM_GRAVE', 'SUSPENSION_TEMPORAL', 'FELICITACION', 'RECONOCIMIENTO'
  String incidentType;

  /// Severidad: 'POSITIVA', 'LEVE', 'MODERADA', 'GRAVE'
  String severity;

  /// Fecha del suceso
  DateTime incidentDate;

  /// Título y descripción
  String title;

  String description;

  /// Medida correctiva / efecto laboral
  String actionTaken;

  bool isJustified;

  /// Auditoría
  int? recordedByUserId;

  String? documentReferenceUrl;

  /// Eliminación lógica y fechas
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhIncident]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhIncident copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? incidentType,
    String? severity,
    DateTime? incidentDate,
    String? title,
    String? description,
    String? actionTaken,
    bool? isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhIncident',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'incidentType': incidentType,
      'severity': severity,
      'incidentDate': incidentDate.toJson(),
      'title': title,
      'description': description,
      'actionTaken': actionTaken,
      'isJustified': isJustified,
      if (recordedByUserId != null) 'recordedByUserId': recordedByUserId,
      if (documentReferenceUrl != null)
        'documentReferenceUrl': documentReferenceUrl,
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

class _RrhhIncidentImpl extends RrhhIncident {
  _RrhhIncidentImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String incidentType,
    required String severity,
    required DateTime incidentDate,
    required String title,
    required String description,
    required String actionTaken,
    bool? isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
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
         incidentType: incidentType,
         severity: severity,
         incidentDate: incidentDate,
         title: title,
         description: description,
         actionTaken: actionTaken,
         isJustified: isJustified,
         recordedByUserId: recordedByUserId,
         documentReferenceUrl: documentReferenceUrl,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhIncident]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhIncident copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? incidentType,
    String? severity,
    DateTime? incidentDate,
    String? title,
    String? description,
    String? actionTaken,
    bool? isJustified,
    Object? recordedByUserId = _Undefined,
    Object? documentReferenceUrl = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhIncident(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      incidentType: incidentType ?? this.incidentType,
      severity: severity ?? this.severity,
      incidentDate: incidentDate ?? this.incidentDate,
      title: title ?? this.title,
      description: description ?? this.description,
      actionTaken: actionTaken ?? this.actionTaken,
      isJustified: isJustified ?? this.isJustified,
      recordedByUserId: recordedByUserId is int?
          ? recordedByUserId
          : this.recordedByUserId,
      documentReferenceUrl: documentReferenceUrl is String?
          ? documentReferenceUrl
          : this.documentReferenceUrl,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
