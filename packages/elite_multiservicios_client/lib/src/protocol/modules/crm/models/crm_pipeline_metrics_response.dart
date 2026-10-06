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

/// Métricas agregadas del embudo de ventas y Pipeline comercial.
abstract class CrmPipelineMetricsResponse implements _i1.SerializableModel {
  CrmPipelineMetricsResponse._({
    required this.totalOpportunities,
    required this.totalPipelineValue,
    required this.weightedValue,
    required this.qualificationCount,
    required this.technicalVisitCount,
    required this.proposalCount,
    required this.negotiationCount,
    required this.wonCount,
    required this.winRate,
  });

  factory CrmPipelineMetricsResponse({
    required int totalOpportunities,
    required double totalPipelineValue,
    required double weightedValue,
    required int qualificationCount,
    required int technicalVisitCount,
    required int proposalCount,
    required int negotiationCount,
    required int wonCount,
    required double winRate,
  }) = _CrmPipelineMetricsResponseImpl;

  factory CrmPipelineMetricsResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmPipelineMetricsResponse(
      totalOpportunities: jsonSerialization['totalOpportunities'] as int,
      totalPipelineValue: (jsonSerialization['totalPipelineValue'] as num)
          .toDouble(),
      weightedValue: (jsonSerialization['weightedValue'] as num).toDouble(),
      qualificationCount: jsonSerialization['qualificationCount'] as int,
      technicalVisitCount: jsonSerialization['technicalVisitCount'] as int,
      proposalCount: jsonSerialization['proposalCount'] as int,
      negotiationCount: jsonSerialization['negotiationCount'] as int,
      wonCount: jsonSerialization['wonCount'] as int,
      winRate: (jsonSerialization['winRate'] as num).toDouble(),
    );
  }

  /// Total de oportunidades activas en el embudo.
  int totalOpportunities;

  /// Valor económico total del pipeline en Bs.
  double totalPipelineValue;

  /// Valor económico ponderado por probabilidad de cierre en Bs.
  double weightedValue;

  /// Oportunidades en etapa de Calificación.
  int qualificationCount;

  /// Oportunidades en etapa de Visita Técnica.
  int technicalVisitCount;

  /// Oportunidades en etapa de Propuesta.
  int proposalCount;

  /// Oportunidades en etapa de Negociación.
  int negotiationCount;

  /// Oportunidades cerradas como Ganadas.
  int wonCount;

  /// Tasa de cierre o conversión porcentual (0.0 - 100.0).
  double winRate;

  /// Returns a shallow copy of this [CrmPipelineMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmPipelineMetricsResponse copyWith({
    int? totalOpportunities,
    double? totalPipelineValue,
    double? weightedValue,
    int? qualificationCount,
    int? technicalVisitCount,
    int? proposalCount,
    int? negotiationCount,
    int? wonCount,
    double? winRate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmPipelineMetricsResponse',
      'totalOpportunities': totalOpportunities,
      'totalPipelineValue': totalPipelineValue,
      'weightedValue': weightedValue,
      'qualificationCount': qualificationCount,
      'technicalVisitCount': technicalVisitCount,
      'proposalCount': proposalCount,
      'negotiationCount': negotiationCount,
      'wonCount': wonCount,
      'winRate': winRate,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CrmPipelineMetricsResponseImpl extends CrmPipelineMetricsResponse {
  _CrmPipelineMetricsResponseImpl({
    required int totalOpportunities,
    required double totalPipelineValue,
    required double weightedValue,
    required int qualificationCount,
    required int technicalVisitCount,
    required int proposalCount,
    required int negotiationCount,
    required int wonCount,
    required double winRate,
  }) : super._(
         totalOpportunities: totalOpportunities,
         totalPipelineValue: totalPipelineValue,
         weightedValue: weightedValue,
         qualificationCount: qualificationCount,
         technicalVisitCount: technicalVisitCount,
         proposalCount: proposalCount,
         negotiationCount: negotiationCount,
         wonCount: wonCount,
         winRate: winRate,
       );

  /// Returns a shallow copy of this [CrmPipelineMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmPipelineMetricsResponse copyWith({
    int? totalOpportunities,
    double? totalPipelineValue,
    double? weightedValue,
    int? qualificationCount,
    int? technicalVisitCount,
    int? proposalCount,
    int? negotiationCount,
    int? wonCount,
    double? winRate,
  }) {
    return CrmPipelineMetricsResponse(
      totalOpportunities: totalOpportunities ?? this.totalOpportunities,
      totalPipelineValue: totalPipelineValue ?? this.totalPipelineValue,
      weightedValue: weightedValue ?? this.weightedValue,
      qualificationCount: qualificationCount ?? this.qualificationCount,
      technicalVisitCount: technicalVisitCount ?? this.technicalVisitCount,
      proposalCount: proposalCount ?? this.proposalCount,
      negotiationCount: negotiationCount ?? this.negotiationCount,
      wonCount: wonCount ?? this.wonCount,
      winRate: winRate ?? this.winRate,
    );
  }
}
