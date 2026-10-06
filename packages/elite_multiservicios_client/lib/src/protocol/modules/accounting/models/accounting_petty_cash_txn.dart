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

abstract class AccountingPettyCashTransaction implements _i1.SerializableModel {
  AccountingPettyCashTransaction._({
    this.id,
    required this.pettyCashId,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.hasInvoice,
    required this.isFixedPayment,
    this.fiscalCredit,
    this.fiscalDebit,
  });

  factory AccountingPettyCashTransaction({
    int? id,
    required int pettyCashId,
    required double amount,
    required String type,
    required String description,
    required DateTime date,
    required bool hasInvoice,
    required bool isFixedPayment,
    double? fiscalCredit,
    double? fiscalDebit,
  }) = _AccountingPettyCashTransactionImpl;

  factory AccountingPettyCashTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPettyCashTransaction(
      id: jsonSerialization['id'] as int?,
      pettyCashId: jsonSerialization['pettyCashId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      hasInvoice: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hasInvoice'],
      ),
      isFixedPayment: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isFixedPayment'],
      ),
      fiscalCredit: (jsonSerialization['fiscalCredit'] as num?)?.toDouble(),
      fiscalDebit: (jsonSerialization['fiscalDebit'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int pettyCashId;

  double amount;

  String type;

  String description;

  DateTime date;

  bool hasInvoice;

  bool isFixedPayment;

  double? fiscalCredit;

  double? fiscalDebit;

  /// Returns a shallow copy of this [AccountingPettyCashTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPettyCashTransaction copyWith({
    int? id,
    int? pettyCashId,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    bool? hasInvoice,
    bool? isFixedPayment,
    double? fiscalCredit,
    double? fiscalDebit,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPettyCashTransaction',
      if (id != null) 'id': id,
      'pettyCashId': pettyCashId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toJson(),
      'hasInvoice': hasInvoice,
      'isFixedPayment': isFixedPayment,
      if (fiscalCredit != null) 'fiscalCredit': fiscalCredit,
      if (fiscalDebit != null) 'fiscalDebit': fiscalDebit,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPettyCashTransactionImpl
    extends AccountingPettyCashTransaction {
  _AccountingPettyCashTransactionImpl({
    int? id,
    required int pettyCashId,
    required double amount,
    required String type,
    required String description,
    required DateTime date,
    required bool hasInvoice,
    required bool isFixedPayment,
    double? fiscalCredit,
    double? fiscalDebit,
  }) : super._(
         id: id,
         pettyCashId: pettyCashId,
         amount: amount,
         type: type,
         description: description,
         date: date,
         hasInvoice: hasInvoice,
         isFixedPayment: isFixedPayment,
         fiscalCredit: fiscalCredit,
         fiscalDebit: fiscalDebit,
       );

  /// Returns a shallow copy of this [AccountingPettyCashTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPettyCashTransaction copyWith({
    Object? id = _Undefined,
    int? pettyCashId,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    bool? hasInvoice,
    bool? isFixedPayment,
    Object? fiscalCredit = _Undefined,
    Object? fiscalDebit = _Undefined,
  }) {
    return AccountingPettyCashTransaction(
      id: id is int? ? id : this.id,
      pettyCashId: pettyCashId ?? this.pettyCashId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      hasInvoice: hasInvoice ?? this.hasInvoice,
      isFixedPayment: isFixedPayment ?? this.isFixedPayment,
      fiscalCredit: fiscalCredit is double? ? fiscalCredit : this.fiscalCredit,
      fiscalDebit: fiscalDebit is double? ? fiscalDebit : this.fiscalDebit,
    );
  }
}
