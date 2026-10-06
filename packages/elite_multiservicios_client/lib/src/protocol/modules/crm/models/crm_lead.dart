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

/// Entidad de prospecto comercial (Outbound / Google Maps / Directorios).
abstract class CrmLead implements _i1.SerializableModel {
  CrmLead._({
    this.id,
    required this.code,
    required this.company,
    String? origin,
    this.requestedService,
    this.companyUrl,
    required this.sector,
    required this.advisor,
    this.advisorUserId,
    required this.address,
    required this.phone,
    this.emailOrWeb,
    String? status,
    String? temperature,
    required this.contactPerson,
    this.notes,
    double? estimatedValue,
    bool? isPromoted,
    this.promotedOpportunityId,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : origin = origin ?? 'Google Maps',
       status = status ?? 'Prospectado',
       temperature = temperature ?? 'Templado',
       estimatedValue = estimatedValue ?? 0.0,
       isPromoted = isPromoted ?? false,
       isDeleted = isDeleted ?? false;

  factory CrmLead({
    int? id,
    required String code,
    required String company,
    String? origin,
    String? requestedService,
    String? companyUrl,
    required String sector,
    required String advisor,
    int? advisorUserId,
    required String address,
    required String phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    required String contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmLeadImpl;

  factory CrmLead.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmLead(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      company: jsonSerialization['company'] as String,
      origin: jsonSerialization['origin'] as String?,
      requestedService: jsonSerialization['requestedService'] as String?,
      companyUrl: jsonSerialization['companyUrl'] as String?,
      sector: jsonSerialization['sector'] as String,
      advisor: jsonSerialization['advisor'] as String,
      advisorUserId: jsonSerialization['advisorUserId'] as int?,
      address: jsonSerialization['address'] as String,
      phone: jsonSerialization['phone'] as String,
      emailOrWeb: jsonSerialization['emailOrWeb'] as String?,
      status: jsonSerialization['status'] as String?,
      temperature: jsonSerialization['temperature'] as String?,
      contactPerson: jsonSerialization['contactPerson'] as String,
      notes: jsonSerialization['notes'] as String?,
      estimatedValue: (jsonSerialization['estimatedValue'] as num?)?.toDouble(),
      isPromoted: jsonSerialization['isPromoted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPromoted']),
      promotedOpportunityId: jsonSerialization['promotedOpportunityId'] as int?,
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

  /// Código de seguimiento del prospecto (ej. PROSP-001).
  String code;

  /// Nombre comercial de la empresa o edificio.
  String company;

  /// Canal de captación / origen del prospecto (Google Maps, Sitio Web, Llamada Telefónica, Referido, Redes Sociales, Prospección en Frío).
  String origin;

  /// Servicio solicitado o de interés inicial.
  String? requestedService;

  /// Enlace web o ficha en Google Maps.
  String? companyUrl;

  /// Rubro o industria (Clínicas, Corporativo, Colegios, Banca, etc.).
  String sector;

  /// Asesor comercial asignado.
  String advisor;

  /// ID del usuario asesor en AppUser (opcional).
  int? advisorUserId;

  /// Dirección física o zona geográfica.
  String address;

  /// Teléfono(s) o WhatsApp corporativo.
  String phone;

  /// Correo electrónico o enlace web oficial.
  String? emailOrWeb;

  /// Estado: Prospectado, Contactado, En Espera de Respuesta, Interesado (Calificado), Descartado.
  String status;

  /// Temperatura comercial: Frío, Templado, Caliente.
  String temperature;

  /// Persona o cargo de contacto decisor.
  String contactPerson;

  /// Notas y observaciones del seguimiento comercial.
  String? notes;

  /// Valor potencial estimado mensual o por proyecto.
  double estimatedValue;

  /// Indicador de si fue promovido al Pipeline comercial.
  bool isPromoted;

  /// ID de la oportunidad generada al promoverse.
  int? promotedOpportunityId;

  /// Indicador de eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fecha de creación del registro.
  DateTime createdAt;

  /// Fecha de última actualización.
  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmLead]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmLead copyWith({
    int? id,
    String? code,
    String? company,
    String? origin,
    String? requestedService,
    String? companyUrl,
    String? sector,
    String? advisor,
    int? advisorUserId,
    String? address,
    String? phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    String? contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmLead',
      if (id != null) 'id': id,
      'code': code,
      'company': company,
      'origin': origin,
      if (requestedService != null) 'requestedService': requestedService,
      if (companyUrl != null) 'companyUrl': companyUrl,
      'sector': sector,
      'advisor': advisor,
      if (advisorUserId != null) 'advisorUserId': advisorUserId,
      'address': address,
      'phone': phone,
      if (emailOrWeb != null) 'emailOrWeb': emailOrWeb,
      'status': status,
      'temperature': temperature,
      'contactPerson': contactPerson,
      if (notes != null) 'notes': notes,
      'estimatedValue': estimatedValue,
      'isPromoted': isPromoted,
      if (promotedOpportunityId != null)
        'promotedOpportunityId': promotedOpportunityId,
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

class _CrmLeadImpl extends CrmLead {
  _CrmLeadImpl({
    int? id,
    required String code,
    required String company,
    String? origin,
    String? requestedService,
    String? companyUrl,
    required String sector,
    required String advisor,
    int? advisorUserId,
    required String address,
    required String phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    required String contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         company: company,
         origin: origin,
         requestedService: requestedService,
         companyUrl: companyUrl,
         sector: sector,
         advisor: advisor,
         advisorUserId: advisorUserId,
         address: address,
         phone: phone,
         emailOrWeb: emailOrWeb,
         status: status,
         temperature: temperature,
         contactPerson: contactPerson,
         notes: notes,
         estimatedValue: estimatedValue,
         isPromoted: isPromoted,
         promotedOpportunityId: promotedOpportunityId,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmLead]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmLead copyWith({
    Object? id = _Undefined,
    String? code,
    String? company,
    String? origin,
    Object? requestedService = _Undefined,
    Object? companyUrl = _Undefined,
    String? sector,
    String? advisor,
    Object? advisorUserId = _Undefined,
    String? address,
    String? phone,
    Object? emailOrWeb = _Undefined,
    String? status,
    String? temperature,
    String? contactPerson,
    Object? notes = _Undefined,
    double? estimatedValue,
    bool? isPromoted,
    Object? promotedOpportunityId = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmLead(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      company: company ?? this.company,
      origin: origin ?? this.origin,
      requestedService: requestedService is String?
          ? requestedService
          : this.requestedService,
      companyUrl: companyUrl is String? ? companyUrl : this.companyUrl,
      sector: sector ?? this.sector,
      advisor: advisor ?? this.advisor,
      advisorUserId: advisorUserId is int? ? advisorUserId : this.advisorUserId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      emailOrWeb: emailOrWeb is String? ? emailOrWeb : this.emailOrWeb,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      contactPerson: contactPerson ?? this.contactPerson,
      notes: notes is String? ? notes : this.notes,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      isPromoted: isPromoted ?? this.isPromoted,
      promotedOpportunityId: promotedOpportunityId is int?
          ? promotedOpportunityId
          : this.promotedOpportunityId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
