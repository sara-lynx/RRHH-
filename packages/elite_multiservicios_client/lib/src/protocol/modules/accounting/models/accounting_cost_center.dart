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

/// Centro de Costo (Cost Center) para medir rentabilidad por contrato o unidad.
abstract class AccountingCostCenter implements _i1.SerializableModel {
  AccountingCostCenter._({
    this.id,
    required this.name,
    this.contractId,
    String? status,
    this.description,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Activo',
       isDeleted = isDeleted ?? false;

  factory AccountingCostCenter({
    int? id,
    required String name,
    int? contractId,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingCostCenterImpl;

  factory AccountingCostCenter.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingCostCenter(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      contractId: jsonSerialization['contractId'] as int?,
      status: jsonSerialization['status'] as String?,
      description: jsonSerialization['description'] as String?,
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

  /// Nombre del centro de costo (ej. 'Condominio Las Palmas - Jardinería').
  String name;

  /// ID del contrato asociado en el CRM (opcional, si es para un contrato específico).
  int? contractId;

  /// Estado operativo: Activo, Cerrado.
  String status;

  /// Descripción detallada del centro de costo.
  String? description;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AccountingCostCenter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingCostCenter copyWith({
    int? id,
    String? name,
    int? contractId,
    String? status,
    String? description,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingCostCenter',
      if (id != null) 'id': id,
      'name': name,
      if (contractId != null) 'contractId': contractId,
      'status': status,
      if (description != null) 'description': description,
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

class _AccountingCostCenterImpl extends AccountingCostCenter {
  _AccountingCostCenterImpl({
    int? id,
    required String name,
    int? contractId,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         contractId: contractId,
         status: status,
         description: description,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingCostCenter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingCostCenter copyWith({
    Object? id = _Undefined,
    String? name,
    Object? contractId = _Undefined,
    String? status,
    Object? description = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingCostCenter(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      contractId: contractId is int? ? contractId : this.contractId,
      status: status ?? this.status,
      description: description is String? ? description : this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
