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
import '../../../modules/crm/models/crm_customer.dart' as _i2;
import '../../../modules/crm/models/crm_customer_branch.dart' as _i3;
import '../../../modules/crm/models/crm_customer_contract.dart' as _i4;
import '../../../modules/crm/models/crm_contract_budget_item.dart' as _i5;
import 'package:elite_multiservicios_client/src/protocol/protocol.dart' as _i6;

/// DTO que contiene la ficha completa de un cliente con sus sedes y contratos.
abstract class CrmCustomerDetailResponse implements _i1.SerializableModel {
  CrmCustomerDetailResponse._({
    required this.customer,
    required this.branches,
    required this.contracts,
    required this.budgetItems,
  });

  factory CrmCustomerDetailResponse({
    required _i2.CrmCustomer customer,
    required List<_i3.CrmCustomerBranch> branches,
    required List<_i4.CrmCustomerContract> contracts,
    required List<_i5.CrmContractBudgetItem> budgetItems,
  }) = _CrmCustomerDetailResponseImpl;

  factory CrmCustomerDetailResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmCustomerDetailResponse(
      customer: _i6.Protocol().deserialize<_i2.CrmCustomer>(
        jsonSerialization['customer'],
      ),
      branches: _i6.Protocol().deserialize<List<_i3.CrmCustomerBranch>>(
        jsonSerialization['branches'],
      ),
      contracts: _i6.Protocol().deserialize<List<_i4.CrmCustomerContract>>(
        jsonSerialization['contracts'],
      ),
      budgetItems: _i6.Protocol().deserialize<List<_i5.CrmContractBudgetItem>>(
        jsonSerialization['budgetItems'],
      ),
    );
  }

  /// Datos generales del cliente.
  _i2.CrmCustomer customer;

  /// Sedes operativas activas vinculadas.
  List<_i3.CrmCustomerBranch> branches;

  /// Contratos u órdenes de trabajo asociadas.
  List<_i4.CrmCustomerContract> contracts;

  /// Partidas presupuestarias asociadas a los contratos.
  List<_i5.CrmContractBudgetItem> budgetItems;

  /// Returns a shallow copy of this [CrmCustomerDetailResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomerDetailResponse copyWith({
    _i2.CrmCustomer? customer,
    List<_i3.CrmCustomerBranch>? branches,
    List<_i4.CrmCustomerContract>? contracts,
    List<_i5.CrmContractBudgetItem>? budgetItems,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomerDetailResponse',
      'customer': customer.toJson(),
      'branches': branches.toJson(valueToJson: (v) => v.toJson()),
      'contracts': contracts.toJson(valueToJson: (v) => v.toJson()),
      'budgetItems': budgetItems.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CrmCustomerDetailResponseImpl extends CrmCustomerDetailResponse {
  _CrmCustomerDetailResponseImpl({
    required _i2.CrmCustomer customer,
    required List<_i3.CrmCustomerBranch> branches,
    required List<_i4.CrmCustomerContract> contracts,
    required List<_i5.CrmContractBudgetItem> budgetItems,
  }) : super._(
         customer: customer,
         branches: branches,
         contracts: contracts,
         budgetItems: budgetItems,
       );

  /// Returns a shallow copy of this [CrmCustomerDetailResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomerDetailResponse copyWith({
    _i2.CrmCustomer? customer,
    List<_i3.CrmCustomerBranch>? branches,
    List<_i4.CrmCustomerContract>? contracts,
    List<_i5.CrmContractBudgetItem>? budgetItems,
  }) {
    return CrmCustomerDetailResponse(
      customer: customer ?? this.customer.copyWith(),
      branches: branches ?? this.branches.map((e0) => e0.copyWith()).toList(),
      contracts:
          contracts ?? this.contracts.map((e0) => e0.copyWith()).toList(),
      budgetItems:
          budgetItems ?? this.budgetItems.map((e0) => e0.copyWith()).toList(),
    );
  }
}
