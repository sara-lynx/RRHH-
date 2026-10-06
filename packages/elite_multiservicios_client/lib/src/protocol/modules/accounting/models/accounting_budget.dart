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

abstract class AccountingBudget implements _i1.SerializableModel {
  AccountingBudget._({
    this.id,
    required this.month,
    required this.year,
    required this.projectedIncome,
    required this.executedIncome,
    required this.projectedExpenses,
    required this.executedExpenses,
    required this.estimatedBalance,
  });

  factory AccountingBudget({
    int? id,
    required int month,
    required int year,
    required double projectedIncome,
    required double executedIncome,
    required double projectedExpenses,
    required double executedExpenses,
    required double estimatedBalance,
  }) = _AccountingBudgetImpl;

  factory AccountingBudget.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingBudget(
      id: jsonSerialization['id'] as int?,
      month: jsonSerialization['month'] as int,
      year: jsonSerialization['year'] as int,
      projectedIncome: (jsonSerialization['projectedIncome'] as num).toDouble(),
      executedIncome: (jsonSerialization['executedIncome'] as num).toDouble(),
      projectedExpenses: (jsonSerialization['projectedExpenses'] as num)
          .toDouble(),
      executedExpenses: (jsonSerialization['executedExpenses'] as num)
          .toDouble(),
      estimatedBalance: (jsonSerialization['estimatedBalance'] as num)
          .toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int month;

  int year;

  double projectedIncome;

  double executedIncome;

  double projectedExpenses;

  double executedExpenses;

  double estimatedBalance;

  /// Returns a shallow copy of this [AccountingBudget]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingBudget copyWith({
    int? id,
    int? month,
    int? year,
    double? projectedIncome,
    double? executedIncome,
    double? projectedExpenses,
    double? executedExpenses,
    double? estimatedBalance,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingBudget',
      if (id != null) 'id': id,
      'month': month,
      'year': year,
      'projectedIncome': projectedIncome,
      'executedIncome': executedIncome,
      'projectedExpenses': projectedExpenses,
      'executedExpenses': executedExpenses,
      'estimatedBalance': estimatedBalance,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingBudgetImpl extends AccountingBudget {
  _AccountingBudgetImpl({
    int? id,
    required int month,
    required int year,
    required double projectedIncome,
    required double executedIncome,
    required double projectedExpenses,
    required double executedExpenses,
    required double estimatedBalance,
  }) : super._(
         id: id,
         month: month,
         year: year,
         projectedIncome: projectedIncome,
         executedIncome: executedIncome,
         projectedExpenses: projectedExpenses,
         executedExpenses: executedExpenses,
         estimatedBalance: estimatedBalance,
       );

  /// Returns a shallow copy of this [AccountingBudget]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingBudget copyWith({
    Object? id = _Undefined,
    int? month,
    int? year,
    double? projectedIncome,
    double? executedIncome,
    double? projectedExpenses,
    double? executedExpenses,
    double? estimatedBalance,
  }) {
    return AccountingBudget(
      id: id is int? ? id : this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      projectedIncome: projectedIncome ?? this.projectedIncome,
      executedIncome: executedIncome ?? this.executedIncome,
      projectedExpenses: projectedExpenses ?? this.projectedExpenses,
      executedExpenses: executedExpenses ?? this.executedExpenses,
      estimatedBalance: estimatedBalance ?? this.estimatedBalance,
    );
  }
}
