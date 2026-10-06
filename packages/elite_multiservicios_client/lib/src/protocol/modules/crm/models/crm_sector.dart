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

/// Sector o Rubro industrial objetivo de clientes corporativos.
abstract class CrmSector implements _i1.SerializableModel {
  CrmSector._({
    this.id,
    required this.code,
    required this.name,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmSector({
    int? id,
    required String code,
    required String name,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmSectorImpl;

  factory CrmSector.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmSector(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
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

  /// Código único identificador (ej: SEC-SALUD, SEC-CORP, SEC-COND).
  String code;

  /// Nombre del rubro (ej: Clínicas y centros médicos).
  String name;

  /// Descripción detallada del perfil industrial.
  String? description;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmSector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmSector copyWith({
    int? id,
    String? code,
    String? name,
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
      '__className__': 'CrmSector',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
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

class _CrmSectorImpl extends CrmSector {
  _CrmSectorImpl({
    int? id,
    required String code,
    required String name,
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
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmSector]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmSector copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmSector(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
