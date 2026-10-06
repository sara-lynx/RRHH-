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
import 'greetings/greeting.dart' as _i2;
import 'modules/accounting/models/accounting_budget.dart' as _i3;
import 'modules/accounting/models/accounting_cost_center.dart' as _i4;
import 'modules/accounting/models/accounting_exchange_rate.dart' as _i5;
import 'modules/accounting/models/accounting_expense.dart' as _i6;
import 'modules/accounting/models/accounting_financial_summary.dart' as _i7;
import 'modules/accounting/models/accounting_fixed_asset.dart' as _i8;
import 'modules/accounting/models/accounting_invoice.dart' as _i9;
import 'modules/accounting/models/accounting_kardex_movement.dart' as _i10;
import 'modules/accounting/models/accounting_ledger_account.dart' as _i11;
import 'modules/accounting/models/accounting_payroll_estimation.dart' as _i12;
import 'modules/accounting/models/accounting_period_closure.dart' as _i13;
import 'modules/accounting/models/accounting_petty_cash.dart' as _i14;
import 'modules/accounting/models/accounting_petty_cash_closure.dart' as _i15;
import 'modules/accounting/models/accounting_petty_cash_txn.dart' as _i16;
import 'modules/accounting/models/accounting_tax.dart' as _i17;
import 'modules/accounting/models/accounting_transaction.dart' as _i18;
import 'modules/accounting/models/accounting_work_order_cost_summary.dart'
    as _i19;
import 'modules/crm/models/crm_agenda_metrics_response.dart' as _i20;
import 'modules/crm/models/crm_catalog_item.dart' as _i21;
import 'modules/crm/models/crm_catalog_item_scope.dart' as _i22;
import 'modules/crm/models/crm_contract_budget_item.dart' as _i23;
import 'modules/crm/models/crm_customer.dart' as _i24;
import 'modules/crm/models/crm_customer_branch.dart' as _i25;
import 'modules/crm/models/crm_customer_contract.dart' as _i26;
import 'modules/crm/models/crm_customer_detail_response.dart' as _i27;
import 'modules/crm/models/crm_customer_metrics_response.dart' as _i28;
import 'modules/crm/models/crm_lead.dart' as _i29;
import 'modules/crm/models/crm_lead_metrics_response.dart' as _i30;
import 'modules/crm/models/crm_opportunity.dart' as _i31;
import 'modules/crm/models/crm_pipeline_metrics_response.dart' as _i32;
import 'modules/crm/models/crm_quote_item.dart' as _i33;
import 'modules/crm/models/crm_sector.dart' as _i34;
import 'modules/crm/models/crm_service_line.dart' as _i35;
import 'modules/crm/models/crm_task.dart' as _i36;
import 'modules/hr/models/hr_attendance.dart' as _i37;
import 'modules/hr/models/hr_employee.dart' as _i38;
import 'modules/hr/models/hr_payroll.dart' as _i39;
import 'modules/ops/models/ops_inventory_item.dart' as _i40;
import 'modules/ops/models/ops_inventory_usage.dart' as _i41;
import 'modules/ops/models/ops_service_contract.dart' as _i42;
import 'modules/ops/models/ops_work_order.dart' as _i43;
import 'modules/rrhh/models/rrhh_applicant.dart' as _i44;
import 'modules/rrhh/models/rrhh_area.dart' as _i45;
import 'modules/rrhh/models/rrhh_assignment.dart' as _i46;
import 'modules/rrhh/models/rrhh_dashboard_metrics_response.dart' as _i47;
import 'modules/rrhh/models/rrhh_dossier_document.dart' as _i48;
import 'modules/rrhh/models/rrhh_employee.dart' as _i49;
import 'modules/rrhh/models/rrhh_employee_bonus.dart' as _i50;
import 'modules/rrhh/models/rrhh_employee_contract_data.dart' as _i51;
import 'modules/rrhh/models/rrhh_employee_deduction.dart' as _i52;
import 'modules/rrhh/models/rrhh_employee_document.dart' as _i53;
import 'modules/rrhh/models/rrhh_employee_summary_dto.dart' as _i54;
import 'modules/rrhh/models/rrhh_hiring_dossier.dart' as _i55;
import 'modules/rrhh/models/rrhh_incident.dart' as _i56;
import 'modules/rrhh/models/rrhh_leave_request.dart' as _i57;
import 'modules/rrhh/models/rrhh_movement_history.dart' as _i58;
import 'modules/rrhh/models/rrhh_position.dart' as _i59;
import 'modules/rrhh/models/rrhh_recent_movement_dto.dart' as _i60;
import 'modules/rrhh/models/rrhh_schedule.dart' as _i61;
import 'modules/rrhh/models/rrhh_specialty.dart' as _i62;
import 'modules/rrhh/models/rrhh_termination.dart' as _i63;
import 'modules/rrhh/models/rrhh_timeline_event.dart' as _i64;
import 'modules/rrhh/models/rrhh_vacation.dart' as _i65;
import 'modules/security/models/app_permission.dart' as _i66;
import 'modules/security/models/app_role.dart' as _i67;
import 'modules/security/models/app_user.dart' as _i68;
import 'modules/security/models/audit_log.dart' as _i69;
import 'modules/security/models/audit_log_page_response.dart' as _i70;
import 'modules/security/models/mfa_challenge.dart' as _i71;
import 'modules/security/models/mfa_challenge_response.dart' as _i72;
import 'modules/security/models/mfa_verify_response.dart' as _i73;
import 'modules/security/models/role_permission.dart' as _i74;
import 'modules/security/models/trusted_device.dart' as _i75;
import 'modules/security/models/user_role.dart' as _i76;
import 'modules/security/models/user_session.dart' as _i77;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_cost_center.dart'
    as _i78;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_invoice.dart'
    as _i79;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_expense.dart'
    as _i80;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_petty_cash.dart'
    as _i81;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_petty_cash_txn.dart'
    as _i82;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_payroll_estimation.dart'
    as _i83;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_budget.dart'
    as _i84;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_transaction.dart'
    as _i85;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_fixed_asset.dart'
    as _i86;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_ledger_account.dart'
    as _i87;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_tax.dart'
    as _i88;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_period_closure.dart'
    as _i89;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_kardex_movement.dart'
    as _i90;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_work_order_cost_summary.dart'
    as _i91;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_task.dart'
    as _i92;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_sector.dart'
    as _i93;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_service_line.dart'
    as _i94;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_catalog_item.dart'
    as _i95;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_catalog_item_scope.dart'
    as _i96;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer.dart'
    as _i97;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_contract_budget_item.dart'
    as _i98;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i99;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_opportunity.dart'
    as _i100;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_quote_item.dart'
    as _i101;
import 'package:elite_multiservicios_client/src/protocol/modules/hr/models/hr_employee.dart'
    as _i102;
import 'package:elite_multiservicios_client/src/protocol/modules/hr/models/hr_attendance.dart'
    as _i103;
import 'package:elite_multiservicios_client/src/protocol/modules/hr/models/hr_payroll.dart'
    as _i104;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_inventory_item.dart'
    as _i105;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_service_contract.dart'
    as _i106;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_work_order.dart'
    as _i107;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_applicant.dart'
    as _i108;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_schedule.dart'
    as _i109;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_assignment.dart'
    as _i110;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_recent_movement_dto.dart'
    as _i111;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_hiring_dossier.dart'
    as _i112;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_dossier_document.dart'
    as _i113;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_bonus.dart'
    as _i114;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_deduction.dart'
    as _i115;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_leave_request.dart'
    as _i116;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_vacation.dart'
    as _i117;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_incident.dart'
    as _i118;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_movement_history.dart'
    as _i119;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_area.dart'
    as _i120;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_position.dart'
    as _i121;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_specialty.dart'
    as _i122;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee.dart'
    as _i123;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_summary_dto.dart'
    as _i124;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_document.dart'
    as _i125;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_timeline_event.dart'
    as _i126;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i127;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i128;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i129;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i130;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i131;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i132;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i133;
