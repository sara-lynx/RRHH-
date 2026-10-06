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

/// Permiso granular del sistema.
abstract class AppPermission implements _i1.SerializableModel {
  AppPermission._({
    this.id,
    required this.code,
    required this.module,
    required this.description,
  });

  factory AppPermission({
    int? id,
    required String code,
    required String module,
    required String description,
  }) = _AppPermissionImpl;

  factory AppPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppPermission(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      module: jsonSerialization['module'] as String,
      description: jsonSerialization['description'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Código canónico único del permiso (ej. users.create, audit.view).
  String code;

  /// Módulo al que pertenece el permiso (ej. users, rbac, audit).
  String module;

  /// Descripción de la operación autorizada.
  String description;

  /// Returns a shallow copy of this [AppPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppPermission copyWith({
    int? id,
    String? code,
    String? module,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppPermission',
      if (id != null) 'id': id,
      'code': code,
      'module': module,
      'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppPermissionImpl extends AppPermission {
  _AppPermissionImpl({
    int? id,
    required String code,
    required String module,
    required String description,
  }) : super._(
         id: id,
         code: code,
         module: module,
         description: description,
       );

  /// Returns a shallow copy of this [AppPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppPermission copyWith({
    Object? id = _Undefined,
    String? code,
    String? module,
    String? description,
  }) {
    return AppPermission(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      module: module ?? this.module,
      description: description ?? this.description,
    );
  }
}
