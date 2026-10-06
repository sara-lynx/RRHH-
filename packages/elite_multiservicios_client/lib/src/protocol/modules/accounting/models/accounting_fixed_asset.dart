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

abstract class AccountingFixedAsset implements _i1.SerializableModel {
  AccountingFixedAsset._({
    this.id,
    required this.name,
    required this.category,
    required this.purchaseValue,
    required this.purchaseDate,
    required this.usefulLifeMonths,
    required this.accumulatedDepreciation,
    required this.isFullyDepreciated,
    this.lastDepreciationDate,
  });

  factory AccountingFixedAsset({
    int? id,
    required String name,
    required String category,
    required double purchaseValue,
    required DateTime purchaseDate,
    required int usefulLifeMonths,
    required double accumulatedDepreciation,
    required bool isFullyDepreciated,
    DateTime? lastDepreciationDate,
  }) = _AccountingFixedAssetImpl;

  factory AccountingFixedAsset.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingFixedAsset(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      purchaseValue: (jsonSerialization['purchaseValue'] as num).toDouble(),
      purchaseDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['purchaseDate'],
      ),
      usefulLifeMonths: jsonSerialization['usefulLifeMonths'] as int,
      accumulatedDepreciation:
          (jsonSerialization['accumulatedDepreciation'] as num).toDouble(),
      isFullyDepreciated: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isFullyDepreciated'],
      ),
      lastDepreciationDate: jsonSerialization['lastDepreciationDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastDepreciationDate'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String category;

  double purchaseValue;

  DateTime purchaseDate;

  int usefulLifeMonths;

  double accumulatedDepreciation;

  bool isFullyDepreciated;

  DateTime? lastDepreciationDate;

  /// Returns a shallow copy of this [AccountingFixedAsset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingFixedAsset copyWith({
    int? id,
    String? name,
    String? category,
    double? purchaseValue,
    DateTime? purchaseDate,
    int? usefulLifeMonths,
    double? accumulatedDepreciation,
    bool? isFullyDepreciated,
    DateTime? lastDepreciationDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingFixedAsset',
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'purchaseValue': purchaseValue,
      'purchaseDate': purchaseDate.toJson(),
      'usefulLifeMonths': usefulLifeMonths,
      'accumulatedDepreciation': accumulatedDepreciation,
      'isFullyDepreciated': isFullyDepreciated,
      if (lastDepreciationDate != null)
        'lastDepreciationDate': lastDepreciationDate?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingFixedAssetImpl extends AccountingFixedAsset {
  _AccountingFixedAssetImpl({
    int? id,
    required String name,
    required String category,
    required double purchaseValue,
    required DateTime purchaseDate,
    required int usefulLifeMonths,
    required double accumulatedDepreciation,
    required bool isFullyDepreciated,
    DateTime? lastDepreciationDate,
  }) : super._(
         id: id,
         name: name,
         category: category,
         purchaseValue: purchaseValue,
         purchaseDate: purchaseDate,
         usefulLifeMonths: usefulLifeMonths,
         accumulatedDepreciation: accumulatedDepreciation,
         isFullyDepreciated: isFullyDepreciated,
         lastDepreciationDate: lastDepreciationDate,
       );

  /// Returns a shallow copy of this [AccountingFixedAsset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingFixedAsset copyWith({
    Object? id = _Undefined,
    String? name,
    String? category,
    double? purchaseValue,
    DateTime? purchaseDate,
    int? usefulLifeMonths,
    double? accumulatedDepreciation,
    bool? isFullyDepreciated,
    Object? lastDepreciationDate = _Undefined,
  }) {
    return AccountingFixedAsset(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      purchaseValue: purchaseValue ?? this.purchaseValue,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      usefulLifeMonths: usefulLifeMonths ?? this.usefulLifeMonths,
      accumulatedDepreciation:
          accumulatedDepreciation ?? this.accumulatedDepreciation,
      isFullyDepreciated: isFullyDepreciated ?? this.isFullyDepreciated,
      lastDepreciationDate: lastDepreciationDate is DateTime?
          ? lastDepreciationDate
          : this.lastDepreciationDate,
    );
  }
}
