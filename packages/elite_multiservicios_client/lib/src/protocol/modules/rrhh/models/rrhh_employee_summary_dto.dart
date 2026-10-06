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

/// DTO optimizado para el Directorio y tablas de personal.
abstract class RrhhEmployeeSummaryDto implements _i1.SerializableModel {
  RrhhEmployeeSummaryDto._({
    required this.id,
    required this.code,
    required this.fullName,
    required this.identityCard,
    required this.phone,
    required this.employeeType,
    this.area,
    this.position,
    this.workplace,
    required this.status,
    required this.availabilityStatus,
    required this.hireDate,
    this.photoUrl,
  });

  factory RrhhEmployeeSummaryDto({
    required int id,
    required String code,
    required String fullName,
    required String identityCard,
    required String phone,
    required String employeeType,
    String? area,
    String? position,
    String? workplace,
    required String status,
    required String availabilityStatus,
    required DateTime hireDate,
    String? photoUrl,
  }) = _RrhhEmployeeSummaryDtoImpl;

  factory RrhhEmployeeSummaryDto.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhEmployeeSummaryDto(
      id: jsonSerialization['id'] as int,
      code: jsonSerialization['code'] as String,
      fullName: jsonSerialization['fullName'] as String,
      identityCard: jsonSerialization['identityCard'] as String,
      phone: jsonSerialization['phone'] as String,
      employeeType: jsonSerialization['employeeType'] as String,
      area: jsonSerialization['area'] as String?,
      position: jsonSerialization['position'] as String?,
      workplace: jsonSerialization['workplace'] as String?,
      status: jsonSerialization['status'] as String,
      availabilityStatus: jsonSerialization['availabilityStatus'] as String,
      hireDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['hireDate'],
      ),
      photoUrl: jsonSerialization['photoUrl'] as String?,
    );
  }

  int id;

  String code;

  String fullName;

  String identityCard;

  String phone;

  String employeeType;

  String? area;

  String? position;

  String? workplace;

  String status;

  String availabilityStatus;

  DateTime hireDate;

  String? photoUrl;

  /// Returns a shallow copy of this [RrhhEmployeeSummaryDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhEmployeeSummaryDto copyWith({
    int? id,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    String? employeeType,
    String? area,
    String? position,
    String? workplace,
    String? status,
    String? availabilityStatus,
    DateTime? hireDate,
    String? photoUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhEmployeeSummaryDto',
      'id': id,
      'code': code,
      'fullName': fullName,
      'identityCard': identityCard,
      'phone': phone,
      'employeeType': employeeType,
      if (area != null) 'area': area,
      if (position != null) 'position': position,
      if (workplace != null) 'workplace': workplace,
      'status': status,
      'availabilityStatus': availabilityStatus,
      'hireDate': hireDate.toJson(),
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhEmployeeSummaryDtoImpl extends RrhhEmployeeSummaryDto {
  _RrhhEmployeeSummaryDtoImpl({
    required int id,
    required String code,
    required String fullName,
    required String identityCard,
    required String phone,
    required String employeeType,
    String? area,
    String? position,
    String? workplace,
    required String status,
    required String availabilityStatus,
    required DateTime hireDate,
    String? photoUrl,
  }) : super._(
         id: id,
         code: code,
         fullName: fullName,
         identityCard: identityCard,
         phone: phone,
         employeeType: employeeType,
         area: area,
         position: position,
         workplace: workplace,
         status: status,
         availabilityStatus: availabilityStatus,
         hireDate: hireDate,
         photoUrl: photoUrl,
       );

  /// Returns a shallow copy of this [RrhhEmployeeSummaryDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhEmployeeSummaryDto copyWith({
    int? id,
    String? code,
    String? fullName,
    String? identityCard,
    String? phone,
    String? employeeType,
    Object? area = _Undefined,
    Object? position = _Undefined,
    Object? workplace = _Undefined,
    String? status,
    String? availabilityStatus,
    DateTime? hireDate,
    Object? photoUrl = _Undefined,
  }) {
    return RrhhEmployeeSummaryDto(
      id: id ?? this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      identityCard: identityCard ?? this.identityCard,
      phone: phone ?? this.phone,
      employeeType: employeeType ?? this.employeeType,
      area: area is String? ? area : this.area,
      position: position is String? ? position : this.position,
      workplace: workplace is String? ? workplace : this.workplace,
      status: status ?? this.status,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      hireDate: hireDate ?? this.hireDate,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
    );
  }
}
