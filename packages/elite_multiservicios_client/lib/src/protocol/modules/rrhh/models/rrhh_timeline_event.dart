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

/// Evento o hito histórico en la línea de tiempo del colaborador (RRHH).
abstract class RrhhTimelineEvent implements _i1.SerializableModel {
  RrhhTimelineEvent._({
    this.id,
    required this.employeeId,
    required this.date,
    required this.title,
    required this.description,
    required this.category,
    required this.registeredBy,
    required this.createdAt,
  });

  factory RrhhTimelineEvent({
    int? id,
    required int employeeId,
    required DateTime date,
    required String title,
    required String description,
    required String category,
    required String registeredBy,
    required DateTime createdAt,
  }) = _RrhhTimelineEventImpl;

  factory RrhhTimelineEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhTimelineEvent(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      registeredBy: jsonSerialization['registeredBy'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Empleado al que corresponde el evento.
  int employeeId;

  /// Fecha del suceso.
  DateTime date;

  /// Título del hito (ej: Contratación Inicial, Ascenso, Traslado).
  String title;

  /// Detalle o descripción del hecho.
  String description;

  /// Categoría del evento: 'CONTRATACION', 'ASIGNACION', 'HORARIO', 'PERMISO', 'INCIDENCIA', 'DESVINCULACION'.
  String category;

  /// Usuario o responsable que registró el evento.
  String registeredBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [RrhhTimelineEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhTimelineEvent copyWith({
    int? id,
    int? employeeId,
    DateTime? date,
    String? title,
    String? description,
    String? category,
    String? registeredBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhTimelineEvent',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'date': date.toJson(),
      'title': title,
      'description': description,
      'category': category,
      'registeredBy': registeredBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhTimelineEventImpl extends RrhhTimelineEvent {
  _RrhhTimelineEventImpl({
    int? id,
    required int employeeId,
    required DateTime date,
    required String title,
    required String description,
    required String category,
    required String registeredBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         date: date,
         title: title,
         description: description,
         category: category,
         registeredBy: registeredBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [RrhhTimelineEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhTimelineEvent copyWith({
    Object? id = _Undefined,
    int? employeeId,
    DateTime? date,
    String? title,
    String? description,
    String? category,
    String? registeredBy,
    DateTime? createdAt,
  }) {
    return RrhhTimelineEvent(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      registeredBy: registeredBy ?? this.registeredBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
