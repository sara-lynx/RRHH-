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
import '../../../modules/rrhh/models/rrhh_dossier_document.dart' as _i2;
import '../../../modules/rrhh/models/rrhh_employee_bonus.dart' as _i3;
import '../../../modules/rrhh/models/rrhh_employee_deduction.dart' as _i4;
import 'package:elite_multiservicios_client/src/protocol/protocol.dart' as _i5;

/// Expediente de Contratación (FASE C). Conecta la etapa SELECCIONADO con el alta en Nómina.
abstract class RrhhHiringDossier implements _i1.SerializableModel {
  RrhhHiringDossier._({
    this.id,
    required this.code,
    this.applicantId,
    required this.applicantCode,
    required this.applicantName,
    this.employeeId,
    this.convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    this.documentChecklist,
    this.afpName,
    this.afpNumber,
    this.healthInsurance,
    this.section2Notes,
    this.fullAddress,
    this.maritalStatus,
    this.childrenCount,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.contractType,
    this.workdayType,
    this.paymentModality,
    this.baseSalary,
    this.contractStartDate,
    this.contractEndDate,
    this.bonuses,
    this.deductions,
    this.section4Notes,
    this.areaId,
    this.positionId,
    this.shiftId,
    this.scheduleId,
    this.baseLocation,
    this.supervisorEmployeeId,
    this.effectiveStartDate,
    this.section5Notes,
    this.closingNotes,
    this.approvedBy,
    this.approvedAt,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
    bool? isDeleted,
    this.deletedAt,
  }) : status = status ?? 'abierto',
       section1Status = section1Status ?? 'pendiente',
       section2Status = section2Status ?? 'pendiente',
       section3Status = section3Status ?? 'pendiente',
       section4Status = section4Status ?? 'pendiente',
       section5Status = section5Status ?? 'pendiente',
       section6Status = section6Status ?? 'pendiente',
       isDeleted = isDeleted ?? false;

