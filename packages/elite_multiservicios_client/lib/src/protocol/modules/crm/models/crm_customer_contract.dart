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

/// Contrato u orden de trabajo de un Cliente 360°.
abstract class CrmCustomerContract implements _i1.SerializableModel {
  CrmCustomerContract._({
    this.id,
    required this.code,
    required this.customerId,
    this.branchId,
    required this.title,
    required this.contractType,
    required this.serviceCategory,
    String? serviceFrequency,
    this.scheduleHours,
    int? billingCycleDay,
    this.specificRequirements,
    required this.totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    required this.paymentTerms,
    required this.executionTime,
    int? advancePercentage,
    String? status,
    required this.startDate,
    this.endDate,
    this.actualEndDate,
    String? originType,
    this.serviceScope,
    this.completionNotes,
    this.satisfactionRating,
    this.completedBy,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : serviceFrequency = serviceFrequency ?? 'Lunes a Viernes',
       billingCycleDay = billingCycleDay ?? 5,
       recurringMonthlyAmount = recurringMonthlyAmount ?? 0.0,
       oneTimeAmount = oneTimeAmount ?? 0.0,
       advancePercentage = advancePercentage ?? 0,
       status = status ?? 'Vigente',
       originType = originType ?? 'Venta Nueva',
       isDeleted = isDeleted ?? false;

  factory CrmCustomerContract({
    int? id,
    required String code,
    required int customerId,
    int? branchId,
    required String title,
    required String contractType,
    required String serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    required double totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    required String paymentTerms,
    required String executionTime,
    int? advancePercentage,
    String? status,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? actualEndDate,
    String? originType,
    String? serviceScope,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCustomerContractImpl;

  factory CrmCustomerContract.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCustomerContract(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      customerId: jsonSerialization['customerId'] as int,
      branchId: jsonSerialization['branchId'] as int?,
      title: jsonSerialization['title'] as String,
      contractType: jsonSerialization['contractType'] as String,
      serviceCategory: jsonSerialization['serviceCategory'] as String,
      serviceFrequency: jsonSerialization['serviceFrequency'] as String?,
      scheduleHours: jsonSerialization['scheduleHours'] as String?,
      billingCycleDay: jsonSerialization['billingCycleDay'] as int?,
      specificRequirements:
          jsonSerialization['specificRequirements'] as String?,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      recurringMonthlyAmount:
          (jsonSerialization['recurringMonthlyAmount'] as num?)?.toDouble(),
      oneTimeAmount: (jsonSerialization['oneTimeAmount'] as num?)?.toDouble(),
      paymentTerms: jsonSerialization['paymentTerms'] as String,
      executionTime: jsonSerialization['executionTime'] as String,
      advancePercentage: jsonSerialization['advancePercentage'] as int?,
      status: jsonSerialization['status'] as String?,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      actualEndDate: jsonSerialization['actualEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['actualEndDate'],
            ),
      originType: jsonSerialization['originType'] as String?,
      serviceScope: jsonSerialization['serviceScope'] as String?,
      completionNotes: jsonSerialization['completionNotes'] as String?,
      satisfactionRating: jsonSerialization['satisfactionRating'] as int?,
      completedBy: jsonSerialization['completedBy'] as String?,
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

  /// Código de contrato (ej. CTR-001).
  String code;

  /// ID del cliente asociado.
  int customerId;

  /// ID de la sede operativa vinculada (opcional).
  int? branchId;

  /// Título u objeto del contrato o servicio.
  String title;

  /// Modalidad: Recurrente Mensual, Proyecto Único, Servicio por Evento, Híbrido.
  String contractType;

  /// Categoría: Seguridad Física, Limpieza Integral, Mantenimiento, Software / Tecnología, Jardinería.
  String serviceCategory;

  /// Frecuencia del servicio acordada (ej. Lunes a Viernes, 24/7, Interdiario).
  String serviceFrequency;

  /// Horario programado de prestación (ej. 08:00 - 17:00, Turno 12h).
  String? scheduleHours;

  /// Día de corte / facturación de cuotas para Contabilidad (1 al 31).
  int? billingCycleDay;

  /// Requerimientos específicos del cliente (normativas, uniformes, pólizas).
  String? specificRequirements;

  /// Monto total global o valor referencial en Bs.
  double totalAmount;

  /// Monto recurrente mensual si aplica en Bs.
  double recurringMonthlyAmount;

  /// Monto puntual por obra/evento/instalación si aplica en Bs.
  double oneTimeAmount;

  /// Términos y condiciones de pago acordadas.
  String paymentTerms;

  /// Plazo o tiempo de ejecución estipulado.
  String executionTime;

  /// Porcentaje de anticipo pactado (0, 30, 50, 70, 100).
  int advancePercentage;

  /// Estado: Vigente, En Ejecución, Completado, En Pausa.
  String status;

  /// Fechas de vigencia.
  DateTime startDate;

  DateTime? endDate;

  DateTime? actualEndDate;

  /// Origen: Venta Nueva, Recontratación, Renovación, Adicional, Pipeline Ganada.
  String originType;

  /// Especificación técnica del alcance del servicio.
  String? serviceScope;

  /// Datos de conclusión formal de obra o servicio.
  String? completionNotes;

  int? satisfactionRating;

  String? completedBy;

  /// Observaciones adicionales.
  String? notes;

  /// Eliminación lógica.
  bool isDeleted;

  /// Fechas de auditoría temporal.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmCustomerContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomerContract copyWith({
    int? id,
    String? code,
    int? customerId,
    int? branchId,
    String? title,
    String? contractType,
    String? serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    double? totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    String? paymentTerms,
    String? executionTime,
    int? advancePercentage,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? actualEndDate,
    String? originType,
    String? serviceScope,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomerContract',
      if (id != null) 'id': id,
      'code': code,
      'customerId': customerId,
      if (branchId != null) 'branchId': branchId,
      'title': title,
      'contractType': contractType,
      'serviceCategory': serviceCategory,
      'serviceFrequency': serviceFrequency,
      if (scheduleHours != null) 'scheduleHours': scheduleHours,
      if (billingCycleDay != null) 'billingCycleDay': billingCycleDay,
      if (specificRequirements != null)
        'specificRequirements': specificRequirements,
      'totalAmount': totalAmount,
      'recurringMonthlyAmount': recurringMonthlyAmount,
      'oneTimeAmount': oneTimeAmount,
      'paymentTerms': paymentTerms,
      'executionTime': executionTime,
      'advancePercentage': advancePercentage,
      'status': status,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (actualEndDate != null) 'actualEndDate': actualEndDate?.toJson(),
      'originType': originType,
      if (serviceScope != null) 'serviceScope': serviceScope,
      if (completionNotes != null) 'completionNotes': completionNotes,
      if (satisfactionRating != null) 'satisfactionRating': satisfactionRating,
      if (completedBy != null) 'completedBy': completedBy,
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

class _CrmCustomerContractImpl extends CrmCustomerContract {
  _CrmCustomerContractImpl({
    int? id,
    required String code,
    required int customerId,
    int? branchId,
    required String title,
    required String contractType,
    required String serviceCategory,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    required double totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    required String paymentTerms,
    required String executionTime,
    int? advancePercentage,
    String? status,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? actualEndDate,
    String? originType,
    String? serviceScope,
    String? completionNotes,
    int? satisfactionRating,
    String? completedBy,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         customerId: customerId,
         branchId: branchId,
         title: title,
         contractType: contractType,
         serviceCategory: serviceCategory,
         serviceFrequency: serviceFrequency,
         scheduleHours: scheduleHours,
         billingCycleDay: billingCycleDay,
         specificRequirements: specificRequirements,
         totalAmount: totalAmount,
         recurringMonthlyAmount: recurringMonthlyAmount,
         oneTimeAmount: oneTimeAmount,
         paymentTerms: paymentTerms,
         executionTime: executionTime,
         advancePercentage: advancePercentage,
         status: status,
         startDate: startDate,
         endDate: endDate,
         actualEndDate: actualEndDate,
         originType: originType,
         serviceScope: serviceScope,
         completionNotes: completionNotes,
         satisfactionRating: satisfactionRating,
         completedBy: completedBy,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCustomerContract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomerContract copyWith({
    Object? id = _Undefined,
    String? code,
    int? customerId,
    Object? branchId = _Undefined,
    String? title,
    String? contractType,
    String? serviceCategory,
    String? serviceFrequency,
    Object? scheduleHours = _Undefined,
    Object? billingCycleDay = _Undefined,
    Object? specificRequirements = _Undefined,
    double? totalAmount,
    double? recurringMonthlyAmount,
    double? oneTimeAmount,
    String? paymentTerms,
    String? executionTime,
    int? advancePercentage,
    String? status,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? actualEndDate = _Undefined,
    String? originType,
    Object? serviceScope = _Undefined,
    Object? completionNotes = _Undefined,
    Object? satisfactionRating = _Undefined,
    Object? completedBy = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCustomerContract(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      customerId: customerId ?? this.customerId,
      branchId: branchId is int? ? branchId : this.branchId,
      title: title ?? this.title,
      contractType: contractType ?? this.contractType,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceFrequency: serviceFrequency ?? this.serviceFrequency,
      scheduleHours: scheduleHours is String?
          ? scheduleHours
          : this.scheduleHours,
      billingCycleDay: billingCycleDay is int?
          ? billingCycleDay
          : this.billingCycleDay,
      specificRequirements: specificRequirements is String?
          ? specificRequirements
          : this.specificRequirements,
      totalAmount: totalAmount ?? this.totalAmount,
      recurringMonthlyAmount:
          recurringMonthlyAmount ?? this.recurringMonthlyAmount,
      oneTimeAmount: oneTimeAmount ?? this.oneTimeAmount,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      executionTime: executionTime ?? this.executionTime,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      actualEndDate: actualEndDate is DateTime?
          ? actualEndDate
          : this.actualEndDate,
      originType: originType ?? this.originType,
      serviceScope: serviceScope is String? ? serviceScope : this.serviceScope,
      completionNotes: completionNotes is String?
          ? completionNotes
          : this.completionNotes,
      satisfactionRating: satisfactionRating is int?
          ? satisfactionRating
          : this.satisfactionRating,
      completedBy: completedBy is String? ? completedBy : this.completedBy,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
