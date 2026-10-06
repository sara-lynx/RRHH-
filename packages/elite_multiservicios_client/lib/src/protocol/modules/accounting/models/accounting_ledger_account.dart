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

abstract class AccountingLedgerAccount implements _i1.SerializableModel {
  AccountingLedgerAccount._({
    this.id,
    required this.code,
    required this.name,
    required this.type,
    this.description,
    required this.isActive,
  });

  factory AccountingLedgerAccount({
    int? id,
    required String code,
    required String name,
    required String type,
    String? description,
    required bool isActive,
  }) = _AccountingLedgerAccountImpl;

  factory AccountingLedgerAccount.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingLedgerAccount(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String name;

  String type;

  String? description;

  bool isActive;

  /// Returns a shallow copy of this [AccountingLedgerAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingLedgerAccount copyWith({
    int? id,
    String? code,
    String? name,
    String? type,
    String? description,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingLedgerAccount',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingLedgerAccountImpl extends AccountingLedgerAccount {
  _AccountingLedgerAccountImpl({
    int? id,
    required String code,
    required String name,
    required String type,
    String? description,
    required bool isActive,
  }) : super._(
         id: id,
         code: code,
         name: name,
         type: type,
         description: description,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [AccountingLedgerAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingLedgerAccount copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? type,
    Object? description = _Undefined,
    bool? isActive,
  }) {
    return AccountingLedgerAccount(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
