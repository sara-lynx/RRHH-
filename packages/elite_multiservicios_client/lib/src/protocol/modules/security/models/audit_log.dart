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

/// Registro inmutable de auditoría y bitácora de eventos del sistema.
abstract class AuditLog implements _i1.SerializableModel {
  AuditLog._({
    this.id,
    required this.action,
    this.userId,
    this.userIdentifier,
    this.resource,
    this.ipAddress,
    required this.result,
    this.metadata,
    required this.timestamp,
  });

  factory AuditLog({
    int? id,
    required String action,
    int? userId,
    String? userIdentifier,
    String? resource,
    String? ipAddress,
    required String result,
    String? metadata,
    required DateTime timestamp,
  }) = _AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLog(
      id: jsonSerialization['id'] as int?,
      action: jsonSerialization['action'] as String,
      userId: jsonSerialization['userId'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
      resource: jsonSerialization['resource'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      result: jsonSerialization['result'] as String,
      metadata: jsonSerialization['metadata'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Tipo de acción ejecutada (ej. LOGIN_SUCCESS, USER_CREATED).
  String action;

  /// ID del usuario que realizó la acción (si estaba autenticado).
  int? userId;

  /// Identificador textual del usuario (correo o username).
  String? userIdentifier;

  /// Recurso sobre el que operó (ej. user:#25, role:#3).
  String? resource;

  /// Dirección IP de origen de la solicitud.
  String? ipAddress;

  /// Resultado de la operación (SUCCESS, FAILURE, DENIED).
  String result;

  /// Metadatos adicionales serializados en formato JSON.
  String? metadata;

  /// Momento exacto del evento (UTC).
  DateTime timestamp;

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLog copyWith({
    int? id,
    String? action,
    int? userId,
    String? userIdentifier,
    String? resource,
    String? ipAddress,
    String? result,
    String? metadata,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id,
      'action': action,
      if (userId != null) 'userId': userId,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
      if (resource != null) 'resource': resource,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'result': result,
      if (metadata != null) 'metadata': metadata,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogImpl extends AuditLog {
  _AuditLogImpl({
    int? id,
    required String action,
    int? userId,
    String? userIdentifier,
    String? resource,
    String? ipAddress,
    required String result,
    String? metadata,
    required DateTime timestamp,
  }) : super._(
         id: id,
         action: action,
         userId: userId,
         userIdentifier: userIdentifier,
         resource: resource,
         ipAddress: ipAddress,
         result: result,
         metadata: metadata,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLog copyWith({
    Object? id = _Undefined,
    String? action,
    Object? userId = _Undefined,
    Object? userIdentifier = _Undefined,
    Object? resource = _Undefined,
    Object? ipAddress = _Undefined,
    String? result,
    Object? metadata = _Undefined,
    DateTime? timestamp,
  }) {
    return AuditLog(
      id: id is int? ? id : this.id,
      action: action ?? this.action,
      userId: userId is int? ? userId : this.userId,
      userIdentifier: userIdentifier is String?
          ? userIdentifier
          : this.userIdentifier,
      resource: resource is String? ? resource : this.resource,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      result: result ?? this.result,
      metadata: metadata is String? ? metadata : this.metadata,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
