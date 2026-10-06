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

/// Especialidad operativa y técnica (ej: Jardinería, Limpieza, Seguridad, Climatización).
abstract class RrhhSpecialty implements _i1.SerializableModel {
  RrhhSpecialty._({
    this.id,
    required this.code,
    required this.name,
    this.description,
    this.colorTag,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhSpecialty({
    int? id,
    required String code,
    required String name,
    String? description,
    String? colorTag,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhSpecialtyImpl;

  factory RrhhSpecialty.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhSpecialty(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      colorTag: jsonSerialization['colorTag'] as String?,
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

  /// Código único de especialidad (ej: ESP-JARD, ESP-LIMP, ESP-SEG).
  String code;

  /// Nombre de la especialidad técnica.
  String name;

  /// Descripción detallada del alcance técnico y certificaciones asociadas.
  String? description;

  /// Color identificador (#HEX) para badges y filtros rápidos en planillas y turnos.
  String? colorTag;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhSpecialty]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhSpecialty copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? colorTag,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhSpecialty',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (colorTag != null) 'colorTag': colorTag,
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

class _RrhhSpecialtyImpl extends RrhhSpecialty {
  _RrhhSpecialtyImpl({
    int? id,
    required String code,
    required String name,
    String? description,
    String? colorTag,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         colorTag: colorTag,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhSpecialty]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhSpecialty copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    Object? description = _Undefined,
    Object? colorTag = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhSpecialty(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      colorTag: colorTag is String? ? colorTag : this.colorTag,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
