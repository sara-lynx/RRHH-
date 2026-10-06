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
import 'package:elite_multiservicios_client/src/protocol/protocol.dart' as _i2;

/// Catálogo de Horarios y Turnos Operativos / Administrativos de RRHH.
abstract class RrhhSchedule implements _i1.SerializableModel {
  RrhhSchedule._({
    this.id,
    required this.code,
    required this.name,
    String? targetType,
    required this.startTime,
    required this.endTime,
    required this.workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : targetType = targetType ?? 'AMBOS',
       toleranceMinutes = toleranceMinutes ?? 10,
       isNightShift = isNightShift ?? false,
       isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhSchedule({
    int? id,
    required String code,
    required String name,
    String? targetType,
    required String startTime,
    required String endTime,
    required List<int> workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhScheduleImpl;

  factory RrhhSchedule.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhSchedule(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      targetType: jsonSerialization['targetType'] as String?,
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      workDays: _i2.Protocol().deserialize<List<int>>(
        jsonSerialization['workDays'],
      ),
      toleranceMinutes: jsonSerialization['toleranceMinutes'] as int?,
      isNightShift: jsonSerialization['isNightShift'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isNightShift']),
      description: jsonSerialization['description'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
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

  /// Código de turno (ej: SCH-001, SCH-ADM, SCH-OP-MAN).
  String code;

  /// Nombre descriptivo del turno (ej: Administrativo Central, Operativo Mañana).
  String name;

  /// Tipo de entorno al que aplica: 'OFICINA', 'CAMPO', 'AMBOS'.
  String targetType;

  /// Hora de inicio en formato HH:mm (ej: "08:30", "07:00", "22:00").
  String startTime;

  /// Hora de finalización en formato HH:mm (ej: "17:30", "15:00", "06:00").
  String endTime;

  /// Días laborales (1=Lunes, 2=Martes, ..., 7=Domingo).
  List<int> workDays;

  /// Tolerancia de atraso en minutos (ej: 15, 10, 5).
  int toleranceMinutes;

  /// Indica si es turno nocturno para recargos legales.
  bool isNightShift;

  /// Descripción opcional del turno o sede sugerida.
  String? description;

  /// Estado activo del turno en catálogo.
  bool isActive;

  /// Eliminación lógica y auditoría
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhSchedule copyWith({
    int? id,
    String? code,
    String? name,
    String? targetType,
    String? startTime,
    String? endTime,
    List<int>? workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhSchedule',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'targetType': targetType,
      'startTime': startTime,
      'endTime': endTime,
      'workDays': workDays.toJson(),
      'toleranceMinutes': toleranceMinutes,
      'isNightShift': isNightShift,
      if (description != null) 'description': description,
      'isActive': isActive,
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

class _RrhhScheduleImpl extends RrhhSchedule {
  _RrhhScheduleImpl({
    int? id,
    required String code,
    required String name,
    String? targetType,
    required String startTime,
    required String endTime,
    required List<int> workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         name: name,
         targetType: targetType,
         startTime: startTime,
         endTime: endTime,
         workDays: workDays,
         toleranceMinutes: toleranceMinutes,
         isNightShift: isNightShift,
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhSchedule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhSchedule copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? targetType,
    String? startTime,
    String? endTime,
    List<int>? workDays,
    int? toleranceMinutes,
    bool? isNightShift,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhSchedule(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      targetType: targetType ?? this.targetType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workDays: workDays ?? this.workDays.map((e0) => e0).toList(),
      toleranceMinutes: toleranceMinutes ?? this.toleranceMinutes,
      isNightShift: isNightShift ?? this.isNightShift,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
