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

/// Alcance y precio diferenciado de una partida de catálogo para un sector o rubro.
abstract class CrmCatalogItemScope implements _i1.SerializableModel {
  CrmCatalogItemScope._({
    this.id,
    required this.catalogItemId,
    required this.sectorId,
    this.serviceLineId,
    this.priceOverride,
    this.minQuantityOverride,
    this.metadataOverride,
    bool? isActive,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmCatalogItemScope({
    int? id,
    required int catalogItemId,
    required int sectorId,
    int? serviceLineId,
    double? priceOverride,
    double? minQuantityOverride,
    String? metadataOverride,
    bool? isActive,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCatalogItemScopeImpl;

  factory CrmCatalogItemScope.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCatalogItemScope(
      id: jsonSerialization['id'] as int?,
      catalogItemId: jsonSerialization['catalogItemId'] as int,
      sectorId: jsonSerialization['sectorId'] as int,
      serviceLineId: jsonSerialization['serviceLineId'] as int?,
      priceOverride: (jsonSerialization['priceOverride'] as num?)?.toDouble(),
      minQuantityOverride: (jsonSerialization['minQuantityOverride'] as num?)
          ?.toDouble(),
      metadataOverride: jsonSerialization['metadataOverride'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
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

  /// Partida de catálogo sobre la que aplica la diferenciación.
  int catalogItemId;

  /// Sector o Rubro industrial al que aplica este override.
  int sectorId;

  /// Línea de servicio opcional.
  int? serviceLineId;

  /// Precio diferenciado o sobreescrito para este rubro en Bs.
  double? priceOverride;

  /// Cantidad mínima diferenciada.
  double? minQuantityOverride;

  /// Parámetros auxiliares JSON sobreescritos para este sector.
  String? metadataOverride;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmCatalogItemScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCatalogItemScope copyWith({
    int? id,
    int? catalogItemId,
    int? sectorId,
    int? serviceLineId,
    double? priceOverride,
    double? minQuantityOverride,
    String? metadataOverride,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCatalogItemScope',
      if (id != null) 'id': id,
      'catalogItemId': catalogItemId,
      'sectorId': sectorId,
      if (serviceLineId != null) 'serviceLineId': serviceLineId,
      if (priceOverride != null) 'priceOverride': priceOverride,
      if (minQuantityOverride != null)
        'minQuantityOverride': minQuantityOverride,
      if (metadataOverride != null) 'metadataOverride': metadataOverride,
      'isActive': isActive,
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

class _CrmCatalogItemScopeImpl extends CrmCatalogItemScope {
  _CrmCatalogItemScopeImpl({
    int? id,
    required int catalogItemId,
    required int sectorId,
    int? serviceLineId,
    double? priceOverride,
    double? minQuantityOverride,
    String? metadataOverride,
    bool? isActive,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         catalogItemId: catalogItemId,
         sectorId: sectorId,
         serviceLineId: serviceLineId,
         priceOverride: priceOverride,
         minQuantityOverride: minQuantityOverride,
         metadataOverride: metadataOverride,
         isActive: isActive,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCatalogItemScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCatalogItemScope copyWith({
    Object? id = _Undefined,
    int? catalogItemId,
    int? sectorId,
    Object? serviceLineId = _Undefined,
    Object? priceOverride = _Undefined,
    Object? minQuantityOverride = _Undefined,
    Object? metadataOverride = _Undefined,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCatalogItemScope(
      id: id is int? ? id : this.id,
      catalogItemId: catalogItemId ?? this.catalogItemId,
      sectorId: sectorId ?? this.sectorId,
      serviceLineId: serviceLineId is int? ? serviceLineId : this.serviceLineId,
      priceOverride: priceOverride is double?
          ? priceOverride
          : this.priceOverride,
      minQuantityOverride: minQuantityOverride is double?
          ? minQuantityOverride
          : this.minQuantityOverride,
      metadataOverride: metadataOverride is String?
          ? metadataOverride
          : this.metadataOverride,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
