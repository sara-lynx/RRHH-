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

/// Postulante o candidato en proceso de selección y reclutamiento laboral.
abstract class RrhhApplicant implements _i1.SerializableModel {
  RrhhApplicant._({
    this.id,
    required this.code,
    required this.fullName,
    required this.identityCard,
    required this.phone,
    this.email,
    this.address,
    this.birthDate,
    this.emergencyContact,
    this.emergencyPhone,
    this.targetArea,
    this.areaId,
    this.targetPosition,
    this.positionId,
    required this.targetType,
    this.specialty,
    this.specialtyId,
    this.education,
    this.experienceSummary,
    this.skills,
    this.referencePerson,
    this.referencePhone,
    required this.applicationDate,
    String? status,
    this.interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    this.cvUrl,
    this.discardReason,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'NUEVO',
       expectedSalary = expectedSalary ?? 0.0,
       hasCvAttached = hasCvAttached ?? true,
       hasIdentityCardCopy = hasIdentityCardCopy ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhApplicant({
    int? id,
    required String code,
    required String fullName,
    required String identityCard,
    required String phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    int? areaId,
    String? targetPosition,
    int? positionId,
    required String targetType,
    String? specialty,
    int? specialtyId,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    required DateTime applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    String? cvUrl,
    String? discardReason,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhApplicantImpl;

  factory RrhhApplicant.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhApplicant(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      fullName: jsonSerialization['fullName'] as String,
      identityCard: jsonSerialization['identityCard'] as String,
      phone: jsonSerialization['phone'] as String,
      email: jsonSerialization['email'] as String?,
      address: jsonSerialization['address'] as String?,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      emergencyContact: jsonSerialization['emergencyContact'] as String?,
      emergencyPhone: jsonSerialization['emergencyPhone'] as String?,
      targetArea: jsonSerialization['targetArea'] as String?,
      areaId: jsonSerialization['areaId'] as int?,
      targetPosition: jsonSerialization['targetPosition'] as String?,
      positionId: jsonSerialization['positionId'] as int?,
      targetType: jsonSerialization['targetType'] as String,
      specialty: jsonSerialization['specialty'] as String?,
      specialtyId: jsonSerialization['specialtyId'] as int?,
      education: jsonSerialization['education'] as String?,
      experienceSummary: jsonSerialization['experienceSummary'] as String?,
      skills: jsonSerialization['skills'] as String?,
      referencePerson: jsonSerialization['referencePerson'] as String?,
      referencePhone: jsonSerialization['referencePhone'] as String?,
      applicationDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['applicationDate'],
      ),
      status: jsonSerialization['status'] as String?,
      interviewNotes: jsonSerialization['interviewNotes'] as String?,
      expectedSalary: (jsonSerialization['expectedSalary'] as num?)?.toDouble(),
      hasCvAttached: jsonSerialization['hasCvAttached'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['hasCvAttached']),
      hasIdentityCardCopy: jsonSerialization['hasIdentityCardCopy'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['hasIdentityCardCopy'],
            ),
      cvUrl: jsonSerialization['cvUrl'] as String?,
      discardReason: jsonSerialization['discardReason'] as String?,
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

  /// Código identificador del postulante (ej: POST-001).
  String code;

  /// Nombre completo del postulante.
  String fullName;

  /// Documento de identidad (CI).
  String identityCard;

  /// Teléfono o celular de contacto.
  String phone;

  /// Correo electrónico de contacto.
  String? email;

  /// Dirección de domicilio.
  String? address;

  /// Fecha de nacimiento.
  DateTime? birthDate;

  /// Contacto de emergencia (nombre y parentesco).
  String? emergencyContact;

  /// Teléfono del contacto de emergencia.
  String? emergencyPhone;

  /// Área objetivo o departamento al que postula.
  String? targetArea;

  int? areaId;

  /// Cargo objetivo al que aspira.
  String? targetPosition;

  int? positionId;

  /// Tipo de entorno laboral deseado: 'OFICINA' o 'CAMPO'.
  String targetType;

  /// Especialidad técnica (ej: Jardinería, Limpieza, Climatización).
  String? specialty;

  int? specialtyId;

  /// Nivel de formación o educación alcanzada.
  String? education;

  /// Resumen de experiencia laboral previa.
  String? experienceSummary;

  /// Habilidades técnicas y competencias.
  String? skills;

  /// Persona de referencia laboral o personal.
  String? referencePerson;

  /// Teléfono de la persona de referencia.
  String? referencePhone;

  /// Fecha de postulación o recepción de hoja de vida.
  DateTime applicationDate;

  /// Estado en el embudo de selección: 'NUEVO', 'EN_EVALUACION', 'SELECCIONADO', 'RECHAZADO', 'CONTRATADO'.
  String status;

  /// Notas y observaciones de entrevista / evaluación.
  String? interviewNotes;

  /// Pretensión salarial en Bolivianos (Bs.).
  double? expectedSalary;

  /// Indicadores de documentación preliminar adjunta.
  bool hasCvAttached;

  bool hasIdentityCardCopy;

  /// Enlace a currículum digital si existe.
  String? cvUrl;

  /// Motivo de descarte en caso de rechazo.
  String? discardReason;

  /// Eliminación lógica y auditoría.
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhApplicant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhApplicant copyWith({
    int? id,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    int? areaId,
    String? targetPosition,
    int? positionId,
    String? targetType,
    String? specialty,
    int? specialtyId,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    DateTime? applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    String? cvUrl,
    String? discardReason,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhApplicant',
      if (id != null) 'id': id,
      'code': code,
      'fullName': fullName,
      'identityCard': identityCard,
      'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (emergencyContact != null) 'emergencyContact': emergencyContact,
      if (emergencyPhone != null) 'emergencyPhone': emergencyPhone,
      if (targetArea != null) 'targetArea': targetArea,
      if (areaId != null) 'areaId': areaId,
      if (targetPosition != null) 'targetPosition': targetPosition,
      if (positionId != null) 'positionId': positionId,
      'targetType': targetType,
      if (specialty != null) 'specialty': specialty,
      if (specialtyId != null) 'specialtyId': specialtyId,
      if (education != null) 'education': education,
      if (experienceSummary != null) 'experienceSummary': experienceSummary,
      if (skills != null) 'skills': skills,
      if (referencePerson != null) 'referencePerson': referencePerson,
      if (referencePhone != null) 'referencePhone': referencePhone,
      'applicationDate': applicationDate.toJson(),
      'status': status,
      if (interviewNotes != null) 'interviewNotes': interviewNotes,
      if (expectedSalary != null) 'expectedSalary': expectedSalary,
      'hasCvAttached': hasCvAttached,
      'hasIdentityCardCopy': hasIdentityCardCopy,
      if (cvUrl != null) 'cvUrl': cvUrl,
      if (discardReason != null) 'discardReason': discardReason,
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

class _RrhhApplicantImpl extends RrhhApplicant {
  _RrhhApplicantImpl({
    int? id,
    required String code,
    required String fullName,
    required String identityCard,
    required String phone,
    String? email,
    String? address,
    DateTime? birthDate,
    String? emergencyContact,
    String? emergencyPhone,
    String? targetArea,
    int? areaId,
    String? targetPosition,
    int? positionId,
    required String targetType,
    String? specialty,
    int? specialtyId,
    String? education,
    String? experienceSummary,
    String? skills,
    String? referencePerson,
    String? referencePhone,
    required DateTime applicationDate,
    String? status,
    String? interviewNotes,
    double? expectedSalary,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    String? cvUrl,
    String? discardReason,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         fullName: fullName,
         identityCard: identityCard,
         phone: phone,
         email: email,
         address: address,
         birthDate: birthDate,
         emergencyContact: emergencyContact,
         emergencyPhone: emergencyPhone,
         targetArea: targetArea,
         areaId: areaId,
         targetPosition: targetPosition,
         positionId: positionId,
         targetType: targetType,
         specialty: specialty,
         specialtyId: specialtyId,
         education: education,
         experienceSummary: experienceSummary,
         skills: skills,
         referencePerson: referencePerson,
         referencePhone: referencePhone,
         applicationDate: applicationDate,
         status: status,
         interviewNotes: interviewNotes,
         expectedSalary: expectedSalary,
         hasCvAttached: hasCvAttached,
         hasIdentityCardCopy: hasIdentityCardCopy,
         cvUrl: cvUrl,
         discardReason: discardReason,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhApplicant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhApplicant copyWith({
    Object? id = _Undefined,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    Object? email = _Undefined,
    Object? address = _Undefined,
    Object? birthDate = _Undefined,
    Object? emergencyContact = _Undefined,
    Object? emergencyPhone = _Undefined,
    Object? targetArea = _Undefined,
    Object? areaId = _Undefined,
    Object? targetPosition = _Undefined,
    Object? positionId = _Undefined,
    String? targetType,
    Object? specialty = _Undefined,
    Object? specialtyId = _Undefined,
    Object? education = _Undefined,
    Object? experienceSummary = _Undefined,
    Object? skills = _Undefined,
    Object? referencePerson = _Undefined,
    Object? referencePhone = _Undefined,
    DateTime? applicationDate,
    String? status,
    Object? interviewNotes = _Undefined,
    Object? expectedSalary = _Undefined,
    bool? hasCvAttached,
    bool? hasIdentityCardCopy,
    Object? cvUrl = _Undefined,
    Object? discardReason = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhApplicant(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      identityCard: identityCard ?? this.identityCard,
      phone: phone ?? this.phone,
      email: email is String? ? email : this.email,
      address: address is String? ? address : this.address,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      emergencyContact: emergencyContact is String?
          ? emergencyContact
          : this.emergencyContact,
      emergencyPhone: emergencyPhone is String?
          ? emergencyPhone
          : this.emergencyPhone,
      targetArea: targetArea is String? ? targetArea : this.targetArea,
      areaId: areaId is int? ? areaId : this.areaId,
      targetPosition: targetPosition is String?
          ? targetPosition
          : this.targetPosition,
      positionId: positionId is int? ? positionId : this.positionId,
      targetType: targetType ?? this.targetType,
      specialty: specialty is String? ? specialty : this.specialty,
      specialtyId: specialtyId is int? ? specialtyId : this.specialtyId,
      education: education is String? ? education : this.education,
      experienceSummary: experienceSummary is String?
          ? experienceSummary
          : this.experienceSummary,
      skills: skills is String? ? skills : this.skills,
      referencePerson: referencePerson is String?
          ? referencePerson
          : this.referencePerson,
      referencePhone: referencePhone is String?
          ? referencePhone
          : this.referencePhone,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      interviewNotes: interviewNotes is String?
          ? interviewNotes
          : this.interviewNotes,
      expectedSalary: expectedSalary is double?
          ? expectedSalary
          : this.expectedSalary,
      hasCvAttached: hasCvAttached ?? this.hasCvAttached,
      hasIdentityCardCopy: hasIdentityCardCopy ?? this.hasIdentityCardCopy,
      cvUrl: cvUrl is String? ? cvUrl : this.cvUrl,
      discardReason: discardReason is String?
          ? discardReason
          : this.discardReason,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
