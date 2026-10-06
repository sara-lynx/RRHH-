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

/// Partida maestra del catálogo y tarifario de servicios.
abstract class CrmCatalogItem implements _i1.SerializableModel {
  CrmCatalogItem._({
    this.id,
    required this.code,
    required this.category,
    required this.serviceLineId,
    required this.concept,
    required this.calculationType,
    required this.unitType,
    required this.basePrice,
    double? minQuantity,
    int? version,
    this.metadata,
    this.description,
    bool? isActive,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : minQuantity = minQuantity ?? 1.0,
       version = version ?? 1,
       isActive = isActive ?? true,
       isDeleted = isDeleted ?? false;

  factory CrmCatalogItem({
    int? id,
    required String code,
    required String category,
    required int serviceLineId,
    required String concept,
    required String calculationType,
    required String unitType,
    required double basePrice,
    double? minQuantity,
    int? version,
    String? metadata,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCatalogItemImpl;

  factory CrmCatalogItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCatalogItem(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      category: jsonSerialization['category'] as String,
      serviceLineId: jsonSerialization['serviceLineId'] as int,
      concept: jsonSerialization['concept'] as String,
      calculationType: jsonSerialization['calculationType'] as String,
      unitType: jsonSerialization['unitType'] as String,
      basePrice: (jsonSerialization['basePrice'] as num).toDouble(),
      minQuantity: (jsonSerialization['minQuantity'] as num?)?.toDouble(),
      version: jsonSerialization['version'] as int?,
      metadata: jsonSerialization['metadata'] as String?,
      description: jsonSerialization['description'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
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

  /// Código identificador de la partida (ej: CAT-LIMP-M2, CAT-VIG-247).
  String code;

  /// Categoría principal: Personal, Limpieza, Mantenimiento, Equipamiento, Tecnología.
  String category;

  /// Línea de servicio a la que pertenece la partida.
  int serviceLineId;

  /// Concepto descriptivo del servicio o partida.
  String concept;

  /// Tipo de cálculo: FIXED, PER_UNIT, PER_HOUR, PER_AREA, PER_POSITION, GLOBAL.
  String calculationType;

  /// Unidad de medida: m², Hora, Puesto 24/7, Puesto 12h, Operario, Tanque, Global, Unid., Kit.
  String unitType;

  /// Precio base de referencia vigente en Bolivianos (Bs.).
  double basePrice;

  /// Cantidad mínima requerida por orden o contrato.
  double minQuantity;

  /// Versión de la partida (incrementa ante cualquier cambio que altere el cálculo).
  int version;

  /// Parámetros auxiliares serializados en formato JSON (ej. turnos, horas, rendimiento).
  String? metadata;

  /// Especificación o alcance detallado.
  String? description;

  /// Estado operativo.
  bool isActive;

  /// Eliminación lógica y auditoría temporal.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmCatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCatalogItem copyWith({
    int? id,
    String? code,
    String? category,
    int? serviceLineId,
    String? concept,
    String? calculationType,
    String? unitType,
    double? basePrice,
    double? minQuantity,
    int? version,
    String? metadata,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCatalogItem',
      if (id != null) 'id': id,
      'code': code,
      'category': category,
      'serviceLineId': serviceLineId,
      'concept': concept,
      'calculationType': calculationType,
      'unitType': unitType,
      'basePrice': basePrice,
      'minQuantity': minQuantity,
      'version': version,
      if (metadata != null) 'metadata': metadata,
      if (description != null) 'description': description,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
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

class _CrmCatalogItemImpl extends CrmCatalogItem {
  _CrmCatalogItemImpl({
    int? id,
    required String code,
    required String category,
    required int serviceLineId,
    required String concept,
    required String calculationType,
    required String unitType,
    required double basePrice,
    double? minQuantity,
    int? version,
    String? metadata,
    String? description,
    bool? isActive,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         category: category,
         serviceLineId: serviceLineId,
         concept: concept,
         calculationType: calculationType,
         unitType: unitType,
         basePrice: basePrice,
         minQuantity: minQuantity,
         version: version,
         metadata: metadata,
         description: description,
         isActive: isActive,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCatalogItem copyWith({
    Object? id = _Undefined,
    String? code,
    String? category,
    int? serviceLineId,
    String? concept,
    String? calculationType,
    String? unitType,
    double? basePrice,
    double? minQuantity,
    int? version,
    Object? metadata = _Undefined,
    Object? description = _Undefined,
    bool? isActive,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCatalogItem(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      category: category ?? this.category,
      serviceLineId: serviceLineId ?? this.serviceLineId,
      concept: concept ?? this.concept,
      calculationType: calculationType ?? this.calculationType,
      unitType: unitType ?? this.unitType,
      basePrice: basePrice ?? this.basePrice,
      minQuantity: minQuantity ?? this.minQuantity,
      version: version ?? this.version,
      metadata: metadata is String? ? metadata : this.metadata,
      description: description is String? ? description : this.description,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
