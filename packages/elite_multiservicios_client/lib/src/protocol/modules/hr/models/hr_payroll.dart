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

abstract class HrPayroll implements _i1.SerializableModel {
  HrPayroll._({
    this.id,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.baseSalary,
    double? bonuses,
    double? deductions,
    required this.netPay,
    bool? isPaid,
    this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
  }) : bonuses = bonuses ?? 0.0,
       deductions = deductions ?? 0.0,
       isPaid = isPaid ?? false;

  factory HrPayroll({
    int? id,
    required int employeeId,
    required int month,
    required int year,
    required double baseSalary,
    double? bonuses,
    double? deductions,
    required double netPay,
    bool? isPaid,
    DateTime? paymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HrPayrollImpl;

  factory HrPayroll.fromJson(Map<String, dynamic> jsonSerialization) {
    return HrPayroll(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      month: jsonSerialization['month'] as int,
      year: jsonSerialization['year'] as int,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      bonuses: (jsonSerialization['bonuses'] as num?)?.toDouble(),
      deductions: (jsonSerialization['deductions'] as num?)?.toDouble(),
      netPay: (jsonSerialization['netPay'] as num).toDouble(),
      isPaid: jsonSerialization['isPaid'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPaid']),
      paymentDate: jsonSerialization['paymentDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['paymentDate'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int employeeId;

  int month;

  int year;

  double baseSalary;

  double bonuses;

  double deductions;

  double netPay;

  bool isPaid;

  DateTime? paymentDate;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [HrPayroll]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HrPayroll copyWith({
    int? id,
    int? employeeId,
    int? month,
    int? year,
    double? baseSalary,
    double? bonuses,
    double? deductions,
    double? netPay,
    bool? isPaid,
    DateTime? paymentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HrPayroll',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'month': month,
      'year': year,
      'baseSalary': baseSalary,
      'bonuses': bonuses,
      'deductions': deductions,
      'netPay': netPay,
      'isPaid': isPaid,
      if (paymentDate != null) 'paymentDate': paymentDate?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HrPayrollImpl extends HrPayroll {
  _HrPayrollImpl({
    int? id,
    required int employeeId,
    required int month,
    required int year,
    required double baseSalary,
    double? bonuses,
    double? deductions,
    required double netPay,
    bool? isPaid,
    DateTime? paymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         month: month,
         year: year,
         baseSalary: baseSalary,
         bonuses: bonuses,
         deductions: deductions,
         netPay: netPay,
         isPaid: isPaid,
         paymentDate: paymentDate,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HrPayroll]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HrPayroll copyWith({
    Object? id = _Undefined,
    int? employeeId,
    int? month,
    int? year,
    double? baseSalary,
    double? bonuses,
    double? deductions,
    double? netPay,
    bool? isPaid,
    Object? paymentDate = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HrPayroll(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      month: month ?? this.month,
      year: year ?? this.year,
      baseSalary: baseSalary ?? this.baseSalary,
      bonuses: bonuses ?? this.bonuses,
      deductions: deductions ?? this.deductions,
      netPay: netPay ?? this.netPay,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate is DateTime? ? paymentDate : this.paymentDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
