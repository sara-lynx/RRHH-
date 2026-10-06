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

import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:elite_multiservicios_client/src/protocol/greetings/greeting.dart'
    as _i5;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_cost_center.dart'
    as _i6;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_invoice.dart'
    as _i7;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_expense.dart'
    as _i8;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_financial_summary.dart'
    as _i9;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_petty_cash.dart'
    as _i10;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_petty_cash_txn.dart'
    as _i11;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_payroll_estimation.dart'
    as _i12;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_budget.dart'
    as _i13;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_transaction.dart'
    as _i14;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_fixed_asset.dart'
    as _i15;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_ledger_account.dart'
    as _i16;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_tax.dart'
    as _i17;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_period_closure.dart'
    as _i18;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_kardex_movement.dart'
    as _i19;
import 'package:elite_multiservicios_client/src/protocol/modules/accounting/models/accounting_work_order_cost_summary.dart'
    as _i20;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_task.dart'
    as _i21;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_agenda_metrics_response.dart'
    as _i22;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_sector.dart'
    as _i23;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_service_line.dart'
    as _i24;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_catalog_item.dart'
    as _i25;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_catalog_item_scope.dart'
    as _i26;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer.dart'
    as _i27;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_detail_response.dart'
    as _i28;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_branch.dart'
    as _i29;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_contract.dart'
    as _i30;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_contract_budget_item.dart'
    as _i31;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_customer_metrics_response.dart'
    as _i32;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead.dart'
    as _i33;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_lead_metrics_response.dart'
    as _i34;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_opportunity.dart'
    as _i35;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_quote_item.dart'
    as _i36;
import 'package:elite_multiservicios_client/src/protocol/modules/crm/models/crm_pipeline_metrics_response.dart'
    as _i37;
import 'package:elite_multiservicios_client/src/protocol/modules/hr/models/hr_employee.dart'
    as _i38;
import 'package:elite_multiservicios_client/src/protocol/modules/hr/models/hr_attendance.dart'
    as _i39;
import 'package:elite_multiservicios_client/src/protocol/modules/hr/models/hr_payroll.dart'
    as _i40;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_inventory_item.dart'
    as _i41;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_service_contract.dart'
    as _i42;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_work_order.dart'
    as _i43;
import 'package:elite_multiservicios_client/src/protocol/modules/ops/models/ops_inventory_usage.dart'
    as _i44;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_applicant.dart'
    as _i45;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_schedule.dart'
    as _i46;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_assignment.dart'
    as _i47;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_dashboard_metrics_response.dart'
    as _i48;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_recent_movement_dto.dart'
    as _i49;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_hiring_dossier.dart'
    as _i50;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_dossier_document.dart'
    as _i51;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_bonus.dart'
    as _i52;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_deduction.dart'
    as _i53;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee.dart'
    as _i54;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_leave_request.dart'
    as _i55;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_vacation.dart'
    as _i56;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_incident.dart'
    as _i57;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_termination.dart'
    as _i58;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_movement_history.dart'
    as _i59;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_area.dart'
    as _i60;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_position.dart'
    as _i61;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_specialty.dart'
    as _i62;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_summary_dto.dart'
    as _i63;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_contract_data.dart'
    as _i64;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_employee_document.dart'
    as _i65;
import 'package:elite_multiservicios_client/src/protocol/modules/rrhh/models/rrhh_timeline_event.dart'
    as _i66;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log.dart'
    as _i67;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/audit_log_page_response.dart'
    as _i68;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/mfa_challenge_response.dart'
    as _i69;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/mfa_verify_response.dart'
    as _i70;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_role.dart'
    as _i71;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_permission.dart'
    as _i72;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_role.dart'
    as _i73;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/role_permission.dart'
    as _i74;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/user_session.dart'
    as _i75;
import 'package:elite_multiservicios_client/src/protocol/modules/security/models/app_user.dart'
    as _i76;
import 'protocol.dart' as _i77;

/// Endpoint de autenticación mediante correo y contraseña.
/// Extiende [EmailIdpBaseEndpoint] para incorporar auditoría de login fallido
/// y bloqueo de cuentas por intentos excesivos (soft lock 15 min, hard lock 24 h).
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointAccounting extends _i2.EndpointRef {
  EndpointAccounting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'accounting';

  /// Obtener lista de centros de costo
  _i3.Future<List<_i6.AccountingCostCenter>> getCostCenters() =>
      caller.callServerEndpoint<List<_i6.AccountingCostCenter>>(
        'accounting',
        'getCostCenters',
        {},
      );

  /// Crear centro de costo
  _i3.Future<_i6.AccountingCostCenter> createCostCenter(
    _i6.AccountingCostCenter costCenter,
  ) => caller.callServerEndpoint<_i6.AccountingCostCenter>(
    'accounting',
    'createCostCenter',
    {'costCenter': costCenter},
  );

  /// Obtener lista de facturas
  _i3.Future<List<_i7.AccountingInvoice>> getInvoices() =>
      caller.callServerEndpoint<List<_i7.AccountingInvoice>>(
        'accounting',
        'getInvoices',
        {},
      );

  /// Crear factura (con validación de periodo bloqueado)
  _i3.Future<_i7.AccountingInvoice> createInvoice(
    _i7.AccountingInvoice invoice,
  ) => caller.callServerEndpoint<_i7.AccountingInvoice>(
    'accounting',
    'createInvoice',
    {'invoice': invoice},
  );

  /// Actualizar estado de factura
  _i3.Future<_i7.AccountingInvoice?> updateInvoiceStatus(
    int invoiceId,
    String status,
  ) => caller.callServerEndpoint<_i7.AccountingInvoice?>(
    'accounting',
    'updateInvoiceStatus',
    {
      'invoiceId': invoiceId,
      'status': status,
    },
  );

  /// Obtener lista de gastos
  _i3.Future<List<_i8.AccountingExpense>> getExpenses() =>
      caller.callServerEndpoint<List<_i8.AccountingExpense>>(
        'accounting',
        'getExpenses',
        {},
      );

  /// Crear gasto (con validación de periodo bloqueado)
  _i3.Future<_i8.AccountingExpense> createExpense(
    _i8.AccountingExpense expense,
  ) => caller.callServerEndpoint<_i8.AccountingExpense>(
    'accounting',
    'createExpense',
    {'expense': expense},
  );

  /// Obtener resumen financiero
  _i3.Future<_i9.AccountingFinancialSummary> getFinancialSummary() =>
      caller.callServerEndpoint<_i9.AccountingFinancialSummary>(
        'accounting',
        'getFinancialSummary',
        {},
      );

  /// Obtener Caja Chica
  _i3.Future<List<_i10.AccountingPettyCash>> getPettyCash() =>
      caller.callServerEndpoint<List<_i10.AccountingPettyCash>>(
        'accounting',
        'getPettyCash',
        {},
      );

  /// Crear Caja Chica
  _i3.Future<_i10.AccountingPettyCash> createPettyCash(
    _i10.AccountingPettyCash pettyCash,
  ) => caller.callServerEndpoint<_i10.AccountingPettyCash>(
    'accounting',
    'createPettyCash',
    {'pettyCash': pettyCash},
  );

  /// Obtener transacciones de caja chica
  _i3.Future<List<_i11.AccountingPettyCashTransaction>>
  getPettyCashTransactions() =>
      caller.callServerEndpoint<List<_i11.AccountingPettyCashTransaction>>(
        'accounting',
        'getPettyCashTransactions',
        {},
      );

  /// Agregar transacción de caja chica
  _i3.Future<_i11.AccountingPettyCashTransaction> addPettyCashTransaction(
    _i11.AccountingPettyCashTransaction transaction,
  ) => caller.callServerEndpoint<_i11.AccountingPettyCashTransaction>(
    'accounting',
    'addPettyCashTransaction',
    {'transaction': transaction},
  );

  /// Obtener estimaciones de nómina
  _i3.Future<List<_i12.AccountingPayrollEstimation>> getPayrollEstimations() =>
      caller.callServerEndpoint<List<_i12.AccountingPayrollEstimation>>(
        'accounting',
        'getPayrollEstimations',
        {},
      );

  /// Crear estimación de nómina
  _i3.Future<_i12.AccountingPayrollEstimation> createPayrollEstimation(
    _i12.AccountingPayrollEstimation estimation,
  ) => caller.callServerEndpoint<_i12.AccountingPayrollEstimation>(
    'accounting',
    'createPayrollEstimation',
    {'estimation': estimation},
  );

  /// Obtener presupuestos mensuales
  _i3.Future<List<_i13.AccountingBudget>> getBudgets() =>
      caller.callServerEndpoint<List<_i13.AccountingBudget>>(
        'accounting',
        'getBudgets',
        {},
      );

  /// Crear o actualizar presupuesto
  _i3.Future<_i13.AccountingBudget> createBudget(
    _i13.AccountingBudget budget,
  ) => caller.callServerEndpoint<_i13.AccountingBudget>(
    'accounting',
    'createBudget',
    {'budget': budget},
  );

  /// Actualizar transacción de caja chica
  _i3.Future<_i11.AccountingPettyCashTransaction> updatePettyCashTransaction(
    _i11.AccountingPettyCashTransaction transaction,
  ) => caller.callServerEndpoint<_i11.AccountingPettyCashTransaction>(
    'accounting',
    'updatePettyCashTransaction',
    {'transaction': transaction},
  );

  /// Eliminar transacción de caja chica
  _i3.Future<void> deletePettyCashTransaction(int transactionId) =>
      caller.callServerEndpoint<void>(
        'accounting',
        'deletePettyCashTransaction',
        {'transactionId': transactionId},
      );

  _i3.Future<List<_i14.AccountingTransaction>> getTransactions() =>
      caller.callServerEndpoint<List<_i14.AccountingTransaction>>(
        'accounting',
        'getTransactions',
        {},
      );

  _i3.Future<_i14.AccountingTransaction> createTransaction(
    _i14.AccountingTransaction transaction,
  ) => caller.callServerEndpoint<_i14.AccountingTransaction>(
    'accounting',
    'createTransaction',
    {'transaction': transaction},
  );

  _i3.Future<List<_i15.AccountingFixedAsset>> getFixedAssets() =>
      caller.callServerEndpoint<List<_i15.AccountingFixedAsset>>(
        'accounting',
        'getFixedAssets',
        {},
      );

  _i3.Future<_i15.AccountingFixedAsset> createFixedAsset(
    _i15.AccountingFixedAsset asset,
  ) => caller.callServerEndpoint<_i15.AccountingFixedAsset>(
    'accounting',
    'createFixedAsset',
    {'asset': asset},
  );

  _i3.Future<int> runMonthlyDepreciation() => caller.callServerEndpoint<int>(
    'accounting',
    'runMonthlyDepreciation',
    {},
  );

  _i3.Future<List<_i16.AccountingLedgerAccount>> getLedgerAccounts() =>
      caller.callServerEndpoint<List<_i16.AccountingLedgerAccount>>(
        'accounting',
        'getLedgerAccounts',
        {},
      );

  _i3.Future<_i16.AccountingLedgerAccount> createLedgerAccount(
    _i16.AccountingLedgerAccount account,
  ) => caller.callServerEndpoint<_i16.AccountingLedgerAccount>(
    'accounting',
    'createLedgerAccount',
    {'account': account},
  );

  _i3.Future<List<_i17.AccountingTax>> getTaxes() =>
      caller.callServerEndpoint<List<_i17.AccountingTax>>(
        'accounting',
        'getTaxes',
        {},
      );

  _i3.Future<_i17.AccountingTax> createTax(_i17.AccountingTax tax) =>
      caller.callServerEndpoint<_i17.AccountingTax>(
        'accounting',
        'createTax',
        {'tax': tax},
      );

  _i3.Future<List<_i7.AccountingInvoice>> getOverdueInvoices() =>
      caller.callServerEndpoint<List<_i7.AccountingInvoice>>(
        'accounting',
        'getOverdueInvoices',
        {},
      );

  _i3.Future<List<_i8.AccountingExpense>> getOverdueExpenses() =>
      caller.callServerEndpoint<List<_i8.AccountingExpense>>(
        'accounting',
        'getOverdueExpenses',
        {},
      );

  /// Obtiene el historial de cierres contables
  _i3.Future<List<_i18.AccountingPeriodClosure>> getPeriodClosures() =>
      caller.callServerEndpoint<List<_i18.AccountingPeriodClosure>>(
        'accounting',
        'getPeriodClosures',
        {},
      );

  /// Ejecuta el cierre de un periodo contable, bloquea modificaciones y genera asiento de regularización
  _i3.Future<_i18.AccountingPeriodClosure> closeAccountingPeriod(
    String periodName,
    String periodType,
    DateTime startDate,
    DateTime endDate,
    String? notes,
    String? closedBy,
  ) => caller.callServerEndpoint<_i18.AccountingPeriodClosure>(
    'accounting',
    'closeAccountingPeriod',
    {
      'periodName': periodName,
      'periodType': periodType,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      'closedBy': closedBy,
    },
  );

  /// Reabre un periodo cerrado para correcciones excepcionales supervisadas
  _i3.Future<_i18.AccountingPeriodClosure> reopenPeriodClosure(
    int closureId,
    String reason,
  ) => caller.callServerEndpoint<_i18.AccountingPeriodClosure>(
    'accounting',
    'reopenPeriodClosure',
    {
      'closureId': closureId,
      'reason': reason,
    },
  );

  /// Obtiene los movimientos del kárdex contable (filtrable por ítem)
  _i3.Future<List<_i19.AccountingKardexMovement>> getKardexMovements({
    int? itemId,
  }) => caller.callServerEndpoint<List<_i19.AccountingKardexMovement>>(
    'accounting',
    'getKardexMovements',
    {'itemId': itemId},
  );

  /// Registra un movimiento en Kárdex, recalcula costo promedio ponderado e impacta contabilidad
  _i3.Future<_i19.AccountingKardexMovement> recordKardexMovement({
    required int itemId,
    required String movementType,
    required double quantity,
    required double unitCost,
    required String referenceDoc,
    int? workOrderId,
    String? notes,
  }) => caller.callServerEndpoint<_i19.AccountingKardexMovement>(
    'accounting',
    'recordKardexMovement',
    {
      'itemId': itemId,
      'movementType': movementType,
      'quantity': quantity,
      'unitCost': unitCost,
      'referenceDoc': referenceDoc,
      'workOrderId': workOrderId,
      'notes': notes,
    },
  );

  /// Obtiene el costeo detallado y margen de rentabilidad por Orden de Trabajo
  _i3.Future<List<_i20.AccountingWorkOrderCostSummary>> getWorkOrderCosting({
    int? workOrderId,
  }) => caller.callServerEndpoint<List<_i20.AccountingWorkOrderCostSummary>>(
    'accounting',
    'getWorkOrderCosting',
    {'workOrderId': workOrderId},
  );

  /// Facturación inmediata en 1 clic de una Orden de Trabajo completada
  _i3.Future<_i7.AccountingInvoice> createInvoiceFromWorkOrder({
    required int workOrderId,
    required double billedAmount,
    required String clientName,
    required DateTime dueDate,
    String? notes,
  }) => caller.callServerEndpoint<_i7.AccountingInvoice>(
    'accounting',
    'createInvoiceFromWorkOrder',
    {
      'workOrderId': workOrderId,
      'billedAmount': billedAmount,
      'clientName': clientName,
      'dueDate': dueDate,
      'notes': notes,
    },
  );
}

