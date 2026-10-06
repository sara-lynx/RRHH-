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

/// Partida o línea de cotización dentro de una oportunidad comercial.
abstract class CrmQuoteItem implements _i1.SerializableModel {
  CrmQuoteItem._({
    this.id,
    required this.opportunityId,
    this.catalogItemId,
    this.catalogVersion,
    required this.category,
    required this.concept,
    String? calculationType,
    required this.unitType,
    required this.quantity,
    required this.unitPrice,
    this.metadata,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : calculationType = calculationType ?? 'PER_UNIT',
       isDeleted = isDeleted ?? false;

  factory CrmQuoteItem({
    int? id,
    required int opportunityId,
    int? catalogItemId,
    int? catalogVersion,
    required String category,
    required String concept,
    String? calculationType,
    required String unitType,
    required double quantity,
    required double unitPrice,
    String? metadata,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmQuoteItemImpl;

  factory CrmQuoteItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmQuoteItem(
      id: jsonSerialization['id'] as int?,
      opportunityId: jsonSerialization['opportunityId'] as int,
      catalogItemId: jsonSerialization['catalogItemId'] as int?,
      catalogVersion: jsonSerialization['catalogVersion'] as int?,
      category: jsonSerialization['category'] as String,
      concept: jsonSerialization['concept'] as String,
      calculationType: jsonSerialization['calculationType'] as String?,
      unitType: jsonSerialization['unitType'] as String,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      metadata: jsonSerialization['metadata'] as String?,
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

  /// ID de la oportunidad a la que pertenece la cotización.
  int opportunityId;

  /// ID opcional de la partida de catálogo de origen (sin join estricto obligatorio).
  int? catalogItemId;

  /// Versión de la partida al momento de cotizar.
  int? catalogVersion;

  /// Categoría: Personal, Limpieza, Mantenimiento, Equipamiento, Materiales, Tecnología.
  String category;

  /// Concepto descriptivo del servicio o insumo.
  String concept;

  /// Tipo de cálculo congelado al cotizar.
  String calculationType;

  /// Tipo de unidad: Puesto 24/7, Puesto 12h, Operario, Global, m², Unid., Servicio, Kit, Tanque.
  String unitType;

  /// Cantidad requerida.
  double quantity;

  /// Precio unitario congelado en Bs.
  double unitPrice;

  /// Parámetros auxiliares congelados en formato JSON.
  String? metadata;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmQuoteItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmQuoteItem copyWith({
    int? id,
    int? opportunityId,
    int? catalogItemId,
    int? catalogVersion,
    String? category,
    String? concept,
    String? calculationType,
    String? unitType,
    double? quantity,
    double? unitPrice,
    String? metadata,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmQuoteItem',
      if (id != null) 'id': id,
      'opportunityId': opportunityId,
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      if (catalogVersion != null) 'catalogVersion': catalogVersion,
      'category': category,
      'concept': concept,
      'calculationType': calculationType,
      'unitType': unitType,
      'quantity': quantity,
      'unitPrice': unitPrice,
      if (metadata != null) 'metadata': metadata,
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

class _CrmQuoteItemImpl extends CrmQuoteItem {
  _CrmQuoteItemImpl({
    int? id,
    required int opportunityId,
    int? catalogItemId,
    int? catalogVersion,
    required String category,
    required String concept,
    String? calculationType,
    required String unitType,
    required double quantity,
    required double unitPrice,
    String? metadata,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         opportunityId: opportunityId,
         catalogItemId: catalogItemId,
         catalogVersion: catalogVersion,
         category: category,
         concept: concept,
         calculationType: calculationType,
         unitType: unitType,
         quantity: quantity,
         unitPrice: unitPrice,
         metadata: metadata,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmQuoteItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmQuoteItem copyWith({
    Object? id = _Undefined,
    int? opportunityId,
    Object? catalogItemId = _Undefined,
    Object? catalogVersion = _Undefined,
    String? category,
    String? concept,
    String? calculationType,
    String? unitType,
    double? quantity,
    double? unitPrice,
    Object? metadata = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmQuoteItem(
      id: id is int? ? id : this.id,
      opportunityId: opportunityId ?? this.opportunityId,
      catalogItemId: catalogItemId is int? ? catalogItemId : this.catalogItemId,
      catalogVersion: catalogVersion is int?
          ? catalogVersion
          : this.catalogVersion,
      category: category ?? this.category,
      concept: concept ?? this.concept,
      calculationType: calculationType ?? this.calculationType,
      unitType: unitType ?? this.unitType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      metadata: metadata is String? ? metadata : this.metadata,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
