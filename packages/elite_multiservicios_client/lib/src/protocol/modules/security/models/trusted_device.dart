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

abstract class TrustedDevice implements _i1.SerializableModel {
  TrustedDevice._({
    this.id,
    required this.userId,
    required this.deviceToken,
    this.deviceInfo,
    this.ipAddress,
    required this.expiresAt,
    required this.createdAt,
  });

  factory TrustedDevice({
    int? id,
    required int userId,
    required String deviceToken,
    String? deviceInfo,
    String? ipAddress,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _TrustedDeviceImpl;

  factory TrustedDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return TrustedDevice(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      deviceToken: jsonSerialization['deviceToken'] as String,
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
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

  int userId;

  String deviceToken;

  String? deviceInfo;

  String? ipAddress;

  DateTime expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [TrustedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TrustedDevice copyWith({
    int? id,
    int? userId,
    String? deviceToken,
    String? deviceInfo,
    String? ipAddress,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TrustedDevice',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceToken': deviceToken,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TrustedDeviceImpl extends TrustedDevice {
  _TrustedDeviceImpl({
    int? id,
    required int userId,
    required String deviceToken,
    String? deviceInfo,
    String? ipAddress,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         deviceToken: deviceToken,
         deviceInfo: deviceInfo,
         ipAddress: ipAddress,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TrustedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TrustedDevice copyWith({
    Object? id = _Undefined,
    int? userId,
    String? deviceToken,
    Object? deviceInfo = _Undefined,
    Object? ipAddress = _Undefined,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return TrustedDevice(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