export 'greetings/greeting.dart';
export 'modules/accounting/models/accounting_budget.dart';
export 'modules/accounting/models/accounting_cost_center.dart';
export 'modules/accounting/models/accounting_exchange_rate.dart';
export 'modules/accounting/models/accounting_expense.dart';
export 'modules/accounting/models/accounting_financial_summary.dart';
export 'modules/accounting/models/accounting_fixed_asset.dart';
export 'modules/accounting/models/accounting_invoice.dart';
export 'modules/accounting/models/accounting_kardex_movement.dart';
export 'modules/accounting/models/accounting_ledger_account.dart';
export 'modules/accounting/models/accounting_payroll_estimation.dart';
export 'modules/accounting/models/accounting_period_closure.dart';
export 'modules/accounting/models/accounting_petty_cash.dart';
export 'modules/accounting/models/accounting_petty_cash_closure.dart';
export 'modules/accounting/models/accounting_petty_cash_txn.dart';
export 'modules/accounting/models/accounting_tax.dart';
export 'modules/accounting/models/accounting_transaction.dart';
export 'modules/accounting/models/accounting_work_order_cost_summary.dart';
export 'modules/crm/models/crm_agenda_metrics_response.dart';
export 'modules/crm/models/crm_catalog_item.dart';
export 'modules/crm/models/crm_catalog_item_scope.dart';
export 'modules/crm/models/crm_contract_budget_item.dart';
export 'modules/crm/models/crm_customer.dart';
export 'modules/crm/models/crm_customer_branch.dart';
export 'modules/crm/models/crm_customer_contract.dart';
export 'modules/crm/models/crm_customer_detail_response.dart';
export 'modules/crm/models/crm_customer_metrics_response.dart';
export 'modules/crm/models/crm_lead.dart';
export 'modules/crm/models/crm_lead_metrics_response.dart';
export 'modules/crm/models/crm_opportunity.dart';
export 'modules/crm/models/crm_pipeline_metrics_response.dart';
export 'modules/crm/models/crm_quote_item.dart';
export 'modules/crm/models/crm_sector.dart';
export 'modules/crm/models/crm_service_line.dart';
export 'modules/crm/models/crm_task.dart';
export 'modules/hr/models/hr_attendance.dart';
export 'modules/hr/models/hr_employee.dart';
export 'modules/hr/models/hr_payroll.dart';
export 'modules/ops/models/ops_inventory_item.dart';
export 'modules/ops/models/ops_inventory_usage.dart';
export 'modules/ops/models/ops_service_contract.dart';
export 'modules/ops/models/ops_work_order.dart';
export 'modules/rrhh/models/rrhh_applicant.dart';
export 'modules/rrhh/models/rrhh_area.dart';
export 'modules/rrhh/models/rrhh_assignment.dart';
export 'modules/rrhh/models/rrhh_dashboard_metrics_response.dart';
export 'modules/rrhh/models/rrhh_dossier_document.dart';
export 'modules/rrhh/models/rrhh_employee.dart';
export 'modules/rrhh/models/rrhh_employee_bonus.dart';
export 'modules/rrhh/models/rrhh_employee_contract_data.dart';
export 'modules/rrhh/models/rrhh_employee_deduction.dart';
export 'modules/rrhh/models/rrhh_employee_document.dart';
export 'modules/rrhh/models/rrhh_employee_summary_dto.dart';
export 'modules/rrhh/models/rrhh_hiring_dossier.dart';
export 'modules/rrhh/models/rrhh_incident.dart';
export 'modules/rrhh/models/rrhh_leave_request.dart';
export 'modules/rrhh/models/rrhh_movement_history.dart';
export 'modules/rrhh/models/rrhh_position.dart';
export 'modules/rrhh/models/rrhh_recent_movement_dto.dart';
export 'modules/rrhh/models/rrhh_schedule.dart';
export 'modules/rrhh/models/rrhh_specialty.dart';
export 'modules/rrhh/models/rrhh_termination.dart';
export 'modules/rrhh/models/rrhh_timeline_event.dart';
export 'modules/rrhh/models/rrhh_vacation.dart';
export 'modules/security/models/app_permission.dart';
export 'modules/security/models/app_role.dart';
export 'modules/security/models/app_user.dart';
export 'modules/security/models/audit_log.dart';
export 'modules/security/models/audit_log_page_response.dart';
export 'modules/security/models/mfa_challenge.dart';
export 'modules/security/models/mfa_challenge_response.dart';
export 'modules/security/models/mfa_verify_response.dart';
export 'modules/security/models/role_permission.dart';
export 'modules/security/models/trusted_device.dart';
export 'modules/security/models/user_role.dart';
export 'modules/security/models/user_session.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.AccountingBudget) {
      return _i3.AccountingBudget.fromJson(data) as T;
    }
    if (t == _i4.AccountingCostCenter) {
      return _i4.AccountingCostCenter.fromJson(data) as T;
    }
    if (t == _i5.AccountingExchangeRate) {
      return _i5.AccountingExchangeRate.fromJson(data) as T;
    }
    if (t == _i6.AccountingExpense) {
      return _i6.AccountingExpense.fromJson(data) as T;
    }
    if (t == _i7.AccountingFinancialSummary) {
      return _i7.AccountingFinancialSummary.fromJson(data) as T;
    }
    if (t == _i8.AccountingFixedAsset) {
      return _i8.AccountingFixedAsset.fromJson(data) as T;
    }
    if (t == _i9.AccountingInvoice) {
      return _i9.AccountingInvoice.fromJson(data) as T;
    }
    if (t == _i10.AccountingKardexMovement) {
      return _i10.AccountingKardexMovement.fromJson(data) as T;
    }
    if (t == _i11.AccountingLedgerAccount) {
      return _i11.AccountingLedgerAccount.fromJson(data) as T;
    }
    if (t == _i12.AccountingPayrollEstimation) {
      return _i12.AccountingPayrollEstimation.fromJson(data) as T;
    }
    if (t == _i13.AccountingPeriodClosure) {
      return _i13.AccountingPeriodClosure.fromJson(data) as T;
    }
    if (t == _i14.AccountingPettyCash) {
      return _i14.AccountingPettyCash.fromJson(data) as T;
    }
    if (t == _i15.AccountingPettyCashClosure) {
      return _i15.AccountingPettyCashClosure.fromJson(data) as T;
    }
    if (t == _i16.AccountingPettyCashTransaction) {
      return _i16.AccountingPettyCashTransaction.fromJson(data) as T;
    }
    if (t == _i17.AccountingTax) {
      return _i17.AccountingTax.fromJson(data) as T;
    }
    if (t == _i18.AccountingTransaction) {
      return _i18.AccountingTransaction.fromJson(data) as T;
    }
    if (t == _i19.AccountingWorkOrderCostSummary) {
      return _i19.AccountingWorkOrderCostSummary.fromJson(data) as T;
    }
    if (t == _i20.CrmAgendaMetricsResponse) {
      return _i20.CrmAgendaMetricsResponse.fromJson(data) as T;
    }
    if (t == _i21.CrmCatalogItem) {
      return _i21.CrmCatalogItem.fromJson(data) as T;
    }
    if (t == _i22.CrmCatalogItemScope) {
      return _i22.CrmCatalogItemScope.fromJson(data) as T;
    }
    if (t == _i23.CrmContractBudgetItem) {
      return _i23.CrmContractBudgetItem.fromJson(data) as T;
    }
    if (t == _i24.CrmCustomer) {
      return _i24.CrmCustomer.fromJson(data) as T;
    }
    if (t == _i25.CrmCustomerBranch) {
      return _i25.CrmCustomerBranch.fromJson(data) as T;
    }
    if (t == _i26.CrmCustomerContract) {
      return _i26.CrmCustomerContract.fromJson(data) as T;
    }
    if (t == _i27.CrmCustomerDetailResponse) {
      return _i27.CrmCustomerDetailResponse.fromJson(data) as T;
    }
    if (t == _i28.CrmCustomerMetricsResponse) {
      return _i28.CrmCustomerMetricsResponse.fromJson(data) as T;
    }
    if (t == _i29.CrmLead) {
      return _i29.CrmLead.fromJson(data) as T;
    }
    if (t == _i30.CrmLeadMetricsResponse) {
      return _i30.CrmLeadMetricsResponse.fromJson(data) as T;
    }
    if (t == _i31.CrmOpportunity) {
      return _i31.CrmOpportunity.fromJson(data) as T;
    }
    if (t == _i32.CrmPipelineMetricsResponse) {
      return _i32.CrmPipelineMetricsResponse.fromJson(data) as T;
    }
    if (t == _i33.CrmQuoteItem) {
      return _i33.CrmQuoteItem.fromJson(data) as T;
    }
    if (t == _i34.CrmSector) {
      return _i34.CrmSector.fromJson(data) as T;
    }
    if (t == _i35.CrmServiceLine) {
      return _i35.CrmServiceLine.fromJson(data) as T;
    }
    if (t == _i36.CrmTask) {
      return _i36.CrmTask.fromJson(data) as T;
    }
    if (t == _i37.HrAttendance) {
      return _i37.HrAttendance.fromJson(data) as T;
    }
    if (t == _i38.HrEmployee) {
      return _i38.HrEmployee.fromJson(data) as T;
    }
    if (t == _i39.HrPayroll) {
      return _i39.HrPayroll.fromJson(data) as T;
    }
    if (t == _i40.OpsInventoryItem) {
      return _i40.OpsInventoryItem.fromJson(data) as T;
    }
    if (t == _i41.OpsInventoryUsage) {
      return _i41.OpsInventoryUsage.fromJson(data) as T;
    }
    if (t == _i42.OpsServiceContract) {
      return _i42.OpsServiceContract.fromJson(data) as T;
    }
    if (t == _i43.OpsWorkOrder) {
      return _i43.OpsWorkOrder.fromJson(data) as T;
    }
    if (t == _i44.RrhhApplicant) {
      return _i44.RrhhApplicant.fromJson(data) as T;
    }
    if (t == _i45.RrhhArea) {
      return _i45.RrhhArea.fromJson(data) as T;
    }
    if (t == _i46.RrhhAssignment) {
      return _i46.RrhhAssignment.fromJson(data) as T;
    }
    if (t == _i47.RrhhDashboardMetricsResponse) {
      return _i47.RrhhDashboardMetricsResponse.fromJson(data) as T;
    }
    if (t == _i48.RrhhDossierDocument) {
      return _i48.RrhhDossierDocument.fromJson(data) as T;
    }
    if (t == _i49.RrhhEmployee) {
      return _i49.RrhhEmployee.fromJson(data) as T;
    }
    if (t == _i50.RrhhEmployeeBonus) {
      return _i50.RrhhEmployeeBonus.fromJson(data) as T;
    }
    if (t == _i51.RrhhEmployeeContractData) {
      return _i51.RrhhEmployeeContractData.fromJson(data) as T;
    }
    if (t == _i52.RrhhEmployeeDeduction) {
      return _i52.RrhhEmployeeDeduction.fromJson(data) as T;
    }
    if (t == _i53.RrhhEmployeeDocument) {
      return _i53.RrhhEmployeeDocument.fromJson(data) as T;
    }
    if (t == _i54.RrhhEmployeeSummaryDto) {
      return _i54.RrhhEmployeeSummaryDto.fromJson(data) as T;
    }
    if (t == _i55.RrhhHiringDossier) {
      return _i55.RrhhHiringDossier.fromJson(data) as T;
    }
    if (t == _i56.RrhhIncident) {
      return _i56.RrhhIncident.fromJson(data) as T;
    }
    if (t == _i57.RrhhLeaveRequest) {
      return _i57.RrhhLeaveRequest.fromJson(data) as T;
    }
    if (t == _i58.RrhhMovementHistory) {
      return _i58.RrhhMovementHistory.fromJson(data) as T;
    }
    if (t == _i59.RrhhPosition) {
      return _i59.RrhhPosition.fromJson(data) as T;
    }
    if (t == _i60.RrhhRecentMovementDto) {
      return _i60.RrhhRecentMovementDto.fromJson(data) as T;
    }
    if (t == _i61.RrhhSchedule) {
      return _i61.RrhhSchedule.fromJson(data) as T;
    }
    if (t == _i62.RrhhSpecialty) {
      return _i62.RrhhSpecialty.fromJson(data) as T;
    }
    if (t == _i63.RrhhTermination) {
      return _i63.RrhhTermination.fromJson(data) as T;
    }
    if (t == _i64.RrhhTimelineEvent) {
      return _i64.RrhhTimelineEvent.fromJson(data) as T;
    }
    if (t == _i65.RrhhVacation) {
      return _i65.RrhhVacation.fromJson(data) as T;
    }
    if (t == _i66.AppPermission) {
      return _i66.AppPermission.fromJson(data) as T;
    }
    if (t == _i67.AppRole) {
      return _i67.AppRole.fromJson(data) as T;
    }
    if (t == _i68.AppUser) {
      return _i68.AppUser.fromJson(data) as T;
    }
    if (t == _i69.AuditLog) {
      return _i69.AuditLog.fromJson(data) as T;
    }
    if (t == _i70.AuditLogPageResponse) {
      return _i70.AuditLogPageResponse.fromJson(data) as T;
    }
    if (t == _i71.MfaChallenge) {
      return _i71.MfaChallenge.fromJson(data) as T;
    }
    if (t == _i72.MfaChallengeResponse) {
      return _i72.MfaChallengeResponse.fromJson(data) as T;
    }
    if (t == _i73.MfaVerifyResponse) {
      return _i73.MfaVerifyResponse.fromJson(data) as T;
    }
    if (t == _i74.RolePermission) {
      return _i74.RolePermission.fromJson(data) as T;
    }
    if (t == _i75.TrustedDevice) {
      return _i75.TrustedDevice.fromJson(data) as T;
    }
    if (t == _i76.UserRole) {
      return _i76.UserRole.fromJson(data) as T;
    }
    if (t == _i77.UserSession) {
      return _i77.UserSession.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AccountingBudget?>()) {
      return (data != null ? _i3.AccountingBudget.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AccountingCostCenter?>()) {
      return (data != null ? _i4.AccountingCostCenter.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AccountingExchangeRate?>()) {
      return (data != null ? _i5.AccountingExchangeRate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.AccountingExpense?>()) {
      return (data != null ? _i6.AccountingExpense.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AccountingFinancialSummary?>()) {
      return (data != null
              ? _i7.AccountingFinancialSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i8.AccountingFixedAsset?>()) {
      return (data != null ? _i8.AccountingFixedAsset.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.AccountingInvoice?>()) {
      return (data != null ? _i9.AccountingInvoice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AccountingKardexMovement?>()) {
      return (data != null
              ? _i10.AccountingKardexMovement.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.AccountingLedgerAccount?>()) {
      return (data != null ? _i11.AccountingLedgerAccount.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.AccountingPayrollEstimation?>()) {
      return (data != null
              ? _i12.AccountingPayrollEstimation.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.AccountingPeriodClosure?>()) {
      return (data != null ? _i13.AccountingPeriodClosure.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.AccountingPettyCash?>()) {
      return (data != null ? _i14.AccountingPettyCash.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.AccountingPettyCashClosure?>()) {
      return (data != null
              ? _i15.AccountingPettyCashClosure.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.AccountingPettyCashTransaction?>()) {
      return (data != null
              ? _i16.AccountingPettyCashTransaction.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i17.AccountingTax?>()) {
      return (data != null ? _i17.AccountingTax.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.AccountingTransaction?>()) {
      return (data != null ? _i18.AccountingTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.AccountingWorkOrderCostSummary?>()) {
      return (data != null
              ? _i19.AccountingWorkOrderCostSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i20.CrmAgendaMetricsResponse?>()) {
      return (data != null
              ? _i20.CrmAgendaMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i21.CrmCatalogItem?>()) {
      return (data != null ? _i21.CrmCatalogItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.CrmCatalogItemScope?>()) {
      return (data != null ? _i22.CrmCatalogItemScope.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.CrmContractBudgetItem?>()) {
      return (data != null ? _i23.CrmContractBudgetItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.CrmCustomer?>()) {
      return (data != null ? _i24.CrmCustomer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.CrmCustomerBranch?>()) {
      return (data != null ? _i25.CrmCustomerBranch.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CrmCustomerContract?>()) {
      return (data != null ? _i26.CrmCustomerContract.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.CrmCustomerDetailResponse?>()) {
      return (data != null
              ? _i27.CrmCustomerDetailResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i28.CrmCustomerMetricsResponse?>()) {
      return (data != null
              ? _i28.CrmCustomerMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i29.CrmLead?>()) {
      return (data != null ? _i29.CrmLead.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CrmLeadMetricsResponse?>()) {
      return (data != null ? _i30.CrmLeadMetricsResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.CrmOpportunity?>()) {
      return (data != null ? _i31.CrmOpportunity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CrmPipelineMetricsResponse?>()) {
      return (data != null
              ? _i32.CrmPipelineMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.CrmQuoteItem?>()) {
      return (data != null ? _i33.CrmQuoteItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CrmSector?>()) {
      return (data != null ? _i34.CrmSector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.CrmServiceLine?>()) {
      return (data != null ? _i35.CrmServiceLine.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.CrmTask?>()) {
      return (data != null ? _i36.CrmTask.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.HrAttendance?>()) {
      return (data != null ? _i37.HrAttendance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.HrEmployee?>()) {
      return (data != null ? _i38.HrEmployee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.HrPayroll?>()) {
      return (data != null ? _i39.HrPayroll.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.OpsInventoryItem?>()) {
      return (data != null ? _i40.OpsInventoryItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.OpsInventoryUsage?>()) {
      return (data != null ? _i41.OpsInventoryUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.OpsServiceContract?>()) {
      return (data != null ? _i42.OpsServiceContract.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.OpsWorkOrder?>()) {
      return (data != null ? _i43.OpsWorkOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.RrhhApplicant?>()) {
      return (data != null ? _i44.RrhhApplicant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.RrhhArea?>()) {
      return (data != null ? _i45.RrhhArea.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.RrhhAssignment?>()) {
      return (data != null ? _i46.RrhhAssignment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.RrhhDashboardMetricsResponse?>()) {
      return (data != null
              ? _i47.RrhhDashboardMetricsResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i48.RrhhDossierDocument?>()) {
      return (data != null ? _i48.RrhhDossierDocument.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.RrhhEmployee?>()) {
      return (data != null ? _i49.RrhhEmployee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.RrhhEmployeeBonus?>()) {
      return (data != null ? _i50.RrhhEmployeeBonus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.RrhhEmployeeContractData?>()) {
      return (data != null
              ? _i51.RrhhEmployeeContractData.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i52.RrhhEmployeeDeduction?>()) {
      return (data != null ? _i52.RrhhEmployeeDeduction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.RrhhEmployeeDocument?>()) {
      return (data != null ? _i53.RrhhEmployeeDocument.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.RrhhEmployeeSummaryDto?>()) {
      return (data != null ? _i54.RrhhEmployeeSummaryDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.RrhhHiringDossier?>()) {
      return (data != null ? _i55.RrhhHiringDossier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.RrhhIncident?>()) {
      return (data != null ? _i56.RrhhIncident.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.RrhhLeaveRequest?>()) {
      return (data != null ? _i57.RrhhLeaveRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.RrhhMovementHistory?>()) {
      return (data != null ? _i58.RrhhMovementHistory.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.RrhhPosition?>()) {
      return (data != null ? _i59.RrhhPosition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.RrhhRecentMovementDto?>()) {
      return (data != null ? _i60.RrhhRecentMovementDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.RrhhSchedule?>()) {
      return (data != null ? _i61.RrhhSchedule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.RrhhSpecialty?>()) {
      return (data != null ? _i62.RrhhSpecialty.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.RrhhTermination?>()) {
      return (data != null ? _i63.RrhhTermination.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.RrhhTimelineEvent?>()) {
      return (data != null ? _i64.RrhhTimelineEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.RrhhVacation?>()) {
      return (data != null ? _i65.RrhhVacation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.AppPermission?>()) {
      return (data != null ? _i66.AppPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.AppRole?>()) {
      return (data != null ? _i67.AppRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.AppUser?>()) {
      return (data != null ? _i68.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.AuditLog?>()) {
      return (data != null ? _i69.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.AuditLogPageResponse?>()) {
      return (data != null ? _i70.AuditLogPageResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.MfaChallenge?>()) {
      return (data != null ? _i71.MfaChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.MfaChallengeResponse?>()) {
      return (data != null ? _i72.MfaChallengeResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.MfaVerifyResponse?>()) {
      return (data != null ? _i73.MfaVerifyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.RolePermission?>()) {
      return (data != null ? _i74.RolePermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.TrustedDevice?>()) {
      return (data != null ? _i75.TrustedDevice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.UserRole?>()) {
      return (data != null ? _i76.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.UserSession?>()) {
      return (data != null ? _i77.UserSession.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i25.CrmCustomerBranch>) {
      return (data as List)
              .map((e) => deserialize<_i25.CrmCustomerBranch>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.CrmCustomerContract>) {
      return (data as List)
              .map((e) => deserialize<_i26.CrmCustomerContract>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.CrmContractBudgetItem>) {
      return (data as List)
              .map((e) => deserialize<_i23.CrmContractBudgetItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i50.RrhhEmployeeBonus>) {
      return (data as List)
              .map((e) => deserialize<_i50.RrhhEmployeeBonus>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i50.RrhhEmployeeBonus>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i50.RrhhEmployeeBonus>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i52.RrhhEmployeeDeduction>) {
      return (data as List)
              .map((e) => deserialize<_i52.RrhhEmployeeDeduction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i52.RrhhEmployeeDeduction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i52.RrhhEmployeeDeduction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i48.RrhhDossierDocument>) {
      return (data as List)
              .map((e) => deserialize<_i48.RrhhDossierDocument>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i48.RrhhDossierDocument>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i48.RrhhDossierDocument>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i69.AuditLog>) {
      return (data as List).map((e) => deserialize<_i69.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i78.AccountingCostCenter>) {
      return (data as List)
              .map((e) => deserialize<_i78.AccountingCostCenter>(e))
              .toList()
          as T;
    }
    if (t == List<_i79.AccountingInvoice>) {
      return (data as List)
              .map((e) => deserialize<_i79.AccountingInvoice>(e))
              .toList()
          as T;
    }
    if (t == List<_i80.AccountingExpense>) {
      return (data as List)
              .map((e) => deserialize<_i80.AccountingExpense>(e))
              .toList()
          as T;
    }
    if (t == List<_i81.AccountingPettyCash>) {
      return (data as List)
              .map((e) => deserialize<_i81.AccountingPettyCash>(e))
              .toList()
          as T;
    }
    if (t == List<_i82.AccountingPettyCashTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i82.AccountingPettyCashTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i83.AccountingPayrollEstimation>) {
      return (data as List)
              .map((e) => deserialize<_i83.AccountingPayrollEstimation>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.AccountingBudget>) {
      return (data as List)
              .map((e) => deserialize<_i84.AccountingBudget>(e))
              .toList()
          as T;
    }
    if (t == List<_i85.AccountingTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i85.AccountingTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i86.AccountingFixedAsset>) {
      return (data as List)
              .map((e) => deserialize<_i86.AccountingFixedAsset>(e))
              .toList()
          as T;
    }
    if (t == List<_i87.AccountingLedgerAccount>) {
      return (data as List)
              .map((e) => deserialize<_i87.AccountingLedgerAccount>(e))
              .toList()
          as T;
    }
    if (t == List<_i88.AccountingTax>) {
      return (data as List)
              .map((e) => deserialize<_i88.AccountingTax>(e))
              .toList()
          as T;
    }
    if (t == List<_i89.AccountingPeriodClosure>) {
      return (data as List)
              .map((e) => deserialize<_i89.AccountingPeriodClosure>(e))
              .toList()
          as T;
    }
    if (t == List<_i90.AccountingKardexMovement>) {
      return (data as List)
              .map((e) => deserialize<_i90.AccountingKardexMovement>(e))
              .toList()
          as T;
    }
    if (t == List<_i91.AccountingWorkOrderCostSummary>) {
      return (data as List)
              .map((e) => deserialize<_i91.AccountingWorkOrderCostSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i92.CrmTask>) {
      return (data as List).map((e) => deserialize<_i92.CrmTask>(e)).toList()
          as T;
    }
    if (t == List<_i93.CrmSector>) {
      return (data as List).map((e) => deserialize<_i93.CrmSector>(e)).toList()
          as T;
    }
    if (t == List<_i94.CrmServiceLine>) {
      return (data as List)
              .map((e) => deserialize<_i94.CrmServiceLine>(e))
              .toList()
          as T;
    }
    if (t == List<_i95.CrmCatalogItem>) {
      return (data as List)
              .map((e) => deserialize<_i95.CrmCatalogItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i96.CrmCatalogItemScope>) {
      return (data as List)
              .map((e) => deserialize<_i96.CrmCatalogItemScope>(e))
              .toList()
          as T;
    }
    if (t == List<_i97.CrmCustomer>) {
      return (data as List)
              .map((e) => deserialize<_i97.CrmCustomer>(e))
              .toList()
          as T;
    }
    if (t == List<_i98.CrmContractBudgetItem>) {
      return (data as List)
              .map((e) => deserialize<_i98.CrmContractBudgetItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i98.CrmContractBudgetItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i98.CrmContractBudgetItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i99.CrmLead>) {
      return (data as List).map((e) => deserialize<_i99.CrmLead>(e)).toList()
          as T;
    }
    if (t == List<_i100.CrmOpportunity>) {
      return (data as List)
              .map((e) => deserialize<_i100.CrmOpportunity>(e))
              .toList()
          as T;
    }
    if (t == List<_i101.CrmQuoteItem>) {
      return (data as List)
              .map((e) => deserialize<_i101.CrmQuoteItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i101.CrmQuoteItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i101.CrmQuoteItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i102.HrEmployee>) {
      return (data as List)
              .map((e) => deserialize<_i102.HrEmployee>(e))
              .toList()
          as T;
    }
    if (t == List<_i103.HrAttendance>) {
      return (data as List)
              .map((e) => deserialize<_i103.HrAttendance>(e))
              .toList()
          as T;
    }
    if (t == List<_i104.HrPayroll>) {
      return (data as List).map((e) => deserialize<_i104.HrPayroll>(e)).toList()
          as T;
    }
    if (t == List<_i105.OpsInventoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i105.OpsInventoryItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i106.OpsServiceContract>) {
      return (data as List)
              .map((e) => deserialize<_i106.OpsServiceContract>(e))
              .toList()
          as T;
    }
    if (t == List<_i107.OpsWorkOrder>) {
      return (data as List)
              .map((e) => deserialize<_i107.OpsWorkOrder>(e))
              .toList()
          as T;
    }
    if (t == List<_i108.RrhhApplicant>) {
      return (data as List)
              .map((e) => deserialize<_i108.RrhhApplicant>(e))
              .toList()
          as T;
    }
    if (t == List<_i109.RrhhSchedule>) {
      return (data as List)
              .map((e) => deserialize<_i109.RrhhSchedule>(e))
              .toList()
          as T;
    }
    if (t == List<_i110.RrhhAssignment>) {
      return (data as List)
              .map((e) => deserialize<_i110.RrhhAssignment>(e))
              .toList()
          as T;
    }
    if (t == List<_i111.RrhhRecentMovementDto>) {
      return (data as List)
              .map((e) => deserialize<_i111.RrhhRecentMovementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i112.RrhhHiringDossier>) {
      return (data as List)
              .map((e) => deserialize<_i112.RrhhHiringDossier>(e))
              .toList()
          as T;
    }
    if (t == List<_i113.RrhhDossierDocument>) {
      return (data as List)
              .map((e) => deserialize<_i113.RrhhDossierDocument>(e))
              .toList()
          as T;
    }
    if (t == List<_i114.RrhhEmployeeBonus>) {
      return (data as List)
              .map((e) => deserialize<_i114.RrhhEmployeeBonus>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i114.RrhhEmployeeBonus>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i114.RrhhEmployeeBonus>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i115.RrhhEmployeeDeduction>) {
      return (data as List)
              .map((e) => deserialize<_i115.RrhhEmployeeDeduction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i115.RrhhEmployeeDeduction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i115.RrhhEmployeeDeduction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i116.RrhhLeaveRequest>) {
      return (data as List)
              .map((e) => deserialize<_i116.RrhhLeaveRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i117.RrhhVacation>) {
      return (data as List)
              .map((e) => deserialize<_i117.RrhhVacation>(e))
              .toList()
          as T;
    }
    if (t == List<_i118.RrhhIncident>) {
      return (data as List)
              .map((e) => deserialize<_i118.RrhhIncident>(e))
              .toList()
          as T;
    }
    if (t == List<_i119.RrhhMovementHistory>) {
      return (data as List)
              .map((e) => deserialize<_i119.RrhhMovementHistory>(e))
              .toList()
          as T;
    }
    if (t == List<_i120.RrhhArea>) {
      return (data as List).map((e) => deserialize<_i120.RrhhArea>(e)).toList()
          as T;
    }
    if (t == List<_i121.RrhhPosition>) {
      return (data as List)
              .map((e) => deserialize<_i121.RrhhPosition>(e))
              .toList()
          as T;
    }
    if (t == List<_i122.RrhhSpecialty>) {
      return (data as List)
              .map((e) => deserialize<_i122.RrhhSpecialty>(e))
              .toList()
          as T;
    }
    if (t == List<_i123.RrhhEmployee>) {
      return (data as List)
              .map((e) => deserialize<_i123.RrhhEmployee>(e))
              .toList()
          as T;
    }
    if (t == List<_i124.RrhhEmployeeSummaryDto>) {
      return (data as List)
              .map((e) => deserialize<_i124.RrhhEmployeeSummaryDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i125.RrhhEmployeeDocument>) {
      return (data as List)
              .map((e) => deserialize<_i125.RrhhEmployeeDocument>(e))
              .toList()
          as T;
    }
    if (t == List<_i126.RrhhTimelineEvent>) {
      return (data as List)
              .map((e) => deserialize<_i126.RrhhTimelineEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i127.AuditLog>) {
      return (data as List).map((e) => deserialize<_i127.AuditLog>(e)).toList()
          as T;
    }
    if (t == List<_i128.AppRole>) {
      return (data as List).map((e) => deserialize<_i128.AppRole>(e)).toList()
          as T;
    }
    if (t == List<_i129.AppPermission>) {
      return (data as List)
              .map((e) => deserialize<_i129.AppPermission>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i130.UserSession>) {
      return (data as List)
              .map((e) => deserialize<_i130.UserSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i131.AppUser>) {
      return (data as List).map((e) => deserialize<_i131.AppUser>(e)).toList()
          as T;
    }
    try {
      return _i132.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i133.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.AccountingBudget => 'AccountingBudget',
      _i4.AccountingCostCenter => 'AccountingCostCenter',
      _i5.AccountingExchangeRate => 'AccountingExchangeRate',
      _i6.AccountingExpense => 'AccountingExpense',
      _i7.AccountingFinancialSummary => 'AccountingFinancialSummary',
      _i8.AccountingFixedAsset => 'AccountingFixedAsset',
      _i9.AccountingInvoice => 'AccountingInvoice',
      _i10.AccountingKardexMovement => 'AccountingKardexMovement',
      _i11.AccountingLedgerAccount => 'AccountingLedgerAccount',
      _i12.AccountingPayrollEstimation => 'AccountingPayrollEstimation',
      _i13.AccountingPeriodClosure => 'AccountingPeriodClosure',
      _i14.AccountingPettyCash => 'AccountingPettyCash',
      _i15.AccountingPettyCashClosure => 'AccountingPettyCashClosure',
      _i16.AccountingPettyCashTransaction => 'AccountingPettyCashTransaction',
      _i17.AccountingTax => 'AccountingTax',
      _i18.AccountingTransaction => 'AccountingTransaction',
      _i19.AccountingWorkOrderCostSummary => 'AccountingWorkOrderCostSummary',
      _i20.CrmAgendaMetricsResponse => 'CrmAgendaMetricsResponse',
      _i21.CrmCatalogItem => 'CrmCatalogItem',
      _i22.CrmCatalogItemScope => 'CrmCatalogItemScope',
      _i23.CrmContractBudgetItem => 'CrmContractBudgetItem',
      _i24.CrmCustomer => 'CrmCustomer',
      _i25.CrmCustomerBranch => 'CrmCustomerBranch',
      _i26.CrmCustomerContract => 'CrmCustomerContract',
      _i27.CrmCustomerDetailResponse => 'CrmCustomerDetailResponse',
      _i28.CrmCustomerMetricsResponse => 'CrmCustomerMetricsResponse',
      _i29.CrmLead => 'CrmLead',
      _i30.CrmLeadMetricsResponse => 'CrmLeadMetricsResponse',
      _i31.CrmOpportunity => 'CrmOpportunity',
      _i32.CrmPipelineMetricsResponse => 'CrmPipelineMetricsResponse',
      _i33.CrmQuoteItem => 'CrmQuoteItem',
      _i34.CrmSector => 'CrmSector',
      _i35.CrmServiceLine => 'CrmServiceLine',
      _i36.CrmTask => 'CrmTask',
      _i37.HrAttendance => 'HrAttendance',
      _i38.HrEmployee => 'HrEmployee',
      _i39.HrPayroll => 'HrPayroll',
      _i40.OpsInventoryItem => 'OpsInventoryItem',
      _i41.OpsInventoryUsage => 'OpsInventoryUsage',
      _i42.OpsServiceContract => 'OpsServiceContract',
      _i43.OpsWorkOrder => 'OpsWorkOrder',
      _i44.RrhhApplicant => 'RrhhApplicant',
      _i45.RrhhArea => 'RrhhArea',
      _i46.RrhhAssignment => 'RrhhAssignment',
      _i47.RrhhDashboardMetricsResponse => 'RrhhDashboardMetricsResponse',
      _i48.RrhhDossierDocument => 'RrhhDossierDocument',
      _i49.RrhhEmployee => 'RrhhEmployee',
      _i50.RrhhEmployeeBonus => 'RrhhEmployeeBonus',
      _i51.RrhhEmployeeContractData => 'RrhhEmployeeContractData',
      _i52.RrhhEmployeeDeduction => 'RrhhEmployeeDeduction',
      _i53.RrhhEmployeeDocument => 'RrhhEmployeeDocument',
      _i54.RrhhEmployeeSummaryDto => 'RrhhEmployeeSummaryDto',
      _i55.RrhhHiringDossier => 'RrhhHiringDossier',
      _i56.RrhhIncident => 'RrhhIncident',
      _i57.RrhhLeaveRequest => 'RrhhLeaveRequest',
      _i58.RrhhMovementHistory => 'RrhhMovementHistory',
      _i59.RrhhPosition => 'RrhhPosition',
      _i60.RrhhRecentMovementDto => 'RrhhRecentMovementDto',
      _i61.RrhhSchedule => 'RrhhSchedule',
      _i62.RrhhSpecialty => 'RrhhSpecialty',
      _i63.RrhhTermination => 'RrhhTermination',
      _i64.RrhhTimelineEvent => 'RrhhTimelineEvent',
      _i65.RrhhVacation => 'RrhhVacation',
      _i66.AppPermission => 'AppPermission',
      _i67.AppRole => 'AppRole',
      _i68.AppUser => 'AppUser',
      _i69.AuditLog => 'AuditLog',
      _i70.AuditLogPageResponse => 'AuditLogPageResponse',
      _i71.MfaChallenge => 'MfaChallenge',
      _i72.MfaChallengeResponse => 'MfaChallengeResponse',
      _i73.MfaVerifyResponse => 'MfaVerifyResponse',
      _i74.RolePermission => 'RolePermission',
      _i75.TrustedDevice => 'TrustedDevice',
      _i76.UserRole => 'UserRole',
      _i77.UserSession => 'UserSession',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'elite_multiservicios.',
        '',
      );
    }

    switch (data) {
      case _i2.Greeting():
        return 'Greeting';
      case _i3.AccountingBudget():
        return 'AccountingBudget';
      case _i4.AccountingCostCenter():
        return 'AccountingCostCenter';
      case _i5.AccountingExchangeRate():
        return 'AccountingExchangeRate';
      case _i6.AccountingExpense():
        return 'AccountingExpense';
      case _i7.AccountingFinancialSummary():
        return 'AccountingFinancialSummary';
      case _i8.AccountingFixedAsset():
        return 'AccountingFixedAsset';
      case _i9.AccountingInvoice():
        return 'AccountingInvoice';
      case _i10.AccountingKardexMovement():
        return 'AccountingKardexMovement';
      case _i11.AccountingLedgerAccount():
        return 'AccountingLedgerAccount';
      case _i12.AccountingPayrollEstimation():
        return 'AccountingPayrollEstimation';
      case _i13.AccountingPeriodClosure():
        return 'AccountingPeriodClosure';
      case _i14.AccountingPettyCash():
        return 'AccountingPettyCash';
      case _i15.AccountingPettyCashClosure():
        return 'AccountingPettyCashClosure';
      case _i16.AccountingPettyCashTransaction():
        return 'AccountingPettyCashTransaction';
      case _i17.AccountingTax():
        return 'AccountingTax';
      case _i18.AccountingTransaction():
        return 'AccountingTransaction';
      case _i19.AccountingWorkOrderCostSummary():
        return 'AccountingWorkOrderCostSummary';
      case _i20.CrmAgendaMetricsResponse():
        return 'CrmAgendaMetricsResponse';
      case _i21.CrmCatalogItem():
        return 'CrmCatalogItem';
      case _i22.CrmCatalogItemScope():
        return 'CrmCatalogItemScope';
      case _i23.CrmContractBudgetItem():
        return 'CrmContractBudgetItem';
      case _i24.CrmCustomer():
        return 'CrmCustomer';
      case _i25.CrmCustomerBranch():
        return 'CrmCustomerBranch';
      case _i26.CrmCustomerContract():
        return 'CrmCustomerContract';
      case _i27.CrmCustomerDetailResponse():
        return 'CrmCustomerDetailResponse';
      case _i28.CrmCustomerMetricsResponse():
        return 'CrmCustomerMetricsResponse';
      case _i29.CrmLead():
        return 'CrmLead';
      case _i30.CrmLeadMetricsResponse():
        return 'CrmLeadMetricsResponse';
      case _i31.CrmOpportunity():
        return 'CrmOpportunity';
      case _i32.CrmPipelineMetricsResponse():
        return 'CrmPipelineMetricsResponse';
      case _i33.CrmQuoteItem():
        return 'CrmQuoteItem';
      case _i34.CrmSector():
        return 'CrmSector';
      case _i35.CrmServiceLine():
        return 'CrmServiceLine';
      case _i36.CrmTask():
        return 'CrmTask';
      case _i37.HrAttendance():
        return 'HrAttendance';
      case _i38.HrEmployee():
        return 'HrEmployee';
      case _i39.HrPayroll():
        return 'HrPayroll';
      case _i40.OpsInventoryItem():
        return 'OpsInventoryItem';
      case _i41.OpsInventoryUsage():
        return 'OpsInventoryUsage';
      case _i42.OpsServiceContract():
        return 'OpsServiceContract';
      case _i43.OpsWorkOrder():
        return 'OpsWorkOrder';
      case _i44.RrhhApplicant():
        return 'RrhhApplicant';
      case _i45.RrhhArea():
        return 'RrhhArea';
      case _i46.RrhhAssignment():
        return 'RrhhAssignment';
      case _i47.RrhhDashboardMetricsResponse():
        return 'RrhhDashboardMetricsResponse';
      case _i48.RrhhDossierDocument():
        return 'RrhhDossierDocument';
      case _i49.RrhhEmployee():
        return 'RrhhEmployee';
      case _i50.RrhhEmployeeBonus():
        return 'RrhhEmployeeBonus';
      case _i51.RrhhEmployeeContractData():
        return 'RrhhEmployeeContractData';
      case _i52.RrhhEmployeeDeduction():
        return 'RrhhEmployeeDeduction';
      case _i53.RrhhEmployeeDocument():
        return 'RrhhEmployeeDocument';
      case _i54.RrhhEmployeeSummaryDto():
        return 'RrhhEmployeeSummaryDto';
      case _i55.RrhhHiringDossier():
        return 'RrhhHiringDossier';
      case _i56.RrhhIncident():
        return 'RrhhIncident';
      case _i57.RrhhLeaveRequest():
        return 'RrhhLeaveRequest';
      case _i58.RrhhMovementHistory():
        return 'RrhhMovementHistory';
      case _i59.RrhhPosition():
        return 'RrhhPosition';
      case _i60.RrhhRecentMovementDto():
        return 'RrhhRecentMovementDto';
      case _i61.RrhhSchedule():
        return 'RrhhSchedule';
      case _i62.RrhhSpecialty():
        return 'RrhhSpecialty';
      case _i63.RrhhTermination():
        return 'RrhhTermination';
      case _i64.RrhhTimelineEvent():
        return 'RrhhTimelineEvent';
      case _i65.RrhhVacation():
        return 'RrhhVacation';
      case _i66.AppPermission():
        return 'AppPermission';
      case _i67.AppRole():
        return 'AppRole';
      case _i68.AppUser():
        return 'AppUser';
      case _i69.AuditLog():
        return 'AuditLog';
      case _i70.AuditLogPageResponse():
        return 'AuditLogPageResponse';
      case _i71.MfaChallenge():
        return 'MfaChallenge';
      case _i72.MfaChallengeResponse():
        return 'MfaChallengeResponse';
      case _i73.MfaVerifyResponse():
        return 'MfaVerifyResponse';
      case _i74.RolePermission():
        return 'RolePermission';
      case _i75.TrustedDevice():
        return 'TrustedDevice';
      case _i76.UserRole():
        return 'UserRole';
      case _i77.UserSession():
        return 'UserSession';
    }
    className = _i132.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i133.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'AccountingBudget') {
      return deserialize<_i3.AccountingBudget>(data['data']);
    }
    if (dataClassName == 'AccountingCostCenter') {
      return deserialize<_i4.AccountingCostCenter>(data['data']);
    }
    if (dataClassName == 'AccountingExchangeRate') {
      return deserialize<_i5.AccountingExchangeRate>(data['data']);
    }
    if (dataClassName == 'AccountingExpense') {
      return deserialize<_i6.AccountingExpense>(data['data']);
    }
    if (dataClassName == 'AccountingFinancialSummary') {
      return deserialize<_i7.AccountingFinancialSummary>(data['data']);
    }
    if (dataClassName == 'AccountingFixedAsset') {
      return deserialize<_i8.AccountingFixedAsset>(data['data']);
    }
    if (dataClassName == 'AccountingInvoice') {
      return deserialize<_i9.AccountingInvoice>(data['data']);
    }
    if (dataClassName == 'AccountingKardexMovement') {
      return deserialize<_i10.AccountingKardexMovement>(data['data']);
    }
    if (dataClassName == 'AccountingLedgerAccount') {
      return deserialize<_i11.AccountingLedgerAccount>(data['data']);
    }
    if (dataClassName == 'AccountingPayrollEstimation') {
      return deserialize<_i12.AccountingPayrollEstimation>(data['data']);
    }
    if (dataClassName == 'AccountingPeriodClosure') {
      return deserialize<_i13.AccountingPeriodClosure>(data['data']);
    }
    if (dataClassName == 'AccountingPettyCash') {
      return deserialize<_i14.AccountingPettyCash>(data['data']);
    }
    if (dataClassName == 'AccountingPettyCashClosure') {
      return deserialize<_i15.AccountingPettyCashClosure>(data['data']);
    }
    if (dataClassName == 'AccountingPettyCashTransaction') {
      return deserialize<_i16.AccountingPettyCashTransaction>(data['data']);
    }
    if (dataClassName == 'AccountingTax') {
      return deserialize<_i17.AccountingTax>(data['data']);
    }
    if (dataClassName == 'AccountingTransaction') {
      return deserialize<_i18.AccountingTransaction>(data['data']);
    }
    if (dataClassName == 'AccountingWorkOrderCostSummary') {
      return deserialize<_i19.AccountingWorkOrderCostSummary>(data['data']);
    }
    if (dataClassName == 'CrmAgendaMetricsResponse') {
      return deserialize<_i20.CrmAgendaMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmCatalogItem') {
      return deserialize<_i21.CrmCatalogItem>(data['data']);
    }
    if (dataClassName == 'CrmCatalogItemScope') {
      return deserialize<_i22.CrmCatalogItemScope>(data['data']);
    }
    if (dataClassName == 'CrmContractBudgetItem') {
      return deserialize<_i23.CrmContractBudgetItem>(data['data']);
    }
    if (dataClassName == 'CrmCustomer') {
      return deserialize<_i24.CrmCustomer>(data['data']);
    }
    if (dataClassName == 'CrmCustomerBranch') {
      return deserialize<_i25.CrmCustomerBranch>(data['data']);
    }
    if (dataClassName == 'CrmCustomerContract') {
      return deserialize<_i26.CrmCustomerContract>(data['data']);
    }
    if (dataClassName == 'CrmCustomerDetailResponse') {
      return deserialize<_i27.CrmCustomerDetailResponse>(data['data']);
    }
    if (dataClassName == 'CrmCustomerMetricsResponse') {
      return deserialize<_i28.CrmCustomerMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmLead') {
      return deserialize<_i29.CrmLead>(data['data']);
    }
    if (dataClassName == 'CrmLeadMetricsResponse') {
      return deserialize<_i30.CrmLeadMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmOpportunity') {
      return deserialize<_i31.CrmOpportunity>(data['data']);
    }
    if (dataClassName == 'CrmPipelineMetricsResponse') {
      return deserialize<_i32.CrmPipelineMetricsResponse>(data['data']);
    }
    if (dataClassName == 'CrmQuoteItem') {
      return deserialize<_i33.CrmQuoteItem>(data['data']);
    }
    if (dataClassName == 'CrmSector') {
      return deserialize<_i34.CrmSector>(data['data']);
    }
    if (dataClassName == 'CrmServiceLine') {
      return deserialize<_i35.CrmServiceLine>(data['data']);
    }
    if (dataClassName == 'CrmTask') {
      return deserialize<_i36.CrmTask>(data['data']);
    }
    if (dataClassName == 'HrAttendance') {
      return deserialize<_i37.HrAttendance>(data['data']);
    }
    if (dataClassName == 'HrEmployee') {
      return deserialize<_i38.HrEmployee>(data['data']);
    }
    if (dataClassName == 'HrPayroll') {
      return deserialize<_i39.HrPayroll>(data['data']);
    }
    if (dataClassName == 'OpsInventoryItem') {
      return deserialize<_i40.OpsInventoryItem>(data['data']);
    }
    if (dataClassName == 'OpsInventoryUsage') {
      return deserialize<_i41.OpsInventoryUsage>(data['data']);
    }
    if (dataClassName == 'OpsServiceContract') {
      return deserialize<_i42.OpsServiceContract>(data['data']);
    }
    if (dataClassName == 'OpsWorkOrder') {
      return deserialize<_i43.OpsWorkOrder>(data['data']);
    }
    if (dataClassName == 'RrhhApplicant') {
      return deserialize<_i44.RrhhApplicant>(data['data']);
    }
    if (dataClassName == 'RrhhArea') {
      return deserialize<_i45.RrhhArea>(data['data']);
    }
    if (dataClassName == 'RrhhAssignment') {
      return deserialize<_i46.RrhhAssignment>(data['data']);
    }
    if (dataClassName == 'RrhhDashboardMetricsResponse') {
      return deserialize<_i47.RrhhDashboardMetricsResponse>(data['data']);
    }
    if (dataClassName == 'RrhhDossierDocument') {
      return deserialize<_i48.RrhhDossierDocument>(data['data']);
    }
    if (dataClassName == 'RrhhEmployee') {
      return deserialize<_i49.RrhhEmployee>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeBonus') {
      return deserialize<_i50.RrhhEmployeeBonus>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeContractData') {
      return deserialize<_i51.RrhhEmployeeContractData>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeDeduction') {
      return deserialize<_i52.RrhhEmployeeDeduction>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeDocument') {
      return deserialize<_i53.RrhhEmployeeDocument>(data['data']);
    }
    if (dataClassName == 'RrhhEmployeeSummaryDto') {
      return deserialize<_i54.RrhhEmployeeSummaryDto>(data['data']);
    }
    if (dataClassName == 'RrhhHiringDossier') {
      return deserialize<_i55.RrhhHiringDossier>(data['data']);
    }
    if (dataClassName == 'RrhhIncident') {
      return deserialize<_i56.RrhhIncident>(data['data']);
    }
    if (dataClassName == 'RrhhLeaveRequest') {
      return deserialize<_i57.RrhhLeaveRequest>(data['data']);
    }
    if (dataClassName == 'RrhhMovementHistory') {
      return deserialize<_i58.RrhhMovementHistory>(data['data']);
    }
    if (dataClassName == 'RrhhPosition') {
      return deserialize<_i59.RrhhPosition>(data['data']);
    }
    if (dataClassName == 'RrhhRecentMovementDto') {
      return deserialize<_i60.RrhhRecentMovementDto>(data['data']);
    }
    if (dataClassName == 'RrhhSchedule') {
      return deserialize<_i61.RrhhSchedule>(data['data']);
    }
    if (dataClassName == 'RrhhSpecialty') {
      return deserialize<_i62.RrhhSpecialty>(data['data']);
    }
    if (dataClassName == 'RrhhTermination') {
      return deserialize<_i63.RrhhTermination>(data['data']);
    }
    if (dataClassName == 'RrhhTimelineEvent') {
      return deserialize<_i64.RrhhTimelineEvent>(data['data']);
    }
    if (dataClassName == 'RrhhVacation') {
      return deserialize<_i65.RrhhVacation>(data['data']);
    }
    if (dataClassName == 'AppPermission') {
      return deserialize<_i66.AppPermission>(data['data']);
    }
    if (dataClassName == 'AppRole') {
      return deserialize<_i67.AppRole>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i68.AppUser>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i69.AuditLog>(data['data']);
    }
    if (dataClassName == 'AuditLogPageResponse') {
      return deserialize<_i70.AuditLogPageResponse>(data['data']);
    }
    if (dataClassName == 'MfaChallenge') {
      return deserialize<_i71.MfaChallenge>(data['data']);
    }
    if (dataClassName == 'MfaChallengeResponse') {
      return deserialize<_i72.MfaChallengeResponse>(data['data']);
    }
    if (dataClassName == 'MfaVerifyResponse') {
      return deserialize<_i73.MfaVerifyResponse>(data['data']);
    }
    if (dataClassName == 'RolePermission') {
      return deserialize<_i74.RolePermission>(data['data']);
    }
    if (dataClassName == 'TrustedDevice') {
      return deserialize<_i75.TrustedDevice>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i76.UserRole>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i77.UserSession>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i132.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i133.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i132.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i133.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
