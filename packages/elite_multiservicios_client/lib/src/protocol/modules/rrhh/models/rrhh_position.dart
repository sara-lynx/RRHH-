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

/// Cargo o Puesto de Trabajo dentro de un Área Organizacional.
abstract class RrhhPosition implements _i1.SerializableModel {
  RrhhPosition._({
    this.id,
    required this.code,
    required this.areaId,
    required this.name,
    required this.workplaceType,
    double? suggestedSalary,
    this.description,
    this.requirements,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : suggestedSalary = suggestedSalary ?? 0.0,
       isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhPosition({
    int? id,
    required String code,
    required int areaId,
    required String name,
    required String workplaceType,
    double? suggestedSalary,
    String? description,
    String? requirements,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhPositionImpl;

  factory RrhhPosition.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhPosition(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      areaId: jsonSerialization['areaId'] as int,
      name: jsonSerialization['name'] as String,
      workplaceType: jsonSerialization['workplaceType'] as String,
      suggestedSalary: (jsonSerialization['suggestedSalary'] as num?)
          ?.toDouble(),
      description: jsonSerialization['description'] as String?,
      requirements: jsonSerialization['requirements'] as String?,
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

  /// Código identificador del puesto (ej: CARGO-JARD, CARGO-EJEC-VENTAS).
  String code;

  /// Área a la que pertenece el cargo.
  int areaId;

  /// Título del cargo (ej: Jardinero, Ejecutivo de Ventas, Guardia de Seguridad).
  String name;

  /// Tipo de entorno laboral principal: 'Oficina' o 'Campo'.
  String workplaceType;

  /// Salario base de referencia sugerido en Bolivianos (Bs.).
  double? suggestedSalary;

  /// Perfil o responsabilidades del puesto.
  String? description;

  /// Requisitos mínimos de contratación o formación requerida.
  String? requirements;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhPosition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhPosition copyWith({
    int? id,
    String? code,
    int? areaId,
    String? name,
    String? workplaceType,
    double? suggestedSalary,
    String? description,
    String? requirements,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhPosition',
      if (id != null) 'id': id,
      'code': code,
      'areaId': areaId,
      'name': name,
      'workplaceType': workplaceType,
      if (suggestedSalary != null) 'suggestedSalary': suggestedSalary,
      if (description != null) 'description': description,
      if (requirements != null) 'requirements': requirements,
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

class _RrhhPositionImpl extends RrhhPosition {
  _RrhhPositionImpl({
    int? id,
    required String code,
    required int areaId,
    required String name,
    required String workplaceType,
    double? suggestedSalary,
    String? description,
    String? requirements,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         areaId: areaId,
         name: name,
         workplaceType: workplaceType,
         suggestedSalary: suggestedSalary,
         description: description,
         requirements: requirements,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhPosition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhPosition copyWith({
    Object? id = _Undefined,
    String? code,
    int? areaId,
    String? name,
    String? workplaceType,
    Object? suggestedSalary = _Undefined,
    Object? description = _Undefined,
    Object? requirements = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhPosition(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
      workplaceType: workplaceType ?? this.workplaceType,
      suggestedSalary: suggestedSalary is double?
          ? suggestedSalary
          : this.suggestedSalary,
      description: description is String? ? description : this.description,
      requirements: requirements is String? ? requirements : this.requirements,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