  factory RrhhHiringDossier({
    int? id,
    required String code,
    int? applicantId,
    required String applicantCode,
    required String applicantName,
    int? employeeId,
    String? convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    List<_i2.RrhhDossierDocument>? documentChecklist,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i3.RrhhEmployeeBonus>? bonuses,
    List<_i4.RrhhEmployeeDeduction>? deductions,
    String? section4Notes,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? section5Notes,
    String? closingNotes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? closedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) = _RrhhHiringDossierImpl;

  factory RrhhHiringDossier.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhHiringDossier(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      applicantId: jsonSerialization['applicantId'] as int?,
      applicantCode: jsonSerialization['applicantCode'] as String,
      applicantName: jsonSerialization['applicantName'] as String,
      employeeId: jsonSerialization['employeeId'] as int?,
      convertedEmployeeCode:
          jsonSerialization['convertedEmployeeCode'] as String?,
      status: jsonSerialization['status'] as String?,
      section1Status: jsonSerialization['section1Status'] as String?,
      section2Status: jsonSerialization['section2Status'] as String?,
      section3Status: jsonSerialization['section3Status'] as String?,
      section4Status: jsonSerialization['section4Status'] as String?,
      section5Status: jsonSerialization['section5Status'] as String?,
      section6Status: jsonSerialization['section6Status'] as String?,
      documentChecklist: jsonSerialization['documentChecklist'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i2.RrhhDossierDocument>>(
              jsonSerialization['documentChecklist'],
            ),
      afpName: jsonSerialization['afpName'] as String?,
      afpNumber: jsonSerialization['afpNumber'] as String?,
      healthInsurance: jsonSerialization['healthInsurance'] as String?,
      section2Notes: jsonSerialization['section2Notes'] as String?,
      fullAddress: jsonSerialization['fullAddress'] as String?,
      maritalStatus: jsonSerialization['maritalStatus'] as String?,
      childrenCount: jsonSerialization['childrenCount'] as int?,
      emergencyContactName:
          jsonSerialization['emergencyContactName'] as String?,
      emergencyContactPhone:
          jsonSerialization['emergencyContactPhone'] as String?,
      emergencyContactRelation:
          jsonSerialization['emergencyContactRelation'] as String?,
      contractType: jsonSerialization['contractType'] as String?,
      workdayType: jsonSerialization['workdayType'] as String?,
      paymentModality: jsonSerialization['paymentModality'] as String?,
      baseSalary: (jsonSerialization['baseSalary'] as num?)?.toDouble(),
      contractStartDate: jsonSerialization['contractStartDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['contractStartDate'],
            ),
      contractEndDate: jsonSerialization['contractEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['contractEndDate'],
            ),
      bonuses: jsonSerialization['bonuses'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i3.RrhhEmployeeBonus>>(
              jsonSerialization['bonuses'],
            ),
      deductions: jsonSerialization['deductions'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i4.RrhhEmployeeDeduction>>(
              jsonSerialization['deductions'],
            ),
      section4Notes: jsonSerialization['section4Notes'] as String?,
      areaId: jsonSerialization['areaId'] as int?,
      positionId: jsonSerialization['positionId'] as int?,
      shiftId: jsonSerialization['shiftId'] as String?,
      scheduleId: jsonSerialization['scheduleId'] as String?,
      baseLocation: jsonSerialization['baseLocation'] as String?,
      supervisorEmployeeId:
          jsonSerialization['supervisorEmployeeId'] as String?,
      effectiveStartDate: jsonSerialization['effectiveStartDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['effectiveStartDate'],
            ),
      section5Notes: jsonSerialization['section5Notes'] as String?,
      closingNotes: jsonSerialization['closingNotes'] as String?,
      approvedBy: jsonSerialization['approvedBy'] as String?,
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      createdBy: jsonSerialization['createdBy'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      closedAt: jsonSerialization['closedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Identificación
  String code;

  /// Referencias
  int? applicantId;

  String applicantCode;

  String applicantName;

  int? employeeId;

  String? convertedEmployeeCode;

  /// Estado general del expediente
  /// 'abierto' | 'en_proceso' | 'listo_para_convertir' | 'convertido' | 'pausado' | 'cancelado'
  String status;

  /// Estados por sección ('pendiente' | 'en_proceso' | 'completa')
  String section1Status;

  String section2Status;

  String section3Status;

  String section4Status;

  String section5Status;

  String section6Status;

  /// Sección 1: Documentos (checklist estructurado)
  List<_i2.RrhhDossierDocument>? documentChecklist;

  /// Sección 2: Afiliación seguridad social
  String? afpName;

  String? afpNumber;

  String? healthInsurance;

  String? section2Notes;

  /// Sección 3: Datos personales complementarios
  String? fullAddress;

  String? maritalStatus;

  int? childrenCount;

  String? emergencyContactName;

  String? emergencyContactPhone;

  String? emergencyContactRelation;

  /// Sección 4: Condiciones contractuales
  String? contractType;

  String? workdayType;

  String? paymentModality;

  double? baseSalary;

  DateTime? contractStartDate;

  DateTime? contractEndDate;

  List<_i3.RrhhEmployeeBonus>? bonuses;

  List<_i4.RrhhEmployeeDeduction>? deductions;

  String? section4Notes;

  /// Sección 5: Asignación organizacional
  int? areaId;

  int? positionId;

  String? shiftId;

  String? scheduleId;

  String? baseLocation;

  String? supervisorEmployeeId;

  DateTime? effectiveStartDate;

  String? section5Notes;

  /// Sección 6: Cierre
  String? closingNotes;

  String? approvedBy;

  DateTime? approvedAt;

  /// Auditoría
  String? createdBy;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? closedAt;

  bool isDeleted;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [RrhhHiringDossier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhHiringDossier copyWith({
    int? id,
    String? code,
    int? applicantId,
    String? applicantCode,
    String? applicantName,
    int? employeeId,
    String? convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    List<_i2.RrhhDossierDocument>? documentChecklist,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i3.RrhhEmployeeBonus>? bonuses,
    List<_i4.RrhhEmployeeDeduction>? deductions,
    String? section4Notes,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? section5Notes,
    String? closingNotes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhHiringDossier',
      if (id != null) 'id': id,
      'code': code,
      if (applicantId != null) 'applicantId': applicantId,
      'applicantCode': applicantCode,
      'applicantName': applicantName,
      if (employeeId != null) 'employeeId': employeeId,
      if (convertedEmployeeCode != null)
        'convertedEmployeeCode': convertedEmployeeCode,
      'status': status,
      'section1Status': section1Status,
      'section2Status': section2Status,
      'section3Status': section3Status,
      'section4Status': section4Status,
      'section5Status': section5Status,
      'section6Status': section6Status,
      if (documentChecklist != null)
        'documentChecklist': documentChecklist?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (afpName != null) 'afpName': afpName,
      if (afpNumber != null) 'afpNumber': afpNumber,
      if (healthInsurance != null) 'healthInsurance': healthInsurance,
      if (section2Notes != null) 'section2Notes': section2Notes,
      if (fullAddress != null) 'fullAddress': fullAddress,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (childrenCount != null) 'childrenCount': childrenCount,
      if (emergencyContactName != null)
        'emergencyContactName': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergencyContactPhone': emergencyContactPhone,
      if (emergencyContactRelation != null)
        'emergencyContactRelation': emergencyContactRelation,
      if (contractType != null) 'contractType': contractType,
      if (workdayType != null) 'workdayType': workdayType,
      if (paymentModality != null) 'paymentModality': paymentModality,
      if (baseSalary != null) 'baseSalary': baseSalary,
      if (contractStartDate != null)
        'contractStartDate': contractStartDate?.toJson(),
      if (contractEndDate != null) 'contractEndDate': contractEndDate?.toJson(),
      if (bonuses != null)
        'bonuses': bonuses?.toJson(valueToJson: (v) => v.toJson()),
      if (deductions != null)
        'deductions': deductions?.toJson(valueToJson: (v) => v.toJson()),
      if (section4Notes != null) 'section4Notes': section4Notes,
      if (areaId != null) 'areaId': areaId,
      if (positionId != null) 'positionId': positionId,
      if (shiftId != null) 'shiftId': shiftId,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (baseLocation != null) 'baseLocation': baseLocation,
      if (supervisorEmployeeId != null)
        'supervisorEmployeeId': supervisorEmployeeId,
      if (effectiveStartDate != null)
        'effectiveStartDate': effectiveStartDate?.toJson(),
      if (section5Notes != null) 'section5Notes': section5Notes,
      if (closingNotes != null) 'closingNotes': closingNotes,
      if (approvedBy != null) 'approvedBy': approvedBy,
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhHiringDossierImpl extends RrhhHiringDossier {
  _RrhhHiringDossierImpl({
    int? id,
    required String code,
    int? applicantId,
    required String applicantCode,
    required String applicantName,
    int? employeeId,
    String? convertedEmployeeCode,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    List<_i2.RrhhDossierDocument>? documentChecklist,
    String? afpName,
    String? afpNumber,
    String? healthInsurance,
    String? section2Notes,
    String? fullAddress,
    String? maritalStatus,
    int? childrenCount,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? contractType,
    String? workdayType,
    String? paymentModality,
    double? baseSalary,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    List<_i3.RrhhEmployeeBonus>? bonuses,
    List<_i4.RrhhEmployeeDeduction>? deductions,
    String? section4Notes,
    int? areaId,
    int? positionId,
    String? shiftId,
    String? scheduleId,
    String? baseLocation,
    String? supervisorEmployeeId,
    DateTime? effectiveStartDate,
    String? section5Notes,
    String? closingNotes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? closedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         code: code,
         applicantId: applicantId,
         applicantCode: applicantCode,
         applicantName: applicantName,
         employeeId: employeeId,
         convertedEmployeeCode: convertedEmployeeCode,
         status: status,
         section1Status: section1Status,
         section2Status: section2Status,
         section3Status: section3Status,
         section4Status: section4Status,
         section5Status: section5Status,
         section6Status: section6Status,
         documentChecklist: documentChecklist,
         afpName: afpName,
         afpNumber: afpNumber,
         healthInsurance: healthInsurance,
         section2Notes: section2Notes,
         fullAddress: fullAddress,
         maritalStatus: maritalStatus,
         childrenCount: childrenCount,
         emergencyContactName: emergencyContactName,
         emergencyContactPhone: emergencyContactPhone,
         emergencyContactRelation: emergencyContactRelation,
         contractType: contractType,
         workdayType: workdayType,
         paymentModality: paymentModality,
         baseSalary: baseSalary,
         contractStartDate: contractStartDate,
         contractEndDate: contractEndDate,
         bonuses: bonuses,
         deductions: deductions,
         section4Notes: section4Notes,
         areaId: areaId,
         positionId: positionId,
         shiftId: shiftId,
         scheduleId: scheduleId,
         baseLocation: baseLocation,
         supervisorEmployeeId: supervisorEmployeeId,
         effectiveStartDate: effectiveStartDate,
         section5Notes: section5Notes,
         closingNotes: closingNotes,
         approvedBy: approvedBy,
         approvedAt: approvedAt,
         createdBy: createdBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         closedAt: closedAt,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [RrhhHiringDossier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhHiringDossier copyWith({
    Object? id = _Undefined,
    String? code,
    Object? applicantId = _Undefined,
    String? applicantCode,
    String? applicantName,
    Object? employeeId = _Undefined,
    Object? convertedEmployeeCode = _Undefined,
    String? status,
    String? section1Status,
    String? section2Status,
    String? section3Status,
    String? section4Status,
    String? section5Status,
    String? section6Status,
    Object? documentChecklist = _Undefined,
    Object? afpName = _Undefined,
    Object? afpNumber = _Undefined,
    Object? healthInsurance = _Undefined,
    Object? section2Notes = _Undefined,
    Object? fullAddress = _Undefined,
    Object? maritalStatus = _Undefined,
    Object? childrenCount = _Undefined,
    Object? emergencyContactName = _Undefined,
    Object? emergencyContactPhone = _Undefined,
    Object? emergencyContactRelation = _Undefined,
    Object? contractType = _Undefined,
    Object? workdayType = _Undefined,
    Object? paymentModality = _Undefined,
    Object? baseSalary = _Undefined,
    Object? contractStartDate = _Undefined,
    Object? contractEndDate = _Undefined,
    Object? bonuses = _Undefined,
    Object? deductions = _Undefined,
    Object? section4Notes = _Undefined,
    Object? areaId = _Undefined,
    Object? positionId = _Undefined,
    Object? shiftId = _Undefined,
    Object? scheduleId = _Undefined,
    Object? baseLocation = _Undefined,
    Object? supervisorEmployeeId = _Undefined,
    Object? effectiveStartDate = _Undefined,
    Object? section5Notes = _Undefined,
    Object? closingNotes = _Undefined,
    Object? approvedBy = _Undefined,
    Object? approvedAt = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? closedAt = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
  }) {
    return RrhhHiringDossier(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      applicantId: applicantId is int? ? applicantId : this.applicantId,
      applicantCode: applicantCode ?? this.applicantCode,
      applicantName: applicantName ?? this.applicantName,
      employeeId: employeeId is int? ? employeeId : this.employeeId,
      convertedEmployeeCode: convertedEmployeeCode is String?
          ? convertedEmployeeCode
          : this.convertedEmployeeCode,
      status: status ?? this.status,
      section1Status: section1Status ?? this.section1Status,
      section2Status: section2Status ?? this.section2Status,
      section3Status: section3Status ?? this.section3Status,
      section4Status: section4Status ?? this.section4Status,
      section5Status: section5Status ?? this.section5Status,
      section6Status: section6Status ?? this.section6Status,
      documentChecklist: documentChecklist is List<_i2.RrhhDossierDocument>?
          ? documentChecklist
          : this.documentChecklist?.map((e0) => e0.copyWith()).toList(),
      afpName: afpName is String? ? afpName : this.afpName,
      afpNumber: afpNumber is String? ? afpNumber : this.afpNumber,
      healthInsurance: healthInsurance is String?
          ? healthInsurance
          : this.healthInsurance,
      section2Notes: section2Notes is String?
          ? section2Notes
          : this.section2Notes,
      fullAddress: fullAddress is String? ? fullAddress : this.fullAddress,
      maritalStatus: maritalStatus is String?
          ? maritalStatus
          : this.maritalStatus,
      childrenCount: childrenCount is int? ? childrenCount : this.childrenCount,
      emergencyContactName: emergencyContactName is String?
          ? emergencyContactName
          : this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone is String?
          ? emergencyContactPhone
          : this.emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation is String?
          ? emergencyContactRelation
          : this.emergencyContactRelation,
      contractType: contractType is String? ? contractType : this.contractType,
      workdayType: workdayType is String? ? workdayType : this.workdayType,
      paymentModality: paymentModality is String?
          ? paymentModality
          : this.paymentModality,
      baseSalary: baseSalary is double? ? baseSalary : this.baseSalary,
      contractStartDate: contractStartDate is DateTime?
          ? contractStartDate
          : this.contractStartDate,
      contractEndDate: contractEndDate is DateTime?
          ? contractEndDate
          : this.contractEndDate,
      bonuses: bonuses is List<_i3.RrhhEmployeeBonus>?
          ? bonuses
          : this.bonuses?.map((e0) => e0.copyWith()).toList(),
      deductions: deductions is List<_i4.RrhhEmployeeDeduction>?
          ? deductions
          : this.deductions?.map((e0) => e0.copyWith()).toList(),
      section4Notes: section4Notes is String?
          ? section4Notes
          : this.section4Notes,
      areaId: areaId is int? ? areaId : this.areaId,
      positionId: positionId is int? ? positionId : this.positionId,
      shiftId: shiftId is String? ? shiftId : this.shiftId,
      scheduleId: scheduleId is String? ? scheduleId : this.scheduleId,
      baseLocation: baseLocation is String? ? baseLocation : this.baseLocation,
      supervisorEmployeeId: supervisorEmployeeId is String?
          ? supervisorEmployeeId
          : this.supervisorEmployeeId,
      effectiveStartDate: effectiveStartDate is DateTime?
          ? effectiveStartDate
          : this.effectiveStartDate,
      section5Notes: section5Notes is String?
          ? section5Notes
          : this.section5Notes,
      closingNotes: closingNotes is String? ? closingNotes : this.closingNotes,
      approvedBy: approvedBy is String? ? approvedBy : this.approvedBy,
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt is DateTime? ? closedAt : this.closedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
