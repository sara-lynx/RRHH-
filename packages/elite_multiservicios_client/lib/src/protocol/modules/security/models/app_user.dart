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

/// Entidad de usuario empresarial del sistema.
abstract class AppUser implements _i1.SerializableModel {
  AppUser._({
    this.id,
    required this.email,
    required this.fullName,
    this.userInfoId,
    required this.isActive,
    required this.isDeleted,
    bool? mustChangePassword,
    int? failedLoginAttempts,
    this.lastFailedLoginAt,
    this.lockedUntil,
    bool? mfaEnabled,
    required this.createdAt,
    required this.updatedAt,
  }) : mustChangePassword = mustChangePassword ?? true,
       failedLoginAttempts = failedLoginAttempts ?? 0,
       mfaEnabled = mfaEnabled ?? false;

  factory AppUser({
    int? id,
    required String email,
    required String fullName,
    int? userInfoId,
    required bool isActive,
    required bool isDeleted,
    bool? mustChangePassword,
    int? failedLoginAttempts,
    DateTime? lastFailedLoginAt,
    DateTime? lockedUntil,
    bool? mfaEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      fullName: jsonSerialization['fullName'] as String,
      userInfoId: jsonSerialization['userInfoId'] as int?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      isDeleted: _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      mustChangePassword: jsonSerialization['mustChangePassword'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['mustChangePassword'],
            ),
      failedLoginAttempts: jsonSerialization['failedLoginAttempts'] as int?,
      lastFailedLoginAt: jsonSerialization['lastFailedLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastFailedLoginAt'],
            ),
      lockedUntil: jsonSerialization['lockedUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lockedUntil'],
            ),
      mfaEnabled: jsonSerialization['mfaEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['mfaEnabled']),
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

  /// Correo electrónico corporativo único.
  String email;

  /// Nombre completo del usuario.
  String fullName;

  /// ID vinculado al subsistema de autenticación de Serverpod.
  int? userInfoId;

  /// Estado de activación de la cuenta.
  bool isActive;

  /// Indicador de eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Indicador de cambio obligatorio de contraseña temporal.
  bool mustChangePassword;

  /// Número de intentos fallidos consecutivos de inicio de sesión.
  int failedLoginAttempts;

  /// Fecha y hora del último intento fallido de inicio de sesión.
  DateTime? lastFailedLoginAt;

  /// Fecha y hora hasta la cual la cuenta permanece bloqueada.
  DateTime? lockedUntil;

  /// Indicador de autenticación multifactor (MFA) activada.
  bool mfaEnabled;

  /// Fecha de creación del registro.
  DateTime createdAt;

  /// Fecha de última actualización.
  DateTime updatedAt;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    int? id,
    String? email,
    String? fullName,
    int? userInfoId,
    bool? isActive,
    bool? isDeleted,
    bool? mustChangePassword,
    int? failedLoginAttempts,
    DateTime? lastFailedLoginAt,
    DateTime? lockedUntil,
    bool? mfaEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'email': email,
      'fullName': fullName,
      if (userInfoId != null) 'userInfoId': userInfoId,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'mustChangePassword': mustChangePassword,
      'failedLoginAttempts': failedLoginAttempts,
      if (lastFailedLoginAt != null)
        'lastFailedLoginAt': lastFailedLoginAt?.toJson(),
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      'mfaEnabled': mfaEnabled,
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

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String email,
    required String fullName,
    int? userInfoId,
    required bool isActive,
    required bool isDeleted,
    bool? mustChangePassword,
    int? failedLoginAttempts,
    DateTime? lastFailedLoginAt,
    DateTime? lockedUntil,
    bool? mfaEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         email: email,
         fullName: fullName,
         userInfoId: userInfoId,
         isActive: isActive,
         isDeleted: isDeleted,
         mustChangePassword: mustChangePassword,
         failedLoginAttempts: failedLoginAttempts,
         lastFailedLoginAt: lastFailedLoginAt,
         lockedUntil: lockedUntil,
         mfaEnabled: mfaEnabled,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? email,
    String? fullName,
    Object? userInfoId = _Undefined,
    bool? isActive,
    bool? isDeleted,
    bool? mustChangePassword,
    int? failedLoginAttempts,
    Object? lastFailedLoginAt = _Undefined,
    Object? lockedUntil = _Undefined,
    bool? mfaEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userInfoId: userInfoId is int? ? userInfoId : this.userInfoId,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      lastFailedLoginAt: lastFailedLoginAt is DateTime?
          ? lastFailedLoginAt
          : this.lastFailedLoginAt,
      lockedUntil: lockedUntil is DateTime? ? lockedUntil : this.lockedUntil,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
