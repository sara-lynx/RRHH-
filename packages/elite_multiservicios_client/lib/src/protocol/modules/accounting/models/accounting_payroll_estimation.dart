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

abstract class AccountingPayrollEstimation implements _i1.SerializableModel {
  AccountingPayrollEstimation._({
    this.id,
    required this.userId,
    required this.baseSalary,
    required this.bonuses,
    required this.estimatedTotal,
    required this.month,
    required this.year,
  });

  factory AccountingPayrollEstimation({
    int? id,
    required int userId,
    required double baseSalary,
    required double bonuses,
    required double estimatedTotal,
    required int month,
    required int year,
  }) = _AccountingPayrollEstimationImpl;

  factory AccountingPayrollEstimation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingPayrollEstimation(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      bonuses: (jsonSerialization['bonuses'] as num).toDouble(),
      estimatedTotal: (jsonSerialization['estimatedTotal'] as num).toDouble(),
      month: jsonSerialization['month'] as int,
      year: jsonSerialization['year'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  double baseSalary;

  double bonuses;

  double estimatedTotal;

  int month;

  int year;

  /// Returns a shallow copy of this [AccountingPayrollEstimation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingPayrollEstimation copyWith({
    int? id,
    int? userId,
    double? baseSalary,
    double? bonuses,
    double? estimatedTotal,
    int? month,
    int? year,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingPayrollEstimation',
      if (id != null) 'id': id,
      'userId': userId,
      'baseSalary': baseSalary,
      'bonuses': bonuses,
      'estimatedTotal': estimatedTotal,
      'month': month,
      'year': year,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingPayrollEstimationImpl extends AccountingPayrollEstimation {
  _AccountingPayrollEstimationImpl({
    int? id,
    required int userId,
    required double baseSalary,
    required double bonuses,
    required double estimatedTotal,
    required int month,
    required int year,
  }) : super._(
         id: id,
         userId: userId,
         baseSalary: baseSalary,
         bonuses: bonuses,
         estimatedTotal: estimatedTotal,
         month: month,
         year: year,
       );

  /// Returns a shallow copy of this [AccountingPayrollEstimation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingPayrollEstimation copyWith({
    Object? id = _Undefined,
    int? userId,
    double? baseSalary,
    double? bonuses,
    double? estimatedTotal,
    int? month,
    int? year,
  }) {
    return AccountingPayrollEstimation(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      baseSalary: baseSalary ?? this.baseSalary,
      bonuses: bonuses ?? this.bonuses,
      estimatedTotal: estimatedTotal ?? this.estimatedTotal,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
