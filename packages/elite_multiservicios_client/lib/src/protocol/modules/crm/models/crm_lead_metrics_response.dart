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

/// Respuesta de métricas agregadas del submódulo de prospectos.
abstract class CrmLeadMetricsResponse implements _i1.SerializableModel {
  CrmLeadMetricsResponse._({
    required this.totalCount,
    required this.contactedCount,
    required this.waitingCount,
    required this.qualifiedCount,
    required this.hotCount,
    required this.conversionRate,
    required this.totalPipelinePotential,
  });

  factory CrmLeadMetricsResponse({
    required int totalCount,
    required int contactedCount,
    required int waitingCount,
    required int qualifiedCount,
    required int hotCount,
    required double conversionRate,
    required double totalPipelinePotential,
  }) = _CrmLeadMetricsResponseImpl;

  factory CrmLeadMetricsResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmLeadMetricsResponse(
      totalCount: jsonSerialization['totalCount'] as int,
      contactedCount: jsonSerialization['contactedCount'] as int,
      waitingCount: jsonSerialization['waitingCount'] as int,
      qualifiedCount: jsonSerialization['qualifiedCount'] as int,
      hotCount: jsonSerialization['hotCount'] as int,
      conversionRate: (jsonSerialization['conversionRate'] as num).toDouble(),
      totalPipelinePotential:
          (jsonSerialization['totalPipelinePotential'] as num).toDouble(),
    );
  }

  /// Total de prospectos activos.
  int totalCount;

  /// Total de prospectos contactados.
  int contactedCount;

  /// Total de prospectos en espera de respuesta.
  int waitingCount;

  /// Total de prospectos calificados o con interés confirmado.
  int qualifiedCount;

  /// Total de prospectos con temperatura caliente.
  int hotCount;

  /// Tasa de conversión comercial porcentual (0.0 - 100.0).
  double conversionRate;

  /// Valor económico potencial total de la cartera en Bs.
  double totalPipelinePotential;

  /// Returns a shallow copy of this [CrmLeadMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmLeadMetricsResponse copyWith({
    int? totalCount,
    int? contactedCount,
    int? waitingCount,
    int? qualifiedCount,
    int? hotCount,
    double? conversionRate,
    double? totalPipelinePotential,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmLeadMetricsResponse',
      'totalCount': totalCount,
      'contactedCount': contactedCount,
      'waitingCount': waitingCount,
      'qualifiedCount': qualifiedCount,
      'hotCount': hotCount,
      'conversionRate': conversionRate,
      'totalPipelinePotential': totalPipelinePotential,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CrmLeadMetricsResponseImpl extends CrmLeadMetricsResponse {
  _CrmLeadMetricsResponseImpl({
    required int totalCount,
    required int contactedCount,
    required int waitingCount,
    required int qualifiedCount,
    required int hotCount,
    required double conversionRate,
    required double totalPipelinePotential,
  }) : super._(
         totalCount: totalCount,
         contactedCount: contactedCount,
         waitingCount: waitingCount,
         qualifiedCount: qualifiedCount,
         hotCount: hotCount,
         conversionRate: conversionRate,
         totalPipelinePotential: totalPipelinePotential,
       );

  /// Returns a shallow copy of this [CrmLeadMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmLeadMetricsResponse copyWith({
    int? totalCount,
    int? contactedCount,
    int? waitingCount,
    int? qualifiedCount,
    int? hotCount,
    double? conversionRate,
    double? totalPipelinePotential,
  }) {
    return CrmLeadMetricsResponse(
      totalCount: totalCount ?? this.totalCount,
      contactedCount: contactedCount ?? this.contactedCount,
      waitingCount: waitingCount ?? this.waitingCount,
      qualifiedCount: qualifiedCount ?? this.qualifiedCount,
      hotCount: hotCount ?? this.hotCount,
      conversionRate: conversionRate ?? this.conversionRate,
      totalPipelinePotential:
          totalPipelinePotential ?? this.totalPipelinePotential,
    );
  }
}
