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

/// Factura emitida a clientes (Cuentas por Cobrar).
abstract class AccountingInvoice implements _i1.SerializableModel {
  AccountingInvoice._({
    this.id,
    required this.invoiceNumber,
    required this.customerId,
    required this.issueDate,
    required this.dueDate,
    required this.totalAmount,
    String? status,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending',
       isDeleted = isDeleted ?? false;

  factory AccountingInvoice({
    int? id,
    required String invoiceNumber,
    required int customerId,
    required DateTime issueDate,
    required DateTime dueDate,
    required double totalAmount,
    String? status,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingInvoiceImpl;

  factory AccountingInvoice.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingInvoice(
      id: jsonSerialization['id'] as int?,
      invoiceNumber: jsonSerialization['invoiceNumber'] as String,
      customerId: jsonSerialization['customerId'] as int,
      issueDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['issueDate'],
      ),
      dueDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      status: jsonSerialization['status'] as String?,
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

  /// Número de factura.
  String invoiceNumber;

  /// Referencia al cliente en el módulo CRM.
  int customerId;

  /// Fecha de emisión.
  DateTime issueDate;

  /// Fecha de vencimiento.
  DateTime dueDate;

  /// Monto total de la factura.
  double totalAmount;

  /// Estado: Pending, Paid, Cancelled, Overdue.
  String status;

  /// Notas adicionales.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AccountingInvoice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingInvoice copyWith({
    int? id,
    String? invoiceNumber,
    int? customerId,
    DateTime? issueDate,
    DateTime? dueDate,
    double? totalAmount,
    String? status,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingInvoice',
      if (id != null) 'id': id,
      'invoiceNumber': invoiceNumber,
      'customerId': customerId,
      'issueDate': issueDate.toJson(),
      'dueDate': dueDate.toJson(),
      'totalAmount': totalAmount,
      'status': status,
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

class _AccountingInvoiceImpl extends AccountingInvoice {
  _AccountingInvoiceImpl({
    int? id,
    required String invoiceNumber,
    required int customerId,
    required DateTime issueDate,
    required DateTime dueDate,
    required double totalAmount,
    String? status,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         invoiceNumber: invoiceNumber,
         customerId: customerId,
         issueDate: issueDate,
         dueDate: dueDate,
         totalAmount: totalAmount,
         status: status,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingInvoice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingInvoice copyWith({
    Object? id = _Undefined,
    String? invoiceNumber,
    int? customerId,
    DateTime? issueDate,
    DateTime? dueDate,
    double? totalAmount,
    String? status,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingInvoice(
      id: id is int? ? id : this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
