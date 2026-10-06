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

abstract class OpsServiceContract implements _i1.SerializableModel {
  OpsServiceContract._({
    this.id,
    required this.customerId,
    required this.serviceType,
    required this.startDate,
    this.endDate,
    String? status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending';

  factory OpsServiceContract({
    int? id,
    required int customerId,
    required String serviceType,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    required double totalAmount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OpsServiceContractImpl;

  factory OpsServiceContract.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsServiceContract(
      id: jsonSerialization['id'] as int?,
      customerId: jsonSerialization['customerId'] as int,
      serviceType: jsonSerialization['serviceType'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String?,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
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

  int customerId;

  String serviceType;

  DateTime startDate;

  DateTime? endDate;

  String status;

  double totalAmount;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [OpsServiceContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsServiceContract copyWith({
    int? id,
    int? customerId,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsServiceContract',
      if (id != null) 'id': id,
      'customerId': customerId,
      'serviceType': serviceType,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'status': status,
      'totalAmount': totalAmount,
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

class _OpsServiceContractImpl extends OpsServiceContract {
  _OpsServiceContractImpl({
    int? id,
    required int customerId,
    required String serviceType,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    required double totalAmount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         customerId: customerId,
         serviceType: serviceType,
         startDate: startDate,
         endDate: endDate,
         status: status,
         totalAmount: totalAmount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OpsServiceContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsServiceContract copyWith({
    Object? id = _Undefined,
    int? customerId,
    String? serviceType,
    DateTime? startDate,
    Object? endDate = _Undefined,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OpsServiceContract(
      id: id is int? ? id : this.id,
      customerId: customerId ?? this.customerId,
      serviceType: serviceType ?? this.serviceType,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
