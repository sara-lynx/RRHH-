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

abstract class OpsWorkOrder implements _i1.SerializableModel {
  OpsWorkOrder._({
    this.id,
    required this.contractId,
    required this.date,
    this.assignedEmployeeId,
    String? status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending';

  factory OpsWorkOrder({
    int? id,
    required int contractId,
    required DateTime date,
    int? assignedEmployeeId,
    String? status,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OpsWorkOrderImpl;

  factory OpsWorkOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsWorkOrder(
      id: jsonSerialization['id'] as int?,
      contractId: jsonSerialization['contractId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      assignedEmployeeId: jsonSerialization['assignedEmployeeId'] as int?,
      status: jsonSerialization['status'] as String?,
      notes: jsonSerialization['notes'] as String?,
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

  int contractId;

  DateTime date;

  int? assignedEmployeeId;

  String status;

  String? notes;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [OpsWorkOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsWorkOrder copyWith({
    int? id,
    int? contractId,
    DateTime? date,
    int? assignedEmployeeId,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsWorkOrder',
      if (id != null) 'id': id,
      'contractId': contractId,
      'date': date.toJson(),
      if (assignedEmployeeId != null) 'assignedEmployeeId': assignedEmployeeId,
      'status': status,
      if (notes != null) 'notes': notes,
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

class _OpsWorkOrderImpl extends OpsWorkOrder {
  _OpsWorkOrderImpl({
    int? id,
    required int contractId,
    required DateTime date,
    int? assignedEmployeeId,
    String? status,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contractId: contractId,
         date: date,
         assignedEmployeeId: assignedEmployeeId,
         status: status,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OpsWorkOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsWorkOrder copyWith({
    Object? id = _Undefined,
    int? contractId,
    DateTime? date,
    Object? assignedEmployeeId = _Undefined,
    String? status,
    Object? notes = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OpsWorkOrder(
      id: id is int? ? id : this.id,
      contractId: contractId ?? this.contractId,
      date: date ?? this.date,
      assignedEmployeeId: assignedEmployeeId is int?
          ? assignedEmployeeId
          : this.assignedEmployeeId,
      status: status ?? this.status,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
