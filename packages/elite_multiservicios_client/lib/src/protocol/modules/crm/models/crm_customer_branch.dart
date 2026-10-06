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

/// Sede u oficina operativa de un Cliente 360°.
abstract class CrmCustomerBranch implements _i1.SerializableModel {
  CrmCustomerBranch._({
    this.id,
    required this.code,
    required this.customerId,
    required this.name,
    required this.address,
    required this.localContact,
    required this.localPhone,
    bool? isHeadquarters,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isHeadquarters = isHeadquarters ?? false,
       isDeleted = isDeleted ?? false;

  factory CrmCustomerBranch({
    int? id,
    required String code,
    required int customerId,
    required String name,
    required String address,
    required String localContact,
    required String localPhone,
    bool? isHeadquarters,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCustomerBranchImpl;

  factory CrmCustomerBranch.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCustomerBranch(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      customerId: jsonSerialization['customerId'] as int,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      localContact: jsonSerialization['localContact'] as String,
      localPhone: jsonSerialization['localPhone'] as String,
      isHeadquarters: jsonSerialization['isHeadquarters'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isHeadquarters']),
      notes: jsonSerialization['notes'] as String?,
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
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

  /// Código de seguimiento de la sede (ej. BR-001).
  String code;

  /// ID del cliente propietario de la sede.
  int customerId;

  /// Nombre descriptivo de la sede (ej. Torre Central, Garita Norte).
  String name;

  /// Dirección física detallada de la sede.
  String address;

  /// Contacto operativo local en la sede.
  String localContact;

  /// Teléfono de contacto local.
  String localPhone;

  /// Indicador de si es la Sede Principal / Casa Matriz.
  bool isHeadquarters;

  /// Requisitos de acceso y notas operativas.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría temporal.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmCustomerBranch]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomerBranch copyWith({
    int? id,
    String? code,
    int? customerId,
    String? name,
    String? address,
    String? localContact,
    String? localPhone,
    bool? isHeadquarters,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomerBranch',
      if (id != null) 'id': id,
      'code': code,
      'customerId': customerId,
      'name': name,
      'address': address,
      'localContact': localContact,
      'localPhone': localPhone,
      'isHeadquarters': isHeadquarters,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
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

class _CrmCustomerBranchImpl extends CrmCustomerBranch {
  _CrmCustomerBranchImpl({
    int? id,
    required String code,
    required int customerId,
    required String name,
    required String address,
    required String localContact,
    required String localPhone,
    bool? isHeadquarters,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         customerId: customerId,
         name: name,
         address: address,
         localContact: localContact,
         localPhone: localPhone,
         isHeadquarters: isHeadquarters,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCustomerBranch]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomerBranch copyWith({
    Object? id = _Undefined,
    String? code,
    int? customerId,
    String? name,
    String? address,
    String? localContact,
    String? localPhone,
    bool? isHeadquarters,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCustomerBranch(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      address: address ?? this.address,
      localContact: localContact ?? this.localContact,
      localPhone: localPhone ?? this.localPhone,
      isHeadquarters: isHeadquarters ?? this.isHeadquarters,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