/// Endpoint RPC para la Agenda Comercial, compromisos y tareas de seguimiento.
/// {@category Endpoint}
class EndpointCrmAgenda extends _i2.EndpointRef {
  EndpointCrmAgenda(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmAgenda';

  /// Lista las tareas con filtros opcionales.
  _i3.Future<List<_i21.CrmTask>> listTasks({
    required int limit,
    required int offset,
    String? search,
    String? status,
    String? taskType,
    String? priority,
    int? customerId,
    int? opportunityId,
    int? leadId,
  }) => caller.callServerEndpoint<List<_i21.CrmTask>>(
    'crmAgenda',
    'listTasks',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'status': status,
      'taskType': taskType,
      'priority': priority,
      'customerId': customerId,
      'opportunityId': opportunityId,
      'leadId': leadId,
    },
  );

  /// Obtiene una tarea por su ID.
  _i3.Future<_i21.CrmTask?> getTask(int id) =>
      caller.callServerEndpoint<_i21.CrmTask?>(
        'crmAgenda',
        'getTask',
        {'id': id},
      );

  /// Obtiene las tareas programadas para una fecha específica.
  _i3.Future<List<_i21.CrmTask>> getTasksForDate(DateTime date) =>
      caller.callServerEndpoint<List<_i21.CrmTask>>(
        'crmAgenda',
        'getTasksForDate',
        {'date': date},
      );

  /// Obtiene las tareas correspondientes al día de hoy.
  _i3.Future<List<_i21.CrmTask>> getTodayTasks() =>
      caller.callServerEndpoint<List<_i21.CrmTask>>(
        'crmAgenda',
        'getTodayTasks',
        {},
      );

  /// Obtiene las tareas vencidas.
  _i3.Future<List<_i21.CrmTask>> getOverdueTasks() =>
      caller.callServerEndpoint<List<_i21.CrmTask>>(
        'crmAgenda',
        'getOverdueTasks',
        {},
      );

  /// Crea una nueva tarea en la agenda.
  _i3.Future<_i21.CrmTask> createTask(_i21.CrmTask task) =>
      caller.callServerEndpoint<_i21.CrmTask>(
        'crmAgenda',
        'createTask',
        {'task': task},
      );

  /// Actualiza una tarea existente.
  _i3.Future<_i21.CrmTask> updateTask(_i21.CrmTask task) =>
      caller.callServerEndpoint<_i21.CrmTask>(
        'crmAgenda',
        'updateTask',
        {'task': task},
      );

  /// Marca una tarea como completada.
  _i3.Future<_i21.CrmTask?> completeTask(
    int id, {
    String? notes,
  }) => caller.callServerEndpoint<_i21.CrmTask?>(
    'crmAgenda',
    'completeTask',
    {
      'id': id,
      'notes': notes,
    },
  );

  /// Pospone una tarea.
  _i3.Future<_i21.CrmTask?> postponeTask(
    int id, {
    required DateTime newDate,
    required String newTimeText,
    String? reason,
  }) => caller.callServerEndpoint<_i21.CrmTask?>(
    'crmAgenda',
    'postponeTask',
    {
      'id': id,
      'newDate': newDate,
      'newTimeText': newTimeText,
      'reason': reason,
    },
  );

  /// Elimina lógicamente una tarea.
  _i3.Future<bool> deleteTask(int id) => caller.callServerEndpoint<bool>(
    'crmAgenda',
    'deleteTask',
    {'id': id},
  );

  /// Programa una tarea de control de calidad tras finalizar obra.
  _i3.Future<_i21.CrmTask> scheduleQualityCheck({
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    int? customerId,
    int? contractId,
  }) => caller.callServerEndpoint<_i21.CrmTask>(
    'crmAgenda',
    'scheduleQualityCheck',
    {
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'contractTitle': contractTitle,
      'customerId': customerId,
      'contractId': contractId,
    },
  );

  /// Programa una alerta comercial de renovación de contrato.
  _i3.Future<_i21.CrmTask> scheduleRenewal({
    required String clientName,
    required String contactPerson,
    required String phone,
    required String contractTitle,
    required DateTime expiryDate,
    int? customerId,
    int? contractId,
  }) => caller.callServerEndpoint<_i21.CrmTask>(
    'crmAgenda',
    'scheduleRenewal',
    {
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'contractTitle': contractTitle,
      'expiryDate': expiryDate,
      'customerId': customerId,
      'contractId': contractId,
    },
  );

