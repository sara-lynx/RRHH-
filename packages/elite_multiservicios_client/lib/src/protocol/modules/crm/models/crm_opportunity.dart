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

/// Oportunidad comercial en el embudo del Pipeline (Kanban).
abstract class CrmOpportunity implements _i1.SerializableModel {
  CrmOpportunity._({
    this.id,
    required this.code,
    required this.title,
    required this.clientName,
    required this.contactPerson,
    required this.phone,
    required this.serviceType,
    required this.amount,
    required this.stage,
    int? probability,
    required this.owner,
    required this.closingDate,
    this.notes,
    String? contractType,
    String? serviceFrequency,
    this.scheduleHours,
    int? billingCycleDay,
    this.specificRequirements,
    String? executionTime,
    required this.paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    this.siteName,
    this.siteAddress,
    String? siteCity,
    this.siteContactName,
    this.siteContactPhone,
    this.siteAccessRequirements,
    bool? isSiteHeadquarters,
    this.legalBusinessName,
    this.taxId,
    this.legalRepresentative,
    this.billingEmail,
    this.serviceStartDate,
    double? advancePaid,
    this.wonNotes,
    this.leadId,
    this.customerId,
    this.branchId,
    this.branchName,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : probability = probability ?? 20,
       contractType = contractType ?? 'Recurrente Mensual',
       serviceFrequency = serviceFrequency ?? 'Lunes a Viernes',
       billingCycleDay = billingCycleDay ?? 5,
       executionTime = executionTime ?? '12 meses',
       advancePercentage = advancePercentage ?? 0,
       contactRole = contactRole ?? 'Administrador',
       businessSegment = businessSegment ?? 'Corporativo B2B',
       siteCity = siteCity ?? 'Santa Cruz',
       isSiteHeadquarters = isSiteHeadquarters ?? true,
       advancePaid = advancePaid ?? 0.0,
       isDeleted = isDeleted ?? false;

  factory CrmOpportunity({
    int? id,
    required String code,
    required String title,
    required String clientName,
    required String contactPerson,
    required String phone,
    required String serviceType,
    required double amount,
    required String stage,
    int? probability,
    required String owner,
    required String closingDate,
    String? notes,
    String? contractType,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    String? executionTime,
    required String paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
    int? leadId,
    int? customerId,
    int? branchId,
    String? branchName,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmOpportunityImpl;

  factory CrmOpportunity.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmOpportunity(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      clientName: jsonSerialization['clientName'] as String,
      contactPerson: jsonSerialization['contactPerson'] as String,
      phone: jsonSerialization['phone'] as String,
      serviceType: jsonSerialization['serviceType'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      stage: jsonSerialization['stage'] as String,
      probability: jsonSerialization['probability'] as int?,
      owner: jsonSerialization['owner'] as String,
      closingDate: jsonSerialization['closingDate'] as String,
      notes: jsonSerialization['notes'] as String?,
      contractType: jsonSerialization['contractType'] as String?,
      serviceFrequency: jsonSerialization['serviceFrequency'] as String?,
      scheduleHours: jsonSerialization['scheduleHours'] as String?,
      billingCycleDay: jsonSerialization['billingCycleDay'] as int?,
      specificRequirements:
          jsonSerialization['specificRequirements'] as String?,
      executionTime: jsonSerialization['executionTime'] as String?,
      paymentTerms: jsonSerialization['paymentTerms'] as String,
      advancePercentage: jsonSerialization['advancePercentage'] as int?,
      contactRole: jsonSerialization['contactRole'] as String?,
      businessSegment: jsonSerialization['businessSegment'] as String?,
      siteName: jsonSerialization['siteName'] as String?,
      siteAddress: jsonSerialization['siteAddress'] as String?,
      siteCity: jsonSerialization['siteCity'] as String?,
      siteContactName: jsonSerialization['siteContactName'] as String?,
      siteContactPhone: jsonSerialization['siteContactPhone'] as String?,
      siteAccessRequirements:
          jsonSerialization['siteAccessRequirements'] as String?,
      isSiteHeadquarters: jsonSerialization['isSiteHeadquarters'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isSiteHeadquarters'],
            ),
      legalBusinessName: jsonSerialization['legalBusinessName'] as String?,
      taxId: jsonSerialization['taxId'] as String?,
      legalRepresentative: jsonSerialization['legalRepresentative'] as String?,
      billingEmail: jsonSerialization['billingEmail'] as String?,
      serviceStartDate: jsonSerialization['serviceStartDate'] as String?,
      advancePaid: (jsonSerialization['advancePaid'] as num?)?.toDouble(),
      wonNotes: jsonSerialization['wonNotes'] as String?,
      leadId: jsonSerialization['leadId'] as int?,
      customerId: jsonSerialization['customerId'] as int?,
      branchId: jsonSerialization['branchId'] as int?,
      branchName: jsonSerialization['branchName'] as String?,
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

  /// Código de seguimiento de la oportunidad (ej. OPP-001).
  String code;

  /// Título u objeto comercial de la oportunidad.
  String title;

  /// Nombre de la empresa, institución o cliente.
  String clientName;

  /// Persona de contacto o decisor.
  String contactPerson;

  /// Teléfono corporativo o de contacto.
  String phone;

  /// Tipo de servicio principal solicitado.
  String serviceType;

  /// Monto total o estimado de la oportunidad en Bs.
  double amount;

  /// Etapa o compuerta comercial en el embudo.
  String stage;

  /// Probabilidad de cierre comercial porcentual (0 - 100).
  int probability;

  /// Asesor o responsable de la oportunidad.
  String owner;

  /// Fecha tentativa de cierre (DD/MM/AAAA).
  String closingDate;

  /// Notas y observaciones comerciales.
  String? notes;

  /// Modalidad de contrato propuesta.
  String contractType;

  /// Frecuencia acordada del servicio (ej. Lunes a Viernes, 24/7, Interdiario).
  String serviceFrequency;

  /// Horario previsto de prestación acordado (ej. 08:00 - 17:00, Turno 12h).
  String? scheduleHours;

  /// Día de corte / facturación de cuotas para Contabilidad (1 al 31).
  int? billingCycleDay;

  /// Requerimientos específicos del cliente (normativas, uniformes, pólizas).
  String? specificRequirements;

  /// Tiempo o plazo de ejecución estimado.
  String executionTime;

  /// Términos y condiciones de pago.
  String paymentTerms;

  /// Porcentaje de anticipo pactado (0, 30, 50, 70, 100).
  int advancePercentage;

  /// Compuerta 1: Perfil del Decisor & Segmento
  String contactRole;

  String businessSegment;

  /// Compuerta 2: Sede Operativa de Inspección (Visita Técnica)
  String? siteName;

  String? siteAddress;

  String siteCity;

  String? siteContactName;

  String? siteContactPhone;

  String? siteAccessRequirements;

  bool isSiteHeadquarters;

  /// Compuerta 3: Datos Fiscales & Minuta Legal (Negociación)
  String? legalBusinessName;

  String? taxId;

  String? legalRepresentative;

  String? billingEmail;

  /// Compuerta 4: Cierre Formal & Traspaso (Ganada)
  String? serviceStartDate;

  double advancePaid;

  String? wonNotes;

  /// Enlaces relacionales con otros submódulos
  int? leadId;

  int? customerId;

  int? branchId;

  String? branchName;

  /// Eliminación lógica y auditoría temporal
  bool isDeleted;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmOpportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmOpportunity copyWith({
    int? id,
    String? code,
    String? title,
    String? clientName,
    String? contactPerson,
    String? phone,
    String? serviceType,
    double? amount,
    String? stage,
    int? probability,
    String? owner,
    String? closingDate,
    String? notes,
    String? contractType,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    String? executionTime,
    String? paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
    int? leadId,
    int? customerId,
    int? branchId,
    String? branchName,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmOpportunity',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'clientName': clientName,
      'contactPerson': contactPerson,
      'phone': phone,
      'serviceType': serviceType,
      'amount': amount,
      'stage': stage,
      'probability': probability,
      'owner': owner,
      'closingDate': closingDate,
      if (notes != null) 'notes': notes,
      'contractType': contractType,
      'serviceFrequency': serviceFrequency,
      if (scheduleHours != null) 'scheduleHours': scheduleHours,
      if (billingCycleDay != null) 'billingCycleDay': billingCycleDay,
      if (specificRequirements != null)
        'specificRequirements': specificRequirements,
      'executionTime': executionTime,
      'paymentTerms': paymentTerms,
      'advancePercentage': advancePercentage,
      'contactRole': contactRole,
      'businessSegment': businessSegment,
      if (siteName != null) 'siteName': siteName,
      if (siteAddress != null) 'siteAddress': siteAddress,
      'siteCity': siteCity,
      if (siteContactName != null) 'siteContactName': siteContactName,
      if (siteContactPhone != null) 'siteContactPhone': siteContactPhone,
      if (siteAccessRequirements != null)
        'siteAccessRequirements': siteAccessRequirements,
      'isSiteHeadquarters': isSiteHeadquarters,
      if (legalBusinessName != null) 'legalBusinessName': legalBusinessName,
      if (taxId != null) 'taxId': taxId,
      if (legalRepresentative != null)
        'legalRepresentative': legalRepresentative,
      if (billingEmail != null) 'billingEmail': billingEmail,
      if (serviceStartDate != null) 'serviceStartDate': serviceStartDate,
      'advancePaid': advancePaid,
      if (wonNotes != null) 'wonNotes': wonNotes,
      if (leadId != null) 'leadId': leadId,
      if (customerId != null) 'customerId': customerId,
      if (branchId != null) 'branchId': branchId,
      if (branchName != null) 'branchName': branchName,
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

class _CrmOpportunityImpl extends CrmOpportunity {
  _CrmOpportunityImpl({
    int? id,
    required String code,
    required String title,
    required String clientName,
    required String contactPerson,
    required String phone,
    required String serviceType,
    required double amount,
    required String stage,
    int? probability,
    required String owner,
    required String closingDate,
    String? notes,
    String? contractType,
    String? serviceFrequency,
    String? scheduleHours,
    int? billingCycleDay,
    String? specificRequirements,
    String? executionTime,
    required String paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
    int? leadId,
    int? customerId,
    int? branchId,
    String? branchName,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         title: title,
         clientName: clientName,
         contactPerson: contactPerson,
         phone: phone,
         serviceType: serviceType,
         amount: amount,
         stage: stage,
         probability: probability,
         owner: owner,
         closingDate: closingDate,
         notes: notes,
         contractType: contractType,
         serviceFrequency: serviceFrequency,
         scheduleHours: scheduleHours,
         billingCycleDay: billingCycleDay,
         specificRequirements: specificRequirements,
         executionTime: executionTime,
         paymentTerms: paymentTerms,
         advancePercentage: advancePercentage,
         contactRole: contactRole,
         businessSegment: businessSegment,
         siteName: siteName,
         siteAddress: siteAddress,
         siteCity: siteCity,
         siteContactName: siteContactName,
         siteContactPhone: siteContactPhone,
         siteAccessRequirements: siteAccessRequirements,
         isSiteHeadquarters: isSiteHeadquarters,
         legalBusinessName: legalBusinessName,
         taxId: taxId,
         legalRepresentative: legalRepresentative,
         billingEmail: billingEmail,
         serviceStartDate: serviceStartDate,
         advancePaid: advancePaid,
         wonNotes: wonNotes,
         leadId: leadId,
         customerId: customerId,
         branchId: branchId,
         branchName: branchName,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmOpportunity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmOpportunity copyWith({
    Object? id = _Undefined,
    String? code,
    String? title,
    String? clientName,
    String? contactPerson,
    String? phone,
    String? serviceType,
    double? amount,
    String? stage,
    int? probability,
    String? owner,
    String? closingDate,
    Object? notes = _Undefined,
    String? contractType,
    String? serviceFrequency,
    Object? scheduleHours = _Undefined,
    Object? billingCycleDay = _Undefined,
    Object? specificRequirements = _Undefined,
    String? executionTime,
    String? paymentTerms,
    int? advancePercentage,
    String? contactRole,
    String? businessSegment,
    Object? siteName = _Undefined,
    Object? siteAddress = _Undefined,
    String? siteCity,
    Object? siteContactName = _Undefined,
    Object? siteContactPhone = _Undefined,
    Object? siteAccessRequirements = _Undefined,
    bool? isSiteHeadquarters,
    Object? legalBusinessName = _Undefined,
    Object? taxId = _Undefined,
    Object? legalRepresentative = _Undefined,
    Object? billingEmail = _Undefined,
    Object? serviceStartDate = _Undefined,
    double? advancePaid,
    Object? wonNotes = _Undefined,
    Object? leadId = _Undefined,
    Object? customerId = _Undefined,
    Object? branchId = _Undefined,
    Object? branchName = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmOpportunity(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      serviceType: serviceType ?? this.serviceType,
      amount: amount ?? this.amount,
      stage: stage ?? this.stage,
      probability: probability ?? this.probability,
      owner: owner ?? this.owner,
      closingDate: closingDate ?? this.closingDate,
      notes: notes is String? ? notes : this.notes,
      contractType: contractType ?? this.contractType,
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
      executionTime: executionTime ?? this.executionTime,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      contactRole: contactRole ?? this.contactRole,
      businessSegment: businessSegment ?? this.businessSegment,
      siteName: siteName is String? ? siteName : this.siteName,
      siteAddress: siteAddress is String? ? siteAddress : this.siteAddress,
      siteCity: siteCity ?? this.siteCity,
      siteContactName: siteContactName is String?
          ? siteContactName
          : this.siteContactName,
      siteContactPhone: siteContactPhone is String?
          ? siteContactPhone
          : this.siteContactPhone,
      siteAccessRequirements: siteAccessRequirements is String?
          ? siteAccessRequirements
          : this.siteAccessRequirements,
      isSiteHeadquarters: isSiteHeadquarters ?? this.isSiteHeadquarters,
      legalBusinessName: legalBusinessName is String?
          ? legalBusinessName
          : this.legalBusinessName,
      taxId: taxId is String? ? taxId : this.taxId,
      legalRepresentative: legalRepresentative is String?
          ? legalRepresentative
          : this.legalRepresentative,
      billingEmail: billingEmail is String? ? billingEmail : this.billingEmail,
      serviceStartDate: serviceStartDate is String?
          ? serviceStartDate
          : this.serviceStartDate,
      advancePaid: advancePaid ?? this.advancePaid,
      wonNotes: wonNotes is String? ? wonNotes : this.wonNotes,
      leadId: leadId is int? ? leadId : this.leadId,
      customerId: customerId is int? ? customerId : this.customerId,
      branchId: branchId is int? ? branchId : this.branchId,
      branchName: branchName is String? ? branchName : this.branchName,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
