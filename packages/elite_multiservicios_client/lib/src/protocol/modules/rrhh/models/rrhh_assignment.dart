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

/// Asignación de Personal a Sede de Cliente (Campo) o Área Corporativa (Oficina).
abstract class RrhhAssignment implements _i1.SerializableModel {
  RrhhAssignment._({
    this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.assignmentType,
    this.officeAreaId,
    this.officeAreaName,
    this.officeRole,
    this.customerId,
    this.customerCompanyName,
    this.workplaceBranch,
    this.contractedServiceName,
    required this.supervisorName,
    this.supervisorEmployeeId,
    required this.scheduleId,
    required this.scheduleName,
    required this.startDate,
    this.endDate,
    String? status,
    int? rotationNumber,
    this.originDescription,
    this.rotationReason,
    this.notes,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'ACTIVA',
       rotationNumber = rotationNumber ?? 0,
       isDeleted = isDeleted ?? false;

  factory RrhhAssignment({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String assignmentType,
    int? officeAreaId,
    String? officeAreaName,
    String? officeRole,
    int? customerId,
    String? customerCompanyName,
    String? workplaceBranch,
    String? contractedServiceName,
    required String supervisorName,
    int? supervisorEmployeeId,
    required int scheduleId,
    required String scheduleName,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    int? rotationNumber,
    String? originDescription,
    String? rotationReason,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhAssignmentImpl;

  factory RrhhAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhAssignment(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      employeeId: jsonSerialization['employeeId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      assignmentType: jsonSerialization['assignmentType'] as String,
      officeAreaId: jsonSerialization['officeAreaId'] as int?,
      officeAreaName: jsonSerialization['officeAreaName'] as String?,
      officeRole: jsonSerialization['officeRole'] as String?,
      customerId: jsonSerialization['customerId'] as int?,
      customerCompanyName: jsonSerialization['customerCompanyName'] as String?,
      workplaceBranch: jsonSerialization['workplaceBranch'] as String?,
      contractedServiceName:
          jsonSerialization['contractedServiceName'] as String?,
      supervisorName: jsonSerialization['supervisorName'] as String,
      supervisorEmployeeId: jsonSerialization['supervisorEmployeeId'] as int?,
      scheduleId: jsonSerialization['scheduleId'] as int,
      scheduleName: jsonSerialization['scheduleName'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String?,
      rotationNumber: jsonSerialization['rotationNumber'] as int?,
      originDescription: jsonSerialization['originDescription'] as String?,
      rotationReason: jsonSerialization['rotationReason'] as String?,
      notes: jsonSerialization['notes'] as String?,
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
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

  /// Código institucional de la asignación (ej: ASG-001).
  String code;

  /// Colaborador asignado
  int employeeId;

  String employeeCode;

  String employeeName;

  /// Modalidad de la asignación: 'OFICINA' o 'CAMPO'
  String assignmentType;

  /// Modalidad Oficina: Área y Rol Interno
  int? officeAreaId;

  String? officeAreaName;

  String? officeRole;

  /// Modalidad Campo: Referencias a CRM y Sedes de Clientes
  int? customerId;

  String? customerCompanyName;

  String? workplaceBranch;

  String? contractedServiceName;

  /// Supervisión y Turno
  String supervisorName;

  int? supervisorEmployeeId;

  int scheduleId;

  String scheduleName;

  /// Fechas y Vigencia
  DateTime startDate;

  DateTime? endDate;

  /// Estado de la asignación: 'ACTIVA', 'FINALIZADA', 'CANCELADA'
  String status;

  /// Rotación Histórica Inmutable (Prohibido sobreescribir)
  /// Número de rotación (0 = Puesto Inicial, 1 = Rotación #1, etc.)
  int rotationNumber;

  /// Descripción del destino anterior antes de rotar
  String? originDescription;

  /// Motivo o justificación de la rotación
  String? rotationReason;

  String? notes;

  /// Eliminación lógica y auditoría
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhAssignment copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? assignmentType,
    int? officeAreaId,
    String? officeAreaName,
    String? officeRole,
    int? customerId,
    String? customerCompanyName,
    String? workplaceBranch,
    String? contractedServiceName,
    String? supervisorName,
    int? supervisorEmployeeId,
    int? scheduleId,
    String? scheduleName,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    int? rotationNumber,
    String? originDescription,
    String? rotationReason,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhAssignment',
      if (id != null) 'id': id,
      'code': code,
      'employeeId': employeeId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'assignmentType': assignmentType,
      if (officeAreaId != null) 'officeAreaId': officeAreaId,
      if (officeAreaName != null) 'officeAreaName': officeAreaName,
      if (officeRole != null) 'officeRole': officeRole,
      if (customerId != null) 'customerId': customerId,
      if (customerCompanyName != null)
        'customerCompanyName': customerCompanyName,
      if (workplaceBranch != null) 'workplaceBranch': workplaceBranch,
      if (contractedServiceName != null)
        'contractedServiceName': contractedServiceName,
      'supervisorName': supervisorName,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      'scheduleId': scheduleId,
      'scheduleName': scheduleName,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'status': status,
      'rotationNumber': rotationNumber,
      if (originDescription != null) 'originDescription': originDescription,
      if (rotationReason != null) 'rotationReason': rotationReason,
      if (notes != null) 'notes': notes,
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
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

class _RrhhAssignmentImpl extends RrhhAssignment {
  _RrhhAssignmentImpl({
    int? id,
    required String code,
    required int employeeId,
    required String employeeCode,
    required String employeeName,
    required String assignmentType,
    int? officeAreaId,
    String? officeAreaName,
    String? officeRole,
    int? customerId,
    String? customerCompanyName,
    String? workplaceBranch,
    String? contractedServiceName,
    required String supervisorName,
    int? supervisorEmployeeId,
    required int scheduleId,
    required String scheduleName,
    required DateTime startDate,
    DateTime? endDate,
    String? status,
    int? rotationNumber,
    String? originDescription,
    String? rotationReason,
    String? notes,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         employeeId: employeeId,
         employeeCode: employeeCode,
         employeeName: employeeName,
         assignmentType: assignmentType,
         officeAreaId: officeAreaId,
         officeAreaName: officeAreaName,
         officeRole: officeRole,
         customerId: customerId,
         customerCompanyName: customerCompanyName,
         workplaceBranch: workplaceBranch,
         contractedServiceName: contractedServiceName,
         supervisorName: supervisorName,
         supervisorEmployeeId: supervisorEmployeeId,
         scheduleId: scheduleId,
         scheduleName: scheduleName,
         startDate: startDate,
         endDate: endDate,
         status: status,
         rotationNumber: rotationNumber,
         originDescription: originDescription,
         rotationReason: rotationReason,
         notes: notes,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhAssignment copyWith({
    Object? id = _Undefined,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    String? assignmentType,
    Object? officeAreaId = _Undefined,
    Object? officeAreaName = _Undefined,
    Object? officeRole = _Undefined,
    Object? customerId = _Undefined,
    Object? customerCompanyName = _Undefined,
    Object? workplaceBranch = _Undefined,
    Object? contractedServiceName = _Undefined,
    String? supervisorName,
    Object? supervisorEmployeeId = _Undefined,
    int? scheduleId,
    String? scheduleName,
    DateTime? startDate,
    Object? endDate = _Undefined,
    String? status,
    int? rotationNumber,
    Object? originDescription = _Undefined,
    Object? rotationReason = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhAssignment(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      assignmentType: assignmentType ?? this.assignmentType,
      officeAreaId: officeAreaId is int? ? officeAreaId : this.officeAreaId,
      officeAreaName: officeAreaName is String?
          ? officeAreaName
          : this.officeAreaName,
      officeRole: officeRole is String? ? officeRole : this.officeRole,
      customerId: customerId is int? ? customerId : this.customerId,
      customerCompanyName: customerCompanyName is String?
          ? customerCompanyName
          : this.customerCompanyName,
      workplaceBranch: workplaceBranch is String?
          ? workplaceBranch
          : this.workplaceBranch,
      contractedServiceName: contractedServiceName is String?
          ? contractedServiceName
          : this.contractedServiceName,
      supervisorName: supervisorName ?? this.supervisorName,
      supervisorEmployeeId: supervisorEmployeeId is int?
          ? supervisorEmployeeId
          : this.supervisorEmployeeId,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduleName: scheduleName ?? this.scheduleName,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      status: status ?? this.status,
      rotationNumber: rotationNumber ?? this.rotationNumber,
      originDescription: originDescription is String?
          ? originDescription
          : this.originDescription,
      rotationReason: rotationReason is String?
          ? rotationReason
          : this.rotationReason,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
