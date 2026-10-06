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

/// Tabla asociativa entre roles y permisos granulares (relación N:M).
abstract class RolePermission implements _i1.SerializableModel {
  RolePermission._({
    this.id,
    required this.roleId,
    required this.permissionId,
    required this.assignedAt,
  });

  factory RolePermission({
    int? id,
    required int roleId,
    required int permissionId,
    required DateTime assignedAt,
  }) = _RolePermissionImpl;

  factory RolePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RolePermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      permissionId: jsonSerialization['permissionId'] as int,
      assignedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['assignedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// ID del rol.
  int roleId;

  /// ID del permiso granular asignado al rol.
  int permissionId;

  /// Fecha y hora de asignación.
  DateTime assignedAt;

  /// Returns a shallow copy of this [RolePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RolePermission copyWith({
    int? id,
    int? roleId,
    int? permissionId,
    DateTime? assignedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RolePermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      'permissionId': permissionId,
      'assignedAt': assignedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RolePermissionImpl extends RolePermission {
  _RolePermissionImpl({
    int? id,
    required int roleId,
    required int permissionId,
    required DateTime assignedAt,
  }) : super._(
         id: id,
         roleId: roleId,
         permissionId: permissionId,
         assignedAt: assignedAt,
       );

  /// Returns a shallow copy of this [RolePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RolePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    int? permissionId,
    DateTime? assignedAt,
  }) {
    return RolePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }
}
