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

abstract class AccountingTax implements _i1.SerializableModel {
  AccountingTax._({
    this.id,
    required this.name,
    required this.rate,
    required this.type,
    this.ledgerAccountId,
    required this.isActive,
  });

  factory AccountingTax({
    int? id,
    required String name,
    required double rate,
    required String type,
    int? ledgerAccountId,
    required bool isActive,
  }) = _AccountingTaxImpl;

  factory AccountingTax.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingTax(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      rate: (jsonSerialization['rate'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      ledgerAccountId: jsonSerialization['ledgerAccountId'] as int?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  double rate;

  String type;

  int? ledgerAccountId;

  bool isActive;

  /// Returns a shallow copy of this [AccountingTax]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingTax copyWith({
    int? id,
    String? name,
    double? rate,
    String? type,
    int? ledgerAccountId,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingTax',
      if (id != null) 'id': id,
      'name': name,
      'rate': rate,
      'type': type,
      if (ledgerAccountId != null) 'ledgerAccountId': ledgerAccountId,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingTaxImpl extends AccountingTax {
  _AccountingTaxImpl({
    int? id,
    required String name,
    required double rate,
    required String type,
    int? ledgerAccountId,
    required bool isActive,
  }) : super._(
         id: id,
         name: name,
         rate: rate,
         type: type,
         ledgerAccountId: ledgerAccountId,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [AccountingTax]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingTax copyWith({
    Object? id = _Undefined,
    String? name,
    double? rate,
    String? type,
    Object? ledgerAccountId = _Undefined,
    bool? isActive,
  }) {
    return AccountingTax(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      rate: rate ?? this.rate,
      type: type ?? this.type,
      ledgerAccountId: ledgerAccountId is int?
          ? ledgerAccountId
          : this.ledgerAccountId,
      isActive: isActive ?? this.isActive,
    );
  }
}
