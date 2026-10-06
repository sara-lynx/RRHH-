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

/// Deducción o retención asignada al colaborador (Contrato / Nómina).
abstract class RrhhEmployeeDeduction implements _i1.SerializableModel {
  RrhhEmployeeDeduction._({
    required this.code,
    required this.name,
    required this.type,
    this.amount,
    bool? isPercentage,
    this.applyFrom,
    this.applyTo,
  }) : isPercentage = isPercentage ?? false;

  factory RrhhEmployeeDeduction({
    required String code,
    required String name,
    required String type,
    double? amount,
    bool? isPercentage,
    DateTime? applyFrom,
    DateTime? applyTo,
  }) = _RrhhEmployeeDeductionImpl;

  factory RrhhEmployeeDeduction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhEmployeeDeduction(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      amount: (jsonSerialization['amount'] as num?)?.toDouble(),
      isPercentage: jsonSerialization['isPercentage'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPercentage']),
      applyFrom: jsonSerialization['applyFrom'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['applyFrom']),
      applyTo: jsonSerialization['applyTo'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['applyTo']),
    );
  }

  /// Código institucional de la deducción (ej: DESC-001).
  String code;

  /// Nombre o concepto del descuento (ej: Aporte Laboral SIP).
  String name;

  /// Tipo de descuento: 'Fijo' | 'Porcentaje' | 'Por evento'.
  String type;

  /// Monto en Bs o valor numérico.
  double? amount;

  /// Verdadero si el monto representa un porcentaje.
  bool isPercentage;

  /// Fecha desde la que aplica la deducción.
  DateTime? applyFrom;

  /// Fecha hasta la que aplica la deducción (opcional).
  DateTime? applyTo;

  /// Returns a shallow copy of this [RrhhEmployeeDeduction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhEmployeeDeduction copyWith({
    String? code,
    String? name,
    String? type,
    double? amount,
    bool? isPercentage,
    DateTime? applyFrom,
    DateTime? applyTo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhEmployeeDeduction',
      'code': code,
      'name': name,
      'type': type,
      if (amount != null) 'amount': amount,
      'isPercentage': isPercentage,
      if (applyFrom != null) 'applyFrom': applyFrom?.toJson(),
      if (applyTo != null) 'applyTo': applyTo?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhEmployeeDeductionImpl extends RrhhEmployeeDeduction {
  _RrhhEmployeeDeductionImpl({
    required String code,
    required String name,
    required String type,
    double? amount,
    bool? isPercentage,
    DateTime? applyFrom,
    DateTime? applyTo,
  }) : super._(
         code: code,
         name: name,
         type: type,
         amount: amount,
         isPercentage: isPercentage,
         applyFrom: applyFrom,
         applyTo: applyTo,
       );

  /// Returns a shallow copy of this [RrhhEmployeeDeduction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhEmployeeDeduction copyWith({
    String? code,
    String? name,
    String? type,
    Object? amount = _Undefined,
    bool? isPercentage,
    Object? applyFrom = _Undefined,
    Object? applyTo = _Undefined,
  }) {
    return RrhhEmployeeDeduction(
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount is double? ? amount : this.amount,
      isPercentage: isPercentage ?? this.isPercentage,
      applyFrom: applyFrom is DateTime? ? applyFrom : this.applyFrom,
      applyTo: applyTo is DateTime? ? applyTo : this.applyTo,
    );
  }
}
