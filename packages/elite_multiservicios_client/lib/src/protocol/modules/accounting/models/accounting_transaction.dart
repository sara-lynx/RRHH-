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

/// Transacciones financieras (Ingresos y Egresos reales en banco o caja).
abstract class AccountingTransaction implements _i1.SerializableModel {
  AccountingTransaction._({
    this.id,
    required this.date,
    required this.amount,
    required this.type,
    this.referenceId,
    this.account,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : isDeleted = isDeleted ?? false;

  factory AccountingTransaction({
    int? id,
    required DateTime date,
    required double amount,
    required String type,
    int? referenceId,
    String? account,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingTransactionImpl;

  factory AccountingTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountingTransaction(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      type: jsonSerialization['type'] as String,
      referenceId: jsonSerialization['referenceId'] as int?,
      account: jsonSerialization['account'] as String?,
      notes: jsonSerialization['notes'] as String?,
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

  /// Fecha de la transacción.
  DateTime date;

  /// Monto de la transacción.
  double amount;

  /// Tipo de transacción: Income (Ingreso), Expense (Egreso).
  String type;

  /// Referencia a ID de Factura (si es ingreso) o Gasto (si es egreso).
  int? referenceId;

  /// Origen/Destino de los fondos (ej. Cuenta Bancaria, Caja Chica).
  String? account;

  /// Notas adicionales.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AccountingTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingTransaction copyWith({
    int? id,
    DateTime? date,
    double? amount,
    String? type,
    int? referenceId,
    String? account,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingTransaction',
      if (id != null) 'id': id,
      'date': date.toJson(),
      'amount': amount,
      'type': type,
      if (referenceId != null) 'referenceId': referenceId,
      if (account != null) 'account': account,
      if (notes != null) 'notes': notes,
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

class _AccountingTransactionImpl extends AccountingTransaction {
  _AccountingTransactionImpl({
    int? id,
    required DateTime date,
    required double amount,
    required String type,
    int? referenceId,
    String? account,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         date: date,
         amount: amount,
         type: type,
         referenceId: referenceId,
         account: account,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingTransaction copyWith({
    Object? id = _Undefined,
    DateTime? date,
    double? amount,
    String? type,
    Object? referenceId = _Undefined,
    Object? account = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingTransaction(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      referenceId: referenceId is int? ? referenceId : this.referenceId,
      account: account is String? ? account : this.account,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
