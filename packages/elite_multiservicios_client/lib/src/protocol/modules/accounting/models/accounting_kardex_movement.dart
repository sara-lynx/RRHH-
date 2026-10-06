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

/// Movimiento de Kárdex Valuado para integración contable de inventario.
abstract class AccountingKardexMovement implements _i1.SerializableModel {
  AccountingKardexMovement._({
    this.id,
    required this.itemId,
    required this.itemName,
    required this.date,
    required this.movementType,
    required this.referenceDoc,
    this.workOrderId,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    required this.balanceQuantity,
    required this.balanceTotalCost,
    this.notes,
    required this.createdAt,
  });

  factory AccountingKardexMovement({
    int? id,
    required int itemId,
    required String itemName,
    required DateTime date,
    required String movementType,
    required String referenceDoc,
    int? workOrderId,
    required double quantity,
    required double unitCost,
    required double totalCost,
    required double balanceQuantity,
    required double balanceTotalCost,
    String? notes,
    required DateTime createdAt,
  }) = _AccountingKardexMovementImpl;

  factory AccountingKardexMovement.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingKardexMovement(
      id: jsonSerialization['id'] as int?,
      itemId: jsonSerialization['itemId'] as int,
      itemName: jsonSerialization['itemName'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      movementType: jsonSerialization['movementType'] as String,
      referenceDoc: jsonSerialization['referenceDoc'] as String,
      workOrderId: jsonSerialization['workOrderId'] as int?,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unitCost: (jsonSerialization['unitCost'] as num).toDouble(),
      totalCost: (jsonSerialization['totalCost'] as num).toDouble(),
      balanceQuantity: (jsonSerialization['balanceQuantity'] as num).toDouble(),
      balanceTotalCost: (jsonSerialization['balanceTotalCost'] as num)
          .toDouble(),
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// ID del item de inventario relacionado (OpsInventoryItem).
  int itemId;

  /// Nombre o código del item para trazabilidad rápida.
  String itemName;

  /// Fecha del movimiento contable de inventario.
  DateTime date;

  /// Tipo: IN_PURCHASE (Compra), OUT_WORK_ORDER (Uso en OT), IN_ADJUSTMENT (Ajuste +), OUT_ADJUSTMENT (Ajuste -).
  String movementType;

  /// Documento de referencia (ej. Factura Compra #123, OT #45, Acta de Inventario).
  String referenceDoc;

  /// ID de Orden de Trabajo vinculada si aplica.
  int? workOrderId;

  /// Cantidad física que ingresa o egresa.
  double quantity;

  /// Costo unitario ponderado del movimiento.
  double unitCost;

  /// Costo total del movimiento monetario.
  double totalCost;

  /// Saldo de cantidad en inventario tras el movimiento.
  double balanceQuantity;

  /// Valoración monetaria total del inventario tras el movimiento.
  double balanceTotalCost;

  /// Notas adicionales o justificación.
  String? notes;

  /// Fechas de auditoría.
  DateTime createdAt;

  /// Returns a shallow copy of this [AccountingKardexMovement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingKardexMovement copyWith({
    int? id,
    int? itemId,
    String? itemName,
    DateTime? date,
    String? movementType,
    String? referenceDoc,
    int? workOrderId,
    double? quantity,
    double? unitCost,
    double? totalCost,
    double? balanceQuantity,
    double? balanceTotalCost,
    String? notes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingKardexMovement',
      if (id != null) 'id': id,
      'itemId': itemId,
      'itemName': itemName,
      'date': date.toJson(),
      'movementType': movementType,
      'referenceDoc': referenceDoc,
      if (workOrderId != null) 'workOrderId': workOrderId,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'balanceQuantity': balanceQuantity,
      'balanceTotalCost': balanceTotalCost,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingKardexMovementImpl extends AccountingKardexMovement {
  _AccountingKardexMovementImpl({
    int? id,
    required int itemId,
    required String itemName,
    required DateTime date,
    required String movementType,
    required String referenceDoc,
    int? workOrderId,
    required double quantity,
    required double unitCost,
    required double totalCost,
    required double balanceQuantity,
    required double balanceTotalCost,
    String? notes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         itemId: itemId,
         itemName: itemName,
         date: date,
         movementType: movementType,
         referenceDoc: referenceDoc,
         workOrderId: workOrderId,
         quantity: quantity,
         unitCost: unitCost,
         totalCost: totalCost,
         balanceQuantity: balanceQuantity,
         balanceTotalCost: balanceTotalCost,
         notes: notes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccountingKardexMovement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingKardexMovement copyWith({
    Object? id = _Undefined,
    int? itemId,
    String? itemName,
    DateTime? date,
    String? movementType,
    String? referenceDoc,
    Object? workOrderId = _Undefined,
    double? quantity,
    double? unitCost,
    double? totalCost,
    double? balanceQuantity,
    double? balanceTotalCost,
    Object? notes = _Undefined,
    DateTime? createdAt,
  }) {
    return AccountingKardexMovement(
      id: id is int? ? id : this.id,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      date: date ?? this.date,
      movementType: movementType ?? this.movementType,
      referenceDoc: referenceDoc ?? this.referenceDoc,
      workOrderId: workOrderId is int? ? workOrderId : this.workOrderId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      totalCost: totalCost ?? this.totalCost,
      balanceQuantity: balanceQuantity ?? this.balanceQuantity,
      balanceTotalCost: balanceTotalCost ?? this.balanceTotalCost,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
