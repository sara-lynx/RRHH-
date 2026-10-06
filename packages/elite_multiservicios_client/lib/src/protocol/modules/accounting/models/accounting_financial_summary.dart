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

abstract class AccountingFinancialSummary implements _i1.SerializableModel {
  AccountingFinancialSummary._({
    required this.totalIncome,
    required this.totalExpenses,
    required this.projectedIncome,
    required this.projectedExpenses,
    required this.pettyCashBalance,
    required this.balance,
  });

  factory AccountingFinancialSummary({
    required double totalIncome,
    required double totalExpenses,
    required double projectedIncome,
    required double projectedExpenses,
    required double pettyCashBalance,
    required double balance,
  }) = _AccountingFinancialSummaryImpl;

  factory AccountingFinancialSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingFinancialSummary(
      totalIncome: (jsonSerialization['totalIncome'] as num).toDouble(),
      totalExpenses: (jsonSerialization['totalExpenses'] as num).toDouble(),
      projectedIncome: (jsonSerialization['projectedIncome'] as num).toDouble(),
      projectedExpenses: (jsonSerialization['projectedExpenses'] as num)
          .toDouble(),
      pettyCashBalance: (jsonSerialization['pettyCashBalance'] as num)
          .toDouble(),
      balance: (jsonSerialization['balance'] as num).toDouble(),
    );
  }

  double totalIncome;

  double totalExpenses;

  double projectedIncome;

  double projectedExpenses;

  double pettyCashBalance;

  double balance;

  /// Returns a shallow copy of this [AccountingFinancialSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingFinancialSummary copyWith({
    double? totalIncome,
    double? totalExpenses,
    double? projectedIncome,
    double? projectedExpenses,
    double? pettyCashBalance,
    double? balance,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingFinancialSummary',
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'projectedIncome': projectedIncome,
      'projectedExpenses': projectedExpenses,
      'pettyCashBalance': pettyCashBalance,
      'balance': balance,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AccountingFinancialSummaryImpl extends AccountingFinancialSummary {
  _AccountingFinancialSummaryImpl({
    required double totalIncome,
    required double totalExpenses,
    required double projectedIncome,
    required double projectedExpenses,
    required double pettyCashBalance,
    required double balance,
  }) : super._(
         totalIncome: totalIncome,
         totalExpenses: totalExpenses,
         projectedIncome: projectedIncome,
         projectedExpenses: projectedExpenses,
         pettyCashBalance: pettyCashBalance,
         balance: balance,
       );

  /// Returns a shallow copy of this [AccountingFinancialSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingFinancialSummary copyWith({
    double? totalIncome,
    double? totalExpenses,
    double? projectedIncome,
    double? projectedExpenses,
    double? pettyCashBalance,
    double? balance,
  }) {
    return AccountingFinancialSummary(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      projectedIncome: projectedIncome ?? this.projectedIncome,
      projectedExpenses: projectedExpenses ?? this.projectedExpenses,
      pettyCashBalance: pettyCashBalance ?? this.pettyCashBalance,
      balance: balance ?? this.balance,
    );
  }
}
