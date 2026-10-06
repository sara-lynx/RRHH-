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

abstract class MfaVerifyResponse implements _i1.SerializableModel {
  MfaVerifyResponse._({
    required this.success,
    this.trustedDeviceToken,
  });

  factory MfaVerifyResponse({
    required bool success,
    String? trustedDeviceToken,
  }) = _MfaVerifyResponseImpl;

  factory MfaVerifyResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return MfaVerifyResponse(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      trustedDeviceToken: jsonSerialization['trustedDeviceToken'] as String?,
    );
  }

  bool success;

  String? trustedDeviceToken;

  /// Returns a shallow copy of this [MfaVerifyResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MfaVerifyResponse copyWith({
    bool? success,
    String? trustedDeviceToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MfaVerifyResponse',
      'success': success,
      if (trustedDeviceToken != null) 'trustedDeviceToken': trustedDeviceToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MfaVerifyResponseImpl extends MfaVerifyResponse {
  _MfaVerifyResponseImpl({
    required bool success,
    String? trustedDeviceToken,
  }) : super._(
         success: success,
         trustedDeviceToken: trustedDeviceToken,
       );

  /// Returns a shallow copy of this [MfaVerifyResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MfaVerifyResponse copyWith({
    bool? success,
    Object? trustedDeviceToken = _Undefined,
  }) {
    return MfaVerifyResponse(
      success: success ?? this.success,
      trustedDeviceToken: trustedDeviceToken is String?
          ? trustedDeviceToken
          : this.trustedDeviceToken,
    );
  }
}
