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

/// Tabla asociativa entre usuarios y roles (relación N:M).
abstract class UserRole implements _i1.SerializableModel {
  UserRole._({
    this.id,
    required this.userId,
    required this.roleId,
    required this.assignedAt,
  });

  factory UserRole({
    int? id,
    required int userId,
    required int roleId,
    required DateTime assignedAt,
  }) = _UserRoleImpl;

  factory UserRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRole(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      roleId: jsonSerialization['roleId'] as int,
      assignedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['assignedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// ID del usuario asignado.
  int userId;

  /// ID del rol asignado.
  int roleId;

  /// Fecha y hora de asignación.
  DateTime assignedAt;

  /// Returns a shallow copy of this [UserRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRole copyWith({
    int? id,
    int? userId,
    int? roleId,
    DateTime? assignedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserRole',
      if (id != null) 'id': id,
      'userId': userId,
      'roleId': roleId,
      'assignedAt': assignedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRoleImpl extends UserRole {
  _UserRoleImpl({
    int? id,
    required int userId,
    required int roleId,
    required DateTime assignedAt,
  }) : super._(
         id: id,
         userId: userId,
         roleId: roleId,
         assignedAt: assignedAt,
       );

  /// Returns a shallow copy of this [UserRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRole copyWith({
    Object? id = _Undefined,
    int? userId,
    int? roleId,
    DateTime? assignedAt,
  }) {
    return UserRole(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }
}
