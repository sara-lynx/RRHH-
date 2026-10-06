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
import 'package:elite_multiservicios_client/src/protocol/protocol.dart' as _i2;

/// Entidad principal de Cliente 360° para el CRM de Elite Multiservicios.
abstract class CrmCustomer implements _i1.SerializableModel {
  CrmCustomer._({
    this.id,
    required this.code,
    required this.legalName,
    required this.tradeName,
    required this.taxId,
    required this.segment,
    String? status,
    required this.activeServices,
    required this.contactPerson,
    required this.phone,
    required this.email,
    this.opportunityId,
    this.startDate,
    this.notes,
    bool? isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : status = status ?? 'Activo',
       isDeleted = isDeleted ?? false;

  factory CrmCustomer({
    int? id,
    required String code,
    required String legalName,
    required String tradeName,
    required String taxId,
    required String segment,
    String? status,
    required List<String> activeServices,
    required String contactPerson,
    required String phone,
    required String email,
    int? opportunityId,
    DateTime? startDate,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CrmCustomerImpl;

  factory CrmCustomer.fromJson(Map<String, dynamic> jsonSerialization) {
    return CrmCustomer(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      legalName: jsonSerialization['legalName'] as String,
      tradeName: jsonSerialization['tradeName'] as String,
      taxId: jsonSerialization['taxId'] as String,
      segment: jsonSerialization['segment'] as String,
      status: jsonSerialization['status'] as String?,
      activeServices: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['activeServices'],
      ),
      contactPerson: jsonSerialization['contactPerson'] as String,
      phone: jsonSerialization['phone'] as String,
      email: jsonSerialization['email'] as String,
      opportunityId: jsonSerialization['opportunityId'] as int?,
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
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

  /// Código comercial único del cliente (ej. CLI-001).
  String code;

  /// Razón Social legal registrada ante impuestos.
  String legalName;

  /// Nombre Comercial o de fantasía de la empresa o cliente.
  String tradeName;

  /// Número de Identificación Tributaria (NIT / RUC / CI).
  String taxId;

  /// Segmento comercial: Corporativo B2B, Residencial B2C, Sector Educativo, Sector Público.
  String segment;

  /// Estado operativo: Activo, En Pausa, Inactivo.
  String status;

  /// Lista de servicios activos contratados.
  List<String> activeServices;

  /// Persona de contacto principal o decisor institucional.
  String contactPerson;

  /// Teléfono corporativo o WhatsApp principal.
  String phone;

  /// Correo electrónico de facturación o contacto.
  String email;

  /// ID de la oportunidad comercial de origen (si proviene del Pipeline).
  int? opportunityId;

  /// Fecha de inicio formal de relación comercial.
  DateTime? startDate;

  /// Notas y antecedentes generales del cliente.
  String? notes;

  /// Eliminación lógica (Soft Delete).
  bool isDeleted;

  /// Fechas de auditoría temporal.
  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CrmCustomer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmCustomer copyWith({
    int? id,
    String? code,
    String? legalName,
    String? tradeName,
    String? taxId,
    String? segment,
    String? status,
    List<String>? activeServices,
    String? contactPerson,
    String? phone,
    String? email,
    int? opportunityId,
    DateTime? startDate,
    String? notes,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmCustomer',
      if (id != null) 'id': id,
      'code': code,
      'legalName': legalName,
      'tradeName': tradeName,
      'taxId': taxId,
      'segment': segment,
      'status': status,
      'activeServices': activeServices.toJson(),
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      if (opportunityId != null) 'opportunityId': opportunityId,
      if (startDate != null) 'startDate': startDate?.toJson(),
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

class _CrmCustomerImpl extends CrmCustomer {
  _CrmCustomerImpl({
    int? id,
    required String code,
    required String legalName,
    required String tradeName,
    required String taxId,
    required String segment,
    String? status,
    required List<String> activeServices,
    required String contactPerson,
    required String phone,
    required String email,
    int? opportunityId,
    DateTime? startDate,
    String? notes,
    bool? isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         code: code,
         legalName: legalName,
         tradeName: tradeName,
         taxId: taxId,
         segment: segment,
         status: status,
         activeServices: activeServices,
         contactPerson: contactPerson,
         phone: phone,
         email: email,
         opportunityId: opportunityId,
         startDate: startDate,
         notes: notes,
         isDeleted: isDeleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CrmCustomer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmCustomer copyWith({
    Object? id = _Undefined,
    String? code,
    String? legalName,
    String? tradeName,
    String? taxId,
    String? segment,
    String? status,
    List<String>? activeServices,
    String? contactPerson,
    String? phone,
    String? email,
    Object? opportunityId = _Undefined,
    Object? startDate = _Undefined,
    Object? notes = _Undefined,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmCustomer(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      legalName: legalName ?? this.legalName,
      tradeName: tradeName ?? this.tradeName,
      taxId: taxId ?? this.taxId,
      segment: segment ?? this.segment,
      status: status ?? this.status,
      activeServices:
          activeServices ?? this.activeServices.map((e0) => e0).toList(),
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      opportunityId: opportunityId is int? ? opportunityId : this.opportunityId,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      notes: notes is String? ? notes : this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
