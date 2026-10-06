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

abstract class OpsInventoryItem implements _i1.SerializableModel {
  OpsInventoryItem._({
    this.id,
    required this.name,
    this.description,
    required this.unit,
    double? quantityInStock,
    double? averageCost,
    required this.createdAt,
    required this.updatedAt,
  }) : quantityInStock = quantityInStock ?? 0.0,
       averageCost = averageCost ?? 0.0;

  factory OpsInventoryItem({
    int? id,
    required String name,
    String? description,
    required String unit,
    double? quantityInStock,
    double? averageCost,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OpsInventoryItemImpl;

  factory OpsInventoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsInventoryItem(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      unit: jsonSerialization['unit'] as String,
      quantityInStock: (jsonSerialization['quantityInStock'] as num?)
          ?.toDouble(),
      averageCost: (jsonSerialization['averageCost'] as num?)?.toDouble(),
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

  String name;

  String? description;

  String unit;

  double quantityInStock;

  double averageCost;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [OpsInventoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OpsInventoryItem copyWith({
    int? id,
    String? name,
    String? description,
    String? unit,
    double? quantityInStock,
    double? averageCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsInventoryItem',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'unit': unit,
      'quantityInStock': quantityInStock,
      'averageCost': averageCost,
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

class _OpsInventoryItemImpl extends OpsInventoryItem {
  _OpsInventoryItemImpl({
    int? id,
    required String name,
    String? description,
    required String unit,
    double? quantityInStock,
    double? averageCost,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         unit: unit,
         quantityInStock: quantityInStock,
         averageCost: averageCost,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OpsInventoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OpsInventoryItem copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? unit,
    double? quantityInStock,
    double? averageCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OpsInventoryItem(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      unit: unit ?? this.unit,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      averageCost: averageCost ?? this.averageCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
