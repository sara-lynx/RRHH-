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

abstract class MfaChallengeResponse implements _i1.SerializableModel {
  MfaChallengeResponse._({
    required this.challengeId,
    required this.emailHint,
    required this.expiresAt,
  });

  factory MfaChallengeResponse({
    required String challengeId,
    required String emailHint,
    required DateTime expiresAt,
  }) = _MfaChallengeResponseImpl;

  factory MfaChallengeResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MfaChallengeResponse(
      challengeId: jsonSerialization['challengeId'] as String,
      emailHint: jsonSerialization['emailHint'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  String challengeId;

  String emailHint;

  DateTime expiresAt;

  /// Returns a shallow copy of this [MfaChallengeResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MfaChallengeResponse copyWith({
    String? challengeId,
    String? emailHint,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MfaChallengeResponse',
      'challengeId': challengeId,
      'emailHint': emailHint,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MfaChallengeResponseImpl extends MfaChallengeResponse {
  _MfaChallengeResponseImpl({
    required String challengeId,
    required String emailHint,
    required DateTime expiresAt,
  }) : super._(
         challengeId: challengeId,
         emailHint: emailHint,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [MfaChallengeResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MfaChallengeResponse copyWith({
    String? challengeId,
    String? emailHint,
    DateTime? expiresAt,
  }) {
    return MfaChallengeResponse(
      challengeId: challengeId ?? this.challengeId,
      emailHint: emailHint ?? this.emailHint,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
