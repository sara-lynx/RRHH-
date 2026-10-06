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

/// Métricas consolidadas del módulo de clientes en tiempo real.
abstract class CrmCustomerMetricsResponse implements _i1.SerializableModel {
  CrmCustomerMetricsResponse._({
    required this.totalActiveCustomers,
    required this.totalMrr,
    required this.totalProjectVolume,
    required this.totalBranches,
    required this.totalContracts,
    required this.totalB2b,
    required this.totalB2c,
    required this.expiringContractsCount,
    required this.readyToRenewCount,
  });

  factory CrmCustomerMetricsResponse({
    required int totalActiveCustomers,
    required double totalMrr,
    required double totalProjectVolume,
    required int totalBranches,
    required int totalContracts,
    required int totalB2b,
    required int totalB2c,
    required int expiringContractsCount,
    required int readyToRenewCount,
  }) = _CrmCustomerMetricsResponseImpl;

  factory CrmCustomerMetricsResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmCustomerMetricsResponse(
      totalActiveCustomers: jsonSerialization['totalActiveCustomers'] as int,
      totalMrr: (jsonSerialization['totalMrr'] as num).toDouble(),
      totalProjectVolume: (jsonSerialization['totalProjectVolume'] as num)
          .toDouble(),
      totalBranches: jsonSerialization['totalBranches'] as int,
      totalContracts: jsonSerialization['totalContracts'] as int,
      totalB2b: jsonSerialization['totalB2b'] as int,
      totalB2c: jsonSerialization['totalB2c'] as int,
      expiringContractsCount:
          jsonSerialization['expiringContractsCount'] as int,
      readyToRenewCount: jsonSerialization['readyToRenewCount'] as int,
    );
  }

  /// Total de clientes en estado Activo.
  int totalActiveCustomers;

  /// Facturación mensual recurrente global (MRR) en Bs.
  double totalMrr;

  /// Volumen total acumulado de proyectos y eventos en Bs.
  double totalProjectVolume;

  /// Total de sedes operativas registradas.
  int totalBranches;

  /// Total de contratos registrados.
  int totalContracts;

  /// Total de cuentas Corporativo B2B.
  int totalB2b;

  /// Total de cuentas Residencial B2C.
  int totalB2c;

  /// Contratos próximos a vencer.
  int expiringContractsCount;

  /// Contratos listos para recontratar.
  int readyToRenewCount;

  /// Returns a shallow copy of this [CrmCustomerMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomerMetricsResponse copyWith({
    int? totalActiveCustomers,
    double? totalMrr,
    double? totalProjectVolume,
    int? totalBranches,
    int? totalContracts,
    int? totalB2b,
    int? totalB2c,
    int? expiringContractsCount,
    int? readyToRenewCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomerMetricsResponse',
      'totalActiveCustomers': totalActiveCustomers,
      'totalMrr': totalMrr,
      'totalProjectVolume': totalProjectVolume,
      'totalBranches': totalBranches,
      'totalContracts': totalContracts,
      'totalB2b': totalB2b,
      'totalB2c': totalB2c,
      'expiringContractsCount': expiringContractsCount,
      'readyToRenewCount': readyToRenewCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CrmCustomerMetricsResponseImpl extends CrmCustomerMetricsResponse {
  _CrmCustomerMetricsResponseImpl({
    required int totalActiveCustomers,
    required double totalMrr,
    required double totalProjectVolume,
    required int totalBranches,
    required int totalContracts,
    required int totalB2b,
    required int totalB2c,
    required int expiringContractsCount,
    required int readyToRenewCount,
  }) : super._(
         totalActiveCustomers: totalActiveCustomers,
         totalMrr: totalMrr,
         totalProjectVolume: totalProjectVolume,
         totalBranches: totalBranches,
         totalContracts: totalContracts,
         totalB2b: totalB2b,
         totalB2c: totalB2c,
         expiringContractsCount: expiringContractsCount,
         readyToRenewCount: readyToRenewCount,
       );

  /// Returns a shallow copy of this [CrmCustomerMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomerMetricsResponse copyWith({
    int? totalActiveCustomers,
    double? totalMrr,
    double? totalProjectVolume,
    int? totalBranches,
    int? totalContracts,
    int? totalB2b,
    int? totalB2c,
    int? expiringContractsCount,
    int? readyToRenewCount,
  }) {
    return CrmCustomerMetricsResponse(
      totalActiveCustomers: totalActiveCustomers ?? this.totalActiveCustomers,
      totalMrr: totalMrr ?? this.totalMrr,
      totalProjectVolume: totalProjectVolume ?? this.totalProjectVolume,
      totalBranches: totalBranches ?? this.totalBranches,
      totalContracts: totalContracts ?? this.totalContracts,
      totalB2b: totalB2b ?? this.totalB2b,
      totalB2c: totalB2c ?? this.totalB2c,
      expiringContractsCount:
          expiringContractsCount ?? this.expiringContractsCount,
      readyToRenewCount: readyToRenewCount ?? this.readyToRenewCount,
    );
  }
}
