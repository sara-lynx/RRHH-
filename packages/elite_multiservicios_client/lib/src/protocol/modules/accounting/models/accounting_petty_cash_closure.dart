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

abstract class AccountingPettyCashClosure implements _i1.SerializableModel {
  AccountingPettyCashClosure._({
    this.id,
    required this.pettyCashId,
    required this.date,
    required this.openingBalance,
    required this.closingBalance,
    this.comments,
    required this.createdAt,
  });

  factory AccountingPettyCashClosure({
    int? id,
    required int pettyCashId,
    required DateTime date,
    required double openingBalance,
    required double closingBalance,
    String? comments,
    required DateTime createdAt,
  }) = _AccountingPettyCashClosureImpl;

  factory AccountingPettyCashClosure.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPettyCashClosure(
      id: jsonSerialization['id'] as int?,
      pettyCashId: jsonSerialization['pettyCashId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      openingBalance: (jsonSerialization['openingBalance'] as num).toDouble(),
      closingBalance: (jsonSerialization['closingBalance'] as num).toDouble(),
      comments: jsonSerialization['comments'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int pettyCashId;

  DateTime date;

  double openingBalance;

  double closingBalance;

  String? comments;

  DateTime createdAt;

  /// Returns a shallow copy of this [AccountingPettyCashClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPettyCashClosure copyWith({
    int? id,
    int? pettyCashId,
    DateTime? date,
    double? openingBalance,
    double? closingBalance,
    String? comments,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPettyCashClosure',
      if (id != null) 'id': id,
      'pettyCashId': pettyCashId,
      'date': date.toJson(),
      'openingBalance': openingBalance,
      'closingBalance': closingBalance,
      if (comments != null) 'comments': comments,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPettyCashClosureImpl extends AccountingPettyCashClosure {
  _AccountingPettyCashClosureImpl({
    int? id,
    required int pettyCashId,
    required DateTime date,
    required double openingBalance,
    required double closingBalance,
    String? comments,
    required DateTime createdAt,
  }) : super._(
         id: id,
         pettyCashId: pettyCashId,
         date: date,
         openingBalance: openingBalance,
         closingBalance: closingBalance,
         comments: comments,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountingPettyCashClosure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPettyCashClosure copyWith({
    Object? id = _Undefined,
    int? pettyCashId,
    DateTime? date,
    double? openingBalance,
    double? closingBalance,
    Object? comments = _Undefined,
    DateTime? createdAt,
  }) {
    return AccountingPettyCashClosure(
      id: id is int? ? id : this.id,
      pettyCashId: pettyCashId ?? this.pettyCashId,
      date: date ?? this.date,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      comments: comments is String? ? comments : this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
