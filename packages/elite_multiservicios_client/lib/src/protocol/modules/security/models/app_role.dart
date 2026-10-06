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

/// Rol de usuario para control de acceso (RBAC).
abstract class AppRole implements _i1.SerializableModel {
  AppRole._({
    this.id,
    required this.name,
    required this.description,
    required this.isSystemRole,
    required this.createdAt,
  });

  factory AppRole({
    int? id,
    required String name,
    required String description,
    required bool isSystemRole,
    required DateTime createdAt,
  }) = _AppRoleImpl;

  factory AppRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppRole(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      isSystemRole: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isSystemRole'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Nombre identificador del rol (ej. Administrador, Supervisor).
  String name;

  /// Descripción funcional de las responsabilidades del rol.
  String description;

  /// Indica si es un rol de sistema protegido contra edición o eliminación.
  bool isSystemRole;

  /// Fecha de registro.
  DateTime createdAt;

  /// Returns a shallow copy of this [AppRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppRole copyWith({
    int? id,
    String? name,
    String? description,
    bool? isSystemRole,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppRole',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'isSystemRole': isSystemRole,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppRoleImpl extends AppRole {
  _AppRoleImpl({
    int? id,
    required String name,
    required String description,
    required bool isSystemRole,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         isSystemRole: isSystemRole,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppRole copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    bool? isSystemRole,
    DateTime? createdAt,
  }) {
    return AppRole(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isSystemRole: isSystemRole ?? this.isSystemRole,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
