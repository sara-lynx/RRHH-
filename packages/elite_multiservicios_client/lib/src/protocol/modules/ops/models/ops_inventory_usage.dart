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

abstract class OpsInventoryUsage implements _i1.SerializableModel {
  OpsInventoryUsage._({
    this.id,
    required this.workOrderId,
    required this.itemId,
    required this.quantityUsed,
    required this.totalCost,
    required this.createdAt,
  });

  factory OpsInventoryUsage({
    int? id,
    required int workOrderId,
    required int itemId,
    required double quantityUsed,
    required double totalCost,
    required DateTime createdAt,
  }) = _OpsInventoryUsageImpl;

  factory OpsInventoryUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsInventoryUsage(
      id: jsonSerialization['id'] as int?,
      workOrderId: jsonSerialization['workOrderId'] as int,
      itemId: jsonSerialization['itemId'] as int,
      quantityUsed: (jsonSerialization['quantityUsed'] as num).toDouble(),
      totalCost: (jsonSerialization['totalCost'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workOrderId;

  int itemId;

  double quantityUsed;

  double totalCost;

  DateTime createdAt;

  /// Returns a shallow copy of this [OpsInventoryUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsInventoryUsage copyWith({
    int? id,
    int? workOrderId,
    int? itemId,
    double? quantityUsed,
    double? totalCost,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsInventoryUsage',
      if (id != null) 'id': id,
      'workOrderId': workOrderId,
      'itemId': itemId,
      'quantityUsed': quantityUsed,
      'totalCost': totalCost,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsInventoryUsageImpl extends OpsInventoryUsage {
  _OpsInventoryUsageImpl({
    int? id,
    required int workOrderId,
    required int itemId,
    required double quantityUsed,
    required double totalCost,
    required DateTime createdAt,
  }) : super._(
         id: id,
         workOrderId: workOrderId,
         itemId: itemId,
         quantityUsed: quantityUsed,
         totalCost: totalCost,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OpsInventoryUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsInventoryUsage copyWith({
    Object? id = _Undefined,
    int? workOrderId,
    int? itemId,
    double? quantityUsed,
    double? totalCost,
    DateTime? createdAt,
  }) {
    return OpsInventoryUsage(
      id: id is int? ? id : this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      itemId: itemId ?? this.itemId,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      totalCost: totalCost ?? this.totalCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
