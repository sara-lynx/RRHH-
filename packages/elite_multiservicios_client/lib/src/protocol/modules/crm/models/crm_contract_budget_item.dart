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

/// Partida individual de cotización o presupuesto de un contrato.
abstract class CrmContractBudgetItem implements _i1.SerializableModel {
  CrmContractBudgetItem._({
    this.id,
    required this.contractId,
    this.catalogItemId,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isDeleted = isDeleted ?? false;

  factory CrmContractBudgetItem({
    int? id,
    required int contractId,
    int? catalogItemId,
    required String description,
    required double quantity,
    required String unit,
    required double unitPrice,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmContractBudgetItemImpl;

  factory CrmContractBudgetItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmContractBudgetItem(
      id: jsonSerialization['id'] as int?,
      contractId: jsonSerialization['contractId'] as int,
      catalogItemId: jsonSerialization['catalogItemId'] as int?,
      description: jsonSerialization['description'] as String,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
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

  /// ID del contrato al que pertenece la partida.
  int contractId;

  /// ID referencial de la partida en el catálogo maestro (service_id).
  int? catalogItemId;

  /// Descripción detallada del ítem o servicio.
  String description;

  /// Cantidad requerida.
  double quantity;

  /// Unidad de medida (Mes, Puesto, Global, Horas, m², Unidad, Visita).
  String unit;

  /// Precio unitario en Bs.
  double unitPrice;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmContractBudgetItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmContractBudgetItem copyWith({
    int? id,
    int? contractId,
    int? catalogItemId,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmContractBudgetItem',
      if (id != null) 'id': id,
      'contractId': contractId,
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
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

class _CrmContractBudgetItemImpl extends CrmContractBudgetItem {
  _CrmContractBudgetItemImpl({
    int? id,
    required int contractId,
    int? catalogItemId,
    required String description,
    required double quantity,
    required String unit,
    required double unitPrice,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contractId: contractId,
         catalogItemId: catalogItemId,
         description: description,
         quantity: quantity,
         unit: unit,
         unitPrice: unitPrice,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmContractBudgetItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmContractBudgetItem copyWith({
    Object? id = _Undefined,
    int? contractId,
    Object? catalogItemId = _Undefined,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmContractBudgetItem(
      id: id is int? ? id : this.id,
      contractId: contractId ?? this.contractId,
      catalogItemId: catalogItemId is int? ? catalogItemId : this.catalogItemId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
