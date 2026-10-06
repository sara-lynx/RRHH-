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

/// Resumen y costeo de rentabilidad por Orden de Trabajo / Servicio.
abstract class AccountingWorkOrderCostSummary implements _i1.SerializableModel {
  AccountingWorkOrderCostSummary._({
    required this.workOrderId,
    required this.workOrderDate,
    required this.workOrderStatus,
    required this.contractId,
    this.clientName,
    this.serviceDescription,
    required this.materialsCost,
    required this.laborCost,
    required this.otherExpenses,
    required this.totalCost,
    required this.invoicedAmount,
    required this.grossMargin,
    required this.grossMarginPercentage,
    required this.isBilled,
    this.invoiceId,
  });

  factory AccountingWorkOrderCostSummary({
    required int workOrderId,
    required DateTime workOrderDate,
    required String workOrderStatus,
    required int contractId,
    String? clientName,
    String? serviceDescription,
    required double materialsCost,
    required double laborCost,
    required double otherExpenses,
    required double totalCost,
    required double invoicedAmount,
    required double grossMargin,
    required double grossMarginPercentage,
    required bool isBilled,
    int? invoiceId,
  }) = _AccountingWorkOrderCostSummaryImpl;

  factory AccountingWorkOrderCostSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingWorkOrderCostSummary(
      workOrderId: jsonSerialization['workOrderId'] as int,
      workOrderDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['workOrderDate'],
      ),
      workOrderStatus: jsonSerialization['workOrderStatus'] as String,
      contractId: jsonSerialization['contractId'] as int,
      clientName: jsonSerialization['clientName'] as String?,
      serviceDescription: jsonSerialization['serviceDescription'] as String?,
      materialsCost: (jsonSerialization['materialsCost'] as num).toDouble(),
      laborCost: (jsonSerialization['laborCost'] as num).toDouble(),
      otherExpenses: (jsonSerialization['otherExpenses'] as num).toDouble(),
      totalCost: (jsonSerialization['totalCost'] as num).toDouble(),
      invoicedAmount: (jsonSerialization['invoicedAmount'] as num).toDouble(),
      grossMargin: (jsonSerialization['grossMargin'] as num).toDouble(),
      grossMarginPercentage: (jsonSerialization['grossMarginPercentage'] as num)
          .toDouble(),
      isBilled: _i1.BoolJsonExtension.fromJson(jsonSerialization['isBilled']),
      invoiceId: jsonSerialization['invoiceId'] as int?,
    );
  }

  int workOrderId;

  DateTime workOrderDate;

  String workOrderStatus;

  int contractId;

  String? clientName;

  String? serviceDescription;

  double materialsCost;

  double laborCost;

  double otherExpenses;

  double totalCost;

  double invoicedAmount;

  double grossMargin;

  double grossMarginPercentage;

  bool isBilled;

  int? invoiceId;

  /// Returns a shallow copy of this [AccountingWorkOrderCostSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingWorkOrderCostSummary copyWith({
    int? workOrderId,
    DateTime? workOrderDate,
    String? workOrderStatus,
    int? contractId,
    String? clientName,
    String? serviceDescription,
    double? materialsCost,
    double? laborCost,
    double? otherExpenses,
    double? totalCost,
    double? invoicedAmount,
    double? grossMargin,
    double? grossMarginPercentage,
    bool? isBilled,
    int? invoiceId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingWorkOrderCostSummary',
      'workOrderId': workOrderId,
      'workOrderDate': workOrderDate.toJson(),
      'workOrderStatus': workOrderStatus,
      'contractId': contractId,
      if (clientName != null) 'clientName': clientName,
      if (serviceDescription != null) 'serviceDescription': serviceDescription,
      'materialsCost': materialsCost,
      'laborCost': laborCost,
      'otherExpenses': otherExpenses,
      'totalCost': totalCost,
      'invoicedAmount': invoicedAmount,
      'grossMargin': grossMargin,
      'grossMarginPercentage': grossMarginPercentage,
      'isBilled': isBilled,
      if (invoiceId != null) 'invoiceId': invoiceId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountingWorkOrderCostSummaryImpl
    extends AccountingWorkOrderCostSummary {
  _AccountingWorkOrderCostSummaryImpl({
    required int workOrderId,
    required DateTime workOrderDate,
    required String workOrderStatus,
    required int contractId,
    String? clientName,
    String? serviceDescription,
    required double materialsCost,
    required double laborCost,
    required double otherExpenses,
    required double totalCost,
    required double invoicedAmount,
    required double grossMargin,
    required double grossMarginPercentage,
    required bool isBilled,
    int? invoiceId,
  }) : super._(
         workOrderId: workOrderId,
         workOrderDate: workOrderDate,
         workOrderStatus: workOrderStatus,
         contractId: contractId,
         clientName: clientName,
         serviceDescription: serviceDescription,
         materialsCost: materialsCost,
         laborCost: laborCost,
         otherExpenses: otherExpenses,
         totalCost: totalCost,
         invoicedAmount: invoicedAmount,
         grossMargin: grossMargin,
         grossMarginPercentage: grossMarginPercentage,
         isBilled: isBilled,
         invoiceId: invoiceId,
       );

  /// Returns a shallow copy of this [AccountingWorkOrderCostSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingWorkOrderCostSummary copyWith({
    int? workOrderId,
    DateTime? workOrderDate,
    String? workOrderStatus,
    int? contractId,
    Object? clientName = _Undefined,
    Object? serviceDescription = _Undefined,
    double? materialsCost,
    double? laborCost,
    double? otherExpenses,
    double? totalCost,
    double? invoicedAmount,
    double? grossMargin,
    double? grossMarginPercentage,
    bool? isBilled,
    Object? invoiceId = _Undefined,
  }) {
    return AccountingWorkOrderCostSummary(
      workOrderId: workOrderId ?? this.workOrderId,
      workOrderDate: workOrderDate ?? this.workOrderDate,
      workOrderStatus: workOrderStatus ?? this.workOrderStatus,
      contractId: contractId ?? this.contractId,
      clientName: clientName is String? ? clientName : this.clientName,
      serviceDescription: serviceDescription is String?
          ? serviceDescription
          : this.serviceDescription,
      materialsCost: materialsCost ?? this.materialsCost,
      laborCost: laborCost ?? this.laborCost,
      otherExpenses: otherExpenses ?? this.otherExpenses,
      totalCost: totalCost ?? this.totalCost,
      invoicedAmount: invoicedAmount ?? this.invoicedAmount,
      grossMargin: grossMargin ?? this.grossMargin,
      grossMarginPercentage:
          grossMarginPercentage ?? this.grossMarginPercentage,
      isBilled: isBilled ?? this.isBilled,
      invoiceId: invoiceId is int? ? invoiceId : this.invoiceId,
    );
  }
}
