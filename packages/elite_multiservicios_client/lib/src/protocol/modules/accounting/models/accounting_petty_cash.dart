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

abstract class AccountingPettyCash implements _i1.SerializableModel {
  AccountingPettyCash._({
    this.id,
    required this.name,
    required this.balance,
    required this.maxLimit,
    required this.custodianId,
  });

  factory AccountingPettyCash({
    int? id,
    required String name,
    required double balance,
    required double maxLimit,
    required int custodianId,
  }) = _AccountingPettyCashImpl;

  factory AccountingPettyCash.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingPettyCash(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      balance: (jsonSerialization['balance'] as num).toDouble(),
      maxLimit: (jsonSerialization['maxLimit'] as num).toDouble(),
      custodianId: jsonSerialization['custodianId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  double balance;

  double maxLimit;

  int custodianId;

  /// Returns a shallow copy of this [AccountingPettyCash]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPettyCash copyWith({
    int? id,
    String? name,
    double? balance,
    double? maxLimit,
    int? custodianId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPettyCash',
      if (id != null) 'id': id,
      'name': name,
      'balance': balance,
      'maxLimit': maxLimit,
      'custodianId': custodianId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPettyCashImpl extends AccountingPettyCash {
  _AccountingPettyCashImpl({
    int? id,
    required String name,
    required double balance,
    required double maxLimit,
    required int custodianId,
  }) : super._(
         id: id,
         name: name,
         balance: balance,
         maxLimit: maxLimit,
         custodianId: custodianId,
       );

  /// Returns a shallow copy of this [AccountingPettyCash]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPettyCash copyWith({
    Object? id = _Undefined,
    String? name,
    double? balance,
    double? maxLimit,
    int? custodianId,
  }) {
    return AccountingPettyCash(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      maxLimit: maxLimit ?? this.maxLimit,
      custodianId: custodianId ?? this.custodianId,
    );
  }
}
