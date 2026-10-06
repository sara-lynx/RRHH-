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

/// Compromiso o tarea comercial agendada en el CRM.
abstract class CrmTask implements _i1.SerializableModel {
  CrmTask._({
    this.id,
    required this.code,
    required this.title,
    required this.taskType,
    required this.clientName,
    required this.contactPerson,
    required this.phone,
    required this.scheduledAt,
    required this.scheduledTimeText,
    String? priority,
    String? status,
    this.callContext,
    this.notes,
    this.leadId,
    this.opportunityId,
    this.customerId,
    this.contractId,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : priority = priority ?? 'Media',
       status = status ?? 'Pendiente',
       isDeleted = isDeleted ?? false;

  factory CrmTask({
    int? id,
    required String code,
    required String title,
    required String taskType,
    required String clientName,
    required String contactPerson,
    required String phone,
    required DateTime scheduledAt,
    required String scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    int? leadId,
    int? opportunityId,
    int? customerId,
    int? contractId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmTaskImpl;

  factory CrmTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmTask(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      taskType: jsonSerialization['taskType'] as String,
      clientName: jsonSerialization['clientName'] as String,
      contactPerson: jsonSerialization['contactPerson'] as String,
      phone: jsonSerialization['phone'] as String,
      scheduledAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledAt'],
      ),
      scheduledTimeText: jsonSerialization['scheduledTimeText'] as String,
      priority: jsonSerialization['priority'] as String?,
      status: jsonSerialization['status'] as String?,
      callContext: jsonSerialization['callContext'] as String?,
      notes: jsonSerialization['notes'] as String?,
      leadId: jsonSerialization['leadId'] as int?,
      opportunityId: jsonSerialization['opportunityId'] as int?,
      customerId: jsonSerialization['customerId'] as int?,
      contractId: jsonSerialization['contractId'] as int?,
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

  /// Código de seguimiento de la tarea (ej. TSK-001).
  String code;

  /// Título descriptivo del compromiso comercial.
  String title;

  /// Tipo de tarea: Llamada de Seguimiento, Enviar Cotización, Visita Técnica, Reunión Presencial / Virtual, Mensaje WhatsApp, Cobro / Seguimiento de Anticipo, Postventa / Control de Calidad, Renovación de Contrato.
  String taskType;

  /// Nombre del cliente o prospecto asociado.
  String clientName;

  /// Persona o contacto decisor.
  String contactPerson;

  /// Teléfono de contacto.
  String phone;

  /// Fecha programada de ejecución.
  DateTime scheduledAt;

  /// Texto de hora programada (ej. '10:00', '16:30').
  String scheduledTimeText;

  /// Prioridad: Alta / Urgente, Media, Normal.
  String priority;

  /// Estado: Pendiente, Completada, Pospuesta, Vencida.
  String status;

  /// Contexto de llamada o recordatorio operativo.
  String? callContext;

  /// Notas u observaciones posteriores a la gestión.
  String? notes;

  /// Enlaces transversales con otros submódulos
  int? leadId;

  int? opportunityId;

  int? customerId;

  int? contractId;

  /// Eliminación lógica y auditoría temporal
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmTask copyWith({
    int? id,
    String? code,
    String? title,
    String? taskType,
    String? clientName,
    String? contactPerson,
    String? phone,
    DateTime? scheduledAt,
    String? scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    int? leadId,
    int? opportunityId,
    int? customerId,
    int? contractId,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmTask',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'taskType': taskType,
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'scheduledAt': scheduledAt.toJson(),
      'scheduledTimeText': scheduledTimeText,
      'priority': priority,
      'status': status,
      if (callContext != null) 'callContext': callContext,
      if (notes != null) 'notes': notes,
      if (leadId != null) 'leadId': leadId,
      if (opportunityId != null) 'opportunityId': opportunityId,
      if (customerId != null) 'customerId': customerId,
      if (contractId != null) 'contractId': contractId,
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

class _CrmTaskImpl extends CrmTask {
  _CrmTaskImpl({
    int? id,
    required String code,
    required String title,
    required String taskType,
    required String clientName,
    required String contactPerson,
    required String phone,
    required DateTime scheduledAt,
    required String scheduledTimeText,
    String? priority,
    String? status,
    String? callContext,
    String? notes,
    int? leadId,
    int? opportunityId,
    int? customerId,
    int? contractId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         title: title,
         taskType: taskType,
         clientName: clientName,
         contactPerson: contactPerson,
         phone: phone,
         scheduledAt: scheduledAt,
         scheduledTimeText: scheduledTimeText,
         priority: priority,
         status: status,
         callContext: callContext,
         notes: notes,
         leadId: leadId,
         opportunityId: opportunityId,
         customerId: customerId,
         contractId: contractId,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmTask]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmTask copyWith({
    Object? id = _Undefined,
    String? code,
    String? title,
    String? taskType,
    String? clientName,
    String? contactPerson,
    String? phone,
    DateTime? scheduledAt,
    String? scheduledTimeText,
    String? priority,
    String? status,
    Object? callContext = _Undefined,
    Object? notes = _Undefined,
    Object? leadId = _Undefined,
    Object? opportunityId = _Undefined,
    Object? customerId = _Undefined,
    Object? contractId = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmTask(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      taskType: taskType ?? this.taskType,
      clientName: clientName ?? this.clientName,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      scheduledTimeText: scheduledTimeText ?? this.scheduledTimeText,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      callContext: callContext is String? ? callContext : this.callContext,
      notes: notes is String? ? notes : this.notes,
      leadId: leadId is int? ? leadId : this.leadId,
      opportunityId: opportunityId is int? ? opportunityId : this.opportunityId,
      customerId: customerId is int? ? customerId : this.customerId,
      contractId: contractId is int? ? contractId : this.contractId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
