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

/// DTO de evento reciente o novedad laboral para la trazabilidad en el Dashboard de RRHH.
abstract class RrhhRecentMovementDto implements _i1.SerializableModel {
  RrhhRecentMovementDto._({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.employeeCode,
    required this.employeeName,
    required this.workplace,
    required this.timestamp,
    required this.registeredBy,
  });

  factory RrhhRecentMovementDto({
    required String id,
    required String type,
    required String title,
    required String description,
    required String employeeCode,
    required String employeeName,
    required String workplace,
    required DateTime timestamp,
    required String registeredBy,
  }) = _RrhhRecentMovementDtoImpl;

  factory RrhhRecentMovementDto.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhRecentMovementDto(
      id: jsonSerialization['id'] as String,
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      employeeCode: jsonSerialization['employeeCode'] as String,
      employeeName: jsonSerialization['employeeName'] as String,
      workplace: jsonSerialization['workplace'] as String,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      registeredBy: jsonSerialization['registeredBy'] as String,
    );
  }

  /// Identificador único del evento o movimiento.
  String id;

  /// Tipo de movimiento: ALTA_PERSONAL, REASIGNACION_SEDE, CAMBIO_CARGO, BAJA_PERSONAL, PERMISO_APROBADO, INCREMENTO_SALARIAL.
  String type;

  /// Título descriptivo del movimiento.
  String title;

  /// Detalle o motivo del movimiento laboral.
  String description;

  /// Código del empleado asociado (ej. EMP-001).
  String employeeCode;

  /// Nombre completo del empleado asociado.
  String employeeName;

  /// Sede de trabajo asignada o destino del movimiento.
  String workplace;

  /// Fecha y hora en que se registró el evento.
  DateTime timestamp;

  /// Nombre o cargo de quien autorizó y registró la novedad.
  String registeredBy;

  /// Returns a shallow copy of this [RrhhRecentMovementDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhRecentMovementDto copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? employeeCode,
    String? employeeName,
    String? workplace,
    DateTime? timestamp,
    String? registeredBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhRecentMovementDto',
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'workplace': workplace,
      'timestamp': timestamp.toJson(),
      'registeredBy': registeredBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RrhhRecentMovementDtoImpl extends RrhhRecentMovementDto {
  _RrhhRecentMovementDtoImpl({
    required String id,
    required String type,
    required String title,
    required String description,
    required String employeeCode,
    required String employeeName,
    required String workplace,
    required DateTime timestamp,
    required String registeredBy,
  }) : super._(
         id: id,
         type: type,
         title: title,
         description: description,
         employeeCode: employeeCode,
         employeeName: employeeName,
         workplace: workplace,
         timestamp: timestamp,
         registeredBy: registeredBy,
       );

  /// Returns a shallow copy of this [RrhhRecentMovementDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhRecentMovementDto copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? employeeCode,
    String? employeeName,
    String? workplace,
    DateTime? timestamp,
    String? registeredBy,
  }) {
    return RrhhRecentMovementDto(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      workplace: workplace ?? this.workplace,
      timestamp: timestamp ?? this.timestamp,
      registeredBy: registeredBy ?? this.registeredBy,
    );
  }
}
