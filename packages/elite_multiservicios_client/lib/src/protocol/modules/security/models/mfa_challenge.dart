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

abstract class MfaChallenge implements _i1.SerializableModel {
  MfaChallenge._({
    this.id,
    required this.userId,
    required this.challengeId,
    required this.codeHash,
    int? attempts,
    bool? isUsed,
    required this.expiresAt,
    required this.createdAt,
  }) : attempts = attempts ?? 0,
       isUsed = isUsed ?? false;

  factory MfaChallenge({
    int? id,
    required int userId,
    required String challengeId,
    required String codeHash,
    int? attempts,
    bool? isUsed,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _MfaChallengeImpl;

  factory MfaChallenge.fromJson(Map<String, dynamic> jsonSerialization) {
    return MfaChallenge(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      challengeId: jsonSerialization['challengeId'] as String,
      codeHash: jsonSerialization['codeHash'] as String,
      attempts: jsonSerialization['attempts'] as int?,
      isUsed: jsonSerialization['isUsed'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isUsed']),
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

  String challengeId;

  String codeHash;

  int attempts;

  bool isUsed;

  DateTime expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [MfaChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MfaChallenge copyWith({
    int? id,
    int? userId,
    String? challengeId,
    String? codeHash,
    int? attempts,
    bool? isUsed,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MfaChallenge',
      if (id != null) 'id': id,
      'userId': userId,
      'challengeId': challengeId,
      'codeHash': codeHash,
      'attempts': attempts,
      'isUsed': isUsed,
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

class _MfaChallengeImpl extends MfaChallenge {
  _MfaChallengeImpl({
    int? id,
    required int userId,
    required String challengeId,
    required String codeHash,
    int? attempts,
    bool? isUsed,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         challengeId: challengeId,
         codeHash: codeHash,
         attempts: attempts,
         isUsed: isUsed,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MfaChallenge]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MfaChallenge copyWith({
    Object? id = _Undefined,
    int? userId,
    String? challengeId,
    String? codeHash,
    int? attempts,
    bool? isUsed,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return MfaChallenge(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      codeHash: codeHash ?? this.codeHash,
      attempts: attempts ?? this.attempts,
      isUsed: isUsed ?? this.isUsed,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
