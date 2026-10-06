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

/// Gastos operativos y facturas de proveedores (Cuentas por Pagar).
abstract class AccountingExpense implements _i1.SerializableModel {
  AccountingExpense._({
    this.id,
    required this.supplierName,
    required this.date,
    required this.amount,
    this.costCenterId,
    required this.category,
    String? status,
    this.description,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Pending',
       isDeleted = isDeleted ?? false;

  factory AccountingExpense({
    int? id,
    required String supplierName,
    required DateTime date,
    required double amount,
    int? costCenterId,
    required String category,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountingExpenseImpl;

  factory AccountingExpense.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountingExpense(
      id: jsonSerialization['id'] as int?,
      supplierName: jsonSerialization['supplierName'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      costCenterId: jsonSerialization['costCenterId'] as int?,
      category: jsonSerialization['category'] as String,
      status: jsonSerialization['status'] as String?,
      description: jsonSerialization['description'] as String?,
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

  /// Nombre del proveedor.
  String supplierName;

  /// Fecha del gasto.
  DateTime date;

  /// Monto del gasto.
  double amount;

  /// ID del centro de costo al que se asigna (opcional).
  int? costCenterId;

  /// Categoría del gasto: Insumos, Nómina, Servicios, Transporte, etc.
  String category;

  /// Estado: Pending, Paid.
  String status;

  /// Notas o descripción.
  String? description;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AccountingExpense]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountingExpense copyWith({
    int? id,
    String? supplierName,
    DateTime? date,
    double? amount,
    int? costCenterId,
    String? category,
    String? status,
    String? description,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountingExpense',
      if (id != null) 'id': id,
      'supplierName': supplierName,
      'date': date.toJson(),
      'amount': amount,
      if (costCenterId != null) 'costCenterId': costCenterId,
      'category': category,
      'status': status,
      if (description != null) 'description': description,
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

class _AccountingExpenseImpl extends AccountingExpense {
  _AccountingExpenseImpl({
    int? id,
    required String supplierName,
    required DateTime date,
    required double amount,
    int? costCenterId,
    required String category,
    String? status,
    String? description,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         supplierName: supplierName,
         date: date,
         amount: amount,
         costCenterId: costCenterId,
         category: category,
         status: status,
         description: description,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AccountingExpense]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountingExpense copyWith({
    Object? id = _Undefined,
    String? supplierName,
    DateTime? date,
    double? amount,
    Object? costCenterId = _Undefined,
    String? category,
    String? status,
    Object? description = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingExpense(
      id: id is int? ? id : this.id,
      supplierName: supplierName ?? this.supplierName,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      costCenterId: costCenterId is int? ? costCenterId : this.costCenterId,
      category: category ?? this.category,
      status: status ?? this.status,
      description: description is String? ? description : this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