  /// Obtiene las métricas agregadas de la agenda.
  _i3.Future<_i22.CrmAgendaMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i22.CrmAgendaMetricsResponse>(
        'crmAgenda',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para la administración y consulta del Catálogo de Servicios,
/// Rubros Industriales, Líneas de Servicio y Tarifas Diferenciadas (Scopes).
/// {@category Endpoint}
class EndpointCrmCatalog extends _i2.EndpointRef {
  EndpointCrmCatalog(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmCatalog';

  /// Lista los sectores o rubros industriales no eliminados.
  _i3.Future<List<_i23.CrmSector>> listSectors({
    required bool includeInactive,
  }) => caller.callServerEndpoint<List<_i23.CrmSector>>(
    'crmCatalog',
    'listSectors',
    {'includeInactive': includeInactive},
  );

  /// Obtiene el próximo código correlativo para sectores (solo preview).
  _i3.Future<String> getNextSectorCode() => caller.callServerEndpoint<String>(
    'crmCatalog',
    'getNextSectorCode',
    {},
  );

  /// Crea un nuevo sector con validación de código y nombre únicos.
  _i3.Future<_i23.CrmSector> createSector(_i23.CrmSector sector) =>
      caller.callServerEndpoint<_i23.CrmSector>(
        'crmCatalog',
        'createSector',
        {'sector': sector},
      );

  /// Actualiza un sector existente.
  _i3.Future<_i23.CrmSector> updateSector(_i23.CrmSector sector) =>
      caller.callServerEndpoint<_i23.CrmSector>(
        'crmCatalog',
        'updateSector',
        {'sector': sector},
      );

  /// Soft delete de un sector con cascada lógica sobre sus scopes asociados.
  _i3.Future<bool> deleteSector(int id) => caller.callServerEndpoint<bool>(
    'crmCatalog',
    'deleteSector',
    {'id': id},
  );

  /// Lista las líneas de servicio disponibles.
  _i3.Future<List<_i24.CrmServiceLine>> listServiceLines({
    String? category,
    required bool includeInactive,
  }) => caller.callServerEndpoint<List<_i24.CrmServiceLine>>(
    'crmCatalog',
    'listServiceLines',
    {
      'category': category,
      'includeInactive': includeInactive,
    },
  );

  /// Obtiene el próximo código correlativo para líneas de servicio (solo preview).
  _i3.Future<String> getNextServiceLineCode() =>
      caller.callServerEndpoint<String>(
        'crmCatalog',
        'getNextServiceLineCode',
        {},
      );

  /// Crea una nueva línea de servicio.
  _i3.Future<_i24.CrmServiceLine> createServiceLine(_i24.CrmServiceLine line) =>
      caller.callServerEndpoint<_i24.CrmServiceLine>(
        'crmCatalog',
        'createServiceLine',
        {'line': line},
      );

  /// Actualiza una línea de servicio existente.
  _i3.Future<_i24.CrmServiceLine> updateServiceLine(_i24.CrmServiceLine line) =>
      caller.callServerEndpoint<_i24.CrmServiceLine>(
        'crmCatalog',
        'updateServiceLine',
        {'line': line},
      );

  /// Soft delete de una línea de servicio.
  _i3.Future<bool> deleteServiceLine(int id) => caller.callServerEndpoint<bool>(
    'crmCatalog',
    'deleteServiceLine',
    {'id': id},
  );

  /// Lista las partidas del catálogo, resolviendo opcionalmente precios diferenciados por sector.
  _i3.Future<List<_i25.CrmCatalogItem>> listCatalogItems({
    String? category,
    int? sectorId,
    int? serviceLineId,
    required bool activeOnly,
  }) => caller.callServerEndpoint<List<_i25.CrmCatalogItem>>(
    'crmCatalog',
    'listCatalogItems',
    {
      'category': category,
      'sectorId': sectorId,
      'serviceLineId': serviceLineId,
      'activeOnly': activeOnly,
    },
  );

  /// Obtiene una partida de catálogo por su ID.
  _i3.Future<_i25.CrmCatalogItem?> getCatalogItem(int id) =>
      caller.callServerEndpoint<_i25.CrmCatalogItem?>(
        'crmCatalog',
        'getCatalogItem',
        {'id': id},
      );

  /// Obtiene el próximo código correlativo para partidas de catálogo (solo preview).
  _i3.Future<String> getNextCatalogItemCode() =>
      caller.callServerEndpoint<String>(
        'crmCatalog',
        'getNextCatalogItemCode',
        {},
      );

  /// Crea una nueva partida con validación de unicidad y metadata de cálculo.
  _i3.Future<_i25.CrmCatalogItem> createCatalogItem(_i25.CrmCatalogItem item) =>
      caller.callServerEndpoint<_i25.CrmCatalogItem>(
        'crmCatalog',
        'createCatalogItem',
        {'item': item},
      );

  /// Actualiza una partida existente con versionado automático si cambia el precio o fórmula.
  _i3.Future<_i25.CrmCatalogItem> updateCatalogItem(_i25.CrmCatalogItem item) =>
      caller.callServerEndpoint<_i25.CrmCatalogItem>(
        'crmCatalog',
        'updateCatalogItem',
        {'item': item},
      );

  /// Soft delete de partida de catálogo.
  _i3.Future<bool> deleteCatalogItem(int id) => caller.callServerEndpoint<bool>(
    'crmCatalog',
    'deleteCatalogItem',
    {'id': id},
  );

  /// Lista los precios diferenciados (scopes) definidos para una partida.
  _i3.Future<List<_i26.CrmCatalogItemScope>> listScopesForItem(
    int catalogItemId,
  ) => caller.callServerEndpoint<List<_i26.CrmCatalogItemScope>>(
    'crmCatalog',
    'listScopesForItem',
    {'catalogItemId': catalogItemId},
  );

  /// Registra o actualiza la tarifa diferenciada de una partida para un sector específico.
  _i3.Future<_i26.CrmCatalogItemScope> setCatalogItemScope(
    _i26.CrmCatalogItemScope scope,
  ) => caller.callServerEndpoint<_i26.CrmCatalogItemScope>(
    'crmCatalog',
    'setCatalogItemScope',
    {'scope': scope},
  );
}

/// Endpoint RPC para el catálogo maestro de Clientes 360°, Sedes Operativas y Contratos.
/// {@category Endpoint}
class EndpointCrmCustomers extends _i2.EndpointRef {
  EndpointCrmCustomers(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmCustomers';

  /// Lista los clientes activos con filtros avanzados.
  _i3.Future<List<_i27.CrmCustomer>> listCustomers({
    required int limit,
    required int offset,
    String? search,
    String? segment,
    String? status,
  }) => caller.callServerEndpoint<List<_i27.CrmCustomer>>(
    'crmCustomers',
    'listCustomers',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'segment': segment,
      'status': status,
    },
  );

  /// Obtiene la ficha 360° detallada e hidratada de un cliente.
  _i3.Future<_i28.CrmCustomerDetailResponse?> getCustomerDetail(int id) =>
      caller.callServerEndpoint<_i28.CrmCustomerDetailResponse?>(
        'crmCustomers',
        'getCustomerDetail',
        {'id': id},
      );

  /// Obtiene los datos generales de un cliente por su ID.
  _i3.Future<_i27.CrmCustomer?> getCustomer(int id) =>
      caller.callServerEndpoint<_i27.CrmCustomer?>(
        'crmCustomers',
        'getCustomer',
        {'id': id},
      );

  /// Registra un nuevo Cliente 360°.
  _i3.Future<_i27.CrmCustomer> createCustomer(
    _i27.CrmCustomer customer, {
    _i29.CrmCustomerBranch? initialBranch,
    _i30.CrmCustomerContract? initialContract,
  }) => caller.callServerEndpoint<_i27.CrmCustomer>(
    'crmCustomers',
    'createCustomer',
    {
      'customer': customer,
      'initialBranch': initialBranch,
      'initialContract': initialContract,
    },
  );

  /// Actualiza los datos generales de un cliente.
  _i3.Future<_i27.CrmCustomer> updateCustomer(_i27.CrmCustomer customer) =>
      caller.callServerEndpoint<_i27.CrmCustomer>(
        'crmCustomers',
        'updateCustomer',
        {'customer': customer},
      );

  /// Elimina lógicamente un cliente y sus dependencias.
  _i3.Future<bool> deleteCustomer(int id) => caller.callServerEndpoint<bool>(
    'crmCustomers',
    'deleteCustomer',
    {'id': id},
  );

  /// Agrega una sede operativa a un cliente.
  _i3.Future<_i29.CrmCustomerBranch> addBranch(_i29.CrmCustomerBranch branch) =>
      caller.callServerEndpoint<_i29.CrmCustomerBranch>(
        'crmCustomers',
        'addBranch',
        {'branch': branch},
      );

  /// Actualiza una sede operativa existente.
  _i3.Future<_i29.CrmCustomerBranch> updateBranch(
    _i29.CrmCustomerBranch branch,
  ) => caller.callServerEndpoint<_i29.CrmCustomerBranch>(
    'crmCustomers',
    'updateBranch',
    {'branch': branch},
  );

  /// Elimina lógicamente una sede operativa.
  _i3.Future<bool> deleteBranch(int branchId) =>
      caller.callServerEndpoint<bool>(
        'crmCustomers',
        'deleteBranch',
        {'branchId': branchId},
      );

  /// Registra un contrato con partidas de cotización.
  _i3.Future<_i30.CrmCustomerContract> addContract(
    _i30.CrmCustomerContract contract, {
    List<_i31.CrmContractBudgetItem>? budgetItems,
  }) => caller.callServerEndpoint<_i30.CrmCustomerContract>(
    'crmCustomers',
    'addContract',
    {
      'contract': contract,
      'budgetItems': budgetItems,
    },
  );

  /// Actualiza un contrato existente.
  _i3.Future<_i30.CrmCustomerContract> updateContract(
    _i30.CrmCustomerContract contract,
  ) => caller.callServerEndpoint<_i30.CrmCustomerContract>(
    'crmCustomers',
    'updateContract',
    {'contract': contract},
  );

  /// Conclusión formal de contrato/obra con calificación de satisfacción.
  _i3.Future<_i30.CrmCustomerContract?> completeContract(
    int contractId, {
    required DateTime actualEndDate,
    String? completionNotes,
    required int satisfactionRating,
    String? completedBy,
  }) => caller.callServerEndpoint<_i30.CrmCustomerContract?>(
    'crmCustomers',
    'completeContract',
    {
      'contractId': contractId,
      'actualEndDate': actualEndDate,
      'completionNotes': completionNotes,
      'satisfactionRating': satisfactionRating,
      'completedBy': completedBy,
    },
  );

  /// Renovación directa de un contrato recurrente (+6 / +12 meses).
  _i3.Future<_i30.CrmCustomerContract?> renewContract(
    int contractId, {
    required int additionalMonths,
    double? adjustedMonthlyAmount,
    String? notes,
  }) => caller.callServerEndpoint<_i30.CrmCustomerContract?>(
    'crmCustomers',
    'renewContract',
    {
      'contractId': contractId,
      'additionalMonths': additionalMonths,
      'adjustedMonthlyAmount': adjustedMonthlyAmount,
      'notes': notes,
    },
  );

  /// Actualiza el estado puntual de un contrato (Pausar / Reactivar).
  _i3.Future<_i30.CrmCustomerContract?> updateContractStatus(
    int contractId,
    String newStatus,
  ) => caller.callServerEndpoint<_i30.CrmCustomerContract?>(
    'crmCustomers',
    'updateContractStatus',
    {
      'contractId': contractId,
      'newStatus': newStatus,
    },
  );

  /// Obtiene el consolidado de métricas en tiempo real.
  _i3.Future<_i32.CrmCustomerMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i32.CrmCustomerMetricsResponse>(
        'crmCustomers',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para la gestión integral de Prospectos (CRM Leads) en frío y Maps.
/// {@category Endpoint}
class EndpointCrmLeads extends _i2.EndpointRef {
  EndpointCrmLeads(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmLeads';

  /// Lista los prospectos con filtros opcionales de búsqueda, rubro, estado y temperatura.
  _i3.Future<List<_i33.CrmLead>> listLeads({
    required int limit,
    required int offset,
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
    String? origin,
    String? requestedService,
  }) => caller.callServerEndpoint<List<_i33.CrmLead>>(
    'crmLeads',
    'listLeads',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'sector': sector,
      'status': status,
      'temperature': temperature,
      'advisor': advisor,
      'origin': origin,
      'requestedService': requestedService,
    },
  );

  /// Obtiene el detalle de un prospecto por su ID.
  _i3.Future<_i33.CrmLead?> getLead(int id) =>
      caller.callServerEndpoint<_i33.CrmLead?>(
        'crmLeads',
        'getLead',
        {'id': id},
      );

  /// Registra un nuevo prospecto comercial en el sistema.
  _i3.Future<_i33.CrmLead> createLead(_i33.CrmLead lead) =>
      caller.callServerEndpoint<_i33.CrmLead>(
        'crmLeads',
        'createLead',
        {'lead': lead},
      );

  /// Actualiza los datos generales de un prospecto.
  _i3.Future<_i33.CrmLead> updateLead(_i33.CrmLead lead) =>
      caller.callServerEndpoint<_i33.CrmLead>(
        'crmLeads',
        'updateLead',
        {'lead': lead},
      );

  /// Actualiza el estado comercial de un prospecto en el embudo inicial.
  _i3.Future<_i33.CrmLead?> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i33.CrmLead?>(
    'crmLeads',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Actualiza la temperatura comercial (Frío, Templado, Caliente).
  _i3.Future<_i33.CrmLead?> updateTemperature(
    int id,
    String temperature,
  ) => caller.callServerEndpoint<_i33.CrmLead?>(
    'crmLeads',
    'updateTemperature',
    {
      'id': id,
      'temperature': temperature,
    },
  );

  /// Marca el prospecto como promovido formalmente a una Oportunidad en el Pipeline.
  _i3.Future<_i33.CrmLead?> markPromoted(
    int id,
    int? opportunityId,
  ) => caller.callServerEndpoint<_i33.CrmLead?>(
    'crmLeads',
    'markPromoted',
    {
      'id': id,
      'opportunityId': opportunityId,
    },
  );

  /// Elimina lógicamente (Soft Delete) un prospecto.
  _i3.Future<bool> deleteLead(int id) => caller.callServerEndpoint<bool>(
    'crmLeads',
    'deleteLead',
    {'id': id},
  );

  /// Consulta el consolidado de métricas de prospección en tiempo real.
  _i3.Future<_i34.CrmLeadMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i34.CrmLeadMetricsResponse>(
        'crmLeads',
        'getMetrics',
        {},
      );
}

/// Endpoint RPC para el embudo de ventas, compuertas y Pipeline comercial.
/// {@category Endpoint}
class EndpointCrmPipeline extends _i2.EndpointRef {
  EndpointCrmPipeline(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'crmPipeline';

  /// Lista las oportunidades con filtros opcionales.
  _i3.Future<List<_i35.CrmOpportunity>> listOpportunities({
    required int limit,
    required int offset,
    String? search,
    String? stage,
    String? owner,
    String? serviceType,
  }) => caller.callServerEndpoint<List<_i35.CrmOpportunity>>(
    'crmPipeline',
    'listOpportunities',
    {
      'limit': limit,
      'offset': offset,
      'search': search,
      'stage': stage,
      'owner': owner,
      'serviceType': serviceType,
    },
  );

  /// Obtiene el detalle de una oportunidad por ID.
  _i3.Future<_i35.CrmOpportunity?> getOpportunity(int id) =>
      caller.callServerEndpoint<_i35.CrmOpportunity?>(
        'crmPipeline',
        'getOpportunity',
        {'id': id},
      );

  /// Obtiene las partidas de cotización asociadas a una oportunidad.
  _i3.Future<List<_i36.CrmQuoteItem>> getQuoteItems(int opportunityId) =>
      caller.callServerEndpoint<List<_i36.CrmQuoteItem>>(
        'crmPipeline',
        'getQuoteItems',
        {'opportunityId': opportunityId},
      );

  /// Crea una nueva oportunidad comercial.
  _i3.Future<_i35.CrmOpportunity> createOpportunity(
    _i35.CrmOpportunity opp, {
    List<_i36.CrmQuoteItem>? quoteItems,
  }) => caller.callServerEndpoint<_i35.CrmOpportunity>(
    'crmPipeline',
    'createOpportunity',
    {
      'opp': opp,
      'quoteItems': quoteItems,
    },
  );

  /// Actualiza una oportunidad comercial.
  _i3.Future<_i35.CrmOpportunity> updateOpportunity(
    _i35.CrmOpportunity opp, {
    List<_i36.CrmQuoteItem>? quoteItems,
  }) => caller.callServerEndpoint<_i35.CrmOpportunity>(
    'crmPipeline',
    'updateOpportunity',
    {
      'opp': opp,
      'quoteItems': quoteItems,
    },
  );

  /// Actualiza la etapa o compuerta comercial de una oportunidad.
  _i3.Future<_i35.CrmOpportunity?> updateStage(
    int id,
    String newStage,
  ) => caller.callServerEndpoint<_i35.CrmOpportunity?>(
    'crmPipeline',
    'updateStage',
    {
      'id': id,
      'newStage': newStage,
    },
  );

  /// Traspaso formal de oportunidad Ganada a Cliente 360°.
  _i3.Future<_i28.CrmCustomerDetailResponse?> promoteToCustomer(
    int opportunityId,
  ) => caller.callServerEndpoint<_i28.CrmCustomerDetailResponse?>(
    'crmPipeline',
    'promoteToCustomer',
    {'opportunityId': opportunityId},
  );

  /// Elimina lógicamente una oportunidad.
  _i3.Future<bool> deleteOpportunity(int id) => caller.callServerEndpoint<bool>(
    'crmPipeline',
    'deleteOpportunity',
    {'id': id},
  );

  /// Obtiene las métricas agregadas del pipeline.
  _i3.Future<_i37.CrmPipelineMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i37.CrmPipelineMetricsResponse>(
        'crmPipeline',
        'getMetrics',
        {},
      );
}

/// {@category Endpoint}
class EndpointHr extends _i2.EndpointRef {
  EndpointHr(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'hr';

  _i3.Future<List<_i38.HrEmployee>> getEmployees() =>
      caller.callServerEndpoint<List<_i38.HrEmployee>>(
        'hr',
        'getEmployees',
        {},
      );

  _i3.Future<_i38.HrEmployee> createOrUpdateEmployee(
    _i38.HrEmployee employee,
  ) => caller.callServerEndpoint<_i38.HrEmployee>(
    'hr',
    'createOrUpdateEmployee',
    {'employee': employee},
  );

  _i3.Future<List<_i39.HrAttendance>> getAttendance(DateTime date) =>
      caller.callServerEndpoint<List<_i39.HrAttendance>>(
        'hr',
        'getAttendance',
        {'date': date},
      );

  _i3.Future<_i39.HrAttendance> markAttendance(_i39.HrAttendance attendance) =>
      caller.callServerEndpoint<_i39.HrAttendance>(
        'hr',
        'markAttendance',
        {'attendance': attendance},
      );

  _i3.Future<List<_i40.HrPayroll>> getPayroll(
    int year,
    int month,
  ) => caller.callServerEndpoint<List<_i40.HrPayroll>>(
    'hr',
    'getPayroll',
    {
      'year': year,
      'month': month,
    },
  );

  _i3.Future<_i40.HrPayroll> processPayroll(_i40.HrPayroll payroll) =>
      caller.callServerEndpoint<_i40.HrPayroll>(
        'hr',
        'processPayroll',
        {'payroll': payroll},
      );

  _i3.Future<bool> payPayroll(int payrollId) => caller.callServerEndpoint<bool>(
    'hr',
    'payPayroll',
    {'payrollId': payrollId},
  );
}

/// {@category Endpoint}
class EndpointOps extends _i2.EndpointRef {
  EndpointOps(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ops';

  _i3.Future<List<_i41.OpsInventoryItem>> getInventory() =>
      caller.callServerEndpoint<List<_i41.OpsInventoryItem>>(
        'ops',
        'getInventory',
        {},
      );

  _i3.Future<_i41.OpsInventoryItem> createOrUpdateItem(
    _i41.OpsInventoryItem item,
  ) => caller.callServerEndpoint<_i41.OpsInventoryItem>(
    'ops',
    'createOrUpdateItem',
    {'item': item},
  );

  _i3.Future<List<_i42.OpsServiceContract>> getContracts() =>
      caller.callServerEndpoint<List<_i42.OpsServiceContract>>(
        'ops',
        'getContracts',
        {},
      );

  _i3.Future<_i42.OpsServiceContract> createOrUpdateContract(
    _i42.OpsServiceContract contract,
  ) => caller.callServerEndpoint<_i42.OpsServiceContract>(
    'ops',
    'createOrUpdateContract',
    {'contract': contract},
  );

  _i3.Future<void> completeContract(int contractId) =>
      caller.callServerEndpoint<void>(
        'ops',
        'completeContract',
        {'contractId': contractId},
      );

  _i3.Future<void> cancelContract(int contractId) =>
      caller.callServerEndpoint<void>(
        'ops',
        'cancelContract',
        {'contractId': contractId},
      );

  _i3.Future<List<_i43.OpsWorkOrder>> getWorkOrders(DateTime date) =>
      caller.callServerEndpoint<List<_i43.OpsWorkOrder>>(
        'ops',
        'getWorkOrders',
        {'date': date},
      );

  _i3.Future<_i43.OpsWorkOrder> createOrUpdateWorkOrder(
    _i43.OpsWorkOrder order,
  ) => caller.callServerEndpoint<_i43.OpsWorkOrder>(
    'ops',
    'createOrUpdateWorkOrder',
    {'order': order},
  );

  _i3.Future<void> completeWorkOrder(int orderId) =>
      caller.callServerEndpoint<void>(
        'ops',
        'completeWorkOrder',
        {'orderId': orderId},
      );

  _i3.Future<_i44.OpsInventoryUsage> registerUsage(
    _i44.OpsInventoryUsage usage,
  ) => caller.callServerEndpoint<_i44.OpsInventoryUsage>(
    'ops',
    'registerUsage',
    {'usage': usage},
  );
}

/// Endpoint RPC para la gestión de postulantes y seguimiento del proceso de selección (RRHH).
/// {@category Endpoint}
class EndpointRrhhApplicant extends _i2.EndpointRef {
  EndpointRrhhApplicant(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhApplicant';

  /// Lista los postulantes aplicando filtros opcionales de estado, tipo de entorno o búsqueda.
  _i3.Future<List<_i45.RrhhApplicant>> listApplicants({
    String? status,
    String? targetType,
    int? specialtyId,
    String? search,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i45.RrhhApplicant>>(
    'rrhhApplicant',
    'listApplicants',
    {
      'status': status,
      'targetType': targetType,
      'specialtyId': specialtyId,
      'search': search,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene el detalle de un postulante por su identificador primario.
  _i3.Future<_i45.RrhhApplicant?> getApplicantById(
    int id, {
    required bool includeDeleted,
  }) => caller.callServerEndpoint<_i45.RrhhApplicant?>(
    'rrhhApplicant',
    'getApplicantById',
    {
      'id': id,
      'includeDeleted': includeDeleted,
    },
  );

  /// Registra un nuevo postulante en el sistema.
  _i3.Future<_i45.RrhhApplicant> createApplicant(
    _i45.RrhhApplicant applicant,
  ) => caller.callServerEndpoint<_i45.RrhhApplicant>(
    'rrhhApplicant',
    'createApplicant',
    {'applicant': applicant},
  );

  /// Actualiza los datos de un postulante existente.
  _i3.Future<_i45.RrhhApplicant> updateApplicant(
    _i45.RrhhApplicant applicant,
  ) => caller.callServerEndpoint<_i45.RrhhApplicant>(
    'rrhhApplicant',
    'updateApplicant',
    {'applicant': applicant},
  );

  /// Modifica el estado del postulante en el pipeline de selección ('NUEVO', 'EN_EVALUACION', 'SELECCIONADO', etc.).
  _i3.Future<_i45.RrhhApplicant> updateApplicantStatus({
    required int id,
    required String newStatus,
    String? interviewNotes,
    String? discardReason,
  }) => caller.callServerEndpoint<_i45.RrhhApplicant>(
    'rrhhApplicant',
    'updateApplicantStatus',
    {
      'id': id,
      'newStatus': newStatus,
      'interviewNotes': interviewNotes,
      'discardReason': discardReason,
    },
  );

  /// Soft delete de un postulante del sistema.
  _i3.Future<bool> deleteApplicant(int id) => caller.callServerEndpoint<bool>(
    'rrhhApplicant',
    'deleteApplicant',
    {'id': id},
  );

  /// Sembrado inicial de postulantes si la base de datos está vacía.
  _i3.Future<bool> seedInitialData() => caller.callServerEndpoint<bool>(
    'rrhhApplicant',
    'seedInitialData',
    {},
  );
}

/// Endpoint RPC para la administración de Turnos, Horarios, Asignaciones Operativas
/// y Rotaciones Inmutables de Personal en Elite Multiservicios.
/// {@category Endpoint}
class EndpointRrhhAssignment extends _i2.EndpointRef {
  EndpointRrhhAssignment(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhAssignment';

  /// Lista los turnos de trabajo disponibles en el catálogo corporativo.
  _i3.Future<List<_i46.RrhhSchedule>> listSchedules({
    String? targetType,
    bool? isActive,
    String? search,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i46.RrhhSchedule>>(
    'rrhhAssignment',
    'listSchedules',
    {
      'targetType': targetType,
      'isActive': isActive,
      'search': search,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene un turno por su ID.
  _i3.Future<_i46.RrhhSchedule?> getScheduleById(int id) =>
      caller.callServerEndpoint<_i46.RrhhSchedule?>(
        'rrhhAssignment',
        'getScheduleById',
        {'id': id},
      );

  /// Registra un nuevo horario/turno corporativo.
  _i3.Future<_i46.RrhhSchedule> createSchedule(_i46.RrhhSchedule schedule) =>
      caller.callServerEndpoint<_i46.RrhhSchedule>(
        'rrhhAssignment',
        'createSchedule',
        {'schedule': schedule},
      );

  /// Actualiza los parámetros de un horario.
  _i3.Future<_i46.RrhhSchedule> updateSchedule(_i46.RrhhSchedule schedule) =>
      caller.callServerEndpoint<_i46.RrhhSchedule>(
        'rrhhAssignment',
        'updateSchedule',
        {'schedule': schedule},
      );

  /// Desactiva (soft-delete) un horario.
  _i3.Future<bool> deleteSchedule(int id) => caller.callServerEndpoint<bool>(
    'rrhhAssignment',
    'deleteSchedule',
    {'id': id},
  );

  /// Lista las asignaciones de personal con filtros de estado, entorno y búsqueda.
  _i3.Future<List<_i47.RrhhAssignment>> listAssignments({
    String? status,
    String? assignmentType,
    int? employeeId,
    int? customerId,
    String? search,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i47.RrhhAssignment>>(
    'rrhhAssignment',
    'listAssignments',
    {
      'status': status,
      'assignmentType': assignmentType,
      'employeeId': employeeId,
      'customerId': customerId,
      'search': search,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene una asignación por su ID.
  _i3.Future<_i47.RrhhAssignment?> getAssignmentById(int id) =>
      caller.callServerEndpoint<_i47.RrhhAssignment?>(
        'rrhhAssignment',
        'getAssignmentById',
        {'id': id},
      );

  /// Obtiene la asignación activa de un colaborador específico.
  _i3.Future<_i47.RrhhAssignment?> getActiveAssignmentByEmployee(
    int employeeId,
  ) => caller.callServerEndpoint<_i47.RrhhAssignment?>(
    'rrhhAssignment',
    'getActiveAssignmentByEmployee',
    {'employeeId': employeeId},
  );

  /// Obtiene el histórico completo de rotaciones de un colaborador (inmutable).
  _i3.Future<List<_i47.RrhhAssignment>> getRotationHistory(int employeeId) =>
      caller.callServerEndpoint<List<_i47.RrhhAssignment>>(
        'rrhhAssignment',
        'getRotationHistory',
        {'employeeId': employeeId},
      );

  /// Crea una nueva asignación para un colaborador y actualiza su disponibilidad.
  _i3.Future<_i47.RrhhAssignment> createAssignment(
    _i47.RrhhAssignment assignment,
  ) => caller.callServerEndpoint<_i47.RrhhAssignment>(
    'rrhhAssignment',
    'createAssignment',
    {'assignment': assignment},
  );

  /// Rota a un colaborador a un nuevo destino preservando la inmutabilidad histórica.
  _i3.Future<_i47.RrhhAssignment> rotateAssignment({
    required int currentAssignmentId,
    required String newAssignmentType,
    int? newOfficeAreaId,
    String? newOfficeAreaName,
    String? newOfficeRole,
    int? newCustomerId,
    String? newCustomerCompanyName,
    String? newWorkplaceBranch,
    String? newContractedServiceName,
    required int newScheduleId,
    required String newSupervisorName,
    int? newSupervisorEmployeeId,
    required String rotationReason,
    String? notes,
  }) => caller.callServerEndpoint<_i47.RrhhAssignment>(
    'rrhhAssignment',
    'rotateAssignment',
    {
      'currentAssignmentId': currentAssignmentId,
      'newAssignmentType': newAssignmentType,
      'newOfficeAreaId': newOfficeAreaId,
      'newOfficeAreaName': newOfficeAreaName,
      'newOfficeRole': newOfficeRole,
      'newCustomerId': newCustomerId,
      'newCustomerCompanyName': newCustomerCompanyName,
      'newWorkplaceBranch': newWorkplaceBranch,
      'newContractedServiceName': newContractedServiceName,
      'newScheduleId': newScheduleId,
      'newSupervisorName': newSupervisorName,
      'newSupervisorEmployeeId': newSupervisorEmployeeId,
      'rotationReason': rotationReason,
      'notes': notes,
    },
  );

  /// Cancela una asignación y libera al colaborador a estado 'DISPONIBLE'.
  _i3.Future<bool> cancelAssignment(
    int id, {
    String? reason,
  }) => caller.callServerEndpoint<bool>(
    'rrhhAssignment',
    'cancelAssignment',
    {
      'id': id,
      'reason': reason,
    },
  );
}

/// Endpoint RPC para el Dashboard de Recursos Humanos y Telemetría Laboral.
/// {@category Endpoint}
class EndpointRrhhDashboard extends _i2.EndpointRef {
  EndpointRrhhDashboard(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhDashboard';

  /// Obtiene los KPIs consolidados y métricas operativas del Dashboard de RRHH.
  _i3.Future<_i48.RrhhDashboardMetricsResponse> getMetrics() =>
      caller.callServerEndpoint<_i48.RrhhDashboardMetricsResponse>(
        'rrhhDashboard',
        'getMetrics',
        {},
      );

  /// Obtiene la lista de novedades y movimientos recientes de personal.
  _i3.Future<List<_i49.RrhhRecentMovementDto>> getRecentMovements({
    required int limit,
  }) => caller.callServerEndpoint<List<_i49.RrhhRecentMovementDto>>(
    'rrhhDashboard',
    'getRecentMovements',
    {'limit': limit},
  );
}

/// Endpoint RPC para la gestión integral del Expediente de Contratación (FASE C - Hiring Dossier).
/// Conecta la etapa SELECCIONADO de Postulantes con el alta definitiva en Nómina de Empleados.
/// {@category Endpoint}
class EndpointRrhhHiring extends _i2.EndpointRef {
  EndpointRrhhHiring(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhHiring';

  /// 1. Crea un nuevo expediente de contratación para un postulante seleccionado.
  _i3.Future<_i50.RrhhHiringDossier> createDossier(int applicantId) =>
      caller.callServerEndpoint<_i50.RrhhHiringDossier>(
        'rrhhHiring',
        'createDossier',
        {'applicantId': applicantId},
      );

  /// 2. Obtiene un expediente por su ID.
  _i3.Future<_i50.RrhhHiringDossier?> getDossierById(int id) =>
      caller.callServerEndpoint<_i50.RrhhHiringDossier?>(
        'rrhhHiring',
        'getDossierById',
        {'id': id},
      );

  /// 3. Obtiene el expediente activo de un postulante.
  _i3.Future<_i50.RrhhHiringDossier?> getDossierByApplicantId(
    int applicantId,
  ) => caller.callServerEndpoint<_i50.RrhhHiringDossier?>(
    'rrhhHiring',
    'getDossierByApplicantId',
    {'applicantId': applicantId},
  );

  /// 4. Lista los expedientes activos con filtros opcionales de búsqueda y estado.
  _i3.Future<List<_i50.RrhhHiringDossier>> listActiveDossiers({
    String? search,
    String? status,
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i50.RrhhHiringDossier>>(
    'rrhhHiring',
    'listActiveDossiers',
    {
      'search': search,
      'status': status,
      'limit': limit,
      'offset': offset,
    },
  );

  /// 5. Actualiza la Sección 1: Documentación digital y checklist de verificación.
  _i3.Future<_i50.RrhhHiringDossier> updateDossierSection1({
    required int id,
    required List<_i51.RrhhDossierDocument> documentChecklist,
    String? sectionStatus,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierSection1',
    {
      'id': id,
      'documentChecklist': documentChecklist,
      'sectionStatus': sectionStatus,
    },
  );

  /// 6. Actualiza la Sección 2: Afiliación de seguridad social (AFP, Seguro de Salud).
  _i3.Future<_i50.RrhhHiringDossier> updateDossierSection2({
    required int id,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? notes,
    required String sectionStatus,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierSection2',
    {
      'id': id,
      'afpName': afpName,
      'afpNumber': afpNumber,
      'healthInsurance': healthInsurance,
      'notes': notes,
      'sectionStatus': sectionStatus,
    },
  );

  /// 7. Actualiza la Sección 3: Datos personales complementarios y contacto de emergencia.
  _i3.Future<_i50.RrhhHiringDossier> updateDossierSection3({
    required int id,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    required String sectionStatus,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierSection3',
    {
      'id': id,
      'fullAddress': fullAddress,
      'maritalStatus': maritalStatus,
      'childrenCount': childrenCount,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactRelation': emergencyContactRelation,
      'sectionStatus': sectionStatus,
    },
  );

  /// 8. Actualiza la Sección 4: Condiciones contractuales, salarios, bonos y deducciones.
  _i3.Future<_i50.RrhhHiringDossier> updateDossierSection4({
    required int id,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i52.RrhhEmployeeBonus>? bonuses,
    List<_i53.RrhhEmployeeDeduction>? deductions,
    String? notes,
    required String sectionStatus,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierSection4',
    {
      'id': id,
      'contractType': contractType,
      'workdayType': workdayType,
      'paymentModality': paymentModality,
      'baseSalary': baseSalary,
      'contractStartDate': contractStartDate,
      'contractEndDate': contractEndDate,
      'bonuses': bonuses,
      'deductions': deductions,
      'notes': notes,
      'sectionStatus': sectionStatus,
    },
  );

  /// 9. Actualiza la Sección 5: Asignación organizacional, área, cargo, turno y base operativa.
  _i3.Future<_i50.RrhhHiringDossier> updateDossierSection5({
    required int id,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? notes,
    required String sectionStatus,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierSection5',
    {
      'id': id,
      'areaId': areaId,
      'positionId': positionId,
      'shiftId': shiftId,
      'scheduleId': scheduleId,
      'baseLocation': baseLocation,
      'supervisorEmployeeId': supervisorEmployeeId,
      'effectiveStartDate': effectiveStartDate,
      'notes': notes,
      'sectionStatus': sectionStatus,
    },
  );

  /// 10. Actualiza la Sección 6: Notas de cierre, aprobación y auditoría del expediente.
  _i3.Future<_i50.RrhhHiringDossier> updateDossierSection6({
    required int id,
    String? closingNotes,
    String? approvedBy,
    required String sectionStatus,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierSection6',
    {
      'id': id,
      'closingNotes': closingNotes,
      'approvedBy': approvedBy,
      'sectionStatus': sectionStatus,
    },
  );

  /// 11. Actualiza el estado global del expediente (abierto, en_proceso, listo_para_convertir, etc.).
  _i3.Future<_i50.RrhhHiringDossier> updateDossierStatus({
    required int id,
    required String status,
  }) => caller.callServerEndpoint<_i50.RrhhHiringDossier>(
    'rrhhHiring',
    'updateDossierStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// 12. Convierte el expediente verificado en un empleado activo en Nómina (transaccional).
  _i3.Future<_i54.RrhhEmployee> convertDossierToEmployee(int id) =>
      caller.callServerEndpoint<_i54.RrhhEmployee>(
        'rrhhHiring',
        'convertDossierToEmployee',
        {'id': id},
      );

  /// 13. Soft delete del expediente de contratación.
  _i3.Future<bool> deleteDossier(int id) => caller.callServerEndpoint<bool>(
    'rrhhHiring',
    'deleteDossier',
    {'id': id},
  );
}

/// Endpoint RPC para la Gestión Laboral en RRHH:
/// Licencias, Vacaciones Legales, Régimen Disciplinario y Desvinculaciones Inmutables.
/// {@category Endpoint}
class EndpointRrhhLabor extends _i2.EndpointRef {
  EndpointRrhhLabor(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhLabor';

  /// Lista solicitudes de permiso/licencia.
  _i3.Future<List<_i55.RrhhLeaveRequest>> listLeaveRequests({
    int? employeeId,
    String? status,
    String? leaveType,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i55.RrhhLeaveRequest>>(
    'rrhhLabor',
    'listLeaveRequests',
    {
      'employeeId': employeeId,
      'status': status,
      'leaveType': leaveType,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene una solicitud de permiso por ID.
  _i3.Future<_i55.RrhhLeaveRequest?> getLeaveRequestById(int id) =>
      caller.callServerEndpoint<_i55.RrhhLeaveRequest?>(
        'rrhhLabor',
        'getLeaveRequestById',
        {'id': id},
      );

  /// Registra una nueva solicitud de permiso o licencia.
  _i3.Future<_i55.RrhhLeaveRequest> createLeaveRequest({
    required int employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
    double? hoursCount,
    required String reason,
    String? medicalCertificateNumber,
    String? attachmentUrl,
  }) => caller.callServerEndpoint<_i55.RrhhLeaveRequest>(
    'rrhhLabor',
    'createLeaveRequest',
    {
      'employeeId': employeeId,
      'leaveType': leaveType,
      'startDate': startDate,
      'endDate': endDate,
      'daysCount': daysCount,
      'hoursCount': hoursCount,
      'reason': reason,
      'medicalCertificateNumber': medicalCertificateNumber,
      'attachmentUrl': attachmentUrl,
    },
  );

  /// Resuelve (Aprueba o Rechaza) una solicitud de permiso.
  _i3.Future<_i55.RrhhLeaveRequest> resolveLeaveRequest(
    int id, {
    required String status,
    String? resolutionNotes,
    int? resolvedByUserId,
  }) => caller.callServerEndpoint<_i55.RrhhLeaveRequest>(
    'rrhhLabor',
    'resolveLeaveRequest',
    {
      'id': id,
      'status': status,
      'resolutionNotes': resolutionNotes,
      'resolvedByUserId': resolvedByUserId,
    },
  );

  /// Retorna los días de vacación según antigüedad en Bolivia.
  _i3.Future<int> calculateVacationEntitlement(
    DateTime entryDate, [
    DateTime? asOfDate,
  ]) => caller.callServerEndpoint<int>(
    'rrhhLabor',
    'calculateVacationEntitlement',
    {
      'entryDate': entryDate,
      'asOfDate': asOfDate,
    },
  );

  /// Lista vacaciones programadas o históricas.
  _i3.Future<List<_i56.RrhhVacation>> listVacations({
    int? employeeId,
    int? periodYear,
    String? status,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i56.RrhhVacation>>(
    'rrhhLabor',
    'listVacations',
    {
      'employeeId': employeeId,
      'periodYear': periodYear,
      'status': status,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Solicita un período de vacaciones.
  _i3.Future<_i56.RrhhVacation> requestVacation({
    required int employeeId,
    required int periodYear,
    required DateTime startDate,
    required DateTime endDate,
    required int daysRequested,
    String? notes,
  }) => caller.callServerEndpoint<_i56.RrhhVacation>(
    'rrhhLabor',
    'requestVacation',
    {
      'employeeId': employeeId,
      'periodYear': periodYear,
      'startDate': startDate,
      'endDate': endDate,
      'daysRequested': daysRequested,
      'notes': notes,
    },
  );

  /// Aprueba una solicitud de vacación.
  _i3.Future<_i56.RrhhVacation> approveVacation(
    int id, {
    int? approvedByUserId,
    String? notes,
  }) => caller.callServerEndpoint<_i56.RrhhVacation>(
    'rrhhLabor',
    'approveVacation',
    {
      'id': id,
      'approvedByUserId': approvedByUserId,
      'notes': notes,
    },
  );

  /// Lista novedades, memorándums o reconocimientos.
  _i3.Future<List<_i57.RrhhIncident>> listIncidents({
    int? employeeId,
    String? incidentType,
    String? severity,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i57.RrhhIncident>>(
    'rrhhLabor',
    'listIncidents',
    {
      'employeeId': employeeId,
      'incidentType': incidentType,
      'severity': severity,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Registra una incidencia disciplinaria o felicitación.
  _i3.Future<_i57.RrhhIncident> recordIncident({
    required int employeeId,
    required String incidentType,
    required String severity,
    required DateTime incidentDate,
    required String title,
    required String description,
    required String actionTaken,
    required bool isJustified,
    int? recordedByUserId,
    String? documentReferenceUrl,
  }) => caller.callServerEndpoint<_i57.RrhhIncident>(
    'rrhhLabor',
    'recordIncident',
    {
      'employeeId': employeeId,
      'incidentType': incidentType,
      'severity': severity,
      'incidentDate': incidentDate,
      'title': title,
      'description': description,
      'actionTaken': actionTaken,
      'isJustified': isJustified,
      'recordedByUserId': recordedByUserId,
      'documentReferenceUrl': documentReferenceUrl,
    },
  );

  /// Registra el egreso de un colaborador, marcándolo INACTIVO y cerrando asignaciones
  /// sin eliminar su expediente histórico de la base de datos.
  _i3.Future<_i58.RrhhTermination> terminateEmployee({
    required int employeeId,
    required DateTime terminationDate,
    required DateTime lastWorkingDay,
    required String reason,
    required String detailedReason,
    double? severanceAmount,
    required bool clearanceCompleted,
    required bool isEligibleForRehire,
    int? processedByUserId,
    String? handoverNotes,
  }) => caller.callServerEndpoint<_i58.RrhhTermination>(
    'rrhhLabor',
    'terminateEmployee',
    {
      'employeeId': employeeId,
      'terminationDate': terminationDate,
      'lastWorkingDay': lastWorkingDay,
      'reason': reason,
      'detailedReason': detailedReason,
      'severanceAmount': severanceAmount,
      'clearanceCompleted': clearanceCompleted,
      'isEligibleForRehire': isEligibleForRehire,
      'processedByUserId': processedByUserId,
      'handoverNotes': handoverNotes,
    },
  );

  /// Lista movimientos registrados de un colaborador o generales.
  _i3.Future<List<_i59.RrhhMovementHistory>> listMovements({
    int? employeeId,
    String? movementType,
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i59.RrhhMovementHistory>>(
    'rrhhLabor',
    'listMovements',
    {
      'employeeId': employeeId,
      'movementType': movementType,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Registra un movimiento laboral institucional.
  _i3.Future<_i59.RrhhMovementHistory> recordMovement({
    required int employeeId,
    required String movementType,
    String? previousValue,
    required String newValue,
    required DateTime effectiveDate,
    required String reason,
    required String authorizedBy,
  }) => caller.callServerEndpoint<_i59.RrhhMovementHistory>(
    'rrhhLabor',
    'recordMovement',
    {
      'employeeId': employeeId,
      'movementType': movementType,
      'previousValue': previousValue,
      'newValue': newValue,
      'effectiveDate': effectiveDate,
      'reason': reason,
      'authorizedBy': authorizedBy,
    },
  );
}

/// Endpoint RPC para la administración y consulta de la Estructura Organizacional:
/// Áreas Departamentales, Cargos de Personal y Especialidades Técnicas Operativas.
/// {@category Endpoint}
class EndpointRrhhOrganization extends _i2.EndpointRef {
  EndpointRrhhOrganization(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhOrganization';

  /// Lista las áreas de la empresa con filtros opcionales.
  _i3.Future<List<_i60.RrhhArea>> listAreas({
    required bool includeInactive,
    String? search,
  }) => caller.callServerEndpoint<List<_i60.RrhhArea>>(
    'rrhhOrganization',
    'listAreas',
    {
      'includeInactive': includeInactive,
      'search': search,
    },
  );

  /// Obtiene un área por su ID.
  _i3.Future<_i60.RrhhArea?> getAreaById(int id) =>
      caller.callServerEndpoint<_i60.RrhhArea?>(
        'rrhhOrganization',
        'getAreaById',
        {'id': id},
      );

  /// Crea una nueva área validando código y nombre únicos.
  _i3.Future<_i60.RrhhArea> createArea(_i60.RrhhArea area) =>
      caller.callServerEndpoint<_i60.RrhhArea>(
        'rrhhOrganization',
        'createArea',
        {'area': area},
      );

  /// Actualiza un área existente.
  _i3.Future<_i60.RrhhArea> updateArea(_i60.RrhhArea area) =>
      caller.callServerEndpoint<_i60.RrhhArea>(
        'rrhhOrganization',
        'updateArea',
        {'area': area},
      );

  /// Soft delete de un área y desactivación en cascada de sus cargos.
  _i3.Future<bool> deleteArea(int id) => caller.callServerEndpoint<bool>(
    'rrhhOrganization',
    'deleteArea',
    {'id': id},
  );

  /// Lista los cargos con filtros por área y tipo de entorno laboral ('Oficina'/'Campo').
  _i3.Future<List<_i61.RrhhPosition>> listPositions({
    int? areaId,
    String? workplaceType,
    required bool includeInactive,
    String? search,
  }) => caller.callServerEndpoint<List<_i61.RrhhPosition>>(
    'rrhhOrganization',
    'listPositions',
    {
      'areaId': areaId,
      'workplaceType': workplaceType,
      'includeInactive': includeInactive,
      'search': search,
    },
  );

  /// Obtiene un cargo por su ID.
  _i3.Future<_i61.RrhhPosition?> getPositionById(int id) =>
      caller.callServerEndpoint<_i61.RrhhPosition?>(
        'rrhhOrganization',
        'getPositionById',
        {'id': id},
      );

  /// Crea un nuevo cargo asociado a un departamento.
  _i3.Future<_i61.RrhhPosition> createPosition(_i61.RrhhPosition position) =>
      caller.callServerEndpoint<_i61.RrhhPosition>(
        'rrhhOrganization',
        'createPosition',
        {'position': position},
      );

  /// Actualiza un cargo existente.
  _i3.Future<_i61.RrhhPosition> updatePosition(_i61.RrhhPosition position) =>
      caller.callServerEndpoint<_i61.RrhhPosition>(
        'rrhhOrganization',
        'updatePosition',
        {'position': position},
      );

  /// Soft delete de un cargo.
  _i3.Future<bool> deletePosition(int id) => caller.callServerEndpoint<bool>(
    'rrhhOrganization',
    'deletePosition',
    {'id': id},
  );

  /// Lista las especialidades técnicas para personal operativo.
  _i3.Future<List<_i62.RrhhSpecialty>> listSpecialties({
    required bool includeInactive,
    String? search,
  }) => caller.callServerEndpoint<List<_i62.RrhhSpecialty>>(
    'rrhhOrganization',
    'listSpecialties',
    {
      'includeInactive': includeInactive,
      'search': search,
    },
  );

  /// Obtiene una especialidad por su ID.
  _i3.Future<_i62.RrhhSpecialty?> getSpecialtyById(int id) =>
      caller.callServerEndpoint<_i62.RrhhSpecialty?>(
        'rrhhOrganization',
        'getSpecialtyById',
        {'id': id},
      );

  /// Crea una nueva especialidad operativa.
  _i3.Future<_i62.RrhhSpecialty> createSpecialty(
    _i62.RrhhSpecialty specialty,
  ) => caller.callServerEndpoint<_i62.RrhhSpecialty>(
    'rrhhOrganization',
    'createSpecialty',
    {'specialty': specialty},
  );

  /// Actualiza una especialidad existente.
  _i3.Future<_i62.RrhhSpecialty> updateSpecialty(
    _i62.RrhhSpecialty specialty,
  ) => caller.callServerEndpoint<_i62.RrhhSpecialty>(
    'rrhhOrganization',
    'updateSpecialty',
    {'specialty': specialty},
  );

  /// Soft delete de una especialidad.
  _i3.Future<bool> deleteSpecialty(int id) => caller.callServerEndpoint<bool>(
    'rrhhOrganization',
    'deleteSpecialty',
    {'id': id},
  );

  /// Si las tablas de áreas y especialidades se encuentran vacías, las inicializa con datos estándar.
  _i3.Future<bool> seedInitialData() => caller.callServerEndpoint<bool>(
    'rrhhOrganization',
    'seedInitialData',
    {},
  );
}

/// Endpoint RPC para la administración integral del Expediente de Empleados,
/// Contratación transaccional desde postulantes, Documentos Digitales e Historial.
/// {@category Endpoint}
class EndpointRrhhPersonnel extends _i2.EndpointRef {
  EndpointRrhhPersonnel(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rrhhPersonnel';

  /// Lista los colaboradores con filtros opcionales de estado, tipo Oficina/Campo y búsqueda.
  _i3.Future<List<_i54.RrhhEmployee>> listEmployees({
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i54.RrhhEmployee>>(
    'rrhhPersonnel',
    'listEmployees',
    {
      'status': status,
      'employeeType': employeeType,
      'availabilityStatus': availabilityStatus,
      'areaId': areaId,
      'search': search,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// TAREA 4: Lista resumida y paginada de colaboradores para el Directorio.
  _i3.Future<List<_i63.RrhhEmployeeSummaryDto>> listEmployeeSummaries({
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i63.RrhhEmployeeSummaryDto>>(
    'rrhhPersonnel',
    'listEmployeeSummaries',
    {
      'status': status,
      'employeeType': employeeType,
      'availabilityStatus': availabilityStatus,
      'areaId': areaId,
      'search': search,
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// TAREA 4: Retorna el conteo total de empleados coincidentes para paginación y métricas.
  _i3.Future<int> countEmployees({
    String? status,
    String? employeeType,
    String? availabilityStatus,
    int? areaId,
    String? search,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<int>(
    'rrhhPersonnel',
    'countEmployees',
    {
      'status': status,
      'employeeType': employeeType,
      'availabilityStatus': availabilityStatus,
      'areaId': areaId,
      'search': search,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene un colaborador por su ID.
  _i3.Future<_i54.RrhhEmployee?> getEmployeeById(
    int id, {
    required bool includeDeleted,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee?>(
    'rrhhPersonnel',
    'getEmployeeById',
    {
      'id': id,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene un colaborador por su código institucional (EMP-001).
  _i3.Future<_i54.RrhhEmployee?> getEmployeeByCode(
    String code, {
    required bool includeDeleted,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee?>(
    'rrhhPersonnel',
    'getEmployeeByCode',
    {
      'code': code,
      'includeDeleted': includeDeleted,
    },
  );

  /// Registra un nuevo colaborador directamente en nómina.
  _i3.Future<_i54.RrhhEmployee> createEmployee(_i54.RrhhEmployee employee) =>
      caller.callServerEndpoint<_i54.RrhhEmployee>(
        'rrhhPersonnel',
        'createEmployee',
        {'employee': employee},
      );

  /// Actualiza los datos laborales de un empleado.
  _i3.Future<_i54.RrhhEmployee> updateEmployee(_i54.RrhhEmployee employee) =>
      caller.callServerEndpoint<_i54.RrhhEmployee>(
        'rrhhPersonnel',
        'updateEmployee',
        {'employee': employee},
      );

  /// Contrata formalmente a un postulante seleccionado, promoviéndolo a empleado.
  _i3.Future<_i54.RrhhEmployee> hireApplicant({
    required int applicantId,
    required DateTime realStartDate,
    required DateTime fiscalStartDate,
    required double agreedSalary,
    required String contractType,
    DateTime? contractEndDate,
    String? observations,
    String? workplace,
    String? supervisor,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'hireApplicant',
    {
      'applicantId': applicantId,
      'realStartDate': realStartDate,
      'fiscalStartDate': fiscalStartDate,
      'agreedSalary': agreedSalary,
      'contractType': contractType,
      'contractEndDate': contractEndDate,
      'observations': observations,
      'workplace': workplace,
      'supervisor': supervisor,
    },
  );

  /// Modifica el estado de disponibilidad operativa del empleado.
  _i3.Future<_i54.RrhhEmployee> updateAvailabilityStatus({
    required int id,
    required String newAvailabilityStatus,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateAvailabilityStatus',
    {
      'id': id,
      'newAvailabilityStatus': newAvailabilityStatus,
    },
  );

  /// Desvincula a un empleado pasando a INACTIVO y conservando todo su historial.
  _i3.Future<_i54.RrhhEmployee> terminateEmployee({
    required int id,
    required DateTime exitDate,
    required String exitReason,
    String? exitObservations,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'terminateEmployee',
    {
      'id': id,
      'exitDate': exitDate,
      'exitReason': exitReason,
      'exitObservations': exitObservations,
    },
  );

  /// Soft delete de un empleado (eliminación lógica).
  _i3.Future<bool> deleteEmployee(int id) => caller.callServerEndpoint<bool>(
    'rrhhPersonnel',
    'deleteEmployee',
    {'id': id},
  );

  /// Obtiene el resumen contractual y salarial de un empleado para exposición a Contabilidad.
  _i3.Future<_i64.RrhhEmployeeContractData> getEmployeeContractData(int id) =>
      caller.callServerEndpoint<_i64.RrhhEmployeeContractData>(
        'rrhhPersonnel',
        'getEmployeeContractData',
        {'id': id},
      );

  /// Actualiza los datos bancarios del empleado (banco, tipo y número de cuenta).
  _i3.Future<_i54.RrhhEmployee> updateEmployeeBankInfo({
    required int id,
    String? bankName,
    String? accountType,
    String? accountNumber,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeBankInfo',
    {
      'id': id,
      'bankName': bankName,
      'accountType': accountType,
      'accountNumber': accountNumber,
    },
  );

  /// Actualiza la información de seguridad social (AFP, Seguro de Salud).
  _i3.Future<_i54.RrhhEmployee> updateEmployeeSocialSecurity({
    required int id,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeSocialSecurity',
    {
      'id': id,
      'afpName': afpName,
      'afpNumber': afpNumber,
      'healthInsurance': healthInsurance,
    },
  );

  /// Actualiza datos personales complementarios y contacto de emergencia.
  _i3.Future<_i54.RrhhEmployee> updateEmployeePersonalInfo({
    required int id,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeePersonalInfo',
    {
      'id': id,
      'fullAddress': fullAddress,
      'maritalStatus': maritalStatus,
      'childrenCount': childrenCount,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactRelation': emergencyContactRelation,
    },
  );

  /// Actualiza las condiciones contractuales y de remuneración.
  _i3.Future<_i54.RrhhEmployee> updateEmployeeContract({
    required int id,
    required String justification,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    String? contractSignedPdfUrl,
    List<_i52.RrhhEmployeeBonus>? bonuses,
    List<_i53.RrhhEmployeeDeduction>? deductions,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeContract',
    {
      'id': id,
      'justification': justification,
      'contractType': contractType,
      'workdayType': workdayType,
      'paymentModality': paymentModality,
      'baseSalary': baseSalary,
      'contractStartDate': contractStartDate,
      'contractEndDate': contractEndDate,
      'contractSignedPdfUrl': contractSignedPdfUrl,
      'bonuses': bonuses,
      'deductions': deductions,
    },
  );

  /// Actualiza la lista de bonificaciones asignadas al colaborador.
  _i3.Future<_i54.RrhhEmployee> updateEmployeeBonuses({
    required int id,
    required List<_i52.RrhhEmployeeBonus> bonuses,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeBonuses',
    {
      'id': id,
      'bonuses': bonuses,
    },
  );

  /// Actualiza la lista de deducciones aplicadas al colaborador.
  _i3.Future<_i54.RrhhEmployee> updateEmployeeDeductions({
    required int id,
    required List<_i53.RrhhEmployeeDeduction> deductions,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeDeductions',
    {
      'id': id,
      'deductions': deductions,
    },
  );

  /// Actualiza la asignación operativa, ubicación base y supervisor.
  _i3.Future<_i54.RrhhEmployee> updateEmployeeAssignment({
    required int id,
    String? shiftId,
    String? baseLocation,
    String? supervisorEmployeeId,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeAssignment',
    {
      'id': id,
      'shiftId': shiftId,
      'baseLocation': baseLocation,
      'supervisorEmployeeId': supervisorEmployeeId,
    },
  );

  /// Actualiza el checklist de documentación digital del colaborador.
  _i3.Future<_i54.RrhhEmployee> updateEmployeeDocuments({
    required int id,
    required List<_i51.RrhhDossierDocument> documentChecklist,
  }) => caller.callServerEndpoint<_i54.RrhhEmployee>(
    'rrhhPersonnel',
    'updateEmployeeDocuments',
    {
      'id': id,
      'documentChecklist': documentChecklist,
    },
  );

  /// Lista los documentos del expediente digital del empleado.
  _i3.Future<List<_i65.RrhhEmployeeDocument>> listDocuments(int employeeId) =>
      caller.callServerEndpoint<List<_i65.RrhhEmployeeDocument>>(
        'rrhhPersonnel',
        'listDocuments',
        {'employeeId': employeeId},
      );

  /// Registra un documento en el expediente.
  _i3.Future<_i65.RrhhEmployeeDocument> addDocument(
    _i65.RrhhEmployeeDocument document,
  ) => caller.callServerEndpoint<_i65.RrhhEmployeeDocument>(
    'rrhhPersonnel',
    'addDocument',
    {'document': document},
  );

  /// Elimina un documento del expediente.
  _i3.Future<bool> deleteDocument(int documentId) =>
      caller.callServerEndpoint<bool>(
        'rrhhPersonnel',
        'deleteDocument',
        {'documentId': documentId},
      );

  /// Consulta la línea de tiempo de un colaborador.
  _i3.Future<List<_i66.RrhhTimelineEvent>> listTimelineEvents(int employeeId) =>
      caller.callServerEndpoint<List<_i66.RrhhTimelineEvent>>(
        'rrhhPersonnel',
        'listTimelineEvents',
        {'employeeId': employeeId},
      );

  /// Agrega un hito a la línea de tiempo del empleado.
  _i3.Future<_i66.RrhhTimelineEvent> addTimelineEvent(
    _i66.RrhhTimelineEvent event,
  ) => caller.callServerEndpoint<_i66.RrhhTimelineEvent>(
    'rrhhPersonnel',
    'addTimelineEvent',
    {'event': event},
  );

  /// Sembrado inicial de empleados si la base de datos está vacía.
  _i3.Future<bool> seedInitialData() => caller.callServerEndpoint<bool>(
    'rrhhPersonnel',
    'seedInitialData',
    {},
  );
}

/// Endpoint RPC para consulta de la bitácora de eventos y auditoría del sistema.
/// {@category Endpoint}
class EndpointAudit extends _i2.EndpointRef {
  EndpointAudit(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'audit';

  /// Lista los registros de bitácora paginados con filtros opcionales. Requiere audit.view.
  _i3.Future<List<_i67.AuditLog>> listLogs({
    required int limit,
    required int offset,
    int? userId,
    String? action,
  }) => caller.callServerEndpoint<List<_i67.AuditLog>>(
    'audit',
    'listLogs',
    {
      'limit': limit,
      'offset': offset,
      'userId': userId,
      'action': action,
    },
  );

  /// Lista los registros de auditoría de forma paginada con filtros avanzados. Requiere audit.view.
  _i3.Future<_i68.AuditLogPageResponse> listLogsPaged({
    required int page,
    required int pageSize,
    String? action,
    String? result,
    int? userId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) => caller.callServerEndpoint<_i68.AuditLogPageResponse>(
    'audit',
    'listLogsPaged',
    {
      'page': page,
      'pageSize': pageSize,
      'action': action,
      'result': result,
      'userId': userId,
      'fromDate': fromDate,
      'toDate': toDate,
      'search': search,
    },
  );
}

/// Endpoint RPC para la gestión de autenticación multifactor (MFA) y dispositivos de confianza.
/// {@category Endpoint}
class EndpointMfa extends _i2.EndpointRef {
  EndpointMfa(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mfa';

  /// Verifica si el usuario autenticado requiere MFA.
  /// Si sí, genera un challenge, envía el email y devuelve el challengeId.
  /// Si no, devuelve null.
  _i3.Future<_i69.MfaChallengeResponse?> checkRequired({
    required bool rememberMe,
    String? trustedDeviceToken,
  }) => caller.callServerEndpoint<_i69.MfaChallengeResponse?>(
    'mfa',
    'checkRequired',
    {
      'rememberMe': rememberMe,
      'trustedDeviceToken': trustedDeviceToken,
    },
  );

  /// Verifica el código MFA. Si es correcto:
  /// - Marca el challenge como usado.
  /// - Si rememberMe, crea un TrustedDevice y devuelve el token.
  /// - Devuelve true si OK.
  /// Si es incorrecto, incrementa attempts y devuelve error.
  _i3.Future<_i70.MfaVerifyResponse> verifyMfa({
    required String challengeId,
    required String code,
    required bool rememberMe,
  }) => caller.callServerEndpoint<_i70.MfaVerifyResponse>(
    'mfa',
    'verifyMfa',
    {
      'challengeId': challengeId,
      'code': code,
      'rememberMe': rememberMe,
    },
  );

  /// Reenvía un nuevo código para el mismo challenge.
  /// Rate limited: solo si pasó 1 minuto desde el último envío.
  _i3.Future<void> resendMfaCode({required String challengeId}) =>
      caller.callServerEndpoint<void>(
        'mfa',
        'resendMfaCode',
        {'challengeId': challengeId},
      );

  /// Comprueba si la sesión activa del usuario actual ya está verificada con MFA en PostgreSQL.
  _i3.Future<bool> isSessionVerified() => caller.callServerEndpoint<bool>(
    'mfa',
    'isSessionVerified',
    {},
  );
}

/// Endpoint RPC para administración de Roles y Permisos Granulares (RBAC).
/// {@category Endpoint}
class EndpointRbac extends _i2.EndpointRef {
  EndpointRbac(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rbac';

  /// Lista los roles registrados en el sistema. Requiere roles.view.
  _i3.Future<List<_i71.AppRole>> listRoles() =>
      caller.callServerEndpoint<List<_i71.AppRole>>(
        'rbac',
        'listRoles',
        {},
      );

  /// Lista el catálogo de permisos granulares. Requiere permissions.view.
  _i3.Future<List<_i72.AppPermission>> listPermissions() =>
      caller.callServerEndpoint<List<_i72.AppPermission>>(
        'rbac',
        'listPermissions',
        {},
      );

  /// Asigna un rol a un usuario. Requiere roles.manage.
  _i3.Future<_i73.UserRole> assignRoleToUser({
    required int userId,
    required int roleId,
  }) => caller.callServerEndpoint<_i73.UserRole>(
    'rbac',
    'assignRoleToUser',
    {
      'userId': userId,
      'roleId': roleId,
    },
  );

  /// Remueve un rol asignado a un usuario. Requiere roles.manage.
  _i3.Future<bool> removeRoleFromUser({
    required int userId,
    required int roleId,
  }) => caller.callServerEndpoint<bool>(
    'rbac',
    'removeRoleFromUser',
    {
      'userId': userId,
      'roleId': roleId,
    },
  );

  /// Asigna un permiso granular a un rol. Requiere permissions.assign.
  _i3.Future<_i74.RolePermission> assignPermissionToRole({
    required int roleId,
    required int permissionId,
  }) => caller.callServerEndpoint<_i74.RolePermission>(
    'rbac',
    'assignPermissionToRole',
    {
      'roleId': roleId,
      'permissionId': permissionId,
    },
  );

  /// Obtiene la lista de códigos de permisos efectivos de un usuario.
  _i3.Future<List<String>> getUserEffectivePermissions(int userId) =>
      caller.callServerEndpoint<List<String>>(
        'rbac',
        'getUserEffectivePermissions',
        {'userId': userId},
      );

  /// Crea un nuevo rol empresarial. Requiere roles.manage.
  _i3.Future<_i71.AppRole> createRole(_i71.AppRole role) =>
      caller.callServerEndpoint<_i71.AppRole>(
        'rbac',
        'createRole',
        {'role': role},
      );

  /// Actualiza un rol existente. Requiere roles.manage.
  _i3.Future<_i71.AppRole> updateRole(_i71.AppRole role) =>
      caller.callServerEndpoint<_i71.AppRole>(
        'rbac',
        'updateRole',
        {'role': role},
      );

  /// Elimina un rol empresarial (los de sistema no se pueden eliminar). Requiere roles.manage.
  _i3.Future<bool> deleteRole(int roleId) => caller.callServerEndpoint<bool>(
    'rbac',
    'deleteRole',
    {'roleId': roleId},
  );

  /// Obtiene los IDs de los permisos asignados a un rol. Requiere permissions.view.
  _i3.Future<List<int>> getRolePermissions(int roleId) =>
      caller.callServerEndpoint<List<int>>(
        'rbac',
        'getRolePermissions',
        {'roleId': roleId},
      );

  /// Sincroniza en bloque los permisos de un rol (Matriz RBAC). Requiere permissions.assign.
  _i3.Future<List<int>> syncRolePermissions({
    required int roleId,
    required List<int> permissionIds,
  }) => caller.callServerEndpoint<List<int>>(
    'rbac',
    'syncRolePermissions',
    {
      'roleId': roleId,
      'permissionIds': permissionIds,
    },
  );
}

/// Endpoint RPC para el monitoreo y control de sesiones activas.
/// {@category Endpoint}
class EndpointSessionManagement extends _i2.EndpointRef {
  EndpointSessionManagement(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sessionManagement';

  /// Registra la sesión actual del usuario autenticado en la tabla `user_session`.
  /// Se invoca después de un login exitoso.
  /// Retorna el `id` de la sesión creada.
  _i3.Future<int> registerSession({bool? mfaVerified}) =>
      caller.callServerEndpoint<int>(
        'sessionManagement',
        'registerSession',
        {'mfaVerified': mfaVerified},
      );

  /// Lista las sesiones activas asociadas a un usuario. Requiere sessions.view.
  _i3.Future<List<_i75.UserSession>> listUserSessions(int userId) =>
      caller.callServerEndpoint<List<_i75.UserSession>>(
        'sessionManagement',
        'listUserSessions',
        {'userId': userId},
      );

  /// Revoca de forma inmediata una sesión activa por su ID. Requiere sessions.revoke.
  _i3.Future<bool> revokeSession(int sessionId) =>
      caller.callServerEndpoint<bool>(
        'sessionManagement',
        'revokeSession',
        {'sessionId': sessionId},
      );

  /// Cierra la sesión actual del usuario autenticado.
  /// Marca la fila en `user_session` como revocada y revoca el token nativo en Serverpod.
  /// Retorna `true` de forma idempotente para preservar la UX de cierre de sesión.
  _i3.Future<bool> logout() => caller.callServerEndpoint<bool>(
    'sessionManagement',
    'logout',
    {},
  );

  /// Marca la sesión activa actual del usuario autenticado como verificada con MFA.
  _i3.Future<void> markMfaVerified() => caller.callServerEndpoint<void>(
    'sessionManagement',
    'markMfaVerified',
    {},
  );
}

/// Endpoint RPC para administración del ciclo de vida de usuarios.
/// Protegido con autorización backend-first estricta.
/// {@category Endpoint}
class EndpointUser extends _i2.EndpointRef {
  EndpointUser(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Lista usuarios paginados. Requiere permiso users.view.
  _i3.Future<List<_i76.AppUser>> listUsers({
    required int limit,
    required int offset,
    required bool includeDeleted,
  }) => caller.callServerEndpoint<List<_i76.AppUser>>(
    'user',
    'listUsers',
    {
      'limit': limit,
      'offset': offset,
      'includeDeleted': includeDeleted,
    },
  );

  /// Obtiene el detalle de un usuario por ID. Requiere permiso users.view.
  _i3.Future<_i76.AppUser?> getUser(int id) =>
      caller.callServerEndpoint<_i76.AppUser?>(
        'user',
        'getUser',
        {'id': id},
      );

  /// Crea un nuevo usuario empresarial y le asocia sus roles iniciales. Requiere users.create.
  _i3.Future<_i76.AppUser> createUser({
    required String email,
    required String fullName,
    required List<int> roleIds,
  }) => caller.callServerEndpoint<_i76.AppUser>(
    'user',
    'createUser',
    {
      'email': email,
      'fullName': fullName,
      'roleIds': roleIds,
    },
  );

  /// Actualiza información de un usuario. Requiere users.update.
  _i3.Future<_i76.AppUser?> updateUser({
    required int id,
    required String fullName,
  }) => caller.callServerEndpoint<_i76.AppUser?>(
    'user',
    'updateUser',
    {
      'id': id,
      'fullName': fullName,
    },
  );

  /// Activa o desactiva la cuenta de un usuario. Requiere users.disable.
  _i3.Future<bool> setUserActive({
    required int id,
    required bool isActive,
  }) => caller.callServerEndpoint<bool>(
    'user',
    'setUserActive',
    {
      'id': id,
      'isActive': isActive,
    },
  );

  /// Borrado lógico (Soft Delete) de un usuario. Requiere users.delete.
  _i3.Future<bool> deleteUser(int id) => caller.callServerEndpoint<bool>(
    'user',
    'deleteUser',
    {'id': id},
  );

  /// Retorna el AppUser asociado a la sesión autenticada actual.
  _i3.Future<_i76.AppUser> getCurrentUser() =>
      caller.callServerEndpoint<_i76.AppUser>(
        'user',
        'getCurrentUser',
        {},
      );

  /// Cambia la contraseña del usuario autenticado.
  _i3.Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'user',
    'changePassword',
    {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i77.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    greeting = EndpointGreeting(this);
    accounting = EndpointAccounting(this);
    crmAgenda = EndpointCrmAgenda(this);
    crmCatalog = EndpointCrmCatalog(this);
    crmCustomers = EndpointCrmCustomers(this);
    crmLeads = EndpointCrmLeads(this);
    crmPipeline = EndpointCrmPipeline(this);
    hr = EndpointHr(this);
    ops = EndpointOps(this);
    rrhhApplicant = EndpointRrhhApplicant(this);
    rrhhAssignment = EndpointRrhhAssignment(this);
    rrhhDashboard = EndpointRrhhDashboard(this);
    rrhhHiring = EndpointRrhhHiring(this);
    rrhhLabor = EndpointRrhhLabor(this);
    rrhhOrganization = EndpointRrhhOrganization(this);
    rrhhPersonnel = EndpointRrhhPersonnel(this);
    audit = EndpointAudit(this);
    mfa = EndpointMfa(this);
    rbac = EndpointRbac(this);
    sessionManagement = EndpointSessionManagement(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointGreeting greeting;

  late final EndpointAccounting accounting;

  late final EndpointCrmAgenda crmAgenda;

  late final EndpointCrmCatalog crmCatalog;

  late final EndpointCrmCustomers crmCustomers;

  late final EndpointCrmLeads crmLeads;

  late final EndpointCrmPipeline crmPipeline;

  late final EndpointHr hr;

  late final EndpointOps ops;

  late final EndpointRrhhApplicant rrhhApplicant;

  late final EndpointRrhhAssignment rrhhAssignment;

  late final EndpointRrhhDashboard rrhhDashboard;

  late final EndpointRrhhHiring rrhhHiring;

  late final EndpointRrhhLabor rrhhLabor;

  late final EndpointRrhhOrganization rrhhOrganization;

  late final EndpointRrhhPersonnel rrhhPersonnel;

  late final EndpointAudit audit;

  late final EndpointMfa mfa;

  late final EndpointRbac rbac;

  late final EndpointSessionManagement sessionManagement;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'greeting': greeting,
    'accounting': accounting,
    'crmAgenda': crmAgenda,
    'crmCatalog': crmCatalog,
    'crmCustomers': crmCustomers,
    'crmLeads': crmLeads,
    'crmPipeline': crmPipeline,
    'hr': hr,
    'ops': ops,
    'rrhhApplicant': rrhhApplicant,
    'rrhhAssignment': rrhhAssignment,
    'rrhhDashboard': rrhhDashboard,
    'rrhhHiring': rrhhHiring,
    'rrhhLabor': rrhhLabor,
    'rrhhOrganization': rrhhOrganization,
    'rrhhPersonnel': rrhhPersonnel,
    'audit': audit,
    'mfa': mfa,
    'rbac': rbac,
    'sessionManagement': sessionManagement,
    'user': user,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
