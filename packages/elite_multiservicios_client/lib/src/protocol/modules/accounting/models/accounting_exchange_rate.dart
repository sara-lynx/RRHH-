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

abstract class AccountingExchangeRate implements _i1.SerializableModel {
  AccountingExchangeRate._({
    this.id,
    required this.date,
    required this.currency,
    required this.rateToBob,
    required this.createdAt,
  });

  factory AccountingExchangeRate({
    int? id,
    required DateTime date,
    required String currency,
    required double rateToBob,
    required DateTime createdAt,
  }) = _AccountingExchangeRateImpl;

  factory AccountingExchangeRate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingExchangeRate(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      currency: jsonSerialization['currency'] as String,
      rateToBob: (jsonSerialization['rateToBob'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime date;

  String currency;

  double rateToBob;

  DateTime createdAt;

  /// Returns a shallow copy of this [AccountingExchangeRate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingExchangeRate copyWith({
    int? id,
    DateTime? date,
    String? currency,
    double? rateToBob,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingExchangeRate',
      if (id != null) 'id': id,
      'date': date.toJson(),
      'currency': currency,
      'rateToBob': rateToBob,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingExchangeRateImpl extends AccountingExchangeRate {
  _AccountingExchangeRateImpl({
    int? id,
    required DateTime date,
    required String currency,
    required double rateToBob,
    required DateTime createdAt,
  }) : super._(
         id: id,
         date: date,
         currency: currency,
         rateToBob: rateToBob,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountingExchangeRate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingExchangeRate copyWith({
    Object? id = _Undefined,
    DateTime? date,
    String? currency,
    double? rateToBob,
    DateTime? createdAt,
  }) {
    return AccountingExchangeRate(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      rateToBob: rateToBob ?? this.rateToBob,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
